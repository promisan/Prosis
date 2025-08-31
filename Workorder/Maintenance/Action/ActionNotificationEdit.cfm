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
<cfif url.ncode eq "">
	<cf_screentop height="100%" label="Notifications" option="Add action Notification content" scroll="Yes" layout="webapp" user="yes">
<cfelse>
	
	<cf_screentop height="100%" label="Action Notificaton" option="Maintain #url.scode# - #url.acode# - #ncode#" scroll="Yes" layout="webapp" user="yes">
</cfif>

<cf_calendarscript>

<cfquery name="getNotification" 
	datasource="AppsWorkOrder" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT *
		FROM   Ref_ActionServiceItemNotification
		WHERE  ServiceItem = '#url.scode#'		
		AND    Action = '#url.acode#'
		<cfif url.ncode neq "">AND	Notification = '#url.ncode#'<cfelse>AND 1 = 0</cfif>
		ORDER BY Notification DESC
</cfquery>

<cfoutput>

<table class="hide">
	<tr ><td><iframe name="processActionNotification" id="processActionNotification" frameborder="0"></iframe></td></tr>	
</table>
							  
<cfform method="post" action="ActionNotificationSubmit.cfm?scode=#url.scode#&acode=#url.acode#&ncode=#url.ncode#" name="editformActionNotification" >

<table width="90%" align="center" class="formpadding">
	<tr><td height="20"></td></tr>

	<tr>
		<td width="25%" height="25" class="labelmedium">Notification:</td>
		<td class="labelmedium">
			<cfif url.ncode neq "">
				<cfset vncode = url.ncode>
				<cfset vndesc = getNotification.NotificationName>
				<cfset vpath = getNotification.TemplatePath>
				<cfset vop = getNotification.operational>
				<input type="hidden"  name="notification" id="notification" value="#vncode#" class="regularxl">
				<b>#url.ncode#</b>
			<cfelse> 
				<cfset vncode = "">
				<cfset vndesc = "">
				<cfset vpath = "">
				<cfset vop = "0">
				<input type="text" name="notification" id="notification" value="#vncode#" size="10" maxlength="10" class="regularxl" style="width:20%">
			</cfif>
		</td>
	</tr>	

	<tr>
		<td width="25%" height="25" class="labelmedium">Description:</td>
		<td>
			<input type="Text"  style="width:90%" maxlength="40" name="notificationname" id="notificationname" value="#vndesc#" class="regularxl">
		</td>
	</tr>

	<tr>
		<td width="25%" height="25" class="labelmedium">Template:</td>
		<td>
			<input type="Text" style="width:90%" maxlength="60" name="templatepath" id="templatepath" value="#vpath#" class="regularxl">				
		</td>
	</tr>


	<tr>
		<td class="labelmedium">Operational</td>
		<td class="labelmedium">
			<input type="radio" name="operational" id="operational" value="0" <cfif vop eq "0">checked</cfif>> No
			&nbsp;
			<input type="radio" name="operational" id="operational" value="1" <cfif vop eq "1">checked</cfif>> Yes
		</td>
	</tr>
	
	<tr><td height="15"></td></tr>		
	<tr><td class="line" colspan="2"></td></tr>
	<tr><td colspan="2" align="center" height="36">
	<input  type="submit" class="button10g" name="Update" id="Update" value=" Save ">	
	</td></tr>
</table>
</cfform>
</cfoutput>
