
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

<cfset oSecurity = CreateObject("component","Service.Process.System.UserController")/>
<cfset mid = oSecurity.gethash()/>   

<cfoutput>
<script>
	#ajaxLink('ParameterEditContract.cfm?mission=#url.mission#&mid=#mid#')#	
</script>
</cfoutput>
