--You want to find pairs of employees who work under the same manager
CREATE TABLE employees (
    id INTEGER PRIMARY KEY,
    name TEXT NOT NULL,
    manager_id INTEGER
);

INSERT INTO employees (id, name, manager_id) VALUES
(1, 'Alice', NULL),
(2, 'Bob', 1),
(3, 'Charlie', 1),
(4, 'David', 2),
(5, 'Eve', 2),
(6, 'Frank', 3);


SELECT 
    e1.name AS employee1, 
    e2.name AS employee2, 
    e1.manager_id AS manager
FROM employees e1
JOIN employees e2 ON e1.manager_id = e2.manager_id
WHERE e1.id != e2.id;
