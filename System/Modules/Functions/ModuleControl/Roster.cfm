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
	   
<cf_ModuleInsertSubmit
   SystemModule="Roster" 
   FunctionClass = "Roster"
   FunctionName = "Roster Status Cube" 
   MenuClass = "Main"
   MenuOrder = "6"
   MainMenuItem = "0"
   FunctionMemo = "Roster Status Inquiry Dataset"
   FunctionDirectory = "Roster/RosterGeneric/"
   FunctionPath = "DataSet.cfm"
   ScriptName = ""
   AccessUserGroup = "1">   
   
<cf_ModuleInsertSubmit
   SystemModule="Roster" 
   FunctionClass = "Roster"
   FunctionName = "Candidate Communicator" 
   MenuClass = "Main"
   MenuOrder = "6"
   MainMenuItem = "0"
   FunctionMemo = "Exchanges Messages with Rostered Candidates"
   FunctionDirectory = "Roster/RosterGeneric/"
   FunctionPath = "Messaging/MessagingView.cfm"
   ScriptName = ""
   AccessUserGroup = "1">      
      
<cf_ModuleInsertSubmit
   SystemModule="Roster" 
   FunctionClass = "Roster"
   FunctionName = "Roster Forecast" 
   MenuClass = "Main"
   MenuOrder = "7"
   MainMenuItem = "0"
   FunctionMemo = "Roster levels Decision Support"
   FunctionDirectory = "Roster/RosterSpecial/"
   FunctionPath = "RosterForecast/ForecastView.cfm"
   ScriptName = ""
   AccessUserGroup = "1">      
   
<!--- System --->   
      
<cf_ModuleInsertSubmit
   SystemModule  = "Roster" 
   FunctionClass = "System"
   FunctionName  = "Owner Parameters and Roster Status" 
   MenuClass     = "Main"
   MenuOrder     = "1"
   MainMenuItem  = "1"
   FunctionIcom  = "parameter"
   FunctionMemo  = "Maintain Roster Parameters and Roster Processing status"
   FunctionDirectory = "Roster/Maintenance/"
   FunctionPath  = "Parameter/ParameterEdit.cfm"
   ScriptName    = ""
   AccessUserGroup = "1">          
   
<!--- maintenance bucket --->
	   
<cf_ModuleInsertSubmit
   SystemModule="Roster" 
   FunctionClass = "Maintain"
   FunctionName = "Roster Edition Class" 
   MenuClass = "Bucket"
   MenuOrder = "1"
   MainMenuItem = "1"
   FunctionMemo = "Maintain Roster Edition Class"
   FunctionDirectory = "Roster/Maintenance/"
   FunctionPath = "ExerciseClass/RecordListing.cfm"
   ScriptName = ""
   AccessUserGroup = "1">      
      
<cf_ModuleInsertSubmit
   SystemModule="Roster" 
   FunctionClass = "Maintain"
   FunctionName = "Roster Edition" 
   MenuClass = "Bucket"
   MenuOrder = "2"
   MainMenuItem = "1"
   FunctionMemo = "Maintain Roster Edition"
   FunctionDirectory = "Roster/Maintenance/"
   FunctionPath = "rosteredition/RecordListing.cfm"
   ScriptName = ""
   AccessUserGroup = "1">    
           
<cf_ModuleInsertSubmit
   SystemModule="Roster" 
   FunctionClass = "Maintain"
   FunctionName = "Occupational Group" 
   MenuClass = "Bucket"
   MenuOrder = "3"
   MainMenuItem = "1"
   FunctionMemo = "Maintain Occupational Groups"
   FunctionDirectory = "Roster/Maintenance/"
   FunctionPath = "occgroup/RecordListing.cfm"
   ScriptName = ""
   AccessUserGroup = "1">   
        
<cf_ModuleInsertSubmit
   SystemModule="Roster" 
   FunctionClass = "System"
   FunctionName = "Functional Titles" 
   MenuClass = "Main"
   MenuOrder = "1"
   MainMenuItem = "1"
   FunctionMemo = "Maintain Functional Titles and Buckets"
   FunctionDirectory = "Roster/Maintenance/"
   FunctionPath = "FunctionalTitles/RecordSearch.cfm"
   ScriptName = ""
   AccessUserGroup = "1">           
      
<cf_ModuleInsertSubmit
   SystemModule="Roster" 
   FunctionClass = "System"
   FunctionName = "Source" 
   MenuClass = "Main"
   MenuOrder = "2"
   MainMenuItem = "1"
   FunctionMemo = "Maintain Submission Sources"
   FunctionDirectory = "Roster/Maintenance/"
   FunctionPath = "Source/RecordListing.cfm"
   ScriptName = ""
   AccessUserGroup = "1">     
	  
<cf_ModuleInsertSubmit
   SystemModule="Roster" 
   FunctionClass = "Maintain"
   FunctionName = "Job Profile Descriptives" 
   MenuClass = "Bucket"
   MenuOrder = "4"
   MainMenuItem = "1"
   FunctionMemo = "Maintain Job Profile and Vacancy Text entry sections"
   FunctionDirectory = "Roster/Maintenance/"
   FunctionPath = "TextArea/RecordListing.cfm"
   ScriptName = ""
   AccessUserGroup = "1">      
     
<cf_ModuleInsertSubmit
   SystemModule="Roster" 
   FunctionClass = "Maintain"
   FunctionName = "Deployment Levels" 
   MenuClass = "Bucket"
   MenuOrder = "5"
   MainMenuItem = "1"
   FunctionMemo = "Maintain Bucket Deployment Level"
   FunctionDirectory = "Roster/Maintenance/"
   FunctionPath = "Deployment/RecordListing.cfm"
   ScriptName = ""
   AccessUserGroup = "1">        
       
<cf_ModuleInsertSubmit
   SystemModule="Roster" 
   FunctionClass = "Maintain"
   FunctionName = "Bucket Organizational Areas" 
   MenuClass = "Bucket"
   MenuOrder = "6"
   MainMenuItem = "1"
   FunctionMemo = "Maintain Bucket Organizational Area"
   FunctionDirectory = "Roster/Maintenance/"
   FunctionPath = "FunctionOrganization/RecordListing.cfm"
   ScriptName = ""
   AccessUserGroup = "1">   
        
<cf_ModuleInsertSubmit
   SystemModule="Roster" 
   FunctionClass = "Maintain"
   FunctionName = "Functional Title Class" 
   MenuClass = "Bucket"
   MenuOrder = "7"
   MainMenuItem = "1"
   FunctionMemo = "Maintain Functional Title Classes"
   FunctionDirectory = "Roster/Maintenance/"
   FunctionPath = "FunctionClass/RecordListing.cfm"
   ScriptName = ""
   AccessUserGroup = "1">         
        
<cf_ModuleInsertSubmit
   SystemModule="Roster" 
   FunctionClass = "Maintain"
   FunctionName = "Functional Title Classification" 
   MenuClass = "Bucket"
   MenuOrder = "8"
   MainMenuItem = "1"
   FunctionMemo = "Maintain Functional Title Classification Codes"
   FunctionDirectory = "Roster/Maintenance/"
   FunctionPath = "FunctionClassification/RecordListing.cfm"
   ScriptName = ""
   AccessUserGroup = "1">      
     	 
<!--- PHP and recruitment --->	 
          
<cf_ModuleInsertSubmit
   SystemModule="Roster" 
   FunctionClass = "Maintain"
   FunctionName = "Submission Questions or Skill" 
   MenuClass = "PHP"
   MenuOrder = "1"
   MainMenuItem = "1"
   FunctionMemo = "Maintain question topics for Experience / Skill / Medical entry"
   FunctionDirectory = "Roster/Maintenance/"
   FunctionPath = "Topics/RecordListing.cfm"
   ScriptName = ""
   AccessUserGroup = "1">         
       
<cf_ModuleInsertSubmit
   SystemModule="Roster" 
   FunctionClass = "Maintain"
   FunctionName = "Background Contact" 
   MenuClass = "PHP"
   MenuOrder = "1"
   MainMenuItem = "1"
   FunctionMemo = "Define types of relevant contacts"
   FunctionDirectory = "Roster/Maintenance/"
   FunctionPath = "ContactClass/RecordListing.cfm"
   ScriptName = ""
   AccessUserGroup = "1">  
   
   <cf_ModuleInsertSubmit
   SystemModule="Roster" 
   FunctionClass = "Maintain"
   FunctionName = "Salutation" 
   MenuClass = "PHP"
   MenuOrder = "8"
   MainMenuItem = "1"
   FunctionMemo = "Person Salulations"
   FunctionDirectory = "Roster/Maintenance/"
   FunctionPath = "Salutation/RecordListing.cfm"
   ScriptName = ""
   AccessUserGroup = "1">                            
          
<cf_ModuleInsertSubmit
   SystemModule="Roster" 
   FunctionClass = "Maintain"
   FunctionName = "Background Call Sign" 
   MenuClass = "PHP"
   MenuOrder = "2"
   MainMenuItem = "1"
   FunctionMemo = "Maintain lookup for type of contact"
   FunctionDirectory = "Roster/Maintenance/"
   FunctionPath = "Contact/RecordListing.cfm"
   ScriptName = ""
   AccessUserGroup = "1">      
          
<cf_ModuleInsertSubmit
   SystemModule="Roster" 
   FunctionClass = "Maintain"
   FunctionName = "PHP Experience Keywords" 
   MenuClass = "PHP"
   MenuOrder = "3"
   MainMenuItem = "1"
   FunctionMemo = "Maintain Keywords for Education and Workexperience"
   FunctionDirectory = "Roster/Maintenance/"
   FunctionPath = "KeywordClass/RecordListing.cfm"
   ScriptName = ""
   AccessUserGroup = "1"> 
      
<cf_ModuleInsertSubmit
   SystemModule="Roster" 
   FunctionClass = "Maintain"
   FunctionName = "Maintain Bucket Rules" 
   MenuClass = "Roster"
   MenuOrder = "4"
   MainMenuItem = "1"
   FunctionMemo = "Maintain Bucket Business Rules"
   FunctionDirectory = "Roster/Maintenance/"
   FunctionPath = "BusinessRule/RecordListing.cfm"
   ScriptName = ""
   AccessUserGroup = "1">   
             
<cf_ModuleInsertSubmit
   SystemModule="Roster" 
   FunctionClass = "Maintain"
   FunctionName = "Candidate Class (Internal/External)" 
   MenuClass = "Roster"
   MenuOrder = "4"
   MainMenuItem = "1"
   FunctionMemo = "Maintain candidate Class"
   FunctionDirectory = "Roster/Maintenance/"
   FunctionPath = "ApplicantClass/RecordListing.cfm"
   ScriptName = ""
   AccessUserGroup = "1">                 
            
<cf_ModuleInsertSubmit
   SystemModule="Roster" 
   FunctionClass = "Maintain"
   FunctionName = "Candidate Priority Status" 
   MenuClass = "Roster"
   MenuOrder = "5"
   MainMenuItem = "1"
   FunctionMemo = "Maintain candidate Priority status"
   FunctionDirectory = "Roster/Maintenance/"
   FunctionPath = "PersonStatus/RecordListing.cfm"
   ScriptName = ""
   AccessUserGroup = "1">           
   
   
<!--- roster processing --->  
   
<cf_ModuleInsertSubmit
   SystemModule="Roster" 
   FunctionClass = "Maintain"
   FunctionName = "Bucket Access" 
   MenuClass = "Roster"
   MenuOrder = "1"
   MainMenuItem = "1"
   FunctionIcon = "access"
   FunctionMemo = "Grant Access to processing of bucket"
   ScriptName = "rosteraccess"
   AccessUserGroup = "1">    
       
<cf_ModuleInsertSubmit
   SystemModule="Roster" 
   FunctionClass = "Maintain"
   FunctionName = "Roster Decision Keywords" 
   MenuClass = "Roster"
   MenuOrder = "2"
   MainMenuItem = "1"
   FunctionMemo = "Define Roster Decision support keywords"
   FunctionDirectory = "Roster/Maintenance/"
   FunctionPath = "RosterDecision/RecordListing.cfm"  
   AccessUserGroup = "1">       
          
<cf_ModuleInsertSubmit
   SystemModule="Roster" 
   FunctionClass = "Maintain"
   FunctionName = "Candidate Review Areas" 
   MenuClass = "Roster"
   MenuOrder = "2"
   MainMenuItem = "1"
   FunctionMemo = "Maintain Candidate Review Areas"
   FunctionDirectory = "Roster/Maintenance/"
   FunctionPath = "ReviewClass/RecordListing.cfm"
   ScriptName = ""
   AccessUserGroup = "1">              
        
<cf_ModuleInsertSubmit
   SystemModule="Roster" 
   FunctionClass = "Maintain"
   FunctionName = "Comptetences" 
   MenuClass = "Roster"
   MenuOrder = "3"
   MainMenuItem = "1"
   FunctionMemo = "Maintain Roster Process Competences"
   FunctionDirectory = "Roster/Maintenance/"
   FunctionPath = "Competence/RecordListing.cfm"
   ScriptName = ""
   AccessUserGroup = "1">    
   		
<cf_ModuleInsertSubmit
   SystemModule="Roster" 
   FunctionClass = "Maintain"
   FunctionName = "Candidate Grouping" 
   MenuClass = "Roster"
   MenuOrder = "4"
   MainMenuItem = "1"
   FunctionMemo = "Maintain Candidate groupings"
   FunctionDirectory = "Roster/Maintenance/"
   FunctionPath = "Group/RecordListing.cfm"
   ScriptName = ""
   AccessUserGroup = "1">       
         
<cf_ModuleInsertSubmit
   SystemModule="Roster" 
   FunctionClass = "Maintain"
   FunctionName = "Candidate Event Classification" 
   MenuClass = "Roster"
   MenuOrder = "5"
   MainMenuItem = "1"
   FunctionMemo = "Maintain Candidate event classification"
   FunctionDirectory = "Roster/Maintenance/"
   FunctionPath = "EventCategory/RecordListing.cfm"
   ScriptName = ""
   AccessUserGroup = "1">      
        
<cf_ModuleInsertSubmit
   SystemModule="Roster" 
   FunctionClass = "Maintain"
   FunctionName = "Candidate Assessment Topics" 
   MenuClass = "Roster"
   MenuOrder = "6"
   MainMenuItem = "1"
   FunctionMemo = "Maintain Candidate assessment checkboxes"
   FunctionDirectory = "Roster/Maintenance/"
   FunctionPath = "Assessment/RecordListing.cfm"
   ScriptName = ""
   AccessUserGroup = "1">   
   
<cf_ModuleInsertSubmit
   SystemModule="Roster" 
   FunctionClass = "Maintain"
   FunctionName = "Candidate Sections" 
   MenuClass = "Roster"
   MenuOrder = "7"
   MainMenuItem = "1"
   FunctionMemo = "Maintain candidate sections and owners"
   FunctionDirectory = "Roster/Maintenance/"
   FunctionPath = "ApplicantSection/RecordListing.cfm"
   ScriptName = ""
   AccessUserGroup = "1">     
   