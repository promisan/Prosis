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
<!--- Organization --->

<cf_verifyOperational module="Insurance">	 

<cfif ModuleEnabled eq "1">	  

	<cf_CheckObjectIntegritySetInsert  SystemModule="Insurance" PrimaryObject="Organization" 
                                 	   Datasource="AppsCaseFile" 
									   TableName="Claim" TableField="OrgUnit">

	<cf_CheckObjectIntegritySetInsert  SystemModule="Insurance" PrimaryObject="Person" 
                                 	   Datasource="AppsCaseFile" 
									   TableName="Claim" TableField="PersonNo">

	<cf_CheckObjectIntegritySetInsert  SystemModule="Insurance" PrimaryObject="Person" 
                                 	   Datasource="AppsCaseFile" 
									   TableName="Element" TableField="PersonNo">
								   
</cfif>

<!--- Warehouse --->
<cf_verifyOperational module="Warehouse">	  

<cfif ModuleEnabled eq "1">	  
								   
	<cf_CheckObjectIntegritySetInsert  SystemModule="Warehouse" PrimaryObject="Organization" 
                               	       Datasource="AppsMaterials" 
									   TableName="ItemVendor" TableField="OrgUnitVendor">				
									   
								   
	<cf_CheckObjectIntegritySetInsert  SystemModule="Warehouse" PrimaryObject="Organization" 
                               	       Datasource="AppsMaterials" 
									   TableName="ItemTransaction" TableField="OrgUnit">

	<cf_CheckObjectIntegritySetInsert  SystemModule="Warehouse" PrimaryObject="Organization" 
                               	       Datasource="AppsMaterials" 
									   TableName="AssetItemOrganization" TableField="OrgUnit">
									   
	<cf_CheckObjectIntegritySetInsert  SystemModule="Warehouse" PrimaryObject="Person" 
                               	       Datasource="AppsMaterials" 
									   TableName="AssetItemOrganization" TableField="PersonNo">

	<cf_CheckObjectIntegritySetInsert  SystemModule="Warehouse" PrimaryObject="Person" 
                               	       Datasource="AppsMaterials" 
									   TableName="TaskOrder" TableField="PersonNo">

	<cf_CheckObjectIntegritySetInsert  SystemModule="Warehouse" PrimaryObject="Person" 
                               	       Datasource="AppsMaterials" 
									   TableName="ItemTransaction" TableField="PersonNo">

	<cf_CheckObjectIntegritySetInsert  SystemModule="Warehouse" PrimaryObject="Person" 
                               	       Datasource="AppsMaterials" 
									   TableName="ItemTransactionDeny" TableField="PersonNo">
								   
</cfif>   
					
<!--- Accounting --->
<cf_verifyOperational module="Accounting">	 

<cfif ModuleEnabled eq "1">	  

	<cf_CheckObjectIntegritySetInsert  SystemModule="Accounting" PrimaryObject="Organization" 
                                 	   Datasource="AppsLedger" 
									   TableName="TransactionLine" TableField="OrgUnit">
									   
	<cf_CheckObjectIntegritySetInsert  SystemModule="Accounting" PrimaryObject="Organization" 
                                 	   Datasource="AppsLedger" 
									   TableName="TransactionHeader" TableField="ReferenceOrgUnit">
									   
	<cf_CheckObjectIntegritySetInsert  SystemModule="Accounting" PrimaryObject="Organization" 
                                 	   Datasource="AppsLedger" 
									   TableName="TransactionHeader" TableField="OrgUnitOwner">
									   
	<cf_CheckObjectIntegritySetInsert  SystemModule="Accounting" PrimaryObject="Person" 
                                 	   Datasource="AppsLedger" 
									   TableName="TransactionHeader" TableField="ReferencePersonNo">

									   <!---
	<cf_CheckObjectIntegritySetInsert  SystemModule="Accounting" PrimaryObject="Person" 
                                 	   Datasource="AppsLedger" 
									   TableName="TransactionHeaderDetail" TableField="DetailPersonNo">
									   --->
								   
</cfif>		   

<!--- Payroll --->

<cf_verifyOperational module="Payroll">	 

<cfif ModuleEnabled eq "1">	  

	<cf_CheckObjectIntegritySetInsert  SystemModule="Payroll" PrimaryObject="Organization" 
                                 	   Datasource="AppsPayroll" 
									   TableName="EmployeeSettlementLine" TableField="OrgUnit">
									   
	<cf_CheckObjectIntegritySetInsert  SystemModule="Payroll" PrimaryObject="Organization" 
                                 	   Datasource="AppsPayroll" 
									   TableName="EmployeeSalary" TableField="OrgUnit">

	<cf_CheckObjectIntegritySetInsert  SystemModule="Payroll" PrimaryObject="Person" 
                                 	   Datasource="AppsPayroll" 
									   TableName="PersonMiscellaneous" TableField="PersonNo">									   

	<cf_CheckObjectIntegritySetInsert  SystemModule="Payroll" PrimaryObject="Person" 
                                 	   Datasource="AppsPayroll" 
									   TableName="EmployeeSettlementAudit" TableField="PersonNo">									   
								   

	<cf_CheckObjectIntegritySetInsert  SystemModule="Payroll" PrimaryObject="Person" 
                                 	   Datasource="AppsPayroll" 
									   TableName="PersonDependentEntitlement" TableField="PersonNo">									   
									   
	<cf_CheckObjectIntegritySetInsert  SystemModule="Payroll" PrimaryObject="Person" 
                                 	   Datasource="AppsPayroll" 
									   TableName="PersonEntitlement" TableField="PersonNo">									   

	<cf_CheckObjectIntegritySetInsert  SystemModule="Payroll" PrimaryObject="Person" 
                                 	   Datasource="AppsPayroll" 
									   TableName="PersonDistribution" TableField="PersonNo">									   

	<cf_CheckObjectIntegritySetInsert  SystemModule="Payroll" PrimaryObject="Person" 
                                 	   Datasource="AppsPayroll" 
									   TableName="EmployeeSalary" TableField="PersonNo">									   

	<cf_CheckObjectIntegritySetInsert  SystemModule="Payroll" PrimaryObject="Person" 
                                 	   Datasource="AppsPayroll" 
									   TableName="EmployeeSettlementLine" TableField="PersonNo">									   

	<cf_CheckObjectIntegritySetInsert  SystemModule="Payroll" PrimaryObject="Person" 
                                 	   Datasource="AppsPayroll" 
									   TableName="EmployeeSalaryLine" TableField="PersonNo">									   

	<cf_CheckObjectIntegritySetInsert  SystemModule="Payroll" PrimaryObject="Person" 
                                 	   Datasource="AppsPayroll" 
									   TableName="PersonOvertime" TableField="PersonNo">									   
									   
	<cf_CheckObjectIntegritySetInsert  SystemModule="Payroll" PrimaryObject="Person" 
                                 	   Datasource="AppsPayroll" 
									   TableName="PersonAccount" TableField="PersonNo">									   

	<cf_CheckObjectIntegritySetInsert  SystemModule="Payroll" PrimaryObject="Person" 
                                 	   Datasource="AppsPayroll" 
									   TableName="EmployeeSettlement" TableField="PersonNo">									   
									   
</cfif>

<!--- Procurement --->

<cf_verifyOperational module="Procurement">	 

<cfif ModuleEnabled eq "1">	  

	<cf_CheckObjectIntegritySetInsert  SystemModule="Procurement" PrimaryObject="Person" 
                                 	   Datasource="AppsPurchase" 
									   TableName="RequisitionLine" TableField="PersonNo">
									   
	<cf_CheckObjectIntegritySetInsert  SystemModule="Procurement" PrimaryObject="Person" 
                                 	   Datasource="AppsPurchase" 
									   TableName="Purchase" TableField="PersonNo">

	<cf_CheckObjectIntegritySetInsert  SystemModule="Procurement" PrimaryObject="Person" 
                                 	   Datasource="AppsPurchase" 
									   TableName="PurchaseLineReceipt" TableField="PersonNo">
									   
	<cf_CheckObjectIntegritySetInsert  SystemModule="Procurement" PrimaryObject="Organization" 
                                 	   Datasource="AppsPurchase" 
									   TableName="RequisitionLine" TableField="OrgUnit">

	<cf_CheckObjectIntegritySetInsert  SystemModule="Procurement" PrimaryObject="Organization" 
                                 	   Datasource="AppsPurchase" 
									   TableName="Purchase" TableField="OrgUnitVendor">
									   
	<cf_CheckObjectIntegritySetInsert  SystemModule="Procurement" PrimaryObject="Organization" 
                                 	   Datasource="AppsPurchase" 
									   TableName="Purchase" TableField="OrgUnit">
									   
	<cf_CheckObjectIntegritySetInsert  SystemModule="Procurement" PrimaryObject="Organization" 
                                 	   Datasource="AppsPurchase" 
									   TableName="Invoice" TableField="OrgUnitVendor">
									   
	<cf_CheckObjectIntegritySetInsert  SystemModule="Procurement" PrimaryObject="Organization" 
                                 	   Datasource="AppsPurchase" 
									   TableName="Invoice" TableField="OrgUnitOwner">

</cfif>

<!--- Program --->
<cf_verifyOperational module="Program">	 

<cfif ModuleEnabled eq "1">	 

	<cf_CheckObjectIntegritySetInsert  SystemModule="Program" PrimaryObject="Organization" 
                                 	   Datasource="AppsProgram" 
									   TableName="ProgramPeriod" TableField="OrgUnitRequest">
									   
	<cf_CheckObjectIntegritySetInsert  SystemModule="Program" PrimaryObject="Organization" 
                                 	   Datasource="AppsProgram" 
									   TableName="ProgramPeriod" TableField="OrgUnitImplement">
									   
	<cf_CheckObjectIntegritySetInsert  SystemModule="Program" PrimaryObject="Organization" 
                                 	   Datasource="AppsProgram" 
									   TableName="ProgramPeriod" TableField="OrgUnit">
									   
	<cf_CheckObjectIntegritySetInsert  SystemModule="Program" PrimaryObject="Organization" 
                                 	   Datasource="AppsProgram" 
									   TableName="ProgramActivity" TableField="OrgUnit">

	<cf_CheckObjectIntegritySetInsert  SystemModule="Program" PrimaryObject="Person" 
                                 	   Datasource="AppsProgram" 
									   TableName="ProgramPeriodOfficer" TableField="PersonNo">

	<cf_CheckObjectIntegritySetInsert  SystemModule="Program" PrimaryObject="Person" 
                                 	   Datasource="AppsProgram" 
									   TableName="ProgramActivityPerson" TableField="PersonNo">
									   
</cfif>

<!--- Staffing --->
<cf_verifyOperational module="Staffing">	 

<cfif ModuleEnabled eq "1">	 

	<cf_CheckObjectIntegritySetInsert  SystemModule="Staffing" PrimaryObject="Organization" 
                                 	   Datasource="AppsEmployee" 
									   TableName="PositionParent" TableField="OrgUnitOperational">
									   
	<cf_CheckObjectIntegritySetInsert  SystemModule="Staffing" PrimaryObject="Organization" 
                                 	   Datasource="AppsEmployee" 
									   TableName="Position" TableField="OrgUnitOperational">

	<cf_CheckObjectIntegritySetInsert  SystemModule="Staffing" PrimaryObject="Organization" 
                                 	   Datasource="AppsEmployee" 
									   TableName="PersonAssignment" TableField="OrgUnit">
									   
</cfif>

<!--- WorkOrder --->
<cf_verifyOperational module="WorkOrder">	 

<cfif ModuleEnabled eq "1">	 

	<cf_CheckObjectIntegritySetInsert  SystemModule="WorkOrder" PrimaryObject="Person" 
                                 	   Datasource="AppsWorkOrder" 
									   TableName="WorkOrderLine" TableField="PersonNo">
									   
	<cf_CheckObjectIntegritySetInsert  SystemModule="WorkOrder" PrimaryObject="Person" 
                                 	   Datasource="AppsWorkOrder" 
									   TableName="Request" TableField="PersonNo">

	<cf_CheckObjectIntegritySetInsert  SystemModule="WorkOrder" PrimaryObject="Person" 
                                 	   Datasource="AppsWorkOrder" 
									   TableName="WorkOrderLineActionPerson" TableField="PersonNo">
									   
</cfif>