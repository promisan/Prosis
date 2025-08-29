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
<cfset dateValue = "">
<cf_DateConvert Value="#Form.SelectionDate#">
<cfset vSelectionDate = dateValue>

<cfset dateValue = "">
<cf_DateConvert Value="#Form.SelectionDateEffective#">
<cfset vSelectionDateEffective = dateValue>

<cfset dateValue = "">
<cf_DateConvert Value="#Form.CutOffDate#">
<cfset vCutOffDate = dateValue>

<cfquery name="getMissionPosting" 
	datasource="AppsWorkOrder" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT *
		FROM   ServiceItemMissionPosting
		WHERE  ServiceItem = '#url.id1#'		
		AND    Mission = '#url.id2#'
		AND	   SelectionDateExpiration = #vSelectionDate#
</cfquery>

<cfif url.id3 eq "">
	
	<cfif getMissionPosting.recordcount eq 0>
		
		<cfquery name="Insert" 
			datasource="AppsWorkOrder" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				INSERT INTO ServiceItemMissionPosting
					(
						ServiceItem,
						Mission,
						SelectionDateEffective,
						SelectionDateExpiration,
						ActionStatus,
						EnablePortalProcessing,
						EnableBatchProcessing,
						CutOffDate,
						OfficerUserId,
						OfficerLastName,
						OfficerFirstName
					)
				VALUES
					(
						'#url.id1#',
						'#url.id2#',
						#vSelectionDateEffective#,						
						#vSelectionDate#,
						'#Form.ActionStatus#',
						#Form.EnablePortalProcessing#,
						#Form.EnableBatchProcessing#,
						#vCutOffDate#,						
						'#SESSION.acc#',
						'#SESSION.last#',
						'#SESSION.first#'
					)
		</cfquery>
		
		<cfoutput>
			<script>
				ColdFusion.Window.destroy('mydialog'); 
				window.location.reload();
			</script>
		</cfoutput>
	
	<cfelse>
		<script>
			alert('The selection date already exists for this service item and mission.');
		</script>	
	</cfif>
	
<cfelse>
		
	<cfquery name="Update" 
		datasource="AppsWorkOrder" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			UPDATE 	ServiceItemMissionPosting
			SET		ActionStatus = '#Form.ActionStatus#',
					EnablePortalProcessing = #Form.EnablePortalProcessing#,
					EnableBatchProcessing = #Form.EnableBatchProcessing#,
					CutOffDate = #vCutOffDate#
			WHERE	ServiceItem = '#url.id1#'
			AND		Mission = '#url.id2#'
			AND		SelectionDateExpiration = #vSelectionDate#
	</cfquery>
	
	<cfoutput>
		<script>
			ColdFusion.Window.destroy('mydialog');
			window.location.reload();
		</script>
	</cfoutput>

</cfif>