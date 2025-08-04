<!--
    Copyright © 2025 Promisan

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