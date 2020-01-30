<cfquery name="Update" 
datasource="AppsWorkOrder" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
UPDATE 	Ref_ParameterMission
SET 	requisitionPrefix    = '#Form.requisitionPrefix#',
		requisitionSerialNo  = #Form.requisitionSerialNo#,
		workOrderPrefix      = '#Form.workOrderPrefix#',
		workOrderSerialNo    = '#Form.workOrderSerialNo#',
		OfficerUserId 	     = '#SESSION.ACC#',
		OfficerLastName      = '#SESSION.LAST#',
		OfficerFirstName     = '#SESSION.FIRST#',
		Created              =  getdate()		
WHERE 	mission              = '#Form.mission#'
</cfquery>

<cfoutput>
<script>
	ColdFusion.navigate('ParameterEditWorkOrderRequisition.cfm?ID1=#Form.mission#','contentbox1')
</script>
</cfoutput>