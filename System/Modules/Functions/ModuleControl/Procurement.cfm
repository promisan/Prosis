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

<!--- application --->

<cf_ModuleInsertSubmit
   SystemModule      = "Procurement" 
   FunctionClass     = "Application"
   FunctionName      = "Vendor Listing" 
   MenuClass         = "Mission"
   MenuOrder         = "7"
   MainMenuItem      = "9"
   ScriptName        = "vendor"    
   FunctionMemo      = "Maintain Vendor Records"  
   AccessUserGroup   = "1">  
   
  
<!--- inquiry --->
  
<!--- 
  
<cf_ModuleInsertSubmit
   SystemModule="Procurement" 
   FunctionClass = "Inquiry"
   FunctionName = "Budget Review" 
   MenuClass    = "Main"
   MenuOrder    = "4"
   MainMenuItem = "2"
   FunctionMemo = "Review Procurement Proposals"
   FunctionDirectory = "Procurement/Inquiry/"
   FunctionPath = "Budget/BudgetListing.cfm"
   FunctionIcon = "Option">    
   
   --->            
	
<cf_ModuleInsertSubmit
   SystemModule="Procurement" 
   FunctionClass = "Inquiry"
   FunctionName = "Budget Execution" 
   MenuClass    = "Main"
   MenuOrder    = "4"
   MainMenuItem = "1"
   FunctionMemo = "Review Budget Execution"
   FunctionDirectory = "Procurement/Application/"
   FunctionPath = "Funding/FundingExecution.cfm"
   FunctionIcon = "Option">         	
      
<cf_ModuleInsertSubmit
   SystemModule="Procurement" 
   FunctionClass = "Inquiry"
   FunctionName = "Requisition Search" 
   MenuClass    = "Main"
   MenuOrder    = "5"
   MainMenuItem = "1"
   FunctionMemo = "Requisition Filter/Search"
   FunctionDirectory = "Procurement/Inquiry/"
   FunctionPath = "Requisition/RequisitionView.cfm"
   FunctionIcon = "Option">         	      

   
<!--- maintenance requistion --->


   
<cf_ModuleInsertSubmit
   SystemModule   = "Procurement" 
   FunctionClass  = "System"
   FunctionName   = "Status Definition" 
   MenuClass      = "Main"
   MenuOrder      = "0"
   MainMenuItem   = "0"
   FunctionMemo   = "Maintain Procurement Status Labels"
   FunctionDirectory = "Procurement/Maintenance/"
   FunctionPath   = "Status/RecordListing.cfm"
   FunctionIcon   = "Maintain">             
   
<cf_ModuleInsertSubmit
   SystemModule   = "Procurement" 
   FunctionClass  = "Maintain"
   FunctionName   = "Requisition Entry Class" 
   MenuClass      = "Requisition"
   MenuOrder      = "0"
   MainMenuItem   = "0"
   FunctionMemo   = "Maintain Requisition Entry classes for Item Master"
   FunctionDirectory = "Procurement/Maintenance/"
   FunctionPath   = "EntryClass/RecordListing.cfm"
   FunctionIcon   = "Maintain">             
    
<cf_ModuleInsertSubmit
   SystemModule      = "Procurement" 
   FunctionClass     = "Maintain"
   FunctionName      = "Procurement Standards" 
   MenuClass         = "Requisition"
   MenuOrder         = "1"
   MainMenuItem      = "0"
   FunctionMemo      = "Maintain Procurement Standards"
   FunctionDirectory = "Procurement/Maintenance/"
   FunctionPath      = "Standards/RecordListing.cfm"
   AccessUserGroup   = "0"> 
    
<cf_ModuleInsertSubmit
   SystemModule      = "Procurement" 
   FunctionClass     = "Maintain"
   FunctionName      = "Custom Fields Requisition" 
   MenuClass         = "Requisition"
   MenuOrder         = "3"
   MainMenuItem      = "0"
   FunctionMemo      = "Maintain Custom Fields Purchase Order"
   FunctionDirectory = "Procurement/Maintenance/"
   FunctionPath      = "Custom/RecordListing.cfm"
   AccessUserGroup   = "0">      
      
<cf_ModuleInsertSubmit
   SystemModule      = "Procurement" 
   FunctionClass     = "Maintain"
   FunctionName      = "Requisition Reasons" 
   MenuClass         = "Requisition"
   MenuOrder         = "4"
   MainMenuItem      = "0"
   FunctionMemo      = "Maintain Requisition Reasons"
   FunctionDirectory = "Procurement/Maintenance/"
   FunctionPath      = "Reasons/RecordListing.cfm"
   AccessUserGroup   = "0">      
        
<cf_ModuleInsertSubmit
   SystemModule    = "Procurement" 
   FunctionClass   = "Maintain"
   FunctionName    = "Job Group" 
   MenuClass       = "Requisition"
   MenuOrder       = "5"
   MainMenuItem    = "0"
   FunctionMemo    = "Maintain Job Grouping"
   FunctionDirectory = "Procurement/Maintenance/"
   FunctionPath    = "JobGroup/RecordListing.cfm"
   AccessUserGroup = "0">  
   
<cf_ModuleInsertSubmit
   SystemModule    = "Procurement" 
   FunctionClass   = "Maintain"
   FunctionName    = "Award" 
   MenuClass       = "Requisition"
   MenuOrder       = "5"
   MainMenuItem    = "0"
   FunctionMemo    = "Maintain Quotation Award reasons"
   FunctionDirectory = "Procurement/Maintenance/"
   FunctionPath    = "Award/RecordListing.cfm"
   AccessUserGroup = "0">   
   
   
<cf_ModuleInsertSubmit
   SystemModule    = "Procurement" 
   FunctionClass   = "Maintain"
   FunctionName    = "Unit of Measure" 
   MenuClass       = "Requisition"
   MenuOrder       = "6"
   MainMenuItem    = "0"
   FunctionMemo    = "Maintain Unit of Measure"
   FunctionDirectory = "Procurement/Maintenance/"
   FunctionPath    = "UoM/RecordListing.cfm"
   AccessUserGroup = "0">   
                         
      

<!--- maintenance purchase --->
   
<cf_ModuleInsertSubmit
   SystemModule      = "Procurement" 
   FunctionClass     = "Maintain"
   FunctionName      = "Order Type" 
   MenuClass         = "Purchase"
   MenuOrder         = "1"
   MainMenuItem      = "0"
   FunctionMemo      = "Maintain Purchase Type"
   FunctionDirectory = "Procurement/Maintenance/"
   FunctionPath      = "OrderType/RecordListing.cfm"
   AccessUserGroup   = "0">   
      
<cf_ModuleInsertSubmit
   SystemModule      = "Procurement" 
   FunctionClass     = "Maintain"
   FunctionName      = "Order Class" 
   MenuClass         = "Purchase"
   MenuOrder         = "2"
   MainMenuItem      = "0"
   FunctionMemo      = "Maintain Order Class"
   FunctionDirectory = "Procurement/Maintenance/"
   FunctionPath      = "OrderClass/RecordListing.cfm"
   AccessUserGroup   = "0">                        
   
<cf_ModuleInsertSubmit
   SystemModule      = "Procurement" 
   FunctionClass     = "Maintain"
   FunctionName      = "Custom Fields Purchase Order" 
   MenuClass         = "Purchase"
   MenuOrder         = "3"
   MainMenuItem      = "0"
   FunctionMemo      = "Maintain Custom Fields Purchase Order"
   FunctionDirectory = "Procurement/Maintenance/"
   FunctionPath      = "Custom/RecordListing.cfm"
   AccessUserGroup   = "0">   
      
<cf_ModuleInsertSubmit
   SystemModule      = "Procurement" 
   FunctionClass     = "Maintain"
   FunctionName      = "Procurement Clauses" 
   MenuClass         = "Purchase"
   MenuOrder         = "4"
   MainMenuItem      = "0"
   FunctionMemo      = "Maintain Procurement Clauses"
   FunctionDirectory = "Procurement/Maintenance/"
   FunctionPath      = "Clauses/RecordListing.cfm"
   AccessUserGroup   = "0"> 
   
     
<cf_ModuleInsertSubmit
   SystemModule      = "Procurement" 
   FunctionClass     = "Maintain"
   FunctionName      = "Conditions" 
   MenuClass         = "Purchase"
   MenuOrder         = "4"
   MainMenuItem      = "0"
   FunctionMemo      = "Maintain Conditions"
   FunctionDirectory = "Procurement/Maintenance/"
   FunctionPath      = "Condition/RecordListing.cfm"
   AccessUserGroup   = "0">   
   
     
<cf_ModuleInsertSubmit
   SystemModule      = "Procurement" 
   FunctionClass     = "Maintain"
   FunctionName      = "international commercial terms" 
   MenuClass         = "Purchase"
   MenuOrder         = "5"
   MainMenuItem      = "0"
   FunctionMemo      = "Maintain international commercial terms"
   FunctionDirectory = "Procurement/Maintenance/"
   FunctionPath      = "Incoterm/RecordListing.cfm"
   AccessUserGroup   = "0">                                   
   
<cf_ModuleInsertSubmit
   SystemModule      = "Procurement" 
   FunctionClass     = "Maintain"
   FunctionName      = "Delivery Tracking" 
   MenuClass         = "Purchase"
   MenuOrder         = "7"
   MainMenuItem      = "0"
   FunctionMemo      = "Maintain Delivery Tracking Fields"
   FunctionDirectory = "Procurement/Maintenance/"
   FunctionPath      = "TTracking/RecordListing.cfm"
   AccessUserGroup   = "0"> 
      
<cf_ModuleInsertSubmit
   SystemModule      = "Procurement" 
   FunctionClass     = "Maintain"
   FunctionName      = "Tracking" 
   MenuClass         = "Purchase"
   MenuOrder         = "8"
   MainMenuItem      = "0"
   FunctionMemo      = "Maintain Tracking Dates"
   FunctionDirectory = "Procurement/Maintenance/"
   FunctionPath      = "Tracking/RecordListing.cfm"
   AccessUserGroup   = "0">  
 

<!--- invoice purchase ---> 
  
<cf_ModuleInsertSubmit
   SystemModule  = "Procurement" 
   FunctionClass = "Maintain"
   FunctionName  = "Financial Object Tag" 
   MenuClass     = "Invoice"
   MenuOrder     = "4"
   MainMenuItem  = "1"
   FunctionMemo  = "Maintain Tags for Financial Objects"
   FunctionDirectory = "GLedger/Maintenance/"
   FunctionPath  = "Tag/RecordListing.cfm"
   FunctionIcon  = "Maintain">       
   
<cf_ModuleInsertSubmit
   SystemModule="Procurement" 
   FunctionClass = "Maintain"
   FunctionName = "Object of Expenditure" 
   MenuClass    = "Invoice"
   MenuOrder    = "4"
   MainMenuItem = "1"
   FunctionMemo = "Maintain Object of Expenditures"
   FunctionDirectory = "ProgramREM/Maintenance/"
   FunctionPath = "Object/RecordListing.cfm"
   FunctionIcon = "Maintain">     
  
   