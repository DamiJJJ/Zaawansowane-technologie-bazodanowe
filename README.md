# Library Database (SQL Server)

This project provides a comprehensive SQL script to set up and manage a simple library database. The script covers schema definition, data population, and examples of using views, functions, and stored procedures.

---

## Table of Contents

* [Introduction](#introduction)
* [Database Structure](#database-structure)
* [Features](#features)
* [How to Run](#how-to-run)

---

## Introduction

The goal of this project is to demonstrate fundamental SQL database operations such as table creation, relationship definition, constraint implementation, and the use of advanced database objects (views, functions, procedures). The `biblioteka` database allows for tracking authors, clients, books, employees, and rental transactions.

---

## Database Structure

The `biblioteka` database consists of the following tables:

* **`autor`**: Information about book authors (ID, First Name, Last Name, Date of Birth).
* **`klient`**: Library client details (ID, First Name, Last Name, Address, PESEL).
* **`ksiazki`**: Book details (ID, Genre, Title, Author ID, Publication Year, Description).
* **`pracownicy`**: Library employee details (ID, First Name, Last Name, PESEL, Position).
* **`wypozyczenie`**: Book rental records (Rental ID, Employee ID, Client ID, Book ID, Rental Date).

### Relationships (Foreign Keys)

* `ksiazki` references `autor` (`id_autor`)
* `wypozyczenie` references `klient` (`id_klient`)
* `wypozyczenie` references `ksiazki` (`id_ksiazki`)
* `wypozyczenie` references `pracownicy` (`id_pracownika`)

### Constraints (`CHECK` Constraints)

* **PESEL number validation**: `CHECK` constraints are implemented for `klient` and `pracownicy` tables to verify the correctness of the PESEL number (checksum) and exclude common invalid values.
* **Forbidden author last names**: A `CHECK` constraint in the `autor` table prevents the insertion of certain last names.
* **Rental Date**: The rental date must be less than or equal to the current date.

### Default Values (`DEFAULT` Constraints)

* `pracownicy.stanowisko`: Defaults to 'Młodszy bibliotekarz' (Junior Librarian).
* `ksiazki.Opis`: Defaults to 'Brak opisu' (No description).
* `klient.Adres`: Defaults to 'Brak podanego adresu' (No address provided).

### Indexes (`NONCLUSTERED INDEX`)

For improved query performance, non-clustered indexes have been added to the following columns:

* `ksiazki.Tytul`
* `klient.PESEL`
* `pracownicy.Nazwisko`

---

## Features

The project includes the following database objects:

* **Views**:
    * `VIEW_Wypozyczone_Ksiazki`: Displays details of rented books, joining data from multiple tables.
    * `VIEW_Ilosc_ksiazek_By_Autor`: Counts the number of books by each author.
    * `VIEW_Ilosc_Wypozyczonych_ksiazek`: Shows the number of times each book has been rented.
    * `VIEW_Ksiazki_Pomiedzy_Latami_1800_1900`: A view utilizing a table-valued function to filter books within a specific year range.
* **Functions**:
    * **Scalar Function (`FUNC_Get_Data_By_IdKlienta_IdKsiazki`)**: Returns the rental date for a specific client and book.
    * **Table-Valued Function (`FUNC_Get_Ksiazki_Pomiedzy_Latami`)**: Returns a table of books published within a specified range of years.
* **Stored Procedure**:
    * `InsertWypozyczenie`: A procedure for inserting new records into the `wypozyczenie` table. It includes validation to check if the provided employee, client, and book IDs exist in the database before insertion. The rental date defaults to the current date if not provided.

---

## How to Run

1.  **Clone the repository** or copy the contents of the `.sql` file.
2.  Open your SQL Server database management environment (e.g., SQL Server Management Studio - SSMS).
3.  Connect to your SQL Server instance.
4.  Open a new query window (`New Query`).
5.  Paste the entire content of the `.sql` file into the query window.
6.  Ensure you are connected to the `master` database (`USE [master]`).
7.  Execute the script (click `Execute` or press `F5`). This will:
    * Drop (if it exists) and recreate the `biblioteka` database.
    * Create all tables, foreign keys, constraints, and indexes.
    * Insert sample data.
    * Create the views, functions, and stored procedures.
    * Execute the example function and procedure calls.
