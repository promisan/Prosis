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
<cf_ModuleInsertSubmit
   SystemModule="Attendance" 
   FunctionClass = "System"
   FunctionName = "Settings" 
   MenuClass = "Main"
   MenuOrder = "1"
   MainMenuItem = "1"
   FunctionMemo = "General Parameters"
   FunctionDirectory = "Attendance/Maintenance/"
   FunctionPath = "Parameter/ParameterEdit.cfm"
   FunctionIcon = "Maintain">   
   
       


<cf_ModuleInsertSubmit
   SystemModule="Attendance" 
   FunctionClass = "Reference"
   FunctionName = "Leave Type" 
   MenuClass = "Main"
   MenuOrder = "1"
   MainMenuItem = "1"
   FunctionMemo = "Register Leave Type and Accrual"
   FunctionDirectory = "Attendance/Maintenance/"
   FunctionPath = "LeaveType/RecordListing.cfm"
   FunctionIcon = "Maintain">      

<cf_ModuleInsertSubmit
   SystemModule="Attendance" 
   FunctionClass = "Reference"
   FunctionName = "Official Holidays" 
   MenuClass = "Main"
   MenuOrder = "1"
   MainMenuItem = "1"
   FunctionMemo = "Register Official Holidays"
   FunctionDirectory = "Attendance/Maintenance/"
   FunctionPath = "Holiday/HolidayCalendar.cfm"
   FunctionIcon = "Maintain">       
   
<cf_ModuleInsertSubmit
   SystemModule="Attendance" 
   FunctionClass = "Reference"
   FunctionName = "Time Class" 
   MenuClass = "Main"
   MenuOrder = "2"
   MainMenuItem = "1"
   FunctionMemo = "Maintain Timekeeping Class"
   FunctionDirectory = "Attendance/Maintenance/"
   FunctionPath = "TimeClass/RecordListing.cfm"
   FunctionIcon = "Maintain">       
    
<cf_ModuleInsertSubmit
   SystemModule="Attendance" 
   FunctionClass = "Reference"
   FunctionName = "Time Sheet Action" 
   MenuClass = "Main"
   MenuOrder = "2"
   MainMenuItem = "1"
   FunctionMemo = "Maintain Timesheet Main Actions"
   FunctionDirectory = "Attendance/Maintenance/"
   FunctionPath = "WorkAction/RecordListing.cfm"
   FunctionIcon = "Maintain">    
   
  
<cf_ModuleInsertSubmit
   SystemModule="EPAS" 
   FunctionClass = "Reference"
   FunctionName = "Performance Appraisal" 
   MenuClass = "Main"
   MenuOrder = "1"
   MainMenuItem = "1"
   FunctionMemo = "General Parameters"
   FunctionDirectory = "Attendance/Maintenance/"
   FunctionPath = "PASSetting/ParameterEdit.cfm"
   FunctionIcon = "Maintain">        
   
<cf_ModuleInsertSubmit
   SystemModule="EPAS" 
   FunctionClass = "Reference"
   FunctionName = "Evaluation Period" 
   MenuClass = "Main"
   MenuOrder = "2"
   MainMenuItem = "1"
   FunctionMemo = "Maintain Evaluation Periods"
   FunctionDirectory = "Attendance/Maintenance/"
   FunctionPath = "PerformancePeriod/RecordListing.cfm"
   FunctionIcon = "Maintain">    
   
<cf_ModuleInsertSubmit
   SystemModule="EPAS" 
   FunctionClass = "Reference"
   FunctionName = "Performance Score" 
   MenuClass = "Main"
   MenuOrder = "2"
   MainMenuItem = "1"
   FunctionMemo = "Maintain Performance elements and scores"
   FunctionDirectory = "Attendance/Maintenance/"
   FunctionPath = "PerformanceScore/RecordListing.cfm"
   FunctionIcon = "Maintain">          
   
   
 