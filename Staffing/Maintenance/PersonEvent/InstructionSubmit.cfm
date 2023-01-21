
<!--- instruction per entity for presentation in portal in particular --->

<cfparam name="Form.SubmissionMode" default="1">
<cfparam name="Form.OrgUnitMode" default="0">

<cfset color = mid(form.MenuColor,2,7)>
 
<cfquery name="setMission" 
	datasource="appsEmployee" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    UPDATE Ref_PersonEventMission
		SET    Instruction    = '#form.instruction#',
		       MenuColor      = '#color#',
			   MenuImagePath  = '#form.MenuImagePath#',
			   ReasonMode     = '#Form.ReasonMode#',
			   SubmissionMode = '#Form.SubmissionMode#',
			   OrgUnitMode    = '#Form.OrgUnitMode#'
		WHERE  PersonEvent    = '#url.Code#'
		AND    Mission        = '#url.mission#' 
</cfquery>	

<script>
	parent.ProsisUI.closeWindow('instruction')
</script>

