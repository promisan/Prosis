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
<cfoutput>

<cfparam name="url.ajaxid"   default="">
<cfparam name="resetenabled" default="0">

<tr>
	<td colspan="9" height="30">
		
		<table cellspacing="0" cellpadding="0">
						
		<tr>
		
		    <td height="18" style="padding-left:5px;padding-right:3px" class="labelit"><a href="javascript:aboutworkflow('#Object.ObjectId#')"><font color="6688aa">O:#Actions.OwnerLastName#</font></u></font></a></td>
			<td width="1" style="padding-left:3px;padding-right:3px">|</td>		
			
			<!--- deprecated 10/4/2020, make the expense sheet visible 
			<cfif attributes.annotation eq "Yes">
			<td id="mail_select"  onMouseOver="this.className='labelit highlight2'"
				onMouseOut="this.className='labelit'" style="cursor:pointer;padding-left:3px;padding-right:3px" class="labelit" onclick="objectdetail('#Object.ObjectId#','mail')">&nbsp;<cf_tl id="Annotations"></td>
			<td width="1" style="padding-left:3px;padding-right:3px">|</td>
			</cfif>
						
			<cfif attributes.communicator eq "Yes">
			<td id="communicator_select"  onMouseOver="this.className='labelit highlight2'"
				onMouseOut="this.className='labelit'" style="cursor:pointer;padding-left:3px;padding-right:3px" class="labelit" onclick="objectdetail('#Object.ObjectId#','communicator')">&nbsp;<cf_tl id="Communicator"></td>
			<td width="1" style="padding-left:3px;padding-right:3px">|</td>
			</cfif>
			
			--->
			
			
			<td class="labelit" style="cursor:pointer;padding-left:3px;padding-right:3px" id="pdf_select_#Object.ObjectId#"  onMouseOver="this.className='labelit highlight2'"
				onMouseOut="this.className='labelit'" onclick="pdf_merge('#Object.ObjectId#')"><cf_tl id="Print"></td>
			<td id="pdf_wait_#Object.ObjectId#" class="hide" style="padding-left:3px;padding-right:3px">
			   <img src="#SESSION.root#/Images/busy4.gif" align="absmiddle" height="16" width="16" alt="" border="0">
			    <font color="0080FF">wait...</b>		
			</td>		
					
		<cfif Attributes.AllowProcess eq "No">
		
			<td class="labelit" style="padding-left:3px;padding-right:3px">|<font color="FF0000"><cf_tl id="Workflow locked"></font></td>
				
		<cfelse>
		
			<cfif Attributes.EntityClassReset eq "0" and Entity.EnableClassSelect eq "0">
							
				<!--- only administrator --->
								
				<cfif getAdministrator("#Object.Mission#") eq "1" or SESSION.acc eq Actions.OwnerId>
				
					<td style="padding-left:3px;padding-right:3px">|</td>					
					<td class="labelit" style="cursor:pointer;padding-left:3px;padding-right:3px" onclick="resetwf('#ObjectId#','<cfif attributes.reset neq 'full'>#url.ajaxid#</cfif>','0','#attributes.entityClass#')" onMouseOver="this.className='labelit highlight2'"
					onMouseOut="this.className='labelit'"><cf_tl id="Reset"></td>	
				
				</cfif>
								
								
			<cfelse>
									
				<cfif attributes.reset eq "Yes"> 
								
					<cfif (getAdministrator("#Object.Mission#") eq "1" or SESSION.acc eq Actions.OwnerId)>
						  <cfset resetenabled = "1">					
					</cfif> 
				
				<cfelse>
												
					<cfif getAdministrator("#Object.Mission#") eq "1">
						  <cfset resetenabled = "1">					
					</cfif> 
				
				</cfif>
														
				<cfif resetenabled eq "1" and CheckClosed.recordcount gt "0"> 								
									
					<td style="padding-left:3px;padding-right:3px">|</td>
					
						<cfif Object.EntityClass neq "">
						    <cfset cls = Object.EntityClass>
						<cfelse>
							<cfset cls = attributes.entityClass>						
						</cfif>			
					
						<td class="labelit" style="cursor:pointer;padding-left:5px;padding-right:3px" onclick="resetwf('#ObjectId#','#url.ajaxid#','1','#cls#')" 
					    onMouseOver="this.className='labelit highlight2'"
						onMouseOut="this.className='labelit'"><cf_tl id="Reset">:</td>
											
					</td>									
					
				</cfif>
			
			</cfif>	
									
			<cfif Entity.EnableGroupSelect eq "1">
				
				<cfif (getAdministrator("#Object.Mission#") eq "1" or SESSION.acc eq Actions.OwnerId) and CheckClosed.recordcount gt "0"> 
														
					    <cfquery name="Group" 
						 datasource="AppsOrganization"
						 username="#SESSION.login#" 
						 password="#SESSION.dbpw#">
							 SELECT *
							 FROM   Ref_EntityGroup
							 WHERE  EntityCode = '#attributes.entityCode#'	 
							 <cfif attributes.owner neq "">
							 AND  (Owner is NULL or Owner = '#attributes.owner#')
							 </cfif>
							 AND Operational = 1
						</cfquery>	
						
						<cfif group.recordcount gt "1">	
					
						<td style="padding-left:3px;padding-right:3px">|</td>
						<td style="padding-left:5px" class="labelit"><cf_tl id="Group">:</td>
						<td>
						<cfloop query="Group">
						
						  <cfif entityGroup eq attributes.entitygroup>
							   <input type="hidden" 
						          name="priorgroup_#ObjectId#" 
								  id="priorgroup_#ObjectId#"
								  value="#currentrow-1#">
						   </cfif>
						
						</cfloop>
						   												
						<select name="newgroup_#ObjectId#" id="newgroup_#ObjectId#" class="regularxl" onchange="resetgroup('#ObjectId#')">						
							<cfloop query="Group">							  
							   <option value="#EntityGroup#" <cfif entityGroup eq Object.entitygroup>selected</cfif>>#EntityGroupName#</option>
							</cfloop>
						</select>						
												
						</td>
						<td class="hide" id="groupreset_#ObjectId#"></td>
						
						</cfif>		
						
				</cfif>			
			
			</cfif>
												
			<cfquery name="Check" 
			 datasource="AppsOrganization"
			 username="#SESSION.login#" 
			 password="#SESSION.dbpw#">
				 SELECT   *
				 FROM     OrganizationObjectDocument O, 
				          Ref_EntityDocument R 
				 WHERE    O.DocumentId = R.DocumentId
				 AND      O.ObjectId  = '#ObjectId#'	
				 AND      O.Operational = 0
				 ORDER BY R.DocumentCode
			</cfquery>
			
			<cfif (SESSION.acc eq Actions.OwnerId or getAdministrator("#Object.Mission#") eq "1") and check.recordcount gte "1">
			    <td style="padding-left:3px;padding-right:3px">|</td>
			    <td class="labelit" style="cursor:pointer;padding-left:3px;padding-right:3px" onclick="res_att('#ObjectId#','1','#Actions.OwnerId#" 
				 onMouseOver="this.className='labelit highlight2'"
				onMouseOut="this.className='labelit'"><cf_tl id="Reset Attachment"></td>
			</cfif>			
										
			<cfinvoke component = "Service.Access"  
				method         =   "RoleAccess" 
				datasource     =   "appsOrganization"
				mission        =   "#Object.Mission#"
				role           =   "'OrgUnitManager'"
				level          =   "'1','2'"
				returnvariable =   "TreeAccess">					
				
			<cfinvoke component = "Service.Access"  
				method         =   "RoleAccess" 
				datasource     =   "appsOrganization"
				mission        =   "#Object.Mission#"
				role           =   "'#Entity.Role#'"
				Parameter      =   "#Actions.ActionCode#"
				level          =   "'1'"
				returnvariable =   "RoleAccess">		
														
			<cfif SESSION.acc eq Actions.OwnerId 
			     or getAdministrator("#Object.Mission#") eq "1" 
				 or TreeAccess eq "GRANTED" 
				 or Session.first eq "RUDOLF TETTEH"
				 or RoleAccess eq "GRANTED">
			    
				<td style="padding-left:3px;padding-right:3px">|</td>
			    <td class="labelit" style="cursor:pointer;padding-left:3px;padding-right:3px" onclick="userlocateN('access','#Actions.Role#','Object','#ObjectId#')"  onMouseOver="this.className='labelit highlight2'"
				onMouseOut="this.className='labelit'"><cf_tl id="Grant Access"></td>
				
			</cfif>
			
			<td width="1" style="padding-left:3px;padding-right:3px">|</td>				
			
			<td align="right" class="labelit" style="padding-left:3px;padding-right:3px">#Actions.EntityClass#: #DateFormat(Actions.TrackEffective,"dd/mm/yy")#</td>	
			
			<td width="1" style="padding-left:3px;padding-right:3px">|</td>		
			
			<td>
		   
			<img src="#SESSION.root#/Images/Workflow-Methods.png"
			     alt="Preview Workflow"
			     border="0"
				 width="22"
				 height="24"
			     align="absmiddle"
				 valign="center"
			     style="cursor: pointer"
			     onClick="workflowshow('#Object.ActionPublishNo#','#Object.EntityCode#','#Object.EntityClass#','','#Object.Objectid#')">
	
			</td>
			<td width="1" style="padding-left:3px;padding-right:3px">|</td>		
			
							
		</cfif>
				
		</table>
	</td>
	
	</tr>
	
	<tr><td height="1" colspan="9" class="linedotted"></td></tr>	
				
	<cfif Entity.EnablePerformance eq "1">
	
		<!--- temp purpose only --->
				
		<tr><td colspan="9">
		
		<cf_securediv bind="url:#SESSION.root#/tools/entityAction/ActionListingPerformance.cfm?objectid=#objectid#" id="perf">	
		
		</td></tr>
	
	</cfif>	
	
</cfoutput>	