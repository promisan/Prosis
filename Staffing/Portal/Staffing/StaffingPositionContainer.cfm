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
<cfoutput>

<cfset hasWorkflow = "0">

<cfif PositionGroup eq "Loaned">
	<cfset color = "##B0B0B0">
<cfelse>
	<cfset color = "##2C3E50">
</cfif>

<table style="width:100%;height:100%">

<tr><td valign="top">

	<table style="width:100%" border="0">
		
		<tr class="line">
		<td valign="top" colspan="2" style="width:100%;padding-top:4px;">
		
			<table style="width:100%">
			
		  	  <!--- position header --->
							
			  <tr>
			  
			  <td colspan="3">
			  
				  <table style="width:100%">
				  
				  <cf_tl id="compress/expand this position" var="1">
				  <td align="center" 
				  		colspan="1" 
						class="clsPostHeader clsPostHeaderText" 
						title="#lt_text#"
				 	 	style="background-color:##1E53A2; cursor:pointer; height:46px; min-width:80px; font-size:18px; font-weight:normal; color:##FFFFFF; border-top-left-radius:5px;"
						onclick="doCompressExpand('#PositionNo#')">
						  #PostGrade#
				  </td>
				  
				  <td align="center" class="clsPostHeader"
					  style="background-color:#color#;height:46px;width:100%;color:black;;border-top-right-radius:5px;padding-left:14px;padding-right:14px">
					  
					  <table style="width:100%">
					  <tr><td colspan="2" align="right" title="#ucase(FunctionDescription)#" style="color:white;font-size:18px;padding-right:5px" class="clsPostHeaderText fixlength">
					  <cfif PositionGroup eq "Loaned">
					  <font color="000000">#ucase(ParentFunctionDescription)#<br><font size="1">[#ucase(FunctionDescription)#]</font></font>
					  <cfelse>
					  #ucase(FunctionDescription)#
					  </cfif></td></tr>
					  <tr>	
					    
					    <cfif OrgUnitOperational neq OwnerOrgUnit>									
						<td class="fixlength" align="center" style="border-radius:5px;padding-left:4px;height:17px;font-size:12px;background-color:##FF8000">	
						<cf_tl id="Owner">: #OwnerOrgUnitName#						
						</cfif>											  
					  
					  </table>
					 					  
					  </td>
				  
				  </table>
			  
			  </td>
			  
			  </tr>
			  			  
			  <tr style="height:28px;width:30%">
			  
				  <td class="fixlength" style="background-color:##e4e4e4;font-size:17px;padding-left:8px;width:160px;"><span style="font-size:12px;">Post##</span>&nbsp;
				  
				  <cfif getAdministrator("#mission#") eq "1">
				  <a href="javascript:EditPosition('#mission#','#MandateNo#','#PositionNo#')" title="Inspect position information"><cfif sourcePostNumber eq "">#PositionParentid#<cfelse>#SourcePostNumber#</cfif></a>
				  <cfelse>
				  <cfif sourcePostNumber eq "">#PositionParentid#<cfelse>#SourcePostNumber#</cfif>
				  </cfif>
				  </td>		
				  				  				  
				  <td align="right" colspan="2" class="fixlength" style="background-color:yellow;padding-right:7px;height:18px;min-width:140px;">
				  
				   <table>
				   <tr class="labelmedium fixlengthlist">
				   
				   		<cfquery name="getGroup" 
							datasource="AppsEmployee" 
							username="#SESSION.login#" 
							password="#SESSION.dbpw#">						  
						        SELECT  PG.PositionNo, PG.PositionGroup, R.Description, R.ShowAsImage
								FROM    Ref_Group AS R INNER JOIN
								        PositionGroup AS PG ON R.GroupCode = PG.PositionGroup
								WHERE   R.GroupDomain = 'Position' 
								AND     R.ShowInView = 1 
								AND     PG.PositionNo = '#PositionNo#'
						</cfquery>
															  
						<cfif getGroup.recordcount gte "1">						  
						  	<td align="center" style="padding-left:3px;padding-right:3px;background-color:##FFDBB780">						  
							  <cfloop query="getGroup">
							  	<cfif showasImage neq "">
								  <img src="#session.root#/images/#showasImage#" height="20" width="20" alt="" border="0">
								<cfelse>#PositionGroup#</cfif>
							  </cfloop>							  
							</td>	
							<td>|</td>						
						</cfif>		
				  
				  <td style="padding-left:3px;padding-right:3px">#PostType#</td>
				  <td>|</td>
				  <td style="padding-left:3px;padding-right:3px">#PostClass#</td>
				  </tr>
				  </table>
				  <!---<cf_tl id="Fund">---></td>	  	  			 
				  
			  </tr>	
			  			  						  
			  <!--- post funding for now disabled, later we can add this again
			  
			  <tr style="background-color:e1e1e1"><td style="padding-left:14px;min-width:90px"><cf_tl id="Post valid">:</td>
			      <td style="width:100%">#DateFormat(DateExpiration,client.dateformatshow)#</td>
				  <td style="background-color:yellow;padding:4px" align="center"></td>
			  </tr>
			  
			  --->
					  
			</table>
			
		</td></tr>
		
		<!--- position classification --->
		
				
		<tr class="labelmedium2 clsBig fixlengthlist">				   
			  
			  <cfif ApprovalPostGrade neq "" or ApprovalPostGrade neq "">		
			    <td align="center" onclick="ViewPosition('#PositionParentId#')" title="Classified as #ApprovalReference#"
				  style="cursor:pointer;height:34px;background-color:##bfff80;padding-left:3px;padding-right:4px">		
				  
				  <cfif ApprovalReference eq "">
				  Classified
				  <cfelse>
				   <u>#ApprovalReference#</u>
				  </cfif>
				  				  
				 <!---
				   
				  <cf_UITooltip
					id         = "position#PositionNo#"
					ContentURL = "PositionDialogView.cfm?positionno=#PositionNo#"
					CallOut    = "true"
					Position   = "left"
					Width      = "480"
					ShowOn     = "click"
					Height     = "200"
					Duration   = "300">												  	  
				      	#ApprovalReference#				  
				  </cf_UItooltip>	
				  --->				  
				    	
				 </td>	
			  <cfelse>
			    <td align="center" 
				  style="height:34px;background-color:##ffb3b3;font-size:13px;padding-left:3px;padding-right:4px">	
			  		<cf_tl id="Not classified">	
				 </td>						
			  </cfif>					 
			  
			  <cfset url.ajaxid = "class_#PositionParentId#">
			  
			  <input type="hidden" 
				   name="workflowlink_#url.ajaxid#" 
				   id="workflowlink_#url.ajaxid#" 		   
				   value="StaffingPositionWorkflowClassification.cfm">		
				   
				  <input type="hidden" 
				   name="workflowcondition_#url.ajaxid#" 
				   id="workflowcondition_#url.ajaxid#" 		   
				   value="?positionparentid=#PositionParentid#&ajaxid=#url.ajaxid#">	
			  
			  <td id="#url.ajaxid#" style="height:100%;width:100%;padding-left:6px;padding-right:6px">		
			  											 	  			 				  
				  <cf_wfActive entityCode="PostClassification" objectkeyvalue1="#PositionParentId#">
				  
				  <cfif wfStatus eq "Closed">		
				  
				      <cf_tl id="Request new Classification" var="1">
				      <input title="Click to initiate a new classification request for this position" 
					  type="button" value="#lt_text#" class="button10g" <cfif getAdministrator eq "0">disabled</cfif> onclick="javascript:AddClassification('#positionparentid#','#url.ajaxid#')" 
					  style="border-radius:2px;width:100%;border:1px solid silver">			  
					  
					  <!--- 
					   <a title="Click to initiate a new classification request for this position" href="javascript:AddClassification('#positionparentid#','#url.ajaxid#')">
					   <cf_tl id="Request new Classification">
					   </a>
					   --->
					   
				  <cfelseif wfStatus eq "Open">		
				  
				  		<cfset hasworkflow = 1>							  						  						  						  			 
				        <cfinclude template="StaffingPositionWorkflowClassification.cfm">										   
					
				  </cfif> 
				  				  					
			   </td>  
			    
		</tr>		  											
		
		<tr class="labelmedium2 clsBig fixlengthlist">
				
		<cfquery name="VacancyClass" 
			datasource="AppsEmployee" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				 SELECT *
				 FROM   Ref_VacancyActionClass C 
				 WHERE  Code = '#VacancyActionClass#'		
			</cfquery>
		
		  <td class="fixlength" title="#VacancyClass.Description#" style="cursor:pointer;min-width:100px;max-width:100px;background-color:#vacancyClass.PresentationColor#;padding:3px" 
		   align="center">#VacancyClass.Description#</td>
			  
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
		
			<td align="center" style="width:100%;height:100%"  id="#url.ajaxid#">					
				<cfinclude template="StaffingPositionWorkflowRecruit.cfm">					
			</td>
			
		</tr>
			
		<cfquery name="AssignDetail" dbtype="query">
			SELECT     *
			FROM       Assignment
			WHERE      PositionNo = '#PositionNo#' 
			<cfif PositionGroup eq "float">
			AND        OrgUnit = '#orgUnitOperational#'	
			</cfif>
			
			<!--- AND        Incumbency != '0' --->
			ORDER BY   Incumbency DESC		
	    </cfquery>	
				
		<cfif AssignDetail.recordcount eq "0">
		
			<tr class="clsBig">
				<td colspan="2" style="height:100px;width:100%">
			     <table style="width:100%;height:100%">
					 <tr>					
					 <td style="font-size:27px;padding-top:64px;text-align:center;color:green;width:100%">
					 	<cf_tl id="Vacant">
					 </td>		  								 
					 </tr>
				 </table>
				 </td>
			</tr>	

			<tr class="clsSmall">
				<td colspan="2" style="height:30px;width:100%">
			     <table style="width:100%;height:100%">
					 <tr>					
					 <td valign="top" style="padding-top:4px;text-align:center;background-color:##FFB0FF50;width:100%">
					 	<cf_tl id="Vacant">
						 <cfif hasworkflow eq "1">
							<cf_tl id="Pending elements to be processed" var="1">
							<i class="fa fa-exclamation-triangle clsSmall" style="color:##fcba03; padding-left:10px; font-size:110%;" title="#lt_text#"></i>
						</cfif>
					 </td>		  								 
					 </tr>
				 </table>
				 </td>
			</tr>	
		
		</cfif>		
						
		<tr class="clsBig"><td style="height:4px"></td></tr>	
		
		</table>
	
	</td>
	</tr>
	
	<cfif AssignDetail.recordcount neq "0">
		
		<cfif AssignDetail.recordcount gt "1">
			
		<tr class="clsBig"><td colspan="2" style="width:100%;height:24px;padding-left:5px">
			
				<table>
				<tr>
				
					<cfloop query="AssignDetail"  startrow="1" endrow="2">
								
					<td style="cursor:pointer;padding-left:4px;padding-right:4px;border:1px solid silver;<cfif incumbency eq "0">background-color:ffffaf</cfif>"
						onclick="$('.clsAssignment_#PositionNo#, .clsIncIcon_#PositionNo#').hide(); $('.clsAssignment_#AssignmentNo#, .clsIncIcon_#assignmentNo#').show(200);">
							<table>
								<tr class="labelmedium">
									<td>
										<cfset vThisIconStyle = "display:none;">
										<cfif incumbency gt "0">
											<cfset vThisIconStyle = "">
										</cfif> 
										<i class="clsIncIcon_#PositionNo# clsIncIcon_#assignmentNo# fa fa-check-circle" 
											style="color:##4883AB; font-size:100%; padding-left:5px; padding-right:5px; #vThisIconStyle#" 
											aria-hidden="true"></i>
										<cfif incumbency gt "0"><cf_tl id="Post User"><cfelse><cf_tl id="Post Owner"></cfif>
									</td>			
									<td style="min-width:25px;height:21px" align="center">
									
									<cfif FileExists("#SESSION.rootDocumentPath#\EmployeePhoto\#IndexNo#.jpg") and indexNo gt "0">                           		
												<cfset pict = IndexNo>  																	    				   									    						
										  <cfelseif FileExists("#SESSION.rootDocumentPath#\EmployeePhoto\#Personno#.jpg")>   
												<cfset pict = Personno>	   																	
										  <cfelse>				  
												 <cfset pict = "">      
										  </cfif>
																			
									 <cfif pict neq "">		
									 
									 	<cffile action="COPY" 
												source="#SESSION.rootDocumentpath#\EmployeePhoto\#pict#.jpg" 
						  		    			destination="#SESSION.rootPath#\CFRStage\EmployeePhoto\#pict#.jpg" nameconflict="OVERWRITE">
									 								  
										 <cfset  vPhoto = "#SESSION.root#\CFRStage\EmployeePhoto\#pict#.jpg?id=1">										  
										 
									 <cfelse>	
									 										  					  
										  <cfif Gender eq "Female">
											  <cfset vPhoto = "#session.root#/Images/Logos/no-picture-female.png">
										  <cfelse>
											  <cfset vPhoto = "#session.root#/Images/Logos/no-picture-male.png">
										  </cfif>											  
										  
									 </cfif>
							
									 <cfset size = "20px">														  
									 <img src="#vPhoto#" class="img-circle clsRoundedPicture" style="height:#size#; width:#size#;">	
												
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
			 
			<tr class="clsBig"><td style="height:0px"></td></tr>					
			
		</cfif>			
			
	</cfif>
		
	<tr><td style="height:100%">	
			
	<cf_divscroll>
	
	<table width="100%">	
		
	<cfif AssignDetail.recordcount neq "0">
		
		<cfset postgroup = PositionGroup>
			
		<cfloop query="AssignDetail" startrow="1" endrow="2">		
		   		
			<cfquery name="getContract" 
				datasource="AppsEmployee" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				SELECT     PC.PersonNo, 
				           PC.Mission, 
						   PC.ContractType, 
						   T.AppointmentType, 
						   PC.DateEffective, 
						   PC.DateExpiration, 
						   PC.ContractLevel, 
						   PC.ContractStep
				FROM       PersonContract AS PC INNER JOIN
                		   Ref_ContractType AS T ON PC.ContractType = T.ContractType
				WHERE      PersonNo = '#PersonNo#' 	
				AND        Mission IN ('UNDEF','#url.mission#')	
				AND        ActionStatus IN ('0','1')
				-- AND        DateEffective <= '#url.selection#'
				ORDER BY   DateEffective DESC					
			</cfquery>				
			
			<cfquery name="getContractAdjustment" 
				datasource="AppsEmployee" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				SELECT     PC.PersonNo, 					           
						   PC.DateEffective, 
						   PC.DateExpiration, 
						   PC.PostAdjustmentLevel, 
						   PC.PostAdjustmentStep
				FROM       PersonContractAdjustment AS PC 
				WHERE      PersonNo = '#PersonNo#' 						
				AND        ActionStatus IN ('0','1')
				AND        DateEffective <= '#url.selection#'
				AND        DateExpiration >= '#url.selection#'
				ORDER BY   DateEffective DESC					
			</cfquery>
									  
			<cfif currentrow eq "1">
			  	<cfset vDisplay= "">
			<cfelse>
			  	<cfset vDisplay = "display:none;">	
			</cfif>
			
			<tr class="clsBig">
				<td colspan="2" class="clsAssignment_#PositionNo# clsAssignment_#AssignmentNo#" valign="top" 
				  style="height:100%;width:100%;padding-right:6px; #vDisplay#" id="ass#AssignmentNo#">		
				  			  		  		     
					<cfinclude template="StaffingPositionIncumbent.cfm">							 					
				</td>					 
			</tr>
						
			<cfset vDisplay = "">

			<cfset vSmallStyleBG = "">
			<cfset vSmallStyleText = "">
			<cfif hasWorkflow eq "1">
				<cfset vSmallStyleBG = "background-color:##1A8CFF;">
				<cfset vSmallStyleText = "color:##FFFFFF;">
			</cfif>

			<tr class="clsSmall line">
				<td colspan="2" class="clsAssignment_#PositionNo# clsAssignment_#AssignmentNo#" valign="top" 
				  style="height:100%;width:100%;padding-right:10px; padding:6px; #vSmallStyleBG# #vDisplay#" id="ass#AssignmentNo#">		
				  	<cfquery name="getCompressPerson" 
						datasource="AppsEmployee" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">
						SELECT     *
						FROM       Person AS P
						WHERE      PersonNo = '#PersonNo#' 					
					</cfquery>				  		     
					<table width="100%">
						<tr>
							<td style="#vSmallStyleText#">							
								<cfif hasworkflow eq "1">
									<cf_tl id="Pending elements to be processed" var="1">
									<i class="fa fa-exclamation-triangle clsSmall" onclick="doCompressExpand('#PositionNo#')" style="color:##fcba03; padding-left:10px; font-size:110%;" title="#lt_text#"></i>
								</cfif>
								#getCompressPerson.FullName#
								
							</td>
							<td align="right" style="#vSmallStyleText#">
								## 
								<cfif getAdministrator("#mission#") eq "1">
								<a style="#vSmallStyleText#" href="javascript:EditPerson('#getCompressPerson.PersonNo#')">#getCompressPerson.IndexNo#</a>
								<cfelse>
								#getCompressPerson.IndexNo#
								</cfif>
							</td>
						</tr>
					</table>						 
				</td>					 
			</tr>			
				
		</cfloop>
	
	</cfif>	
		
	</table>
			
	</cf_divscroll>
					
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
	#PostType#
	#PostClass#
	<cfif hasworkflow eq "1">Pending</cfif>
	<cfif AssignDetail.recordcount eq "0">Vacant<cfelse>
		<cfif extendctr eq "1" or extendass eq "1">Extend</cfif>		
	</cfif>	
	
	<cfloop query="getGroup">#PositionGroup# </cfloop>	
</div>


</cfoutput>