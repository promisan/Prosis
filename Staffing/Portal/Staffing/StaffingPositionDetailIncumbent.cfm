
<cfoutput>

  <table style="width:100%;height:100%;<cfif incumbency eq "0">background-color:ffffaf</cfif>">
					
		 <tr class="line">
		 <td valign="top" style="width:100%;padding:2px">
		 
			 <table style="width:100%">
			 <tr>
			  <td valign="top" style="width:85px;padding-left:4px;padding-right:10px;padding-top:4px">
			  <table>
				  <tr><td>
				  <cfif incumbency eq "0">						  
				      <cfset size = "80px">
				  <cfelse>
				     <cfset size = "80px">
				  </cfif>
				  <cfif Gender eq "Female">
					  <cfset vPhoto = "#session.root#/Images/Logos/no-picture-female.png">
				  <cfelse>
					  <cfset vPhoto = "#session.root#/Images/Logos/no-picture-male.png">
				  </cfif>
				  <img src="#vPhoto#" class="img-circle clsRoundedPicture" style="height:#size#; width:#size#;">	
			      </td>
				  </tr>
			      <tr><td align="center">#Nationality#</td></tr>
			  </table>
			</td>
						  
			<td valign="top">
			  
			  	<table style="width:100%">
				
				   <tr style="height:25px">						        
						 <td colspan="3" style="width:100%">								 
						 <table style="width:100%">
						  <tr class="labelmedium">
						  <td colspan="2" style="font-size:17px">#LastName#, #FirstName#</td></tr>
						  <tr class="labelmedium" style="height:20px">
						  <td style="font-size:14px"><cf_tl id="Index">## #IndexNo#</td>
						  <td style="padding-right:5px" align="right">#Nationality#</td></tr>
						 </table>								
						 </td>
				   </tr>		
				   								   
				   <cfif getContract.ContractLevel neq "">	
				   	
					   <tr style="height:20px">							   
					   	   <td colspan="2" style="color:gray"><cf_tl id="Type of appointment">:</td>
					       <td align="right" style="padding-right:5px">#getContract.ContractType#</td>
					   </tr>								   
					   							   
					   <tr style="height:20px">
						   <td colspan="2" style="color:gray"><cf_tl id="Grade">/<cf_tl id="Step">:</td>
						   <td align="right" style="padding-right:5px">#getContract.ContractLevel# / #getContract.ContractStep#</td>
					   </tr>
						   								   
					   <cfif PostGrade neq getContract.ContractLevel and incumbency eq "100">   
						   
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
						   
							   <td id="#url.ajaxid#" colspan="3" align="center" style="background-color:e1e1e1;border-radius:8px">
							   <cfset mde = "spa">
							   <cfinclude template="StaffingPositionWorkflowEvent.cfm">	
							   </td>
							   
							  </tr> 								   
													   
						</cfif>
						   
						</tr>	
					   
						   <cfif getContract.DateExpiration neq "">							   
						   
							   <tr style="height:20px">
								   <td style="color:gray" colspan="2"><cf_tl id="Appointment Expiry">:</td>
								   <td align="right" style="padding-right:5px">
									   <cfif dateDiff("d",now(),getContract.DateExpiration) lte 50>
									   <font color="FF0000">#dateformat(getContract.DateExpiration,client.dateformatshow)#</font>
									   <cfelse>
									   #dateformat(getContract.DateExpiration,client.dateformatshow)#
									   </cfif>									  
								   </td>
							   </tr>
							   
							   <cfif getContract.AppointmentType neq "Permanent" or getContract.AppointmentType eq "">
							   
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
							   
							     <td colspan="3" id="#url.ajaxid#" align="center" style="background-color:e1e1e1;border-radius:8px">
							     <cfset mde = "ctr">
							     <cfinclude template="StaffingPositionWorkflowEvent.cfm">	
								 </td>
								 
							   </tr>
							   
							   </cfif>
						   
						   </cfif>
						   
					   </cfif>	   
					   
					 <cfset extend = "0">  
					 
					 <cfif incumbency eq "100"
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
														
						<cfif getAssignZero.recordcount gte "1" or getContract.AppointmentType eq "">								 
							 <cfset extend = "1"> 								 
						</cfif> 
					 
					
					</cfif>	  
					 
					<tr style="height:20px">
					   <td style="color:gray" colspan="2"><cf_tl id="Assignment Expiry">:</td>
					   <td align="right" style="padding-right:5px">
						   <cfif dateDiff("d",now(),DateExpiration) lte 50>
						   <font color="FF0000">#dateformat(DateExpiration,client.dateformatshow)#</font>
						   <cfelse>
						    #dateformat(DateExpiration,client.dateformatshow)#
						   </cfif>							   
					   </td>							   
					</tr>
					   
					<cfif extend eq "1">
							   
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
					   
						 <td id="#url.ajaxid#" colspan="3" align="center" style="background-color:e1e1e1;border-radius:8px">
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