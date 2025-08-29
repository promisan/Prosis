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
<cfparam name="URL.mode" default="active">
<cfparam name="URL.Mission" default="">


<cfquery name="Lines" 
datasource="AppsSystem" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
    FROM Ref_ModuleControlAuthorization L
	WHERE SystemFunctionId = '#URL.ID#'
	<cfif URL.mode eq "expired">
		<!--- nada --->
	<cfelse>
		AND DateEffective  <= getdate()
		AND DateExpiration >= getdate()
	</cfif>
	ORDER BY DateEffective,DateExpiration
</cfquery>

<cfoutput>

<CFFORM action="AuthorizationRolesSubmit.cfm" method="post" name="editauthorizationform" onsubmit="return false">

<br>
<table style="border:1px solid silver" width="96%" align="center"><tr>

<td valign="top" style="padding:4px">

<table width="100%" align="center" class="navigation_table">

	<cfif URL.mode neq "new">
	
		<tr class="line">
			
			<td colspan="9" class="labelmedium" style="padding-left:4px;height:25">
				<cfif URL.mode eq "active">
		   		<a href="##" onclick="javascript:showAndHide('#URL.ID#','expired')" title="Click to add a new section">Show all</a>			
				<cfelse>
			   		<a href="##" onclick="javascript:showAndHide('#URL.ID#','active')" title="Click to add a new section">Show only active</a>								
				</cfif>				
				&nbsp;|&nbsp;
		   		<a href="##" onclick="javascript:addAuthorizationCode('#URL.ID#')" title="Click to add a new section">Add new</a>

			</td>
			
		</tr>
				
	<cfelse>
			
	</cfif>
	<tr class="labelmedium fixlengthlist line">
		<td style="height:20" width="1%"></td>		
		<td>Mission</td>		
		<td></td>		
		<td>Account</td>	
		<td>Date Effective</td>				
		<td style="padding-left:7px">Date Expiration</td>			
		<td>Level</td>
		<td colspan="2">Authorization Code</td>
		
	</tr>	
		
<cfloop query="Lines">
	<tr class="navigation_row fixlengthlist labelmedium2 linedotted">
		<td></td>		
		<td>#Mission#</td>	
		<td></td>
		<td><cfif Account eq "">Any<cfelse>#Account#</cfif></td>				
		<td>#dateformat(DateEffective,CLIENT.DateFormatShow)# #TimeFormat(DateEffective,"HH:MM")#</td>				
		<td style="padding-left:7px">#dateformat(DateExpiration,CLIENT.DateFormatShow)# #TimeFormat(DateExpiration,"HH:MM")#</td>			
		<td style="padding-left:5px">#AuthorizationLevel#</td>
		<td><b><font color="0080C0">#AuthorizationCode#</b></td>
		<td></td>
	</tr>
</cfloop>

<cfif URL.mode eq "new">
	<tr>
		<td></td>	
		
		<td align="center">
				<cfquery name="qMission" 
				datasource="AppsSystem" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">		
						SELECT DISTINCT R.Mission
						FROM   Ref_ModuleControl M INNER JOIN
				               Organization.dbo.Ref_MissionModule R ON M.SystemModule = R.SystemModule
						WHERE  (M.SystemFunctionId = '#URL.ID#')
				</cfquery>		

			    <select class="regularxl"  name="AuthorizationMission" id="AuthorizationMission" class="enterastab">
					<cfloop query="qMission">
					    <option value="#Mission#" >#Mission#</option>
					</cfloop>					
				</select>						
			
		</td>
		
		<td align="right">
			   <cfset link = "#SESSION.root#/system/modules/functions/Authorization/AccountSubmit.cfm?id=#url.id#">		
			   <cf_selectlookup
				    box          = "iAccount"
					title        = "+"
					link         = "#link#"
					button       = "No"
					iconheight   = "25"
					close        = "Yes"
					class        = "user"
					des1         = "acc">			
				
		</td>
		<td>
			<div id="iAccount">	
		</td>	
		
		<td>
			 <cf_setCalendarDate
		      name     = "DateEffective"        		      
			  class    = "regularxl"
		      mode     = "datetime"
			  future   = "Yes"> 
		</td>
		<td style="padding-left:4px">
			 <cf_setCalendarDate
		      name     = "DateExpiration"        
		      class    = "regularxl"
		      mode     = "datetime"
			  future   = "Yes"> 

		</td>
		<td  style="padding-left:4px">
			    <select name="AuthorizationLevel" id="AuthorizationLevel" class="enterastab regularxl">
					<cfloop index = "i" from = "1" to = "5">
					    <option value="#i#" >#i#</option>
					</cfloop>					
				</select>						
		</td>
		<td style="padding-left:5px">
			<input type="text" name="AuthorizationCode" id="AuthorizationCode" class="regularxl" value="" size="5">
		</td>
		<td>
		</td>
	</tr>
	<tr height="40">
		<td></td>
		<td colspan="7" class="labelit" align="center">
		     <input type="button" value="Save" name="Save" class="button10g" onclick="javascript:submitAuthorizationCode('#URL.ID#')">
		   	
		</td>
		<td></td>
	</tr>
</cfif>

</table>
</td></tr></table>
</cfform>
</cfoutput>

<cfset ajaxonload("doHighlight")>