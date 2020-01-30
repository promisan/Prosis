<!-- 
	ContingentEditSubmit.cfm
	
	Process user request to save updates to current contingent record.

	Called by: ContingentEdit.Cfm
	
	Modification history:

-->	
<!--- Write changes to Incident table --->
<cfquery name="Update_Rec" datasource="#CLIENT.Datasource#" username="#SESSION.login#" password="#SESSION.dbpw#">
UPDATE Contingent
SET Name                	= '#Form.ContingentName#',
	PermanentMissionId 		= #Form.PermanentMissionId#,
	ContingentUnit_Id		= '#Form.ContingentUnitId#',
	ContingentSubUnit_Id	= '#Form.ContingentSubUnitId#',
	AuthorizedStrength		= #Form.AuthorizedStrength#,
	Mission             	= '#Form.Mission#',
	DeploymentPeriod		= #Form.DeploymentPeriod#,	
	Remarks       			= RTRIM(SUBSTRING('#Form.Remarks#', 1,200)),
	Status			    	= #Form.Status#
WHERE Id		    		= #Form.ContingentId#
</cfquery>

<cflocation url="ContingentEdit.cfm?ID=#Form.ContingentId#">