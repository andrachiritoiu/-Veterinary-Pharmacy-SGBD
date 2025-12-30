--ex 4
--creare secvente
CREATE SEQUENCE seq_client START WITH 1;
CREATE SEQUENCE seq_animal START WITH 1;

CREATE SEQUENCE seq_personal_medical START WITH 1;
CREATE SEQUENCE seq_campanie START WITH 1;
CREATE SEQUENCE seq_consultatie START WITH 1;
CREATE SEQUENCE seq_reteta START WITH 1;
CREATE SEQUENCE seq_program START WITH 1;

CREATE SEQUENCE seq_medicament START WITH 1;
CREATE SEQUENCE seq_stoc START WITH 1;

CREATE SEQUENCE seq_furnizor START WITH 1;
CREATE SEQUENCE seq_comanda START WITH 1;
CREATE SEQUENCE seq_factura START WITH 1;

CREATE SEQUENCE seq_interventie START WITH 1;



--creare tabele
CREATE TABLE CLIENT (
  id_client INT DEFAULT seq_client.NEXTVAL PRIMARY KEY,
  nume      VARCHAR2(50) NOT NULL,
  prenume   VARCHAR2(50) NOT NULL,
  telefon   VARCHAR2(10) NOT NULL CHECK (REGEXP_LIKE(telefon, '^[0-9]{10}$')),
  email     VARCHAR2(50)
);

CREATE TABLE PERSONAL_MEDICAL (
  id_personal_medical INT DEFAULT seq_personal_medical.NEXTVAL PRIMARY KEY,
  nume               VARCHAR2(50) NOT NULL,
  prenume            VARCHAR2(50) NOT NULL,
  salariu            NUMBER(10,2) NOT NULL CHECK (salariu > 0),
  grad_profesional   VARCHAR2(50),
  data_angajare      DATE NOT NULL
);

CREATE TABLE FARMACIST (
  id_personal_medical INT PRIMARY KEY,
  responsabil_stoc    NUMBER(1) DEFAULT 0 NOT NULL CHECK (responsabil_stoc IN (0,1)),
  FOREIGN KEY (id_personal_medical) REFERENCES PERSONAL_MEDICAL(id_personal_medical)
);

CREATE TABLE MEDIC_VETERINAR (
  id_personal_medical INT PRIMARY KEY,
  specializare        VARCHAR2(50),
  FOREIGN KEY (id_personal_medical) REFERENCES PERSONAL_MEDICAL(id_personal_medical)
);

CREATE TABLE PROGRAM (
  id_program          INT DEFAULT seq_program.NEXTVAL PRIMARY KEY,
  zi_saptamana        VARCHAR2(50) NOT NULL,
  ora_inceput         VARCHAR2(5)  NOT NULL CHECK (REGEXP_LIKE(ora_inceput,'^[0-2][0-9]:[0-5][0-9]$')),
  ora_sfarsit         VARCHAR2(5)  NOT NULL CHECK (REGEXP_LIKE(ora_sfarsit,'^[0-2][0-9]:[0-5][0-9]$')),
  id_personal_medical INT NOT NULL,
  UNIQUE (id_personal_medical, zi_saptamana),
  FOREIGN KEY (id_personal_medical) REFERENCES PERSONAL_MEDICAL(id_personal_medical)
);

CREATE TABLE ANIMAL (
  id_animal INT DEFAULT seq_animal.NEXTVAL PRIMARY KEY,
  nume      VARCHAR2(50) NOT NULL,
  specie    VARCHAR2(50) NOT NULL,
  rasa      VARCHAR2(50),
  id_client INT NOT NULL,
  FOREIGN KEY (id_client) REFERENCES CLIENT(id_client)
);

CREATE TABLE CAMPANIE (
  id_campanie  INT DEFAULT seq_campanie.NEXTVAL PRIMARY KEY,
  nume         VARCHAR2(50) NOT NULL,
  tip          VARCHAR2(50) NOT NULL,
  data_start   DATE NOT NULL,
  data_sfarsit DATE NOT NULL,
  CHECK (data_sfarsit >= data_start)
);

CREATE TABLE CONSULTATIE (
  id_consultatie      INT DEFAULT seq_consultatie.NEXTVAL PRIMARY KEY,
  pret                NUMBER(10,2) NOT NULL CHECK (pret > 0),
  id_animal           INT NOT NULL,
  id_personal_medical INT NOT NULL,
  FOREIGN KEY (id_animal) REFERENCES ANIMAL(id_animal),
  FOREIGN KEY (id_personal_medical) REFERENCES MEDIC_VETERINAR(id_personal_medical)
);

CREATE TABLE RETETA (
  id_reteta           INT DEFAULT seq_reteta.NEXTVAL PRIMARY KEY,
  data_emitere        DATE DEFAULT SYSDATE NOT NULL,
  id_consultatie      INT NOT NULL UNIQUE,
  id_personal_medical INT NOT NULL,
  FOREIGN KEY (id_consultatie) REFERENCES CONSULTATIE(id_consultatie),
  FOREIGN KEY (id_personal_medical) REFERENCES MEDIC_VETERINAR(id_personal_medical)
);

CREATE TABLE MEDICAMENT (
  id_medicament    INT DEFAULT seq_medicament.NEXTVAL PRIMARY KEY,
  substanta_activa VARCHAR2(50) NOT NULL,
  denumire         VARCHAR2(50) NOT NULL,
  producator       VARCHAR2(50) NOT NULL
);

CREATE TABLE STOC (
  id_stoc              INT DEFAULT seq_stoc.NEXTVAL PRIMARY KEY,
  data_expirare        DATE NOT NULL,
  data_fabricatie      DATE,
  nr_bucati_primite    INT NOT NULL CHECK (nr_bucati_primite > 0),
  nr_bucati_ramase     INT NOT NULL CHECK (nr_bucati_ramase >= 0),
  pret_vanzare_curent  NUMBER(10,2) NOT NULL CHECK (pret_vanzare_curent > 0),
  data_aprovizionare   DATE DEFAULT SYSDATE NOT NULL,
  pret_achizitie       NUMBER(10,2) NOT NULL CHECK (pret_achizitie > 0),
  id_medicament        INT NOT NULL,
  CHECK (nr_bucati_ramase <= nr_bucati_primite),
  FOREIGN KEY (id_medicament) REFERENCES MEDICAMENT(id_medicament)
);

CREATE TABLE FURNIZOR (
  id_furnizor INT DEFAULT seq_furnizor.NEXTVAL PRIMARY KEY,
  nume        VARCHAR2(50) NOT NULL,
  adresa      VARCHAR2(50),
  telefon     VARCHAR2(10) NOT NULL CHECK (REGEXP_LIKE(telefon, '^[0-9]{10}$'))
);

CREATE TABLE COMANDA (
  id_comanda          INT DEFAULT seq_comanda.NEXTVAL PRIMARY KEY,
  data_comanda        DATE DEFAULT SYSDATE NOT NULL,
  id_personal_medical INT NOT NULL,
  FOREIGN KEY (id_personal_medical) REFERENCES FARMACIST(id_personal_medical)
);

CREATE TABLE COMANDA_CLIENT (
  id_comanda   INT PRIMARY KEY,
  metoda_plata VARCHAR2(20) NOT NULL CHECK (LOWER(metoda_plata) IN ('cash','card')),
  id_client    INT NOT NULL,
  FOREIGN KEY (id_comanda) REFERENCES COMANDA(id_comanda),
  FOREIGN KEY (id_client) REFERENCES CLIENT(id_client)
);

CREATE TABLE COMANDA_FARMACIE (
  id_comanda     INT PRIMARY KEY,
  termen_livrare DATE,
  id_furnizor    INT NOT NULL,
  FOREIGN KEY (id_comanda) REFERENCES COMANDA(id_comanda),
  FOREIGN KEY (id_furnizor) REFERENCES FURNIZOR(id_furnizor)
);

CREATE TABLE FACTURA (
  id_factura   INT DEFAULT seq_factura.NEXTVAL PRIMARY KEY,
  data_emitere DATE DEFAULT SYSDATE NOT NULL,
  suma         NUMBER(12,2) NOT NULL CHECK (suma > 0),
  id_comanda   INT NOT NULL UNIQUE,
  FOREIGN KEY (id_comanda) REFERENCES COMANDA(id_comanda)
);

CREATE TABLE VINDE (
  id_furnizor   INT NOT NULL,
  id_medicament INT NOT NULL,
  pret_furnizor NUMBER(10,2) NOT NULL CHECK (pret_furnizor > 0),
  PRIMARY KEY (id_furnizor, id_medicament),
  FOREIGN KEY (id_furnizor) REFERENCES FURNIZOR(id_furnizor),
  FOREIGN KEY (id_medicament) REFERENCES MEDICAMENT(id_medicament)
);

CREATE TABLE INCLUDE (
  id_comanda    INT NOT NULL,
  id_medicament INT NOT NULL,
  cantitate     INT NOT NULL CHECK (cantitate > 0),
  PRIMARY KEY (id_comanda, id_medicament),
  FOREIGN KEY (id_comanda) REFERENCES COMANDA_FARMACIE(id_comanda),
  FOREIGN KEY (id_medicament) REFERENCES MEDICAMENT(id_medicament)
);

CREATE TABLE ARE (
  id_comanda         INT NOT NULL,
  id_stoc            INT NOT NULL,
  cantitate          INT NOT NULL CHECK (cantitate > 0),
  pret_vanzare_final NUMBER(10,2) NOT NULL CHECK (pret_vanzare_final > 0),
  discount           NUMBER(5,2) DEFAULT 0 NOT NULL CHECK (discount >= 0 AND discount <= 100),
  PRIMARY KEY (id_comanda, id_stoc),
  FOREIGN KEY (id_comanda) REFERENCES COMANDA_CLIENT(id_comanda),
  FOREIGN KEY (id_stoc) REFERENCES STOC(id_stoc)
);

CREATE TABLE CONTINE (
  id_reteta        INT NOT NULL,
  id_medicament    INT NOT NULL,
  dozaj            VARCHAR2(50),
  mod_administrare VARCHAR2(50),
  frecventa        VARCHAR2(50),
  durata_tratament VARCHAR2(50),
  PRIMARY KEY (id_reteta, id_medicament),
  FOREIGN KEY (id_reteta) REFERENCES RETETA(id_reteta),
  FOREIGN KEY (id_medicament) REFERENCES MEDICAMENT(id_medicament)
);

CREATE TABLE INTERVINE (
  id_interventie      INT DEFAULT seq_interventie.NEXTVAL PRIMARY KEY,
  id_animal           INT NOT NULL,
  id_campanie         INT NOT NULL,
  id_personal_medical INT NOT NULL,
  data_interventiei   DATE DEFAULT SYSDATE NOT NULL,
  observatii          VARCHAR2(200),
  FOREIGN KEY (id_animal) REFERENCES ANIMAL(id_animal),
  FOREIGN KEY (id_campanie) REFERENCES CAMPANIE(id_campanie),
  FOREIGN KEY (id_personal_medical) REFERENCES MEDIC_VETERINAR(id_personal_medical)
);




--ex5.inserarea de date
INSERT INTO CLIENT(nume, prenume, telefon, email) VALUES ('Popescu','Ana','0712345678','ana.popescu@gmail.com');
INSERT INTO CLIENT(nume, prenume, telefon, email) VALUES ('Ionescu','Vlad','0723456789','vlad.ionescu@gmail.com');
INSERT INTO CLIENT(nume, prenume, telefon, email) VALUES ('Dumitru','Andreea','0734567890','andreea.dumitru@yahoo.com');
INSERT INTO CLIENT(nume, prenume, telefon, email) VALUES ('Marin','Mihai','0745678901','mihai.marin@gmail.com');
INSERT INTO CLIENT(nume, prenume, telefon, email) VALUES ('Georgescu','Elena','0756789012','elena.georgescu@yahoo.com');
INSERT INTO CLIENT(nume, prenume, telefon, email) VALUES ('Stan','Radu','0767890123','radu.stan@gmail.com');
INSERT INTO CLIENT(nume, prenume, telefon, email) VALUES ('Ilie','Cristina','0778901234','cristina.ilie@yahoo.com');
INSERT INTO CLIENT(nume, prenume, telefon, email) VALUES ('Toma','Sorin','0789012345','sorin.toma@gmail.com');
INSERT INTO CLIENT(nume, prenume, telefon, email) VALUES ('Petrescu','Ioana','0790123456','ioana.petrescu@gmail.com');
INSERT INTO CLIENT(nume, prenume, telefon, email) VALUES ('Neagu','Daniel','0701234567','daniel.neagu@yahoo.com');


INSERT INTO PERSONAL_MEDICAL(nume, prenume, salariu, grad_profesional, data_angajare)
VALUES ('Vasilescu','Dan',8000,'Dr.',DATE '2020-01-15');
INSERT INTO PERSONAL_MEDICAL(nume, prenume, salariu, grad_profesional, data_angajare)
VALUES ('Marinescu','Laura',7500,'Dr.',DATE '2019-03-10');
INSERT INTO PERSONAL_MEDICAL(nume, prenume, salariu, grad_profesional, data_angajare)
VALUES ('Stoica','Radu',6000,'Farm.',DATE '2021-05-20');
INSERT INTO PERSONAL_MEDICAL(nume, prenume, salariu, grad_profesional, data_angajare)
VALUES ('Popa','Carmen',5500,'Farm.',DATE '2022-02-14');
INSERT INTO PERSONAL_MEDICAL(nume, prenume, salariu, grad_profesional, data_angajare)
VALUES ('Tudor','Bogdan',7800,'Dr.',DATE '2018-09-05');
INSERT INTO PERSONAL_MEDICAL(nume, prenume, salariu, grad_profesional, data_angajare)
VALUES ('Munteanu','Diana',5800,'Farm.',DATE '2023-01-10');
INSERT INTO PERSONAL_MEDICAL(nume, prenume, salariu, grad_profesional, data_angajare)
VALUES ('Ionescu','Adrian',7200,'Dr.',DATE '2021-11-08');
INSERT INTO PERSONAL_MEDICAL(nume, prenume, salariu, grad_profesional, data_angajare)
VALUES ('Georgescu','Mihaela',6200,'Farm.',DATE '2020-07-22');
INSERT INTO PERSONAL_MEDICAL(nume, prenume, salariu, grad_profesional, data_angajare)
VALUES ('Popescu','Gabriel',8200,'Dr.',DATE '2017-04-12');
INSERT INTO PERSONAL_MEDICAL(nume, prenume, salariu, grad_profesional, data_angajare)
VALUES ('Dinu','Andreea',5900,'Farm.',DATE '2022-09-03');


INSERT INTO MEDIC_VETERINAR (id_personal_medical, specializare) VALUES (1,'Chirurgie');
INSERT INTO MEDIC_VETERINAR (id_personal_medical, specializare) VALUES (2,'Dermatologie');
INSERT INTO MEDIC_VETERINAR (id_personal_medical, specializare) VALUES (5,'Medicina interna');
INSERT INTO MEDIC_VETERINAR (id_personal_medical, specializare) VALUES (7,'Cardiologie');
INSERT INTO MEDIC_VETERINAR (id_personal_medical, specializare) VALUES (9,'Oncologie');


INSERT INTO FARMACIST (id_personal_medical, responsabil_stoc) VALUES (3,1);
INSERT INTO FARMACIST (id_personal_medical, responsabil_stoc) VALUES (4,0);
INSERT INTO FARMACIST (id_personal_medical, responsabil_stoc) VALUES (6,1);
INSERT INTO FARMACIST (id_personal_medical, responsabil_stoc) VALUES (8,0);
INSERT INTO FARMACIST (id_personal_medical, responsabil_stoc) VALUES (10,1);



INSERT INTO PROGRAM (zi_saptamana, ora_inceput, ora_sfarsit, id_personal_medical) VALUES ('Luni','08:00','16:00',1);
INSERT INTO PROGRAM (zi_saptamana, ora_inceput, ora_sfarsit, id_personal_medical) VALUES ('Marti','08:00','16:00',1);
INSERT INTO PROGRAM (zi_saptamana, ora_inceput, ora_sfarsit, id_personal_medical) VALUES ('Marti','09:00','17:00',2);
INSERT INTO PROGRAM (zi_saptamana, ora_inceput, ora_sfarsit, id_personal_medical) VALUES ('Miercuri','09:00','17:00',2);
INSERT INTO PROGRAM (zi_saptamana, ora_inceput, ora_sfarsit, id_personal_medical) VALUES ('Miercuri','10:00','18:00',3);
INSERT INTO PROGRAM (zi_saptamana, ora_inceput, ora_sfarsit, id_personal_medical) VALUES ('Joi','10:00','18:00',4);
INSERT INTO PROGRAM (zi_saptamana, ora_inceput, ora_sfarsit, id_personal_medical) VALUES ('Vineri','10:00','18:00',4);
INSERT INTO PROGRAM (zi_saptamana, ora_inceput, ora_sfarsit, id_personal_medical) VALUES ('Vineri','08:00','16:00',5);
INSERT INTO PROGRAM (zi_saptamana, ora_inceput, ora_sfarsit, id_personal_medical) VALUES ('Sambata','08:00','12:00',5);
INSERT INTO PROGRAM (zi_saptamana, ora_inceput, ora_sfarsit, id_personal_medical) VALUES ('Sambata','10:00','14:00',6);
INSERT INTO PROGRAM (zi_saptamana, ora_inceput, ora_sfarsit, id_personal_medical) VALUES ('Vineri','10:00','14:00',6);
INSERT INTO PROGRAM (zi_saptamana, ora_inceput, ora_sfarsit, id_personal_medical) VALUES ('Luni','12:00','20:00',7);
INSERT INTO PROGRAM (zi_saptamana, ora_inceput, ora_sfarsit, id_personal_medical) VALUES ('Marti','12:00','20:00',8);
INSERT INTO PROGRAM (zi_saptamana, ora_inceput, ora_sfarsit, id_personal_medical) VALUES ('Miercuri','09:00','17:00',9);
INSERT INTO PROGRAM (zi_saptamana, ora_inceput, ora_sfarsit, id_personal_medical) VALUES ('Joi','12:00','20:00',10);
INSERT INTO PROGRAM (zi_saptamana, ora_inceput, ora_sfarsit, id_personal_medical) VALUES ('Luni','09:00','17:00',10);


INSERT INTO ANIMAL (nume, specie, rasa, id_client) VALUES ('Rex','Caine','Labrador',1);
INSERT INTO ANIMAL (nume, specie, rasa, id_client) VALUES ('Mia','Pisica','Persana',2);
INSERT INTO ANIMAL (nume, specie, rasa, id_client) VALUES ('Max','Caine','Ciobanesc german',3);
INSERT INTO ANIMAL (nume, specie, rasa, id_client) VALUES ('Luna','Pisica','Siameza',4);
INSERT INTO ANIMAL (nume, specie, rasa, id_client) VALUES ('Buddy','Caine','Golden Retriever',5);
INSERT INTO ANIMAL (nume, specie, rasa, id_client) VALUES ('Kira','Caine','Beagle',6);
INSERT INTO ANIMAL (nume, specie, rasa, id_client) VALUES ('Oscar','Pisica','Europeana',7);
INSERT INTO ANIMAL (nume, specie, rasa, id_client) VALUES ('Toby','Caine','Pug',8);
INSERT INTO ANIMAL (nume, specie, rasa, id_client) VALUES ('Bella','Pisica','Maine Coon',9);
INSERT INTO ANIMAL (nume, specie, rasa, id_client) VALUES ('Simba','Pisica','Bengaleza',10);
INSERT INTO ANIMAL (nume, specie, rasa, id_client) VALUES ('Coco','Caine','Bichon',1);
INSERT INTO ANIMAL (nume, specie, rasa, id_client) VALUES ('Nala','Pisica','British Shorthair',2);



INSERT INTO CAMPANIE (nume, tip, data_start, data_sfarsit)
VALUES ('Vaccinare antirabica','Vaccinare',DATE '2025-01-10',DATE '2025-02-10');

INSERT INTO CAMPANIE (nume, tip, data_start, data_sfarsit)
VALUES ('Deparazitare gratuita','Preventie',DATE '2025-03-01',DATE '2025-03-31');

INSERT INTO CAMPANIE (nume, tip, data_start, data_sfarsit)
VALUES ('Sterilizare','Chirurgie',DATE '2025-04-01',DATE '2025-04-30');

INSERT INTO CAMPANIE (nume, tip, data_start, data_sfarsit)
VALUES ('Control cardiologic','Diagnostic',DATE '2025-05-01',DATE '2025-05-31');

INSERT INTO CAMPANIE (nume, tip, data_start, data_sfarsit)
VALUES ('Vaccinare polivalenta','Vaccinare',DATE '2025-09-01',DATE '2025-10-31');

INSERT INTO CAMPANIE (nume, tip, data_start, data_sfarsit)
VALUES ('Campanie antiparazitare','Preventie',DATE '2025-06-01',DATE '2025-06-30');

INSERT INTO CAMPANIE (nume, tip, data_start, data_sfarsit)
VALUES ('Consultatii gratuite junior','Preventie',DATE '2025-07-01',DATE '2025-07-31');



INSERT INTO MEDICAMENT (substanta_activa, denumire, producator) VALUES ('Amoxicilina','Amoxivet','VetPharma');
INSERT INTO MEDICAMENT (substanta_activa, denumire, producator) VALUES ('Meloxicam','Meloxivet','AnimalHealth');
INSERT INTO MEDICAMENT (substanta_activa, denumire, producator) VALUES ('Fipronil','Frontline','Boehringer');
INSERT INTO MEDICAMENT (substanta_activa, denumire, producator) VALUES ('Ivermectina','Ivomec','Merial');
INSERT INTO MEDICAMENT (substanta_activa, denumire, producator) VALUES ('Dexametazona','Dexavet','VetMedica');
INSERT INTO MEDICAMENT (substanta_activa, denumire, producator) VALUES ('Enrofloxacina','Baytril','Bayer');
INSERT INTO MEDICAMENT (substanta_activa, denumire, producator) VALUES ('Maropitant','Cerenia','Zoetis');
INSERT INTO MEDICAMENT (substanta_activa, denumire, producator) VALUES ('Carprofen','Rimadyl','Zoetis');
INSERT INTO MEDICAMENT (substanta_activa, denumire, producator) VALUES ('Prednison','Prednicort','KRKA');
INSERT INTO MEDICAMENT (substanta_activa, denumire, producator) VALUES ('Clotrimazol','Clotrivet','VetPharma');


INSERT INTO FURNIZOR (nume, adresa, telefon) VALUES ('VetPharma Distribution','Bucuresti','0213456789');
INSERT INTO FURNIZOR (nume, adresa, telefon) VALUES ('AnimalHealth Supply','Cluj','0264567890');
INSERT INTO FURNIZOR (nume, adresa, telefon) VALUES ('MedVet Solutions','Timisoara','0256678901');
INSERT INTO FURNIZOR (nume, adresa, telefon) VALUES ('PetCare Logistics','Bucuresti','0212789012');
INSERT INTO FURNIZOR (nume, adresa, telefon) VALUES ('VetMed Import','Constanta','0241890123');
INSERT INTO FURNIZOR (nume, adresa, telefon) VALUES ('EuroVet Trade','Iasi','0232123456');


INSERT INTO STOC (data_expirare, data_fabricatie, nr_bucati_primite, nr_bucati_ramase, pret_vanzare_curent, data_aprovizionare, pret_achizitie, id_medicament)
VALUES (DATE '2026-12-31', DATE '2025-01-10', 100, 80, 30, DATE '2025-02-01', 20, 1);

INSERT INTO STOC (data_expirare, data_fabricatie, nr_bucati_primite, nr_bucati_ramase, pret_vanzare_curent, data_aprovizionare, pret_achizitie, id_medicament)
VALUES (DATE '2027-01-31', DATE '2025-06-01', 120, 120, 35, DATE '2025-06-10', 22, 1);

INSERT INTO STOC (data_expirare, data_fabricatie, nr_bucati_primite, nr_bucati_ramase, pret_vanzare_curent, data_aprovizionare, pret_achizitie, id_medicament)
VALUES (DATE '2026-06-30', DATE '2025-02-10', 50, 35, 55, DATE '2025-02-15', 40, 2);

INSERT INTO STOC (data_expirare, data_fabricatie, nr_bucati_primite, nr_bucati_ramase, pret_vanzare_curent, data_aprovizionare, pret_achizitie, id_medicament)
VALUES (DATE '2025-08-31', DATE '2025-01-05', 80, 60, 45, DATE '2025-02-20', 30, 3);

INSERT INTO STOC (data_expirare, data_fabricatie, nr_bucati_primite, nr_bucati_ramase, pret_vanzare_curent, data_aprovizionare, pret_achizitie, id_medicament)
VALUES (DATE '2025-11-30', DATE '2025-03-01', 60, 40, 65, DATE '2025-03-05', 50, 4);

INSERT INTO STOC (data_expirare, data_fabricatie, nr_bucati_primite, nr_bucati_ramase, pret_vanzare_curent, data_aprovizionare, pret_achizitie, id_medicament)
VALUES (DATE '2026-01-31', DATE '2025-02-20', 40, 25, 40, DATE '2025-03-10', 27, 5);

INSERT INTO STOC (data_expirare, data_fabricatie, nr_bucati_primite, nr_bucati_ramase, pret_vanzare_curent, data_aprovizionare, pret_achizitie, id_medicament)
VALUES (DATE '2026-10-31', DATE '2025-04-10', 70, 55, 60, DATE '2025-04-20', 45, 6);

INSERT INTO STOC (data_expirare, data_fabricatie, nr_bucati_primite, nr_bucati_ramase, pret_vanzare_curent, data_aprovizionare, pret_achizitie, id_medicament)
VALUES (DATE '2026-09-30', DATE '2025-03-15', 30, 22, 95, DATE '2025-04-01', 75, 7);

INSERT INTO STOC (data_expirare, data_fabricatie, nr_bucati_primite, nr_bucati_ramase, pret_vanzare_curent, data_aprovizionare, pret_achizitie, id_medicament)
VALUES (DATE '2027-03-31', DATE '2025-05-05', 90, 90, 85, DATE '2025-05-10', 62, 8);

INSERT INTO STOC (data_expirare, data_fabricatie, nr_bucati_primite, nr_bucati_ramase, pret_vanzare_curent, data_aprovizionare, pret_achizitie, id_medicament)
VALUES (DATE '2026-04-30', DATE '2025-02-01', 60, 48, 25, DATE '2025-02-12', 15, 9);

INSERT INTO STOC (data_expirare, data_fabricatie, nr_bucati_primite, nr_bucati_ramase, pret_vanzare_curent, data_aprovizionare, pret_achizitie, id_medicament)
VALUES (DATE '2026-07-31', DATE '2025-03-01', 50, 50, 28, DATE '2025-03-15', 18, 10);

INSERT INTO STOC (data_expirare, data_fabricatie, nr_bucati_primite, nr_bucati_ramase, pret_vanzare_curent, data_aprovizionare, pret_achizitie, id_medicament)
VALUES (DATE '2027-06-30', DATE '2025-07-01', 70, 70, 58, DATE '2025-07-10', 42, 2);



INSERT INTO CONSULTATIE (pret, id_animal, id_personal_medical) VALUES (150,1,1);
INSERT INTO CONSULTATIE (pret, id_animal, id_personal_medical) VALUES (200,2,2);
INSERT INTO CONSULTATIE (pret, id_animal, id_personal_medical) VALUES (180,3,1);
INSERT INTO CONSULTATIE (pret, id_animal, id_personal_medical) VALUES (220,4,5);
INSERT INTO CONSULTATIE (pret, id_animal, id_personal_medical) VALUES (170,5,2);
INSERT INTO CONSULTATIE (pret, id_animal, id_personal_medical) VALUES (140,6,2);
INSERT INTO CONSULTATIE (pret, id_animal, id_personal_medical) VALUES (160,7,1);
INSERT INTO CONSULTATIE (pret, id_animal, id_personal_medical) VALUES (155,8,7);
INSERT INTO CONSULTATIE (pret, id_animal, id_personal_medical) VALUES (190,9,5);
INSERT INTO CONSULTATIE (pret, id_animal, id_personal_medical) VALUES (175,10,2);


INSERT INTO RETETA (data_emitere, id_consultatie, id_personal_medical) VALUES (DATE '2025-03-10',1,1);
INSERT INTO RETETA (data_emitere, id_consultatie, id_personal_medical) VALUES (DATE '2025-03-12',2,2);
INSERT INTO RETETA (data_emitere, id_consultatie, id_personal_medical) VALUES (DATE '2025-03-15',3,1);
INSERT INTO RETETA (data_emitere, id_consultatie, id_personal_medical) VALUES (DATE '2025-03-20',4,5);
INSERT INTO RETETA (data_emitere, id_consultatie, id_personal_medical) VALUES (DATE '2025-03-22',5,2);
INSERT INTO RETETA (data_emitere, id_consultatie, id_personal_medical) VALUES (DATE '2025-04-01',6,2);
INSERT INTO RETETA (data_emitere, id_consultatie, id_personal_medical) VALUES (DATE '2025-04-03',7,1);
INSERT INTO RETETA (data_emitere, id_consultatie, id_personal_medical) VALUES (DATE '2025-04-05',8,7);


INSERT INTO COMANDA (data_comanda, id_personal_medical) VALUES (DATE '2025-04-01',3);
INSERT INTO COMANDA (data_comanda, id_personal_medical) VALUES (DATE '2025-04-02',4);
INSERT INTO COMANDA (data_comanda, id_personal_medical) VALUES (DATE '2025-04-03',6);
INSERT INTO COMANDA (data_comanda, id_personal_medical) VALUES (DATE '2025-04-04',3);
INSERT INTO COMANDA (data_comanda, id_personal_medical) VALUES (DATE '2025-04-05',10);
INSERT INTO COMANDA (data_comanda, id_personal_medical) VALUES (DATE '2025-04-06',4);
INSERT INTO COMANDA (data_comanda, id_personal_medical) VALUES (DATE '2025-04-07',6);
INSERT INTO COMANDA (data_comanda, id_personal_medical) VALUES (DATE '2025-04-08',3);
INSERT INTO COMANDA (data_comanda, id_personal_medical) VALUES (DATE '2025-04-09',10);
INSERT INTO COMANDA (data_comanda, id_personal_medical) VALUES (DATE '2025-04-10',4);
INSERT INTO COMANDA (data_comanda, id_personal_medical) VALUES (DATE '2025-04-11',6);
INSERT INTO COMANDA (data_comanda, id_personal_medical) VALUES (DATE '2025-04-12',3);
INSERT INTO COMANDA (data_comanda, id_personal_medical) VALUES (DATE '2025-05-01',3);
INSERT INTO COMANDA (data_comanda, id_personal_medical) VALUES (DATE '2025-05-03',4);
INSERT INTO COMANDA (data_comanda, id_personal_medical) VALUES (DATE '2025-05-05',6);
INSERT INTO COMANDA (data_comanda, id_personal_medical) VALUES (DATE '2025-06-01',3);
INSERT INTO COMANDA (data_comanda, id_personal_medical) VALUES (DATE '2025-06-10',4);


INSERT INTO COMANDA_CLIENT VALUES (1,'card',1);
INSERT INTO COMANDA_CLIENT VALUES (2,'cash',2);
INSERT INTO COMANDA_CLIENT VALUES (3,'card',3);
INSERT INTO COMANDA_CLIENT VALUES (4,'cash',4);
INSERT INTO COMANDA_CLIENT VALUES (5,'card',5);
INSERT INTO COMANDA_CLIENT VALUES (6,'cash',6);
INSERT INTO COMANDA_CLIENT VALUES (7,'card',7);
INSERT INTO COMANDA_CLIENT VALUES (8,'cash',8);
INSERT INTO COMANDA_CLIENT VALUES (9,'card',9);
INSERT INTO COMANDA_CLIENT VALUES (10,'cash',10);
INSERT INTO COMANDA_CLIENT VALUES (11,'card',1);
INSERT INTO COMANDA_CLIENT VALUES (12,'cash',2);


INSERT INTO COMANDA_FARMACIE VALUES (13, DATE '2025-05-10', 1);
INSERT INTO COMANDA_FARMACIE VALUES (14, DATE '2025-05-12', 2);
INSERT INTO COMANDA_FARMACIE VALUES (15, DATE '2025-05-15', 3);
INSERT INTO COMANDA_FARMACIE VALUES (16, DATE '2025-06-08', 6);
INSERT INTO COMANDA_FARMACIE VALUES (17, DATE '2025-06-18', 5);


INSERT INTO FACTURA (data_emitere, suma, id_comanda) VALUES (DATE '2025-04-01',120,1);
INSERT INTO FACTURA (data_emitere, suma, id_comanda) VALUES (DATE '2025-04-02', 90,2);
INSERT INTO FACTURA (data_emitere, suma, id_comanda) VALUES (DATE '2025-04-03',140,3);
INSERT INTO FACTURA (data_emitere, suma, id_comanda) VALUES (DATE '2025-04-04',160,4);
INSERT INTO FACTURA (data_emitere, suma, id_comanda) VALUES (DATE '2025-04-05',130,5);
INSERT INTO FACTURA (data_emitere, suma, id_comanda) VALUES (DATE '2025-04-06',100,6);
INSERT INTO FACTURA (data_emitere, suma, id_comanda) VALUES (DATE '2025-04-07',115,7);
INSERT INTO FACTURA (data_emitere, suma, id_comanda) VALUES (DATE '2025-04-08',125,8);
INSERT INTO FACTURA (data_emitere, suma, id_comanda) VALUES (DATE '2025-04-09',140,9);
INSERT INTO FACTURA (data_emitere, suma, id_comanda) VALUES (DATE '2025-04-10',110,10);
INSERT INTO FACTURA (data_emitere, suma, id_comanda) VALUES (DATE '2025-04-11', 85,11);
INSERT INTO FACTURA (data_emitere, suma, id_comanda) VALUES (DATE '2025-04-12', 95,12);
INSERT INTO FACTURA (data_emitere, suma, id_comanda) VALUES (DATE '2025-05-01',900,13);
INSERT INTO FACTURA (data_emitere, suma, id_comanda) VALUES (DATE '2025-05-03',620,14);
INSERT INTO FACTURA (data_emitere, suma, id_comanda) VALUES (DATE '2025-05-05',480,15);
INSERT INTO FACTURA (data_emitere, suma, id_comanda) VALUES (DATE '2025-06-01',700,16);
INSERT INTO FACTURA (data_emitere, suma, id_comanda) VALUES (DATE '2025-06-10',560,17);


--tabele asociative
INSERT INTO VINDE VALUES (1,1,20);
INSERT INTO VINDE VALUES (1,10,18);
INSERT INTO VINDE VALUES (1,5,27);

INSERT INTO VINDE VALUES (2,2,40);
INSERT INTO VINDE VALUES (2,8,62);
INSERT INTO VINDE VALUES (2,9,15);

INSERT INTO VINDE VALUES (3,6,45);
INSERT INTO VINDE VALUES (3,7,75);
INSERT INTO VINDE VALUES (3,4,50);

INSERT INTO VINDE VALUES (4,3,30);
INSERT INTO VINDE VALUES (4,2,42);
INSERT INTO VINDE VALUES (4,1,22);

INSERT INTO VINDE VALUES (5,4,48);
INSERT INTO VINDE VALUES (5,3,33);
INSERT INTO VINDE VALUES (5,6,44);

INSERT INTO VINDE VALUES (6,8,63);
INSERT INTO VINDE VALUES (6,7,74);
INSERT INTO VINDE VALUES (6,9,14);
INSERT INTO VINDE VALUES (6,1,21);
INSERT INTO VINDE VALUES (6,5,26);




INSERT INTO CONTINE (id_reteta, id_medicament, dozaj, mod_administrare, frecventa, durata_tratament)
VALUES (1, 1, '1 cp', 'oral', '2/zi', '7 zile');

INSERT INTO CONTINE (id_reteta, id_medicament, dozaj, mod_administrare, frecventa, durata_tratament)
VALUES (1, 2, '1 cp', 'oral', '1/zi', '5 zile');

INSERT INTO CONTINE (id_reteta, id_medicament, dozaj, mod_administrare, frecventa, durata_tratament)
VALUES (2, 3, '1 pipeta', 'topic', 'o data', '1 zi');

INSERT INTO CONTINE (id_reteta, id_medicament, dozaj, mod_administrare, frecventa, durata_tratament)
VALUES (2, 10, 'aplicare locala', 'topic', '2/zi', '7 zile');

INSERT INTO CONTINE (id_reteta, id_medicament, dozaj, mod_administrare, frecventa, durata_tratament)
VALUES (2, 9, '1 cp', 'oral', '1/zi', '5 zile');

INSERT INTO CONTINE (id_reteta, id_medicament, dozaj, mod_administrare, frecventa, durata_tratament)
VALUES (3, 6, '1 cp', 'oral', '2/zi', '7 zile');

INSERT INTO CONTINE (id_reteta, id_medicament, dozaj, mod_administrare, frecventa, durata_tratament)
VALUES (3, 5, '0.5 ml', 'injectabil', 'o data', '1 zi');

INSERT INTO CONTINE (id_reteta, id_medicament, dozaj, mod_administrare, frecventa, durata_tratament)
VALUES (4, 7, '1 cp', 'oral', '1/zi', '3 zile');

INSERT INTO CONTINE (id_reteta, id_medicament, dozaj, mod_administrare, frecventa, durata_tratament)
VALUES (4, 2, '1 cp', 'oral', '1/zi', '5 zile');

INSERT INTO CONTINE (id_reteta, id_medicament, dozaj, mod_administrare, frecventa, durata_tratament)
VALUES (5, 8, '1 cp', 'oral', '2/zi', '7 zile');

INSERT INTO CONTINE (id_reteta, id_medicament, dozaj, mod_administrare, frecventa, durata_tratament)
VALUES (5, 1, '1 cp', 'oral', '2/zi', '5 zile');

INSERT INTO CONTINE (id_reteta, id_medicament, dozaj, mod_administrare, frecventa, durata_tratament)
VALUES (6, 4, '1 ml', 'injectabil', 'o data', '1 zi');

INSERT INTO CONTINE (id_reteta, id_medicament, dozaj, mod_administrare, frecventa, durata_tratament)
VALUES (6, 2, '1 cp', 'oral', '1/zi', '5 zile');

INSERT INTO CONTINE (id_reteta, id_medicament, dozaj, mod_administrare, frecventa, durata_tratament)
VALUES (7, 1, '1 cp', 'oral', '2/zi', '7 zile');

INSERT INTO CONTINE (id_reteta, id_medicament, dozaj, mod_administrare, frecventa, durata_tratament)
VALUES (8, 6, '1 cp', 'oral', '2/zi', '7 zile');



INSERT INTO ARE (id_comanda, id_stoc, cantitate, pret_vanzare_final, discount)
VALUES (1, 1, 2, 30, 0);

INSERT INTO ARE (id_comanda, id_stoc, cantitate, pret_vanzare_final, discount)
VALUES (2, 4, 1, 45, 0);

INSERT INTO ARE (id_comanda, id_stoc, cantitate, pret_vanzare_final, discount)
VALUES (2, 6, 1, 40, 5);

INSERT INTO ARE (id_comanda, id_stoc, cantitate, pret_vanzare_final, discount)
VALUES (3, 7, 1, 60, 0);

INSERT INTO ARE (id_comanda, id_stoc, cantitate, pret_vanzare_final, discount)
VALUES (3, 10, 2, 25, 10);

INSERT INTO ARE (id_comanda, id_stoc, cantitate, pret_vanzare_final, discount)
VALUES (3, 3, 1, 55, 0);

INSERT INTO ARE (id_comanda, id_stoc, cantitate, pret_vanzare_final, discount)
VALUES (4, 8, 1, 95, 0);

INSERT INTO ARE (id_comanda, id_stoc, cantitate, pret_vanzare_final, discount)
VALUES (4, 11, 1, 28, 0);

INSERT INTO ARE (id_comanda, id_stoc, cantitate, pret_vanzare_final, discount)
VALUES (4, 2, 1, 35, 5);

INSERT INTO ARE (id_comanda, id_stoc, cantitate, pret_vanzare_final, discount)
VALUES (4, 5, 1, 65, 0);

INSERT INTO ARE (id_comanda, id_stoc, cantitate, pret_vanzare_final, discount)
VALUES (5, 9, 1, 85, 0);

INSERT INTO ARE (id_comanda, id_stoc, cantitate, pret_vanzare_final, discount)
VALUES (5, 1, 1, 30, 0);

INSERT INTO ARE (id_comanda, id_stoc, cantitate, pret_vanzare_final, discount)
VALUES (6, 12, 1, 58, 0);

INSERT INTO ARE (id_comanda, id_stoc, cantitate, pret_vanzare_final, discount)
VALUES (7, 4, 1, 45, 0);

INSERT INTO ARE (id_comanda, id_stoc, cantitate, pret_vanzare_final, discount)
VALUES (7, 10, 1, 25, 0);

INSERT INTO ARE (id_comanda, id_stoc, cantitate, pret_vanzare_final, discount)
VALUES (7, 6, 1, 40, 5);

INSERT INTO ARE (id_comanda, id_stoc, cantitate, pret_vanzare_final, discount)
VALUES (8, 3, 1, 55, 0);

INSERT INTO ARE (id_comanda, id_stoc, cantitate, pret_vanzare_final, discount)
VALUES (9, 7, 1, 60, 0);

INSERT INTO ARE (id_comanda, id_stoc, cantitate, pret_vanzare_final, discount)
VALUES (9, 6, 1, 40, 0);

INSERT INTO ARE (id_comanda, id_stoc, cantitate, pret_vanzare_final, discount)
VALUES (10, 11, 1, 28, 0);

INSERT INTO ARE (id_comanda, id_stoc, cantitate, pret_vanzare_final, discount)
VALUES (11, 2, 1, 35, 0);

INSERT INTO ARE (id_comanda, id_stoc, cantitate, pret_vanzare_final, discount)
VALUES (11, 1, 1, 30, 10);

INSERT INTO ARE (id_comanda, id_stoc, cantitate, pret_vanzare_final, discount)
VALUES (12, 5, 1, 65, 0);




INSERT INTO INTERVINE (id_animal, id_campanie, id_personal_medical, data_interventiei, observatii)
VALUES (1, 1, 1, DATE '2025-01-20', 'Vaccinare efectuata');

INSERT INTO INTERVINE (id_animal, id_campanie, id_personal_medical, data_interventiei, observatii)
VALUES (2, 1, 2, DATE '2025-01-22', 'Vaccinare efectuata');

INSERT INTO INTERVINE (id_animal, id_campanie, id_personal_medical, data_interventiei, observatii)
VALUES (3, 2, 1, DATE '2025-03-10', 'Deparazitare interna');

INSERT INTO INTERVINE (id_animal, id_campanie, id_personal_medical, data_interventiei, observatii)
VALUES (4, 2, 2, DATE '2025-03-12', 'Deparazitare externa');

INSERT INTO INTERVINE (id_animal, id_campanie, id_personal_medical, data_interventiei, observatii)
VALUES (5, 3, 1, DATE '2025-04-05', 'Programare sterilizare');

INSERT INTO INTERVINE (id_animal, id_campanie, id_personal_medical, data_interventiei, observatii)
VALUES (6, 4, 5, DATE '2025-05-08', 'Control efectuat');

INSERT INTO INTERVINE (id_animal, id_campanie, id_personal_medical, data_interventiei, observatii)
VALUES (7, 4, 5, DATE '2025-05-10', 'Control efectuat');

INSERT INTO INTERVINE (id_animal, id_campanie, id_personal_medical, data_interventiei, observatii)
VALUES (8, 5, 2, DATE '2025-09-15', 'Vaccinare polivalenta');

INSERT INTO INTERVINE (id_animal, id_campanie, id_personal_medical, data_interventiei, observatii)
VALUES (9, 5, 1, DATE '2025-09-20', 'Vaccinare polivalenta');

INSERT INTO INTERVINE (id_animal, id_campanie, id_personal_medical, data_interventiei, observatii)
VALUES (10, 6, 7, DATE '2025-06-12', 'Tratament antiparazitar');

INSERT INTO INTERVINE (id_animal, id_campanie, id_personal_medical, data_interventiei, observatii)
VALUES (11, 6, 7, DATE '2025-06-18', 'Preventie');

INSERT INTO INTERVINE (id_animal, id_campanie, id_personal_medical, data_interventiei, observatii)
VALUES (12, 7, 2, DATE '2025-07-05', 'Consultatie junior');

INSERT INTO INTERVINE (id_animal, id_campanie, id_personal_medical, data_interventiei, observatii)
VALUES (1, 7, 1, DATE '2025-07-08', 'Consultatie preventie');

INSERT INTO INTERVINE (id_animal, id_campanie, id_personal_medical, data_interventiei, observatii)
VALUES (2, 6, 7, DATE '2025-06-20', 'Preventie');

INSERT INTO INTERVINE (id_animal, id_campanie, id_personal_medical, data_interventiei, observatii)
VALUES (5, 1, 2, DATE '2025-02-01', 'Rapel antirabic');




INSERT INTO INCLUDE VALUES (13,1,60);
INSERT INTO INCLUDE VALUES (13,10,40);
INSERT INTO INCLUDE VALUES (13,5,30);

INSERT INTO INCLUDE VALUES (14,2,50);
INSERT INTO INCLUDE VALUES (14,8,25);
INSERT INTO INCLUDE VALUES (14,9,80);

INSERT INTO INCLUDE VALUES (15,6,40);
INSERT INTO INCLUDE VALUES (15,7,20);
INSERT INTO INCLUDE VALUES (15,4,35);

INSERT INTO INCLUDE VALUES (16,8,30);
INSERT INTO INCLUDE VALUES (16,7,25);
INSERT INTO INCLUDE VALUES (16,1,70);

INSERT INTO INCLUDE VALUES (17,3,55);
INSERT INTO INCLUDE VALUES (17,6,35);
INSERT INTO INCLUDE VALUES (17,2,40);

COMMIT;

