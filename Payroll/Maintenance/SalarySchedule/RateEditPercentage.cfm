
<table width="97%" align="center" cellspacing="0" cellpadding="0" class="navigation_table">

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

<tr class="line labelmedium fixrow">
    
	<TD align="left"><cf_tl id="Component"></TD>
	<TD align="left" style="padding-right:5px"><cf_tl id="Condition"></TD>
	<TD align="left" style="padding-left:7px"><cf_tl id="Percentage mode"></TD>
	<TD align="left"><cf_tl id="Percentage"></TD>	
	<td align="left" style="padding-left:7px"><cf_tl id="Calculation base"></td>
	<td align="left" style="padding-left:7px"><cf_tl id="Calculation base Final"></td>	
	<TD align="left" style="padding-left:7px"><cf_tl id="Base Month"></TD>
	<!---
	<TD align="left">Settle Until</TD>
	--->
  
</TR>

<cfset prior = "">

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
		    SELECT P.ScaleNo, 
			       P.ComponentName, P.EntitlementPointer, cast(Percentage as Decimal(14,8)) as Percentage,
			       P.CalculationBase,
				   P.calculationBaseFinal, 
				   P.CalculationBasePeriod, 
				   P.DetailMode, 
				   P.OfficerUserId, P.OfficerLastName, P.OfficerFirstName,
				   S.EntitlementRecurrent
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
	   
		<TR bgcolor="white" class="labelmedium line navigation_row">
		
			<cfset com = "#replace(ComponentName,' ','','ALL')#">
			<cfset com = "#replace(com,'-','','ALL')#">
			<cfset com = "#replace(com,'.','','ALL')#">
			
			<TD style="height:18px;padding-left:4px;width:25%"><cfif prior neq description>#Description#<cfelse>&nbsp;&nbsp;,,</cfif></TD>
			
			<TD style="height:18px;padding-right:7px">#TriggerCondition#<cfif TriggerConditionPointer neq "">/#pt#</cfif></TD>
					
			<td>	
			
			<table width="100%">
			 <tr>
			 <td style="width:12px;padding-top:1px;border-left:1px solid silver;">
			  
			   <cfif Perc.DetailMode neq "Default">
			   			  
			    <cf_img icon="open" 
			    onclick="javascript:showdetails('#Scale.ScaleNo#','#ComponentName#','#pt#',document.getElementById('#Com#_DetailMode_#pt#').value)">
				
				
			   </cfif>
			   
			 </td>
			   
			 <td style="width:99%;padding-left:2px;padding-right:5px;">
			
			   <select class="regularxl" style="border:0px;width:99%;background-color:transparent" name="#Com#_DetailMode_#pt#" id="#Com#_DetailMode_#pt#"
			          onchange="javascript:showdetails('#Scale.ScaleNo#','#ComponentName#','#pt#',this.value)">
					  
				   <option value="Default" <cfif Perc.DetailMode eq "Default">selected</cfif>>Flat percentage</option>
				   <option value="Hour"    <cfif Perc.DetailMode eq "Hour">selected</cfif>>Calc Hour:21.75*8</option>
				   <option value="Month"   <cfif Perc.DetailMode eq "Month">selected</cfif>>Per calendar month</option>
				   <option value="Amount"  <cfif Perc.DetailMode eq "Amount">selected</cfif>>Per calculated amount</option>
				   <option value="Group"   <cfif Perc.DetailMode eq "Group">selected</cfif>>Per entitlement group</option>
				   
			   </select>
			   
			 </td>
			 </tr>			
			 </table>
					  
			</td>	
			
			<cfif Perc.DetailMode eq "default">
				<cfset cl = "regular">
			<cfelse>
				<cfset cl = "hide">
			</cfif>
			
			<TD>
			
				<table width="100%">
					<tr id="percent_#componentname#" class="#cl#" style="height:20px">
					<td align="right" style="width:100%;padding-right:3px;border-left:1px solid silver;">
					
					   <cfif Perc.DetailMode eq "hour">
					   
						   	<cfset mul = 21.75 * 8>
						   
						   	 <cfinput type="Text" 
							    name="#Com#_Percentage_#pt#" 
								value="#numberformat(Perc.Percentage*mul,'.____')#" 
								validate="float" 
								class="regularxl" 
								required="No" 
								visible="Yes" 
								enabled="Yes" 
								size="10" 
								maxlength="14" 
								style="text-align:right;border:0px;padding-right:3px">
					   
					   <cfelse>				   
								
						    <cfinput type="Text" 
							    name="#Com#_Percentage_#pt#" 
								value="#numberformat(Perc.Percentage,'.____')#" 
								validate="float" 
								class="regularxl" 
								required="No" 
								visible="Yes" 
								enabled="Yes" 
								size="10" 
								maxlength="14" 
								style="text-align:right;border:0px;padding-right:3px">
						
					   </cfif>	
											
			 		</td>
					<td style="width:10px;padding-right:3px">%</td>
					</tr>
				</table>
			 
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
			
			<TD align="right" style="padding-right:2px;border-left:1px solid silver;">
			
				<select style="width:98%;border:0px;background-color:transparent" name="#Com#_CalculationBase_#pt#" class="regularxl">
				 <cfloop query="Base">
				<option value="#Code#" <cfif Perc.CalculationBase eq "#Code#">selected</cfif>>#Description#</option>
				</cfloop>
				</select>
			
			</TD>
			
			<TD align="right" style="padding-right:2px;border-left:1px solid silver;">
			
				<select style="width:98%;border:0px;background-color:transparent" name="#Com#_CalculationBaseFinal_#pt#" class="regularxl">
				 <cfloop query="Base">
				<option value="#Code#" <cfif Perc.CalculationBaseFinal eq "#Code#">selected</cfif>>#Description#</option>
				</cfloop>
				</select>
				
			</TD>
				
			<td style="padding-right:2px;border-left:1px solid silver;padding-left:10px">
			
				<select name="#Com#_CalculationBasePeriod_#pt#" class="regularxl" style="border:0px;width:80px;background-color:transparent">
					<option value="Current" <cfif Perc.CalculationBasePeriod eq "Current">selected</cfif>>Current</option>
					<option value="Prior" <cfif Perc.CalculationBasePeriod eq "Prior">selected</cfif>>Prior</option>
				</select>		
				
			</td>
			
	    </TR>

		<cfif Perc.EntitlementRecurrent eq "0">
			<tr><td></td><td colspan="6" class="labelmedium"><b>Special calculation routine</b></td></tr>
		</cfif>
		
		<cfset prior = description>
	
	</cfloop> 
		
</cfoutput>	

</table>