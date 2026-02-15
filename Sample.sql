-- Test
CREATE OR REPLACE PACKAGE emp_pkg AS
  PROCEDURE process_employees;
END emp_pkg;
/

CREATE OR REPLACE PACKAGE BODY emp_pkg AS

  PROCEDURE process_employees IS
  BEGIN
    UPDATE employees
    SET salary = salary * 1.05;
  END process_employees;

END emp_pkg;
/
