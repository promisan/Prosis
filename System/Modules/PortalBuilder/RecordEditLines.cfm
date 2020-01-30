<cfquery name="get" 
     datasource="AppsSystem" 
     username="#SESSION.login#" 
     password="#SESSION.dbpw#">		 
	 SELECT     *
	 FROM       #client.lanPrefix#Ref_ModuleControl	 
	 WHERE		<cfif url.id neq "">SystemFunctionId = '#url.id#'<cfelse>1 = 0</cfif>
</cfquery>

<cfset url.functionClass = "#url.name#">
<cfinclude template="RecordEditDetail.cfm">