

<cfparam name="url.salaryschedule" default="">

<table cellspacing="0" ccellpadding="0">

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
		
		AND       Operational = 1
		
		<cfif check.recordcount gt "0">
		AND       SalaryTrigger IN (SELECT SalaryTrigger
		                            FROM   Ref_PayrollTriggerContractType
									WHERE  ContractType = '#url.contracttype#'
									AND    Operational = 1)
		</cfif>							
									
		AND      ( SalaryTrigger IN (
		                            SELECT  RC.SalaryTrigger
									FROM    SalaryScheduleComponent SC INNER JOIN
					                        Ref_PayrollComponent RC ON SC.ComponentName = RC.Code
									WHERE   SC.SalarySchedule = '#url.salarySchedule#'
									)  	
									
			OR 
			
				<!--- added to have personalised entry on the level of the contract as well --->
				(EntitlementClass = 'Amount' AND SalaryTrigger IN (SELECT  RC.SalaryTrigger FROM Ref_PayrollComponent RC ))
			
			)														
	</cfquery>
					
	<cfquery name="LastContract" 
	datasource="AppsPayroll" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT   * 
		FROM     Employee.dbo.PersonContract
		WHERE    PersonNo     = '#URL.ID#' 
		AND      ActionStatus = '1'
		ORDER BY DateEffective desc
	</cfquery>
	
	<cf_tl id="YesShort" var="1">
	<cfset tYes = "#Lt_text#">
	
	<cfset cnt = "0">
		
	<cfif Ent.Recordcount eq "0">
	
	<tr class="labelmedium"><td><cf_tl id="Not applicable"></td></tr>
	
	</cfif>	
	
	<cfoutput query="Ent">		
	
		<cfset cnt = cnt+1>				
			
		<TR class="labelmedium2">
				
		    <TD height="20" style="padding-right:5px">				    
				<img src="#SESSION.root#/Images/pointer.gif" align="absmiddle" border="0">					
		    </TD>			    
			<td style="padding-left:4px;padding-right:17px" class="labelmedium">#Description#:</td>
			
			<TD style="padding-right:20px" class="labelmedium">	
			
			 <cfquery name="CheckPrior" 
				datasource="AppsPayroll" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
					SELECT    *
					FROM      PersonEntitlement
					WHERE     PersonNo      = '#URL.ID#'
					AND       SalaryTrigger = '#SalaryTrigger#'		
					<cfif LastContract.Recordcount neq 0>
						AND ContractId = '#LastContract.ContractId#'
					</cfif>					
			</cfquery>	
			
			<cfif entitlementClass neq "Amount">		  
											
				<INPUT type="radio" class="radiol" name="#SalaryTrigger#" value="0" <cfif CheckPrior.recordcount eq "0">checked</cfif>> No
				<INPUT type="radio" class="radiol" name="#SalaryTrigger#" value="1" <cfif CheckPrior.recordcount gt "0">checked</cfif>> #tYes#
				
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
							
							  	<select name="#SalaryTrigger#_Currency" size="1" class="regularxl">
									<cfloop query="Currency">
										<option value="#Currency#" <cfif CheckPrior.currency eq Currency or currency eq application.basecurrency>selected</cfif>>#Currency#</option>
									</cfloop>
							    </select>
							
							<td>
								<INPUT type="hidden" class="regularxl" name="#SalaryTrigger#_PayrollItem" value="#getItem.PayrollItem#">
							</td>	
																			
							</td>
							<td style="padding-left:4px">
								<INPUT type="text" class="regularxl" name="#SalaryTrigger#_Amount"
								     style="width:120px;padding-right:4px;text-align:right" 
									 value="#CheckPrior.Amount#">
							</td>
							<td style="padding-left:4px">
							
								<select name="#SalaryTrigger#_Period" class="regularxl" style="width:99%;">
									 <option value="MONTHW"  <cfif CheckPrior.Period eq "MONTHW" or CheckPrior.Period eq "">selected</cfif>><cf_tl id="Month"> -/- [slwop + suspend]</option>			 									
									 <option value="WORKDAY" <cfif CheckPrior.Period eq "WORKDAY">selected</cfif>><cf_tl id="Workdays"></option>
									 <option value="MONTHF"  <cfif CheckPrior.Period eq "MONTHF">selected</cfif>><cf_tl id="Month">: fixed</option>
									 <option value="MONTH"   <cfif CheckPrior.Period eq "MONTH">selected</cfif>><cf_tl id="Month"></option>
									 <option value="MONTHN"  <cfif CheckPrior.Period eq "MONTHN">selected</cfif>><cf_tl id="Month"> -/- slwop</option>
									 <option value="DAY"     <cfif CheckPrior.Period eq "DAY">selected</cfif>><cf_tl id="Daily"></option>
									
								</select>
							</td>
							
							</tr>
						</table>					 
			 
			 </cfif>	
				
			</TD>
			
		<cfif cnt eq "2">
		<cfset cnt = "0">
		</tr>
		</cfif>
			
	</cfoutput>
	
</table>