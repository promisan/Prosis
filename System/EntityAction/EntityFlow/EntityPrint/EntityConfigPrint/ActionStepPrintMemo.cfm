
<cfif URL.PublishNo eq "">

	<cfquery name="Line" 
	datasource="AppsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT *
	FROM Ref_EntityClassAction
	WHERE ActionCode  = '#GetAction.ActionCode#'
	AND   EntityClass = '#URL.EntityClass#'
	AND   EntityCode  = '#URL.EntityCode#' 
	</cfquery>
	
<cfelse>

	<cfquery name="Line" 
	datasource="AppsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT *
	FROM Ref_EntityActionPublish A
	WHERE A.ActionCode    = '#GetAction.ActionCode#'
	AND A.ActionPublishNo = '#URL.PublishNo#'
	</cfquery>
	
</cfif>	
	
<cfoutput>

<table width="97%" border="0" cellspacing="0" align="center" cellpadding="0">
	<tr><td height="6"></td></tr>
	<tr>
        <td>#Line.ActionSpecification#</td>
	</TR>
</table>
			
</cfoutput>	