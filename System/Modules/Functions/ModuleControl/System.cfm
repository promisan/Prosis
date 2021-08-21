
<!--- ref_Modulecontrol --->

<cf_ModuleInsert
   SystemModule    = "System" 
   Description     = "System Administration"
   MenuTemplate    = "System" 
   Hint            = "Manage System Settings"
   MenuOrder       = "8">
   
<cf_ModuleInsert
   SystemModule    = "Organization" 
   Description     = "Organization Management"
   MenuTemplate    = "System" 
   Hint            = "Manage Organization"
   MenuOrder       = "8">   
   
<cf_ModuleInsert
   SystemModule    = "AdminConfig" 
   Description     = "System Configuration"
   MenuTemplate    = "System" 
   Hint            = "Manage Workflow and Reports"
   MenuOrder       = "8">
   
<cf_ModuleInsert
   SystemModule    = "AdminUser" 
   Description     = "User Administration"
   MenuTemplate    = "System" 
   Hint            = "Manage User Access"
   MenuOrder       = "8">   
   
<cf_ModuleInsert
   SystemModule    = "Mobile" 
   Description     = "Mobile Apps"
   MenuTemplate    = "" 
   Hint            = "Mobile Apps"
   MenuOrder       = "98">   
   
<cf_ModuleInsert
   SystemModule    = "PMobile" 
   Description     = "Mobility Functions"
   MenuTemplate    = "" 
   Hint            = "Mobility enabled function"
   MenuOrder       = "99">         


 <cfquery name="Drop"
	datasource="appsOrganization">
      if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[vwOrganizationAddress]') 
	 and OBJECTPROPERTY(id, N'IsView') = 1)
     drop view [dbo].[vwOrganizationAddress]
  </cfquery>

  <cfquery name="CreateView"
	datasource="appsOrganization">
	CREATE VIEW dbo.vwOrganizationAddress
	AS
		
	SELECT    TOP 100 PERCENT s.*,
	          A.AddressScope, 
	          A.Address AS Address1, 
			  A.Address2, 
			  A.AddressCity AS City, 
			  A.AddressRoom, 			  
			  A.AddressPostalCode AS PostalCode, 
			  A.State, 
			  A.Country, 
			  A.Coordinates, 
              A.eMailAddress, 
			  A.Source, 
			  A.Remarks
	FROM      dbo.OrganizationAddress S INNER JOIN System.dbo.Ref_Address A ON S.AddressId = A.AddressId
	ORDER BY  S.PersonNo  
	
	
  </cfquery>
  
<cf_SystemModuleDatabase
   SystemModule    = "Accounting" 
   DatabaseName    = "Accounting"
   MissionTable     = "Ref_ParameterMission">
   
<cf_SystemModuleDatabase
   SystemModule    = "Procurement" 
   DatabaseName    = "Purchase"
   MissionTable     = "Ref_ParameterMission">
   
<cf_SystemModuleDatabase
   SystemModule    = "Warehouse" 
   DatabaseName    = "Materials"
   MissionTable     = "Ref_ParameterMission">     
      
<cf_SystemModuleDatabase
   SystemModule    = "Staffing" 
   DatabaseName    = "Employee"
   MissionTable     = "Ref_ParameterMission">   
        
<cf_SystemModuleDatabase
   SystemModule    = "Program" 
   DatabaseName    = "Program"
   MissionTable     = "Ref_ParameterMission">    
      
<cf_SystemModuleDatabase
   SystemModule    = "Workorder" 
   DatabaseName    = "WorkOrder"
   MissionTable     = "Ref_ParameterMission"> 
    
<cf_SystemModuleDatabase
   SystemModule    = "Payroll" 
   DatabaseName    = "Payroll"
   MissionTable     = "Ref_ParameterMission">    
   
<cf_SystemModuleDatabase
   SystemModule    = "Learning" 
   DatabaseName    = "Learning"
   MissionTable     = "Ref_ParameterMission">           
   
<cf_SystemModuleDatabase
   SystemModule    = "Insurance" 
   DatabaseName    = "CaseFile"
   MissionTable     = "Ref_ParameterMission">        
   
<!--- Listing function --->

<cfquery name="System" 
	datasource="AppsSystem" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	UPDATE    Ref_ModuleControl 
	SET       BrowserSupport = '2'
    WHERE     MenuClass = 'Builder'     
</cfquery>		

<!--- ---- --->
<!--- User --->	
<!--- ---- --->

<cf_ModuleInsertSubmit
   SystemModule      = "AdminUser" 
   FunctionClass     = "User"
   FunctionName      = "User Functions" 
   MenuOrder         = "3"
   MainMenuItem      = "1"
   FunctionMemo      = "Maintain User Functions by Entity"
   FunctionDirectory = "System/Organization/"
   FunctionPath      = "Function/RecordListing.cfm"
   FunctionIcon      = "role"
   ScriptName        = ""
   AccessUserGroup   = "0">  
       
<cf_ModuleInsertSubmit
   SystemModule      = "AdminUser" 
   FunctionClass     = "User"
   FunctionName      = "Grant User Access" 
   MenuOrder         = "4"
   MainMenuItem      = "1"
   FunctionMemo      = "Record and Maintain User Role Access"
   FunctionDirectory = "System/Organization/"
   FunctionPath      = "Access/OrganizationAuthorization.cfm"
   FunctionIcon      = "role"
   ScriptName        = ""
   AccessUserGroup   = "0">    
                
<cf_ModuleInsertSubmit
   SystemModule      = "AdminUser" 
   FunctionClass     = "User"
   FunctionName      = "User Roles" 
   MenuOrder         = "4"
   MainMenuItem      = "1"
   FunctionMemo      = "Record and Maintain User Authorization Roles"
   FunctionDirectory = "System/Access/"
   FunctionPath      = "Role/RecordListing.cfm"
   FunctionIcon      = "role"
   ScriptName        = ""
   AccessUserGroup   = "0">       
     
<cf_ModuleInsertSubmit
   SystemModule      = "AdminUser" 
   FunctionClass     = "User"
   FunctionName      = "System Owners" 
   MenuOrder         = "6"
   MainMenuItem      = "1"
   FunctionMemo      = "Record and Maintain System Owners"
   FunctionDirectory = "System/Parameter/"
   FunctionPath      = "Owner/RecordListing.cfm"
   ScriptName        = ""
   AccessUserGroup   = "0">     
   
    
<cf_ModuleInsertSubmit
   SystemModule      = "AdminUser" 
   FunctionClass     = "User"
   FunctionName      = "Entity functions" 
   MenuOrder         = "6"
   MainMenuItem      = "1"
   FunctionMemo      = "Record and Maintain Entity functions"
   FunctionDirectory = "System/Access/"
   FunctionPath      = "Entity/RecordListing.cfm"
   ScriptName        = ""
   AccessUserGroup   = "0">        
   
<cf_ModuleInsertSubmit
   SystemModule       = "System" 
   FunctionClass      = "UserMaintain"
   FunctionName       = "User Roles" 
   MenuClass          = "Access"
   MenuOrder          = "3"
   MainMenuItem       = "0"
   FunctionMemo       = "User Role Assignment"
   FunctionPath       = ""
   ScriptName         = "orgrole"
   AccessUserGroup    = "1">   

  <cf_ModuleInsertSubmit
   SystemModule       = "System" 
   FunctionClass      = "UserMaintain"
   FunctionName       = "Portal Access" 
   MenuClass          = "Access"
   MenuOrder          = "3"
   MainMenuItem       = "0"
   FunctionMemo       = "User Portal Access"
   FunctionPath       = ""
   ScriptName         = "portal"
   AccessUserGroup    = "0">   
   
	<!--- context menu for user admin --->  
	
	<cf_ModuleInsertSubmit
	   SystemModule       = "System" 
	   FunctionClass      = "UserMaintain"
	   FunctionName       = "Grant Access" 
	   MenuClass          = "Access"
	   MenuOrder          = "1"
	   MainMenuItem       = "0"
	   FunctionMemo       = "Function access"
	   FunctionPath       = ""
	   ScriptName         = "functionaccess"
	   AccessUserGroup    = "1">	 
			
	<cf_ModuleInsertSubmit
	   SystemModule       = "System" 
	   FunctionClass      = "UserMaintain"
	   FunctionName       = "Group Membership" 
	   MenuClass          = "Access"
	   MenuOrder          = "3"
	   MainMenuItem       = "0"
	   FunctionMemo       = "User Group Membership"
	   FunctionPath       = ""
	   ScriptName         = "group"
	   AccessUserGroup    = "1">
					
	<cf_ModuleInsertSubmit
	   SystemModule       = "System" 
	   FunctionClass      = "UserMaintain"
	   FunctionName       = "Report Subscription" 
	   MenuClass          = "Logging"
	   MenuOrder          = "0"
	   MainMenuItem       = "0"
	   FunctionMemo       = "User report subscription"
	   ScriptName         = "variant"
	   AccessUserGroup    = "1">
	   				
	<cf_ModuleInsertSubmit
	   SystemModule       = "System" 
	   FunctionClass      = "UserMaintain"
	   FunctionName       = "User Log Files" 
	   MenuClass          = "Logging"
	   MenuOrder          = "0"
	   MainMenuItem       = "0"
	   FunctionMemo       = "User Activity Summary"
	   ScriptName         = "activity"
	   AccessUserGroup    = "1">
	   
	<cf_ModuleInsertSubmit
	   SystemModule       = "System" 
	   FunctionClass      = "UserMaintain"
	   FunctionName       = "Reset Password" 
	   MenuClass          = "Utility"
	   MenuOrder          = "0"
	   MainMenuItem       = "0"
	   FunctionMemo       = "Reset Password"
	   ScriptName         = "resetpw"
	   AccessUserGroup    = "1">
	   
	<cf_ModuleInsertSubmit
	   SystemModule       = "System" 
	   FunctionClass      = "UserMaintain"
	   FunctionName       = "Batch Access restore" 
	   MenuClass          = "Utility"
	   MenuOrder          = "0"
	   MainMenuItem       = "0"
	   FunctionMemo       = "User Activity Summary"
	   ScriptName         = "accessSet"
	   AccessUserGroup    = "1">      
	   
<!--- ------ --->	   
<!--- Config --->
<!--- ------ --->	
	 
	<cf_ModuleInsertSubmit
	   SystemModule      = "AdminConfig" 
	   FunctionClass     = "Library"
	   FunctionName      = "Applications" 
	   MenuOrder         = "1"
	   MainMenuItem      = "1"
	   FunctionMemo      = "Record and Maintain Applications"
	   FunctionDirectory = "System/Parameter/"
	   FunctionPath      = "Application/RecordListing.cfm"
	   FunctionIcon      = ""
	   ScriptName        = ""
	   AccessUserGroup   = "0">   
	    	
	<cf_ModuleInsertSubmit
	   SystemModule       = "AdminConfig" 
	   FunctionClass      = "Library"
	   FunctionName       = "Module Library" 
	   MenuOrder          = "2"
	   MainMenuItem       = "1"
	   FunctionMemo       = "Maintain System Functions"
	   FunctionIcon       = "dictionary"
	   FunctionTarget     = "blank"
	   ScriptName         = "module"
	   BrowserSupport     = "2"
	   AccessUserGroup    = "1">      
	 
	<cf_ModuleInsertSubmit
	   SystemModule       = "AdminConfig" 
	   FunctionClass      = "Library"
	   FunctionName       = "Collection Configuration" 
	   MenuCLass          = "Main"
	   MenuOrder          = "7"
	   FunctionIcon		  = "Dictionary"
	   MainMenuItem       = "0"
	   FunctionPath       = " ../Modules/Collection/RecordListing.cfm">     
	
	<cf_ModuleInsertSubmit
	   SystemModule       = "AdminConfig" 
	   FunctionClass      = "Library"
	   FunctionName       = "Address Type" 
	   MenuCLass          = "Main"
	   MenuOrder          = "8"
	   FunctionIcon		  = ""
	   MainMenuItem       = "1"
	   FunctionDirectory = "System/Parameter/"
	   FunctionPath       = "AddressType/RecordListing.cfm"> 
	   
	<cf_ModuleInsertSubmit
	   SystemModule       = "AdminConfig" 
	   FunctionClass      = "Documentation"
	   FunctionName       = "Application Code" 
	   MenuOrder          = "10"
	   MainMenuItem       = "1"
	   FunctionMemo       = "Application Code Inquiry"
	   FunctionIcon       = "dictionary"
	   FunctionTarget     = "blank"
	   ScriptName         = "appcode"
	   AccessUserGroup    = "0">   
	      		
	<cf_ModuleInsertSubmit
	   SystemModule       = "AdminConfig" 
	   FunctionClass      = "Documentation"
	   FunctionName       = "Data Dictionary" 
	   MenuOrder          = "11"
	   MainMenuItem       = "1"
	   FunctionMemo       = "Database structure inquiry"
	   FunctionIcon       = "dictionary"
	   FunctionTarget     = "blank"
	   ScriptName         = "dictionary"
	   BrowserSupport     = "2"
	   AccessUserGroup    = "0">
	   
	   <cf_ModuleInsertSubmit
	   SystemModule       = "AdminConfig" 
	   FunctionClass      = "Documentation"
	   FunctionName       = "System Documentation" 
	   MenuOrder          = "12"
	   MainMenuItem       = "0"
	   FunctionMemo       = "Maintain System Function Documentation (UseCase)"
	   FunctionDirectory  = "System/Parameter/"
	   FunctionPath       = "FunctionClass/FunctionView.cfm"
	   FunctionIcon       = "dictionary"
	   FunctionTarget     = "blank"
	   ScriptName         = ""
	   AccessUserGroup    = "0">     
          
      
	  
<!--- System --->	

<cf_ModuleInsertSubmit
   SystemModule    = "System" 
   FunctionClass   = "Utility"
   FunctionName    = "Scheduled Tasks" 
   MenuOrder       = "7"
   MainMenuItem    = "1"
   FunctionMemo    = "Register and Maintain Scheduled Tasks"
   FunctionDirectory = "System/"
   FunctionPath    = "Scheduler/RecordListing.cfm"
   FunctionIcon    = "schedule"
   ScriptName      = ""
   AccessUserGroup = "0">   
   
<cf_ModuleInsertSubmit
   SystemModule    = "System" 
   FunctionClass   = "Utility"
   FunctionName    = "Attachment Settings" 
   MenuOrder       = "9"
   MainMenuItem    = "1"
   FunctionMemo    = "Maintain Document and File Attachment settings"
   FunctionDirectory = "System/Parameter"
   FunctionPath    = "Attachment/RecordListing.cfm"
   FunctionIcon    = "attachment"
   ScriptName      = ""
   AccessUserGroup = "0">      
    
<cf_ModuleInsertSubmit
   SystemModule    = "System" 
   FunctionClass   = "Utility"
   FunctionName    = "Global Documents" 
   MenuOrder       = "8"
   MainMenuItem    = "1"
   FunctionMemo    = "Manage document to be shared through Exchange Server"
   FunctionDirectory = "System/"
   FunctionPath    = "Exchange/DocumentFolder.cfm"   
   ScriptName      = ""
   AccessUserGroup = "0">     
   
  <cf_ModuleInsertSubmit
   SystemModule      = "System" 
   FunctionClass     = "Monitor"
   FunctionName      = "System Notifications" 
   MenuOrder         = "8"
   MainMenuItem      = "1"
   FunctionMemo      = "Review Application Exception Errors"
   FunctionDirectory = "System/"
   FunctionPath      = "Monitor/DataSet.cfm"
   FunctionCondition = "error"
   FunctionIcon      = "Monitor"
   ScriptName        = "monitor"
   AccessUserGroup   = "0">   

<!---	
<cf_ModuleInsertSubmit
   SystemModule    = "System" 
   FunctionClass   = "Utility"
   FunctionName    = "Help Project" 
   MenuOrder       = "6"
   MainMenuItem    = "1"
   FunctionMemo    = "Maintain Internal / Robohelp Help-projects"
   FunctionDirectory = "System/Parameter/"
   FunctionPath    = "HelpProject/RecordListing.cfm"
   FunctionIcon    = "help"
   ScriptName      = ""
   AccessUserGroup = "0">
   --->
   
<cf_ModuleInsertSubmit
   SystemModule       = "System" 
   FunctionClass      = "Utility"
   FunctionName       = "Country and Nationality" 
   MenuOrder          = "6"
   MainMenuItem       = "1"
   FunctionMemo       = "Maintain Country Codes and Nationality"
   FunctionDirectory  = "System/Parameter/"
   FunctionPath       = "Nationality/RecordListing.cfm"   
   ScriptName         = ""
   AccessUserGroup    = "0">   
   
<cf_ModuleInsertSubmit
   SystemModule       = "System" 
   FunctionClass      = "Utility"
   FunctionName       = "Banking Institutions" 
   MenuOrder          = "6"
   MainMenuItem       = "1"
   FunctionMemo       = "Maintain Banking Institutions"
   FunctionDirectory  = "System/Parameter/"
   FunctionPath       = "Bank/RecordListing.cfm"   
   ScriptName         = ""
   AccessUserGroup    = "0">  
   
<cf_ModuleInsertSubmit
   SystemModule       = "System" 
   FunctionClass      = "Utility"
   FunctionName       = "Report Menu Class" 
   MenuOrder          = "7"
   MainMenuItem       = "1"
   FunctionMemo       = "Maintain Report Menuclass Structure"
   FunctionDirectory  = "System/Modules/"
   FunctionPath       = "ReportMenu/RecordListing.cfm"   
   ScriptName         = ""
   AccessUserGroup    = "0">  
   
<cf_ModuleInsertSubmit
   SystemModule       = "System" 
   FunctionClass      = "Utility"
   FunctionName       = "Requests for Amendment" 
   MenuOrder          = "5"
   MainMenuItem       = "1"
   FunctionMemo       = "Register and Manage Code and System Amendments"
   FunctionDirectory  = "System/Modification/"
   FunctionPath       = "ModificationViewView.cfm"
   AccessRole         = "cmofficer"
   AccessRoleLevel    = "0,1,2"
   FunctionIcon       = "code"
   ScriptName         = ""
   AccessUserGroup    = "0">        
         
<cf_ModuleInsertSubmit
   SystemModule       = "System" 
   FunctionClass      = "Utility"
   FunctionName       = "Site servers" 
   MenuOrder          = "8"
   MainMenuItem       = "1"
   FunctionMemo       = "Register and Maintain Application servers within a single System deployment"
   FunctionDirectory  = "System/Parameter/"
   FunctionPath       = "Site/RecordListing.cfm"
   FunctionIcon       = "code"
   ScriptName         = ""
   AccessUserGroup    = "0">   
     
<cf_ModuleInsertSubmit
   SystemModule       = "System" 
   FunctionClass      = "Monitor"
   FunctionName       = "Server Monitoring" 
   MenuOrder          = "6"
   MainMenuItem       = "1"
   FunctionVirtualDir = "CFIDE"
   FunctionMemo       = "Monitor ColdFusion application server"
   FunctionPath       = "/administrator/monitor/launch-monitor.cfm"
   FunctionIcon       = "Monitor"
   FunctionTarget     = "_blank"
   ScriptName         = ""
   BrowserSupport     = "2"
   AccessUserGroup    = "0">     
  
<cf_ModuleInsertSubmit
   SystemModule       = "System" 
   FunctionClass      = "Setting"
   FunctionName       = "Installation Parameters" 
   MenuOrder          = "1"
   MainMenuItem       = "1"
   FunctionMemo       = "Global Installation Parameters"
   FunctionDirectory  = "System/Parameter/"
   FunctionPath       = "ParameterSystemEdit.cfm"
   FunctionIcon       = "parameter"
   ScriptName         = ""
   AccessUserGroup    = "0">           
   
<cf_ModuleInsertSubmit
   SystemModule       = "System" 
   FunctionClass      = "Setting"
   FunctionName       = "Application Server Parameters" 
   MenuOrder          = "2"
   MainMenuItem       = "1"
   FunctionMemo       = "Maintain Parameters specific to this application server"
   FunctionDirectory  = "System/Parameter/"
   FunctionPath       = "ParameterEdit.cfm"
   FunctionIcon       = "parameter"
   ScriptName         = ""
   AccessUserGroup    = "0">  
   

<cf_ModuleInsertSubmit
   SystemModule       = "System" 
   FunctionClass      = "Setting"
   FunctionName       = "Interface Language Configuration" 
   MenuOrder          = "3"
   MainMenuItem       = "1"
   FunctionMemo       = "Define Language Interface"
   FunctionDirectory  = "System/Language/"
   FunctionPath       = "RecordListing.cfm"
   FunctionIcon       = "input"
   ScriptName         = ""
   AccessUserGroup    = "0">   
   

<cf_ModuleInsertSubmit
   SystemModule       = "System" 
   FunctionClass      = "Setting"
   FunctionName       = "Portal Links" 
   MenuOrder          = "4"
   MainMenuItem       = "1"
   FunctionMemo       = "Register Portal announcements and links"
   FunctionDirectory  = "System/Parameter/"
   FunctionPath       = "Portal/RecordListing.cfm"
   FunctionIcon       = "link"
   ScriptName         = ""
   AccessUserGroup    = "0">
              
   	
<cf_ModuleInsertSubmit
   SystemModule       = "System" 
   FunctionClass      = "SourceCode"
   FunctionName       = "Application Source Code" 
   MenuOrder          = "7"
   MainMenuItem       = "0"
   FunctionMemo       = "Application template version control"
   ScriptName         = "template"
   FunctionIcon       = "code"
   FunctionTarget     = "blank"
   AccessUserGroup    = "0">   
     
<cf_ModuleInsertSubmit
   SystemModule       = "System" 
   FunctionClass      = "Utility"
   FunctionName       = "User IP Mapping" 
   MenuOrder          = "10"
   MainMenuItem       = "1"
   FunctionMemo       = "Redirect users to a certain Application Server"
   FunctionDirectory  = "System/Parameter"
   FunctionPath       = "Redirection/IPTable.cfm">   
    
   
<cf_ModuleInsertSubmit
   SystemModule       = "System" 
   FunctionClass      = "Utility"
   FunctionName       = "Maintain OrgUnit Class" 
   MenuClass          = "Main"
   MenuOrder          = "5"
   MainMenuItem       = "0"
   FunctionMemo       = "Maintain OrgUnit Class"
   FunctionDirectory  = "System/Organization"
   FunctionPath       = "Maintenance/OrgUnitClass/RecordListing.cfm">
 
    
<cf_ModuleInsertSubmit
   SystemModule       = "System" 
   FunctionClass      = "Organization"
   FunctionName       = "Memo/Notes" 
   MenuCLass          = "Detail"
   MenuOrder          = "1"
   MainMenuItem       = "0"
   ScriptName         = "memo">         
 
<cf_ModuleInsertSubmit
   SystemModule       = "System" 
   FunctionClass      = "Organization"
   FunctionName       = "Category" 
   MenuCLass          = "Detail"
   MenuOrder          = "2"
   MainMenuItem       = "0"
   ScriptName         = "category">     
   
<cf_ModuleInsertSubmit
   SystemModule       = "System" 
   FunctionClass      = "Organization"
   FunctionName       = "Bank Account" 
   MenuCLass          = "Detail"
   MenuOrder          = "3"
   MainMenuItem       = "0"
   ScriptName         = "account">          
   
<cf_ModuleInsertSubmit
   SystemModule       = "System" 
   FunctionClass      = "Organization"
   FunctionName       = "Credit Terms" 
   MenuCLass          = "Detail"
   MenuOrder          = "4"
   MainMenuItem       = "0"
   ScriptName         = "threshold">                   
    
<cf_ModuleInsertSubmit
   SystemModule       = "System" 
   FunctionClass      = "Organization"
   FunctionName       = "Purchase Order" 
   MenuCLass          = "Provider"
   MenuOrder          = "1"
   MainMenuItem       = "0"
   ScriptName         = "purchase">    
  
<cf_ModuleInsertSubmit
   SystemModule       = "System" 
   FunctionClass      = "Organization"
   FunctionName       = "Invoices" 
   MenuCLass          = "Provider"
   MenuOrder          = "2"
   MainMenuItem       = "0"
   ScriptName         = "invoice">  
   
<cf_ModuleInsertSubmit
   SystemModule       = "System" 
   FunctionClass      = "Organization"
   FunctionName       = "Accounts Payable" 
   MenuCLass          = "Provider"
   MenuOrder          = "3"
   MainMenuItem       = "0"
   ScriptName         = "invoiceAP">     
        
<cf_ModuleInsertSubmit
   SystemModule       = "System" 
   FunctionClass      = "Organization"
   FunctionName       = "Payments" 
   MenuCLass          = "Provider"
   MenuOrder          = "4"
   MainMenuItem       = "0"
   ScriptName         = "invoiceAPpayment">    
   
<cf_ModuleInsertSubmit
   SystemModule       = "System" 
   FunctionClass      = "Organization"
   FunctionName       = "Receipts" 
   MenuCLass          = "Provider"
   MenuOrder          = "5"
   MainMenuItem       = "0"
   ScriptName         = "invoiceAPreceipt">           
   
<cf_ModuleInsertSubmit
   SystemModule       = "System" 
   FunctionClass      = "Organization"
   FunctionName       = "Accounts Receivable" 
   MenuCLass          = "Purchaser"
   MenuOrder          = "6"
   MainMenuItem       = "0"
   ScriptName         = "invoiceAR">     
      
<cf_ModuleInsertSubmit
   SystemModule       = "System" 
   FunctionClass      = "Organization"
   FunctionName       = "Shipping" 
   MenuCLass          = "Purchaser"
   MenuOrder          = "7"
   MainMenuItem       = "0"
   ScriptName         = "invoiceARreceipt">        
  

