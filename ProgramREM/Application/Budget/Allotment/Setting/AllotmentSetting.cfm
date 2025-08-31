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
<cf_screentop height="100%" html="no" label="Allotment Settings" line="no" user="no" scroll="no" layout="webapp" banner="blue" jquery="yes">


<cfoutput>

<script>
 function maintainRelease(edition,per,mode,prg) {	    	   
	 	ptoken.open("#session.root#/ProgramREM/Application/Budget/Requirement/FundObject/FundObject.cfm?entrymode="+mode+"&systemfunctionid=#url.systemfunctionid#&editionId="+edition+"&period="+per+"&programcode="+prg, "", "left=80, top=80, width=800, height=850, toolbar=no, status=yes, scrollbars=no, resizable=yes");
	 }	 
</script>

</cfoutput>


<cf_listingscript>

<cfquery name="getProgram" 
datasource="AppsProgram" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT    *
	FROM      Program
	WHERE     ProgramCode = '#url.ProgramCode#' 	
</cfquery>

<cfquery name="Parameter" 
datasource="AppsProgram" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT    *
	FROM      Ref_ParameterMission
	WHERE     Mission = '#getProgram.mission#' 	
</cfquery>

<cfquery name="check" 
datasource="AppsProgram" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT    *
	FROM      ProgramAllotment PA
	WHERE     PA.ProgramCode = '#url.programcode#' 
	AND       PA.Period      = '#url.period#' 
	AND       PA.EditionId   = '#url.editionid#'
</cfquery>

<cfquery name="fundlist" 
datasource="AppsProgram" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT    Fund
	FROM      Ref_AllotmentEditionFund
	WHERE     EditionId   = '#url.editionid#'
</cfquery>

<cfif check.recordcount eq "0">
	
	<cfquery name="insert" 
	datasource="AppsProgram" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		INSERT INTO ProgramAllotment
		(ProgramCode,Period,EditionId,SupportPercentage,
					SupportObjectCode,OfficerUserId,OfficerLastName,OfficerFirstName)
		VALUES
		('#url.programcode#',
		 '#url.period#',
		 '#url.editionid#',
		 '#parameter.SupportPercentage#',
		 <cfif parameter.SupportObjectCode neq "">		 
		 '#parameter.SupportObjectCode#',
		 <cfelse>
		 NULL,
		 </cfif>
		 '#SESSION.acc#',
		 '#SESSION.last#',
		 '#SESSION.first#')
	</cfquery>

</cfif>

<cfquery name="get" 
datasource="AppsProgram" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT    P.*, Pe.Reference, PA.*, R.Description as EditionName, BudgetEntryMode
	FROM      Program P INNER JOIN
	          ProgramPeriod Pe ON P.ProgramCode = Pe.ProgramCode INNER JOIN
	          ProgramAllotment PA ON Pe.ProgramCode = PA.ProgramCode AND Pe.Period = PA.Period INNER JOIN
	          Ref_AllotmentEdition R ON PA.EditionId = R.EditionId
	WHERE     P.ProgramCode = '#url.programcode#' 
	AND       Pe.Period     = '#url.period#' 
	AND       PA.EditionId  = '#url.editionid#'
</cfquery>

<cfinvoke component="Service.Access"  <!--- get access levels based on top Program--->
			Method         = "budget"
			ProgramCode    = "#URL.ProgramCode#"
			Period         = "#URL.Period#"	
			EditionId      = "'#URL.editionID#'"  
			Role           = "'BudgetManager'"
			ReturnVariable = "BudgetAccess">	
			
<cfif BudgetAccess eq "ALL">
	<cfset mode = "Edit">
<cfelse>
	<cfset mode = "View">
</cfif>		

<cf_divscroll style="height:100%">

<table width="95%" height="100%" align="center" border="0">

	<cfoutput query="get">
	
		<tr><td height="4"></td></tr>
	
		<tr><td colspan="4"><table width="99%">
		
		<tr height="23"><td style="width:150px" class="labelmedium">
		    <cfif get.ProgramClass eq "Project"> <cf_tl id="Project"> <cfelse> <cf_tl id="Program"> </cfif>:
			</td>
			<td colspan="3" class="labelmedium">#get.ProgramName# <cfif get.Reference neq ""><b>(#get.Reference#)<cfelse><b>#get.ProgramCode#</cfif></td>		
		</tr>
		
		<!--- edit limited for budget officer = all, otherwise view mode --->
		
		<tr height="23">	   
			<td class="labelmedium"><cf_tl id="Edition">:</td>
			<td class="labelmedium">#get.EditionName#</td>
			<td class="labelmedium"><cf_tl id="Plan period">:</td>
			<td class="labelmedium">#url.period#</td>
		</tr>
		
		</table></td></tr>
			
		<tr><td height="1" colspan="4" class="line"></td></tr>
		
		<tr><td colspan="2" style="height:10px" valign="top">
				
			    <form name="allotmentform">			
					<cfinclude template="AllotmentSettingForm.cfm">								
				</form>
					
				</td>
			
			    <td colspan="2" width="40%" valign="top" style="padding-top:5px">
			
				<table width="100%" border="0" class="formpadding formspacing" bordercolor="silver">
								    
					<tr class="line"><td colspan="2" class="labelmedium" style="padding-left:5px;height:25"><font color="gray"><cf_tl id="Budget and Execution Metrics"></td>					
					 </tr>
			
												
					<cfif get.BudgetEntryMode eq "1">
					
					<tr class="line">
					  <td width="50%" style="padding-left:4px" class="labelit">Last requirement recorded:</td>
					  <td class="labelit" align="right" style="padding-right:4px">
					  
					  <cfquery name="getRequirement" 
							datasource="AppsProgram" 
							username="#SESSION.login#" 
							password="#SESSION.dbpw#">
					  	    SELECT   MAX(TransactionDate) as TransactionDate
							FROM     ProgramAllotmentDetail
							WHERE    ProgramCode = '#url.programcode#'
							AND      Period      = '#url.period#'
							AND      EditionId   = '#url.editionid#'
							AND      Status      IN ('0','P')
							
						</cfquery>	
						
						#dateformat(getRequirement.TransactionDate,client.dateformatshow)#
					  
					  
					  </td>
				    </tr>	
					
					</cfif>
					
					<tr class="line">
					  <td style="padding-left:4px" class="labelit"><cf_tl id="Budget requested">:</td>
					  <td class="labelit" align="right" style="padding-right:4px">
					  
					   <cfquery name="getAllotment" 
							datasource="AppsProgram" 
							username="#SESSION.login#" 
							password="#SESSION.dbpw#">
					  	    SELECT   SUM(Amount) as Amount
							FROM     ProgramAllotmentDetail
							WHERE    ProgramCode = '#url.programcode#'
							AND      Period      = '#url.period#'
							AND      EditionId   = '#url.editionid#'
							AND      Status IN ('P','0','1')						
						</cfquery>	
						
						#Parameter.BudgetCurrency# #numberformat(getAllotment.Amount,"__,__")#
					  				  
					  </td>
				    </tr>		
				
					<tr class="line">
					  <td style="padding-left:4px" class="labelit">Last allotment issued:</td>
					  <td class="labelit" style="padding-right:4px" align="right">
					  
					   <cfquery name="getAllotment" 
							datasource="AppsProgram" 
							username="#SESSION.login#" 
							password="#SESSION.dbpw#">
					  	    SELECT   MAX(TransactionDate) as TransactionDate
							FROM     ProgramAllotmentDetail
							WHERE    ProgramCode = '#url.programcode#'
							AND      Period      = '#url.period#'
							AND      EditionId   = '#url.editionid#'
							AND      Status      = '1'
						</cfquery>	
						<cfif getAllotment.TransactionDate neq "">
						<font color="FF0000">never</font>
						<cfelse>
						#dateformat(getAllotment.TransactionDate,client.dateformatshow)#
						</cfif>
					  				  
					  </td>
				    </tr>	
					
					<tr class="line">
					  <td style="padding-left:4px" class="labelit">Last obligation raised:</td>
					  <td class="labelit" style="padding-right:4px" align="right">
					  
					   <cfquery name="getObligation" 
							datasource="AppsPurchase" 
							username="#SESSION.login#" 
							password="#SESSION.dbpw#">
							SELECT   MAX(P.OrderDate) AS OrderDate
							FROM     RequisitionLineFunding RLF INNER JOIN
					                 PurchaseLine PL ON RLF.RequisitionNo = PL.RequisitionNo INNER JOIN
	                      			 Purchase P ON PL.PurchaseNo = P.PurchaseNo
							WHERE   (RLF.ProgramCode = '#url.programcode#') 
							AND     (RLF.ProgramPeriod = '#url.period#')
						</cfquery>
						
						#dateformat(getObligation.OrderDate,client.dateformatshow)#
					  
					  </td>
				    </tr>			
					
					<tr class="line">
					  <td style="padding-left:4px" class="labelit">Last disbursement posted:</td>
					  <td class="labelit" style="padding-right:4px" align="right">
					  
					  <cfquery name="getInvoice" 
							datasource="AppsLedger" 
							username="#SESSION.login#" 
							password="#SESSION.dbpw#">
							SELECT    TOP 1 *
							FROM      TransactionLine
							WHERE     ProgramCode   = '#url.ProgramCode#' 	
							AND       ProgramPeriod = '#url.period#'
							ORDER BY  TransactionDate DESC
						</cfquery>
						<cfif getInvoice.TransactionDate eq "">
						never
						<cfelse>
						#dateformat(getInvoice.TransactionDate,client.dateformatshow)#
						</cfif>	  
					  
					  </td>
				    </tr>		
					
					<cfif Parameter.EnableDonor eq "1">	
					
					<tr class="line"> 			
					<td style="padding-left:4px" class="labelit"><cf_tl id="Contribution Mapped">:</td>
																	
						<cfquery name="getEdition" 
							datasource="AppsProgram" 
							username="#SESSION.login#" 
							password="#SESSION.dbpw#">
							SELECT    *
							FROM      Ref_AllotmentEdition
							WHERE     EditionId = '#url.EditionId#' 	
						</cfquery>
						
						<!--- Dev : attention this amounts are in the Finance base currency we can be different
						from the budget currency, if that happens we need to convert transactions
						back the to bufget currency unless the transaction itself was posted in the currency
						AmountDebit - AmountCredit --->
															
						<cfquery name="getMapping" 
						datasource="AppsLedger" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">
							SELECT SUM(AmountBaseDebit-AmountBaseCredit) as Total
							FROM   TransactionLine	
							WHERE     ProgramCode   = '#url.programcode#' 
							AND       ProgramPeriod = '#getEdition.Period#'
							<!--- all transactions for that mission excluding the generated ones for support cost, they will be corrected --->
							AND       Journal IN
							               (SELECT   Journal
							                FROM     Journal
							                WHERE    Mission       = '#getEdition.Mission#' 
											AND      SystemJournal != 'SupportCost') 
							AND       ContributionLineId IS NOT NULL
						</cfquery>
											
					<td id="reset" class="labelit" align="right" style="padding-right:0px">
					
						<table cellspacing="0" cellpadding="0">
						<tr>
						
						<cfif getMapping.total neq "0" and mode eq "edit">
						<td class="labelit" style="padding-left:10px;padding-right:4px" align="right">
								<a href="javascript:if (confirm('Do you want to revert all contribution mapped transactions to this project ?')) {ColdFusion.navigate('resetContributions.cfm?programcode=#url.programcode#&period=#url.period#&editionid=#url.editionid#','reset')}" 
									title="Revert all associated contributions for this program allotment, except the calculated support costs.">
									<font color="0080C0"><cf_tl id="Reset"></font>
								</a>
							</td>
						</cfif>	
							
						<td align="right" style="padding-right:4px" class="labelit">#numberformat(getMapping.total,"__,__.__")#</td>
						
						</tr>
						</table>
						
					</td>	
					
				    </tr>	
					
					</cfif>
				
				</table>
			
			    </td>
			
		</tr>
			
		<cfif mode eq "edit" and (get.BudgetEntryMode eq "1" or getProgram.EnforceAllotmentRequest eq "1")>	
			
			
			<tr><td colspan="4" height="30" style="padding-left:10px">			
			<table>
				<tr>
				<td>
					<cf_tl id="Save Settings" var="vSave">
					<input type="button" name="Update" value="#vSave#" style="width:160px;height:25px" class="button10g" 
					onclick="ptoken.navigate('AllotmentSettingSubmit.cfm?programcode=#url.programcode#&period=#url.period#&editionid=#url.editionid#','process','','','POST','allotmentform')">
				</td>
				<td id="process" class="labelmedium" style="padding-left:10px"></td>
				</tr>
			</table>
			</td>
			</tr>
			<tr><td colspan="4" class="line"></td></tr>
		</cfif>
		
		<!---	
		<tr><td colspan="3" style="padding-left:10px;height:30" class="labelmedium"><b><cf_tl id="Allotment Action Log"></td></tr>
		
		<tr><td colspan="4" class="line"></td></tr>
		--->
		
		<tr><td style="height:100%" colspan="4">
			
			<table width="100%" height="100%">
				<tr><td style="height:100%;padding:10px">
				<cfinclude template="AllotmentSettingListing.cfm">
				</td></tr>
			</table>
		
		</td>
		</tr>
	
	</cfoutput>

</table>

</cf_divscroll>
	
<cf_screenbottom layout="webapp">

