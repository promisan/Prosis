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
<cfquery name="get" 
	datasource="AppsWorkOrder" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">	
	SELECT * 
	FROM   WorkorderLine 
	WHERE  WorkorderLineid = '#url.workorderlineid#'
</cfquery>	

<cfquery name="get" 
	datasource="AppsWorkOrder" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">	
    SELECT   *
    FROM     WorkOrderLineDetailUser
	WHERE    UserAccount   = '#SESSION.acc#'
	AND      Workorderid   = '#get.workorderid#'
	AND      WorkOrderLine = '#get.WorkOrderLine#'
	AND      Reference     = '#url.reference#'
</cfquery>

<cfoutput>

<cfparam name="url.row" default="0">
	
<form id="user_#url.row#" name="user_#url.row#" style="width:96%">	

	<table><tr><td style="padding:5px" bgcolor="transparent">
	
	<table width="100%" cellpadding="0" style="border:0px solid gray" bgcolor="FFFFFF" class="formpadding">
	
		<cfif get.recordcount eq "1">
		<tr>
			<td class="labelit" style="padding-left:6px;padding-right:2px">No:</td>
			<td class="labelit" height="20">#Reference#</td>
		</tr>
		</cfif>

		<cfset lk = "ServiceUsageInspectLinesUserSet.cfm?workorderlineid=#url.workorderlineid#&reference=#url.reference#&row=#url.row#&src=inspect">

		<tr>
			<td class="labelit" width="45px" style="padding-left:16px;">Tag:</td>
			<td>
				<table cellpadding="0" cellspacing="0" height="18px" width="100%">
					<tr>
						<td>
							<input type="text" 
								name="ReferenceAlias"  
								id="ReferenceAlias"
								class="regularxl" 
								maxlength="30"
								size="20"
								onclick="document.getElementById('check_#url.row#').style.display = 'none'"
								value="#get.ReferenceAlias#">
						</td>
						
					</tr>
				</table>
			</td>
		</tr>
						
		<tr>
			<td class="labelit" style="padding-left:16px;">Type:</td>
			<td>
				<table cellpadding="0" cellspacing="0">
					<tr>
					<!--- onclick="ColdFusion.navigate('#lk#','set_#row#','','','POST','user_#row#')" --->
						<td style="padding-right:4px"><input type="radio" value="1" onclick="document.getElementById('check_#url.row#').style.display = 'none'" name="Charged" id="Charged" <cfif get.Charged eq "1">checked</cfif>></td>
						<td class="labelit" style="padding-right:6px">Business</td>	 
						<td style="padding-right:4px"><input type="radio" value="2" onclick="document.getElementById('check_#url.row#').style.display = 'none'" name="Charged" id="Charged" <cfif get.Charged eq "2">checked</cfif>></td>
						<td class="labelit" style="padding-right:6px">Personal</td>	 
						<td style="padding-right:4px"><input type="radio" value="" onclick="document.getElementById('check_#url.row#').style.display = 'none'" name="Charged" id="Charged" <cfif get.Charged eq "">checked</cfif>></td>
						<td class="labelit" style="padding-right:6px">Mixed</td>	 			
					</tr>
				</table>
			</td>
		</tr>
		
		<tr>
		<td></td>
		
		<td style="padding-left:1px">
		
			<table cellpadding="0" cellspacing="0" style="height:35px">
				<tr>									
				 <td>
				 
				 	<input type="button" id="#row#_applyp" 
					onClick="ColdFusion.navigate('#lk#','set_#row#','','','POST','user_#row#');document.getElementById('check_#url.row#').style.display = 'block'" 
					value="Apply Preferences" class="button10s" style="font-size:11px;width:170;height:25">
				 											
					</td>							
					
					<td style="padding-left:4px">
						<img src="#SESSION.root#/Images/check_icon.gif" id="check_#url.row#" name="check_#url.row#" border="0" style="display:none">
					</td>
					
				</tr>
			</table>
		</td>
						
		</td>
		</tr>				
		
	</table>
	
	</td></tr></table>

</form>
	
	</cfoutput>