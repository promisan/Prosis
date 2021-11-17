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
				 
				<cfset cl = "##FFEBCF">
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
				
			<!---	
								
			<cfelseif ActionType eq "Decision">
			    <cfset cl     = "">
				<cfset box    = "4ED4CA">
				<cfset action = "0">
				
			--->
								
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
																									
			<tr bgcolor="#cl#" class="labelmedium" style="<cfif currentrow neq '1'>border-top:1px dotted silver</cfif>">
			
			   <td align="center" style="width:50px;">
			   
			    <cfset sub = "0">	
			   			   			  	   
				<cfswitch expression="#ActionStatus#">
				
				   	<cfcase value="0">
					
						<cfif attributes.subflow eq "Yes">
						
							 <img style="opacity:0.8;margin-right: 6px;" src="#SESSION.root#/Images/Sub-Workflow.png" width="24" height="24"
						     alt="Embedded Step"
						     border="0"
						     align="right">
									
						<cfelseif object_op is 1 
						     and enableNotification eq "1" 
							 and (isActor.recordcount gte "1" or getAdministrator(attributes.Mission) eq "1")>
						
						    <button name="mail" id="mail"
							    class="button3" 
								type="button" 
								onClick="remind('#Objectid#','#ActionCode#')">
									<img style="top:-1px;position:relative;" src="#SESSION.root#/Images/Notify-Bell.png" width="36" height="36" 
									alt="Send a reminder" 
									border="0" 
									align="texttop" 
									style="cursor: pointer;">
							</button>
													
						 <cfelse>
						 					 
						 <cfif actionTrigger eq "" and
						       (EntityAccess eq "EDIT" or EntityAccess eq "ALL")  and
	               			   Action eq "1" and object_op is 1>								 				 					 
						 
						   <img src="#SESSION.root#/Images/Alert-W.png" width="32" height="32" style=""
							     alt="Current Action"
							     border="0"
							     align="absmiddle"
							     style="cursor: pointer; height:25px;"
							     onClick="javascript:process('#ActionId#','#attributes.preventProcess#','#Attributes.ajaxid#')">
							 
						   <cfelseif actionTrigger neq "">
						   	 
							  <img src="#SESSION.root#/Images/Processing.png"
							     alt="Waiting for External Process"
							     border="0"
							     align="absmiddle"
							     style="cursor: pointer; height:25px;">
							 
						   </cfif>	 
								 
						</cfif>		 
					
					</cfcase>
					<cfcase value="1"><b><cf_tl id="Pending"></b></cfcase>
					
					<cfcase value="2">
					
					  <cfif attributes.subflow eq "Yes">
					  		<cfset sub = "1">			  						
							 <img style="opacity:0.8;top:3px;position:relative;margin-right: 6px;" src="#SESSION.root#/Images/Sub-Workflow.png" width="24" height="24" alt="Embedded Step" border="0" align="right">
							 	
					  <cfelseif ActionCodeOnHold eq "">
					  
							<img style="top:4px;position:relative;" src="#SESSION.root#/Images/Processed.png" width="32" height="32" alt="Action has been completed"  
								 border="0" align="absmiddle">								 
								 
					  <cfelse>
					        
							<img style="top:4px;position:relative;" src="#SESSION.root#/Images/Send.png" alt="Action was cancelled" width="32" height="32" 
								 border="0" align="absmiddle">
								 <cfset box = "rgba(3, 63, 93,0.4)">								
								
					  </cfif>		
					  	 
					</cfcase>
					
					<cfcase value="2Y">
						 <cfif attributes.subflow eq "Yes">		
						     <cfset sub = "1">					
							 <img style="opacity:0.8;top:3px;position:relative;margin-right: 6px;" src="#SESSION.root#/Images/Sub-Workflow.png" width="24" height="24" alt="Embedded Step" border="0" align="right">							
						<cfelse>
							<img style="top:4px;position:relative;" src="#SESSION.root#/Images/Processed.png" width="32" height="32"  alt="Positive decision"  
								 border="0" align="absmiddle">
						</cfif>
					</cfcase>
					
					<cfcase value="2N">
						 <cfif attributes.subflow eq "Yes">		
						 	 <cfset sub = "1">				
							 <img style="opacity:0.8;top:3px;position:relative;margin-right: 6px;" src="#SESSION.root#/Images/Sub-Workflow.png" width="24" height="24" alt="Embedded Step" border="0" align="right">							
						 <cfelse>
						   <cfif currentrow eq "1">
							<img src="#SESSION.root#/Images/Stopped.png" width="32" height="32" alt="Negative decision"  
									 border="0" align="absmiddle">
							<cfelse>
							  <img style="padding-top: 10px;" src="#SESSION.root#/Images/Forward.png" width="32" height="32" alt="Action was cancelled"  
									 border="0" align="absmiddle">
					    	</cfif>			
						</cfif>
					</cfcase>
					
				</cfswitch>
				
				</td>
				
				<cfset ht = attributes.rowheight - 10>
				
				<cfif attributes.subflow eq "No" and showaction eq "1">
				
					<cfset ln = "5">														
                    <td valign="top" style="padding:2px 2px 2px 2px">												
				
				<cfelse>
	
					<cfset ln = "2">							
                    <td align="right">
														
				</cfif>
					
					<table height="100%" width="100%">
					
					<cfif (actionstatus eq "0" or currentrow eq 1) and sub eq "0">
					
					<tr><td style="height:10px"></td></tr>			
					
					<!--- nada --->
					
					<cfelse>
					
					<tr>
						<td style="height:20px">																								
							<table width="90%" height="100%" align="center">
					        <tr>
					         <td width="49%"></td>
							 <td width="3%" style="padding:2px 0 2px;">
                                 <img src="#SESSION.root#/Images/Step-Up.png" height="16" alt="Next Step"  border="0" align="absmiddle">                                     
                             </td>                                
							 <td width="48%"></td>
							 </tr>	 
					        </table>	
						
						</td>
					</tr>	
					
					</cfif>
															
					<cfif Action eq "1" and (EntityAccess eq "EDIT" OR EntityAccess eq "READ" or EntityAccess eq "ALL" )>
					
					 <cfset vSquareStyle     = "padding:0px 0 0;border-radius:8px 0 0 8px;max-width:100%">		  
										
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
													
							<tr class="cellcontent">
							<td style="height:43px;padding-right:4%;min-width:200px;">
							 		
							<table width="100%" height="100%">
							   <tr><td style="width:100%">																							
								<table align="center" class="Procets-L" style="height:100%;width:100%;height:40px;max-width:360px;background-color:#box#;#vSquareStyle#;">								
									<tr>									
									<td style="min-width:10px"></td>	
									<cfif Dialog.DocumentMode eq "Popup">																									
									<td align="center" class="labelmedium" style="width:100%;cursor: pointer;font-size:14px;line-height:14px;color:rgba(255,255,255,1);font-weight:400;height:25px;"
										  onClick="<cfif Object_op eq 1>#Dialog.DocumentTemplate#('#actioncode#','#actionId#','#url.ajaxid#')</cfif>">#ActionDescription#</td>										  
									<cfelse>
									<td align="center" class="labelmedium" style="width:100%;cursor: pointer;font-size:14px;line-height:14px;color:rgba(255,255,255,1);font-weight:400;"
									  ondblClick="<cfif SESSION.isAdministrator eq 'Yes'>javascript:stepedit('#Actions.EntityCode#','#Actions.EntityClass#','#Actions.ActionPublishNo#','#ActionCode#')</cfif>"
									  onClick="<cfif Object_op eq 1>#pr#</cfif>">#ActionDescription#</td>	
									</cfif>  	  
									<td width="13" style="padding-left:5px; padding-right:5px;">		
										<img style="padding-top:0;" src="#SESSION.root#/Images/Open-W.png" width="16" height="16"  alt="Open"
									    	onClick="workflowshow('#Actions.ActionPublishNo#','#Actions.EntityCode#','#Actions.EntityClass#','#ActionCode#','#Object.Objectid#')">
									</td>
									</tr>
								</table>	
								</td>							
								<cfinclude template="ActionListingViewLineProcess.cfm">							
								</tr></table>						
							</tr>									
																
					<cfelse>
					
						<cfset vSquareStyle     = "padding:5px 0 0;border-radius:8px;max-width:95%">   
					
						<cfif ActionDialogContent neq "">
						    <cfset pr = "javascript:actionlog('#ActionId#')">
						<cfelse>
						    <cfset pr = "">
						</cfif>						
					
						<tr><td style="<cfif sub eq '0'>height:43px<cfelse>height:25px</cfif>;min-width:200px;max-width:340px">
								
								<cfif sub eq "1">	
								    <cfset box = "FFFF97">																				
								<cfelseif box eq "C7FECB">
									<cfset boxend = "##77C97D">
								<cfelseif box eq "##C9EDF1">
									<cfset boxend = "##7DC9D1">
								<cfelse>
									<cfset boxend = "gray">
								</cfif>																														
																					
								<table width="100%" height="100%" onClick="#pr#"
									 style="<cfif pr neq "" or SESSION.isAdministrator eq 'Yes'>cursor: pointer;</cfif> background-color:#box#; #vSquareStyle#;"
									 ondblClick="<cfif SESSION.isAdministrator eq "Yes">javascript:stepedit('#Actions.EntityCode#','#Actions.EntityClass#','#Actions.ActionPublishNo#','#ActionCode#')</cfif>">
										<tr class="fixlengthlist labelmedium">
																																																						
											<cfparam name="ActionCompleted" default="">
											<cfparam name="ActionDenied" default="">
											
											<cfif actionStatus eq "2Y" and ActionCompleted neq "">
											<cfset lbl = "#ActionCompleted#">
											<cfelseif actionStatus eq "2" and ActionCompleted neq "">
											<cfset lbl = "#ActionCompleted#">
											<cfelseif actionStatus eq "2N" and ActionDenied neq "">
											<cfset lbl = "#ActionDenied#">
											<cfelse>
											<cfset lbl = "#ActionDescription#">
											</cfif>
											
											
											<td align="center" title="#ActionCode# #lbl#"
											style="padding-left:10px;padding-right:10px;width:100%;font-size:14px;cursor: pointer;color:rgba(0,0,0,0.7)">
											#lbl#</td>																						
											
										</tr>
								</table>
							
						</td>
						</tr>
						
					</cfif>
					
					<tr><td style="height:4px"></td></tr>
					
					<!--- line connecting --->
										
					</table>
																	
				</td>		
											
				<td style="padding-top:4px;" class="fixlength">
                          
					<table>			
							
						<tr class="labelmedium">										
						<cfif Entity.EnablePerformance eq "1">						
							<td style="font-size: 13px;padding-right:5px"><cf_tl id="within"></td>
							
							<cfif SESSION.isAdministrator eq "Yes">
							<td>
							
								<input type="text" 
								   name="hour#ActionId#" 
								   id="hour#ActionId#"
								   value="#actionTakeAction#" 
								   maxlength="3" 
								   class="regularxl" 
								   style="width: 20px; text-align: center" 
								   onChange="_cf_loadingtexthtml='';ptoken.navigate('#SESSION.root#/tools/entityAction/ActionListingPerformance.cfm?objectid=#objectid#&actionid=#actionid#&hour='+this.value,'perf')">
									
							</td>							
								
							<cfelse>
								<td style="padding-left:4px">
								#ActionTakeAction#
								</td>
							</cfif>
							
							<td style="padding-left:3px;padding-right:3px;font-size: 12px;"><cf_tl id="hr"></td>							
						</cfif>
																
						</tr>					
						
					</table>
				
				</td>
											
				<cfif EnableQuickProcess eq "1" 
				     and ActionStatus eq "2" 
					 and (EntityAccess eq "EDIT" or EntityAccess eq "READ" or EntityAccess eq "ALL" )
					 and Action eq "1">
					
				<td colspan="1" style="padding-top:4px;width: auto;min-width: 120px; ">
				
				    <cfif OfficerFirstName eq "">
					#ActionReference#	
					<cfelse>									
					#OfficerFirstName# #OfficerLastName#<br>
					<cfif officerdate neq "">
					
						<cf_getLocalTime mission    = "#Object.Mission#" 
						                 recorddate = "#dateformat(OfficerDate,CLIENT.DateFormatShow)#"
										 recordtime = "#timeformat(OfficerDate,'HH:MM:SS')#">					
						
						<!--- outputting --->
						#DateFormat(LocalTime,"#client.dateFormatShow#")#@#TimeFormat(LocalTime, "HH:MM")# <font style="font-size: xx-small;"><cfif timezone neq "0:00">[<cfif timezone gt 0>+</cfif>#timezone#]</cfif></font>
					
					</cfif>
					
					</cfif>
				</td>	
							
				<td style="padding-top:4px;width: auto; min-width: 120px;">
				
					<cfif OfficerDate neq "">
															
						<cfif OfficerLeadTime gt 48>
						 #round(OfficerLeadTime/24)#d
						<cfelse> 
						 #numberformat(OfficerLeadTime,"_._")# h 
						</cfif>
					
					</cfif>
										
				</td>	
							
				<td style="padding-top:4px;width: auto;">#DateFormat(OfficerActionDate, CLIENT.DateFormatShow)#</td>
				
				<!---
				<cfelseif object_op is 1 and 
				        Action eq "1" and 
						(EntityAccess eq "EDIT" or EntityAccess eq "READ")>
										 
					<td colspan="4" height="#ht#" valign="middle"> 																					

					     <cfquery name="Dialog" 
								 datasource="AppsOrganization"
								 username="#SESSION.login#" 
								 password="#SESSION.dbpw#">
								 SELECT *
								 FROM  Ref_EntityDocument D
								 WHERE EntityCode  = '#EntityCode#' 
								 AND DocumentCode = '#ActionDialog#'
								</cfquery>
								
						<cf_tl id="Process" var="1">										
											
						<cfif attributes.hideprocess eq "0" and actionTrigger eq "" and showaction is 1>
									
							<cfif Dialog.DocumentMode eq "Popup" and DisableStandardDialog eq "1" >
							
							   <cfif EntityAccess eq "EDIT">
														
								  <cf_button type="button" 
							       onClick="#Dialog.DocumentTemplate#('#ActionCode#','#ActionId#')" 								  
								   value="#lt_text#">
								   
								</cfif>   
																		
							<cfelse>
							
								<cfif Attributes.Subflow eq "No">
														
								   <cf_button2 type="button" 
									  text="#lt_text#1"
									  onClick="process('#ActionId#','#attributes.preventProcess#','#Attributes.ajaxid#','#ProcessMode#')">									  
																   
								<cfelse>
																
									<cf_button2 type="button" 
								       onClick="process('#ObjectId#','#attributes.preventProcess#','#Attributes.ajaxid#','#ProcessMode#')" 								     
									   text="#lt_text#">							   
									   								   
								</cfif>	   								 						
							
							</cfif>
						
						</cfif>
					
					</td>	
							  --->
				<cfelse>
				
					<td style="padding-top:4px; width: auto;">
					
					<cfif OfficerFirstName eq "">
					#ActionReference#	
					<cfelse>	
					#OfficerFirstName# #OfficerLastName#
					</cfif>
					
					<cfif officerdate neq "">
						<br>
						<cf_getLocalTime mission    = "#Object.Mission#" 
						                 recorddate = "#dateformat(OfficerDate,CLIENT.DateFormatShow)#"
										 recordtime = "#timeformat(OfficerDate,'HH:MM:SS')#">					
						
						<!--- outputting --->
						#DateFormat(LocalTime, "#client.dateFormatShow#")#@#TimeFormat(LocalTime, "HH:MM")# <font style="font-size: xx-small; color:##333333;"><cfif timezone neq "0:00">[<cfif timezone gt 0>+</cfif>#timezone#]</cfif></font><br>
					
						<!--- officer submitted this step leaving the status as Pending --->
						<cfif ActionStatus eq "0">
							<img src="#session.root#/images/Alert-W.png" width="22" height="22" style="top: 7px;position: relative;"><span style="position: relative; left: -3px; font-size: 11px;"><cf_tl id="Pending"></span>
						</cfif>
					
					</cfif>
					
					</td>
										
					<td style="padding-top:4px; width: auto">
															
					<cfif OfficerDate neq "">
					
						<cfif OfficerLeadTime gt 48>
						 #round(OfficerLeadTime/24)#d 
						<cfelse> 
						 #numberformat(OfficerLeadTime,"_._")# h 
						</cfif>
					
					</cfif>
										
					</td>					
					
					<td style="padding-top:4px; width: auto">#DateFormat(OfficerActionDate, CLIENT.DateFormatShow)#</td>
					
				</cfif>
								
				<cfquery name="Mail" 
					 datasource="AppsOrganization"
					 username="#SESSION.login#" 
					 password="#SESSION.dbpw#">
						 SELECT TOP 1 * 
						 FROM  OrganizationObjectActionMail OA
						 WHERE ActionId  = '#ActionId#' 
						 AND   ActionStatus != '8' <!--- 8= preparation --->
				</cfquery>				
					
				<td align="center" valign="middle" style="width: auto; min-width: 20px;"> 
													 
					<cfif Mail.recordcount eq "1">
					 										 	
					 	<img src="#SESSION.root#/Images/Mail-Check.png" alt="Show EMail that was sent" 
			        	id="m#ObjectId#_#objectcnt#_#CurrentRow#Max" 
						border="0"						
						width="32" 
						class="regular" 
						align="absmiddle" 
						style="cursor: pointer;"
						onClick="ajaxdialog('m','#ObjectId#_#objectcnt#_#CurrentRow#','#actionid#')">
											
						<img src="#SESSION.root#/Images/Mail-Open.png" 
						id="m#ObjectId#_#objectcnt#_#CurrentRow#Min" 
						alt="Hide EMail" border="0" height="32"	width="32" align="absmiddle" 
						class="Hide" style="cursor: pointer;"
						onClick="ajaxdialog('m','#ObjectId#_#objectcnt#_#CurrentRow#','#actionid#')">
												
					</cfif>
				
					<cfquery name="Documents" 
						datasource="appsOrganization" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">
						SELECT * FROM OrganizationObjectActionReport
						WHERE  ActionId   = '#ActionId#' 
					</cfquery>		
													
					 <cfif len(ActionMemo) gte "4" or documents.recordcount gte "1">	
					 					 
					 		<img src="#SESSION.root#/Images/More.png" 
							id="d#ObjectId#_#objectcnt#_#CurrentRow#Min" width="32" height="32" alt="View memo/document" border="0" align="absmiddle" class="regular" style="cursor: pointer;" 
							onClick="documentshow('#actionid#','#ObjectId#_#objectcnt#_#CurrentRow#',document.body.clientWidth)">
						
							<img src="#SESSION.root#/Images/Minus.png" width="32" height="32"
							id="d#ObjectId#_#objectcnt#_#CurrentRow#Exp" alt="Hide document" border="0" 
							align="absmiddle" class="hide" style="cursor: pointer;" 
							onClick="documentshow('#actionid#','#ObjectId#_#objectcnt#_#CurrentRow#',document.body.clientWidth)">	
											
					 </cfif>		 
					 					  						  
			    </td>
								
				<td valign="middle" style="width:auto;">
				
				  <table width="100%" cellspacing="0" cellpadding="0" style="width:100%">
				  <tr>
				  
				    <!--- check if there is a predefined attachment option --->
				  					
					<cfquery name="External" 
					datasource="appsOrganization" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
					    SELECT   R.*			
					    FROM     Ref_EntityDocument R,
							     Ref_EntityActionDocument R1
					    WHERE    R1.ActionCode   = '#ActionCode#' 
						AND      R.DocumentId    = R1.DocumentId
						AND      R.DocumentType  = 'Attach'
						AND      R.DocumentMode  = 'Step'
						AND      R.Operational   = 1
						AND      R.DocumentId IN (SELECT DocumentId 
						                          FROM   OrganizationObjectDocument
												  WHERE  ObjectId = '#ObjectId#'
												  AND    Operational = 1) 
												  
						<!--- 17/7/2018 and enabled for the step in the config --->						  
						AND 	EXISTS (SELECT  'X'
						                FROM    Ref_EntityActionPublishDocument
										WHERE   ActionPublishNo = '#ActionPublishNo#' 
										AND     ActionCode = '#ActionCode#' 
										AND     DocumentId = R.DocumentId
										AND     Operational = 1)
										
										  
						ORDER BY DocumentOrder
					</cfquery>
										        
					 <!--- check if there is a predefined questionaire option --->
					<cfquery name="Questionaire" 
						datasource="AppsOrganization" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">
					    SELECT     D.DocumentId, 
						           D.DocumentCode, 
								   D.DocumentDescription,
								   A.ActionCode
					    FROM       Ref_EntityActionDocument A INNER JOIN
					               Ref_EntityDocument D ON A.DocumentId = D.DocumentId
					    WHERE      A.ActionCode   = '#ActionCode#' 
						AND        D.DocumentType = 'Question'
						<!--- enabled for this workflow --->
						AND        D.DocumentId IN (SELECT DocumentId
						                           FROM   Ref_EntityActionPublishDocument 
												   WHERE  ActionPublishNo = '#Object.ActionPublishNo#' 
												   AND    ActionCode = '#ActionCode#' 
												   AND    Operational = 1)
					    ORDER BY   D.DocumentOrder 
					</cfquery>	
					
					<!--- if predefined and we actually do have data in the database --->
					
					<cfquery name="hasAttachment" 
					datasource="appsOrganization" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
						SELECT    TOP 1 *
						FROM      System.dbo.Attachment
						WHERE     DocumentPathName = '#EntityCode#' 
						AND       ServerPath = '#EntityCode#/#ObjectId#/'
					</cfquery>
										
					<cfif external.recordcount gte "1" and hasAttachment.recordcount gte "1">			
					
						  <td align="center">		
					
    					  <img  src    = "#SESSION.root#/Images/attachment.png"
					     	 alt    = "Attachments"
						     name   = "a#actionid#Min"
						     id     = "a#actionid#Min"
						     border = "0"	
							 width  = "16"
							 height = "16"
							 onclick= "showatt('a#actionid#')"								 		
						     align  = "absmiddle"
						     class  = "regular"
					    	 style  = "cursor: pointer; border : 0px solid Silver;">							 
							 
						 <img src    = "#SESSION.root#/Images/portal_min.jpg" 
							id      = "a#ActionId#Exp" 
							alt     = "Hide Attachments" 
							onclick = "showatt('a#actionid#')"								
							border  = "0" 
							align   = "absmiddle" 
							class   = "hide" 
							style   = "cursor: pointer;">
							
						 </td>						
					
					</cfif>						  	
				   
				   <td style="padding-right:5px">  				   
				   	
				   <table>
				   <tr>
				   <td>
				   				
				   <cfif (isActor.userAccount eq SESSION.acc or SESSION.isAdministrator eq "Yes") and Object_op is 1>
				  				  
				   <button name="accessgrantedbutton" id="accessgrantedbutton"
				       class="button3" 
					   type="button" 
					   onClick="accessgrantedwf('u','#ObjectId#_#objectcnt#_#actioncode#_#CurrentRow#','show','#ActionCode#&objectId=#ObjectId#&actionId=#actionid#&i=i#CurrentRow#','#Attributes.OrgUnit#','#Entity.Role#','#actionPublishNo#')">
					
					   <img  src    = "#SESSION.root#/Images/Authorization.png"
					     	 alt    = "Collaboration Info"
						     name   = "u#ObjectId#_#objectcnt#_#actioncode#_#CurrentRow#Min"
						     id     = "u#ObjectId#_#objectcnt#_#actioncode#_#CurrentRow#Min"
						     border = "0"		
							 height = "32"
							 width  = "32"
						     align  = "absmiddle"
						     class  = "regular"
					    	 style  = "cursor: pointer;">							 
						
						<img src    = "#SESSION.root#/Images/Authorization-Close.png" 
						    name    = "u#ObjectId#_#objectcnt#_#actioncode#_#CurrentRow#Exp"
							id      = "u#ObjectId#_#objectcnt#_#actioncode#_#CurrentRow#Exp" 
							alt     = "" 
							border  = "0" 
							height  = "32"
							width   = "32"
							align   = "absmiddle" 
							class   = "hide" 
							style   = "cursor: pointer;">
							
					</button>	
														
					</cfif>	
					
					</td>
					
					<cfif Questionaire.recordcount gte "1">
					
					<td>
					
					<button name="questionbutton" id="questionbutton"
				       class="button3" 
					   type="button" 
					   onClick="questionairewf('u','#ObjectId#_#objectcnt#_#actioncode#_#CurrentRow#','show','#ActionCode#&objectId=#ObjectId#&i=i#CurrentRow#','#object.ObjectId#','#Entity.Role#','#actionPublishNo#')">
					   
					    <img  src    = "#SESSION.root#/Images/Logos/System/Questionaire.png"
					     	 alt    = "Questionaire"						   
						     border = "0"		
							 height = "25"
						     align  = "absmiddle"
						     class  = "regular"							
					    	 style  = "cursor: pointer;">		
				
					</button>	
								
					</td>
					
					</cfif>
					
					</tr>
					</table>									
					</td>
					
					<td class="labellarge">	
					
					<cfparam name="ReopenAccess" default="NONE">	
										
					<cfif Object.Mission eq "">					
						<cfset admin = getAdministrator("*")>						
					<cfelse>					
						<cfset admin = getAdministrator("#Object.Mission#")>					
					</cfif>
																																		
					<cfif (	 admin eq "1" or 					
							 (ReopenAccess eq "EDIT" and Entity.EnableReopen eq "1") or
					         <!--- allow subflow to be reopened --->
					      	 (SESSION.acc eq Object.OfficerUserid and Entity.EntityCodeParent neq "")
						  )
					    and ActionFlowOrder eq checkLast.ActionFlowOrder 
						and CurrentRow eq "1">
										
												
						<cfif Entity.ConditionAlias neq "" and Entity.ConditionScript neq "">
							
								 <cfset val = Entity.conditionscript>
											 
								 <cfset val = replaceNoCase("#val#", "@key1",   "#Object.ObjectKeyValue1#" , "ALL")>
								 <cfset val = replaceNoCase("#val#", "@key2",   "#Object.ObjectKeyValue2#" , "ALL")>
								 <cfset val = replaceNoCase("#val#", "@key3",   "#Object.ObjectKeyValue3#" , "ALL")>
								 <cfset val = replaceNoCase("#val#", "@key4",   "#Object.ObjectKeyValue4#" , "ALL")>
								 
								 <!--- runtime conversion of custom object fields --->
	
								<cfquery name="Fields" 
									 datasource="AppsOrganization"
									 username="#SESSION.login#" 
									 password="#SESSION.dbpw#">	 
								     SELECT    R.EntityCode, R.DocumentCode, R.DocumentDescription, I.DocumentItem, I.DocumentItemValue, R.DocumentId
							         FROM      Ref_EntityDocument AS R INNER JOIN
							                   OrganizationObjectInformation AS I ON R.DocumentId = I.DocumentId AND I.Objectid = '#Object.ObjectId#'
							         WHERE     R.EntityCode   = '#Object.EntityCode#' 
									 AND       R.DocumentType = 'field'
									 ORDER BY R.DocumentOrder
								</cfquery>	       
								
								<cfloop query="fields">
								
								     <cfif documentitem eq "date">
		
										<cfif DocumentItemValue neq "">
									        <cfset dateValue = "">
											<CF_DateConvert Value="#DocumentItemValue#">
											<cfset DTE = dateValue>
											<cfset val = replaceNoCase("#val#", "@#documentcode#","#dateformat(dte,client.datesql)#", "ALL")>
										<cfelse>
										    <cfset val = replaceNoCase("#val#", "@#documentcode#","01/01/1900", "ALL")>
										</cfif>  
									
									<cfelse>
									
									   	<cfset val = replaceNoCase("#val#", "@#documentcode#","#DocumentItemValue#", "ALL")>
									
									</cfif>
		
								</cfloop>								 
								 
								 <cfset val = replaceNoCase("#val#", "@object", "#objectid#" , "ALL")>
								 <cfset val = replaceNoCase("#val#", "@action", "#actionid#" , "ALL")>
								 <cfset val = replaceNoCase("#val#", "@acc",    "#SESSION.acc#" , "ALL")>
								 <cfset val = replaceNoCase("#val#", "@last",   "#SESSION.last#" , "ALL")>
								 <cfset val = replaceNoCase("#val#", "@first",  "#SESSION.first#" , "ALL")>
								 
								 <cfquery name="Check" 
									datasource="#Entity.ConditionAlias#" 
									username="#SESSION.login#" 
									password="#SESSION.dbpw#">
										#preservesinglequotes(val)# 
								 </cfquery>
																																	
								 <cfif check.recordcount eq "0" and Object.operational eq "1">								 
																	
										<cfif attributes.subflow eq "No">
										<a href="javascript:reopen('#ActionId#','#attributes.ajaxid#')" title="Reopen this step of the workflow (Admin only)">
										   <font color="FF0000"><cf_tl id="Undo"></font></a>	
										</cfif>
										
								 <cfelse>
								 
								 		<cf_tl id="Locked">			
													
								 </cfif>
							
						<cfelse>
													
							<cfif attributes.subflow eq "No" and Object.operational eq "1">
								<a href="javascript:reopen('#ActionId#','#attributes.ajaxid#')" title="Reopen this step of the workflow (Admin only)">
								   <font color="FF0000"><cf_tl id="Undo"></font>
								</a>									
							</cfif>
							
						</cfif>
						
					</cfif>
					
					</td>
					<td style="min-width:4"></td>
					</tr>
					</table>
				</td>
								
			</tr>	
										
			<cfif len(ActionMemo) gt "15" or actionReferenceDate neq "">	
			
				<tr>
					<td bgcolor="#cl#" colspan="#col#" style="padding-bottom:1px;">		
						<table cellpadding="0" cellspacing="0" width="88%" align="center">
							<tr>
							     <td bgcolor="#cl#">			
							     <cfif actionReferenceDate neq "">				    
									#ActionReferenceNo#: #dateformat(actionReferenceDate,CLIENT.DateFormatShow)#								
								 </cfif>		
							     </td>							 
								 
								 <cfif find("stylesheet", ActionMemo)>
								 
								 <cfelse>
													 	     
								 <td colspan="#col-2#" align="left" bgcolor="#cl#">
								 
								 <table width="100%" border="0">
								 									 
									 <tr>
									 <td class="labelit" bgcolor="#cl#" style="border:0px dotted silver;word-wrap: break-word; word-break: break-all;padding:5px">
									 
										<cfif len(ActionMemo) lte 100>												 
											#ParagraphFormat(ActionMemo)#										
										<cfelse>										 
											<cf_paragraph mode="cut">#ActionMemo#</cf_paragraph>																 
										</cfif>
										
									 </td>
									 </tr>
																		 
								 </table>
								 
								 </td>
								 
								 </cfif>
								 
							</tr>	
						</table>
					</td>
				</tr>	
										
			</cfif>				
								
			<tr bgcolor="#cl#" style="height:1px">
			    <td colspan="#col#">
				 <table width="99%" border="0" cellspacing="0" cellpadding="0" align="center" style="">
				   <tr><td id="u#ObjectId#_#objectcnt#_#actioncode#_#currentRow#"></td></tr>
				 </table>
				</td>
			</tr>
			
			<cfparam name="ActionCodeEmbed" default="">
									
			<cfif ActionURLDetails neq "" and ActionCodeEmbed neq ActionCode and candidate eq "0">
							
				<tr class="line">
					<td colspan="#col#" id="h#currentrow#">
									
				   <table width="100%" align="center">
				   <tr><td id="urldetail#currentrow#" height="15">   
				   
				    <!--- embedding of a custom template in the view --->
																			  				   				  		
					<cfinvoke component = "Service.Access"  
						method         =   "AccessEntity" 
						objectid       =   "#ObjectId#"
						actioncode     =   "#ActionCode#" 
						mission        =   "#attributes.mission#"
						orgunit        =   "#Attributes.OrgUnit#" 
						entitygroup    =   "#EntityGroup#" 
						returnvariable =   "dialogaccess">	
						
					   <cfset url.line = currentrow>
									
					   <cfset ActionCodeEmbed = ActionCode>		
						  						 					
					   <cfinclude template="../../#ActionURLDetails#"> 	
				   
				   <!--- embedding of a custom template in the view 				  				  
				   <cfdiv id="urldetail#currentrow#" bind="url:#session.root#/tools/entityaction/getEmbeddedList.cfm?line=#currentrow#&ajaxid=#url.ajaxid#&objectid=#objectid#&actioncode=#actioncode#&mission=#attributes.mission#&orgunit=#attributes.OrgUnit#&entitygroup=#entitygroup#&passtru=#ActionURLDetails#">				   
				   --->
				   				   				   
				   </td></tr>	
				   </table>
				   
				</td></tr>
											
			</cfif>					
						
			<cfif Mail.recordcount eq "1">
			
				<tr>
				  <td bgcolor="#cl#" colspan="#col#" id="m#ObjectId#_#objectcnt#_#currentRow#"></td>
				</tr>
								 
			</cfif> 		
					
			<cfquery name="Documents" 
				datasource="appsOrganization" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				SELECT * FROM OrganizationObjectActionReport
				WHERE  ActionId   = '#ActionId#' 
			</cfquery>
																								
			<cfif ActionMemo neq "" or documents.recordcount gte "1">
											
				<cfquery name="Org" 
				 datasource="AppsOrganization">
				 SELECT *
				 FROM Organization
				 WHERE OrgUnit = '#OrgUnit#' 
				</cfquery>				
								
				<tr id="d#ObjectId#_#objectcnt#_#currentrow#" bgcolor="#cl#" class="hide">
				
				    <td align="center" colspan="#col#">
					
					<!--- container for showing documents --->
					
					<table width="100%">						
						<tr><td style="padding:10px" align="center" id="document_#ObjectId#_#objectcnt#_#currentrow#"></td></tr>																					
					</table>
					
					 </td>
				</tr>				
																
			</cfif>			
			
						
			<cf_fileexist
				DocumentPath = "#EntityCode#"
				DataSource   = "appsOrganization"
				SubDirectory = "#ActionId#" 
				Filter       = "">	
													
			<cfif files gte "1">
							
				<tr bgcolor="transparent">
				<td colspan="#col#" style="padding-right:30px">
				  			   
				    <cfset mode         = "inquiry">
			   		<cfset EntityCode   = "#EntityCode#">
				    <cfset ActionId     = "#ActionId#">
					<cfset Box          = "#CurrentRow#">	
					<cfif attributes.ajaxid eq "">
					  <cfset script = "yes">
					<cfelse>
					  <cfset script = "no">
					</cfif>
					<cfset color  = "transparent">		
					
																				
				    <cfinclude template = "ProcessActionAttachment.cfm">
									   					
				</td>
				</TR>
					
			</cfif>			
						
			<!--- attachments --->						
			
			<cfset actid = actionid>
			
			<cfif External.recordcount gt "0">
								
				<tr class="hide" id="atta#actionid#">
									
					<td colspan="#col#" style="padding-right:30px;height:36px">
					
						<table style="width:100%">
						
						<cfloop query="External">											
									  			   
						    <cfset mode         = "inquiry">
					   		<cfset EntityCode   = "#EntityCode#">
						    <cfset ActionId     = "#ActId#">
							<cfset Box          = "#CurrentRow#">	
							<cfif attributes.ajaxid eq "">
							     <cfset script = "yes">
							<cfelse>
							     <cfset script = "no">
							</cfif>
						
							<tr><td>
																						
								<cfif SESSION.isAdministrator eq "Yes" or session.acc eq Object.OfficerUserid>										
								 <cfset md = "yes">
								<cfelse>
								 <cfset md = "no"> 
								</cfif>
															
							    <cf_filelibraryN
									DocumentPath  = "#EntityCode#"
									SubDirectory  = "#ObjectId#" 
									Filter        = "#DocumentCode#"
									LoadScript    = "No"
									color         = "f4f4f4"
									AttachDialog  = "No"
									Width         = "100%"
									Box           = "ext_#Box#_#currentrow#"
									rowheader     = "No"
									Insert        = "#md#"
									Remove        = "#md#">	
								
							</td></tr>
						
						</cfloop>
						
						</table>	
														   					
					</td>
					
				</TR>			
				
			</cfif>
											
			<cfif ActionCodeOnHold neq "">
			
				<cfquery name="Trigger" 
				 datasource="AppsOrganization">
				 SELECT *
				 FROM   Ref_EntityAction
				 WHERE  ActionCode = '#ActionCodeOnHold#' 
				</cfquery>
				
				<tr bgcolor="B5EDFF">
				     
					 <td colspan="#col#" class="cellcontent" align="center" style="color:454545;">
					    <cf_tl id="Sent back to">: <b>#Trigger.ActionDescription#</b>
					</td>
				</tr>
			
			</cfif>		
			
			<cfinclude template="ActionListingViewFields.cfm">
			
			<cfinclude template="ActionListingViewFunction.cfm">
					
			<!---					
			<cfif currentRow neq "#Actions.Recordcount#">		
				<tr class="line"><td colspan="#col#"></td></tr>	
			</cfif>
			--->
						
		</cfif>	
					
</cfoutput>

