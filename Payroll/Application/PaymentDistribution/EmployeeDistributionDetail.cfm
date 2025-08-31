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
<cfset dateValue = "">
<cf_DateConvert Value="#url.dateEffective#">
<cfset vDateEffective = dateValue>

<cfset vLines     = url.lines>
<cfset vBigAmount = url.bigAmount>

<cfif url.mode eq "Cash">

	<cfloop from="1" to="#vLines#" index="thisLine">
		<cfoutput>
			<input type="hidden" name="AccountId_#thisLine#" value="">
			<input type="hidden" name="DistributionOrder_#thisLine#" value="#thisLine#">
			<cfset vThisValue = "">
			<cfif thisLine eq 1>
				<cfif url.method eq "Amount">
					<cfset vThisValue = vBigAmount>
				</cfif>
				<cfif url.method eq "Percentage">
					<cfset vThisValue = 100>
				</cfif>
			</cfif>
			<input type="hidden" name="DistributionNumber_#thisLine#" value="#vThisValue#">
		</cfoutput>
	</cfloop>

	<table>
		<tr><td height="10"></td></tr>
	</table>

<cfelse>

	<!--- show accounts to be selected 
	
	only cleared accouunt and if an account is cleared and 
	  has a child account which is cleared it will no longer be shown --->

	<cfquery name="Accounts" 
	     datasource="AppsPayroll" 
	     username="#SESSION.login#" 
	     password="#SESSION.dbpw#">
			SELECT    PA.*,
					  B.Description as BankDescription
			FROM      PersonAccount PA INNER JOIN Ref_Bank B ON PA.BankCode = B.Code
			WHERE     PersonNo = '#url.id#'
			<!--- cleared --->
			AND       ActionStatus = '1'
			<!--- no active children --->
			AND       NOT EXISTS (SELECT 'X'
			                      FROM   PersonAccount
								  WHERE  PersonNo = '#url.id#'
								  AND    SourceId = PA.Accountid
								  AND    ActionStatus = '1')
			AND 	  PA.DateEffective <= GETDATE()
			AND 	  (PA.DateExpiration >= GETDATE() OR PA.DateExpiration IS NULL)
	</cfquery>

	<cfquery name="getContract" 
	     datasource="AppsEmployee" 
	     username="#SESSION.login#" 
	     password="#SESSION.dbpw#">
			SELECT TOP 1 PC.*
			FROM      PersonContract PC
			WHERE     PersonNo = '#url.id#'
			AND 	  PC.DateEffective <= (GETDATE() + 460)
			AND 	  (PC.DateExpiration >= (GETDATE() - 460) OR PC.DateExpiration IS NULL)
			AND 	  PC.ActionStatus != '9'
			ORDER BY PC.Created DESC
	</cfquery>
	
	<cfif getContract.recordCount eq 0>
		<cfquery name="getContract" 
		     datasource="AppsEmployee" 
		     username="#SESSION.login#" 
		     password="#SESSION.dbpw#">
				SELECT TOP 1 PC.*
				FROM      PersonContract PC
				WHERE     PersonNo = '#url.id#'
				AND 	  PC.ActionStatus != '9'
				ORDER BY PC.DateEffective DESC
		</cfquery>
	</cfif>

	<cfquery name="getCurrencies" 
	     datasource="AppsPayroll" 
	     username="#SESSION.login#" 
	     password="#SESSION.dbpw#">
			SELECT DISTINCT S.PaymentCurrency AS Currency	
			FROM 	SalaryScheduleMission SM 
					INNER JOIN SalarySchedule S 
						ON SM.SalarySchedule = S.SalarySchedule
			WHERE 	SM.Mission = '#getContract.Mission#'
			AND 	S.Operational = '1'
			ORDER BY S.PaymentCurrency ASC
	</cfquery>

	<cfset vSuffix = "">
	<cfset vWidth = "width:100px;">
	<cfset vRestAmout = vBigAmount>
	<cfif url.method eq "Percentage">
		<cfset vSuffix = "%">
		<cfset vWidth = "width:50px;">
	</cfif>

	<cfquery name="getLines" 
	     datasource="AppsPayroll" 
	     username="#SESSION.login#" 
	     password="#SESSION.dbpw#">
			SELECT 	*	
			FROM 	PersonDistribution
			WHERE 	PersonNo = '#url.id#'	
			AND 	Operational = 1
			AND 	DateEffective = #vDateEffective#
	</cfquery>	

	<cfloop from="1" to="#vLines#" index="thisLine">

		<cfquery name="get" 
		     datasource="AppsPayroll" 
		     username="#SESSION.login#" 
		     password="#SESSION.dbpw#">
				SELECT 	*	
				FROM 	PersonDistribution
				WHERE 	PersonNo = '#url.id#'	
				AND 	DistributionOrder = #thisLine#
				AND 	Operational = 1
				AND 	DateEffective = #vDateEffective#
				<cfif url.reset eq 1>
					AND 	1=0
				</cfif>
		</cfquery>

		<cfoutput>
			
			<table width="100%" class="formpadding navigation_table">
			
				<tr class="navigation_row">
					
					<td class="labellarge" width="3%">
						<input type="hidden" name="DistributionOrder_#thisLine#" value="#thisLine#">
						#thisLine#.
					</td>
					
					<td style="padding-left:10px;">					
					   
						<select name="AccountId_#thisLine#" id="AccountId_#thisLine#" class="regularxl clsSelect" style="width:500px;font-size:15px; height:32px;">
							<cfset vCntAccounts = 0>
							 <option disabled class="clsOption"><cf_tl id="Transfer"></option>
						
							<cfloop query="Accounts">
								<cfset vSelected = "">
								<cfset vCntAccounts = vCntAccounts + 1>

								<cfif getLines.recordCount eq 0>
									<cfif vCntAccounts eq thisLine>
										<cfset vSelected = "selected">
									</cfif>
								<cfelse>
									<cfif get.AccountId eq AccountId>
										<cfset vSelected = "selected">
									</cfif>
								</cfif>

								<option class="clsOption" value="#AccountId#" #vSelected#>#BankDescription# (#AccountNo#)</option>
								<option disabled style="font-size:12px;">&nbsp;&nbsp;&nbsp;#AccountName#: #AccountCurrency# #AccountType# #Swiftcode#</option> 
								
							</cfloop>
									
							<cfif get.PaymentMode eq "Check">
								<option class="clsOption"  value="Check" selected><cf_tl id="Check"></option>
							<cfelse>
								<option class="clsOption"  value="Check"><cf_tl id="Check"></option>
							</cfif>													
							
							<cfif get.PaymentMode eq "Cash">											
							<option class="clsOption" selected value="Cash"><cf_tl id="Cash"></option>	
						    <cfelse>
							<option class="clsOption" value="Cash"><cf_tl id="Cash"></option>							
							</cfif>
							
						</select>
					</td>
					
					<td style="padding-left:10px;" class="labellarge">
						<select name="Currency_#thisLine#" id="Currency_#thisLine#" class="regularxl" style="font-size:15px; height:32px;" required="yes">
							<cfloop query="getCurrencies">
								<option value="#Currency#" <cfif currency eq get.DistributionCurrency>selected</cfif>>#Currency#</option>
							</cfloop>							
						</select>
					</td>
					<td style="padding-left:10px;" class="labelit" width="80%">
					
						<cfif thisLine eq vLines>
						
							<cf_tl id="The rest">
							<input type="hidden" name="DistributionNumber_#thisLine#" value="#vRestAmout#">
							
						<cfelse>

							<cfset vValue = get.DistributionNumber>
							<cfif get.DistributionNumber eq "">
								<cfset vValue = 0>
							</cfif>

							<input type="text" 
								name="DistributionNumber_#thisLine#" 
								id="DistributionNumber_#thisLine#" 
								class="regularxl" 
								style="font-size:15px; height:32px; padding:5px; text-align:right; #vWidth#" 
								value="#vValue#"> &nbsp;#vSuffix#
						</cfif>
					</td>
				</tr>
			</table>
		</cfoutput>

	</cfloop>

	<table width="100%">
		<tr><td height="10"></td></tr>
		<tr><td class="line"></td></tr>
		<tr><td height="10"></td></tr>
	</table>

</cfif>

<table>
	<tr><td class="labelit" style="color:#808080; padding-left:50px; padding-bottom:10px;">** <cf_tl id="Zero (0) amounts/percentages will not be considered as a distribution method"></td></tr>
</table>

<cfset ajaxOnLoad("doHighlight")>