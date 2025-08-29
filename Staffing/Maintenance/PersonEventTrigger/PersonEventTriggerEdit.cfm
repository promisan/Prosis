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
<cfparam name="url.idmenu" default="">

<cfset vTitle = "Edit">
<cfif url.code eq "">
	<cfset vTitle = "Associate">
</cfif>

<!---
<cf_screentop height="100%" 
			  scroll="Yes" 
			  layout="webapp" 
			  label="#vTitle# Person Event Trigger" 
			  menuAccess="Yes" 
			  banner="gray"
			  jQuery="yes"
			  line="No"
			  user="no"
			  systemfunctionid="#url.idmenu#">
			  
			  --->

<cfquery name="get"
	datasource="AppsEmployee" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT 	T.*,
				(
					SELECT 	Description
					FROM 	Ref_PersonEvent
					WHERE	Code = T.EventCode
				) as EventDescription
		FROM 	Ref_PersonEventTrigger T
		WHERE	T.EventTrigger = '#url.trigger#'
		AND		T.EventCode = '#url.code#'
</cfquery>

<cfform action="PersonEventTriggerSubmit.cfm?trigger=#URL.trigger#&code=#url.code#" method="POST"  name="dialogEvent">

<table width="92%" border="0" cellspacing="0" cellpadding="0" align="center" class="formpadding formspacing">

    <tr><td></td></tr>
    <cfoutput>
    <TR class="labelmedium2">
    <TD width="120">Code:</TD>
    <TD>
	   <cfif url.code neq "">
	   
	   	  #get.EventDescription#	
	      <input type="hidden" name="Code" value="#get.EventCode#" size="10" maxlength="10">
		  
	   <cfelse>
	   
	      <cfquery name="getEvent"
			datasource="AppsEmployee" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			    SELECT 	PE.*,
						(PE.Code + ' - ' + PE.Description) as Display
				FROM 	Ref_PersonEvent PE
				WHERE	PE.Code NOT IN
						(
							SELECT 	EventCode
							FROM 	Ref_PersonEventTrigger
							WHERE	EventTrigger = '#url.trigger#'
						)
				ORDER BY PE.ListingOrder ASC
			</cfquery>
			
			<cfselect name="Code" id="Code" query="getEvent" display="Display" value="Code" class="regularxl" message="Please, select a valid event code" required="Yes"></cfselect>
			
	   </cfif>
    </TD>
	</TR>
	
	<TR class="labelmedium2">
    <TD><cf_tl id="Impact">:</TD>
    <TD>
	<table><tr class="labelmedium2"><td>
	<input type="radio" name="ActionImpact" value="Action" <cfif get.ActionImpact neq "Inquiry">checked</cfif>>
	</td><td style="padding-top:3px">Used for Triggering an Action</td>
	<td style="padding-left:6px">
	<input type="radio" name="ActionImpact" value="Inquiry" <cfif get.ActionImpact eq "Inquiry">checked</cfif>>
	</td><td style="padding-top:3px">Used for Facilitating an Inquiry</td>
	</tr></table>
	    </TD>
	</TR>
	
	<TR class="labelmedium2">
    <TD>Reason Code:</TD>
    <TD>
  	   <cfquery name="getReason"
			datasource="AppsEmployee" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			    SELECT 	*,
						(Code + ' - ' + Description) as Display
				FROM 	Ref_PersonGroup
				WHERE	Context     = 'Event'
				AND		Operational = '1'
			</cfquery>
			
			<cfselect name="ReasonCode" id="ReasonCode" query="getReason" display="Display" value="Code" class="regularxl" message="Please, select a valid reason code" required="No" selected="#get.ReasonCode#" queryposition=
			"below">
				<option value = "">None</option> 
			</cfselect>
    </TD>
	</TR>
	
	</cfoutput>
	
	<tr class="line"><td colspan="2"></td></tr>
	
	<tr>
		
	<td align="center" colspan="2">
    <input class="button10g" style="width:200px" type="submit" name="Update" value="Save">
	</td>	
	
	</tr>

</TABLE>

</CFFORM>