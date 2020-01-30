
<cfquery name="getPeriod" 
	datasource="appsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT	PlanningPeriod
		FROM	Ref_MissionPeriod
		WHERE	Mission = '#url.mission#'
		ORDER BY PlanningPeriod ASC
</cfquery>

<cf_tl id = "Please, select a valid period" var = "1">

<!-- <cfform method="POST" name="frmReviewCycle"> -->
	<table>
		<tr>
			<cfselect 
				name="Period" 
				query="getPeriod" 
				value="PlanningPeriod" 
				display="PlanningPeriod" 
				selected="#url.period#" 
				required="Yes" 
				class="regularxl" 
				message="#lt_text#" 
				onchange="ColdFusion.navigate('#session.root#/ProgramREM/Maintenance/ReviewCycle/setDate.cfm?id1=#url.id1#&period='+this.value+'&name=Effective&blank=1','divEffectiveDate'); ColdFusion.navigate('#session.root#/ProgramREM/Maintenance/ReviewCycle/setDate.cfm?id1=#url.id1#&period='+this.value+'&name=Expiration&blank=1','divExpirationDate');">
			</cfselect>
		</tr>
	</table>
<!-- </cfform> -->