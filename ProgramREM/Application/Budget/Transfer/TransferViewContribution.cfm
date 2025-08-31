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
 <cfquery name="contribution" 
		datasource="AppsProgram" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">		
		SELECT    *
		FROM      ContributionLine 
		WHERE     ContributionLineId = '#url.contributionLineId#'
	 </cfquery> 

 <cfquery name="get" 
		datasource="AppsProgram" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		
		SELECT     P.Mission, 
		           P.ProgramCode, 
				   P.ProgramName,
				   R.EditionId,
				   R.Period as ProgramPeriod,
		           PA.Fund, 
				   PA.ObjectCode,
				   PAC.Amount,
				   Per.Period, 
				   Per.DateEffective, 
				   Per.DateExpiration
		FROM       ProgramAllotmentDetail PA INNER JOIN 
				   ProgramAllotmentDetailContribution PAC ON PA.Transactionid = PAC.TransactionId INNER JOIN
                   Program P ON PA.ProgramCode            = P.ProgramCode INNER JOIN
                   Ref_AllotmentEdition R ON PA.EditionId = R.EditionId INNER JOIN
                   Ref_Period Per ON R.Period             = Per.Period
		WHERE      PAC.TransactionId                      = '#url.transactionid#'
	    AND        PAC.ContributionLineId                 = '#url.contributionLineId#'
	 </cfquery> 
	
	<table width="96%" align="center" class="formpadding">
	
		<cfoutput>
				
		<tr><td colspan="9" class="line"></td></tr>
		
		<tr>
		    
			<td height="30" width="30%" class="labelmedium" style="padding-left:10px">#get.ProgramName#</td>	
			<td width="5%" class="labelsmall" style="width:40;padding-left:10px">Contribution:</td>
			<td width="9%" class="labelmedium"><b>#Contribution.Reference#</td>											
			<td width="10%" class="labelsmall" style="width:40;padding-left:10px">Fund:<b>#get.Fund#</td>
				
			<cfquery name="Object" 
			datasource="AppsProgram" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				SELECT *
				FROM Ref_Object
				WHERE Code = '#get.ObjectCode#'
			</cfquery>
		
			<td class="labelmedium" style="padding-left:10px">Object: <b>#Object.Code# #Object.Description#</td>
				
			<td align="right" width="5%" class="labelsmall" style="padding-left:30px">Amount:</td>
			<td class="labelmedium" align="right" style="padding-right:8px"><b>#numberformat(get.Amount,"__,__.__")#</td>
		</tr>	
		
		<tr><td colspan="9" class="line"></td></tr>	
		<tr><td height="4"></td></tr>
		
		<tr>
		<td width="500" class="labelmedium style="padding-left:20px">Transaction Date:</td>
		<td colspan="8">
		
		<cf_calendarscript>
		
		<cf_intelliCalendarDate9
					FieldName="TransactionDate" 
					Manual="True"		
					class="regularxl"					
					DateValidStart="#Dateformat(get.DateEffective, 'YYYYMMDD')#"
					DateValidEnd="#Dateformat(get.DateExpiration, 'YYYYMMDD')#"
					Default="#dateformat(now(),client.dateformatshow)#"
					AllowBlank="False">	
		
		</td>
		</tr>
		
		<tr><td class="labelmedium" valign="top" style="padding-left:20px;padding-top:6px"><cf_tl id="Memo">:</td>
			<td colspan="8">
				<textarea totlength="150" class="regular" onkeyup="return ismaxlength(this)" name="Memo" 
				  style="height:30;width:95%"></textarea>	
			</td>	  
		</tr>
		
		<tr><td height="4"></td></tr>		
		<tr><td colspan="9" class="line"></td></tr>
		
		</cfoutput>
		
		<!--- we will prepolulate the from record and 
		   WE only get the amount on money that is really available for movements as the rest has been executed already --->
				
		<cfinvoke component   = "Service.Process.Program.ProgramAllotment"  
		   method             = "validateContributionBalance" 
		   ProgramCode        = "#get.programcode#" 
		   Period             = "#get.ProgramPeriod#"	
		   Fund               = "#get.Fund#"
		   ObjectCode         = "#get.ObjectCode#"						  
		   ContributionLineId = "#url.ContributionLineId#"
		   returnvariable     = "contribution">	 
			
		<cfquery name="RecordFrom" 
				datasource="AppsProgram" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				INSERT INTO UserQuery.dbo.#SESSION.acc#BudgetTransfer_#client.sessionNo#
		
					(ContributionLineId,
					 Period,
					 EditionId,
					 ProgramCode,
					 ActionClass,
					 Fund,
					 ObjectCode,
					 AmountCurrent,
					 Amount)
				 
				SELECT '#url.contributionlineid#',
					   Period,
					   EditionId,
					   ProgramCode,
					   'Transfer',
					   Fund,
					   ObjectCode,
					   '#contribution.balance#',
					   #contribution.balance#*-1	
					   	
				FROM   ProgramAllotmentDetail D, ProgramAllotmentDetailContribution C
				WHERE  D.TransactionId      = C.TransactionId				
				AND    D.TransactionId      = '#url.transactionid#'
				AND    C.ContributionLineId = '#url.contributionLineId#'
				 			 
		</cfquery>
		
		<!--- ------------- --->
		<!--- main box info --->
		<!--- ------------- --->
		
		<cfoutput>
			<input type="hidden" id="program"            name="program"            value="#get.ProgramCode#">
			<input type="hidden" id="contributionlineid" name="contributionlineid" value="#url.contributionLineId#">
			<input type="hidden" id="period"             name="period"             value="#get.Period#">
			<input type="hidden" id="editionid"          name="editionid"          value="#get.EditionId#">
			<input type="hidden" id="resource"           name="resource"           value="">
			<input type="hidden" id="actionclass"        name="actionclass"        value="transfer">			
		</cfoutput>
						
		<cfset url.program     = "#get.ProgramCode#">
		<cfset url.period      = "#get.Period#">
		<cfset url.editionid   = "#get.EditionId#">
		<cfset url.resource    = "">
		<cfset url.actionclass = "transfer">
	
		<tr><td height="10"></td></tr>
		<tr><td colspan="9" id="linesfrom">
		
		<cfset url.actionclass  = "transfer">
		<cfset url.direction    = "from">	
		<cfset url.processmode  = "edit">		
				
		<cfinclude template="TransferDialogLines.cfm">
	
		</td></tr>	
		<tr><td height="10"></td></tr>
		<tr><td colspan="9" id="linesto">
		
		<cfset url.direction   = "to">		
		<cfset url.program     = "">		
		<cfset url.processmode = "all">			
		<cfinclude template="TransferDialogLines.cfm">
		
		</td></tr>	
		<tr><td colspan="9" id="process" align="center"></td></tr>
		
		<tr class="xhide">
		<td colspan="2" height="300" id="result"></td>
		</tr>
		
</table>		