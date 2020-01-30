<cfquery name="AllotmentActionUpdate"
datasource="AppsProgram" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
		UPDATE ProgramAllotmentAction
		SET Reference='#FORM.tReference#'
		WHERE ActionId = '#url.id#'
</cfquery>	
<cfinclude template="AllotmentActionReferenceEdit.cfm">