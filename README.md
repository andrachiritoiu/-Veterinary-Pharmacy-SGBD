# 🐾 Bază de date – Farmacie Veterinară (Oracle SGBD)

## Descriere generală
Acest proiect constă în proiectarea și implementarea unei baze de date relaționale destinate **gestiunii unei farmacii veterinare**, realizată în cadrul disciplinei **Sisteme de Gestiune a Bazelor de Date (SGBD)** – Anul II.

Baza de date modelează atât **componenta medicală** (animale, consultații, rețete, campanii veterinare), cât și **componenta comercială** (gestiunea stocurilor pe loturi, comenzi, facturi, furnizori), oferind suport pentru interogări complexe și automatizarea proceselor prin **PL/SQL** și **trigger-e**.

---

## Obiectivele proiectului
- proiectarea unei baze de date relaționale normalizate (FN3);
- implementarea completă în **Oracle Database 19c**;
- utilizarea avansată a mecanismelor PL/SQL:
  - colecții (VARRAY, nested table, associative array);
  - cursoare (simple, parametrizate, dinamice);
  - funcții și proceduri stocate;
  - trigger-e LMD (statement & row) și LDD;
  - tratarea erorilor și audit operații.

---

## Tehnologii utilizate
- **SGBD:** Oracle Database 19c  
- **Limbaj:** SQL, PL/SQL  
- **Mediu de dezvoltare:** Oracle SQL Developer  
- **Sistem de operare:** Windows 11 x64  

---

## Structura bazei de date
Baza de date include peste **20 de tabele**, dintre care:

### Entități principale
- `CLIENT`, `ANIMAL`
- `PERSONAL_MEDICAL`, `MEDIC_VETERINAR`, `FARMACIST`
- `MEDICAMENT`, `STOC`
- `COMANDA`, `FACTURA`
- `FURNIZOR`, `CAMPANIE`

### Tabele asociative
- `ARE` – produse vândute în comenzi clienți
- `INCLUDE` – produse comandate de farmacie
- `CONTINE` – medicamente prescrise în rețete
- `INTERVINE` – participări în campanii veterinare
- `VINDE` – relația furnizor–medicament

---

## Diagrame
- **Diagramă Entitate–Relație (ERD)**
- **Diagramă conceptuală**  

---

## Funcționalități implementate
### 🔹 Subprograme PL/SQL
- procedură cu **3 tipuri de colecții** (VARRAY, nested table, associative array);
- procedură cu **2 tipuri de cursoare**, inclusiv cursor parametrizat;
- funcție ce utilizează **3 tabele** într-o singură instrucțiune SQL;
- procedură ce utilizează **5 tabele** și tratează excepții personalizate.

### 🔹 Trigger-e
- trigger **LMD la nivel de comandă** (restricții temporale + audit);
- trigger **LMD la nivel de linie** (actualizare automată stoc);
- trigger **LDD** pentru audit operații DDL și protecția tabelelor critice.

### 🔹 Pachet PL/SQL (cerință opțională)
- tipuri de date complexe;
- funcții și proceduri integrate;
- cursor dinamic;
- raport permanent de reaprovizionare.

---

## Audit & gestionare erori
- `CODURI_EROARE` – catalog de erori personalizate;
- `LOG_EROARE` – logare execuții eșuate (autonomous transaction);
- `AUDIT_OPERATII_LDD` – audit complet pentru CREATE / ALTER / DROP.

---

## Rulare proiect
1. Creează un user dedicat în Oracle.
2. Rulează scripturile SQL în următoarea ordine:
   - creare tabele & secvențe;
   - inserare date;
   - subprograme PL/SQL;
   - trigger-e;
   - pachetul PL/SQL.
3. Activează `SET SERVEROUTPUT ON` pentru vizualizarea rezultatelor.

---

## 📁 Structura proiectului

```text
 proiect-sgbd-farmacie-veterinara
 ┣ 📄 schema.sql
 ┣ 📄 inserturi.sql
 ┣ 📄 subprograme.sql
 ┣ 📄 triggere.sql
 ┣ 📄 pachet.sql
 ┣ 📄 README.md
 ┗ 📄 Proiect_SGBD_Farmacie_Veterinara.docx
```
