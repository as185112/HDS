
CREATE OR REPLACE PACKAGE emp_pkg AS
  PROCEDURE process_employees;
END emp_pkg;
/

CREATE OR REPLACE PACKAGE BODY emp_pkg AS

  PROCEDURE process_employees IS
    CURSOR emp_cur IS
      SELECT * FROM employees; 

    v_emp_id     employees.employee_id%TYPE;
    v_emp_name   employees.first_name%TYPE;
    v_salary     employees.salary%TYPE;

  BEGIN
    FOR emp_rec IN emp_cur LOOP
      SELECT employee_id, first_name, salary
      INTO v_emp_id, v_emp_name, v_salary
      FROM employees
      WHERE employee_id = emp_rec.employee_id;

      UPDATE employees
      SET salary = salary * 1.05
      WHERE employee_id = v_emp_id;

      COMMIT;  
    END LOOP;
  END process_employees;

END emp_pkg;
/
