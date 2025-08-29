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
<!--- part of scheduler 				
<cf_ModuleInsertSubmit
   SystemModule="Program" 
   FunctionClass = "Maintain"
   FunctionName = "Synchronise program" 
   MenuClass = "Main"
   MenuOrder = "0"
   MainMenuItem = "0"
   FunctionMemo = "Synchronise program utility"
   FunctionPath = "Synchronize/Select.cfm"
   ScriptName = ""
   AccessUserGroup = "0">   
--->  
     
<!--- functions --->

   
<cf_ModuleInsertSubmit
   SystemModule="Program" 
   FunctionClass = "Program"
   FunctionName = "Title" 
   MenuClass = "Activities"
   MenuOrder = "1"
   MainMenuItem = "0"
   FunctionMemo = "General information"   
   ScriptName = "programinfo"
   AccessUserGroup = "0">      
            
<cf_ModuleInsertSubmit
   SystemModule="Program" 
   FunctionClass = "Program"
   FunctionName = "Detail" 
   MenuClass = "Classification"
   MenuOrder = "1"
   MainMenuItem = "0"
   FunctionMemo = "General information"   
   ScriptName = "programinfo"
   AccessUserGroup = "0">         
      
<cf_ModuleInsertSubmit
   SystemModule="Program" 
   FunctionClass = "Program"
   FunctionName = "Budget" 
   MenuClass = "Resources"
   MenuOrder = "2"
   MainMenuItem = "0"
   FunctionMemo = "Maintain Budget"   
   ScriptName = "budget"
   AccessUserGroup = "0">     
   
<cf_ModuleInsertSubmit
   SystemModule="Program" 
   FunctionClass = "Program"
   FunctionName = "Forecast" 
   MenuClass = "Resources"
   MenuOrder = "3"
   MainMenuItem = "0"
   FunctionMemo = "Maintain and Review forecast settings"   
   ScriptName = "forecast"
   AccessUserGroup = "0">        
         
<cf_ModuleInsertSubmit
   SystemModule="Program" 
   FunctionClass = "Program"
   FunctionName = "Risk Management" 
   MenuClass = "Activities"
   MenuOrder = "4"
   MainMenuItem = "1"
   FunctionMemo = "Maintain Risks"   
   ScriptName = "risk"
   AccessUserGroup = "1"> 
            
<cf_ModuleInsertSubmit
   SystemModule="Program" 
   FunctionClass = "Program"
   FunctionName = "Outcome and Target" 
   MenuClass = "Activities"
   MenuOrder = "2"
   MainMenuItem = "1"
   FunctionMemo = "Maintain outputs"   
   ScriptName = "outcometarget"
   AccessUserGroup = "1">      
   
<cf_ModuleInsertSubmit
   SystemModule="Program" 
   FunctionClass = "Program"
   FunctionName = "Authorization" 
   MenuClass = "System"
   MenuOrder = "1"
   MainMenuItem = "1"
   FunctionMemo = "Maintain Program Authorization"   
   ScriptName = "authorization"
   AccessUserGroup = "1">     
   
<cf_ModuleInsertSubmit
   SystemModule="Program" 
   FunctionClass = "Program"
   FunctionName = "Summary Checklist" 
   MenuClass = "System"
   MenuOrder = "2"
   MainMenuItem = "1"
   FunctionMemo = "Validation of program/project"   
   ScriptName = "verify"
   AccessUserGroup = "1">          
   
<!--- general --->

<cf_ModuleInsertSubmit
   SystemModule="Program" 
   FunctionClass = "System"
   FunctionName = "Planning Period" 
   MenuClass = "Main"
   MenuOrder = "4"
   MainMenuItem = "1"
   FunctionMemo = "Maintain Planning Periods"
   FunctionDirectory = "ProgramREM/Maintenance/"
   FunctionPath = "PlanningPeriod/RecordListing.cfm"
   ScriptName = ""
   AccessUserGroup = "0">  
   
<!--- ePas --->          
  			
<cf_ModuleInsertSubmit
   SystemModule="Program" 
   FunctionClass = "Maintain"
   FunctionName = "Parameters" 
   MenuClass = "Workplan"
   MenuOrder = "0"
   MainMenuItem = "0"
   FunctionMemo = "General Parameters ePas"
   FunctionPath = "Workplan/Parameter/ParameterEdit.cfm"
   ScriptName = ""
   AccessUserGroup = "0"> 
   
<!--- project --->

<cf_ModuleInsertSubmit
   SystemModule="Program" 
   FunctionClass = "Maintain"
   FunctionName = "Review Cycle" 
   MenuClass = "Project"
   MenuOrder = "3"
   MainMenuItem = "1"
   FunctionMemo = "Maintain Project Review Cycles"
   FunctionDirectory = "ProgramREM/Maintenance/"
   FunctionPath = "ReviewCycle/RecordListing.cfm"
   ScriptName = ""
   AccessUserGroup = "0">               
   
<cf_ModuleInsertSubmit
   SystemModule="Program" 
   FunctionClass = "Maintain"
   FunctionName = "Financial Metrics" 
   MenuClass = "Project"
   MenuOrder = "4"
   MainMenuItem = "1"
   FunctionMemo = "Maintain Financial Metrics"
   FunctionDirectory = "ProgramREM/Maintenance/"
   FunctionPath = "Financial/RecordListing.cfm"
   ScriptName = ""
   AccessUserGroup = "0">   
   
    <cf_ModuleInsertSubmit
   SystemModule="Program" 
   FunctionClass = "Program"
   FunctionName = "Activity Progress" 
   MenuClass = "Monitor"
   MenuOrder = "1"
   MainMenuItem = "1"
   FunctionMemo = "Activity progress"
   ScriptName = "activityprogress"   
   AccessUserGroup = "1">          
   
     
<cf_ModuleInsertSubmit
   SystemModule="Program" 
   FunctionClass = "Program"
   FunctionName = "Summary" 
   MenuClass = "Monitor"
   MenuOrder = "2"
   MainMenuItem = "1"
   FunctionMemo = "Activity progress"
   ScriptName = "programsummary"
   AccessUserGroup = "1">              
   
<!--- maintain allotment reference --->
  
<cf_ModuleInsertSubmit
   SystemModule="Program" 
   FunctionClass = "Maintain"
   FunctionName = "Allotment Version" 
   MenuClass = "Allotment"
   MenuOrder = "7"
   MainMenuItem = "1"
   FunctionDirectory = "ProgramREM/Maintenance/"
   FunctionMemo = "Maintain Allotment Versions"
   FunctionPath = "AllotmentVersion/RecordListing.cfm"
   ScriptName = ""
   AccessUserGroup = "0">   
   
<cf_ModuleInsertSubmit
   SystemModule="Program" 
   FunctionClass = "Maintain"
   FunctionName = "Resource Category" 
   MenuClass = "Allotment"
   MenuOrder = "1"
   MainMenuItem = "1"
   FunctionDirectory = "ProgramREM/Maintenance/"
   FunctionMemo = "Maintain Allotment Resource Classes"
   FunctionPath = "ResourceCategory/RecordListing.cfm"
   ScriptName = ""
   AccessUserGroup = "0">      
   
<cf_ModuleInsertSubmit
   SystemModule="Program" 
   FunctionClass = "Maintain"
   FunctionName = "Object of Expenditure" 
   MenuClass = "Allotment"
   MenuOrder = "2"
   MainMenuItem = "1"
   FunctionDirectory = "ProgramREM/Maintenance/"
   FunctionMemo = "Maintain Object of Expenditure"
   FunctionPath = "Object/RecordListing.cfm"
   ScriptName = ""
   AccessUserGroup = "0">   
   
<cf_ModuleInsertSubmit
   SystemModule="Program" 
   FunctionClass = "Maintain"
   FunctionName = "Object Usage" 
   MenuClass = "Allotment"
   MenuOrder = "3"
   MainMenuItem = "1"
   FunctionDirectory = "ProgramREM/Maintenance/"
   FunctionMemo = "Maintain Object of Expenditure Usage"
   FunctionPath = "ObjectUsage/RecordListing.cfm"
   ScriptName = ""
   AccessUserGroup = "0">      
    
<cf_ModuleInsertSubmit
   SystemModule="Program" 
   FunctionClass = "Maintain"
   FunctionName = "Funding Source" 
   MenuClass = "Allotment"
   MenuOrder = "4"
   MainMenuItem = "1"
   FunctionMemo = "Maintain Funding source"
   FunctionDirectory = "ProgramREM/Maintenance/"
   FunctionPath = "FundingSource/RecordListing.cfm"
   ScriptName = ""
   AccessUserGroup = "0">      
  
<cf_ModuleInsertSubmit
   SystemModule="Program" 
   FunctionClass = "Maintain"
   FunctionName = "Fund Types" 
   MenuClass = "Allotment"
   MenuOrder = "5"
   MainMenuItem = "1"
   FunctionMemo = "Maintain Fund Classes"
   FunctionDirectory = "ProgramREM/Maintenance/"
   FunctionPath = "FundType/RecordListing.cfm"
   ScriptName = ""
   AccessUserGroup = "0">      
   
<cf_ModuleInsertSubmit
   SystemModule="Program" 
   FunctionClass = "Maintain"
   FunctionName = "Allotment Edition" 
   MenuClass = "Allotment"
   MenuOrder = "6"
   MainMenuItem = "1"
   FunctionMemo = "Maintain Allotment Editions"
   FunctionDirectory = "ProgramREM/Maintenance/"
   FunctionPath = "Edition/RecordListing.cfm"
   ScriptName = ""
   AccessUserGroup = "0">   
   
<cf_ModuleInsertSubmit
   SystemModule="Program" 
   FunctionClass = "Maintain"
   FunctionName = "Allotment Edition Requirement Snapshots" 
   MenuClass = "Allotment"
   MenuOrder = "7"
   MainMenuItem = "1"
   FunctionMemo = "Maintain Allotment Requirement Snapshots"
   FunctionDirectory = "ProgramREM/Inquiry/"
   FunctionPath = "Snapshot/RecordListing.cfm"
   ScriptName = ""
   AccessUserGroup = "0">  
   
   
<cf_ModuleInsertSubmit
   SystemModule="Program" 
   FunctionClass = "Maintain"
   FunctionName = "Budget Request Classification" 
   MenuClass = "Allotment"
   MenuOrder = "8"
   MainMenuItem = "0"
   FunctionMemo = "Budget Request Classification List Values"
   FunctionDirectory = "ProgramRem/Maintenance"
   FunctionPath = "RequestClassification/RecordListing.cfm"   
   AccessUserGroup = "0">        
   
  
<cf_ModuleInsertSubmit
   SystemModule="Program" 
   FunctionClass = "Maintain"
   FunctionName = "Program Allotment Action" 
   MenuClass = "Allotment"
   MenuOrder = "9"
   MainMenuItem = "0"
   FunctionMemo = "Maintain Allotment Actions"
   FunctionDirectory = "ProgramRem/Maintenance"
   FunctionPath = "AllotmentAction/RecordListing.cfm"   
   AccessUserGroup = "0">  
   
<!--- maintain donor --->
 
<cf_ModuleInsertSubmit
   SystemModule="Program" 
   FunctionClass = "Maintain"
   FunctionName = "Contribution Class" 
   MenuClass = "Donor"
   MenuOrder = "1"
   MainMenuItem = "1"
   FunctionDirectory = "ProgramREM/Maintenance/"
   FunctionMemo = "Maintain Contribution Classes"
   FunctionPath = "ContributionClass/RecordListing.cfm"
   ScriptName = ""
   AccessUserGroup = "0">     
 
<cf_ModuleInsertSubmit
   SystemModule="Program" 
   FunctionClass = "Maintain"
   FunctionName = "Pledge Earmark" 
   MenuClass = "Donor"
   MenuOrder = "1"
   MainMenuItem = "1"
   FunctionDirectory = "ProgramREM/Maintenance/"
   FunctionMemo = "Maintain Pledge Earmarking"
   FunctionPath = "Earmark/RecordListing.cfm"
   ScriptName = ""
   AccessUserGroup = "0">                             
   
<!--- maintain indicator reference --->  

<cf_ModuleInsertSubmit
   SystemModule="Program" 
   FunctionClass = "Maintain"
   FunctionName = "Program Events" 
   MenuClass = "Indicator"
   MenuOrder = "0"
   MainMenuItem = "1"
   FunctionMemo = "Maintain Project Events"
   FunctionDirectory = "ProgramREM/Maintenance/"
   FunctionPath = "Events/RecordListing.cfm"
   ScriptName = ""
   AccessUserGroup = "0">      

<cf_ModuleInsertSubmit
   SystemModule="Program" 
   FunctionClass = "Maintain"
   FunctionName = "Program Classification" 
   MenuClass = "Indicator"
   MenuOrder = "0"
   MainMenuItem = "1"
   FunctionMemo = "Maintain Program Classification"
   FunctionDirectory = "ProgramREM/Maintenance/"
   FunctionPath = "ProgramCategory/RecordListing.cfm"
   ScriptName = ""
   AccessUserGroup = "0">   
   
<cf_ModuleInsertSubmit
   SystemModule="Program" 
   FunctionClass = "Maintain"
   FunctionName = "Text Areas" 
   MenuClass = "Indicator"
   MenuOrder = "0"
   MainMenuItem = "2"
   FunctionMemo = "Maintain Program Text Area"
   FunctionDirectory = "ProgramREM/Maintenance/"
   FunctionPath = "TextArea/RecordListing.cfm"
   ScriptName = ""
   AccessUserGroup = "0">            
   
<cf_ModuleInsertSubmit
   SystemModule="Program" 
   FunctionClass = "Maintain"
   FunctionName = "Performance Indicator" 
   MenuClass = "Indicator"
   MenuOrder = "3"
   MainMenuItem = "1"
   FunctionMemo = "Maintain Performance Indicator"
   FunctionDirectory = "ProgramREM/Maintenance/"
   FunctionPath = "Indicator/RecordListing.cfm"
   ScriptName = ""
   AccessUserGroup = "0">      

<cf_ModuleInsertSubmit
   SystemModule="Program" 
   FunctionClass = "Maintain"
   FunctionName = "Indicator Milestones" 
   MenuClass = "Indicator"
   MenuOrder = "4"
   MainMenuItem = "1"
   FunctionMemo = "Maintain Performance Indicator Milestones"
   FunctionDirectory = "ProgramREM/Maintenance/" 
   FunctionPath = "Milestone/RecordListing.cfm"
   ScriptName = ""
   AccessUserGroup = "0">   
   
<cf_ModuleInsertSubmit
   SystemModule="Program" 
   FunctionClass = "Maintain"
   FunctionName = "Performance Indicator class" 
   MenuClass = "Indicator"
   MenuOrder = "2"
   MainMenuItem = "1"
   FunctionMemo = "Maintain Performance Indicator Class"
   FunctionDirectory = "ProgramREM/Maintenance/" 
   FunctionPath = "ProgramTarget/RecordListing.cfm"
   ScriptName = ""
   AccessUserGroup = "0">     
   
<cf_ModuleInsertSubmit
   SystemModule="Program" 
   FunctionClass = "Maintain"
   FunctionName = "Indicator source files" 
   MenuClass = "Indicator"
   MenuOrder = "3"
   MainMenuItem = "1"
   FunctionMemo = "Maintain Indicator source files"
   FunctionDirectory = "ProgramREM/Maintenance/" 
   FunctionPath = "ExternalMeasurement/RecordListing.cfm"
   ScriptName = ""
   AccessUserGroup = "0"> 
   
<!--- deactivated which was a pre-olap approach 17/4/2009           
       
<cf_ModuleInsertSubmit
   SystemModule  = "Program" 
   FunctionClass = "Inquiry"
   FunctionName  = "Management view Project progress " 
   MenuClass     = "Main"
   MenuOrder     = "7"
   MainMenuItem  = "1"
   FunctionMemo  = "Review Project progress on a aggregated level"
   FunctionPath  = "ScoreCard/SummaryBase.cfm"
   FunctionIcon  = "Statistics">   
   
--->       
               			
<cf_ModuleInsertSubmit
   SystemModule="Program" 
   FunctionClass = "Maintain"
   FunctionName = "Score values" 
   MenuClass = "Workplan"
   MenuOrder = "0"
   MainMenuItem = "0"
   FunctionMemo = "EPas evaluation ratings"
   FunctionPath = "Workplan/Parameter/Score.cfm"
   ScriptName = ""
   AccessUserGroup = "0">     
   
  
 
 