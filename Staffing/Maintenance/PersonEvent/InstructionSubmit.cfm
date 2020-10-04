
<!--- instruction per entity for presentation in portal in particular --->


<cfquery name="setMission" 
	datasource="appsEmployee" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    UPDATE Ref_PersonEventMission
		SET    Instruction    = '#form.instruction#',
		       MenuColor      = '#form.MenuColor#',
			   MenuImagePath  = '#form.MenuImagePath#',
			   ReasonMode     = '#Form.ReasonMode#'
		WHERE  PersonEvent = '#url.Code#'
		AND    Mission = '#url.mission#' 
</cfquery>	

<script>
	parent.ProsisUI.closeWindow('instruction')
</script>

