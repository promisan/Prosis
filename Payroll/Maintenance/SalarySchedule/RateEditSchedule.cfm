
<table width="97%" align="center" cellspacing="0" cellpadding="0" class="formspacing">

<cfquery name="Percentage"
datasource="AppsPayroll" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT DISTINCT *
	FROM   SalaryScaleComponent C,
		   Ref_PayrollComponent Com,
		   Ref_PayrollTrigger T
	WHERE  Com.Code = C.ComponentName
	AND    T.SalaryTrigger = Com.SalaryTrigger
	AND    C.ScaleNo       = '#Scale.ScaleNo#'
	AND    C.Period        = 'PERCENT' 	
</cfquery>

<tr class="line labelmedium">
    
	<TD align="left"><cf_tl id="Component"></TD>
	<TD align="left"><cf_tl id="Condition"></TD>
	
	<TD align="left"><cf_tl id="Percentage"></TD>
	<td align="left"><cf_tl id="Calculation base"></td>
	<td align="left"><cf_tl id="Calculation base Final"></td>
	<TD align="left"><cf_tl id="Detail Table"></TD>
	<TD align="left"><cf_tl id="Base Month"></TD>
	<!---
	<TD align="left">Settle Until</TD>
	--->
  
</TR>

<cfoutput query="Percentage">

    <cfif TriggerConditionPointer neq "">
	   <cfset pointer = "#TriggerConditionPointer#">
	<cfelse>
	   <cfset pointer = "0">
	</cfif>
		
	<cfloop index="pt" list="#pointer#" delimiters=","> 
		
		<cfquery name="Perc"
			datasource="AppsPayroll" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
		    SELECT 
			<!-----to avoid scientific notation as the value for the percentage: for very small/large numbers ---->
		    		P.ScaleNo, P.ComponentName, P.EntitlementPointer, cast(Percentage as Decimal(14,8)) as Percentage,
			 	P.CalculationBase,P.calculationBaseFinal, P.CalculationBasePeriod, P.DetailMode, P.OfficerUserId, P.OfficerLastName, P.OfficerFirstName
				, S.EntitlementRecurrent
			FROM   SalaryScale R,
				   SalaryScalePercentage P, 
			       SalaryScaleComponent S
			WHERE  R.ScaleNo            = '#Scale.ScaleNo#'
			AND    R.ScaleNo            = P.ScaleNo
			AND    P.ComponentName      = '#ComponentName#'
			AND    P.EntitlementPointer = '#pt#'
			AND    R.ScaleNo            = S.ScaleNo
			AND    P.ComponentName      = S.ComponentName
		</cfquery>    
	   
		<TR bgcolor="white">
		
		<cfset com = "#replace(ComponentName,' ','','ALL')#">
		<cfset com = "#replace(com,'-','','ALL')#">
		
		<TD class="labelmedium">#ComponentName#</TD>
		
		<TD class="labelmedium">#TriggerCondition# <cfif TriggerConditionPointer neq "">(#pt#)</cfif></TD>
		
		<TD>
		
		<cfinput type="Text" 
		    name="#Com#_Percentage_#pt#" 
			value="#Perc.Percentage#" 
			validate="float" 
			class="regularxl" 
			required="No" 
			visible="Yes" 
			enabled="Yes" 
			size="8" 
			maxlength="14" 
			style="text-align:right"> %
		</TD>
				
		<cfquery name="Base"
		datasource="AppsPayroll" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		    SELECT *
			FROM   Ref_CalculationBase	
			WHERE  Code IN (SELECT Code 
			                FROM   Ref_CalculationBaseItem 
						    WHERE  SalarySchedule = '#URL.Schedule#')		
		</cfquery>
		
		<TD>
		
			<select style="width:150px" name="#Com#_CalculationBase_#pt#" class="regularxl">
			 <cfloop query="Base">
			<option value="#Code#" <cfif Perc.CalculationBase eq "#Code#">selected</cfif>>#Description#</option>
			</cfloop>
			</select>
		
		</TD>
		
		<TD>
		
			<select style="width:150px" name="#Com#_CalculationBaseFinal_#pt#" class="regularxl">
			 <cfloop query="Base">
			<option value="#Code#" <cfif Perc.CalculationBaseFinal eq "#Code#">selected</cfif>>#Description#</option>
			</cfloop>
			</select>
			
		</TD>
		
		<td>	
		
			<table cellspacing="0" cellpadding="0" class="formspacing">
			<tr>	
			<td class="labelmedium">
			<input type="radio" name="#Com#_DetailMode_#pt#" value="" <cfif Perc.DetailMode eq "">checked</cfif>> None
			</td>
			<td class="labelmedium" style="padding-left:6px">
			<input onclick="javascript:showdetails('#Scale.ScaleNo#','#ComponentName#','#pt#')"type="radio" name="#Com#_DetailMode_#pt#" value="Month" <cfif Perc.DetailMode eq "Month">checked</cfif>> Month
			</td>
			<td class="labelmedium" style="padding-left:6px">
			<input onclick="javascript:showdetails('#Scale.ScaleNo#','#ComponentName#','#pt#')" type="radio" name="#Com#_DetailMode_#pt#" value="Amount" <cfif Perc.DetailMode eq "Amount">checked</cfif>> Amount
			</td>
			</tr>
			</table>

		</td>		
				
		<td>
		<select name="#Com#_CalculationBasePeriod_#pt#" class="regularxl">
		<option value="Current" <cfif Perc.CalculationBasePeriod eq "Current">selected</cfif>>Current</option>
		<option value="Prior" <cfif Perc.CalculationBasePeriod eq "Prior">selected</cfif>>Prior</option>
		</select>
		
		</td>
			
	    </TR>

		<cfif Perc.EntitlementRecurrent eq "0">
			<tr><td></td><td colspan="6" class="labelmedium"><b>Special calculation routine</b></td></tr>
		</cfif>
	
	</cfloop> 

</cfoutput>	

</table>