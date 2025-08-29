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
<table width="100%" height="100%">
	
	<tr><td colspan="2" style="padding-left:15px;padding-right:15px;">
   	
	<table width="100%" height="100%">
		
	<cfparam name="URL.Mode" default="">	
	<cfparam name="url.id"  default="{00000000-0000-0000-0000-000000000000}">
		
	<cfif Action.recordcount eq "0">
		<cf_message text="Problem, please contact your administrator">
		<cfabort>
	</cfif>
	
	
	<cfoutput query="action">	
	
	  <cfset processhide = "No">
	  <cfset showProcess = "1">
	  <cfset def         = "0">		
	  			
	  <cfif ActionReferenceShow eq "1"> 
				   
		  <tr><td style="background-color:white" colspan="2" valign="top">		
		  <table width="100%" align="center">
			  
		    <!--- Element 1b of 3 about --->	
														   
			    <tr class="labelmedium line" style="background-color:white">
				
				<cfquery name="Person" 
					datasource="appsEmployee" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">	
				    SELECT    *
					FROM      Person
					WHERE     PersonNo = '#Object.PersonNo#'						
				</cfquery>			
				
				<cfif Person.recordcount eq "1">
				
					 <cfquery name="Person" 
							datasource="appsEmployee" 
							username="#SESSION.login#" 
							password="#SESSION.dbpw#">	
						    SELECT    *
							FROM      Person
							WHERE     PersonNo = '#Object.PersonNo#'						
					</cfquery>
				
					<td style="width:70px" style="background-color:white;font-size:16px;padding-left:10px">
						
						  <cfset size = "60px">
						  <cfset pict = "">    
						  
						  <!---	removed to isolate performance issue 					  			   
						  <cfif FileExists("#SESSION.rootDocumentPath#\EmployeePhoto\#Person.IndexNo#.jpg") and indexNo gt "0"> 						                            		
								<cfset pict = Person.IndexNo>     				    
						  <cfelseif FileExists("#SESSION.rootDocumentPath#\EmployeePhoto\#Person.Personno#.jpg")>   						  
								<cfset pict = Person.Personno>	   				  						   
						  </cfif>
						  --->
						  						  
						  <cfif FileExists("#SESSION.rootPath#\CFRStage\EmployeePhoto\#Person.IndexNo#.jpg") and indexNo gt "0"> 						                            		
								<cfset pict = Person.IndexNo>     				    
						  <cfelseif FileExists("#SESSION.rootPath#\CFRStage\EmployeePhoto\#Person.Personno#.jpg")>   						  
								<cfset pict = Person.Personno>	   				  						   
						  </cfif>
						  
						  <cfif pict neq "">	
						  
						    <!--- 
						    <cffile action="COPY" 
							    source="#SESSION.rootDocumentpath#\EmployeePhoto\#vPhoto#.jpg" 
				  		    	destination="#SESSION.rootPath#\CFRStage\EmployeePhoto\#vPhoto#.jpg" nameconflict="OVERWRITE">
								
								--->
												
					  		  <cfset vPhoto = "#SESSION.root#\CFRStage\EmployeePhoto\#pict#.jpg">						
						  					  
						  <cfelse>												
						  						  			  					  
							  <cfif Person.Gender eq "Female">
								  <cfset vPhoto = "#session.root#/Images/Logos/no-picture-female.png">
							  <cfelse>
								  <cfset vPhoto = "#session.root#/Images/Logos/no-picture-male.png">
							  </cfif>					  
							  
						  </cfif>	
						  						  						  			 
						  <img src="#vPhoto#" class="img-circle clsRoundedPicture" style="height:#size#; width:#size#;">
						 
													
					</td>
					<td style="background-color:white;padding-bottom:4px" valign="bottom">			
						
						<table width="100%">
							<tr class="labelmedium">
							<td style="font-size:18px;background-color:white">
							#Person.FirstName# #Person.LastName# (#Person.Gender#)
							<cfif Person.IndexNo neq "">
							<span style="font-size:14px"><br>IndexNo ## #Person.IndexNo#</span>
							</cfif>
							<cfif Object.ObjectReference2 neq ""><br><span style="font-size:14px">#Object.ObjectReference2#</span></cfif>
							</td>	
																					
							<td id="menutabs">
							
								<table width="100%">
								<tr>		
								
									<cfset menumode = "menu">
									<cfinclude template="ProcessAction8Tabs.cfm">
									
				
									<td width="10%"></td>			
							    </tr>
								</table>	
							
							</td>	
										
							<td align="right" style="background-color:white">
							
								<cfif getAdministrator("#Object.Mission#") eq "1">
							
								<img src="#SESSION.root#/Images/Workflow-Methods.png"
									 alt="Show Workflow"
									 border="0"
									 width="32"
									 height="32"
									 align="absmiddle"
									 valign="center"
									 style="cursor: pointer;"
								     onClick="workflowshow('#Object.ActionPublishNo#','#Object.EntityCode#','#Object.EntityClass#','#ActionCode#','#Object.ObjectId#')">
									 
								</cfif>	 
									 
							 </td>
							</tr>
							
							<tr><td colspan="3">
																
								<cfquery name="Prior" 
									datasource="appsOrganization" 
									username="#SESSION.login#" 
									password="#SESSION.dbpw#">	
										SELECT      DISTINCT OA.ObjectId, PP.ActionPublishNo, PP.ProcessActionCode
										FROM        OrganizationObjectAction AS OA INNER JOIN
							                        Ref_EntityActionPublishProcess AS PP ON OA.ActionPublishNo = PP.ActionPublishNo AND OA.ActionCode = PP.ActionCode AND PP.ProcessClass = 'GoTo'
										WHERE       OA.ObjectId = '#Object.ObjectId#' AND PP.ConditionShow = '1' AND OA.ActionCode = '#Action.ActionCode#'										    
										
									</cfquery>
									
									<cfif prior.recordcount gte "1">
									
									    <table>
																			
										<cfloop query="Prior">											
										
											<cfquery name="getPrior" 
												datasource="appsOrganization" 
												username="#SESSION.login#" 
												password="#SESSION.dbpw#">	
													SELECT    R.ActionCode,
													          R.ActionDescription, 
															  OOA.ActionMemo, 
															  R.ActionCompleted, 
															  R.ActionDenied, 
															  OOA.ActionStatus, 
															  OOA.OfficerUserId, OOA.OfficerLastName, OOA.OfficerFirstName, OOA.OfficerDate, OOA.OfficerActionDate
				                                    FROM      OrganizationObjectAction AS OOA INNER JOIN
				                                              Ref_EntityActionPublish AS R ON OOA.ActionCode = R.ActionCode AND OOA.ActionPublishNo = R.ActionPublishNo		
													WHERE     OOA.ObjectId = '#Object.ObjectId#' and OOA.ActionStatus != '0' and OOA.ActionCode = '#processactionCode#'	
														  
													ORDER BY  OOA.Created DESC		  										
											</cfquery>
											
											<cfif getPrior.recordcount neq "0">
																												
												<tr  class="labelmedium"><td style="border:1px dotted silver;padding-left:3px;padding-right:5px;font-size:15px;color:black;background-color:ffffcf">
																															
													<cfif getprior.actionstatus eq "2" or getprior.actionstatus eq "2Y">										
													    <b>#getPrior.ActionCompleted#</b> <font size="1">(#getPrior.actionCode#)</font>: #getPrior.OfficerFirstName# #getPrior.OfficerLastName# <span style="font-size:13px"><cf_tl id="on"> #dateformat(getPrior.OfficerDate,client.dateformatshow)# #timeformat(getPrior.OfficerDate,"HH:MM")#</span>										
													<cfelse>
													    <b>#getPrior.ActionDenied#</b> <font size="1">(#getPrior.actionCode#)</font>: #getPrior.OfficerFirstName# #getPrior.OfficerLastName# <span style="font-size:13px"><cf_tl id="on"> #dateformat(getPrior.OfficerDate,client.dateformatshow)# #timeformat(getPrior.OfficerDate,"HH:MM")#</span>																			
													</cfif>									
												
													</td>
												</tr>
												
												<cfif getprior.actionMemo neq "">
												
													<tr  class="labelmedium">
													   <td colspan="1" style="border:1px dotted silver;padding-left:3px;padding-right:5px;color:black;font-size:15px;background-color:ffffaf"><i>
													   <span style="font-size:12px">Instruction&nbsp;&nbsp;</span></i>#getPrior.ActionMemo#</td>
													</tr>	
													
													<tr><td style="height:3px"></td></tr>								
												
												</cfif>
											
											</cfif>
										</cfloop>
										
										</table>
										
									</cfif>	
							
							
							</td></tr>
						</table>
						
					</td>
								
				<cfelse>
				
				   <td style="background-color:white">			
					
						<table width="100%">
							<tr>
							<td valign="top" style="font-size:16px;background-color:white">
							
								<table>
									<tr  class="labelmedium"><td>#Object.EntityDescription# / #Object.EntityClassName#</td></tr>
									<tr  class="labelmedium"><td style="font-size:19px;background-color:white">
											#Object.ObjectReference# <cfif Object.ObjectReference2 neq "">(#Object.ObjectReference2#)</cfif>
										</td>
									</tr>
									
									
									<cfquery name="Prior" 
									datasource="appsOrganization" 
									username="#SESSION.login#" 
									password="#SESSION.dbpw#">	
										SELECT      DISTINCT OA.ObjectId, PP.ActionPublishNo, PP.ProcessActionCode
										FROM        OrganizationObjectAction AS OA INNER JOIN
							                        Ref_EntityActionPublishProcess AS PP ON OA.ActionPublishNo = PP.ActionPublishNo AND OA.ActionCode = PP.ActionCode AND PP.ProcessClass = 'GoTo'
										WHERE       OA.ObjectId = '#Object.ObjectId#' AND PP.ConditionShow = '1' AND OA.ActionCode = '#Action.ActionCode#'
										    
										
									</cfquery>
																											
									<cfif prior.recordcount gte "1">									
																	
									<cfloop query="Prior">			
																		
										<cfquery name="getPrior" 
											datasource="appsOrganization" 
											username="#SESSION.login#" 
											password="#SESSION.dbpw#">	
												SELECT    R.ActionCode,
												          R.ActionDescription, 
														  OOA.ActionMemo, 
														  R.ActionCompleted, 
														  R.ActionDenied, 
														  OOA.ActionStatus, 
														  OOA.OfficerUserId, OOA.OfficerLastName, OOA.OfficerFirstName, OOA.OfficerDate, OOA.OfficerActionDate
			                                    FROM      OrganizationObjectAction AS OOA INNER JOIN
			                                              Ref_EntityActionPublish AS R ON OOA.ActionCode = R.ActionCode AND OOA.ActionPublishNo = R.ActionPublishNo		
												WHERE     OOA.ObjectId = '#Object.ObjectId#' and OOA.ActionStatus != '0' and OOA.ActionCode = '#processactionCode#'	
													  
												ORDER BY  OOA.Created DESC		  										
										</cfquery>
										
										<cfif getPrior.recordcount neq "0">
																											
											<tr  class="labelmedium"><td style="border:1px dotted silver;padding-left:3px;padding-right:5px;font-size:15px;color:black;background-color:ffffcf">
																														
												<cfif getprior.actionstatus eq "2" or getprior.actionstatus eq "2Y">										
												    <b>#getPrior.ActionCompleted#</b> <font size="1">(#getPrior.actionCode#)</font>: #getPrior.OfficerFirstName# #getPrior.OfficerLastName# <span style="font-size:13px"><cf_tl id="on"> #dateformat(getPrior.OfficerDate,client.dateformatshow)# #timeformat(getPrior.OfficerDate,"HH:MM")#</span>										
												<cfelse>
												    <b>#getPrior.ActionDenied#</b> <font size="1">(#getPrior.actionCode#)</font>: #getPrior.OfficerFirstName# #getPrior.OfficerLastName# <span style="font-size:13px"><cf_tl id="on"> #dateformat(getPrior.OfficerDate,client.dateformatshow)# #timeformat(getPrior.OfficerDate,"HH:MM")#</span>																			
												</cfif>									
											
												</td>
											</tr>
											
											<cfif getprior.actionMemo neq "">
											
											<tr  class="labelmedium">
											   <td colspan="1" style="border:1px dotted silver;padding-left:3px;padding-right:5px;color:black;font-size:15px;background-color:ffffaf"><i><span style="font-size:12px">Instruction&nbsp;&nbsp;</span></i>#getPrior.ActionMemo#</td>
											</tr>	
											
											<tr><td style="height:3px"></td></tr>								
											
											</cfif>
										
										</cfif>
									</cfloop>
									
									</cfif>									
									
								</table>
							
							</td>	
							
							<td id="menutabs">
							<table width="100%">
							<tr>		
							
								<cfset menumode = "menu">
								<cfinclude template="ProcessAction8Tabs.cfm">
								<td width="10%"></td>			
						    </tr>
							</table>	
							
							</td>		
											
							<td align="right" style="background-color:white">
							
								<cfif getAdministrator("#Object.Mission#") eq "1">
							
									<img src="#SESSION.root#/Images/Workflow-Methods.png"
										 alt="Show Workflow"
										 border="0"
										 width="32"
										 height="32"
										 align="absmiddle"
										 valign="center"
										 style="cursor: pointer;"
									     onClick="workflowshow('#Object.ActionPublishNo#','#Object.EntityCode#','#Object.EntityClass#','#ActionCode#','#Object.ObjectId#')">
										 
								</cfif>	 
									 
							 </td>
							</tr>
						</table>
						
					</td>
					
				</cfif>
			   </tr>	
			   
		  </table>
		  </td></tr> 	
		  
		  
	  <cfelse>
	 	  
	  <tr class="line">
	<td valign="top" colspan="2" height="30" id="menutabs">	
		<table width="100%">
		<tr>		
			<cfset menumode = "menu">
			<cfinclude template="ProcessAction8Tabs.cfm">
			<td width="10%"></td>			
	    </tr>
		</table>	
	</td></tr>
			  
	   </cfif>	
	
	</cfoutput>
	
	
	
	
	<tr><td height="100%" valign="top" style="border:0px solid silver">
		<table width="100%" height="100%">				
		<cfset menumode = "content">
		<cfinclude template="ProcessAction8Tabs.cfm">
		</table>		
	</td></tr>
	
</table>

</td></tr>

</table>

