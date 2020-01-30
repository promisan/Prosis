
<cfquery name="Check" 
datasource="AppsOrganization" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
    FROM   Organization
	WHERE  Mission     = '#URL.Mission#' 
	 AND   OrgUnitCode = '#URL.OrgUnitCode#'
</cfquery>

<cfoutput>

<cfif check.recordcount gte "1">

	&nbsp;&nbsp;<font color="FF0000">Code [#URL.OrgUnitCode#] already in use</font>

<cfelse>
	
	&nbsp;&nbsp;<img src="#SESSION.root#/Images/check.gif" alt="" border="0">
	
</cfif>

</cfoutput>
