
<cfoutput>

  <table style="width:100%;height:100%;<cfif incumbency eq "0">background-color:ffffaf</cfif>">
					
		 <tr>
		 <td valign="top" style="width:100%;padding:2px">
		 
			 <table style="width:100%">
			 <tr>
			  <td valign="top" style="width:85px;padding-left:4px;padding-right:10px;">
			 			  
			  <table>
				  <tr><td>
				  
				  <cfif incumbency eq "0">						  
				     <cfset size = "85px">
				  <cfelse>
				     <cfset size = "85px">
				  </cfif>				 
				 
				  <cfset ind = rereplace(Indexno,'^0+','','ALL')>	
				 				 				 											  
				  <cfif FileExists("#SESSION.rootDocumentPath#\EmployeePhoto\#IndexNo#.jpg") and indexNo gt "0">                           		
						<cfset pict = IndexNo>  						
				  <cfelseif FileExists("#SESSION.rootDocumentPath#\EmployeePhoto\#ind#.jpg")>                           						  
						<cfset pict = ind>     				   									    						
				  <cfelseif FileExists("#SESSION.rootDocumentPath#\EmployeePhoto\#Personno#.jpg")>   
						<cfset pict = Personno>	   																	
				  <cfelse>				  
						<cfset pict = "">      
				  </cfif>	
				  
				 			 
				  
				  <cf_UITooltip
					id         = "#assignDetail.AssignmentNo#"
					ContentURL = "PersonDialogView.cfm?assignmentNo=#AssignmentNo#&personNo=#PersonNo#&pict=#pict#"
					CallOut    = "true"
					Position   = "left"
					Width      = "580"
					ShowOn     = "click"
					Height     = "200"
					Duration   = "300">
														  
				  <cfif pict neq "">
				  
				  	  <cfif FileExists("#SESSION.rootDocumentpath#\EmployeePhoto\#pict#.jpg")>				  
						   <cf_getMid>
					  	   <cfset vPhoto = "#SESSION.root#\CFRStage\getFile.cfm?id=#pict#.jpg&mode=EmployeePhoto&mid=#mid#">						  						   
				      <cfelse>
						  <cfif Gender eq "Female">
							  <cfset vPhoto = "#session.root#/Images/Logos/no-picture-female.png">
						  <cfelse>
							  <cfset vPhoto = "#session.root#/Images/Logos/no-picture-male.png">
						  </cfif>
					  </cfif> 	
									
						<img src="#vPhoto#" class="img-circle clsRoundedPicture" style="cursor:pointer;height:#size#; width:#size#;">		
						
						<!---
											 				 
 						<cfset myImage=ImageNew("#SESSION.rootDocumentpath#\EmployeePhoto/#pict#.jpg")>						
					    <cfimage class="img-circle clsRoundedPicture" source="#myImage#" width="#size#" height="#size#" action="writeToBrowser">												
						
						--->
				  
				  <cfelse>
					  					 					  
					  <cfif Gender eq "Female">
						  <cfset vPhoto = "#session.root#/Images/Logos/no-picture-female.png">
					  <cfelse>
						  <cfset vPhoto = "#session.root#/Images/Logos/no-picture-male.png">
					  </cfif>
					  					  
					  <img src="#vPhoto#" class="img-circle clsRoundedPicture" style="cursor:pointer;height:#size#; width:#size#;">		
					  
				  </cfif>		
				  
				  		  
					  </cf_UItooltip>						  
				  				 				   
				  			  
			      </td>
				  </tr>
				  
			      <tr><td align="center" style="font-size:12px">#NationalityName#</td></tr>				  
				  
			  </table>			  			  
			</td>	
									  
			<td valign="top">			  
			  	<table style="width:100%">				
				   <tr style="height:25px">					   					        
						 <td colspan="3" style="width:100%">							 							 
						 <table style="width:100%">
							 <tr class="labelmedium2">
								 <td colspan="2" style="font-weight:bold;font-size:17px">#FirstName# #LastName#</td>
							 </tr>
							 <tr class="labelmedium2" style="height:20px">
								 <td style="font-size:14px">
								  <cfif getAdministrator("#mission#") eq "1">
								  <cf_tl id="Index">## <a href="javascript:EditPerson('#PersonNo#')">#IndexNo#</a>
								  <cfelse>
								  <cf_tl id="Index">## #IndexNo#
								  </cfif>
								 </td>
								 <td style="padding-right:5px" align="right"></td>
							 </tr>
						 </table>					 
						 </td>
				   </tr>	
				   
				    <cfquery name="recruit" 
						datasource="appsEmployee" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">	
					    SELECT    Source, SourceId
						FROM      PersonAssignment
						WHERE     PersonNo = '#PersonNo#'
						AND       PositionNo IN
				                       (SELECT    PositionNo
	            			            FROM      Position
	                        		    WHERE     Mission = '#mission#') 
						AND       Source = 'VAC' 					
						ORDER BY  DateEffective DESC						
					</cfquery>
										
					<cfif recruit.recordcount gte "1">	
					
						<cfset docno = recruit.sourceId>
					
						<cfquery name="Track" 
							datasource="AppsEmployee" 
							username="#SESSION.login#" 
							password="#SESSION.dbpw#">									
								SELECT    D.*, RC.EntityClassName 
								FROM      Vacancy.dbo.Document D INNER JOIN
										  Organization.dbo.Ref_EntityClass RC ON RC.EntityClass = D.EntityClass AND RC.EntityCode = 'VacDocument'		
								WHERE     D.DocumentNo = '#docno#' 
						</cfquery>	
				
						<cfquery name="FO" 
							datasource="AppsSelection" 
							username="#SESSION.login#" 
							password="#SESSION.dbpw#">												
								SELECT    D.*
								FROM      Functionorganization D 		
								WHERE     FunctionId = '#Track.Functionid#' 												
						</cfquery>			

						<tr class="labelmedium2">					      						   
					   	   <td class="fixlength" colspan="2" style="max-width:100px;padding-left:4px;font-size:12px;background-color:f1f1f1;padding-right:5px;">#Track.entityclassName#</td>
						   
						   <td align="right" style="padding-right:5px;color:green">						   					   
						   <cfif fo.recordcount eq "1"><A href="javascript:va('#FO.FunctionId#');">#FO.ReferenceNo#</a><cfelse>#docno#</cfif>
						   </td>	
						   				   	   	   		
						</tr>	
						
						<tr><td colspan="3" class="line"></td></tr>
					 
				   </cfif> 		
				   
				   <cfset extendctr = "0">
				   <cfset extendass = "0">		
				   				  				   								   
				   <cfif getContract.ContractLevel neq "">	
				   	
					   <tr class="labelmedium2" style="height:20px">							   
					   	   <td class="fixlength" style="padding-left:4px;font-size:12px;background-color:f1f1f1;padding-right:5px;" colspan="2"><cf_tl id="Type of appointment"></td>
					       <td align="right" style="padding-right:5px">#getContract.ContractType#</td>
					   </tr>	
					   
					   <tr><td colspan="3" class="line"></td></tr>							   
					   							   
					   <tr class="labelmedium2" style="height:20px">
						   <td class="fixlength" style="padding-left:4px;font-size:12px;background-color:f1f1f1;padding-right:5px;"><cf_tl id="Grade">|<cf_tl id="Step"></td>
						   <cfif getContractAdjustment.recordcount gte "1">
						   <td class="fixlength"><font size="1">SPA</font> #getContractAdjustment.PostAdjustmentLevel# | #getContractAdjustment.PostAdjustmentStep#</td>
						   <cfelse>
						   <td></td>
						   </cfif>
						   <td align="right" class="fixlength" style="padding-right:5px">#getContract.ContractLevel# | #getContract.ContractStep#</td>
					   </tr>
						   								   
					   <cfif Postgroup eq "Used" and PostGrade neq getContract.ContractLevel and incumbency eq "100">   
						   
						   	<tr>
							 								   
						     <cfset url.ajaxid = "spa_#PositionParentId#">
	
							 <input type="hidden" 
								   name="workflowlink_#url.ajaxid#" 
								   id="workflowlink_#url.ajaxid#" 		   
								   value="StaffingPositionWorkflowEvent.cfm">		
								   
							 <input type="hidden" 
								   name="workflowcondition_#url.ajaxid#" 
								   id="workflowcondition_#url.ajaxid#" 		   
								   value="?personno=#Personno#&positionparentid=#PositionParentid#&ajaxid=#url.ajaxid#&mde=spa&thisorgunit=#thisorgunit#">	
						   
							   <td id="#url.ajaxid#" colspan="3" align="center" style="padding:0px">
								   <cfset mde = "spa">
								   <cfinclude template="StaffingPositionWorkflowEvent.cfm">	
							   </td>
							   
							 </tr> 	
									   
													   
						</cfif>
						
						<tr><td colspan="3" class="line"></td></tr>
												 					   
						<cfif getContract.DateExpiration neq "">							   
						   
							   <tr class="labelmedium2" style="height:20px">
								   <td class="fixlength" style="padding-left:4px;font-size:12px;background-color:f1f1f1;padding-right:5px;" colspan="2"><cf_tl id="Appointment Expiry"></td>
								   <td align="right" style="padding-right:5px">
								   
								   <!--- check if there is an event for contract that has a later date --->
								   
									   <cfquery name="Cleared" 
										datasource="AppsEmployee" 
										username="#SESSION.login#" 
										password="#SESSION.dbpw#">									   
									       SELECT    TOP (1) ActionDateExpiration
	                                       FROM      PersonEvent
	                                       WHERE     PersonNo     = '#PersonNo#' 
										   AND       EventTrigger = 'CONTRA' <!--- generic a bit more --->
										   AND       ActionStatus = '3'
	                                       ORDER BY  Created DESC
									   </cfquery>	
									   
									   <cfif cleared.actionDateExpiration gt getContract.DateExpiration>
									   
									       #dateformat(Cleared.ActionDateExpiration,client.dateformatshow)# *
										   										   									   									   
									   <cfelse>
									    
										   <cfif dateDiff("d",now(),getContract.DateExpiration) lte 50>
										   <font color="FF0000">#dateformat(getContract.DateExpiration,client.dateformatshow)#</font>
										   <cfset extendctr = "1">
										   <cfelse>
										   #dateformat(getContract.DateExpiration,client.dateformatshow)#
										   </cfif>		
									   									   
									   </cfif>  							  
									   
								   </td>
							   </tr>
							   
							   <cfif PostGroup eq "Used" and getContract.AppointmentType neq "Permanent">
							   
							   <tr>									   
							   
							     <cfset url.ajaxid = "ctr_#PositionParentId#">
		
								 <input type="hidden" 
									   name="workflowlink_#url.ajaxid#" 
									   id="workflowlink_#url.ajaxid#" 		   
									   value="StaffingPositionWorkflowEvent.cfm">		
									   
								 <input type="hidden" 
									   name="workflowcondition_#url.ajaxid#" 
									   id="workflowcondition_#url.ajaxid#" 		   
									   value="?personno=#Personno#&positionparentid=#PositionParentid#&ajaxid=#url.ajaxid#&mde=ctr&thisorgunit=#thisorgunit#">	
							   
							     <td colspan="3" id="#url.ajaxid#" align="center" style="padding:0px">
							     <cfset mde = "ctr">
							     <cfinclude template="StaffingPositionWorkflowEvent.cfm">	
								 </td>
								 
							   </tr>
							   
							   </cfif>
							   
							   <tr><td colspan="3" class="line"></td></tr>
						   
						   </cfif>
						   
					 </cfif>	   
					   
					 <cfset extend = "0">  	
					 
					 <!--- we define if the person has an assignment beyond the one found on the position today --->
					 				 
					 <cfquery name="getLastAssign" 
						datasource="appsEmployee" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">								 
						SELECT    PA.*
						FROM      PersonAssignment PA
						WHERE     PersonNo = '#PersonNo#' 
						AND       PositionNo IN (SELECT PositionNo FROM Position WHERE MissionOperational = '#mission#')
						AND       AssignmentStatus IN ('0','1')						
						ORDER BY  DateExpiration DESC							
					 </cfquery> 	
					 
					 <!--- remove me						 			
					 				  
					 <cfif PostGroup eq "Used" and incumbency eq "100"
					     and DateExpiration neq "" <!--- has an expiration --->
						 and AssignmentClass neq "regular">									 						
						  						 						 								 
						 <cftry>
						 
							 <cfquery name="getAssignZero" 
								datasource="hubEnterprise" 
								username="#SESSION.login#" 
								password="#SESSION.dbpw#">	
							 
								SELECT    *
								FROM      PersonAssignment
								WHERE     IndexNo = '#indexNo#' 
								AND       TransactionStatus = '1' 
								AND       DateEffective < GETDATE() 
								AND       DateExpiration > GETDATE() 
								AND       Incumbency = 0
								
							 </cfquery> 	
						 
						 <cfcatch>
						 
						 	<cfquery name="getAssignZero" dbtype="query">
								SELECT     *
								FROM       Assignment
								WHERE      PersonNo  = '#PersonNo#' 		
								AND        Incumbency = '0'		
						    </cfquery>	
						 
						 </cfcatch>							 
						
						</cftry>	
					
					</cfif>	  	
					
					--->
								
					
					<!--- special condition in UN hardcoded --->					
					<cfif DateExpiration lt getContract.DateExpiration and assignmentclass neq "Regular" and assignmentclass neq "TmpAppt" and assignmentclass neq "Admin">
					    <cfset extend = "1">						
					</cfif>
										
					<cfif (extend eq "1" and PostGroup eq "Used") or PostGroup eq "Float">
					 
					  <tr class="labelmedium2">
					   <td style="padding-left:4px;font-size:12px;background-color:f1f1f1;padding-right:5px;" colspan="2">
					   <cfif getLastAssign.PositionNo neq PositionNo><b>*</b></cfif>	
					   <cf_tl id="Assignment Expiry">					   				   
					   </td>
					   <td align="right" style="padding-right:5px">
					   	  <cfif getLastAssign.DateExpiration neq "">
							   <cfif dateDiff("d",now(),getLastAssign.DateExpiration) lte 50>						   
							       <span style="color:##FF0000;">#dateformat(getLastAssign.DateExpiration,client.dateformatshow)#</span>		
								   <cfset extendass = "1">					   
							   <cfelse>						   
							    #dateformat(getLastAssign.DateExpiration,client.dateformatshow)#							
							   </cfif>
						   </cfif>								   
					   </td>							   
					   </tr>
					 							   
					   <tr>							   
					   <cfset url.ajaxid = "ass_#PositionParentId#">

						 <input type="hidden" 
							   name="workflowlink_#url.ajaxid#" 
							   id="workflowlink_#url.ajaxid#" 		   
							   value="StaffingPositionWorkflowEvent.cfm">		
							   
						 <input type="hidden" 
							   name="workflowcondition_#url.ajaxid#" 
							   id="workflowcondition_#url.ajaxid#" 		   
							   value="?personno=#Personno#&positionparentid=#PositionParentid#&ajaxid=#url.ajaxid#&mde=ass&thisorgunit=#thisorgunit#">	
					   
						 <td id="#url.ajaxid#" colspan="3" align="center" style="padding:0px">						 
						   <cfset mde = "ass">
						   <cfinclude template="StaffingPositionWorkflowEvent.cfm">	
						 </td>
						 
					   </tr>
				   
									   
				   </cfif>
				   
			 </table>
							 
		  </td>		
		  		    
		  </tr>	 
	</table> 		
	
 </td>		  
 </tr>	 
</table> 		

</cfoutput>				 