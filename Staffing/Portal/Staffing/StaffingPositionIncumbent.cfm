
<cfoutput>

  <table style="width:100%;height:100%;<cfif incumbency eq "0">background-color:ffffaf</cfif>">
					
		 <tr class="line">
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
				  
				  <cfif pict neq "">
				  
					  	<cfset  vPhoto = "#SESSION.rootDocument#/EmployeePhoto/#pict#.jpg?id=1">
				  
				  <cfelse>
					  					  
					  <cfif Gender eq "Female">
						  <cfset vPhoto = "#session.root#/Images/Logos/no-picture-female.png">
					  <cfelse>
						  <cfset vPhoto = "#session.root#/Images/Logos/no-picture-male.png">
					  </cfif>
					  
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
				      <img src="#vPhoto#" class="img-circle clsRoundedPicture" style="cursor:pointer;height:#size#; width:#size#;">					  
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
					   	   <td colspan="2" style="padding-right:5px;">#Track.entityclassName#:</td>
				   	   	   <td align="right" style="padding-right:5px;color:green"><cfif fo.recordcount eq "1">#FO.ReferenceNo#<cfelse>#docno#</cfif></td>				
						</tr>	
						
						<tr><td colspan="3" class="line"></td></tr>
					 
				   </cfif> 				   	
				   								   
				   <cfif getContract.ContractLevel neq "">	
				   	
					   <tr class="labelmedium2">							   
					   	   <td colspan="2"><cf_tl id="Type of appointment">:</td>
					       <td align="right" style="padding-right:5px">#getContract.ContractType#</td>
					   </tr>	
					   
					   <tr><td colspan="3" class="line"></td></tr>							   
					   							   
					   <tr class="labelmedium2">
						   <td><cf_tl id="Grade">|<cf_tl id="Step">:</td>
						   <cfif getContractAdjustment.recordcount gte "1">
						   <td align="right" style="padding-right:5px">SPA: #getContractAdjustment.PostAdjustmentLevel# | #getContractAdjustment.PostAdjustmentStep#</td>
						   <cfelse>
						   <td></td>
						   </cfif>
						   <td align="right" style="padding-right:5px">#getContract.ContractLevel# | #getContract.ContractStep#</td>
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
								   value="?personno=#Personno#&positionparentid=#PositionParentid#&ajaxid=#url.ajaxid#&mde=spa">	
						   
							   <td id="#url.ajaxid#" colspan="3" align="center" style="padding:2px">
								   <cfset mde = "spa">
								   <cfinclude template="StaffingPositionWorkflowEvent.cfm">	
							   </td>
							   
							 </tr> 	
									   
													   
						</cfif>
						
						<tr><td colspan="3" class="line"></td></tr>
						 					   
						<cfif getContract.DateExpiration neq "">							   
						   
							   <tr class="labelmedium2">
								   <td colspan="2"><cf_tl id="Appointment Expiry">:</td>
								   <td align="right" style="padding-right:5px">
									   <cfif dateDiff("d",now(),getContract.DateExpiration) lte 50>
									   <font color="FF0000">#dateformat(getContract.DateExpiration,client.dateformatshow)#</font>
									   <cfelse>
									   #dateformat(getContract.DateExpiration,client.dateformatshow)#
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
									   value="?personno=#Personno#&positionparentid=#PositionParentid#&ajaxid=#url.ajaxid#&mde=ctr">	
							   
							     <td colspan="3" id="#url.ajaxid#" align="center" style="padding:2px">
							     <cfset mde = "ctr">
							     <cfinclude template="StaffingPositionWorkflowEvent.cfm">	
								 </td>
								 
							   </tr>
							   
							   </cfif>
							   
							   <tr><td colspan="3" class="line"></td></tr>
						   
						   </cfif>
						   
					 </cfif>	   
					   
					 <cfset extend = "0">  
					 
					 <cfif PostGroup eq "Used" and incumbency eq "100"
					     and DateExpiration neq "" <!--- has an expiration --->
						 and getContract.AppointmentType neq "Temporary" or getContract.AppointmentType eq "">
						 
						 						 								 
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
																										
						<cfif getAssignZero.recordcount gte "1" or getContract.AppointmentType eq "" or DateExpiration lt getContract.DateExpiration>								 
							 <cfset extend = "1"> 								 
						</cfif> 
					 
					
					</cfif>	  
					 
					<tr class="labelmedium2">
					   <td colspan="2"><cf_tl id="Assignment Expiry">:</td>
					   <td align="right" style="padding-right:5px">
						   <cfif dateDiff("d",now(),DateExpiration) lte 50>
						   <span style="color:##FF0000;">#dateformat(DateExpiration,client.dateformatshow)#</span>
						   <cfelse>
						    #dateformat(DateExpiration,client.dateformatshow)#
						   </cfif>							   
					   </td>							   
					</tr>
					   
					<cfif extend eq "1" and PostGroup eq "Used">
							   
					   <tr>							   
					   <cfset url.ajaxid = "ass_#PositionParentId#">

						 <input type="hidden" 
							   name="workflowlink_#url.ajaxid#" 
							   id="workflowlink_#url.ajaxid#" 		   
							   value="StaffingPositionWorkflowEvent.cfm">		
							   
						 <input type="hidden" 
							   name="workflowcondition_#url.ajaxid#" 
							   id="workflowcondition_#url.ajaxid#" 		   
							   value="?personno=#Personno#&positionparentid=#PositionParentid#&ajaxid=#url.ajaxid#&mde=ctr">	
					   
						 <td id="#url.ajaxid#" colspan="3" align="center" style="padding:2px">
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