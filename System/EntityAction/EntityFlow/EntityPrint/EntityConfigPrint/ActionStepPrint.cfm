<cfoutput>

<cfif URL.PublishNo eq "">

	<cfquery name="GetAction" 
		datasource="AppsOrganization" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT *
		FROM Ref_EntityClassAction
		WHERE ActionOrder != 0
		AND   EntityClass = '#URL.EntityClass#'
		AND   EntityCode  = '#URL.EntityCode#' 
		ORDER by ActionOrder
		</cfquery>
		
				
	<cfquery name= "GetDocuments"
		datasource="AppsOrganization" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT C.ActionCode, C.ActionDescription, C.ActionOrder, 
				D.DocumentDescription, D.DocumentTemplate, D.DocumentMode
		FROM  Ref_EntityClassAction C Inner Join Ref_EntityClassActionDocument P
					ON C.EntityCode = P.EntityCode AND C.EntityClass = P.EntityClass AND C.ActionCode = P.ActionCode
				Inner join Ref_EntityDocument D
					ON P.DocumentID = D.DocumentId			
		WHERE ActionOrder != 0
		AND   C.EntityClass = '#URL.EntityClass#'
		AND   C.EntityCode  = '#URL.EntityCode#' 
		AND D.DocumentType = 'Report' 
		</cfquery>

<cfelse>
	
	<cfquery name="GetAction" 
		datasource="AppsOrganization" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT *
		FROM Ref_EntityActionPublish A
		WHERE ActionOrder != 0
		AND   A.ActionPublishNo = '#URL.PublishNo#'	
		ORDER by ActionOrder
		</cfquery>
	
	<cfquery name= "GetDocuments"
		datasource="AppsOrganization" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT E.ActionCode, E.ActionDescription, E.ActionOrder, 
				D.DocumentDescription, D.DocumentTemplate, D.DocumentMode
		FROM  Ref_EntityActionPublish E Inner Join Ref_EntityActionPublishDocument P
					ON E.ActionPublishNo = P.ActionPublishNo AND E.ActionCode = P.ActionCode
				Inner join Ref_EntityDocument D
					ON P.DocumentID = D.DocumentId			
		WHERE E.ActionPublishNo = '#URL.PublishNo#'
		AND D.DocumentType = 'Report' 
		</cfquery>

</cfif>	

<cfquery name="QueryActions" 
	dbtype="query">
	SELECT *
	FROM GetAction
	</cfquery>		
	
	
<cfif URL.PrintDocs eq "true">
	<cfinclude template="ActionStepPrintDocuments.cfm">
</cfif>	

<cfif URL.PrintConfig eq "true">
	<cfinclude template="ActionStepPrintSteps.cfm">

	<cfloop query="GetAction">
	
		<table style="page-break-after: always;">
		<tr><td></td></tr>
		</table>
	
		<cfinclude template="ActionStepPrintActionPrepare.cfm">
		
		<cfif URL.PublishNo neq "">
			<cfset l = "Action: #GetAction.ActionDescription# [Published]">
		<cfelse>
		    <cfset l = "Action: #GetAction.ActionDescription# [Draft]">
		</cfif>	
		

			
		<table width="100%" align="center" cellspacing="0" cellpadding="0">	
			<TR>
			<td height="22" colspan="2">&nbsp;&nbsp;<b><cfif GetAction.ActionType eq "Decision">Decision<cfelse>Action</cfif> Step:
				&nbsp;<b><font color="0080FF">#GetAction.ActionCode# #GetAction.ActionDescription#
			</TD>
			</TR>	
			<tr><td colspan="2" class="line"></td></tr>			
			<tr>
			
			<td height="100%" width="100%" valign="top">				
				<cfinclude template="ActionStepPrintAction.cfm">			
			</td>
			</tr>
			
			<tr><td height="25"></td></tr>
			
		</table>
	
		
	</cfLoop>

</cfif>

</cfoutput>

