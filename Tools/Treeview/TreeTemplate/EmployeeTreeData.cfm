
<cfset heading = "Inquiry">
<cfset module = "'WarehousePMSS'">
<cfset selection = "'Employee'">
<cfset menuclass = "'Miscellaneous','History'">
<cfset class = "'Main'">

<cfquery name="SearchResult" 
datasource="AppsSystem" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
   SELECT   *
   FROM     Ref_ModuleControl
   WHERE    SystemModule = #PreserveSingleQuotes(module)#
   	AND     FunctionClass in (#PreserveSingleQuotes(selection)#)
   	AND     MenuClass in (#PreserveSingleQuotes(menuclass)#)
   	AND     Operational = '1'
   ORDER BY MenuClass, MenuOrder 
</cfquery>

<cfoutput query="SearchResult" group="MenuClass">

['&nbsp;<u>#MenuClass#</u>','', 

<cfoutput>
	
<cfinvoke component="Service.Access"  
    method="function"  
    SystemFunctionId="#SystemFunctionId#"
    returnvariable="access">

<CFIF access is "GRANTED">
	['#FunctionName#','EmployeeGeneral.cfm?ID=#URL.ID#&section=#menuclass#&topic=#scriptname#'],
</cfif>

</cfoutput>
],
</cfoutput>





