-- В данной базе данных создать 3 таблиц,
-- В 1-й содержатся имена и номера телефонов сотрудников некой компании
-- Во 2-й Ведомости об их зарплате, и должностях: главный директор, менеджер, рабочий.
-- В 3-й семейном положении, дате рождения, где они проживают.

DROP  DATABASE IF EXISTS myFunkDB;
CREATE DATABASE  IF NOT EXISTS myFunkDB;

USE myFunkDB;

CREATE TABLE IF NOT EXISTS person
(
    id_person int AUTO_INCREMENT NOT NULL PRIMARY KEY,
    name_person varchar(60) NOT NULL,
    phone_person varchar(12) NOT NULL
);

CREATE TABLE  IF NOT EXISTS salary
(
    id_salary int auto_increment NOT NULL PRIMARY KEY,
    salary float(10,2) NOT NULL,
    position varchar(40) NOT NULL,
    id_person_salary int NOT NULL,
    CONSTRAINT FOREIGN KEY (id_person_salary) REFERENCES person(id_person)

);

CREATE TABLE  IF NOT EXISTS personalInfo
(
    id_personalInfo int auto_increment NOT NULL PRIMARY KEY,
    familyStatus varchar(30) NOT NULL,
    birthday date NOT NULL,
    address varchar(50) NOT NULL,
    id_person_personalInfo int NOT NULL,
    CONSTRAINT FOREIGN KEY (id_person_personalInfo) REFERENCES person(id_person)
);

INSERT INTO person
( id_person, name_person, phone_person)
VALUES
    (1,'Анна Антонюк','(099)7142212'),
    (2,'Саша Фіц','(097)4302001'),
    (3,'Марія Карась','(098)6202990'),
    (4,'Оля Чиж','(098)7181236'),
    (5,'Коля ФІл','(098)2133217');

INSERT INTO salary
( id_salary, salary, position, id_person_salary)
VALUES
    (1,3000.20, 'Manager',1),
    (2, 2500.50, 'Worker',2),
    (3,6000.25, 'Manager',3),
    (4,2000.50, 'Worker',4),
    (5,2900.50, 'Director',5);

INSERT INTO personalInfo
( id_personalInfo, familyStatus, birthday, address,id_person_personalInfo)
VALUES
    (1,'Single', '1999-01-23', 'Address st, 88',1),
    (2,'Divorced', '1998-02-19', 'Address st, 527',2),
    (3,'Married', '1994-03-22', 'Address st, 1',3),
    (4,'Divorced', '1996-02-22', 'Address st, 949',4),
    (5,'Married', '1998-02-22', 'Address st, 29',5);

SELECT * FROM person;
SELECT * FROM salary;
SELECT * FROM personalInfo;
--
-- Задание 4
-- Создайте функции / процедуры для таких заданий:
--  1) Требуется узнать контактные данные сотрудников (номера телефонов, место жительства).
DELIMITER |

DROP PROCEDURE  IF EXISTS contactDetails; |
CREATE PROCEDURE  contactDetails()
BEGIN
    SELECT name_person, phone_person, address FROM person
                                                       JOIN
                                                   personalInfo
                                                   ON person.id_person = personalInfo.id_personalInfo;
END
|

DELIMITER |
CALL contactDetails();
|
--  2) Требуется узнать информацию о дате рождения всех не женатых сотрудников и номера телефонов этих сотрудников.

DELIMITER |
DROP PROCEDURE IF EXISTS unmarried; |
CREATE PROCEDURE unmarried()
BEGIN
    SELECT name_person, birthday, phone_person, familyStatus FROM personalInfo
                                                                      JOIN
                                                                  person
                                                                  ON personalInfo.id_personalInfo = person.id_person
    WHERE personalInfo.familyStatus = 'Divorced';
END
|

DELIMITER |
CALL unmarried();
|

--  3) Требуется узнать информацию о дате рождения всех сотрудников с должностью менеджер и номера телефонов этих сотрудников.
DELIMITER |
DROP PROCEDURE  IF EXISTS managers; |
CREATE PROCEDURE managers()
BEGIN
    SELECT name_person, birthday, phone_person, position FROM salary
                                                                  JOIN
                                                              personalInfo
                                                              ON salary.id_salary = personalInfo.id_personalInfo
                                                                  JOIN
                                                              person
                                                              ON salary.id_salary = person.id_person
    WHERE salary.position = 'Manager';
END
|

DELIMITER |
CALL managers();
|