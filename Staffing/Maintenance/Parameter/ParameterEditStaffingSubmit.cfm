<!--
    Copyright © 2025 Promisan B.V.

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

        http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
-->
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

<cfset oSecurity = CreateObject("component","Service.Process.System.UserController")/>
<cfset mid = oSecurity.gethash()/>   

<cfoutput>
<script>
	#ajaxLink('ParameterEditStaffing.cfm?mission=#url.mission#&mid=#mid#')#	
</script>
</cfoutput>
