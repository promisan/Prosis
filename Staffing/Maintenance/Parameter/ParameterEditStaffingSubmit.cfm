
<cfparam name="Form.EnableSourcePost" default="0">
<cfparam name="Form.AssignmentClear" default="0">
<cfparam name="Form.EnforceGrade" default="0">

<cfquery name="Update" 
datasource="AppsEmployee" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	UPDATE Ref_ParameterMission
	SET EnableSourcePost       = '#Form.EnableSourcePost#',
		EnableMissionPeriod    = '#Form.EnableMissionPeriod#',	
		<!---	
		EnableStaffingMenu	   = '#Form.EnableStaffingMenu#',
		--->
		AssignmentExpiration   = '#Form.AssignmentExpiration#',
		StaffingViewMode       = '#Form.StaffingViewMode#',
		ShowPositionPeriod     = '#Form.ShowPositionPeriod#',
		StaffingViewLoad       = '#Form.StaffingViewLoad#',
		AssignmentEntryDirect  = '#Form.AssignmentEntryDirect#',
		TrackToEmployee        = '#Form.TrackToEmployee#',
		StaffingApplicant      = '#Form.StaffingApplicant#',
		AssignmentLocation     = '#Form.AssignmentLocation#',
		AssignmentClear        = '#Form.AssignmentClear#',
		EnforceGrade           = '#Form.EnforceGrade#',
		OfficerUserId 	 	   = '#SESSION.ACC#',
		OfficerLastName  	   = '#SESSION.LAST#',
		OfficerFirstName 	   = '#SESSION.FIRST#',
		Created          	   =  getdate()		
	WHERE Mission              = '#url.Mission#'
</cfquery>

<cfif Form.AssignmentClear eq "0">

	<!--- no clearance, reset all assignments to status = 1 --->

	<cfquery name="Update" 
	datasource="AppsEmployee" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		UPDATE    PersonAssignment
		SET       AssignmentStatus = '1', 
		          Remarks = 'BatchReset to status 1'
		WHERE     (PositionNo IN
	                   (SELECT   PositionNo
	                    FROM     Position
	                    WHERE    Mission = '#URL.Mission#')) 
		AND        AssignmentStatus = '0'
	</cfquery>							

</cfif>

<cfoutput>
<script>
	#ajaxLink('ParameterEditStaffing.cfm?mission=#url.mission#')#	
</script>
</cfoutput>
