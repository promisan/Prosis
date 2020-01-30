<cf_screentop html="no">

<div style="position:absolute;width:100%;height:100%; overflow: auto; scrollbar-face-color: F4f4f4;">

<table width="99%" align="center"><tr><td>

<cfquery name="Document" 
 datasource="AppsOrganization"
 username="#SESSION.login#" 
 password="#SESSION.dbpw#">
 SELECT *
 FROM  OrganizationObjectAction OA
 WHERE ActionId  = '#URL.id#' 
 </cfquery>

<cfoutput>
#Document.ActionMemo#
</cfoutput>
</td></tr></table>
</div>

<cfif len(Document.ActionMemo) lte 500>

<cfoutput>
	<script>
	frm = parent.document.getElementById("document#url.box#")
	frm.height = 80
	</script>
</cfoutput>

</cfif>