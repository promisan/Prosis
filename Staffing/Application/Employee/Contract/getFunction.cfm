
<cfquery name="Title" 
	datasource="AppsEmployee" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT *
	    FROM  Applicant.dbo.FunctionTitle
		WHERE FunctionNo = '#url.FunctionNo#'			
</cfquery>

<cfoutput>

<script>
	document.getElementById('ContractFunctionNo').value = '#Title.functionno#'
	document.getElementById('ContractFunctionDescription').value = '#Title.FunctionDescription#'
</script>

</cfoutput>
