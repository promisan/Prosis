
<cfquery name="Update" 
datasource="AppsEmployee" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
UPDATE Ref_ParameterMission
SET PersonActionPrefix     = '#Form.PersonActionPrefix#',
	PersonActionNo         = '#Form.PersonActionNo#',
	PersonActionEnable     = '#Form.PersonActionEnable#',
	BatchStepIncrement     = '#Form.BatchStepIncrement#',
	DisableSPA             = '#Form.DisableSPA#',
	PersonActionTemplate   = '#Form.PersonActionTemplate#',
	OfficerUserId 	 	   = '#SESSION.ACC#',
	OfficerLastName  	   = '#SESSION.LAST#',
	OfficerFirstName 	   = '#SESSION.FIRST#',
	Created          	   =  getdate()	
WHERE Mission              = '#url.Mission#'
</cfquery>

<cfoutput>
<script>
	#ajaxLink('ParameterEditContract.cfm?mission=#url.mission#')#	
</script>
</cfoutput>
