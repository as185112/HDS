# Oracle E-Business Suite Customization Codebase

## Project Overview
This is a Nintendo of America Oracle EBS customization repository containing PL/SQL packages, Oracle Forms, Reports, OA Framework extensions, and database objects. All custom objects use the `XXNIN` naming prefix.

## GitHub Copilot Instructions for PL/SQL Code Standards

### ✅ Naming Conventions
- Use `p_` prefix for procedure parameters (e.g., `p_emp_id`, `p_dept_id`)
- Use `v_` prefix for local variables (e.g., `v_total`, `v_status`)
- Use `c_` prefix for constants
- Use meaningful and descriptive names for procedures and functions

### ✅ Code Structure Guidelines
- Always include `DECLARE`, `BEGIN`, and `EXCEPTION` blocks in PL/SQL blocks
- Use indentation consistently (2 or 4 spaces)
- Group related logic into separate procedures or packages
- Avoid deeply nested IF/ELSE or LOOP structures

### ✅ SQL*Plus Script Standards
- All `.pks`, `.pkb`, and `.sql` files must end with:
  ```sql
  /
  SHOW ERRORS
  EXIT
  ```
- The `/` executes the PL/SQL block
- `SHOW ERRORS` displays compilation errors
- `EXIT` closes the SQL*Plus session

### ✅ Best Practices
- Validate inputs before performing operations
- Use `PRAGMA AUTONOMOUS_TRANSACTION` only when necessary
- Avoid hard-coded values; use constants or parameters
- Include comments to describe logic and purpose
- Use `%TYPE` and `%ROWTYPE` for variable declarations
- Handle exceptions gracefully with specific exception handlers (e.g., `NO_DATA_FOUND`, `TOO_MANY_ROWS`)
- Log errors to appropriate tables or use `DBMS_OUTPUT.PUT_LINE` for debugging

### ✅ Copilot Prompting Tips
- Start with a comment describing the procedure’s purpose
- Include parameter names and expected behavior
- Provide table or schema context in the workspace
- Use descriptive function names to guide Copilot
