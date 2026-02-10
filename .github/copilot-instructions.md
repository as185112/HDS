# Oracle E-Business Suite Customization Codebase

## Project Overview
This is a Nintendo of America Oracle EBS customization repository containing PL/SQL packages, Oracle Forms, Reports, OA Framework extensions, and database objects. All custom objects use the `XXNIN` naming prefix.

## Architecture & Project Structure

### Object Types & Naming
- **PL/SQL Packages**: `.pks` (spec) + `.pkb` (body) pairs (e.g., `XXNIN_POS_RCV_INTF.pks/pkb`)
- **Tables**: `.sql` scripts creating custom tables in `XXNIN` schema (e.g., `XXNIN_POS_RCV_TRXS.sql`)
- **Oracle Forms**: `.fmb` files for custom forms (e.g., `XXNINONTRTLODRWB.fmb`)
- **Oracle Reports**: `.rdf` files for report definitions (e.g., `XXNIN_INV_PRINT_RPT.rdf`)
- **BI Publisher**: `.xml` data templates (e.g., `XXNIN_ECOMMERCE_OPEN_ORDERS_DT.xml`)
- **OA Framework**: Java controller files extending standard OA classes (e.g., `XxNinReqLinesNotificationsCO.java`)
- **Concurrent Programs**: `.ldt` FNDLOAD files (e.g., `XXNIN_ECOMMERCE_OP_ORD_RPT_CP.ldt`)
- **Installation Scripts**: Shell scripts with naming pattern `xxnin_W_<env>_<version>_ENHC<number>_install.sh`

### Enhancement Tracking
- All modifications reference enhancement/defect IDs in format `ENHC0######` or `DFCT0######`
- Change history sections in file headers track modifications chronologically
- Example: `ENHC0021396 - POS to EBS Receiving Interface`

### Standard Utilities & APIs
- **`fnd_global`**: Get session context (user_id, conc_request_id, org_id)
- **`fnd_file.put_line()`**: Concurrent program output (LOG and OUTPUT files)
- **`xxnin_util_pkg.send_notification()`**: Custom email notification wrapper
- **`xxnin_ou_details_util.get_master_org`**: Retrieve master operating unit
- **`fnd_lookup_values`**: Configuration via Oracle lookups (e.g., `XXNIN_POS_USER_LIST`)

## Code Standards

### Naming Conventions
- **Parameters**: `p_` prefix (e.g., `p_emp_id`, `p_store`, `p_shipment`)
- **Local Variables**: `v_` or `l_` prefix (e.g., `v_total`, `l_email_body`)
- **Global Variables**: `g_` prefix (e.g., `g_date`, `g_conc_request_id`, `g_user_id`)
- **Cursors**: `cur_` prefix (e.g., `cur_rcv_errors`)
- **Constants**: `c_` prefix
- **Record Types**: Use `%ROWTYPE` for cursor records (e.g., `rec_rcv_errors`)

### File Structure Standards
- **Header Block Required**: Author, date, description, file name, change log
- **Package Specifications**: Define procedure/function signatures with parameter documentation
- **Package Bodies**: 
  - Global variables defined at package level
  - Private procedures before public procedures
  - Exception handling in all procedures

### SQL*Plus Script Standards
All `.pks`, `.pkb`, and `.sql` files must end with:
```sql
/
SHOW ERRORS
EXIT
```
- `/` executes the PL/SQL block or DDL statement
- `SHOW ERRORS` displays compilation errors
- `EXIT` terminates SQL*Plus session

### Table Creation Patterns
- Create tables in `XXNIN` schema explicitly: `CREATE TABLE XXNIN.table_name`
- Always include audit columns: `CREATED_BY`, `CREATION_DATE`, `LAST_UPDATED_BY`, `LAST_UPDATE_DATE`
- Use `REQUEST_ID` for concurrent program tracking
- Include flexible `ATTRIBUTE1` through `ATTRIBUTE15` for extensibility
- End with: `EXEC ad_zd_table.upgrade('XXNIN', 'TABLE_NAME');` for online patching

### Concurrent Program Patterns
- Main procedures have signature: `(errbuf OUT VARCHAR2, retcode OUT NUMBER, p_param1 IN ...)`
- Set `retcode = 1` for warnings, `retcode = 2` for errors
- Use `fnd_file.put_line(fnd_file.LOG, ...)` for log messages
- Use `fnd_file.put_line(fnd_file.output, ...)` for output file content
- Implement summary reports with counts and error details
- Send email notifications on errors using `xxnin_util_pkg.send_notification()` with XML body

### Error Handling Standards
```sql
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        -- Specific error handling
    WHEN TOO_MANY_ROWS THEN
        -- Specific error handling
    WHEN OTHERS THEN
        l_error_message := 'UnExpected Error - <context>: ' 
            || SUBSTR(SQLERRM, 1, 500) 
            || ', ' 
            || DBMS_UTILITY.format_error_backtrace;
        fnd_file.put_line(fnd_file.LOG, l_error_message);
```

### OA Framework Extensions
- Custom controllers extend standard OA classes (e.g., `extends ReqLinesNotificationsCO`)
- Override `processRequest()` method calling `super.processRequest()` first
- Use JDBC connections via: `pageContext.getApplicationModule(webBean).getOADBTransaction().getJdbcConnection()`
- Build queries using `LISTAGG()` for aggregate string concatenation

## Development Workflow

### Key File Locations
- Package specs/bodies: `Multiple_Files/XXNIN_*.pks`, `XXNIN_*.pkb`
- Tables: `Multiple_Files/XXNIN_*_TRXNS.sql`, `R_*/XXNIN_*.sql`
- OA Framework: `Multiple_Files/XxNin*CO.java`
- Reports: `Multiple_Files/XXNIN_*_RPT.rdf` or `*_RPT_CP.ldt`

### Common Patterns to Follow
- Use `NVL()` extensively for null handling: `NVL(warning_flag, 'X') = 'Y'`
- Status tracking: `'PROCESSED'`, `'VALIDATION_ERROR'`, `'DATA_ERROR'`, `'PERIOD_ERROR'`, `'IGNORE'`
- Date handling: Store as DATE, format with `TO_CHAR()` for XML/output
- Cursor-based processing with explicit error tracking per record
- Aggregate statistics before detail processing (total, processed, errors)

### References
- File headers show enhancement numbers linking to requirements
- Lookup type usage for dynamic configuration (vs hard-coded values)
- Standard audit trail using FND APIs (`fnd_global.user_id`, `SYSDATE`)

- what are my team's coding preferences?
- Does this code follow my team's standards?

.

