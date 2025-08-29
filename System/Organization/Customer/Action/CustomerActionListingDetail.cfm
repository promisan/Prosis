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
<cfparam name="URL.CustomerId" default="">
<cfparam name="URL.mode" default="">

<cfquery name="GetAction" 
	datasource="AppsWorkOrder" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		 
		SELECT 	CA.*,
				A.Description as ActionClassDescription,
				ISNULL((
					SELECT 	StatusDescription
					FROM	Organization.dbo.Ref_EntityStatus
					WHERE	Operational = 1
					AND		EntityCode = 'WrkCustomer'
					AND		EntityStatus = CA.ActionStatus
				), '[Undef]') as ActionStatusDescription
		FROM   	CustomerAction CA
				INNER JOIN Ref_Action A
					ON CA.ActionClass = A.Code
		WHERE  	CA.CustomerId = '#URL.CustomerId#'
		ORDER BY CA.ActionDate
		 
</cfquery>

<cfform name="ActionForm" id="ActionForm" onSubmit="return false;">

<table width="100%" cellspacing="0" cellpadding="0">
  
  <cfif url.mode neq "new">
	  <tr>
  		<td align="center" colspan="7" style="padding:4px">
  			<cfoutput>
  			<input type="button" class="button10g" name="addAction" id="addAction" value="New Action Event" style="height:30px;width:240px" onClick="addActionRecord('#url.CustomerId#')">
  			</cfoutput>
	  	</td>
	  </tr>
  </cfif>
  
	<tr><td height="10px" colspan="7"></td></tr>
	<tr class="line">
		<td width="30"></td>
		<td class="labelit"><cf_tl id="Date"></td>
		<td class="labelit"><cf_tl id="Action"></td> 
		<td class="labelit">
			<cfif url.mode eq "new">
				<cf_tl id="Memo">
			<cfelse>
				Status
			</cfif>
		</td>
		<td class="labelit">
			<cfif url.mode eq "new">
			    <cf_tl id="Routing">
			<cfelse>
				Officer
			</cfif>
		</td>
		<td width="80" class="labelit"><cf_tl id="Recorded"></td>
		<td width="30"></td>
	</tr>
				
	<cfif url.mode eq "new">
	
		<cfoutput>	
				
		<tr>
			<td></td>
			<td style="height:40"> 
			    <cf_space spaces="40">
				<cf_intelliCalendarDate8
					FieldName  = "ActionDate" 
					Default    = "#dateformat(now(),client.dateformatshow)#"
					Class      = "regularxl"
					AllowBlank = "false"> 	
			</td>
			<td>
				<cfquery name="GetClass" 
				 datasource="AppsWorkorder" 
				 username="#SESSION.login#" 
				 password="#SESSION.dbpw#">
					SELECT 	*
					FROM   	Ref_Action
					WHERE 	Operational = 1
					AND		Mission IN (SELECT Mission 
					                    FROM   Customer 
										WHERE  CustomerId = '#URL.CustomerId#')
					ORDER BY ListingOrder ASC
				</cfquery>
			
				<cfselect name="ActionClass" class="regularxl">
					<cfloop query="GetClass">
						<option value="#Code#"> #Description# </option>
					</cfloop>
				</cfselect>
			
			</td>
			<td><cfinput type="text" class="regularxl" maxLength="50" value="" id="remarks" name="remarks" size="40"></td>
			<td>
			
				<cfquery name="GetEntity" 
				 datasource="AppsOrganization" 
				 username="#SESSION.login#" 
				 password="#SESSION.dbpw#">
					SELECT E.EntityCode, 
					       E.EntityClass, 
						   E.EntityClassName
					FROM   Ref_EntityClass E
					WHERE  EntityCode = 'WrkCustomer'
					AND    EXISTS
						(
							SELECT 'X'
							FROM   Ref_EntityClassPublish P
							WHERE  E.EntityCode = P.EntityCode
						)
					AND Operational = 1
				</cfquery>
				
				<cfselect name="Workflow" class="regularxl">
					<cfloop query="GetEntity">
						<option value="#EntityClass#"> #EntityClassName# </option>
					</cfloop>
				</cfselect>
				
			
			</td>
			<td style="padding-left:5px"><input type="button" value="Save" name="save" id="save" class="button10g" onClick="submitAction('#url.CustomerId#')"></td>			
			
			<td></td>
			
		</tr>
				
		</cfoutput>
		
		<tr><td colspan="7" height="10px"></td></tr>
		
	</cfif>
	
		<cfoutput query="GetAction">
		
		<tr>
			<td width="20px">
				
				<cfif ActionStatus neq "2">
					<cf_img icon="expand" toggle="Yes" onclick="twistWf('#CustomerActionId#',0)" mode="selected">	
				<cfelse>
					<cf_img icon="expand" toggle="Yes" onclick="twistWf('#CustomerActionId#',1)">	
				</cfif>							
						
			</td>
			<td class="labelmedium"> <b>#DateFormat(ActionDate,CLIENT.DateFormatShow)#</b></td>
			<td class="labelit">#ActionClassDescription#</td>
			<td class="labelit">#ActionStatusDescription#</td>
			<td class="labelit">#OfficerFirstName# #OfficerLastName#</td>		
			<td class="labelit">#DateFormat(Created,CLIENT.DateFormatShow)#</td>
			<td align="right" style="padding-right:3px">
				<cfif ActionStatus eq "0">
						<cf_img icon="delete" onclick="deleteAction('#CustomerId#','#CustomerActionId#')">
				</cfif>
			</td>
		</tr>
		
		<tr id="#CustomerActionId#_memo" <cfif ActionStatus eq "2"> class="hide"</cfif>>
			<td></td>
			<td colspan="5" style="background-color:##FFFFDF; padding:4px;">
				<img src="#SESSION.root#/images/join.gif" style="vertical-align:middle;">&nbsp;&nbsp;&nbsp;#Remarks#
			</td>
			<td></td>
		</tr>
						   	   
		 <input type="hidden" 
		     name="workflowlink_#CustomerActionId#" id="workflowlink_#CustomerActionId#"
		     value="Action/CustomerActionWorkflow.cfm"> 			
		
		<cfif ActionStatus neq "2">
									
			<tr>
				<td></td>
				<td colspan="5" style="padding-left:10px;padding-right:0px;border: 0px solid Silver;"
				id="#CustomerActionId#">						
					<cfset url.ajaxid = CustomerActionId>							
					<cfinclude template="CustomerActionWorkflow.cfm">								
				</td>
				<td></td>
			</tr>		
								
		<cfelse>
		
			<tr>
				<td></td>
				<td colspan="5" style="padding-left:10px;padding-right:0px;border: 0px solid Silver;"
					id="#CustomerActionId#" class="hide">	
				</td>
				<td></td>
			</tr>
		
		</cfif>
		
		<tr> <td colspan="7" height="6px;"></td></tr>
		<tr> <td colspan="7" class="linedotted"></td></tr>
		<tr> <td colspan="7" height="6px;"></td></tr>	
		
		</cfoutput>
	
</table>

</cfform>

<cfset AjaxOnLoad("doCalendar")> 
		

