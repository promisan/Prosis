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
<!--- get planning periods that overlap the contribution --->

<cfoutput>

<cfquery name="qLine" 
	datasource="AppsProgram"  
	username="#SESSION.login#"
	password="#SESSION.dbpw#">
		SELECT * 
		FROM   ContributionLine
		WHERE  ContributionLineId = '#URL.ContributionLineId#'
</cfquery>

<cfquery name="qContribution" 
	datasource="AppsProgram"  
	username="#SESSION.login#"
	password="#SESSION.dbpw#">
	SELECT * 
	FROM   Contribution
	WHERE  ContributionId = '#qLine.ContributionId#'
</cfquery>
			
	<cfquery name="qPeriod" 
		datasource="AppsProgram"  
		username="#SESSION.login#"
		password="#SESSION.dbpw#">
		SELECT    DISTINCT M.Period,P.DateEffective, 
		
			      (SELECT CD.AmountBase 
				   FROM  ContributionLinePeriod CD
				   WHERE CD.Period             = M.Period						  
				   AND   CD.ContributionLineid = '#qLine.contributionLineid#') as PeriodAmount,
				   	
				  <!--- amount alloted for the execution periods --->
				  									  
		          (SELECT IsNull(SUM(PC.Amount),0) 
				   FROM  ProgramAllotmentDetail PD,
				         ProgramAllotmentDetailContribution PC,
						 Ref_AllotmentEdition ED
				   WHERE PD.Transactionid      = PC.TransactionId
				   AND   PD.Editionid          = ED.EditionId
				   AND   ED.Period             = M.Period
				   AND   ED.Mission            = '#qContribution.Mission#' 
				   AND   PD.Status != '9'
				   AND   PC.ContributionLineid = '#qLine.contributionLineid#') as PeriodAlloted,
				   
				   <!--- amount mapped to the execution periods --->
					
				  (SELECT IsNull(SUM(T.AmountBaseDebit-T.AmountBaseCredit),0)
				   FROM  Accounting.dbo.TransactionHeader H,
				         Accounting.dbo.TransactionLine T
				   WHERE H.Mission          = '#qContribution.Mission#' 
				   AND   H.Journal          = T.Journal
				   AND   H.JournalSerialNo  = T.JournalSerialNo
				   AND   T.ProgramPeriod    = M.Period
				   AND   T.ContributionLineid = '#qLine.contributionLineid#') as PeriodExpended
				
				   
		FROM      Organization.dbo.Ref_MissionPeriod AS M INNER JOIN
                        Program.dbo.Ref_Period AS P ON M.Period = P.Period
				  
		<!--- only relevant execution periods for mission and line driven --->
				  
		WHERE     M.Mission = '#qContribution.Mission#' 
		
		<cfif qLine.dateExpiration neq "">
		AND       P.DateEffective <= '#dateformat('#qLine.dateExpiration#',client.dateSQL)#'
		</cfif>
		AND       P.DateExpiration >= '#dateformat('#qLine.dateEffective#',client.dateSQL)#'
		
		ORDER BY P.DateEffective, M.Period
	</cfquery>	
			
	<table width="100%" cellspacing="0" cellpadding="0">
	
	<tr class="line labelmedium">
	   <td width="80"><cf_tl id="Execution"></td>
	   <td width="20%" align="right"><cf_tl id="Opening Balance"></td>
       <td width="20%" align="right"><cf_tl id="From Prior"></td>
	   <td width="20%" align="right"><cf_tl id="Allocated"></td>
	   <td width="20%" align="right"><cf_tl id="Used"></td>
   </tr>
 	
	<cfset  amt = url.amountbase>
	
	<cfloop query="qPeriod">
					
	<tr style="height:28px" class="line labelmedium">
		<td>#Period#</td>
		<td align="right">#numberformat(amt,'__,__.__')#</td>
		<td align="right" style="padding-left:7px;padding-top:1px">
		<input type="text"
		   name="Amount_#currentrow#"
		   style="text-align:right;width:100;height:23px;" 
		   class="regularxl enterastab"
		   value="#numberformat(PeriodAmount,',__')#">
		</td>
		<td align="right">#numberformat(PeriodAlloted,'__,__.__')#</td>	
		<td align="right">#numberformat(PeriodExpended,'__,__.__')#</td>				
	</tr>
	
	<cfif PeriodAmount neq "">
		<cfset amt = (amt + PeriodAmount) - PeriodAlloted>
	<cfelse>
		<cfset amt = amt - PeriodAlloted>
	</cfif>
	
	</cfloop>
						
	</table>
				
</cfoutput>				