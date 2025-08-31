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
<cfparam name="prior" default="">
<cfparam name="url.recordstatus" default="1">

<cfif url.recordstatus gte "2">
	<cfset prior = url.recordstatus - 1>
</cfif>


<cfquery name="SearchResult" 
    datasource="AppsEPAS" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT    *
	    FROM      ContractActivity
		WHERE     ContractId     = '#URL.ContractId#'
		AND	      RecordStatus   = '#url.recordstatus#'
		AND       Operational = 1
		AND       ActivityIdParent is NULL
		ORDER BY  Reference, ActivityId
</cfquery>

<table width="100%" border="0" cellspacing="0" cellpadding="0" align="center">
				
	<tr><td width="100%">
							
		<table border="0" cellpadding="0" cellspacing="0" width="100%" class="formpadding">
						
			<cfoutput query="SearchResult">						
													
				<tr>
							
			     <td width="100%" colspan="3" align="left" style="padding-top:10px"> 
								 
					  <table width="100%" align="left" border="0" cellspacing="0" cellpadding="0">
					  
						  <tr>						
							<td width="90%" colspan="2" class="labelit">						
							<table>
							<tr>
							<td class="labelmedium" style="height:40px;font-size:20px;padding-left:16px">							
							<h1 style="font-size:30px;height:50px;padding:5px 15px 0;font-weight: 200;">
							<cf_tl id="Major assignments and objectives"></h1></td>
							</tr>
							</table>						 
							</td>						 
						  </tr>
						  
						  <tr>
							<td colspan="3">
							<table width="94%" cellspacing="0" cellpadding="0" align="center" bgcolor="ffffff" class="formpadding">
							    <cfif prior neq "">
								
								<tr class="labelmedium">
								<td><cf_tl id="Current"></td>
								<td></td>
								<td><cf_tl id="Initial"></td>
								</tr>
								
								<tr>								
								<td valign="top" style="min-width:49%;max-width:49%;border:1px solid silver;padding-left:5px;padding-right:5px">#ActivityDescription#</td>
								
									<cfquery name="getPrior" 
									    datasource="AppsEPAS" 
										username="#SESSION.login#" 
										password="#SESSION.dbpw#">
										    SELECT    *
										    FROM      ContractActivity
											WHERE     ContractId     = '#URL.ContractId#'
											AND       ActivityOrder  = '#ActivityOrder#'
											AND	      RecordStatus   = '#prior#'																			
									</cfquery>
									
									<td style="width:1%">&nbsp;</td>								
									<td valign="top" style="min-width:49%;max-width:49%;;border:1px solid silver;background-color:ffffcf;width:50%;padding-left:2x;padding-right:2px">
									
									<cfif getPrior.ActivityDescription neq ActivityDescription>
									#getPrior.ActivityDescription#
									<cfelse>
										<table align="center"><tr><td style="padding-top:40px" class="labellarge"><cf_tl id="Workplan has not changed"></td></tr></table>
									</cfif>
									
									</td>								
									
								</tr>
								
								<cfelse>
								<tr><td valign="top" colspan="3" style="background-color:eaeaea;padding-left:25px;padding-right:20px">#ActivityDescription#</td></tr>
								</cfif>
							</table>
							</td>
						  </tr> 		
												  
					  </table>
						
				 </td>
								 
			    </tr>
													   			
				<cfquery name="Detail" 
				datasource="AppsEPAS" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
					SELECT   *
					FROM     ContractActivity CA LEFT OUTER JOIN Ref_Priority C ON CA.PriorityCode = C.Code  
					WHERE    CA.ContractId       = '#URL.ContractId#'
					
					<cfif Mode eq "View">
					AND      CA.ActivityIdParent = '#ActivityID#'
					<cfelse>
					AND      CA.ActivityIdParent is NULL <!--- only for evaluation --->
					</cfif>
					AND	     CA.RecordStatus     = '#url.recordstatus#'	
					AND      CA.Operational = 1					 
					ORDER BY ActivityOrder					
				</cfquery>				
																	
				<cfif detail.recordcount gte "2">
														
						<tr>						
						<td width="90%" colspan="3" class="labelit">					
							<table>
							<tr>
								<td class="labelmedium" style="height:40px;font-size:20px;padding-left:6px">
								<h1 style="font-size:30px;height:40px;padding:5px 15px 0;font-weight: 200;">
								<cf_tl id="Specific assignments and objectives"></h1></td>
							</tr>
							</table>						 
						</td>						 
						</tr>
					
					<cfloop query="Detail">
					
							<tr>							
							<td width="98%" colspan="3" align="right" class="labelit" style="color:##808080;padding-right:43px">							
							   #officerFirstName# #OfficerLastName# : #dateformat(created, CLIENT.DateFormatShow)#		
						    </td>														
							</tr>
							
							<tr>
							<td colspan="3">
							<table width="94%" cellspacing="0" cellpadding="0" align="center" bgcolor="ffffff" class="formpadding">
							      <cfif prior neq "">
								  
								  	<tr class="labelmedium">
									<td><cf_tl id="Current"></td>
									<td></td>
									<td><cf_tl id="Initial"></td>
									</tr>
									
									<tr>
									
									<td valign="top" style="min-width:49%;max-width:49%;background-color:eaeaea;padding-left:25px;padding-right:20px">#ActivityDescription#</td>
									
									<cfquery name="getPrior" 
									    datasource="AppsEPAS" 
										username="#SESSION.login#" 
										password="#SESSION.dbpw#">
										    SELECT    *
										    FROM      ContractActivity
											WHERE     ContractId     = '#URL.ContractId#'
											AND       ActivityOrder  = '#ActivityOrder#'
											AND	      RecordStatus   = '#prior#'																			
									</cfquery>
									
									<td style="width:2%">&nbsp;</td>								
									<td valign="top" style="min-width:49%;max-width:49%;background-color:ffffcf;width:50%;padding-left:25px;padding-right:20px">#getPrior.ActivityDescription#</td>								
									
									</tr>
							
							    <cfelse>
								
								
								<tr>
								<td valign="top" style="background-color:eaeaea;padding-left:25px;padding-right:20px">#ActivityDescription#</td>
								</tr>
								
								</cfif>
								
							</table>
							</td>	
							</tr>
														
							<cfquery name="Output" 
							datasource="AppsEPAS" 
							username="#SESSION.login#" 
							password="#SESSION.dbpw#">
								SELECT    *
								FROM      ContractActivityOutput O, Ref_OutputClass S
								WHERE     O.ActivityId = '#Detail.ActivityID#'
								 AND      O.ContractId = '#URL.ContractId#'
								 AND      (O.RecordStatus <> 9 OR O.RecordStatus IS NULL)
								 AND      S.Code = O.OutputClass
								 AND      OutputDescription != ''
								 ORDER BY O.OutputClass
							</cfquery>
														
							<cfif Output.recordcount neq "0">
							
								<tr><td height="1" colspan="3" bgcolor="white" style="border:0px solid silver">						
									<table width="94%" cellspacing="0" cellpadding="0" align="center" bgcolor="ffffff" class="formpadding">					
									    <cfloop query="Output">							
										<tr bgcolor="ffffff">			 
										  <td width="120"><b>#Description#:</td>
										  <td>#OutputDescription#</td>
										</tr>  						  	  
									    </cfloop> 						
									</table>						
								</td></tr>						
								<tr><td height="1"></td></tr>
							
							</cfif>
								  
					</cfloop>
					
				</cfif>			
										
		</cfoutput>
		
		</td></tr>
					
		</table>
		
    </td></tr>
	
    </table>
