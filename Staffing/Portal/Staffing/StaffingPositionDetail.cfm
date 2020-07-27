
<!--- post conetn box --->

<cfoutput>

<table style="width:100%;height:99%">

<tr><td style="height:100%" valign="top">

	<table style="width:100%">
		
		<tr class="line"><td valign="top" style="padding-top:5px;width:100%;padding-top:7px;">
		
			<table style="width:100%">
							
			  <tr style="border-bottom:1px solid black">
			  
			  <td colspan="3">
			  
				  <table style="width:100%">
				  
				  <td align="center" colspan="1" 
				 	 style="background-color:##2C3E50;height:50px;min-width:80px;font-size:18px;font-weight:normal;color:##FFFFFF;border-top-left-radius:10px">#PostGrade#</td>
				  
				  <td align="center" 
					  style="background-color:##5B92E5;height:50px;width:100%;font-size:15px;font-weight:normal;color:black;;border-top-right-radius:10px">#FunctionDescription#</td>
				  
				  </table>
			  
			  </td>
			  
			  </tr>
			  
			  <tr style="height:32px;width:30%">
			  
			  <td style="background-color:##e4e4e4;font-size:17px;padding-left:8px;width:45%;"><cf_tl id="Post">##&nbsp;#SourcePostNumber#</td>		
			  <td align="center" style="background-color:##B5D0EE;font-size:17px;width:20%;padding-left:8px;padding-right:8px;border-left:1px solid silver">
			  
				  <cfif ApprovalPostGrade neq PostGrade and ApprovalPostGrade neq "">				  
					    #ApprovalPostGrade# #ApprovalReference#						
				  </cfif>		
				  
				  <cf_wfActive entityCode="PostClassification" objectkeyvalue1="#PositionParentId#">
				  
				  <cfset url.ajaxid = "class_#PositionParentId#">
				  
				  <cfif wfStatus eq "Closed">					  
					   <span style="font-size:70%;"><a href="javascript:AddClassification('#positionparentid#','#url.ajaxid#')"><cf_tl id="Classification"></a></span>				  
				  </cfif>
			  			  
			  </td>		
			  <td align="right" style="background-color:##C1E0FF;padding-right:7px;height:18px;width:40%;">#PostType# #PostClass#<!---<cf_tl id="Fund">---></td>	  	  			 
			  </tr>			  		  		
			   
					<!---	  
					   <tr style="background-color:ffffff;height:10px">
					      <td style="padding-top:5px;padding-left:14px;min-width:90px;font-size:10px"><cf_tl id="Classification">:</td>
					   </tr>	  				   
				   --->
						
				   <tr style="background-color:##ffffff"> 
				    
					      <input type="hidden" 
						   name="workflowlink_#url.ajaxid#" 
						   id="workflowlink_#url.ajaxid#" 		   
						   value="StaffingPositionClassificationWorkflow.cfm">		
						   
						  <input type="hidden" 
						   name="workflowcondition_#url.ajaxid#" 
						   id="workflowcondition_#url.ajaxid#" 		   
						   value="?positionparentid=#PositionParentid#&ajaxid=#url.ajaxid#">	
					  
						  <td colspan="3" style="width:100%;padding-left:0px;padding-right:0px" id="#url.ajaxid#">		  
						  	
							  <cfif wfStatus eq "Open">									  						  						  			 
							        <cfinclude template="StaffingPositionWorkflowClassification.cfm">										   
							  </cfif> 
							
						  </td>  
				   </tr>	
							  
			  <!--- post funding for now disabled, later we can add this again
			  
			  <tr style="background-color:e1e1e1"><td style="padding-left:14px;min-width:90px"><cf_tl id="Post valid">:</td>
			      <td style="width:100%">#DateFormat(DateExpiration,client.dateformatshow)#</td>
				  <td style="background-color:yellow;padding:4px" align="center"></td>
			  </tr>
			  
			  --->
					  
			</table>
			
		</td></tr>
				
		<cfset url.ajaxid = "recruit_#PositionParentId#">
		
		<input type="hidden" value="refresh" id="refresh_#url.ajaxid#" onclick="workflowreload('#url.ajaxid#')">
					
		 <input type="hidden" 
			   name="workflowlink_#url.ajaxid#" 
			   id="workflowlink_#url.ajaxid#" 		   			   
			   value="StaffingPositionWorkflowRecruit.cfm">		
			   
		 <input type="hidden" 
			   name="workflowcondition_#url.ajaxid#" 
			   id="workflowcondition_#url.ajaxid#" 		   
			   value="?positionparentid=#PositionParentid#&ajaxid=#url.ajaxid#">	
		
		<tr class="labelmedium">
		
		<td align="center" colspan="2" style="height:34px;width:100%;background-color:##D5FFD5;" id="#url.ajaxid#">
		
			<cfinclude template="StaffingPositionWorkflowRecruit.cfm">	
		
		</td>
		</tr>
	
		<cfquery name="AssignDetail" dbtype="query">
			SELECT     *
			FROM       Assignment
			WHERE      PositionNo = '#PositionNo#' 
			<!--- AND        Incumbency != '0' --->
			ORDER BY   Incumbency DESC		
	    </cfquery>	
		
		<cfif AssignDetail.recordcount eq "0">
		
			<tr><td style="height:220px;width:100%">
			     <table style="width:100%;height:100%">
					 <tr>					
					 <td valign="top" style="padding-top:4px;text-align:center;background-color:##FFB0FF50;width:100%"><cf_tl id="Vacant"></td>		  								 
					 </tr>
				 </table>
			</tr>	
		
		</cfif>	
		
		<cfquery name="AssignDetail" dbtype="query">
			SELECT     *
			FROM       Assignment
			WHERE      PositionNo = '#PositionNo#' 		
			ORDER BY   Incumbency DESC		
	    </cfquery>		
		
				 	
		<cfif AssignDetail.recordcount neq "0">
		
			<cfif AssignDetail.recordcount gt "1">
			
				<tr><td style="width:100%;height:28px;padding-left:5px">
				
					<table>
					<tr>
					
						<cfloop query="AssignDetail"  startrow="1" endrow="2">
									
						<td 
							style="cursor:pointer;padding-left:4px;padding-right:4px;border-right:1px solid silver;;border-left:1px solid silver;border-bottom:1px solid silver;<cfif incumbency eq "0">background-color:ffffaf</cfif>"
							onclick="$('.clsAssignment_#PositionNo#, .clsIncIcon_#PositionNo#').hide(); $('.clsAssignment_#AssignmentNo#, .clsIncIcon_#assignmentNo#').show(200);">
								<table>
									<tr class="labelmedium">
										<td>
											<cfset vThisIconStyle = "display:none;">
											<cfif incumbency gt "0">
												<cfset vThisIconStyle = "">
											</cfif> 
											<i class="clsIncIcon_#PositionNo# clsIncIcon_#assignmentNo# fa fa-check-circle" 
												style="color:##4883AB; font-size:125%; padding-left:5px; padding-right:5px; #vThisIconStyle#" 
												aria-hidden="true"></i>
											<cfif incumbency gt "0"><cf_tl id="Post User"><cfelse><cf_tl id="Post Owner"></cfif>
										</td>			
										<td style="min-width:25px;height:25px" align="center">
										
										 <cfif FileExists("#SESSION.rootDocumentPath#\EmployeePhoto\#IndexNo#.jpg") and indexNo gt "0">                           		
												<cfset pict = IndexNo>     				    
										  <cfelseif FileExists("#SESSION.rootDocumentPath#\EmployeePhoto\#Personno#.jpg")>   
												<cfset pict = Personno>	   
										  <cfelse>
												 <cfset pict = "">      
										  </cfif>
										  
										  <cfif pict neq "">
										  
											  	<cfset  vPhoto = "#SESSION.rootDocument#\EmployeePhoto\#pict#.jpg?id=1">
										  
										  <cfelse>
											  					  
											  <cfif Gender eq "Female">
												  <cfset vPhoto = "#session.root#/Images/Logos/no-picture-female.png">
											  <cfelse>
												  <cfset vPhoto = "#session.root#/Images/Logos/no-picture-male.png">
											  </cfif>
											  
										  </cfif>
								
										  <cfset size = "20px">				
										  
										  <img src='#vPhoto#' class="img-circle clsRoundedPicture" style="height:#size#; width:#size#;">	
													
										</td>
									</tr>
								</table>	
						</td>	
						</cfloop>
						
					</tr>
					</table>
					
				</td>
				</tr>
				
			<cfelse>
			
			   <!---
				<tr><td style="height:30px"><cf_tl id="Post user"></td></tr>	
				--->
			
			</cfif>
			
			<cfloop query="AssignDetail" startrow="1" endrow="2">
			
				<cfquery name="getContract" 
					datasource="AppsEmployee" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
					SELECT     PC.PersonNo, PC.Mission, PC.ContractType, T.AppointmentType, PC.DateEffective, PC.DateExpiration, PC.ContractLevel, PC.ContractStep
					FROM       PersonContract AS PC INNER JOIN
	                		   Ref_ContractType AS T ON PC.ContractType = T.ContractType
					WHERE      PersonNo = '#PersonNo#' 	
					AND        Mission IN ('UNDEF','#url.mission#')	
					AND        ActionStatus IN ('0','1')
					AND        DateEffective <= '#url.selection#'
					ORDER BY DateEffective DESC					
				  </cfquery>	
				  
				  <cfif currentrow eq "1">
				  	<cfset vDisplay= "">
				  <cfelse>
				  	<cfset vDisplay = "display:none;">	
				  </cfif>
				
				<tr>
					<td class="clsAssignment_#PositionNo# clsAssignment_#AssignmentNo#" valign="top" style="height:210px;padding:4px;width:100%; #vDisplay#" id="ass#AssignmentNo#">				     
						<cfinclude template="StaffingPositionDetailIncumbent.cfm">			
					</td>					 
				</tr>			
					
			</cfloop>
					
		</cfif>	
		
		</table>
	
	</td>
	</tr>
	
</table>

<div class="clsSearchCriteria">
	#AssignDetail.fullname# 
	#AssignDetail.indexNo# 
	#PostGrade# 
	#functionDescription# 
	#SourcePostNumber#
	#AssignDetail.NationalityName#
</div>

</cfoutput>