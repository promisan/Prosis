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

<!--- listing associations --->

<cfparam name="url.contributionlineid" default="">

<cfquery name="get"
    datasource="AppsProgram" 
	username="#SESSION.login#"
	password="#SESSION.dbpw#">
	SELECT   *
    FROM     Contribution
    WHERE    ContributionId = '#url.contributionid#'
</cfquery>	


<cfquery name="param"
    datasource="AppsProgram" 
	username="#SESSION.login#"
	password="#SESSION.dbpw#">
	SELECT   *
    FROM     Ref_ParameterMission
    WHERE    Mission = '#get.Mission#'
</cfquery>	

<!--- parent object codes --->

<cftransaction isolation="READ_UNCOMMITTED">
	
	<cfquery name="getlines"
	    datasource="AppsProgram" 
		username="#SESSION.login#"
		password="#SESSION.dbpw#">
		SELECT   *,
		  	
		   		  ( SELECT O.ObjectId 
					     FROM   Organization.dbo.OrganizationObject O
						 WHERE  O.EntityCode = 'EntTrench'
						 AND    O.Operational = 1				
						 AND    O.ObjectKeyValue4 = L.ContributionLineId
					   ) as WorkflowId
					   	 
	    FROM     ContributionLine L
	    WHERE    ContributionId = '#url.contributionid#'
		ORDER BY DateEffective
	</cfquery>	

</cftransaction>

<cfset lines = quotedValueList(getLines.ContributionLineId)>

<form method="post" name="allocationform" id="allocationform">

<table width="95%" cellspacing="0" cellpadding="0" align="center" class="navigation_table">
	
	<tr class="line"><td class="labellarge" colspan="11" style="height:38">
		<table width="100%">
			<tr>
			<td style="font-size:23px" class="labellarge"><cfoutput>#get.Reference#</cfoutput></td>
			<td style="font-size:23px" class="labelmedium" align="right"><cf_tl id="Contribution Allocation"></td>
			</tr>
		</table>
	</td>
	</tr>
	
	<tr class="line">
			
		<td class="labelit" style="padding-left:10px"><cf_tl id="Effective"></td>
		<td></td>	
		<td class="labelit"><cf_tl id="Expiration"></td>
		<td class="labelit"><cf_tl id="Fund"></td>	
		<td class="labelit" style="height:20;"><cf_tl id="Reference"></td>			
		<td align="right" colspan="1"></td>			
		<td align="right" class="labelit" style="padding-right:10px"><cf_tl id="Tranche Amount"></td>
		<td align="right" colspan="2"></td>		
		<td align="right" style="padding-right:5px" class="labelit"><cf_tl id="Allocated"><cfoutput>#Param.BudgetCurrency#</cfoutput></td>
		<td align="right" style="padding-right:5px" class="labelit"><cf_tl id="Commitment"><cfoutput>#Application.BaseCurrency#</cfoutput></td>
	</tr>			
	
	<tr bgcolor="f5f5f5" class="xhide labelit line">
	    <td></td>
		<td colspan="2" style="height:18;padding-left:20px"><cf_tl id="Project"></td>						
		<td><cf_tl id="Period"></td>		
		<td><cf_tl id="Fund"></td>				
		<td style="width:140px"><cf_tl id="Document"></td>
		<td colspan="2"><cf_tl id="Date"></td>						
		<td width="10%" align="right"><cf_tl id="Allotment"></td>													
		<td width="10%" colspan="1" align="right" style="padding-right:10px"><cf_tl id="This Tranche"></td>
		<td></td>
	</tr>
	
	<cfoutput query="getLines">			
		
		<cftransaction isolation="READ_UNCOMMITTED">
		
		<!--- retrieve all allotment transaction for this contribution and project --->
	
		<cfquery name="getAllocations"
		    datasource="AppsProgram" 
			username="#SESSION.login#"
			password="#SESSION.dbpw#">
			
			   SELECT     D.TransactionId, 
			              D.ProgramCode, 
						  P.ProgramName, 
						  D.Period, 
						  D.ActionId,
						  D.Status,
						  (SELECT Reference 
						   FROM   ProgramAllotmentAction 
						   WHERE  ActionId = D.ActionId) as ActionReference,
						  Pe.Reference, 
						  D.EditionId, 
						  D.TransactionDate, 
						  D.Fund, 
						  
						  <!--- no sure on the purpose here as effectively we do not change the allotment detail line but 
						  only the contribution allocation to that line --->
						  
						  D.TransactionIdSource,
						  
						  (SELECT count(*) 
						   FROM   ProgramAllotmentDetail 
						   WHERE  TransactionIdSource = D.TransactionId) as Processed,					  
						  
						  <!--- end of doubt ---> 
						   
						  R.Code, 
						  R.Description, 
						  R.HierarchyCode,
						  PAD.SupportObjectCode,
						  PAD.SupportPercentage,
						  D.Amount as AmountBase,
						  							  
			                 (
							  SELECT  SUM(Amount) AS Contribution
			                  FROM    ProgramAllotmentDetailContribution AS C
			                  WHERE   TransactionId      = D.TransactionId
							  AND     ContributionLineid = '#ContributionLineId#' 						  
							  AND     ContributionLineId IN (#preservesinglequotes(lines)#)						  
							  ) AS ThisContribution
								   
			     FROM     ProgramAllotmentDetail AS D INNER JOIN
			              Program AS P ON D.ProgramCode = P.ProgramCode INNER JOIN
						  stObject O ON O.Code = D.ObjectCode INNER JOIN
			              Ref_Object AS R ON O.ParentCode = R.Code INNER JOIN
			              ProgramPeriod AS Pe ON D.ProgramCode = Pe.ProgramCode AND D.Period = Pe.Period INNER JOIN		
						  ProgramAllotment AS PAD ON D.ProgramCode = PAD.ProgramCode AND D.Period = PAD.Period AND D.EditionId = PAD.EditionId 
		 
			     WHERE    P.Mission = '#get.Mission#'					 
				
				 AND      EXISTS  (
				                   SELECT   'X'
			                       FROM     ProgramAllotmentDetailContribution AS SPAD
								   WHERE    TransactionId      = D.TransactionId								
			                       AND      ContributionLineId = '#ContributionLineId#'                      								
								  )																	
				     				
				 AND      D.Status in ('0','P', '1')  <!--- before this was is =! 9 but we only take cleared allocations --->
				 ORDER BY Pe.Reference, P.ProgramCode, D.Period, R.HierarchyCode, R.Description, D.TransactionDate			 
	
		</cfquery>	
									
		<cfquery name="getUsed" 
			datasource="AppsProgram" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">			
					
					SELECT    ProgramCode,ProgramPeriod,R.Code,R.Description,
					          ISNULL(SUM(AmountBaseDebit - AmountBaseCredit), 0) as Commitment
		            FROM      Accounting.dbo.TransactionLine TL 
					          INNER JOIN stObject O ON O.Code = TL.ObjectCode 
							  INNER JOIN Ref_Object AS R ON O.ParentCode = R.Code
					WHERE     Journal IN (SELECT Journal 
			                              FROM   Accounting.dbo.Journal 
								          WHERE  Mission = '#get.Mission#')											
					AND       TL.ContributionLineId = '#getLines.ContributionLineId#'	
					GROUP BY  ProgramCode, ProgramPeriod,R.Code,R.Description							
					
		</cfquery>
		
		</cftransaction>
					
		<tr class="line navigation_row">
								
			<td class="labellarge" style="padding-left:10px">#dateformat(DateEffective,CLIENT.DateFormatShow)#</td>
			<td style="width:20;padding-left:5px" id="box#ContributionLineId#">			
				<!--- contentbox for issuing of a correction --->				
			</td>	
			<td class="labellarge" style="padding-left:3px"><cfif DateExpiration eq "">unlimited<cfelse>#dateformat(DateExpiration,CLIENT.DateFormatShow)#</cfif></td>
			<td width="80"  class="labellarge">#Fund#</td>		
			<td class="labellarge">#Reference#</td>				
			<td></td>		
			
			<td align="right" class="labellarge" style="padding-right:0px">#numberformat(amount,",.__")#</td>
											
			<td colspan="2" align="center">
	
				<cfif workflowid eq "" and getAllocations.recordcount gte "0">
				
					<cfquery name="qCheckWorkflow" 
					   datasource="AppsProgram" 
					   username="#SESSION.login#"
					   password="#SESSION.dbpw#">
						SELECT *
						FROM   ContributionLine
						WHERE  ContributionLineId   = '#contributionlineid#'
						AND    HistoricContribution = '1'
					</cfquery>							
					
					<cfif qCheckWorkflow.recordcount eq 0>
						<table>
							<tr>
								<td id="workflow_#contributionlineid#" class="labelit">
								<a href="javascript:contributionlineaction('#contributionlineid#')"><font color="0080C0"><cf_tl id="Initiate review"></font></a>			
								</td>
							</tr>
						</table>
					<cfelse>
						<table>
							<tr>
								<td class="labelit">
									<cf_tl id="Historical Contribution">		
								</td>
							</tr>
						</table>							
					</cfif>
				
				</cfif>
			
			</td>
			
			<td align="right" class="labellarge" style="padding-right:5px">
			
				<cfquery name="getTotal"        
				     dbtype="query">
					 SELECT SUM(ThisContribution) as Total
					 FROM   getAllocations
				</cfquery>				
				
				<cfif getTotal.total gte amountbase>
				<font color="008000"><b><img src="#SESSION.root#/images/check.gif" alt="" border="0">
				</cfif>
				<b>#numberformat(getTotal.Total,'__,__.__')#</b>
				</font>
			
			</td>
			
			<cfquery name="getExpenditure" dbtype="query">			
					SELECT  SUM(Commitment) as Commitment
					FROM    getUsed			            									
			</cfquery>
			
			<td align="right" style="padding-right:5px" class="labelmedium">#numberformat(getExpenditure.Commitment,'__,__.__')#</td>	
							
		</tr>				
				
		<cfoutput>
		
		<input type="hidden" 
		   name="workflowlink_#contributionlineid#" 
		   id="workflowlink_#contributionlineid#"
		   value="../Allocation/RequirementListingWorkflow.cfm">			   
						   
		</cfoutput>   
							
		<tr><td colspan="11" id="#contributionlineid#" style="padding-left:2px;padding-right:2px">
			
			<cfif workflowid neq "">
			
				<cfset url.ajaxid = contributionlineid>	
				<cfinclude template="RequirementListingWorkflow.cfm">		
			
			</cfif>
		
		</td></tr>
							
		<cfif getAllocations.recordcount eq "0">
		
			<tr bgcolor="f1f1f1">
			<td colspan="11" align="center" class="labelit">This contribution has not been allocated.</td>
			</tr>
		
		<cfelse>
		
			<!--- Hanno : later we might allow an expand collapse if the number 
			of records would be too big for each trench --->
											
			<cfset prior = "">
			<cfset pperi = "">
			<cfset pcode = "">
		
			<cfloop query="getAllocations">
							
				<!--- PROGRAM --->
			
				<cfif ProgramCode neq prior>
				
					<cfset prior = ProgramCode>
					<cfset pperi = "">
					
					<cfquery name="getTotal" dbtype="query">
					 	SELECT  SUM(ThisContribution) as Total
						FROM    getAllocations
						WHERE   ProgramCode = '#ProgramCode#'
				     </cfquery>
					 
					 <cfquery name="getTotalUsed" dbtype="query">					
						SELECT  SUM(Commitment) as Commitment
						FROM    getUsed		
						WHERE   ProgramCode = '#ProgramCode#' 		            									
					</cfquery>
										
					<cfquery name="getPending" dbtype="query">
					 	SELECT  *
						FROM    getAllocations
						WHERE   Status = '0'
						AND     ProgramCode = '#ProgramCode#'
				     </cfquery>					
														
					<tr bgcolor="EaEaEa" class="line details#getLines.contributionlineid# xhide navigation_row">
						<td colspan="9" style="padding-left:15px">
						
												
						<table width="100%" height="100%" cellspacing="0" cellpadding="0">
						<tr>						   
						    <td class="labelmedium" bgcolor="<cfif getPending.recordcount neq 0>f1f1f1<cfelse>transparent</cfif>">	
								<table cellspacing="0" cellpadding="0">
									<tr>
									<td style="padding-left:50px;padding-right:4px">
									   <cf_img icon="expand" toggle="yes" onclick="javascript:expand('details#getLines.ContributionLineId#_#programcode#')">
									</td>
									<td style="width:200"        class="labelmedium">#Reference#</td>
									<td style="padding-left:4px" class="labelmedium">#ProgramName#</td>
									</tr>
								</table>
							</td>							
							<td></td>
						</tr>
						</table>
						
						</td>	
						<td align="right" style="padding-right:5px" class="labelmedium">#numberformat(getTotal.Total,'__,__.__')#</td>			
						<td align="right" style="padding-right:5px" class="labelmedium">#numberformat(getTotalUsed.Commitment,'__,__.__')#</td>										
					</tr>
											
				</cfif>				
				
				<cfif url.contributionlineid eq getLines.ContributionLineId>				
					<cfset cl    = "regular">
					<cfset state = "open">
				<cfelse>
				    <cfset cl    = "hide">
					<cfset state = "">
				</cfif>
				
				<!--- PERIOD --->
											
				<cfif period neq pperi>
												
				    <cfset pperi = Period>
					
					<cfquery name="getTotal" dbtype="query">
					 	SELECT  SUM(ThisContribution) as Total
						FROM    getAllocations
						WHERE   ProgramCode = '#ProgramCode#'
						AND     Period      = '#Period#'
				     </cfquery>				 
					 
					 <cfquery name="getTotalUsed" dbtype="query">		
					   	SELECT  SUM(Commitment) as Commitment
						FROM    getUsed
						WHERE   ProgramCode   = '#ProgramCode#'
						AND     ProgramPeriod = '#Period#'						
					</cfquery>	
					 					
					<tr class="details#getLines.contributionlineid#_#programcode# #cl#">
						<td colspan="9" style="padding-left:55px">
						
						<table width="100%" height="100%">
						<tr>						   
						    <td class="labelmedium">	
							<table cellspacing="0" cellpadding="0">
							<tr>
							<td style="padding-left:10px;padding-top:2px;padding-right:4px">
							     <cf_img icon="expand" state="#state#" toggle="yes" onclick="javascript:expand('details#getLines.ContributionLineId#_#programcode#_#period#')"></td>
							<td style="width:80;padding-left:10px" class="labelmedium">				
								<a href="javascript:Allotment('#programcode#','','#period#','budget','')">
									<font color="0080C0">#Period#</font>
								</a>
							</td>
							<td style="padding-left:4px" class="labelmedium"></td>
							</tr>
							</table>
							</td>							
							<td></td>
						</tr>
						</table>
						</td>	
						<td align="right" style="padding-right:5px" class="labelmedium" bgcolor="f1f1f1">#numberformat(getTotal.Total,'__,__.__')#</td>			
						<td align="right" style="padding-right:5px" class="labelmedium" bgcolor="f1f1f1"><cfif getTotalUsed.Commitment gt getTotal.Total><font color="red"></cfif>#numberformat(getTotalUsed.Commitment,'__,__.__')#</font></td>										
					</tr>
					
					<cfif getTotalUsed.Commitment gt getTotal.Total and getTotal.Total gt "0">
		
						<tr class="details#getLines.contributionlineid#_#programcode# #cl#">
						
						<td colspan="11" style="padding-left:88px;height:25">
							<table>
							<tr><td valign="top">
							<img src="#session.root#/images/join.gif" alt="" border="0">
							</td>
							<td class="labelit" style="padding-left:4px">
							<font color="FF0000">
							It is recommended you reset the mapping for this project, in order for the commitments to be mapped again based on the revised allotments.
							</font>
							</td>
							</tr>
							</table>
						</td>
						</tr>
		
					</cfif>
					
					<!--- check if we have any commitments for the project/period that are not part of the allotment --->
					
					<cfquery name="getCommitment" dbtype="query">
					 	SELECT  Code
						FROM    getAllocations
						WHERE   ProgramCode = '#ProgramCode#'
						AND     Period      = '#Period#'
				     </cfquery>		
					
					 <cfquery name="otherCommitments" dbtype="query">		
					   	SELECT  *
						FROM    getUsed
						WHERE   ProgramCode   = '#ProgramCode#'
						AND     ProgramPeriod = '#Period#'						
						AND     Code NOT IN (#quotedValueList(getCommitment.Code)#)
					</cfquery>	
					
					<cfif otherCommitments.recordcount gte "1">
					
					<cfloop query="otherCommitments">
					
					<tr class="labelit details#getLines.contributionlineid#_#programcode# #cl#">
					<td style="padding-left:80px;padding-top:2px;padding-right:2px"></td>								
					    <td colspan="8">
						
						<table width="100%" cellspacing="0" cellpadding="0">
							<tr class="labelit">															
							<td bgcolor="FAC5BE" style="padding-left:6px">#Code# #Description#</td></tr>
						</table>
						
						</td>					

						<td align="right" style="padding-right:8px" bgcolor="FAC5BE"></td>									
						<td align="right" style="padding-right:5px" bgcolor="FAC5BE"><font color="red">#numberformat(Commitment,'__,__.__')#</font></td>										
												
					</tr>
					
					</cfloop>
					
					</cfif>					
									
				</cfif>
				
				<!--- OE --->						
								
				<cfif code neq pcode>				
					
					<cfquery name="getTotal" dbtype="query">
					 	SELECT  SUM(ThisContribution) as Total
						FROM    getAllocations
						WHERE   ProgramCode = '#ProgramCode#'
						AND     Period      = '#Period#'
						AND     Code        = '#Code#'
				    </cfquery>
					 
					<cfquery name="getTotalUsed" dbtype="query">		
					   	SELECT  SUM(Commitment) as Commitment
						FROM    getUsed
						WHERE   ProgramCode    = '#ProgramCode#'
						AND     ProgramPeriod  = '#Period#'
						AND     Code           = '#Code#'
					</cfquery>	
									
					<cfquery name="getPendingLine" dbtype="query">
					 	SELECT  *
						FROM    getAllocations
						WHERE   ProgramCode = '#ProgramCode#'
						AND     Period      = '#Period#'
						AND     Code        = '#Code#'
						AND     Status      = '0'
				     </cfquery>							
				
					<tr class="labelit line details#getLines.contributionlineid#_#programcode#_#period# #cl#">
									
						<td style="padding-left:80px;padding-top:2px;padding-right:2px">
						   <cf_img icon="expand" toggle="yes" onclick="javascript:expand('details#getLines.ContributionLineId#_#programcode#_#period#_#code#')">
						</td>								
					    <td bgcolor="<cfif getPendingLine.recordcount neq 0>F6CECE<cfelse>D0FBD6</cfif>" colspan="8">
						
						<table width="100%" cellspacing="0" cellpadding="0">
							<tr class="labelit">															
							<td style="padding-left:6px">#Code# #Description#</td>	
							<cfif Code neq SupportObjectCode and getTotal.total gt "0">
							<td align="right" height="18" style="padding-left:10px;padding-right:2px" align="right">								 
									
									<img src="#client.root#/images/transfer2.gif" 									  
									  border="0" style="cursor:pointer" alt="Transfer"
									  onclick="budgettransfercontribution('#getLines.contributionlineid#','#transactionid#','#URL.systemfunctionid#','#URL.contributionid#')">								   
									  
							</td>	
							</cfif>		
							</tr>
						</table>
						
						</td>					

						<td align="right" style="padding-right:8px" bgcolor="f1f1f1">#numberformat(getTotal.Total,'__,__.__')#</td>									
						<td align="right" style="padding-right:5px" bgcolor="f1f1f1"><cfif getTotalUsed.Commitment gt getTotal.Total><font color="red"></cfif>#numberformat(getTotalUsed.Commitment,'__,__.__')#</font></td>										
				
					</tr>		
														
					<cfset pcode = Code>	
																		
				</cfif>					
				
				<!--- ----------------------------------------- --->													
				<!--- detailed transactions for the object code --->				
					
				<tr class="details#getLines.contributionlineid#_#programcode#_#period#_#code# hide">
				    <td></td>
					<td colspan="10"></td></tr>
															
					<tr class="details#getLines.contributionlineid#_#programcode#_#period#_#code# hide">
						
						<td style="padding-right:10px" colspan="3" align="right">
						
						       <table cellspacing="0" cellpadding="0">
							   
								   <tr>						   							
									<td style="padding-left:8px;padding-top:1px;padding-right:0px">
																		
									
									   <!--- I am not sure why we have this condition 
									        which seems to come from the carry over	and that is not intended										
									  								   
									   <cfif TransactionIdSource eq "" and Processed eq "0">
									   
									    --->
																														
									   <cfif Processed eq "0">  <!--- if processed is not 0 it is already part of the prior amendment to be included --->
									   			
										     <!--- reallocation --->					
										   <cfif (Code neq SupportObjectCode or supportpercentage eq "0") and status eq "1">
										   
											   <!--- NEW added to select lines --->
											   										   
											   <input type = "checkbox" 
											       name    = "Transaction_#left(getLines.contributionlineid,8)#" 
												   id      = "Transaction_#left(getLines.contributionlineid,8)#"
												   value   = "#TransactionId#" 
												   onclick = "ColdFusion.navigate('../Allocation/setReallocation.cfm?contributionid=#contributionid#&systemfunctionid=#url.systemfunctionid#&contributionlineid=#getLines.contributionlineid#','box#getLines.ContributionLineId#','','','POST','allocationform')">											  
										 											
											</cfif>											
										
									   </cfif>
									   										
								    </td>
								   </tr>
							   
							   </table>
							   
						</td>
						<td class="labelit">#Period#</td>	
						<td class="labelit">#Fund#</td>					
						<td class="labelit"><cfif status eq "0"><font color="808080">in process</font><cfelse><a href="javascript:budgetaction('#actionid#')"><font color="0080C0">#ActionReference#</a></cfif></td>							
						<td class="labelit" colspan="2" style="padding-left:5px"><cfif status eq "1">#dateformat(TransactionDate,client.dateformatshow)#</cfif></td>		
						<td class="labelit" align="right"><font color="gray"><b</b>#numberformat(AmountBase,'__,__.__')#</td>									
						<td align="right" class="labelit" style="padding-right:20px" bgcolor="f1f1f1"><font color="black">#numberformat(ThisContribution,'__,__.__')#</td>
						<td></td>
						
				</tr>
				
										
			
			</cfloop>	
								
		</cfif>		
		
		<tr><td></td><td colspan="11" style="height:10"></td></tr>
		
	</cfoutput>	
		
</table>

</form>

<cfset AjaxOnLoad("doHighlight")>	
