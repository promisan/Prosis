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
<table width="99%" align="center">   

<cf_assignid>

<tr><td>

<table width="99%" align="center" class="navigation_table">    

	<cfif detail.transactionid neq "">
			
		<cfquery name="Requested" 
			datasource="AppsProgram" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			    SELECT   RE.RequestPrice,
						 RE.ExecutionStatus,
				         RE.RequestQuantity, 
						 RE.Requirementid, 
						 RE.PositionNo,
						
						 
						 (SELECT    TOP 1 ProgramCode
						  FROM      ProgramAllotmentRequestMove
						  WHERE     RequirementId = RE.RequirementId
						  AND       Action = 'Move'
						  AND       ProgramCode <> PR.ProgramCode
						  ORDER BY  Created DESC) as Moved,
						  
						 RE.RequestDescription, 
						 RE.ItemMaster,
						 
						 (SELECT Description
						  FROM   Purchase.dbo.ItemMaster
						  WHERE  Code = RE.ItemMaster ) as ItemMasterDescription,
						 
						 RE.ObjectCode,
						 O.RequirementMode,
						 RE.RequestDue,
						 RE.RequestAmountBase,
						 RE.AmountBaseAllotment,
						 RE.AmountBasePercentageDue,
						 
						 <!--- ----------------------- IMPORANT QUERY ------------------------- --->
						 <!--- determine if the requested line was (partially) cleared for allotments for
						   any of its clustered transactions under the same FUND/Object --------- --->			  
						 <!--- ----------------------  important query ------------------------ --->
						  
						  (SELECT  count(*) 
						   FROM    ProgramAllotmentRequest PAR, 
						           ProgramAllotmentDetailRequest PADR, 
								   ProgramAllotmentDetail S
						   WHERE   RE.RequirementIdParent  = PAR.RequirementIdParent <!--- alert : adjusted to consider the full transaction includes ripples and travel complex --->				   
						   AND     RE.Fund                 = PAR.Fund                 <!--- alert : 14/9 I adjusted this to limit within the same OE !!! ripples are now considered ---> 
						   AND     RE.ObjectCode           = PAR.ObjectCode						   
						   AND     PAR.RequirementId       =  PADR.RequirementId
						   AND     PADR.TransactionId      =  S.TransactionId				      
						   AND     PADR.Amount <> '0' <!--- indeed used in allotment --->
						   AND     S.Status IN ('1','9')) as Alloted,
						   
						 <!--- ---------------------- end important query --------------------- --->
						 
						 <!--- old query 
						 (SELECT  count(*)
						  FROM    ProgramAllotmentDetailRequest PADR INNER JOIN
			                      ProgramAllotmentDetail PAD ON PADR.TransactionId = PAD.TransactionId
						  WHERE   PADR.RequirementId = RE.RequirementId
						  AND     PAD.Status = '1'
						 ) as Alloted,	<!--- determine of it has partial allotments --->			 
						 
						 --->						 
						 
						 RE.ActionStatus,
						 RE.OfficerLastName, 
						 Re.OfficerFirstName
						 
			    FROM     ProgramAllotmentRequest RE 
				         INNER JOIN Program PR   ON RE.ProgramCode = PR.ProgramCode 
				         INNER JOIN Ref_Object O ON Re.ObjectCode = O.Code 
							
				WHERE    ( 
							RequirementId IN (
				                           SELECT RequirementId
				                           FROM   ProgramAllotmentDetailRequest AR 
										   WHERE  TransactionId IN (#quotedValueList(detail.transactionid)#)
										   )										  										   
							OR 
							
							( 
							
							RequirementId NOT IN (
				                           SELECT RequirementId
				                           FROM   ProgramAllotmentDetailRequest AR 
										   WHERE  TransactionId IN (#quotedValueList(detail.transactionid)#)
										   )														
							
								<!--- program --->	
								<cfif url.programhierarchy eq "" or url.programhierarchy eq "undefined">			
								AND      RE.ProgramCode = '#URL.ProgramCode#'		
								<cfelse>		
								AND      RE.ProgramCode IN (SELECT ProgramCode 
										                   FROM   ProgramPeriod 
														   WHERE  Period = '#URL.Period#'
														   AND    PeriodHierarchy LIKE '#url.programhierarchy#%')		
								</cfif>
								
								<!--- period --->	
								AND      RE.Period      = '#URL.Period#'		
								<!--- edition --->	
								AND      RE.EditionId   = '#url.edition#' 	
									
								<!--- fund --->	
								<cfif url.fund neq "Total" and url.fund neq "">
								AND      RE.Fund      = '#url.fund#'
								</cfif>		
								<!--- object,parent,resource --->	
								<cfif url.resource eq "resource">		
									AND     RE.ObjectCode IN (SELECT Code FROM Ref_Object WHERE Resource = '#res#')			
								<cfelseif url.isParent eq "1">			
									AND    (
								          RE.ObjectCode = '#url.object#' OR 
							              RE.ObjectCode IN (SELECT Code 
							                               FROM   Ref_Object 
												           WHERE  ParentCode = '#url.object#')
							        	   ) 		
								<cfelse>		
									AND     RE.ObjectCode  = '#url.object#'		
								</cfif>						
												   
								)			   
						
						)								 
						 				   
				AND      ActionStatus != '9'
				AND      PR.Mission = '#Program.Mission#'
				ORDER BY RE.RequestDue
				
				
		</cfquery>	
		
		<cfif requested.recordcount gte "1">
					
		<tr class="line">
		
			<td class="labelmedium" colspan="8" style="font-size:15px"><cf_tl id="Requirement"></td>
			<cfif url.mode neq "list">
				<td colspan="1" class="labelmedium" style="font-size:15px"><cf_tl id="Action"></td>				
			<cfelse>
				<td></td>	
			</cfif>			
		
		</tr>
				
		<cfoutput query="Requested">
					
				<tr class="navigation_row line fixlengthlist">		
						
				<cfif actionstatus eq "0">
					<cfset dec = "label blocked">
				<cfelse>
				    <cfset dec = "labelmedium">
				</cfif>
								
				<td id="#requirementid#_exe" style="width:35px;padding-left:17px" align="center">
				
						
					<cfif ExecutionStatus eq "0">
					
					    <cf_img icon="log" onclick="alldetexecution('#requirementid#','3')"
						   tooltip="Pending Execution">
						   
					<cfelse>
					
						<img  src="#SESSION.root#/images/Validate.gif" 
							  onclick="alldetexecution('#requirementid#','0')"
							  style="cursor:pointer" alt="Executed" border="0" align="absmiddle">
						  
					</cfif>
				
				</td>
								
				<td width="35%" id="#requirementid#_des" style="padding-left:6px" class="#dec#">
					<cfif url.mode neq "List" and alloted eq "0" and RequirementLock eq "0">
					<a href="javascript:alldetinsert('#url.edition#_#url.object#','#url.edition#','#url.object#','#requirementid#','readonly','','#url.programcode#','#url.period#')">
					#ItemMasterDescription# #RequestDescription# 
					</a>
					<cfelse>
					#ItemMasterDescription# #RequestDescription# 
					</cfif>
					
					<cfif PositionNo neq "">
				
					   <cfquery name="Position" 
						datasource="AppsProgram" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">
							 SELECT    *
							 FROM      Ref_AllotmentEditionPosition
							 WHERE     EditionId  = '#url.Edition#'
							 AND       PositionNo = '#PositionNo#'
					   </cfquery>		  
				 				
					<a href="javascript:EditPosition('','','#PositionNo#')"><cfif Position.SourcePostNumber neq "">#Position.SourcePostNumber#<cfelse>#Position.PositionParentId#</cfif></a>
					</cfif>
					
					<cfquery name="program" 
						datasource="AppsProgram" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">
						SELECT * FROM Program WHERE ProgramCode = '#moved#'
					</cfquery>
								
					<cfif moved neq "">
						<br><font size="2" color="C46200">:<cf_tl id="From">#program.programName#</font>
					</cfif>
					
				</td>
													
				<td><cf_space id="#requirementid#_off" spaces="40" label="#officerLastName#" class="#dec#"></td>
				<td id="#requirementid#_dte" align="center" class="#dec#"><cfif RequestDue neq "">#month(RequestDue)#/#year(RequestDue)#</cfif></td>				
				<td align="right"><cf_space spaces="22" id="#requirementid#_qty" class="#dec#" padding="0" align="right" label="#numberformat(RequestQuantity,'__')#"></td>	
				<td align="right"><cf_space spaces="22" id="#requirementid#_prc" class="#dec#" padding="0" align="right" label="#numberformat(RequestPrice,'__,__')#"></td>
				<td align="right" style="padding-right:10px"><cf_space spaces="22" id="#requirementid#_amt" class="#dec#" padding="0" align="right" label="#numberformat(RequestAmountBase,"__,__")#"></td>						
				<cfif url.mode eq "list">
					<td align="right" style="background-color:ffffcf;padding-right:10px"><cf_space spaces="22" id="#requirementid#_amt" class="#dec#" padding="0" align="right" label="#numberformat(AmountBaseAllotment,"__,__")#"></td>	
					<td align="right" style="background-color:ffffaf;padding-right:10px"><cf_space spaces="22" id="#requirementid#_amt" class="#dec#" padding="0" align="right" label="#numberformat(AmountBasePercentageDue*100,'_._')#%"></td>					
				</cfif>
								
				<!--- ---------------------------------- --->
				<!--- --- BOX to show various options -- --->
				<!--- ---------------------------------- ---> 
																
				<cfif actionstatus neq "9" and url.mode neq "list">				
								
					<td colspan="2" align="right" style="padding-left:35px" width="4%">
											
					
						<cfif requested.ActionStatus eq "1">
						   <cfset cl = "regular">
						<cfelse>
						   <cfset cl = "hide">						  
						</cfif>      
											
						<table style="height:20;padding:0px">
						
							<tr>
							
							<!--- ajaxbox --->
							
							<td width="1%" class="hide" id="action_#requirementid#"></td>					
																						
							<td class="#cl#" align="center" 
							   style="width:30px;border-left:0px solid silver;padding-top:2px;padding-left:4px;padding-right:4px" id="y_#requirementid#"> 
							   
							   <cf_space spaces="4">
														
							   <cfif alloted eq "0" or alloted eq "" or (RequirementMode lt "3" and getAdministrator("*") eq "1")>
							   						   
								   <cfif RequirementLock eq "0" and (BudgetOfficer eq "EDIT" or BudgetOfficer eq "ALL")>
								   
									   <cfif url.mode neq "list">
										   <cf_img icon="edit" onclick="alldetinsert('#url.edition#_#url.object#','#url.edition#','#url.object#','#requirementid#','readonly','','#url.programcode#','#url.period#')">
									   </cfif>
								   
								   </cfif>												   		   
							   
							   </cfif>
							   						
							</td>
								
							<td style="min-width:90px">							
																													
								<table width="100%">
								<tr>
									<td align="left" class="#cl#" style="padding-left:3px" id="x_#requirementid#">
																							
								    <cfif BudgetAccess eq "EDIT" or BudgetAccess eq "ALL">
															
									<!--- ------------------------------------------------------ --->	
									<!--- ----- ending is to limit access to these functions---- --->
									<!--- ------------------------------------------------------ --->	
																					
								    <cf_UItooltip tooltip="Set the amount to be released for allotment.">
									
										<input type="text"
										       id="releaseallotment#requirementid#"
										       value="#numberformat(AmountBaseAllotment,',__')#"
											   class="regular3 enterastab"							   
											   style="background-color:ffffaf;padding-top:0px;padding-right:3px;text-align:right;border:1px solid gray;width:72px;height:23px;font-size:14px"
										       onChange="_cf_loadingtexthtml='';ptoken.navigate('#SESSION.root#/ProgramREM/Application/Budget/Allotment/AllotmentInquiryDetailCleared.cfm?mission=#Program.Mission#&requirementid=#requirementid#&value='+this.value+'&action=0&isParent=#url.isParent#&programhierarchy=#url.programhierarchy#&resource=#url.resource#&programcode=#url.programcode#&period=#url.period#&edition=#url.edition#&fund=#url.fund#&object=#url.object#','box#rowguid#')">
											   
									</cf_UItooltip>
									
									</cfif>
									
									</td>
								</tr>
								</table>
								
							</td>
							
							<td class="labelit" style="padding-left:6px;padding-right:6px">
													
								<table width="100%" style="height:25px;">								   
								   <tr><td bgcolor="efefef" align="right" class="labelmedium" style="min-width:50px;padding-left:5px;padding-right:5px;height:22px;border:1px solid silver">							  
								       #numberformat(AmountBasePercentageDue*100,'._')#%</td>
								   </tr>
							   </table>
							
							</td>
							
							<td align="center" style="min-width:50px;border-left:1px solid silver;padding-top:1px;padding-left:3px;padding-right:2px" id="s_#requirementid#">
																																		
								<!--- only available if the requirement has not been allotted at all --->
															
								<cfif (alloted lte "1" or alloted eq "") and RequirementLock eq "0" and  (BudgetOfficer eq "EDIT" or BudgetOfficer eq "ALL")>								
																											
									<cfif ActionStatus eq "1">
					
										<img src="#SESSION.root#/images/light_green2.gif" 
										 style="cursor:pointer" width="25" height="16"
									     onclick="ptoken.navigate('#SESSION.root#/programrem/application/budget/allotment/setAllotmentBlock.cfm?requirementid=#requirementid#&action=0&isParent=#url.isParent#&programcode=#url.programcode#&period=#url.period#&edition=#url.edition#&fund=#url.fund#&object=#url.object#&execution='+document.getElementById('exec_#url.edition#').value,'s_#requirementid#')" 						 
										 alt="Disable/Lock Requirement" 
										 style="border:0px solid silver">
										
									<cfelse>
									
										<img src="#SESSION.root#/images/light_red3.gif" 
										style="cursor:pointer" width="25" height="16"
									    onclick="ptoken.navigate('#SESSION.root#/programrem/application/budget/allotment/setAllotmentBlock.cfm?requirementid=#requirementid#&action=1&isParent=#url.isParent#&programcode=#url.programcode#&period=#url.period#&edition=#url.edition#&fund=#url.fund#&object=#url.object#&execution='+document.getElementById('exec_#url.edition#').value,'s_#requirementid#')"						
										alt="Unlock Requirement" 
										style="border:0px solid silver">
									
									</cfif>	
									
								<cfelse>
								
								</cfif>
																
							</td>	
							
							<td align="center" style="min-width:40px;padding-left:2px;border-left:1px solid silver;padding-right:3px">
														
							    <!--- no movement if requirement is partially allotted already --->
																
								<cfif alloted eq "0" and RequirementLock eq "0" and (BudgetOfficer eq "EDIT" or BudgetOfficer eq "ALL")>
																
									    <cf_UItooltip tooltip="Select to move a requirement">
										
										<input type="checkbox" 
										     name="moveline#url.edition#" 
											 value="#requirementid#" 
											 class="enterastab"
											 class="radiol"
											 onclick="movedetail('#url.edition#')">
											 
										</cf_UItooltip>
																	
								</cfif>
								
							</td>	
							
							</tr>
					
						</table>
										
					</td>
					
				</cfif>
				
				</tr>
								
				<!---				
				<cfif alloted gte "1">					
				--->
								
				<cfif actionstatus neq "0">								
				
					<tr class="navigation_row_child">
						<td colspan="2"></td>						
						<td colspan="8" id="#requirementid#_detail">							
							<cfinclude template="getRequirementAllocation.cfm">										
						</td>
					</tr>
						
				</cfif>					
				
				<!---					
				</cfif>
				--->
										
		</cfoutput>
		
		<!--- totals --->
					
		<cfquery name="total" dbtype="query">
			SELECT SUM(RequestAmountBase) as RequestTotal, 
			       SUM(AmountBaseAllotment) as AllotmentTotal,
				   SUM(AmountBaseAllotment*AmountBasePercentageDue) as AllotmentDueTotal
			FROM   Requested
			WHERE  ActionStatus = '1' <!--- valid transaction --->
		</cfquery>
		
 		<cfoutput> 		
		<tr class="line labelmedium">
		 <td colspan="6"></td>		
		 <td align="right" style="font-size:16px;background-color:ffffff;padding-right:10px">#numberformat(total.RequestTotal,",__")#</td>
		 <cfif url.mode eq "list">
		 <td align="right" style="font-size:16px;background-color:ffffcf;padding-right:10px">#numberformat(total.AllotmentTotal,",__")#</td>
		 <td align="right" style="font-size:16px;background-color:yellow;border-left:1px solid silver;border-right:1px solid silver;border-bottom:1px solid silver;padding-right:10px">#numberformat(total.AllotmentDueTotal,"__,__")#</td>
		 </cfif>
		 <td colspan="5"></td>
		</tr>
		</cfoutput>
		
		</cfif>
			
		<!--- show pipeline --->
		
	  </cfif>
	  
	</table>  
	  
 </td>
 </tr>  
	  	  
 <tr><td id="<cfoutput>box#rowguid#</cfoutput>">	
      <cfset init = "1">  	  
	  <cfinclude template="AllotmentInquiryDetailCleared.cfm">	
      </td>
  </tr>
				
</table>

<cfset ajaxOnLoad("doHighlight")>