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

<cfset dir = "Insurance">
<!--- <cfset dir = "CaseFile"> --->

 <!--- Application --->

 <cf_ModuleInsertSubmit
   SystemModule  = "Insurance" 
   FunctionClass = "Application"
   FunctionName  = "Case File Listing" 
   MenuClass     = "Mission"
   MenuOrder     = "1"
   MainMenuItem  = "1"
   FunctionMemo  = "Manage Case Files"
   ScriptName    = "casefile"   
   FunctionIcon  = "Process"> 
   
<cf_ModuleInsertSubmit
   SystemModule  = "Insurance" 
   FunctionClass = "Inquiry"
   FunctionName  = "Person Inquiry" 
   MenuClass     = "Main"
   MenuOrder     = "3"
   MainMenuItem  = "1"
   FunctionMemo  = "Casefile related Persons"
   FunctionDirectory = "../Roster/RosterGeneric/"
   FunctionPath  = "CandidateSearch.cfm"
   FunctionCondition = "class=3"   
   ScriptName = ""
   AccessUserGroup = "1">      

  <!--- Inquiry --->
   
  <cf_ModuleInsertSubmit
   SystemModule="Insurance" 
   FunctionClass = "Inquiry"
   FunctionName = "Case File Inquiry" 
   MenuClass = "Main"
   MenuOrder = "1"
   MainMenuItem = "1"
   FunctionMemo = "Search Options for Files"   
   FunctionDirectory = "CaseFile/Application/"
   FunctionPath = "Claim/ClaimControl/ClaimLocate.cfm"
   FunctionIcon = "Process">    
   
   <!--- MAINTENANCE --->

   <!--- ------------------- --->
   <!--- ---Configuration--- --->
   <!--- ------------------- --->
   
   <cf_ModuleInsertSubmit
   SystemModule="Insurance" 
   FunctionClass = "Maintain"
   FunctionName = "Case File Type and related cases" 
   MenuClass = "Main"
   MenuOrder = "4"
   MainMenuItem = "1"
   FunctionMemo = "Maintain File Types and Class"
   FunctionDirectory = "CaseFile/Maintenance/"
   FunctionPath = "CaseFileType/RecordListing.cfm"
   FunctionIcon = "Maintain">     
   
   <cf_ModuleInsertSubmit
   SystemModule="Insurance" 
   FunctionClass = "Maintain"
   FunctionName = "Case File Elements" 
   MenuClass = "Main"
   MenuOrder = "5"
   MainMenuItem = "1"
   FunctionMemo = "Maintain File Elements"
   FunctionDirectory = "Casefile/Maintenance/"
   FunctionPath = "FileElement/RecordListing.cfm"
   FunctionIcon = "Maintain">  
   
   <cf_ModuleInsertSubmit
   SystemModule="Insurance" 
   FunctionClass = "Maintain"
   FunctionName = "Element Topics" 
   MenuClass = "Main"
   MenuOrder = "6"
   MainMenuItem = "1"
   FunctionMemo = "Maintain File Element topics"
   FunctionDirectory = "CaseFile/Maintenance/"
   FunctionPath = "FileElementTopic/RecordListing.cfm"
   FunctionIcon = "Maintain">  
      
   <cf_ModuleInsertSubmit
   SystemModule="Insurance" 
   FunctionClass = "Maintain"
   FunctionName = "File Status" 
   MenuClass = "Main"
   MenuOrder = "8"
   MainMenuItem = "1"
   FunctionMemo = "Maintain Case File Status"
   FunctionDirectory = "CaseFile/Maintenance/"
   FunctionPath = "Status/RecordListing.cfm"
   FunctionIcon = "Maintain"> 
   
   <cf_ModuleInsertSubmit
   SystemModule="Insurance" 
   FunctionClass = "Maintain"
   FunctionName = "Elements relation" 
   MenuClass = "Main"
   MenuOrder = "9"
   MainMenuItem = "1"
   FunctionMemo = "Maintain Element relations definition"
   FunctionDirectory = "CaseFile/Maintenance/"
   FunctionPath = "ElementRelation/RecordListing.cfm"
   FunctionIcon = "Maintain"> 
   
   <cf_ModuleInsertSubmit
   SystemModule="Insurance" 
   FunctionClass = "Maintain"
   FunctionName = "Element Section" 
   MenuClass = "Main"
   MenuOrder = "10"
   MainMenuItem = "1"
   FunctionMemo = "Maintain Element sections"
   FunctionDirectory = "CaseFile/Maintenance/"
   FunctionPath = "ElementSection/RecordListing.cfm"
   FunctionIcon = "Maintain"> 
   
   
   <!--- -------------- --->
   <!--- ---Incident--- --->
   <!--- -------------- --->
   
   <cf_ModuleInsertSubmit
   SystemModule="Insurance" 
   FunctionClass = "Incident"
   FunctionName = "Circumstance" 
   MenuClass = "Main"
   MenuOrder = "1"
   MainMenuItem = "1"
   FunctionMemo = "Maintain Circumstance"
   FunctionDirectory = "CaseFile/Maintenance/"
   FunctionPath = "Incident/Circumstance/RecordListing.cfm"
   FunctionIcon = "Maintain">   

   <cf_ModuleInsertSubmit
   SystemModule="Insurance" 
   FunctionClass = "Incident"
   FunctionName = "Casualty" 
   MenuClass = "Main"
   MenuOrder = "2"
   MainMenuItem = "1"
   FunctionMemo = "Maintain Casualties"
   FunctionDirectory = "CaseFile/Maintenance/"
   FunctionPath = "Incident/Casualty/RecordListing.cfm"
   FunctionIcon = "Maintain">      
         
   <cf_ModuleInsertSubmit
   SystemModule="Insurance" 
   FunctionClass = "Incident"
   FunctionName = "Cause" 
   MenuClass = "Main"
   MenuOrder = "3"
   MainMenuItem = "1"
   FunctionMemo = "Maintain Causes"
   FunctionDirectory = "CaseFile/Maintenance/"
   FunctionPath = "Incident/Cause/RecordListing.cfm"
   FunctionIcon = "Maintain">   
   
   
   <!--- ------------- --->
   <!--- Miscellaneous --->
   <!--- ------------- --->
   
   <cf_ModuleInsertSubmit
   SystemModule="Insurance" 
   FunctionClass = "Person"
   FunctionName = "Rank" 
   MenuClass = "Main"
   MenuOrder = "1"
   MainMenuItem = "1"
   FunctionMemo = "Maintain Ranks"
   FunctionDirectory = "CaseFile/Maintenance/"
   FunctionPath = "Person/Rank/RecordListing.cfm"
   FunctionIcon = "Maintain">      
   
   <cf_ModuleInsertSubmit
   SystemModule="Insurance" 
   FunctionClass = "Person"
   FunctionName = "Claimant Type" 
   MenuClass = "Main"
   MenuOrder = "2"
   MainMenuItem = "1"
   FunctionMemo = "Maintain Claimant Types"
   FunctionDirectory = "CaseFile/Maintenance/"
   FunctionPath = "Person/ClaimantType/RecordListing.cfm"
   FunctionIcon = "Maintain">  
      
   <!--- -------------- --->   
   <!--- --Financials-- --->
   <!--- -------------- --->

   <cf_ModuleInsertSubmit
   SystemModule="Insurance" 
   FunctionClass = "Financials"
   FunctionName = "Claim Line Category" 
   MenuClass = "Main"
   MenuOrder = "1"
   MainMenuItem = "1"
   FunctionMemo = "Maintain Claim Category"
   FunctionDirectory = "CaseFile/Maintenance/"
   FunctionPath = "ClaimCategory/RecordListing.cfm"
   FunctionIcon = "Maintain">         