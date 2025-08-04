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

<!--- manual --->

<cfloop index="itm" list="Staffing,Program,Procurement,Accounting,System,Vacancy,Warehouse,Vacancy" delimiters=",">
	
	<cf_ModuleInsertSubmit
	   SystemModule="Portal" 
	   FunctionClass = "#itm#"
	   FunctionName = "Manuals" 
	   MenuClass = "Main"
	   MenuOrder = "4"
	   MainMenuItem = "1"
	   FunctionMemo = ""
	   FunctionDirectory="Manual"
	   FunctionPath = "Menu.cfm"
	   FunctionCondition = "id=#itm#"
	   FunctionIcon = "Manual">   
   
</cfloop>   

<cf_ModuleInsertSubmit
   SystemModule      = "System" 
   FunctionClass     = "Manuals"
   FunctionName      = "Reporting Framework" 
   MenuClass         = "Main"
   MenuOrder         = "1"
   MainMenuItem      = "1"
   FunctionMemo      = "Develop and Publish Reports and datasets"
   FunctionTarget    = "_blank"
   FunctionDirectory = "Manual"
   FunctionPath      = "System/RF.pdf"
   FunctionIcon      = "Manual">   
   
<cf_ModuleInsertSubmit
   SystemModule      = "System" 
   FunctionClass     = "Manuals"
   FunctionName      = "Workflow Framework" 
   MenuClass         = "Main"
   MenuOrder         = "2"
   MainMenuItem      = "1"
   FunctionMemo      = "Orchestrate and Publish Workflows"
   FunctionTarget    = "_blank"
   FunctionDirectory = "Manual"
   FunctionPath      = "System/WF.pdf"
   FunctionIcon      = "Manual">      

