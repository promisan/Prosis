
<cf_ModuleInsert
   SystemModule    = "Accounting" 
   Description     = "Financials"
   MenuTemplate    = "../Gledger/Menu.cfm" 
   MenuOrder       = "9">
  
<cf_ModuleInsertSubmit
   SystemModule    = "Accounting" 
   FunctionClass   = "Application"
   FunctionName    = "Journal Entry" 
   MenuOrder       = "1"
   MainMenuItem    = "1"
   FunctionMemo    = "Enter and review AP, AR and General Ledger Transactions"
   FunctionIcon    = "Folder"
   MenuClass       = "Mission"
   ScriptName      = "financials"
   AccessUserGroup = "0">  
   
<!--- journal listing --->  

<cf_ModuleInsertSubmit
   SystemModule      = "Accounting" 
   FunctionClass     = "Inquiry"
   FunctionName      = "Staff Advances" 
   MenuClass         = "Journal"
   MenuOrder         = "1"
   MainMenuItem      = "0"
   FunctionMemo      = "Inquiry Staff advances"
   FunctionDirectory = "GLedger/Inquiry/"
   FunctionPath      = "Advance/ListingEmployee.cfm"> 
   
<cf_ModuleInsertSubmit
   SystemModule      = "Accounting" 
   FunctionClass     = "Inquiry"
   FunctionName      = "Vendor Advances" 
   MenuClass         = "Journal"
   MenuOrder         = "1"
   MainMenuItem      = "0"
   FunctionMemo      = "Inquiry Vendor advances"
   FunctionDirectory = "GLedger/Inquiry/"
   FunctionPath      = "Advance/ListingVendor.cfm">    
   
<cf_ModuleInsertSubmit
   SystemModule      = "Accounting" 
   FunctionClass     = "Inquiry"
   FunctionName      = "Checks Issued" 
   MenuClass         = "Journal"
   MenuOrder         = "2"
   MainMenuItem      = "0"
   FunctionMemo      = "Inquiry Checks issued"
   FunctionDirectory = "GLedger/Inquiry/"
   FunctionPath      = "Checks/CheckIssued.cfm"> 
   
<cf_ModuleInsertSubmit
   SystemModule      = "Accounting" 
   FunctionClass     = "Inquiry"
   FunctionName      = "Pending Sale Declaration" 
   MenuClass         = "Journal"
   MenuOrder         = "2"
   MainMenuItem      = "0"
   FunctionMemo      = "Sales not declared"
   FunctionDirectory = "GLedger/Inquiry/"
   FunctionPath      = "Invoice/InvoiceNotDeclared.cfm">          
    
 <cf_ModuleInsertSubmit
   SystemModule      = "Accounting" 
   FunctionClass     = "Inquiry"
   FunctionName      = "Purchases" 
   MenuClass         = "Journal"
   MenuOrder         = "3"
   MainMenuItem      = "0"
   FunctionMemo      = "Inquiry Purchases"
   FunctionDirectory = "GLedger/Inquiry/"
   FunctionPath      = "Purchase/PurchaseBook.cfm">    
   
<cf_ModuleInsertSubmit
   SystemModule      = "Accounting" 
   FunctionClass     = "Inquiry"
   FunctionName      = "Interoffice transactions" 
   MenuClass         = "Journal"
   MenuOrder         = "3"
   MainMenuItem      = "0"
   FunctionMemo      = "Inquiry Interoffice transaction"
   FunctionDirectory = "GLedger/Inquiry/"
   FunctionPath      = "Interoffice/InterOffice.cfm">      
   
<!--- --------------- --->       
   
<cf_ModuleInsertSubmit
   SystemModule      = "Accounting" 
   FunctionClass     = "Application"
   FunctionName      = "Payables" 
   MenuOrder         = "2"
   MainMenuItem      = "1"
   FunctionMemo      = "Review and Process Payables"
   FunctionIcon      = "Folder"
   MenuClass         = "Mission"
   ScriptName        = "payables"   
   AccessUserGroup   = "1">     
   
   <!---
   FunctionDirectory = "GLedger/Inquiry/"
   FunctionPath      = "Payables/PayablesView.cfm"  
   --->
   
<cf_ModuleInsertSubmit
   SystemModule      = "Accounting" 
   FunctionClass     = "Application"
   FunctionName      = "Receivables" 
   MenuOrder         = "3"
   MainMenuItem      = "1"
   FunctionMemo      = "Review and Process Receivables"
   FunctionIcon      = "Folder"
   MenuClass         = "Mission"
   ScriptName        = "receivables"    
   AccessUserGroup   = "1">          
   
   <!---
   FunctionDirectory = "GLedger/Inquiry/"
   FunctionPath      = "Receivables/ReceivablesView.cfm"  
   --->
          
<cf_ModuleInsertSubmit
  SystemModule    = "Accounting" 
  FunctionClass   = "Reporting"
  FunctionName    = "Financial Statement" 
  MenuOrder       = "1"
  MainMenuItem    = "1"
  FunctionMemo    = "Financial Statement"
  FunctionIcon    = "Folder"
  MenuClass       = "Main"
  ScriptName      = "finstatement"
  AccessUserGroup = "0">  
  
<cf_ModuleInsertSubmit
   SystemModule   = "Accounting" 
   FunctionClass  = "Reporting"
   FunctionName   = "Budget Execution" 
   MenuClass      = "Main"
   MenuOrder      = "2"
   MainMenuItem   = "1"
   FunctionMemo   = "Review Budget Execution"
   FunctionDirectory = "Procurement/Application/"
   FunctionPath   = "Funding/FundingExecution.cfm"
   FunctionIcon   = "Option">    
   
  <cf_ModuleInsertSubmit
   SystemModule       = "Accounting" 
   FunctionClass      = "Reporting"
   FunctionName       = "Transaction Analysis" 
   MenuOrder          = "8"
   MainMenuItem       = "1"
   FunctionMemo       = "Review General Ledger Transactions"
   FunctionDirectory  = "GLedger/"
   FunctionPath       = "Inquiry/Transaction/DataSet.cfm"
   FunctionCondition  = "error"
   BrowserSupport     = "2"
   FunctionIcon       = "Dataset"   
   AccessUserGroup    = "0">      
   
<!--- add maintain --->
 
  <cf_ModuleInsertSubmit
   SystemModule      = "Accounting" 
   FunctionClass     = "Maintain"
   FunctionName      = "Budget Account Conversion" 
   MenuOrder         = "8"
   MainMenuItem      = "1"   
   FunctionMemo      = "Fund/Object Account conversion"
   FunctionDirectory = "GLedger/Maintenance"
   FunctionPath      = "Budget/RecordListing.cfm"     
   AccessUserGroup   = "0">      
       	     
 
  <cf_ModuleInsertSubmit
   SystemModule      = "Accounting" 
   FunctionClass     = "Maintain"
   FunctionName      = "Parameters" 
   MenuOrder         = "8"
   MainMenuItem      = "1"   
   FunctionMemo      = "Maintain application parameters"
   FunctionDirectory = "GLedger/Maintenance"
   FunctionPath      = "Parameter/ParameterEdit.cfm"     
   AccessUserGroup   = "0">      
   
   
  <cf_ModuleInsertSubmit
   SystemModule      = "Accounting" 
   FunctionClass     = "Maintain"
   FunctionName      = "Ledger Actions" 
   MenuOrder         = "8"
   MainMenuItem      = "1"   
   FunctionMemo      = "Maintain journal ledger actions"
   FunctionDirectory = "GLedger/Maintenance"
   FunctionPath      = "Action/RecordListing.cfm"     
   AccessUserGroup   = "0">      


  <cf_ModuleInsertSubmit
   SystemModule      = "Accounting" 
   FunctionClass     = "Maintain"
   FunctionName      = "Tax codes" 
   MenuOrder         = "7"
   MainMenuItem      = "1"   
   FunctionMemo      = "Maintain Taxcodes"
   FunctionDirectory = "GLedger/Maintenance"
   FunctionPath      = "Tax/RecordListing.cfm"     
   AccessUserGroup   = "0">    
   
   <cf_ModuleInsertSubmit
   SystemModule      = "Accounting" 
   FunctionClass     = "Maintain"
   FunctionName      = "Custom Fields" 
   MenuOrder         = "9"
   MainMenuItem      = "1"   
   FunctionMemo      = "Maintain Custom Fields"
   FunctionDirectory = "GLedger/Maintenance"
   FunctionPath      = "CustomField/RecordListing.cfm"     
   AccessUserGroup   = "0">                     
        
		
  <cf_ModuleInsertSubmit
   SystemModule      = "Accounting" 
   FunctionClass     = "Maintain"
   FunctionName      = "Terms" 
   MenuOrder         = "6"
   MainMenuItem      = "1"   
   FunctionMemo      = "Maintain Taxcodes"
   FunctionDirectory = "GLedger/Maintenance"
   FunctionPath      = "Terms/RecordListing.cfm"     
   AccessUserGroup   = "0"> 
   
  <cf_ModuleInsertSubmit
   SystemModule    = "Accounting" 
   FunctionClass   = "Maintain"
   FunctionName    = "Data entry Speedtypes" 
   MenuOrder       = "5"
   MainMenuItem    = "0"
   FunctionMemo    = "Data entry speedtypes" 
   FunctionDirectory = "GLedger/Maintenance"
   FunctionPath = "Speedtype/RecordListing.cfm" 
   AccessUserGroup = "0">     
      
 <cf_ModuleInsertSubmit
   SystemModule      = "Accounting" 
   FunctionClass     = "Maintain"
   FunctionName      = "Currencies" 
   MenuOrder         = "4"
   MainMenuItem      = "1"   
   FunctionMemo      = "Maintain Currencies"
   FunctionDirectory = "GLedger/Maintenance"
   FunctionPath      = "Currency/RecordListing.cfm"     
   AccessUserGroup   = "0"> 
      
 <cf_ModuleInsertSubmit
   SystemModule      = "Accounting" 
   FunctionClass     = "Maintain"
   FunctionName      = "Accounting Schema" 
   MenuOrder         = "0"
   MainMenuItem      = "1"   
   FunctionMemo      = "Maintain Journal and General Ledger Account codes"
   FunctionDirectory = "GLedger/Maintenance"
   FunctionPath      = "LedgerSchema/SchemaView.cfm"     
   AccessUserGroup   = "0">   		  		     		  		
      
   
<cf_ModuleInsertSubmit
   SystemModule      = "Accounting" 
   FunctionClass     = "Maintain"
   FunctionName      = "Account Period" 
   MenuOrder         = "2"
   MainMenuItem      = "1"   
   FunctionMemo      = "Maintain Account Financial Period"
   FunctionDirectory = "GLedger/Maintenance"
   FunctionPath      = "Period/RecordListing.cfm"     
   AccessUserGroup   = "0">   		     
   
   
   <cf_ModuleInsertSubmit
   SystemModule      = "Accounting" 
   FunctionClass     = "Maintain"
   FunctionName      = "Bank account" 
   MenuOrder         = "1"
   MainMenuItem      = "1"   
   FunctionMemo      = "Maintain Bank Accounts"
   FunctionDirectory = "GLedger/Maintenance"
   FunctionPath      = "Bank/RecordListing.cfm"     
   AccessUserGroup   = "0">   		     
   
   
      
   <cf_ModuleInsertSubmit
   SystemModule      = "Accounting" 
   FunctionClass     = "Maintain"
   FunctionName      = "Financial Object Tag" 
   MenuOrder         = "1"
   MainMenuItem      = "1"   
   FunctionMemo      = "Maintain Tags for Financial Objects"
   FunctionDirectory = "GLedger/Maintenance"
   FunctionPath      = "Tag/RecordListing.cfm"     
   AccessUserGroup   = "0">   	
   
   
   <cf_ModuleInsertSubmit
   SystemModule      = "Accounting" 
   FunctionClass     = "Maintain"
   FunctionName      = "Ledger Routing" 
   MenuOrder         = "1"
   MainMenuItem      = "1"   
   FunctionMemo      = "Maintain Routing Table for External Systems"
   FunctionDirectory = "GLedger/Maintenance"
   FunctionPath      = "Routing/RecordListing.cfm"     
   AccessUserGroup   = "0">
  