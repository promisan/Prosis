<cfquery name="Detail" 
	datasource="appsSelection" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		UPDATE 	FunctionRequirementLine
		SET		Operational = '#url.value#'
		WHERE  	RequirementId = '#url.reqId#'
		AND    	RequirementLineNo = '#url.line#'
</cfquery>

<table>
	<tr>
		<td class="labelit" style="color:#3283E4;"><cf_tl id="Saved"></td>
	</tr>
</table>