
<!--- create views --->

 <cfquery name="Drop"
	datasource="appsEmployee">
      if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[vwPersonAddress]') 
	 and OBJECTPROPERTY(id, N'IsView') = 1)
     drop view [dbo].[vwPersonAddress]
  </cfquery>

  <cfquery name="CreateView"
	datasource="appsEmployee">
	CREATE VIEW dbo.vwPersonAddress
	AS
		
	SELECT    TOP 100 PERCENT s.*,
	          A.AddressScope, 
	          A.Address, 
			  A.Address2, 
			  A.AddressCity, 
			  A.AddressRoom, 			  
			  A.AddressPostalCode, 
			  A.State, 
			  A.Country, 
			  A.Coordinates, 
              A.eMailAddress, 
			  A.Source, 
			  A.Remarks
	FROM      dbo.PersonAddress S INNER JOIN System.dbo.Ref_Address A ON S.AddressId = A.AddressId
	ORDER BY  S.PersonNo  
	
  </cfquery>
 
   
<!--- employee --->

<cf_ModuleInsertSubmit
   SystemModule="Staffing" 
   FunctionClass = "Application"
   FunctionName = "Staffing table" 
   MenuClass = "Mission"
   MenuOrder = "1"
   MainMenuItem = "1"
   FunctionTarget = "Mission"
   FunctionMemo = "Manage Staffing Table"
   FunctionDirectory = "Staffing/Reporting"
   FunctionPath = "PostView/Staffing/PostView.cfm"> 
   
<cf_ModuleInsertSubmit
   SystemModule="Attendance" 
   FunctionClass = "Application"
   FunctionName = "Attendance" 
   MenuClass = "Mission"
   MenuOrder = "1"
   MainMenuItem = "1"
   FunctionTarget = "Mission"
   FunctionMemo = "Manage Attendance"
   FunctionDirectory = "Attendance/Application"
   FunctionPath = "TimeView/View.cfm">    

<cf_ModuleInsertSubmit
   SystemModule="Staffing" 
   FunctionClass = "System"
   FunctionName = "Staffing Table Verification" 
   MenuClass = "Main"
   MenuOrder = "1"
   MainMenuItem = "1"
   FunctionMemo = "Review Consistency Parent Position, Positions and Assignments"
   FunctionPath = "../Application/Tools/VerifyStaffingTable.cfm"
   FunctionIcon = "Review">   

<!--- -------- --->
<!--- History- --->
<!--- -------- --->
   
<cf_ModuleInsertSubmit
   SystemModule="Staffing" 
   FunctionClass = "Employee"
   FunctionName = "Profile" 
   MenuClass = "General"
   MenuOrder = "4"
   MainMenuItem = "0"
   FunctionMemo = "Profile"
   ScriptName = "profile"
   AccessRole = "ContractManager"
   FunctionIcon = "Maintain"> 
   
<cf_ModuleInsertSubmit
   SystemModule="Staffing" 
   FunctionClass = "Employee"
   FunctionName = "Request" 
   MenuClass = "History"
   MenuOrder = "1"
   MainMenuItem = "0"
   FunctionMemo = "Request"
   ScriptName = "request"
   FunctionIcon = "Maintain">             
   
<cf_ModuleInsertSubmit
   SystemModule="Staffing" 
   FunctionClass = "Employee"
   FunctionName = "Leave" 
   MenuClass = "History"
   MenuOrder = "5"
   MainMenuItem = "0"
   FunctionMemo = "Profile"
   ScriptName = "leave"
   AccessRole = "ContractManager"
   FunctionIcon = "Maintain">          
    
<cf_ModuleInsertSubmit
   SystemModule="Staffing" 
   FunctionClass = "Employee"
   FunctionName = "Actions Log" 
   MenuClass = "History"
   MenuOrder = "1"
   MainMenuItem = "0"
   FunctionMemo = "Profile"
   ScriptName = "paction"
   AccessRole = "ContractManager"
   FunctionIcon = "Maintain">  
   
<cf_ModuleInsertSubmit
   SystemModule="Staffing" 
   FunctionClass = "Employee"
   FunctionName = "Historical Actions" 
   MenuClass = "History"
   MenuOrder = "2"
   MainMenuItem = "0"
   FunctionMemo = "Profile"
   ScriptName = "phistory"
   AccessRole = "ContractManager"
   FunctionIcon = "Maintain">     
   
<!--- --------- ---> 
<!--- applicant --->
<!--- --------- --->

<cf_ModuleInsertSubmit
   SystemModule="Staffing" 
   FunctionClass = "Employee"
   FunctionName = "Candidate Profile" 
   MenuClass = "applicant"
   MenuOrder = "1"
   MainMenuItem = "0"   
   FunctionMemo = "PHP profile"
   AccessRole = "ContractManager"
   ScriptName = "php">    
   
<!--- -------- --->   
<!--- Learning --->
<!--- -------- --->    

<cf_ModuleInsertSubmit
   SystemModule="Staffing" 
   FunctionClass = "Employee"
   FunctionName = "ePAS" 
   MenuClass = "Learning"
   MenuOrder = "1"
   MainMenuItem = "0"
   FunctionMemo = "ePas"
   ScriptName = "ePas"
   FunctionIcon = "Maintain">        
            
<cf_ModuleInsertSubmit
   SystemModule="Staffing" 
   FunctionClass = "Employee"
   FunctionName = "Courses" 
   MenuClass = "Learning"
   MenuOrder = "2"
   MainMenuItem = "0"
   FunctionMemo = "Learning"
   AccessRole = "ContractManager"
   ScriptName = "course"
   FunctionIcon = "Maintain">          
   
<!--- ------------- --->   
<!--- Used Resource --->
<!--- ------------- --->      
      
<cf_ModuleInsertSubmit
   SystemModule="Staffing" 
   FunctionClass = "Employee"
   FunctionName = "Equipment" 
   MenuClass = "Resource"
   MenuOrder = "1"
   MainMenuItem = "0"
   FunctionMemo = "Equipment"
   ScriptName = "asset"
   FunctionIcon = "Maintain">    
    
<cf_ModuleInsertSubmit
   SystemModule="Staffing" 
   FunctionClass = "Employee"
   FunctionName = "Services" 
   MenuClass = "Resource"
   MenuOrder = "2"
   MainMenuItem = "0"
   FunctionMemo = "Services"
   ScriptName = "workorder"
   FunctionIcon = "Maintain">   
   
<cf_ModuleInsertSubmit
   SystemModule="Staffing" 
   FunctionClass = "Employee"
   FunctionName = "Case Files" 
   MenuClass = "Resource"
   MenuOrder = "3"
   MainMenuItem = "0"
   FunctionMemo = "Case File"
   ScriptName = "casefile"
   FunctionIcon = "Maintain">       
   
<cf_ModuleInsertSubmit
   SystemModule="Staffing" 
   FunctionClass = "Employee"
   FunctionName = "Payments" 
   MenuClass = "Resource"
   MenuOrder = "4"
   MainMenuItem = "0"
   FunctionMemo = "ledger"
   AccessRole = "ContractManager"
   ScriptName = "ledger"
   FunctionIcon = "Maintain">           
   
<!--- ------------ --->   
<!--- Miscellaneos --->
<!--- ------------ --->
      
<cf_ModuleInsertSubmit
   SystemModule="Staffing" 
   FunctionClass = "Employee"
   FunctionName = "Status and Actions" 
   MenuClass = "Miscellaneous"
   MenuOrder = "0"
   MainMenuItem = "0"
   FunctionMemo = "Status and Actions"
   ScriptName = "personevent"
   FunctionIcon = "Maintain">       
   
<!---     
      
<cf_ModuleInsertSubmit
   SystemModule="Staffing" 
   FunctionClass = "Employee"
   FunctionName = "Appointment" 
   MenuClass = "Miscellaneous"
   MenuOrder = "1"
   MainMenuItem = "0"
   FunctionMemo = "Appointment"
   AccessRole = "ContractManager"
   ScriptName = "appointment"
   FunctionIcon = "Maintain">  
   
   --->
     
<cf_ModuleInsertSubmit
   SystemModule="Staffing" 
   FunctionClass = "Employee"
   FunctionName = "Dependents" 
   MenuClass = "Miscellaneous"
   MenuOrder = "1"
   MainMenuItem = "0"
   FunctionMemo = "Dependents"
   AccessRole = "ContractManager"
   ScriptName = "dependent"
   FunctionIcon = "Maintain"> 
   
<cf_ModuleInsertSubmit
   SystemModule="Staffing" 
   FunctionClass = "Employee"
   FunctionName = "Performance Appraisal" 
   MenuClass = "Miscellaneous"
   MenuOrder = "1"
   MainMenuItem = "0"
   FunctionMemo = "PAS"
   AccessRole = "ContractManager"
   ScriptName = "pas"
   FunctionIcon = "Maintain">    
   
<cf_ModuleInsertSubmit
   SystemModule="Staffing" 
   FunctionClass = "Employee"
   FunctionName = "Document" 
   MenuClass = "Miscellaneous"
   MenuOrder = "1"
   MainMenuItem = "0"
   FunctionMemo = "Document"
   AccessRole = "ContractManager"
   ScriptName = "issueddocument"
   FunctionIcon = "Maintain">   
 
      
<cf_ModuleInsertSubmit
   SystemModule="Staffing" 
   FunctionClass = "Application"
   FunctionName = "ePAS Status" 
   MenuClass = "Main"
   MenuOrder = "7"
   MainMenuItem = "1"
   FunctionMemo = "Review ePas issuance"
   FunctionPath = "../../ProgramREM/Reporting/Epas/SummaryBase.cfm"
   FunctionIcon = "Inquiry">  
   
<!--- ----------- --->   
<!--- maintenance ---> 
<!--- ----------- --->
         
<cf_ModuleInsertSubmit
   SystemModule="Staffing" 
   FunctionClass = "Maintain"
   FunctionName = "Appointment Type" 
   MenuClass = "Employee"
   MenuOrder = "1"
   MainMenuItem = "1"
   BrowserSupport = "2"
   FunctionMemo = "Maintain Contract Appointment Types"
   FunctionDirectory="Staffing/Maintenance"
   FunctionPath = "AppointmentType/RecordListing.cfm"
   FunctionIcon = "Maintain">    
   
<cf_ModuleInsertSubmit
   SystemModule="Staffing" 
   FunctionClass = "Maintain"
   FunctionName = "Document type" 
   MenuClass = "Employee"
   MenuOrder = "2"
   MainMenuItem = "1"
   BrowserSupport = "2"
   FunctionMemo = "Maintain Document Types"
   FunctionDirectory="Staffing/Maintenance"
   FunctionPath = "DocumentType/RecordListing.cfm"
   FunctionIcon = "Maintain">         
   
<cf_ModuleInsertSubmit
   SystemModule="Staffing" 
   FunctionClass = "Maintain"
   FunctionName = "Salary scales" 
   MenuClass = "Employee"
   MenuOrder = "3"
   MainMenuItem = "1"
   FunctionMemo = "Edit Salary Scales"
   FunctionDirectory="Payroll/Maintenance"
   FunctionPath = "SalarySchedule/RecordListing.cfm"
   FunctionIcon = "Maintain">    
   
<cf_ModuleInsertSubmit
   SystemModule="Staffing" 
   FunctionClass = "Maintain"
   FunctionName = "Relationship" 
   MenuClass = "Employee"
   MenuOrder = "4"
   MainMenuItem = "1"
   FunctionMemo = "Maintain relationships"
   BrowserSupport = "2"
   FunctionDirectory="Staffing/Maintenance"
   FunctionPath = "Relationship/RecordListing.cfm"
   FunctionIcon = "Maintain">   
     
  <cf_ModuleInsertSubmit
   SystemModule="Staffing" 
   FunctionClass = "Maintain"
   FunctionName = "Person Classification" 
   MenuClass = "Employee"
   MenuOrder = "5"
   MainMenuItem = "1"
   BrowserSupport = "2"
   FunctionMemo = "Main Custom Fields for Employee"
   FunctionDirectory="Staffing/Maintenance"
   FunctionPath = "PersonClassification/RecordListing.cfm"
   FunctionIcon = "Maintain">     
   
<cf_ModuleInsertSubmit
   SystemModule="Staffing" 
   FunctionClass = "Maintain"
   FunctionName = "Contract Type" 
   MenuClass = "Employee"
   MenuOrder = "6"
   MainMenuItem = "1"
   BrowserSupport = "2"
   FunctionMemo = "Maintain Contract Types"
   FunctionDirectory="Staffing/Maintenance"
   FunctionPath = "ContractType/RecordListing.cfm"
   FunctionIcon = "Maintain">  
  
<cf_ModuleInsertSubmit
   SystemModule="Staffing" 
   FunctionClass = "Maintain"
   FunctionName = "Address Type" 
   MenuClass = "Employee"
   MenuOrder = "7"
   MainMenuItem = "1"
   BrowserSupport = "2"
   FunctionMemo = "Maintain Address Classes"
   FunctionDirectory="Staffing/Maintenance"
   FunctionPath = "AddressType/RecordListing.cfm"
   FunctionIcon = "Maintain">  
   
<cf_ModuleInsertSubmit
   SystemModule="Staffing" 
   FunctionClass = "Maintain"
   FunctionName = "Building" 
   MenuClass = "Employee"
   MenuOrder = "8"
   MainMenuItem = "1"
   BrowserSupport = "2"
   FunctionMemo = "Maintain Buildings"
   FunctionDirectory="Staffing/Maintenance"
   FunctionPath = "Building/RecordListing.cfm"
   FunctionIcon = "Maintain">     
   
<cf_ModuleInsertSubmit
   SystemModule="Staffing" 
   FunctionClass = "Maintain"
   FunctionName = "Address Zone" 
   MenuClass = "Employee"
   MenuOrder = "8"
   MainMenuItem = "1"
   BrowserSupport = "2"
   FunctionMemo = "Maintain Address Zones"
   FunctionDirectory="Staffing/Maintenance"
   FunctionPath = "AddressZone/RecordListing.cfm"
   FunctionIcon = "Maintain">  
   
<!--- -------------------------- ---> 

<cf_ModuleInsertSubmit
   SystemModule="Staffing" 
   FunctionClass = "Maintain"
   FunctionName = "Post Type" 
   MenuClass = "Staffing"
   MenuOrder = "1"
   MainMenuItem = "1"
   BrowserSupport = "2"
   FunctionMemo = "Maintain Position Type"
   FunctionDirectory="Staffing/Maintenance"
   FunctionPath = "PostType/RecordListing.cfm"
   FunctionIcon = "Maintain">    
 
<cf_ModuleInsertSubmit
   SystemModule="Staffing" 
   FunctionClass = "Maintain"
   FunctionName = "Post Class" 
   MenuClass = "Staffing"
   MenuOrder = "2"
   MainMenuItem = "1"
   BrowserSupport = "2"
   FunctionMemo = "Maintain Position Classes"
   FunctionDirectory="Staffing/Maintenance"
   FunctionPath = "PostClass/RecordListing.cfm"
   FunctionIcon = "Maintain">  
   
<cf_ModuleInsertSubmit
   SystemModule="Staffing" 
   FunctionClass = "Maintain"
   FunctionName = "Vacancy Class" 
   MenuClass = "Staffing"
   MenuOrder = "3"
   MainMenuItem = "1"
   BrowserSupport = "2"
   FunctionMemo = "Maintain Position Vacancy Classes"
   FunctionDirectory="Staffing/Maintenance"
   FunctionPath = "VacancyClass/RecordListing.cfm"
   FunctionIcon = "Maintain">        
   
<cf_ModuleInsertSubmit
   SystemModule="Staffing" 
   FunctionClass = "Maintain"
   FunctionName = "Location" 
   MenuClass = "Staffing"
   MenuOrder = "4"
   MainMenuItem = "1"
   BrowserSupport = "2"
   FunctionMemo = "Maintain Geographical Locations"
   FunctionDirectory="Staffing/Maintenance"
   FunctionPath = "Location/RecordListing.cfm"
   FunctionIcon = "Maintain">  
   
<cf_ModuleInsertSubmit
   SystemModule="Staffing" 
   FunctionClass = "Maintain"
   FunctionName = "Postgrade Parent" 
   MenuClass = "Staffing"
   MenuOrder = "5"
   MainMenuItem = "1"
   BrowserSupport = "2"
   FunctionMemo = "Maintain Post Parent Levels"
   FunctionDirectory="Staffing/Maintenance"
   FunctionPath = "PostGradeParent/RecordListing.cfm"
   FunctionIcon = "Maintain">  
  

<cf_ModuleInsertSubmit
   SystemModule="Staffing" 
   FunctionClass = "Maintain"
   FunctionName = "Post Grade" 
   MenuClass = "Staffing"
   MenuOrder = "6"
   MainMenuItem = "1"
   BrowserSupport = "2"
   FunctionMemo = "Maintain Position Grades"
   FunctionDirectory="Staffing/Maintenance"
   FunctionPath = "PostGrade/RecordListing.cfm"
   FunctionIcon = "Maintain">    
   

<cf_ModuleInsertSubmit
   SystemModule="Staffing" 
   FunctionClass = "Maintain"
   FunctionName = "Position Classification" 
   MenuClass = "Staffing"
   MenuOrder = "7"
   MainMenuItem = "1"
   BrowserSupport = "2"
   FunctionMemo = "Maintain Position Grouping"
   FunctionDirectory="Staffing/Maintenance"
   FunctionPath = "PositionGroup/RecordListing.cfm"
   FunctionIcon = "Maintain">    
   
<cf_ModuleInsertSubmit
   SystemModule="Staffing" 
   FunctionClass = "Maintain"
   FunctionName = "Assignment type" 
   MenuClass = "Staffing"
   MenuOrder = "8"
   MainMenuItem = "1"
   BrowserSupport = "2"
   FunctionMemo = "Maintain Position Type (actual etc.)"
   FunctionDirectory="Staffing/Maintenance"
   FunctionPath = "AssignmentType/RecordListing.cfm"
   FunctionIcon = "Maintain">  
   
<cf_ModuleInsertSubmit
   SystemModule="Staffing" 
   FunctionClass = "Maintain"
   FunctionName = "Assignment Class" 
   MenuClass = "Staffing"
   MenuOrder = "9"
   MainMenuItem = "1"
   BrowserSupport = "2"
   FunctionMemo = "Maintain Assignment Class"
   FunctionDirectory="Staffing/Maintenance"
   FunctionPath = "AssignmentClass/RecordListing.cfm"
   FunctionIcon = "Maintain">    
   
<cf_ModuleInsertSubmit
   SystemModule="Staffing" 
   FunctionClass = "System"
   FunctionName = "Personnel Actions" 
   MenuClass = "Main"
   MenuOrder = "10"
   MainMenuItem = "1"
   BrowserSupport = "2"
   FunctionMemo = "Personnel Action Reference table"
   FunctionDirectory="Staffing/Maintenance"
   FunctionPath = "Action/RecordListing.cfm"
   FunctionIcon = "Maintain">    
   
<cf_ModuleInsertSubmit
   SystemModule="Staffing" 
   FunctionClass = "Maintain"
   FunctionName = "Schedule class" 
   MenuClass = "Staffing"
   MenuOrder = "21"
   MainMenuItem = "1"
   BrowserSupport = "2"
   FunctionMemo = "Maintain Schedule classes (night, day etc.)"
   FunctionDirectory="Staffing/Maintenance"
   FunctionPath = "ScheduleClass/RecordListing.cfm"
   FunctionIcon = "Maintain">           
          

<cf_ModuleInsertSubmit
   SystemModule="Staffing" 
   FunctionClass = "Application"
   FunctionName = "Quick Locate Staffmember" 
   MenuClass = "Main"
   MenuOrder = "1"
   MainMenuItem = "1"
   BrowserSupport = "2"
   FunctionMemo = "Locate staffmember"
   FunctionDirectory="Staffing/Application"
   FunctionPath = "Employee/PersonSearch1.cfm"
   FunctionIcon = "admin">  


   <cf_ModuleInsertSubmit
   SystemModule="Staffing" 
   FunctionClass = "Maintain"
   FunctionName = "Person Event Triggers" 
   MenuClass = "Staffing"
   MenuOrder = "10"
   MainMenuItem = "1"
   BrowserSupport = "2"
   FunctionMemo = "Maintain Person Event Triggers and combinations"
   FunctionDirectory="Staffing/Maintenance"
   FunctionPath = "PersonEventTrigger/RecordListing.cfm"
   FunctionIcon = "Maintain">       
   
<cf_ModuleInsertSubmit
   SystemModule="Staffing" 
   FunctionClass = "Maintain"
   FunctionName = "Person Events" 
   MenuClass = "Staffing"
   MenuOrder = "11"
   MainMenuItem = "1"
   BrowserSupport = "2"
   FunctionMemo = "Maintain Person events"
   FunctionDirectory="Staffing/Maintenance"
   FunctionPath = "PersonEvent/RecordListing.cfm"
   FunctionIcon = "Maintain">         
          
        
<cf_ModuleInsertSubmit
   SystemModule="Staffing" 
   FunctionClass = "Maintain"
   FunctionName = "Person Topics" 
   MenuClass = "Staffing"
   MenuOrder = "11"
   MainMenuItem = "1"
   FunctionMemo = "Person topics and list of values"
   FunctionDirectory = "Staffing/Maintenance"
   FunctionPath = "PersonTopic/RecordListing.cfm"   
   AccessUserGroup = "0">        
   
   
<cf_ModuleInsertSubmit
   SystemModule  ="Staffing" 
   FunctionClass = "Maintain"
   FunctionName  = "Contact Types" 
   MenuClass = "Employee"
   MenuOrder = "12"
   MainMenuItem = "1"
   FunctionMemo = "Maintain Contact Types"
   FunctionDirectory = "Staffing/Maintenance"
   FunctionPath = "ContactType/RecordListing.cfm"   
   AccessUserGroup = "0">           

<!--- payroll --->

<cf_ModuleInsertSubmit
   SystemModule="Staffing" 
   FunctionClass = "Maintain"
   FunctionName = "Designation" 
   MenuClass    = "Payroll"
   MenuOrder    = "1"
   MainMenuItem = "1"
   FunctionMemo = "Maintain Designations"
   FunctionDirectory = "Payroll/Maintenance"
   FunctionPath = "Designation/RecordListing.cfm"
   FunctionIcon = "Maintain">      
      
<cf_ModuleInsertSubmit
   SystemModule  = "Staffing" 
   FunctionClass = "Maintain"
   FunctionName = "Payroll Locations" 
   MenuClass    = "Payroll"
   MenuOrder    = "2"
   MainMenuItem = "1"
   FunctionMemo = "Maintain Payroll Location and Designations"
   FunctionDirectory = "Payroll/Maintenance"
   FunctionPath = "Location/RecordListing.cfm"
   FunctionIcon = "Maintain">    
   
<!--- matrix action --->  
    
<cf_ModuleInsertSubmit
   SystemModule  = "Staffing" 
   FunctionClass = "Inquiry"
   FunctionName  = "Personnel Events" 
   MenuClass     = "Action"
   MenuOrder     = "1"
   MainMenuItem  = "0"
   FunctionMemo  = "Inquiry Personnel Events"
   ScriptName    = "personevent">     
   
<cf_ModuleInsertSubmit
   SystemModule  = "Staffing" 
   FunctionClass = "Inquiry"
   FunctionName  = "Assignments" 
   MenuClass     = "Action"
   MenuOrder     = "1"
   MainMenuItem  = "0"
   FunctionMemo  = "Inquiry Assignments"
   ScriptName    = "personassignment">        

<cf_ModuleInsertSubmit
   SystemModule  = "Staffing" 
   FunctionClass = "Inquiry"
   FunctionName  = "Personnel Actions" 
   MenuClass     = "Action"
   MenuOrder     = "1"
   MainMenuItem  = "0"
   FunctionMemo  = "Inquiry Personnel Action"
   ScriptName    = "personaction">        
             
   
   