<!--
    Copyright © 2025 Promisan

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

   
<!--- topics --->

<cf_ModuleInsertSubmit
   SystemModule    = "Portal" 
   FunctionClass   = "User"
   FunctionName    = "Pending Support Tickets" 
   MenuOrder       = "1"
   MainMenuItem    = "0"
   MenuClass       = "topic"
   FunctionMemo    = "Manage and review your pending Support Tickets"
   FunctionPath    = "Support"
   AccessUserGroup = "0">  
   
<cf_ModuleInsertSubmit
   SystemModule    = "Portal" 
   FunctionClass   = "User"
   FunctionName    = "Pending Actions" 
   MenuOrder       = "1"
   MainMenuItem    = "0"
   MenuClass       = "topic"
   FunctionMemo    = "Review and process any pending workflow related action that require your action"
   FunctionPath    = "MyClearances"
   AccessUserGroup = "0">     
   
   <cf_ModuleInsertSubmit
   SystemModule    = "Portal" 
   FunctionClass   = "User"
   FunctionName    = "Workflow Actions" 
   MenuOrder       = "1"
   MainMenuItem    = "0"
   MenuClass       = "topic"
   FunctionMemo    = "Review workflow actions taken (excluding Procurement batch review)"
   FunctionPath    = "MyActions"
   AccessUserGroup = "0">     
   
<cf_ModuleInsertSubmit
   SystemModule    = "Portal" 
   FunctionClass   = "HR"
   FunctionName    = "Workforce Summary" 
   MenuOrder       = "1"
   MainMenuItem    = "0"
   MenuClass       = "topic"
   FunctionMemo    = "Workforce Staffing and Vacancy summary"
   FunctionPath    = "Staffing"
   AccessUserGroup = "0">     
   
<cf_ModuleInsertSubmit
   SystemModule    = "Portal" 
   FunctionClass   = "HR"
   FunctionName    = "Staff Diversity and Movements" 
   MenuOrder       = "2"
   MainMenuItem    = "0"
   MenuClass       = "topic"
   FunctionMemo    = "Workforce Diversity and Movements"
   FunctionPath    = "PersonDiversity"
   AccessUserGroup = "0">     
   
<cf_ModuleInsertSubmit
   SystemModule    = "Portal" 
   FunctionClass   = "Program"
   FunctionName    = "Budget Execution" 
   MenuOrder       = "0"
   MainMenuItem    = "0"
   MenuClass       = "topic"
   FunctionMemo    = "Executive Budget execution summary"
   FunctionPath    = "BudgetExecution"
   AccessUserGroup = "0">     
   
<cf_ModuleInsertSubmit
   SystemModule    = "Portal" 
   FunctionClass   = "HR"
   FunctionName    = "Personnel Events" 
   MenuOrder       = "3"
   MainMenuItem    = "0"
   MenuClass       = "topic"
   FunctionMemo    = "Personnel event summary"
   FunctionPath    = "PersonEvent"
   AccessUserGroup = "0">       
   
<cf_ModuleInsertSubmit
   SystemModule    = "Portal" 
   FunctionClass   = "HR"
   FunctionName    = "Performance Appraisal status" 
   MenuOrder       = "4"
   MainMenuItem    = "0"
   MenuClass       = "topic"
   FunctionMemo    = "Processing of EPAS"
   FunctionPath    = "EPAS"
   AccessUserGroup = "0">        

<cf_ModuleInsertSubmit
   SystemModule    = "Portal" 
   FunctionClass   = "HR"
   FunctionName    = "Pending Recruitment Tracks" 
   MenuOrder       = "4"
   MainMenuItem    = "0"
   MenuClass       = "topic"
   FunctionMemo    = "Staff Recruitment tracks in process"
   FunctionPath    = "Vacancy"
   AccessUserGroup = "0">          
      
<cf_ModuleInsertSubmit
   SystemModule    = "Portal" 
   FunctionClass   = "Program"
   FunctionName    = "Financial Requirements" 
   MenuOrder       = "3"
   MainMenuItem    = "0"
   MenuClass       = "topic"
   FunctionMemo    = "Project and Program Financial requirements"
   FunctionPath    = "Requirement"
   AccessUserGroup = "0">        
   
<cf_ModuleInsertSubmit
   SystemModule    = "Portal" 
   FunctionClass   = "Procurement"
   FunctionName    = "Commitments by Class" 
   MenuOrder       = "3"
   MainMenuItem    = "0"
   MenuClass       = "topic"
   FunctionMemo    = "Obligations and Disbursement by procurement request class"
   FunctionPath    = "Obligation"
   AccessUserGroup = "0">        
     
<cf_ModuleInsertSubmit
   SystemModule    = "Portal" 
   FunctionClass   = "Procurement"
   FunctionName    = "Invoices in process" 
   MenuOrder       = "4"
   MainMenuItem    = "0"
   MenuClass       = "topic"
   FunctionMemo    = "Incoming Invoices that are in process of payment"
   FunctionPath    = "Invoice"
   AccessUserGroup = "0">      
  
<cf_ModuleInsertSubmit
   SystemModule    = "Portal" 
   FunctionClass   = "WorkOrder"
   FunctionName    = "Service Charges" 
   MenuOrder       = "5"
   MainMenuItem    = "0"
   MenuClass       = "topic"
   FunctionMemo    = "WorkOrder Service Charges and Accounts Receivables"
   FunctionPath    = "WorkOrder"
   AccessUserGroup = "0">  

<cf_ModuleInsertSubmit
   SystemModule    = "Portal" 
   FunctionClass   = "WorkOrder"
   FunctionName    = "Manufacturing" 
   MenuOrder       = "6"
   MainMenuItem    = "0"
   MenuClass       = "topic"
   FunctionMemo    = "WorkOrder Shipping, Billing and Settlement"
   FunctionPath    = "Manufacturing"
   AccessUserGroup = "0">    
   
<cf_ModuleInsertSubmit
   SystemModule    = "Portal" 
   FunctionClass   = "WorkOrder"
   FunctionName    = "WorkOrder Production" 
   MenuOrder       = "6"
   MainMenuItem    = "0"
   MenuClass       = "topic"
   FunctionMemo    = "WorkOrder Production and its costs (BOM/Service) per Unit"
   FunctionPath    = "WorkOrderProduction"
   AccessUserGroup = "0">     
       
<cf_ModuleInsertSubmit
   SystemModule    = "Portal" 
   FunctionClass   = "Warehouse"
   FunctionName    = "Store Sales" 
   MenuOrder       = "6"
   MainMenuItem    = "0"
   MenuClass       = "topic"
   FunctionMemo    = "Sales and COGS summary by store (warehouse)"
   FunctionPath    = "SalesWarehouse"
   AccessUserGroup = "0">   
   
<cf_ModuleInsertSubmit
   SystemModule    = "Portal" 
   FunctionClass   = "Warehouse"
   FunctionName    = "Sales Officer" 
   MenuOrder       = "6"
   MainMenuItem    = "0"
   MenuClass       = "topic"
   FunctionMemo    = "Sales by Sales Officer"
   FunctionPath    = "SalesOfficer"
   AccessUserGroup = "0">    
   
<cf_ModuleInsertSubmit
   SystemModule    = "Portal" 
   FunctionClass   = "WorkOrder"
   FunctionName    = "WorkOrder Sales" 
   MenuOrder       = "6"
   MainMenuItem    = "0"
   MenuClass       = "topic"
   FunctionMemo    = "WorkOrder sales summary by service"
   FunctionPath    = "SalesWorkOrder"
   AccessUserGroup = "0">      
   
<cf_ModuleInsertSubmit
   SystemModule    = "Portal" 
   FunctionClass   = "WorkOrder"
   FunctionName    = "Workorder Deliveries" 
   MenuOrder       = "7"
   MainMenuItem    = "0"
   MenuClass       = "topic"
   FunctionMemo    = "WorkOrder Delivery History"
   FunctionPath    = "WorkOrderDelivery"
   AccessUserGroup = "0">                                            
    
	
   
<!--- Portal --->   
   
<!--- modules   

<cfloop index="itm" list="TravelClaim,Learning" delimiters=",">
	
	<cf_ModuleInsertSubmit
	   SystemModule       = "Portal" 
	   FunctionClass      = "#itm#"
	   FunctionName       = "Application" 
	   MenuOrder          = "1"
	   MainMenuItem       = "1"
	   FunctionMemo       = "#itm#"
	   FunctionDirectory  = "#itm#"
	   FunctionPath       = "Application/Menu.cfm">      
	
	<cf_ModuleInsertSubmit
	   SystemModule       = "Portal" 
	   FunctionClass      = "#Itm#"
	   FunctionName       = "Maintenance" 
	   MenuOrder          = "4"
	   MainMenuItem       = "1"
	   FunctionMemo       = "#itm#"
	   FunctionDirectory  = "#itm#"
	   FunctionPath       = "Maintenance/Menu.cfm">   
	   
	 <cf_ModuleInsertSubmit
	   SystemModule       = "Portal" 
	   FunctionClass      = "#Itm#"
	   FunctionName       = "Inquiry" 
	   MenuOrder          = "2"
	   MainMenuItem       = "1"
	   FunctionMemo       = "#itm#"
	   FunctionDirectory  = "#itm#"
	   FunctionPath       = "Inquiry/Menu.cfm">                 
   
</cfloop>  

***Not needed any more under the new Prosis look and feel: July,2012:
   
<cf_ModuleInsertSubmit
   SystemModule       = "Portal" 
   FunctionClass      = "System"
   FunctionName       = "System Configuration" 
   MenuOrder          = "3"
   MainMenuItem       = "1"
   FunctionMemo       = "System Utilities and Miscellaneous Settings"
   FunctionDirectory  = "System"
   FunctionPath       = "Parameter/Menu.cfm"
   FunctionCondition  = "id=config">      
   --->
   
<!--- self service --->        
   
<cf_ModuleInsertSubmit
   SystemModule       = "SelfService" 
   FunctionClass      = "SelfService"
   FunctionName       = "TravelClaim" 
   MenuOrder          = "1"
   MainMenuItem       = "1"
   FunctionMemo       = "Travel Claim Portal"
   FunctionDirectory  = "TravelClaim/Application"
   FunctionPath       = "ClaimView/ClaimView.cfm">   
   
  <cf_ModuleInsertSubmit
   SystemModule       = "SelfService" 
   FunctionClass      = "SelfService"
   FunctionName       = "PHP" 
   MenuOrder          = "1"
   MainMenuItem       = "1"
   FunctionMemo       = "Personal History Profile"
   FunctionPath       = "Roster/PHP/PHPEntry/PHPView.cfm">  
    
   <cf_ModuleInsertSubmit
   SystemModule       = "SelfService" 
   FunctionClass      = "SelfService"
   FunctionName       = "PAS" 
   MenuOrder          = "1"
   MainMenuItem       = "1"
   FunctionMemo       = "PAS"
   FunctionPath       = "ProgramREM/Application/Workplan/PASView/PASView.cfm">   
  
   <!--- disclaimer --->

   <cf_ModuleInsertSubmit
   SystemModule    = "SelfService" 
   FunctionClass   = "SelfService"
   FunctionName    = "PrivacyPolicy" 
   MenuOrder       = "1"
   MainMenuItem    = "0"
   MenuClass       = "disclaimer"
   FunctionMemo    = "Privacy Policy">    
   
     <cf_ModuleInsertSubmit
   SystemModule    = "SelfService" 
   FunctionClass   = "SelfService"
   FunctionName    = "About" 
   MenuOrder       = "1"
   MainMenuItem    = "0"
   MenuClass       = "disclaimer"
   FunctionMemo    = "About">          
   
     <cf_ModuleInsertSubmit
   SystemModule    = "SelfService" 
   FunctionClass   = "SelfService"
   FunctionName    = "Feedback" 
   MenuOrder       = "1"
   MainMenuItem    = "0"
   MenuClass       = "disclaimer"
   FunctionMemo    = "Feedback">    
   