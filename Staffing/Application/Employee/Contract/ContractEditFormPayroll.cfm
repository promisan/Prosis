
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
						
	AND       SalaryTrigger IN (
		                        SELECT  RC.SalaryTrigger
								FROM    SalaryScheduleComponent SC INNER JOIN
					                    Ref_PayrollComponent RC ON SC.ComponentName = RC.Code
								WHERE   SC.SalarySchedule IN ('#contractsel.salarySchedule#','#url.salaryschedule#')
								)  		
																	
								
</cfquery>

<table width="100%">

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
						
				<td bgcolor="f1f1f1" class="labelmedium ccell" style="min-width:233;padding-right:3px">							
				<cfif Check.recordcount eq "0">--<cfelse><cf_tl id="Yes"></cfif>
				</td>
				
			</cfif>
		 			 		
	 		<cfif mode eq "edit" or last eq "1">    
						
				<td bgcolor="#color#" id="editfield" style="min-width:300;width:100%;padding-left:6px;" name="editfield" class="ccell labelmedium">		
				
				    <cfif ContractSel.actionStatus eq "1">
															
					   <!--- new record --->
					  
					   <table>
					    <tr class="labelmedium">
							<td style="padding-left:3px">				  			   
						    <INPUT type="radio" name="#SalaryTrigger#" value="0" <cfif Check.recordcount eq "0">checked</cfif>> 					
							</td>
							<td style="padding-left:4px"><cf_tl id="No"></td>					
							<td style="padding-left:8px">
							<INPUT type="radio" name="#SalaryTrigger#" value="1" <cfif Check.recordcount gt "0">checked</cfif>>
							</td>
							<td style="padding-left:4px"><cf_tl id="Yes"></td>
						</tr>
						</table>
					   
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
							<INPUT type="radio" name="#SalaryTrigger#" value="0" <cfif getSelected.recordcount eq "0">checked</cfif>> 
							</td>
							<td style="padding-left:4px"><cf_tl id="No"></td>					
							<td style="padding-left:8px">
							<INPUT type="radio" name="#SalaryTrigger#" value="1" <cfif getSelected.recordcount gt "0">checked</cfif>>
							</td>
							<td style="padding-left:4px"><cf_tl id="Yes"></td>
							</tr>
						</table>
					
				   </cfif>					   
				</td>							
			</cfif>			
		</TD>
	</TR>

</cfoutput>

</table>

<script>


</script>
