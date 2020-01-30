

<cfparam name="url.salaryschedule" default="">

<table cellspacing="0" ccellpadding="0">
		
	<cfquery name="Ent" 
	datasource="AppsPayroll" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT    *
		FROM      Ref_PayrollTrigger
		
		WHERE     EnableContract IN ('1','2')
		
		AND       Operational = 1
		
		AND       SalaryTrigger IN (SELECT SalaryTrigger
		                            FROM   Ref_PayrollTriggerContractType
									WHERE  ContractType = '#url.contracttype#'
									AND    Operational = 1)
									
		AND       SalaryTrigger IN (
		                            SELECT  RC.SalaryTrigger
									FROM    SalaryScheduleComponent SC INNER JOIN
					                        Ref_PayrollComponent RC ON SC.ComponentName = RC.Code
									WHERE   SC.SalarySchedule = '#url.salarySchedule#'
									)  							
	</cfquery>
	
	<cfif Ent.recordcount eq "0">
	
		<cfquery name="Ent" 
		datasource="AppsPayroll" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT    *
			FROM      Ref_PayrollTrigger
			WHERE     EnableContract IN ('1','2')
			AND       Operational = 1			
			AND       SalaryTrigger IN (SELECT  RC.SalaryTrigger
									    FROM    SalaryScheduleComponent SC INNER JOIN
					                            Ref_PayrollComponent RC ON SC.ComponentName = RC.Code
									    WHERE   SC.SalarySchedule = '#url.salarySchedule#'
									    )  								
		</cfquery>		
	
	</cfif>
			
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
					
		<cfif cnt eq "1">			
		<TR>
		</cfif>
		
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
											
				<INPUT type="radio" name="#SalaryTrigger#" value="0" <cfif CheckPrior.recordcount eq "0">checked</cfif>> No
				<INPUT type="radio" name="#SalaryTrigger#" value="1" <cfif CheckPrior.recordcount gt "0">checked</cfif>> #tYes#
				
			</TD>
			
		<cfif cnt eq "2">
		<cfset cnt = "0">
		</tr>
		</cfif>
			
	</cfoutput>
	
</table>