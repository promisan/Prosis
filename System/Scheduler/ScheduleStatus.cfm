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
<table width="30" cellspacing="0" cellpadding="0">

<tr style="height:10px">

<cfparam name="url.toggle" default="0">
<cfparam name="url.init" default="0">

<!--- Query returning search results --->
<cfquery name="Schedule"
	datasource="AppsSystem" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT *
	FROM   Schedule S
	WHERE  ScheduleId = '#URL.ID#'
</cfquery>

<cfif url.toggle eq "1">

    <cfif Schedule.operational eq "1">
	    <cfset op = 0>
	<cfelse>
    	<cfset op = 1>	
	</cfif>
	<cfinclude template="ScheduleApply.cfm">
		
	<!--- Query returning search results --->
	<cfquery name="Schedule"
		datasource="AppsSystem" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT *
		FROM   Schedule
		WHERE  ScheduleId = '#URL.ID#'
	</cfquery>
		
</cfif>

<!--- show result --->

<cfoutput>

	<cfif schedule.ScheduleInterval eq "Manual">
	
		<td width="25px" colspan="2">N/A</td>
	
	<cfelse>
		
		<cfquery name="Host" 
		datasource="AppsInit">
		    SELECT  *
    		FROM    Parameter 
	    	WHERE   HostName = '#CGI.HTTP_HOST#' 
		</cfquery>
		
				
		<td></td>
		
		<td>	
				
		<cfif Schedule.ApplicationServer eq Host.ApplicationServer or Schedule.ApplicationServer eq CGI.HTTP_HOST> 
		
			<table cellspacing="0" cellpadding="0"><tr>
			
			   <cfif schedule.operational eq "0">
			   
			    <td>
			    <img src="#client.VirtualDir#/Images/light_red3.gif"
			     border="0"
				 height="18"
				 alt="Enable"
				 onClick="toggle('#URL.Id#')"
				 align="absmiddle"
			     style="cursor: pointer;">	
				 </td>	
				 
				 <cfif url.init eq "0">
				 
				 <script>
					 scheduleoption('#url.id#')
				 </script>		
				 
				 </cfif>			 
				  
				 <td style="padding-left:3px;padding-top:3px">
				 
					<cfif schedule.ScheduleClass eq "Custom" or (SESSION.acc eq Schedule.OfficerUserid or SESSION.isAdministrator eq "Yes")>
						<cf_img icon="delete" onclick="ColdFusion.navigate('ScheduleApply.cfm?action=delete&id=#url.id#','process')">
					</cfif>
				 
				 </td>
				 				 	   
			   <cfelse>
			   
			     <td>
				     <img src="#client.virtualdir#/Images/light_green2.gif"
				     border="0"
					 alt="Disable"
					 height="18"
					 onClick="toggle('#URL.Id#')"
					 align="absmiddle"
				     style="cursor: pointer;">
				 </td>
				 
				 <cfif url.init eq "0">
				 
					 <script language="JavaScript">
						 scheduleoption('#url.id#')
					 </script>
				 
				 </cfif>			
								 
				 <td id="del#url.id#" style="padding-left:4px;padding-top:2px">
				 
					<cfif schedule.ScheduleClass eq "Custom" or (SESSION.acc eq Schedule.OfficerUserid or SESSION.isAdministrator eq "Yes")>						
						<cf_img icon="delete" onclick="ptoken.navigate('ScheduleApply.cfm?action=delete&id=#url.id#','del#url.id#')">
					</cfif>
				 
				 </td>
							
   			   </cfif>			  
			</tr></table>	
			
		<cfelseif schedule.ScheduleClass eq "Custom" and SESSION.isAdministrator eq "Yes">
		
		<table width="100%" cellspacing="0" cellpadding="0"><tr>
			 <td id="del#url.id#" style="padding-left:4px;padding-top:3px">
				<cf_img icon="delete"
				 onclick="ptoken.navigate('ScheduleApply.cfm?action=delete&id=#url.id#','del#url.id#')">						
			</td>
			
		</table>				
		
			
		</cfif>		
		
		</td>
		
	</cfif>	
	
</cfoutput>	

</tr></table>
