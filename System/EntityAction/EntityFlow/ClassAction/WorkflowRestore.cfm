<cfparam name="url.EntityCode"  default="">
<cfparam name="url.EntityClass" default="">

<cfoutput>

<cfquery name="RestoreLog" 
	datasource="AppsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	UPDATE R
	SET ActionParent = L.ActionParent,
	ActionGoToYes = L.ActionGoToYes,
	ActionGoToNo = L.ActionGoToNo
	From Ref_EntityClassAction R Inner Join Ref_EntityClassActionLog L
		ON R.ActionCode = L.ActionCode AND R.EntityCode = L.EntityCode AND R.EntityClass = L.EntityClass 
	WHERE R.EntityCode = '#URL.EntityCode#' AND R.EntityClass = '#URL.EntityClass#' 
	</cfquery>

</cfoutput>			

<cfoutput>
	<script language="JavaScript">
		alert("The Workflow configuration was successfully restored.")
		window.location = "FlowView.cfm?EntityCode=#URL.EntityCode#&EntityClass=#URL.EntityClass#"
	</script>
</cfoutput>
			  
</body>