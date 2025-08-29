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
<cfparam name="url.drillid" default="00000000-0000-0000-0000-000000000000">

<cfif url.drillid eq "00000000-0000-0000-0000-000000000000">

	<cf_screentop height="100%" 
			  scroll="Yes" 
			  label="New Event" 
			  layout="webapp" 
			  line="no"
			  banner="gray">

<cfelse>

		<cf_screentop height="100%" 
			  scroll="Yes" 
			  label="Edit Event" 
			  layout="webapp" 
			  line="no"
			  banner="gray">
			  
		<cf_menuscript>
		
</cfif>

<cf_calendarscript>
<cfajaximport tags="cfinput-datefield,cfform">

<cfoutput>

	<script language="JavaScript">

			
		function validate() {
			document.notificationform.onsubmit() 
			if( _CF_error_messages.length == 0 ) {     
				ColdFusion.navigate('#SESSION.root#/Tools/Notification/NotificationFormSubmit.cfm','contentbox1','','','POST','notificationform')
			 }   
		}	
		
	 	function deleteRecord(){
			if(confirm('Are you sure that you want to delete this record?') ) {     
				ColdFusion.navigate('#SESSION.root#/Tools/Notification/NotificationFormSubmit.cfm?action=delete','contentbox1','','','POST','notificationform')
			 } 
		}
			
	</script>

</cfoutput>

<table width="100%" height="100%" cellspacing="0" cellpadding="0">

<cfif url.drillid neq "00000000-0000-0000-0000-000000000000">

	<cfoutput>
	<tr><td height="34">
	
			<!--- top menu --->
			
			<table width="100%" border="0" align="center" cellspacing="0" cellpadding="0">		  		
										
				<cfset ht = "48">
				<cfset wd = "48">			
				
				<tr>		
							
						<cfset itm = 0>
						
						<cfset itm = itm+1>			
						<cf_tl id="General"	var="vGeneral">
						<cf_menutab item       = "#itm#" 
						            iconsrc    = "Logos/Workorder/General.png" 
									targetitem = "1"
									padding    = "5"
									iconwidth  = "#wd#" 
									iconheight = "#ht#" 
									name       = "#vGeneral#"
									class      = "highlight1"
									source 	   = "NotificationForm.cfm?drillid=#url.drillid#">
																							
									
						<cfset itm = itm+1>		
						<cf_tl id="Users" var="vUsers">
						<cf_menutab item       = "#itm#" 
						            iconsrc    = "Logos/User/UserGroup.png" 
									targetitem = "2"
									padding    = "5"
									iconwidth  = "#wd#" 								
									iconheight = "#ht#" 
									name       = "#vUsers#"
									source 	   = "NotificationUser.cfm?drillid=#url.drillid#">
									
							
							<td width="20%"></td>								 		
					</tr>
			</table>
	
		</td>
	 </tr>
	 </cfoutput>
	 
	<tr><td height="1" colspan="1" class="linedotted"></td></tr>

</cfif>

<tr><td height="100%">
	
	<table width="100%" 
	      border="0"
		  height="100%"
		  cellspacing="0" 
		  cellpadding="0" 
		  align="center" 
	      bordercolor="d4d4d4">
			
			<cf_menucontainer item="1" class="regular">
				<cfinclude template="NotificationForm.cfm">
			</cf_menucontainer>							
			
			<cf_menucontainer item="2" class="hide">						
												
	</table>

</td></tr>

</table>