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
	SELECT *, 
			(SELECT Execution 
			 FROM   Ref_ContributionClass 
			 WHERE  Code = C.ContributionClass) as Execution
	FROM   Contribution C
	WHERE  ContributionId = '#URL.ContributionId#'
</cfquery>

<cfset url.mission = qContribution.mission>

<cfquery name="Param" 
	datasource="AppsProgram"  
	username="#SESSION.login#"
	password="#SESSION.dbpw#">
	SELECT *
	FROM   Ref_ParameterMission
	WHERE  Mission = '#url.Mission#'	
</cfquery>


<cfif url.systemfunctionid neq "" and url.systemfunctionid neq "{00000000-0000-0000-0000-000000000000}">
		
	<cf_screentop height="100%" 
				  scroll="Yes" 
				  layout="webapp" 
				  label="Maintain tranche" 			  
				  banner="gray" 
				  menuAccess="Yes" 
				  jquery="Yes"
				  line="no"
				  close="parent.ColdFusion.Window.destroy('mydialog',true)"
				  systemfunctionid="#url.systemFunctionId#">
			  
<cfelse>
		
	<cf_screentop height="100%" 
				  scroll="Yes" 
				  layout="webapp" 
				  label="Maintain tranche" 			  
				  banner="gray" 
				  menuAccess="no" 
				  jquery="Yes"
				  line="no"
				  close="parent.ColdFusion.Window.destroy('mydialog',true)"
				  systemfunctionid="#url.systemFunctionId#">

</cfif>			  

<cfoutput>

<cfform id="form_contribution_line_pop" style="width:100%;height:100%"
        name="form_contribution_line_pop" 
		action="ContributionLineDialogSubmit.cfm?systemFunctionId=#url.systemFunctionId#&isPop=1&contributionId=#url.contributionId#&contributionLineid=#url.contributionLineId#" 
		target="processContributionLine"> 

	<table width="91%" cellspacing="0" cellpadding="0" align="center" class="formpadding formspacing">
	
		<tr class="hide"><td colspan="2">
		<iframe name="processContributionLine" id="processContributionLine" width="100%" frameborder="0"></iframe>
		</td>
		</tr>
		
		<tr><td height="8"></td></tr>
		
		<cf_calendarscript>
	
		<tr>
			<td width="20%" class="labelmedium"><cf_tl id="Received">:</td>
			<td style="position:relative; z-index:90004;">
			 
			 <cfif URL.ContributionLineId neq "">
			 	<cfset dateRec = qLine.DateReceived>
			 <cfelse>	
			 	<cfset dateRec = now()>
			 </cfif>
			 
			 	<cf_intelliCalendarDate9
			    	  FieldName="DateReceived"
				      Default="#Dateformat(dateRec, CLIENT.DateFormatShow)#"
					  class="regularxl enterastab"				  
				      AllowBlank="Yes">         
					  
			</td>
		</tr>
		<tr>
			<td class="labelmedium"><cf_tl id="Effective">:</td>
			<td style="position:relative; z-index:90003;">
			 
			 <cfif URL.ContributionLineId neq "">
			 	<cfset dateEff = qLine.DateEffective>
			 <cfelse>	
			 	<cfset dateEff = now()>
			 </cfif>
			 
			 <cf_intelliCalendarDate9
			    	  FieldName="DateEffective"
				      Default="#Dateformat(dateEff, CLIENT.DateFormatShow)#"
					  class="regularxl enterastab"
				      AllowBlank="Yes">    				  
	
			</td>
		</tr>
		<tr>
			<td class="labelmedium"><cf_tl id="Expiration">:</td>
			<td style="position:relative; z-index:90002;">
	
				 <cfif URL.ContributionLineId neq "">
				 	<cfset dateExp = qLine.DateExpiration>
				 <cfelse>	
				 	<cfset dateExp = now()>
				 </cfif>	
			 	 
			 	<cf_intelliCalendarDate9
			       FieldName="DateExpiration"
			       Default="#Dateformat(dateExp, CLIENT.DateFormatShow)#"
				   class="regularxl enterastab"
			       AllowBlank="Yes">  
		 
			</td>		
		</tr>
		<tr>
			<td class="labelmedium"><cf_tl id="Reference">:</td>
			<td>
			
		    	<cfif URL.ContributionLineId neq "">
			 	   <cfset reference = qLine.reference>
			    <cfelse>	
			 		<cfset reference = "">
				</cfif>		
					
				<input type="text" maxlength="20" name="Reference" id="Reference" class="regularxl enterastab" value="#reference#" style="width:140; padding-right:3px;"/>
					
			</td>
		</tr>
		<tr>
			<td class="labelmedium"><cf_tl id="Fund">:</td>
			<td>
			
			    <cfif URL.ContributionLineId neq "">
			 	   <cfset fund = qLine.Fund>
			    <cfelse>	
			 		<cfset fund = "">
				</cfif>			
				
				<cfquery name="qFund" 
					datasource="AppsProgram"  
					username="#SESSION.login#"
					password="#SESSION.dbpw#">
					SELECT *
					FROM   Ref_Fund
					WHERE  Code IN ( SELECT Fund FROM Ref_AllotmentEditionFund F, Ref_AllotmentEdition R
					                 WHERE  R.EditionId = F.EditionId
									 AND    R.Mission = '#qContribution.Mission#')
				</cfquery>
				
				<select id="fund" name="fund" class="regularxl enterastab">
				
					<cfloop query="qFund">
						<option value="#code#" <cfif fund eq code>selected</cfif>>#Code#</option>
					</cfloop>
				
				</select>
				
			</td>
		</tr>
		<tr>
			<td class="labelmedium"><cf_tl id="Amount">:</td>
			<td>
	
			    <cfif URL.ContributionLineId neq "">
			 	   <cfset currency = qLine.currency>
			    <cfelse>	
			 		<cfset currency = "">
				</cfif>			
						
				<cfquery name="qCurrency" 
					datasource="AppsLedger"  
					username="#SESSION.login#"
					password="#SESSION.dbpw#">
						SELECT 	*
						FROM 	Currency
						WHERE 	Currency IN (	SELECT Currency
										    FROM   CurrencyMission
										    WHERE  Mission = '#qContribution.Mission#' )
				</cfquery>
				
				<cfif qCurrency.recordcount eq "0">
				
					<cfquery name="qCurrency" 
						datasource="AppsLedger"  
						username="#SESSION.login#"
						password="#SESSION.dbpw#">
							SELECT 	*
							FROM 	Currency					
					</cfquery>
							
				</cfif>
				
				<cfif qLine.recordCount eq 0>
					<cfset vSelectedCurr = Application.BaseCurrency>
				<cfelse>
					<cfif trim(qLine.Currency) eq "">
						<cfset vSelectedCurr = Application.BaseCurrency>
					<cfelse>
						<cfset vSelectedCurr = qLine.Currency>
					</cfif>
				</cfif>
				
				<cfif URL.ContributionLineId neq "">
			 	   <cfset amount = qLine.amount>
			    <cfelse>	
			 		<cfset amount = "">
				</cfif>	
				
				<table cellspacing="0" cellpadding="0">
				<tr><td>
				
				<select id="currency" 
						name="currency" class="regularxl enterastab"
						onchange="_cf_loadingtexthtml='';ColdFusion.navigate('setAmountBase.cfm?mission=#url.mission#&amount=#amount#&cur='+this.value+'&amountbase=#qline.amountBase#&contributionlineid=#url.contributionlineid#','divAmountBase');">
					<cfloop query="qCurrency">
						<option value="#qCurrency.Currency#" <cfif vSelectedCurr eq qCurrency.Currency>selected</cfif>>#qCurrency.Currency#</option>
					</cfloop>
				</select>
				
				</td>
				<td style="padding-left:2px">	
						
				<input type="text" 
					name="Amount" 
					id="Amount" class="regularxl enterastab"
					value="#Trim(NumberFormat(amount,',.__'))#" 
					style="text-align:right;width:120px" 
					onchange="_cf_loadingtexthtml='';ColdFusion.navigate('setAmountBase.cfm?mission=#url.mission#&amount='+this.value+'&cur='+currency.value+'&amountbase=#qline.amountBase#&contributionlineid=#url.contributionlineid#','divAmountBase');">
	
				</td>
				
				</tr>
				</table>
				
			</td>
		</tr>
			
		<tr>
			<td height="23" class="labelmedium"><cf_tl id="Amount"> #Param.BudgetCurrency#:</td>
			<td class="labelmedium" id="divAmountBase">		
				#numberformat(qline.amountBase,',.__')#
				<input type="Hidden" id="AmountBase" name="AmountBase" value="#qline.amountBase#">	
			</td>
		</tr>
		
		<cfif qContribution.Execution eq "0">
		
			<input type="hidden" name="OverAllocate" value="0">
			
			<tr>
				<td height="23" class="labelmedium" style="cursor:pointer"><cf_UIToolTip tooltip="Funds parent contribution"><cf_tl id="Implementing Grant"></cf_UIToolTip>:</td>
				<td class="labelmedium"> 
				
				<cfdiv id="parent" 
				   bind="url:getParentContributionLine.cfm?mission=#qcontribution.mission#&contributionlineid=#qline.parentcontributionlineid#&fund={fund}">
				
				
				</td>
			</tr>			
		
		<cfelse>
		
			<tr>
				<td height="23" class="labelmedium" style="cursor:pointer"><cf_UIToolTip  tooltip="Allows during  allotment the contribution line to be overspend with a percentage"><cf_tl id="Over allocation"></cf_UIToolTip>:</td>
				<td class="labelmedoum"> 
						
				<cfinput type="Text"
					   name="OverAllocate" value="#qLine.OverAllocate#" range="0,15" validate="integer"  maxlength="2" class="regularxl enterastab" style="text-align:center;width:30"> %		
					
				</td>
			</tr>
		
		</cfif>
		
		
		
		
		<tr>
			<td height="23" class="labelmedium" valign="top" style="padding-top:4px"><cf_tl id="Allocation"> #Application.BaseCurrency#:</td>
			<td id="amountperiod" style="padding-top:4px">
			
			    <cfset url.amountbase = qLine.amountBase>
				<cfinclude template="ContributionLineDialogPeriod.cfm">				
							
			</td>
		</tr>
		
		<tr><td class="labelmedium" valign="top" style="padding-top:3px"><cf_tl id="Remarks">:</td>
		<td class="labelmedium">
		    
			<textarea type="text" 
			      name="remarks" 			   
				  class="regular"  
				  style="padding:3px;font-size:14px;width:100%;height:97" 
				  totlength="500" 
				  onkeyup="return ismaxlength(this)">#qLine.Remarks#</textarea>
				  
		</td>
		</tr>
		
		
		<cfif URL.ContributionLineId neq "">
		
		<tr>
			<td style="height:25" class="labelmedium"><cf_tl id="Status">:</td>
			<td class="labelmedium">
				<cfif qLine.ActionStatus eq 0><cf_tl id="Pending"></cfif>
				<cfif qLine.ActionStatus eq 1><cf_tl id="Cleared"></cfif>
			</td>
		</tr>	
		
		<tr>
			<td style="height:25" class="labelmedium"><cf_tl id="Last updated by">:</td>
			<td class="labelmedium">
				[#qLine.OfficerUserId#] #qLine.OfficerFirstName# #qLine.OfficerLastName# #dateformat(qLine.created,client.dateformatshow)# #timeformat(qLine.created,"HH:MM")# 
			</td>
		</tr>
		
		</cfif>
		
		<tr><td height="2"></td></tr>
		<tr><td colspan="2" class="line"></td></tr>
		<tr><td height="2"></td></tr>
		
		<tr>
			<td colspan="2" align="center">
			
		    	<input type="Submit" style="width:200px;height:27px" id="btnSave" name="btnSave" class="button10g" value=" Save ">	
				
			</td>		
		
		</tr>
	
	</table>	
	
</cfform>

</cfoutput>