

<cfquery name="getNotification" 
	datasource="AppsWorkOrder" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT *
		FROM   Ref_ActionServiceItemNotification
		WHERE  ServiceItem = '#url.scode#'		
		AND    Action = '#url.acode#'
		AND	   Notification = '#Form.notification#'
</cfquery>

<cfif url.ncode eq "">
	
	<cfif getNotification.recordcount eq 0>
		
		<cfquery name="Insert" 
			datasource="AppsWorkOrder" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				INSERT INTO Ref_ActionServiceItemNotification (
						ServiceItem,
						Action,
						Notification,
						NotificationName,
						TemplatePath,
						Operational,
						OfficerUserId,
						OfficerLastName,
						OfficerFirstName
					) VALUES (
						'#url.scode#',
						'#url.acode#',
						'#Form.notification#',						
						'#Form.notificationname#',
						'#Form.templatepath#',
						#Form.operational#,
						'#SESSION.acc#',
						'#SESSION.last#',
						'#SESSION.first#'
					)
		</cfquery>
		
		<cfoutput>
			<script>
				ColdFusion.Window.hide('mydialog');
				window.location.reload();
			</script>
		</cfoutput>
	
	<cfelse>
		<script>
			alert('The notification code already exists.');
		</script>	
	</cfif>
	
<cfelse>
		
	<cfquery name="Update" 
		datasource="AppsWorkOrder" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			UPDATE 	Ref_ActionServiceItemNotification
			SET		NotificationName = '#Form.notificationname#',
					TemplatePath = '#Form.templatepath#',
					Operational = '#Form.operational#'
			WHERE  ServiceItem = '#url.scode#'		
			AND    Action = '#url.acode#'
			AND	   Notification = '#Form.notification#'
	</cfquery>
	
	<cfoutput>
		<script>
			ColdFusion.Window.hide('mydialog');
			window.location.reload();
		</script>
	</cfoutput>


</cfif>