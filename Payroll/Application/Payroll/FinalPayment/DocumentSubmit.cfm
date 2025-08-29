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
<!--- save or 
 update entries in the table Payroll.dbo.PersonMiscellaneous for the date of the 
separation (not later), the id is the SourceId which is coming from
EmployeeSettlement from cross reference. --->


<cfparam name="Form.Key4" default="">
<cfparam name="url.action" default="">

<cfquery name="get" 
datasource="AppsPayroll" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT *
    FROM   EmployeeSettlement	
    WHERE  SettlementId = '#form.Key4#'	
</cfquery>	

<cfquery name="payroll" 
	datasource="AppsPayroll" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT *
	FROM   PersonMiscellaneous
	WHERE  PersonNo = '#get.PersonNo#' 
	AND    Sourceid = '#get.SettlementId#'
	AND    PayrollItem NOT IN (SELECT   PayrollItem
						       FROM     Ref_PayrollGroupItem
							   WHERE    Code IN ('Retention')) 
	AND    Status   = '5'
</cfquery>	

<cfif payroll.recordcount gte "99">

	<table width="98%" align="center">
			<tr><td align="center" class="labellarge" style="height:40px;font-size:17px;border:0px solid silver">
			<font color="FF0000">It appears this final payment has been processed already. Please contact your administrator.</font></td></tr>
	</table>
		
	<cfabort>

<cfelse>

	<cftransaction>

	<cfquery name="payroll" 
	datasource="AppsPayroll" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		DELETE FROM   PersonMiscellaneous
		WHERE  PersonNo = '#get.PersonNo#' 
		AND    Sourceid = '#get.SettlementId#'		
	</cfquery>	
	
	<cfquery name="Item" 
			datasource="AppsPayroll" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">		
				SELECT    *
				FROM      Ref_PayrollItem
				WHERE     PayrollItem IN (#preserveSingleQuotes(Form.PayrollItem)#)			
	</cfquery>

	<cfloop query="Item">
	
		<cfparam name="Form.Quantity_#PayrollItem#" default="1">
		<cfparam name="Form.Amount_#PayrollItem#"   default="0">
		
		<cfset amt = evaluate("Form.Amount_#PayrollItem#")>
		
		<cfparam name="Form.Rate_#PayrollItem#"     default="#amt#">
		
		<cfset mem = evaluate("Form.Memo_#PayrollItem#")>
		<cfset qty = evaluate("Form.Quantity_#PayrollItem#")>
		<cfset qty = replace("#qty#",",","")>
		
		<cfset cur = evaluate("Form.Currency_#PayrollItem#")>
		<cfset rte = evaluate("Form.Rate_#PayrollItem#")>
		<cfset rte = replace("#rte#",",","")>
		<cfset amt = evaluate("Form.Amount_#PayrollItem#")>
		<cfset amt = replace("#amt#",",","")>
		
		<cfif not LSIsNumeric(rte)>
		
		<table width="98%" align="center">
			<tr><td align="center" class="labellarge" style="height:40px;font-size:20px;border:1px solid silver">
			<font color="FF0000">Problem, incorrect rate entered.</font></td></tr>
		</table>
		<cfabort>
		
		</cfif>
				
		<cfif LSIsNumeric(qty) and qty neq "" 
		 and  LSIsNumeric(rte) and rte neq "0">
		 	<cfset rte = Replace(rte, ",", "","ALL")>		
						
			<cfquery name="payroll" 
			datasource="AppsPayroll" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			INSERT INTO PersonMiscellaneous
			       (PersonNo, 
				    DateEffective, 
					DateExpiration, 
					DocumentDate,
					PayrollItem, 
					EntitlementClass,
					Quantity,
					Currency, 
					Rate, 
					Amount, 
					Status, 
					Remarks, 
					Source,
					SourceId,
					OfficerUserId, OfficerLastName, OfficerFirstName)
			VALUES ('#get.PersonNo#',
			        '#get.PaymentDate#',
					'#get.PaymentDate#',
					'#get.PaymentDate#',
					'#payrollitem#',
					<cfif PaymentMultiplier eq "-1">
					'Deduction',
					<cfelse>
					'Earning',
					</cfif>
					'#qty#',
					'#cur#',
					'#rte#',
					'#qty*rte#',					
					'3',
					'#mem#',
					'Final',
					'#get.settlementId#',
					'#session.acc#','#session.last#','#session.first#')
	 		</cfquery>		
		
		</cfif> 
	
	</cfloop>
	
	</cftransaction>
	
	 <cfif url.action eq "embed">
	
		 <table width="100%"><tr>
	          <td style="padding-right:19px;height:40px;padding-left:10px;font-size:19px;font-weight:normal;background-color:eaeaea;width:100%;border-right:1px solid silver;font-size:16px" align="right" class="labellarge"><cf_tl id="Final payment correction">:</td>
			  <td style="padding:1px;height:100%">
				  <table height="100%">
				  <tr>
		               <td height="100%" style="height:40;border:1px solid silver;background-color:C0F1C1;min-width:240px">
					   
					   <cfquery name="myresult" 
						datasource="AppsPayroll" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">	
						  SELECT   Currency, EntitlementClass, SUM(Amount) AS Amount
						  FROM     PersonMiscellaneous
						  WHERE    PersonNo    = '#get.PersonNo#' 
						  AND      Sourceid    = '#get.SettlementId#'		
						  GROUP BY Currency, EntitlementClass
					   </cfquery>
					  
					   <table width="100%">
					   <cfoutput query="myresult">
					     <tr class="labelmedium <cfif currentrow neq recordcount>line</cfif>">
						 <td style="padding-left:4px">#EntitlementClass#</td>
						 <td>#Currency#</td>							 
						 <td align="right" style="font-size:15px;padding-right:5px">#numberformat(amount,',.__')#</td>
						 </tr>					  
					   </cfoutput>		
					   </table>		 
					   
					   </td>
				  </tr>
				  </table>
			  </td>
			  </tr>
		 </table>
	 
	 </cfif>
	
</cfif>	



