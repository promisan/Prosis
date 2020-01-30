<cfquery name="Contract" 
   datasource="AppsEmployee" 
   username="#SESSION.login#" 
   password="#SESSION.dbpw#">
	SELECT DISTINCT PostGradeBudget as Level, PostOrderBudget
	FROM Ref_PostGrade
	ORDER BY PostOrderBudget
</cfquery>

<cfquery name="Deployment" 
   datasource="AppsSelection" 
   username="#SESSION.login#" 
   password="#SESSION.dbpw#">
	SELECT *
	FROM Ref_GradeDeployment 
	ORDER BY PostGradeParent, ListingOrder
</cfquery>

<cfloop query="Contract">

<cfset row = "#CurrentRow#">
<cfset lvl = "#Contract.Level#">

<cfoutput query="Deployment" group="PostGradeParent">

<cfoutput>

<cfparam name="Form.#Row#_#CurrentRow#" default="0">

<cfset sel     =   Evaluate("Form.#Row#_#CurrentRow#")>
<cfset selOld  =   Evaluate("Form.#Row#_#CurrentRow#_old")>

<cfif #sel# neq #selOld#>

#sel# neq #selOld#

	<cfif #sel# eq "1">
	
		<cfquery name="Insert" 
		   datasource="AppsSelection" 
		   username="#SESSION.login#" 
		   password="#SESSION.dbpw#">
			INSERT INTO Ref_RosterLevelCondition
			(Owner, ContractLevel, GradeDeployment)
			VALUES 
			('#URL.Owner#','#lvl#','#GradeDeployment#')
		</cfquery>
	
	<cfelse>
	
		   <cfquery name="Delete" 
		   datasource="AppsSelection" 
		   username="#SESSION.login#" 
		   password="#SESSION.dbpw#">
		   DELETE FROM Ref_RosterLevelCondition
			WHERE Owner = '#URL.Owner#'
			AND   ContractLevel = '#lvl#'
			AND   GradeDeployment = '#GradeDeployment#' 
		   </cfquery>
	
	</cfif>
	
</cfif>

</cfoutput>
</cfoutput>
</cfloop>
	
<script>
window.close()
</script>	
