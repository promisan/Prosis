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


<cfquery name="Ownership" 
		datasource="AppsSelection" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT *
		FROM Ref_ParameterOwner
		WHERE Owner = '#URL.Owner#'
</cfquery>

<cfloop query="OwnerShip">
<br>
<table width="97%" border="0" cellspacing="0" cellpadding="0" align="center" bgcolor="white" class="formpadding">
			
    <TR>
	<td height="25" width="20"><img src="<cfoutput>#SESSION.root#</cfoutput>/Images/pointer.gif" alt="" border="0"></td>
    <td  class="labelit"><font face="Verdana">Limit roster candidacy by contract grade:</td>
    <Td width="60%" class="labelit">
	
	<cfoutput>
	<a href="javascript:deny('#Owner#')"><font color="0080C0">Click here to maintain conditions</font></a>
	</cfoutput>
    </td>
    </tr>	
	
	<TR>
	<td height="25" width="20"><img src="<cfoutput>#SESSION.root#</cfoutput>/Images/pointer.gif" alt="" border="0"></td>
    <td  class="labelit"><font face="Verdana">Candidacy Bucket Status Role Assignment Matrix:</b></td>
    <Td width="60%"  class="labelit">
	
	<cfoutput>
	<a href="javascript:authorization('#Owner#')"><font color="0080C0">Click here to maintain authorization</font></a>
	</cfoutput>
    </td>
    </tr>	
	
	<TR>
	<td height="25" width="20"><img src="<cfoutput>#SESSION.root#</cfoutput>/Images/pointer.gif" alt="" border="0"></td>
    <td><font face="Verdana">Candidacy Bucket Status List:</b></td>
    
    </tr>	
	
	<cfif Operational eq "1">
	
	<cfoutput>
	
	<cf_insertRoster   Owner="#Owner#" 
	                   Id="FUN"
					   Status="0"
					   RosterAction="0"
					   AccessLevel=""
					   Meaning="Pending Assessment"
					   TextHeader="Submitted">
					   
	<cf_insertRoster   Owner="#Owner#" 
	                   Id="FUN"
					   Status="1"
					   RosterAction="1"
					   AccessLevel="ALL"
					   Meaning="Initial Clearance"
					   TextHeader="Initial Cl.">
					   
    <cf_insertRoster   Owner="#Owner#" 
	                   Id="FUN"
					   Status="2"
					   RosterAction="1"
					   AccessLevel="EDIT"
					   Meaning="Technical Clearance"
					   TextHeader="Techn Cl.">	
					   
    <cf_insertRoster   Owner="#Owner#" 
	                   Id="FUN"
					   Status="5"
					   RosterAction="0"
					   AccessLevel=""
					   Meaning="Outdated"
					   TextHeader="Outdated">		
					   
	<cf_insertRoster   Owner="#Owner#" 
	                   Id="FUN"
					   Status="8"
					   RosterAction="0"
					   AccessLevel=""
					   Meaning="Expired Candidacy"
					   TextHeader="Expired">							   
					   
	<cf_insertRoster   Owner="#Owner#" 
	                   Id="FUN"
					   Status="9"
					   RosterAction="0"
					   AccessLevel=""
					   Meaning="Denied"
					   TextHeader="Denied">		
					   
	</cfoutput>				   					   					   				   				   
	
	</cfif>
	
		
	<cfquery name="Step" 
	datasource="AppsSelection" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT *
		FROM   Ref_StatusCode
		WHERE  Owner = '#Owner#'
		AND    Id = 'Fun'
		ORDER BY Status
	</cfquery>
	
	<tr>
	<td colspan="3" valign="top">
	
	<table width="100%" border="0" cellspacing="0" cellpadding="0">
	<tr>
	
    <TD colspan="2">
	
		<table border="0" width="100%" class="navigation_table">
		<tr class="line labelmedium">
		  <td width="5%" height="20"></td>
		  <td colspan="2"><cf_tl id="Roster Status"></td>
		  <td align="center"><cf_tl id="Needs Action"></td>
		  <td align="center" style="cursor: pointer;"><cf_UIToolTip tooltip="Show candidate totals in roster cells for this status"><cf_tl id="Show in Roster"></cf_UIToolTip></td>
		  <td align="center" style="cursor: pointer;"><cf_UIToolTip tooltip="Show candidate totals in preview boxes"><cf_tl id="Show in Search"></cf_UIToolTip></td>
		  <td align="center" style="cursor: pointer;"><cf_UIToolTip tooltip="Status which represents the pre-roster status">Pre-roster</cf_UIToolTip></td>
		  <td align="center"><cf_tl id="Method"></td>
		  <td align="center"><cf_tl id="Workflow"></td>
		  <td align="center"><cf_tl id="Reason"></td>		
		  <td align="center"><cf_tl id="Access Process"></td>	  
		  <td align="center"><cf_tl id="Access Search"></td>		
		  <td align="center"><cf_tl id="Notification"></td>
		  </tr>
				  
		<cfoutput query="step">
		
		<tr class="navigation_row cellcontent line">
		  <td align="center" style="height:20px">
		    <cf_img icon="edit" navigation="Yes" onClick="javascript:process('#owner#','#status#')">
		  </td>
		  <td align="left">#Status#</td>
		  <td>#Meaning#</td>
		  <td align="center"><cfif RosterAction eq "1">Yes</cfif></td>
		  <td align="center"><cfif ShowRoster eq "1">Yes</cfif></td>
		  <td align="center"><cfif ShowRosterSearch eq "1">Yes <cfif ShowRosterSearchDefault eq "1">(default)</cfif></cfif></td>		  
		  <td align="center"><cfif PreRosterStatus eq "1">Yes</cfif></td>
		  <td align="center"><cfif triggermethod neq "">#TriggerMethod#()</cfif></td>
		  <td align="center"><cfif entityclass eq "">n/a<cfelse>#EntityClass#</cfif></td>
		  <td align="center"><cfif enforcereason eq "1">Yes<cfelse>Optional</cfif></td>
		  <td align="center">
		  
	  		<cfquery name="GetAccess" 
				 datasource="AppsSelection"
				 username="#SESSION.login#" 
				 password="#SESSION.dbpw#">
				 SELECT		*
				 FROM 		Ref_StatusCodeProcess
				 WHERE 		Owner   = '#Owner#' 
				 AND 		Id      = 'Fun'
				 AND 		Status  = '#Status#'
				 AND 		Role    = 'RosterClear'
				 AND        Process = 'Process'
				 ORDER BY   AccessLevel ASC
			</cfquery>
								
			<cfif GetAccess.recordCount gt 0>
				<a title="Look accesses defined" href="javascript:checkProcessAuthorization('#url.owner#', '#Status#')"><font face="Verdana" color="0080C0">[#GetAccess.recordCount#]</font></a>
			</cfif>								
			
		  </td>
		  
		  <td align="center">
		  
	  		<cfquery name="GetAccess" 
				 datasource="AppsSelection"
				 username="#SESSION.login#" 
				 password="#SESSION.dbpw#">
				 SELECT		*
				 FROM 		Ref_StatusCodeProcess
				 WHERE 		Owner   = '#Owner#' 
				 AND 		Id      = 'Fun'
				 AND 		Status  = '#Status#'
				 AND 		Role    = 'RosterClear'
				 AND        Process = 'Search'
				 ORDER BY   AccessLevel ASC
			</cfquery>
				
			<cfset accessesList = ValueList(GetAccess.AccessLevel)>												
			#accessesList#					
						
		  </td>			 	 
		  <td align="center">#MailConfirmation#</td>
		</tr>
				
		</cfoutput>
		</table>
	</td></tr>
	</table>
	</td>
	</table>
	
</cfloop>	

<cfset ajaxonload("doHighlight")>
	
