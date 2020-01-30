
<cfquery name="qParent" 
	datasource="AppsProgram"  
	username="#SESSION.login#"
	password="#SESSION.dbpw#">
	SELECT CL.ContributionLineId, CL.Reference			
	FROM   Contribution C, Contributionline CL, Ref_ContributionClass R
	WHERE  C.ContributionId    = CL.ContributionId
	AND    C.ContributionClass = R.Code
	AND    C.Mission = '#URL.Mission#'
	AND    CL.Fund   = '#URL.Fund#'		
	AND    R.Execution = '1'
</cfquery>

<cfif qParent.recordcount gte "1">

	<select class="regularxl" name="ParentContributionLineId">
	    <option value=""><cf_tl id="Not applicable"></option>
		<cfoutput query="qParent">
		<option value="#ContributionLineid#" <cfif ContributionLineId eq url.contributionlineid>selected</cfif>>#Reference#</option>
		</cfoutput>
		</select>
		
<cfelse>

	<table><tr><td class="labelmedium"><cf_tl id="No values"></td></tr></table>

	<input type="hidden" name="ParentContributionLineId" value="">

</cfif>		