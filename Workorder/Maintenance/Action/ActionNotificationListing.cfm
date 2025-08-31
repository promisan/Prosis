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
<cf_screentop height="100%" label="Action Notifications" option="Maintain #url.scode# - #url.acode#" scroll="Yes" layout="webapp" banner="yellow">

<cfajaximport tags="cfwindow,cfform">

<cfoutput>
<script>
	function editnotification(serviceitem, action, notification)
	{
		var vWidth = 500;
		var vHeight = 400;    
				   
		ColdFusion.Window.create('mydialog', 'Edit Notification', '',{x:30,y:30,height:vHeight,width:vWidth,modal:true,center:true});    
		ColdFusion.Window.show('mydialog'); 				
		ColdFusion.navigate("ActionNotificationEdit.cfm?scode="+serviceitem+"&acode="+action+"&ncode="+notification,'mydialog'); 
	}
</script>
</cfoutput>

<cfquery name="getNotifications" 
	datasource="AppsWorkOrder" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT *
		FROM   Ref_ActionServiceItemNotification
		WHERE  ServiceItem = '#url.scode#'		
		AND    Action = '#url.acode#'
		ORDER BY Notification DESC
	</cfquery>
	
<table width="95%" align="center">
	<tr><td height="10"></td></tr>	
	<tr><td height="5"></td></tr>
	<tr>
		<td colspan="7" align="center">
			<cfoutput>
				<input type="Button" class="button10g" name="Add" id="Add" value=" Add Notificaton " onclick="javascript: editnotification('#url.scode#', '#url.acode#', '')">
			</cfoutput>
		</td>
	</tr>
	<tr><td height="5"></td></tr>
	
	<tr class="line labelmedium">
		<td width="50"></td>
		<td>Code</td>		
		<td>Description</td>
		<td>TemplatePath</td>
		<td>Operational</td>
	</tr>
	
	<tr><td height="5"></td></tr>
	<cfif getNotifications.recordcount eq 0>
		<tr class="labelmedium"><td colspan="7" align="center"><font color="808080">No Notifications Defined</td></tr>
	<cfelse>
		<cfoutput query="getNotifications">		
			<tr class="labelmedium">
				<td align="right" height="25">
				   <table>
				   	<tr>
						<td>
								<cf_img icon="delete" onclick="if (confirm('Do you want to remove this record ?')) {ColdFusion.navigate('ActionNotificationDelete.cfm?scode=#url.scode#&acode=#url.acode#&ncode=#Notification#', 'process');}">
						</td>
						<td>
 								<cf_img icon="edit" onclick="editnotification('#url.scode#', '#url.acode#', '#Notification#');">
						</td>
					</tr>
				   </table>
							
				</td>
				<td>#Notification#</td>
				<td>#NotificationName#</td>
				<td>#TemplatePath#</td>
				<td><cfif Operational eq "1">Yes<cfelse>No</cfif></td>
			</tr>
		</cfoutput>	
	</cfif>
	<tr><td height="5" id="process"></td></tr>
		
</table>