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

		<cfset vTextStyle       = "color:##FAFAFA; font-size:14px;">   		
	
		<cfif Actions.ActionFlowOrder lte CheckNext.ActionFlowOrder or CheckNext.ActionFlowOrder eq "">
		
			<cfif ActionStatus eq "1">
				<cfset cl = "##F7FFCF">
				<cfset action = "1">
				<cfset box = "##FAC87D">
													
			<cfelseif (ActionStatus eq "2" or Attributes.DocumentStatus eq "9") and EnableQuickProcess eq "0">
			    <cfset cl = "">
				<cfset box = "rgba(174, 192, 108,0.6)">
				<cfset action = "0">	
										
			<cfelseif ActionStatus eq "2Y">
			    <cfset cl = "">
				<cfset box = "rgba(174, 192, 108,0.6)">			
				<cfset action = "0">	
                    
                <cfif currentrow eq "1"><!--- Approved Final --->
                    <cfset box = "rgba(174, 192, 108,1)">			
                </cfif>
                    
           <cfelseif ActionStatus eq "2N">
               
			    <cfset cl = "">
				<cfset box = "rgba(205, 57, 57,0.8)">			
				<cfset action = "0">	
                    
                <cfif currentrow neq "1"><!--- skip --->
                    <cfset box = "rgba(129, 168, 145,0.7)">			
                </cfif>
                    
			<cfelseif NextAction.ActionFlowOrder eq "" 
			     and FirstDue.ActionFlowOrder eq ActionFlowOrder>				 
																				 
				<cfset cl = "##1A8CFF">
				<cfset box = "##D35400">
				<cfset action = "1">               
               						
			<cfelseif (NextAction.ActionFlowOrder eq ActionFlowOrder or Concurrent.ActionParent eq ActionParent) and ActionStatus neq "2">
									
				<cfset cl = "##f4f4f4">
				<cfset box = "##EDB800">
				<cfset action = "1">
					
			<cfelseif NextAction.ActionFlowOrder eq ActionFlowOrder
						and ActionStatus eq "2"
						and EnableQuickProcess eq "1">
																			
				<cfset cl = "##f4f4f4">
				<cfset box = "##F5D76E">
				<cfset action = "1">					
											
			<cfelseif ActionStatus eq "9">
			
			    <cfset cl     = "">
				<cfset box    = "##87C6BB">
				<cfset action = "1">	
			
			<cfelse>	
			
			    <cfset cl     = "ffffff">
				<cfset box    = "rgba(174, 192, 108,0.6)">
				<cfset action = "0">				
								
			</cfif>			
			
		<cfif ActionStatus eq "0" 
			   or ActionStatus eq "1" 
			   or EnableQuickProcess eq "1">
			  													
				 <cfinvoke component = "Service.Access"  
					method         =   "AccessEntity" 
					objectid       =   "#ObjectId#"
					actioncode     =   "#ActionCode#" 
					mission        =   "#attributes.mission#"
					orgunit        =   "#Attributes.OrgUnit#" 
					entitygroup    =   "#EntityGroup#" 
					returnvariable =   "entityaccess">		
														
				 <cfset reopenAccess = entityAccess>							
				
			<cfelse>
			
				<cfif currentrow eq "1">
			
					<cfinvoke component = "Service.Access"  
						method         =   "AccessEntity" 
						objectid       =   "#ObjectId#"
						actioncode     =   "#ActionCode#" 
						mission        =   "#attributes.mission#"
						orgunit        =   "#Attributes.OrgUnit#" 
						entitygroup    =   "#EntityGroup#" 
						returnvariable =   "entityaccess">	
						
					<cfset reopenAccess = entityAccess>		
														
				</cfif>
			
			  	 <cfset EntityAccess = "NONE">	
				
			</cfif>	
			
			<cfif attributes.allowProcess eq "No">
				<cfset EntityAccess = "NONE">	
			</cfif>
			
			<cfif actionStatus gte "2">
			
			 <cfif actionCompletedColor neq "Default">
			    <cfset box = actionCompletedColor>		 
			 </cfif>
			
			</cfif>
																									
			<tr bgcolor="#cl#" style="border:1px solid silver">
			
				<cfquery name="Dialog" 
				 datasource="AppsOrganization"
				 username="#SESSION.login#" 
				 password="#SESSION.dbpw#">
				 	SELECT *
					 FROM  Ref_EntityDocument D
					 WHERE EntityCode  = '#EntityCode#' 
					 AND   DocumentCode = '#ActionDialog#'
				</cfquery>		
			  	
				<cfif attributes.subflow eq "No" and showaction eq "1">
				
					<cfset ln = "5">														
                    <td style="width:100%;height:100%;padding-left:0px;padding-right:0px">
														
				<cfelse>
	
					<cfset ln = "2">							
                    <td style="width:100%;height:100%;padding-left:0px;padding-right:0px" align="right">
																			
				</cfif>
													
					<table style="width:105%;height:100%">
																											
					<cfif Action eq "1" and (EntityAccess eq "EDIT" OR EntityAccess eq "READ" OR EntityAccess eq "ALL")>
											  										
						<cfif attributes.hideprocess eq "0" and ActionTrigger eq "">
						    <cfif attributes.subflow eq "No">
						    <cfset pr = "javascript:process('#ActionId#','#attributes.preventProcess#','#attributes.ajaxid#','#ProcessMode#')">
							<cfelse>												
							<cfset pr = "javascript:process('#ObjectId#','#attributes.preventProcess#','#attributes.ajaxid#','#ProcessMode#')">							
							</cfif>
						<cfelse>
						    <cfset pr = "">
						</cfif>
						
						<!--- correction --->
						<cfif EntityAccess eq "READ">
						   <cfset pr = "">
						</cfif>
						
						<cfif attributes.subflow eq "Yes">
							<cfset box = "silver">
						</cfif>
						
						<cfparam name="ActionCompleted" default="">
						<cfparam name="ActionDenied" default="">
						
						<cfquery name="Dialog" 
							 datasource="AppsOrganization"
							 username="#SESSION.login#" 
							 password="#SESSION.dbpw#">
							 	SELECT *
								 FROM  Ref_EntityDocument D
								 WHERE EntityCode  = '#EntityCode#' 
								 AND   DocumentCode = '#ActionDialog#'
						</cfquery>													
													
							<tr style="height:25px" class="labelmedium">
																							
								<cfparam name="ActionProcess" default="Do it">
								
								<cfset proctext = "#ActionProcess#">
								<cfif proctext eq "">
									<cfset proctext = "Do it">
								</cfif>
								
								<cfoutput>  
								
								 <cfif EnableQuickProcess eq "1">
								 
								 	<cfif ActionStatus eq "0" and EntityAccess eq "EDIT" and Action eq "1">		
												 
										<td id="quick#ActionId#" style="padding-left:3px" name="quick#ActionId#">	
												
										<cfif attributes.hideprocess eq "0" and actionTrigger eq "" and object_op is 1>		
											<input type="checkbox" class="radiol" name="confirmwf" id="confirmwf" style="display:none;" value="#ActionId#" checked onclick="toggleaction('#ActionId#')">		
										    <a id="d#ActionId#" href="javascript:submitwfquick('#ActionId#','#attributes.ajaxid#')">#ActionDescription#</a>  			
										 </cfif>		
									 	</td>		
										
									</cfif>
									
								 <cfelse>
								  				
									 <cfif object_op is 1 and Action eq "1" and (EntityAccess eq "EDIT" or EntityAccess eq "READ" OR EntityAccess eq "ALL")>	 		
									 
									   <cfif Dialog.DocumentMode eq "Popup" and Object_op eq 1>	
									   									 						
											<td class="labelmedium" style="height:100%;cursor: pointer;">											
												<cf_img icon="select" onclick="#Dialog.DocumentTemplate#('#actioncode#','#actionId#','#url.ajaxid#')">						  
										    </td>										  								
											
										</cfif>	
																																							 
											 <td class="fixlength" style="padding-left:3px;height:22px;max-width:200px" title="#ActionDescription#">		
												
												<cfif attributes.hideprocess eq "0" and actionTrigger eq "" and showaction is 1>		
												    <cfif Dialog.DocumentMode eq "Popup" and DisableStandardDialog eq "1" >				
													   <cfif EntityAccess eq "EDIT" OR EntityAccess eq "ALL">
														  <a href="javascript:#Dialog.DocumentTemplate#('#ActionCode#','#ActionId#','#url.ajaxid#')"><font color="FFFFFF">#ActionDescription#</a>
														</cfif>   															
													<cfelse>				
														<cfif Attributes.Subflow eq "No">
															<a href="javascript:process('#ActionId#','#attributes.preventProcess#','#Attributes.ajaxid#','#ProcessMode#')"><font color="FFFFFF">#ActionDescription#</a>
														<cfelse>														   						
															<a href="javascript:process('#ObjectId#','#attributes.preventProcess#','#Attributes.ajaxid#','#ProcessMode#')"><font color="FFFFFF">#ActionDescription#</a>							   
														</cfif>	   								 										
													</cfif>	
												</cfif>
												
											 </td>	
										 
										 										                        
									  </cfif>
								
								  </cfif> 
									  
								</cfoutput>
															
							</tr>
																
					<cfelse>
					
						<cfset vSquareStyle     = "padding:0px 0 0;border-radius:2px;max-width:100%">   
					
						<cfif ActionDialogContent neq "">
						    <cfset pr = "javascript:actionlog('#ActionId#')">
						<cfelse>
						    <cfset pr = "">
						</cfif>		
						
						<cfif box eq "C7FECB">
							<cfset boxend = "##77C97D">
						<cfelseif box eq "##C9EDF1">
							<cfset boxend = "##7DC9D1">
						<cfelse>
							<cfset boxend = "gray">
						</cfif>							
					
						<tr>
						<td class="fixlength" title="#ActionReference#: #ActionDescription#" style="padding-left:0px;height:25px;background-color:#boxend#;cursor: pointer;color:white;" align="center">																																
																						
								<cfparam name="ActionCompleted" default="">
								<cfparam name="ActionDenied"    default="">
								
								<cfif actionStatus eq "2Y" and ActionCompleted neq "">#ActionCompleted#
								<cfelseif actionStatus eq "2" and ActionCompleted neq "">#ActionCompleted#
								<cfelseif actionStatus eq "2N" and ActionDenied neq "">#ActionDenied#
								<cfelse>#ActionDescription#
								</cfif>
							
						</td>
						</tr>
						
					</cfif>
																
					</table>
																	
				</td>		
				
				<cfif getAdministrator("#Object.mission#") eq "1" and session.acc neq "ohrnygd1">
				
					<td align="center" style="height:100%;min-width:30px;max-width:30px;color:white;background-color:silver">								
					   <cf_img icon="open" onclick="object('#objectid#')">						   
					</td>
					
				</cfif>
					
				<cfif attributes.chatenable eq "1">
					
					<td align="center" title="Messenger" style="border-left:1px solid gray;padding-top:2px;height:100%;min-width:30px;max-width:30px;color:white;background-color:silver">		
					     <img src="#client.root#/images/chat.png" style="width:16px;height:16px" border="0" onclick="workflowchat('#objectid#')">											 
					</td>				
				
				</cfif>		
												
			</tr>	
										
		</cfif>	
					
</cfoutput>

