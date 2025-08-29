<!--
    Copyright © 2025 Promisan B.V.

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

        http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
-->
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
 
 
 
 