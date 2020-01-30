
<cfquery name="Update" 
datasource="AppsEmployee" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	UPDATE 	Ref_ParameterMission
	SET 	OvertimePayroll   = '#Form.OvertimePayroll#', 
    		BatchLeaveBalance = '#Form.BatchLeaveBalance#',
			DisableTimesheet  = '#Form.DisableTimesheet#', 
			OfficerUserId 	  = '#SESSION.ACC#',
			OfficerLastName   = '#SESSION.LAST#',
			OfficerFirstName  = '#SESSION.FIRST#',
			Created           =  getdate()			
	WHERE 	Mission = '#url.mission#'	
</cfquery>

<cfoutput>
<script>
	#ajaxLink('ParameterEditLeave.cfm?mission=#url.mission#')#	
</script>
</cfoutput>
