
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

