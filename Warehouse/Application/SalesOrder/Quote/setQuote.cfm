
<!--- set quote --->

<cfquery name="set"
	datasource="AppsMaterials"
	username="#SESSION.login#"
	password="#SESSION.dbpw#">
		UPDATE CustomerRequest
		SET    Remarks      = '#form.Remarks#', 
		       RequestClass = '#Form.RequestClass#'
		WHERE  Requestno    = '#URL.Requestno#'
</cfquery>
	