
<cfparam name="url.Last" default="1">
<cfparam name="url.mode" default="edit">

<cfparam name="Mode" default="#url.mode#">
<cfparam name="Last" default="#url.last#">

<cfquery name="ContractSel" 
	datasource="AppsEmployee" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
    SELECT   *
    FROM     PersonContract
	WHERE    PersonNo   = '#URL.ID#'
	AND      ContractId = '#URL.ID1#' 
</cfquery>

<!--- we show triggers based on the prior and selected value --->

<cfquery name="check" 
datasource="AppsPayroll" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT SalaryTrigger
	FROM   Ref_PayrollTriggerContractType	
	WHERE  Operational = 1
</cfquery>	

<cfquery name="Currency" 
datasource="AppsLedger"
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
    FROM Currency
</cfquery>

<cfquery name="Ent" 
datasource="AppsPayroll" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT    *
	FROM      Ref_PayrollTrigger
	WHERE     EnableContract IN ('1','2')
	AND       Operational    = 1
	AND       TriggerGroup != 'Contract'
	<cfif check.recordcount gt "0">
	AND       SalaryTrigger IN (SELECT SalaryTrigger
			                    FROM   Ref_PayrollTriggerContractType
								WHERE  ContractType = '#url.contracttype#'
								AND    Operational = 1)
	</cfif>							
	
							
	AND    (  SalaryTrigger IN (
		                        SELECT  RC.SalaryTrigger
								FROM    SalaryScheduleComponent SC INNER JOIN
					                    Ref_PayrollComponent RC ON SC.ComponentName = RC.Code
								WHERE   SC.SalarySchedule IN ('#contractsel.salarySchedule#','#url.salaryschedule#'))
								  		
			OR 
			
			<!--- added to have personalised entry on the level of the contract as well --->
			(EntitlementClass = 'Amount' AND SalaryTrigger IN (SELECT  RC.SalaryTrigger FROM Ref_PayrollComponent RC ))
			
			)	
			
					
																	
								
</cfquery>

<table width="100%" class="formpadding">

<cfoutput query="Ent">
	
	<cfquery name="Check" 
	datasource="AppsPayroll" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT    *
		FROM      PersonEntitlement
		WHERE     PersonNo      = '#url.id#'
		AND       ContractId    = '#URL.ID1#'
		AND       SalaryTrigger = '#SalaryTrigger#'
	</cfquery>	
				
	<tr id="editfield" name="editfield">
		
	    <TD style="padding-left:5px;min-width:300px" class="labelmedium bcell">#Description#:</TD>
	  							
			<cfif mode eq "view">
				
				<cfif entitlementClass neq "Amount">		
					<td bgcolor="EDFDB5" class="labelmedium2 ccell" style="min-width:233;padding-left:5px;padding-right:3px">							
					<cfif Check.recordcount eq "0">--<cfelse><cf_tl id="Yes"></cfif>
					</td>
				<cfelse>
					<td bgcolor="EDFDB5" class="labelmedium2 ccell" style="min-width:233;padding-left:5px;padding-right:3px">	
					<cfif Check.recordcount eq "0">--<cfelse><cf_tl id="Yes">
					#check.currency# #numberformat(check.amount,",.__")# (#check.Period#)
					</cfif>
					</td>
				
				</cfif>
				
			</cfif>
		 			 		
	 		<cfif mode eq "edit" or last eq "1">    
						
				<td bgcolor="#color#" id="editfield" style="min-width:300;width:100%;padding-left:6px;" name="editfield" class="ccell labelmedium">		
				
				    <!---
				    <cfif ContractSel.actionStatus eq "1">
					--->
															
					   <!--- new record --->
					   
					   <cfif entitlementClass neq "Amount">
					  
						   <table>
						    <tr class="labelmedium">
								<td style="padding-left:3px">				  			   
							    <INPUT type="radio" class="radiol" name="#SalaryTrigger#" value="0" <cfif Check.recordcount eq "0">checked</cfif>> 					
								</td>
								<td style="padding-left:4px"><cf_tl id="No"></td>					
								<td style="padding-left:8px">
								<INPUT type="radio" class="radiol" name="#SalaryTrigger#" value="1" <cfif Check.recordcount gt "0">checked</cfif>>
								</td>
								<td style="padding-left:4px"><cf_tl id="Yes"></td>
							</tr>
							</table>
						
						<cfelse>
						
							<cfquery name="getItem" 
							datasource="AppsPayroll" 
							username="#SESSION.login#" 
							password="#SESSION.dbpw#">
								SELECT    *
								FROM      Ref_PayrollComponent
								WHERE     SalaryTrigger = '#SalaryTrigger#'
							</cfquery>	
						
							<table><tr>
							<td style="padding-left:3px">	
							
							  	<select name="#SalaryTrigger#_Currency" style="border:0px" size="1" class="regularxxl">
									<cfloop query="Currency">
										<option value="#Currency#" <cfif Check.currency eq Currency or currency eq application.basecurrency>selected</cfif>>#Currency#</option>
									</cfloop>
							    </select>
							
							<td>
								<INPUT type="hidden" class="regularxxl" name="#SalaryTrigger#_PayrollItem" value="#getItem.PayrollItem#">
							</td>	
																			
							</td>
							<td style="padding-left:8px">
								<INPUT type="text" class="regularxxl" name="#SalaryTrigger#_Amount" style="width:120px;padding-right:4px;border:0px;border-left:1px solid silver;border-right:1px solid silver;text-align:right" value="#Check.Amount#">
							</td>
							<td style="padding-left:8px">
							
								<select name="Period" class="regularxxl" style="width:99%;border:0px">
									 <option value="DAY"     <cfif Check.Period eq "DAY">selected</cfif>><cf_tl id="Daily"></option>
									 <option value="WORKDAY" <cfif Check.Period eq "WORKDAY">selected</cfif>><cf_tl id="Workdays"></option>
									 <option value="MONTHF"  <cfif Check.Period eq "MONTHF">selected</cfif>><cf_tl id="Month">: fixed</option>
									 <option value="MONTH"   <cfif Check.Period eq "MONTH" or check.Period eq "">selected</cfif>><cf_tl id="Month"></option>
									 <option value="MONTHN"  <cfif Check.Period eq "MONTHN">selected</cfif>><cf_tl id="Month"> -/- slwop</option>
									 <option value="MONTHW"  <cfif Check.Period eq "MONTHW">selected</cfif>><cf_tl id="Month"> -/- [slwop + suspend]</option>			 
								</select>
							</td>
							
							</tr></table>						
						
						</cfif>
						
					<!---	
					   
				   <cfelse>
				   			   			   
					   <cfquery name="getSelected" 
						datasource="AppsPayroll" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">
							SELECT    *
							FROM      PersonEntitlement
							WHERE     PersonNo       = '#URL.ID#'
							-- AND       SalarySchedule = '#ContractSel.SalarySchedule#'
							AND       ContractId     = '#URL.ID1#'
							AND       SalaryTrigger  = '#SalaryTrigger#'												
						</cfquery>
						
					  	<table>
							<tr class="labelmedium"><td style="padding-left:3px">				  									
							<INPUT type="radio" class="radiol" name="#SalaryTrigger#" value="0" <cfif getSelected.recordcount eq "0">checked</cfif>> 
							</td>
							<td style="padding-left:4px"><cf_tl id="No"></td>					
							<td style="padding-left:8px">
							<INPUT type="radio" class="radiol" name="#SalaryTrigger#" value="1" <cfif getSelected.recordcount gt "0">checked</cfif>>
							</td>
							<td style="padding-left:4px"><cf_tl id="Yes"></td>
							</tr>
						</table>
					
				   </cfif>		
				   
				   --->
				   			   
				</td>							
			</cfif>			
		</TD>
	</TR>

</cfoutput>

</table>

<script>


</script>
