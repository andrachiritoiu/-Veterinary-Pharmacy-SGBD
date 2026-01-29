> 🇷🇴 Romanian version available: [README.md](README.md)

# 🐾 Veterinary Pharmacy – Database Management System (Oracle)

The database accurately models the real-world activity of a **veterinary pharmacy**, integrating:
- the **medical component** (animals, consultations, prescriptions, veterinary campaigns);
- the **commercial component** (batch-based stock management, sales, supplier orders, invoices).

The project focuses on **data consistency**, **business rules**, **process automation**, and advanced usage of **PL/SQL mechanisms** provided by Oracle.

---

## Project Objectives
- design of a normalized relational model (3NF);
- full implementation in **Oracle Database 19c**;
- advanced usage of **SQL and PL/SQL**;
- implementation of mechanisms for:
  - audit;
  - error handling;
  - automation through triggers;
  - complex reports using PL/SQL packages.

---

## Technologies Used
- **DBMS:** Oracle Database 19c  
- **Language:** SQL, PL/SQL  
- **Development environment:** Oracle SQL Developer  
- **Operating system:** Windows 11 x64  

---

## Database Structure

### 🔹 Main Entities
- `CLIENT`, `ANIMAL`
- `PERSONAL_MEDICAL`, `MEDIC_VETERINAR`, `FARMACIST`
- `MEDICAMENT`, `STOC`
- `COMANDA`, `FACTURA`
- `FURNIZOR`, `CAMPANIE`

### 🔹 Associative Tables
- `ARE` – products sold in client orders
- `INCLUDE` – products ordered by the pharmacy
- `CONTINE` – medications prescribed in prescriptions
- `INTERVINE` – participations in veterinary campaigns
- `VINDE` – supplier–medication relationship

---

## Data Modeling

### Entity–Relationship Diagram (ERD)
<p align="center">
  <img src="diagrama ER.png" alt="Entity–Relationship Diagram" width="700"/>
</p>
📄 [PDF version](Diagrama farmacie SGBD.pdf)

---

### Conceptual Diagram
<p align="center">
  <img src="diagrama conceptuala.jpg" alt="Conceptual Diagram" width="700"/>
</p>
📄 [PDF version](Diagrama conceptuala.pdf)

---

## Implemented Functionalities

### 🔸 PL/SQL Subprograms
- a procedure that uses **all three types of collections**:
  - VARRAY
  - Nested Table
  - Associative Array
- a procedure with **two types of cursors**, including a dependent parameterized cursor;
- a function that uses **three tables within a single SQL statement**, with full exception handling;
- a complex procedure that uses **five tables** and implements **custom exceptions**.

---

### 🔸 Triggers
- **Statement-level DML trigger**
  - restricts invoice operations outside business hours;
  - forbids modifications on non-working days;
  - logs unauthorized attempts.
- **Row-level DML trigger (compound trigger)**
  - automatically updates stock when invoices are issued or deleted;
  - handles client orders and supplier orders differently;
  - prevents *mutating table* errors.
- **DDL trigger**
  - audits all DDL operations (CREATE, ALTER, DROP);
  - prevents deletion of critical application tables.

---

## Audit & Error Handling
- `CODURI_EROARE` – centralized catalog of custom error codes;
- `LOG_EROARE` – logging of failed executions using **autonomous transactions**;
- `AUDIT_OPERATII_LDD` – full audit of DDL operations at schema level.

---

## PL/SQL Package – Pharmacy Replenishment
The project includes a **complex PL/SQL package** that manages the pharmacy replenishment process:

### Functionalities:
- identification of medications with **critical stock levels** and/or **expiring batches**;
- estimation of **recent consumption** based on client orders;
- generation and permanent storage of a **replenishment report**;
- configuration of minimum thresholds per medication, with **change history**.

### Techniques Used:
- complex data types (`OBJECT`, `NESTED TABLE`);
- dynamic cursor;
- functions and procedures integrated into a complete business workflow.

---

## Project Execution
1. Create a dedicated Oracle user.
2. Run the SQL scripts in the following order:
   - table & sequence creation;
   - data insertion;
   - PL/SQL subprograms;
   - triggers;
   - PL/SQL package.
3. Enable output display:
```sql
   SET SERVEROUTPUT ON;
```
