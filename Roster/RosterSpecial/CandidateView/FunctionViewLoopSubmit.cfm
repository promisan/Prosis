<cfloop index="itm" list="#Form.FunctionNew#" delimiters=":">

    <cfquery name="Check" 
	 datasource="AppsSelection" 
	 username="#SESSION.login#" 
	 password="#SESSION.dbpw#">
	 SELECT *
	 FROM FunctionTitle
	 WHERE FunctionNo = '#itm#'
    </cfquery>
 
    <cfif check.recordCount eq "1">
		<cfquery name="FunctionNew" 
		 datasource="AppsSelection" 
		 username="#SESSION.login#" 
		 password="#SESSION.dbpw#">
		 UPDATE FunctionOrganization
		 SET    FunctionNo = '#itm#'
		 WHERE  FunctionId = '#Form.FunctionId#'
		</cfquery>
	</cfif>
  
</cfloop>

<cflocation url="FunctionViewLoop.cfm?IDFunction=#Form.FunctionId#" addtoken="No">
