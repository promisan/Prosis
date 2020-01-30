
<!--- ---------- --->
<!--- -Program-- --->
<!--- ---------- --->

<cf_InsertIntegrityCheck 
 Object   = "Organization"       DataSource = "AppsProgram" 
 TableName = "ProgramActivity"  TableField = "OrgUnit"
 SystemModule = "Program">  


 
<cf_InsertIntegrityCheck 
 Object   = "Organization"       DataSource = "AppsProgram" 
 TableName = "ProgramPeriod"  TableField = "OrgUnit"
 SystemModule = "Program">   
 
<cf_InsertIntegrityCheck 
 Object   = "Organization"       DataSource = "AppsProgram" 
 TableName = "ProgramPeriod"  TableField = "OrgUnitImplement"
 SystemModule = "Program">   
 
<cf_InsertIntegrityCheck 
 Object   = "Organization"       DataSource = "AppsProgram" 
 TableName = "ProgramPeriod"  TableField = "OrgUnitRequest"
 SystemModule = "Program"> 

<!--- ------------- --->
<!--- -Employee---- --->
<!--- ------------- ---> 

<cf_InsertIntegrityCheck 
 Object   = "Organization"       DataSource = "AppsEmployee" 
 TableName = "PersonAssignment"  TableField = "OrgUnit"
 SystemModule = "Staffing">	
 
<cf_InsertIntegrityCheck 
 Object   = "Organization"       DataSource = "AppsEmployee" 
 TableName = "Position"  TableField = "OrgUnitOperational"
 SystemModule = "Staffing">	 
 
<cf_InsertIntegrityCheck 
 Object   = "Organization"       DataSource = "AppsEmployee" 
 TableName = "PositionParent"  TableField = "OrgUnitOperational"
 SystemModule = "Staffing">	
 
<!--- ------------- --->
<!--- -Insurance--- --->
<!--- ------------- --->  
 
<cf_InsertIntegrityCheck 
 Object   = "Organization"       DataSource = "AppsCaseFile" 
 TableName = "Claim"  TableField = "OrgUnit"
 SystemModule = "Insurance">	  
  
<!--- ------------ --->
<!--- -Materials-- --->
<!--- ------------ --->
 
<cf_InsertIntegrityCheck 
 Object   = "Organization"       DataSource = "AppsMaterials" 
 TableName = "AssetItemOrganization"  TableField = "OrgUnit"
 SystemModule = "Warehouse"> 
 
<cf_InsertIntegrityCheck 
 Object   = "Person"       DataSource = "AppsMaterials" 
 TableName = "AssetItemOrganization"  TableField = "PersonNo"
 SystemModule = "Warehouse">  

<cf_InsertIntegrityCheck 
 Object   = "Organization"       DataSource = "AppsMaterials" 
 TableName = "ItemTransaction"  TableField = "OrgUnit"
 SystemModule = "Warehouse"> 

<!--- ---------- --->
<!--- -Payroll-- --->
<!--- ---------- --->
  
<cf_InsertIntegrityCheck 
 Object   = "Organization"       DataSource = "AppsPayroll" 
 TableName = "EmployeeSalary"  TableField = "OrgUnit"
 SystemModule = "Payroll"> 
 
<cf_InsertIntegrityCheck 
 Object   = "Organization"       DataSource = "AppsPayroll" 
 TableName = "EmployeeSettlementLine"  TableField = "OrgUnit"
 SystemModule = "Payroll"> 
   

 <!--- -------- --->
 <!--- Purchase --->
 <!--- -------- --->
 
<cf_InsertIntegrityCheck 
 Object   = "Organization"       DataSource = "AppsPurchase" 
 TableName = "Invoice"  TableField = "OrgUnitOwner"
 SystemModule = "Procurement">  
 
<cf_InsertIntegrityCheck 
 Object   = "Organization"       DataSource = "AppsPurchase" 
 TableName = "Invoice"  TableField = "OrgUnitVendor"
 SystemModule = "Procurement">  

<cf_InsertIntegrityCheck 
 Object   = "Organization"       DataSource = "AppsPurchase" 
 TableName = "Purchase"  TableField = "OrgUnit"
 SystemModule = "Procurement">    
 
<cf_InsertIntegrityCheck 
 Object   = "Organization"       DataSource = "AppsPurchase" 
 TableName = "Purchase"  TableField = "OrgUnitVendor"
 SystemModule = "Procurement">   

<cf_InsertIntegrityCheck 
 Object   = "Person"       DataSource = "AppsPurchase" 
 TableName = "Purchase"  TableField = "PersonNo"
 SystemModule = "Procurement">   
  
<cf_InsertIntegrityCheck 
 Object   = "Person"            DataSource = "AppsPurchase" 
 TableName = "RequisitionLine"  TableField = "PersonNo"
 SystemModule = "Procurement">  

<cf_InsertIntegrityCheck 
 Object   = "Organization"       DataSource = "AppsPurchase" 
 TableName = "RequisitionLine"  TableField = "OrgUnit"
 SystemModule = "Procurement">    

<!--- ------------- --->
<!--- -Accounting-- --->
<!--- ------------- ---> 
 
<cf_InsertIntegrityCheck 
 Object   = "Organization"       DataSource = "AppsLedger" 
 TableName = "TransactionHeader"  TableField = "OrgUnitOwner"
 SystemModule = "Accounting">	
 
<cf_InsertIntegrityCheck 
 Object   = "Organization"       DataSource = "AppsLedger" 
 TableName = "TransactionHeader"  TableField = "ReferenceOrgUnit"
 SystemModule = "Accounting">   

<cf_InsertIntegrityCheck 
 Object   = "Organization"       DataSource = "AppsLedger" 
 TableName = "TransactionLine"  TableField = "OrgUnit"
 SystemModule = "Accounting">    
 
<cf_InsertIntegrityCheck 
 Object   = "Person"             DataSource = "AppsLedger" 
 TableName = "TransactionHeader"  TableField = "ReferencePersonNo"
 SystemModule = "Accounting">     
 
 
 
 