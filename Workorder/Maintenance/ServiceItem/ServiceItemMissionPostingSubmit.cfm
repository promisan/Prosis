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