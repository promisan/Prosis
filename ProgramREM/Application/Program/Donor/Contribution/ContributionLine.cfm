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
<cfparam name="URL.ContributionLineId" default="">

<cfif URL.ContributionLineId neq "">

	<cfquery name="qLine" 
		datasource="AppsProgram"  
		username="#SESSION.login#"
		password="#SESSION.dbpw#">
			SELECT * 
			FROM   ContributionLine
			WHERE  ContributionLineId = '#URL.ContributionLineId#'
	</cfquery>

	<cfset URL.ContributionId =	qLine.ContributionId>
	
</cfif>

<cfquery name="qContribution" 
	datasource="AppsProgram"  
	username="#SESSION.login#"
	password="#SESSION.dbpw#">
	SELECT * 
	FROM   Contribution
	WHERE  ContributionId = '#URL.ContributionId#'
</cfquery>

<cfoutput>

<cfform id="form_contribution_line" 
        name="form_contribution_line" 
		onsubmit="return false;"> 

<table cellspacing="0" cellpadding="0" width="100%" border="0">

	<tr class="linedotted">
					
		<td style="height:40" width="5%"></td>
	
		<td style="min-width:150">
		 
		 
		 <cfif URL.ContributionLineId neq "">
		 	<cfset dateRec = qLine.DateReceived>
		 <cfelse>	
		 	<cfset dateRec = now()>
		 </cfif>
		 
		 	<cf_intelliCalendarDate9
		    	  FieldName="DateReceived"
			      Default="#Dateformat(dateRec, CLIENT.DateFormatShow)#"
				  class="regularxl"
			      AllowBlank="Yes">         
				  
		</td>			

		<td style="min-width:150">		 
		
		 <cfif URL.ContributionLineId neq "">
		 	<cfset dateEff = qLine.DateEffective>
		 <cfelse>	
		 	<cfset dateEff = now()>
		 </cfif>
		 
		 <cf_intelliCalendarDate9
		    	  FieldName="DateEffective"
			      Default="#Dateformat(dateEff, CLIENT.DateFormatShow)#"
				  class="regularxl"
			      AllowBlank="Yes">    				  

		</td>	
		
		<td style="min-width:150">
					
			 <cfif URL.ContributionLineId neq "">
			 	<cfset dateExp = qLine.DateExpiration>
			 <cfelse>	
			 	<cfset dateExp = now()>
			 </cfif>	
		 	 
		 	<cf_intelliCalendarDate9
		       FieldName="DateExpiration"
		       Default="#Dateformat(dateExp, CLIENT.DateFormatShow)#"
			   class="regularxl"
		       AllowBlank="Yes">  
	 
		</td>		
		
		<td width="30%">
		
		    	<cfif URL.ContributionLineId neq "">
			 	   <cfset reference = qLine.reference>
			    <cfelse>	
			 		<cfset reference = "">
				</cfif>		
					
				<div>		
					<input type="text" class="regularxl" maxlength="20" name="Reference" id="Reference" value="#reference#" style="text-align:left; width:90%; padding-right:3px;"/>		
				</div>	
				
		</td>
		
		<td width="80px">
		
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
			
			<select id="fund" name="fund" class="regularxl">
			
				<cfloop query="qFund">
					<option value="#code#" <cfif fund eq code>selected</cfif>>#Code#</option>
				</cfloop>
			
			</select>
			
		</td>
		
		<td width="80px"  align="right">

		    <cfif URL.ContributionLineId neq "">
		 	   <cfset currency = qLine.currency>
		    <cfelse>	
		 		<cfset currency = "">
			</cfif>			
					
			<cfquery name="qCurrency" 
				datasource="AppsLedger"  
				username="#SESSION.login#"
				password="#SESSION.dbpw#">
					SELECT *
					FROM Currency
					WHERE Currency IN (	SELECT Currency
									    FROM   CurrencyMission
									    WHERE  Mission = '#qContribution.Mission#' )
			</cfquery>
			
			<cfif qCurrency.recordcount eq "0">
			
				<cfquery name="qCurrency" 
					datasource="AppsLedger"  
					username="#SESSION.login#"
					password="#SESSION.dbpw#">
						SELECT *
						FROM Currency					
				</cfquery>
						
			</cfif>
			
			<select id="currency" name="currency" class="regularxl">
				<cfloop query="qCurrency">
					<option value="#Currency#" <cfif Currency eq APPLICATION.BaseCurrency>selected</cfif>>#Currency#</option>
				</cfloop>
			</select>
			
		</td>
		
		<td align="right">
			
			<div align="right">
			
		    	<cfif URL.ContributionLineId neq "">
			 	   <cfset amount = qLine.amount>
			    <cfelse>	
			 		<cfset amount = "">
				</cfif>			
						
				<input type="text" class="regularxl" name="Amount" id="Amount" value="#Trim(NumberFormat(amount,'__,___.__'))#" style="text-align:right;width:90px"/>
				
			</div>	
			
		</td>	

		<td style="padding-left:3px" width="40px">
		
	    	<cfif URL.ContributionLineId neq "">
				<button onclick="saveeditrow('#url.systemFunctionId#','#url.contributionId#','#url.contributionLineId#')" id="btnSaveLine" name="btnSaveLine" style="height:26" class="btn_small">Save</button>
		    <cfelse>	
				<button onclick="saverow('#url.systemFunctionId#','#url.contributionId#')" id="btnSaveLine" name="btnSaveLine" style="height:26" class="btn_small">Save</button>
			</cfif>			
			
		</td>		
	
	</tr>		

</table>	
	
</cfform>

</cfoutput>

<cfset ajaxonload("doCalendar")>