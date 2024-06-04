DROP TABLE IF EXISTS EMPLOYEES;

CREATE TABLE Employees (
    ID INT PRIMARY KEY,
    Name VARCHAR(100),
    Salary DECIMAL(10,2),
    DepartmentID INT
);

INSERT INTO Employees (ID, Name, Salary, DepartmentID)
VALUES (1, 'Alice', 35000, 1),
       (2, 'Bob', 40000, 2),
       (3, 'Carol', 55000, 3),
       (4, 'David', 60000, 2),
       (5, 'Ethan', 70000, 1);
       
---------------------------       
DROP TABLE IF EXISTS DEPARTMENTS;

CREATE TABLE Departments (
    ID INT PRIMARY KEY,
    Name VARCHAR(100)
);

INSERT INTO Departments (ID, Name)
VALUES (1, 'HR'),
       (2, 'Finance'),
       (3, 'Marketing');
       
----------------------------       
DROP TABLE IF EXISTS SALES;

CREATE TABLE Sales (
    EmployeeID INT,
    Product VARCHAR(100),
    Quantity INT
);

INSERT INTO Sales (EmployeeID, Product, Quantity)
VALUES (1, 'A', 10),
       (1, 'B', 5),
       (2, 'A', 7),
       (2, 'C', 3),
       (3, 'B', 8),
       (3, 'C', 2),
       (4, 'A', 9),
       (4, 'B', 6),
       (5, 'C', 4),
       (5, 'A', 3);

/*Employees who make more than the average salary by department (subquery)*/
select e1.name, e1.salary 
from EMPLOYEES e1
WHERE salary >= (
  SELECT AVG(salary) FROM EMPLOYEES e2
  WHERE e1.DepartmentID = e2.DepartmentID)

/*Employees who make more than the average salary by department (CTE)*/
WITH CTE AS (
  select avg(salary) salary, departmentid
  FROM employees
  GROUP BY departmentid)
, CTE2 AS (
  SELECT name, salary, departmentid
  FROM employees)

SELECT x.name, x.salary
FROM CTE2 x
JOIN CTE y on x.departmentid = y.departmentid
WHERE x.salary >= y.salary

/*Employees who sold Product A AND sold more than the average quantity sold by all employees*/
SELECT e.name, s.product, sum(s.quantity) as totalquantity
FROM Sales s
JOIN Employees e on e.id = s.employeeid
WHERE s.product = 'A'
AND s.quantity > (SELECT avg(quantity) FROM sales WHERE product = 'A')
GROUP BY 1,2;
