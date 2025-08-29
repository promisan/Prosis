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
<table width="97%" align="center" class="navigation_table">

<cfquery name="Rate"
datasource="AppsPayroll" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT DISTINCT *, T.Description as TriggerDescription
	FROM   SalaryScaleComponent C,
		   Ref_PayrollComponent Com,
		   Ref_PayrollTrigger T
	WHERE  Com.Code = C.ComponentName
	AND    T.SalaryTrigger = Com.SalaryTrigger
	AND    C.ScaleNo       = '#Scale.ScaleNo#'
	AND    C.Period        != 'PERCENT' and C.RateStep = '9'
	ORDER BY T.Description
</cfquery>

<tr class="line labelmedium fixrow">
    
	<TD style="padding-left:20px"><cf_tl id="Component"></TD>	
	<TD><cf_tl id="Group"></TD>
	<TD><cf_tl id="Currency"></TD>
	<TD style="padding-right:4px" align="right"><cf_tl id="Amount"></TD>
	  
</TR>

<cfquery name="CurrencyList"
	datasource="AppsLedger" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT *
		FROM Currency
</cfquery>

<cfoutput query="Rate" group="SalaryTrigger">	

	<tr><td colspan="3" class="labelmedium fixrow2" style="font-size:20px;height:43px">#TriggerDescription#</td></tr>

	<cfoutput>
			   
			<TR bgcolor="white" class="line navigation_row labelmedium" style="height:20px">
			
			<cfset cp = "#replace(ComponentName,' ','','ALL')#">
		    <cfset cp = "#replace(cp,'-','','ALL')#">
			
			<TD style="padding-left:20px;border-top:1px solid silver">#Description# (#Code#)</TD>						
						
			<cfquery name="Group"
			datasource="AppsPayroll" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				SELECT    *
				FROM      Ref_PayrollTriggerGroup AS G 
				WHERE     G.SalaryTrigger     = '#SalaryTrigger#'
				AND       G.EntitlementGroup  = '#EntitlementGroup#'		  
			</cfquery>						
			
			<TD style="border-top:1px solid silver"><cfif Group.EntitlementName neq "">#Group.EntitlementName# (#Group.EntitlementGroup#)<cfelse>#Group.EntitlementGroup#</cfif></TD>		
					
			<cfquery name="getRate"
					datasource="AppsPayroll" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
				    SELECT  TOP 1 *
					FROM    SalaryScaleLine
					WHERE   ScaleNo        = '#Scale.ScaleNo#' 				
					AND     ComponentName  = '#ComponentName#'							
	     		</cfquery>		
				
				<cfif Rate.recordcount gte "1">
						
	    			 <cfset curr = getRate.Currency>
					 
				<cfelse>
							
					 <cfquery name="schedule"
						datasource="AppsPayroll" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">
					    SELECT  TOP 1 *
						FROM    SalarySchedule
						WHERE   SalarySchedule = '#Scale.SalarySchedule#'						
		     		</cfquery>		
									
				     <cfset curr = schedule.PaymentCurrency>
					 
				</cfif>			
			
			<TD style="border:1px solid silver;padding-right:2px" align="right">
			<select name="Currency_#cp#" class="regularxl enterastab" style="background-color:##ffffff80;border:0px;width:98%">
				  <cfloop query="CurrencyList">
				    <option value="#Currency#" <cfif Currency eq curr>selected</cfif>>#Currency#</option>
				  </cfloop>
			</select>	
					
			<input type="hidden" name="Currency_#cp#_old" id="Currency_#cp#_old" value="#getRate.Currency#">
			
			</td>		
			<td style="border:1px solid silver">
			
			<cfinput type="Text"
			       name="Amount_#cp#"
				   id="Amount_#cp#"
			       message="Please enter a valid amount"
			       validate="float"
				   value="#numberformat(getrate.amount,'.___')#"
			       required="No"
			       visible="Yes"
			       enabled="Yes"							   
			       size="5"
				   maxlength="20"
				   style="background-color:##ffffff80;border:0px solid silver;width:98%;text-align:right"
			       class="amount2 enterastab regularxl"/>
															   					   
		    <input type="hidden"  id="Amount_#cp#_old" name="Amount_#cp#_old" value="#getRate.amount#">
				
					
			</td>		
			
			</tr>	 
	
	</cfoutput>	
	
</cfoutput>	

</table>