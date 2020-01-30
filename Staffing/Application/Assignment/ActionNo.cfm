<cfquery name="GetLastNumber" 
    datasource="AppsEmployee" 
    username="#SESSION.login#" 
    password="#SESSION.dbpw#">
		 SELECT * FROM Parameter
</cfquery>
 
<cfset NoAct = GetLastNumber.ActionNo + 1>
 
<cfquery name="GetLastNumber" 
    datasource="AppsEmployee" 
    username="#SESSION.login#" 
    password="#SESSION.dbpw#">
		 UPDATE Parameter
		 SET ActionNo = #NoAct#
</cfquery>