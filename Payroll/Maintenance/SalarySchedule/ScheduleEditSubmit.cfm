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

<cf_wait Text="Saving schedule components">

<cftransaction>

<cfif ParameterExists(Form.Delete)>

	<cfquery name="Delete"
	  datasource="AppsPayroll" 
	  username="#SESSION.login#" 
	  password="#SESSION.dbpw#">
	     DELETE FROM Ref_CalculationBaseItem
		 WHERE  SalarySchedule  = '#URL.ID1#'		
	</cfquery>
	
	<cfquery name="Delete"
	  datasource="AppsPayroll" 
	  username="#SESSION.login#" 
	  password="#SESSION.dbpw#">
	     DELETE FROM PersonEntitlement
		 WHERE  SalarySchedule  = '#URL.ID1#'		
	</cfquery>
	 
	<cfquery name="Delete"
	  datasource="AppsPayroll" 
	  username="#SESSION.login#" 
	  password="#SESSION.dbpw#">
	     DELETE FROM SalarySchedule
		 WHERE  SalarySchedule  = '#URL.ID1#'		
	</cfquery>

</cfif>
		
<cfparam name="form.operational" default="0">			
<cfparam name="form.selectedgrade" default="">		

<cfif ParameterExists(Form.Update)> 
		  
	<cfquery name="Update"
	  datasource="AppsPayroll" 
	  username="#SESSION.login#" 
	  password="#SESSION.dbpw#">
	     UPDATE SalarySchedule
		 SET    Description            = '#Form.Description#',
		        ProcessMode            = '#Form.ProcessMode#',
		 		SalaryBasePeriodDays   = '#Form.SalaryBasePeriodDays#', 	
				SalaryBasePeriodMode   = '#Form.SalaryBasePeriodMode#', 					
				SalaryBaseRate         = '#Form.SalaryBaseRate#',  
				PaymentCurrency        = '#Form.Currency#',
				EnforceProgram         = '#Form.EnforceProgram#',
				IncumbencyZero         = '#Form.IncumbencyZero#',				
				PaymentRounding        = '#Form.PaymentRounding#',
				Operational            = '#Form.Operational#',
				ListingOrder           = '#Form.ListingOrder#',
				SettleOtherSchedules   = '#Form.SettleOtherSchedules#',
				SalaryBasePayrollItem  = '#Form.SalaryBasePayrollItem#',
				PaySlipMailText        = '#Form.PaySlipMailText#' 	
		 WHERE  SalarySchedule         = '#URL.ID1#'
	</cfquery>
	
	<!--- mission --->
		
	<cfquery name="MissionSelect" 
		datasource="AppsPayroll" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT DISTINCT Mission
		FROM   Organization.dbo.Ref_MissionModule
		WHERE  SystemModule = 'Payroll' 
	</cfquery>	
	
	<cfloop query="MissionSelect">

   	    <cfparam name="Form.mission_#currentrow#"     			default="0">
		<cfparam name="Form.orgunit_#currentrow#"     			default="0">
		<cfparam name="Form.disableDistribution_#currentrow#"   default="0">
		<cfparam name="Form.DistributionMode_#currentrow#"      default="0">
		<cfparam name="Form.journal_#currentrow#"     			default="">
		<cfparam name="Form.PostingMode_#currentrow#" 			default="Schedule">
	
		<cfset mis = evaluate("form.mission_#currentrow#")>
		<cfset eff = evaluate("form.dateeffective_#currentrow#")>
		<cfset jou = evaluate("form.journal_#currentrow#")>
		<cfset gla = evaluate("form.glaccount_#currentrow#")>
		<cfset mde = evaluate("form.PostingMode_#currentrow#")>
		<cfset org = evaluate("form.orgunit_#currentrow#")>
		<cfset dist = evaluate("form.disableDistribution_#currentrow#")>
		<cfset db  = evaluate("form.DistributionMode_#currentrow#")>
		
		<cfif mis eq "0">
		
			<cfquery name="MissionSelect" 
			datasource="AppsPayroll" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				DELETE FROM SalaryScheduleMission
				WHERE  Mission        = '#mission#' 
				AND    SalarySchedule = '#url.id1#'
			</cfquery>			
		
		<cfelse>
		
			<cfquery name="MissionSelect" 
			datasource="AppsPayroll" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				SELECT * FROM SalaryScheduleMission
				WHERE Mission = '#mission#' 
				and   SalarySchedule = '#url.id1#'
			</cfquery>		
						
			<cfset dateValue = "">
			<CF_DateConvert Value="#eff#">
			<cfset dte = dateValue>
			
			<cfif MissionSelect.recordcount eq "0">
			
				<cfquery name="Insert" 
				datasource="AppsPayroll" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
					INSERT INTO SalaryScheduleMission
					(SalarySchedule,Mission,Journal,GLAccount,DisableDistribution,DistributionMode,OrgUnit,PostingMode,DateEffective,OfficerUserId,OfficerLastName,OfficerFirstName)
					VALUES
					('#url.id1#',
					 '#mission#',
					 '#jou#',
					 '#gla#',
					 '#dist#',
					 '#db#',
					 '#org#',
					 '#mde#',
					 #dte#,'#SESSION.acc#','#SESSION.last#','#SESSION.first#')
				</cfquery>	
			
			<cfelse>	
			
				<cfquery name="MissionSelect" 
				datasource="AppsPayroll" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
					UPDATE SalaryScheduleMission
					SET    DateEffective       = #dte#, 
					       GLAccount           = <cfif gla eq "">null<cfelse>'#gla#'</cfif>, 
						   Journal             = '#jou#',
						   OrgUnit             = '#org#',
						   PostingMode         = '#mde#',
						   DisableDistribution = '#dist#',
						   DistributionMode    = '#db#'
					WHERE  Mission             = '#mission#' 
					AND    SalarySchedule      = '#url.id1#' 
				</cfquery>				
			
			</cfif>
			
		</cfif>
	
	</cfloop>
	
	<!--- grade --->
	
	<cfquery name="Update" 
		datasource="AppsPayroll" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			UPDATE SalaryScheduleServiceLevel
			SET    Operational    = 0
			WHERE  SalarySchedule = '#URL.ID1#'		
	</cfquery>
	
	<cfloop index="Item" list="#Form.SelectedGrade#" delimiters=",">
		
		<cfquery name="Check" 
		datasource="AppsPayroll" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT * 
			FROM SalaryScheduleServiceLevel		
			WHERE  SalarySchedule = '#URL.ID1#'		
			AND    ServiceLevel = '#Item#'
		</cfquery>
		
		<cfif check.recordcount eq "1">
		
			<cfquery name="Update" 
			datasource="AppsPayroll" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				UPDATE SalaryScheduleServiceLevel
				SET    Operational    = 1
				WHERE  SalarySchedule = '#URL.ID1#'		
				AND  ServiceLevel = '#Item#'
			</cfquery>
		
		<cfelse>
				
			<cfquery name="InsertGrade" 
			datasource="AppsPayroll" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				INSERT INTO SalaryScheduleServiceLevel
				       (SalarySchedule,
						 ServiceLevel,
						 Operational,
						 OfficerUserId,
						 OfficerLastName,
						 OfficerFirstName)
			  	VALUES ('#URL.ID1#',
				        '#Item#', 
						1,
						'#SESSION.acc#',
				    	'#SESSION.last#',		  
					  	'#SESSION.first#')
			</cfquery>
		
		</cfif>
		
	</cfloop>
	
<!--- percentages --->

<cfquery name="Component"
	datasource="AppsPayroll" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
    SELECT R.*
    FROM   Ref_PayrollTrigger T INNER JOIN
	       Ref_PayrollComponent R ON T.SalaryTrigger = R.SalaryTrigger 	 
</cfquery>

<cfoutput query="Component">

    <cfset com = "#replace(Code,' ','','ALL')#">'
	<cfset com = "#replace(com,'-','','ALL')#">
	
	<cfparam name="Form.value_#com#" default="">
	<cfparam name="Form.select_#com#" default="">
	<cfparam name="Form.SettleUntilPeriod_#com#" default="current">
						 
	<cfset cde    = Evaluate("Form.value_#Com#")>
	<cfset sel    = Evaluate("Form.select_#Com#")>
	<cfset Settle = Evaluate("Form.SettleUntilPeriod_#com#")>
				
	<cfif cde neq "">
					
		<cfif sel eq "">
		
			<cfquery name="Component"
			datasource="AppsPayroll" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			    DELETE FROM SalaryScheduleComponent 
				WHERE  SalarySchedule = '#URL.ID1#'  
				AND    ComponentName = '#Cde#'
			</cfquery>
		
		<!--- delete --->
		
		<cfelse>			
		
			<cfquery name="Check"
			datasource="AppsPayroll" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			    SELECT * 
				FROM   SalaryScheduleComponent 
				WHERE  SalarySchedule = '#URL.ID1#' 
				AND    ComponentName = '#Cde#' 
			</cfquery>
		
			<cfif Check.recordcount eq "0">
			
				<cfquery name="Component"
					datasource="AppsPayroll" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
															
				    INSERT INTO SalaryScheduleComponent 
							(SalarySchedule, 
							 ComponentName, 
							 EntitlementPointer, 
							 EntitlementGroup,
							 SalaryMultiplier, 			
							 PayrollItem,
							 Period, 
							 RateStep, 
							 SalaryDays,							 
							 ListingOrder, 
							 SettleUntilPeriod, 
							 OfficerUserId, 
							 OfficerLastName, 
							 OfficerFirstName)
					SELECT  '#URL.ID1#', 
					         Code, 
						     EntitlementPointer, 
						     EntitlementGroup,
						     SalaryMultiplier, 
						     PayrollItem,
						     Period, 
						     RateStep, 
						     SalaryDays,						    
						     ListingOrder, 
						     '#settle#', 
						     '#SESSION.acc#',
						     '#SESSION.last#', 
						     '#SESSION.first#'
					FROM     Ref_PayrollComponent 	   
					WHERE    Code = '#cde#'
				</cfquery>
				
			</cfif>	
				
			<!--- check if locations are selected --->
			
			<cfparam name="form.locationvisible_#com#" default="">
					
			<cfset loc = Evaluate("Form.locationvisible_#Com#")>
									
			<cfif loc neq "">
			
				<cfquery name="Component"
					datasource="AppsPayroll" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
				    DELETE FROM SalaryScheduleComponentLocation 
					WHERE SalarySchedule = '#URL.ID1#' and ComponentName = '#cde#' 
				</cfquery>		
				
				<cfparam name="Form.location_#Com#" default="">
					
				<cfset locs = Evaluate("Form.location_#Com#")>	
															
				<cfloop index="itm" list="#locs#">				
				
					<cfquery name="Component"
						datasource="AppsPayroll" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">
				    	INSERT INTO SalaryScheduleComponentLocation 
								(SalarySchedule, 
								 ComponentName, 
								 LocationCode, 							
								 OfficerUserId, 
								 OfficerLastName, 
								 OfficerFirstName)
						VALUES ('#URL.ID1#','#cde#','#itm#','#SESSION.acc#','#SESSION.last#','#SESSION.first#')					
					</cfquery>				
				
				</cfloop>
				
				<cfquery name="Component"
					datasource="AppsPayroll" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
				    DELETE FROM SalaryScheduleComponentRate 
					WHERE SalarySchedule = '#URL.ID1#' and ComponentName = '#cde#' 
				</cfquery>		
				
				<!--- optionally record the rate --->
				
				<cfparam name="form.ratecomponent_#com#" 	default="">
				<cfparam name="form.ratepercentage_#Com#" 	default="">
				
				<cfset rate = Evaluate("Form.ratecomponent_#Com#")>	
				<cfset perc = Evaluate("Form.ratepercentage_#Com#")>
				
				<cfif rate neq "" and isvalid("numeric",perc)>
				
					<cfquery name="Component"
						datasource="AppsPayroll" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">
				    	INSERT INTO SalaryScheduleComponentRate 
								(SalarySchedule, 
								 ComponentName, 
								 RateComponentName, 							
								 RatePercentage,
								 OfficerUserId, 
								 OfficerLastName, 
								 OfficerFirstName)
						VALUES ('#URL.ID1#','#cde#','#rate#','#perc#','#SESSION.acc#','#SESSION.last#','#SESSION.first#')					
					</cfquery>				
				
				</cfif>				
								
			<cfelse>
			
				<!--- nada --->
			
			</cfif>
			
		</cfif>
	
	</cfif>
		
</cfoutput>	

<!---- Work schedule days ---->
<cfloop index="i" from="1" to="7">
	
	<cfset workhours = Evaluate("Form.WorkHours_#i#")>
	
	<cfquery name="CheckSSWork" 
		datasource="AppsPayroll" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT * FROM SalaryScheduleWork
			WHERE  SalarySchedule = '#URL.ID1#'		
			AND    Weekday = '#i#'
	</cfquery>	
	
	<cfif CheckSSWork.recordcount eq 0>
		<cfquery name="InsertSSWork" 
			datasource="AppsPayroll" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			INSERT SalaryScheduleWork (SalarySchedule, Weekday, WorkHours)
			VALUES ('#URL.ID1#','#i#','#workhours#')
		</cfquery>	
	
	<cfelse>
	
		<cfquery name="UpdateSSWork" 
			datasource="AppsPayroll" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				UPDATE SalaryScheduleWork
				SET    WorkHours = '#workhours#'
				WHERE  SalarySchedule = '#URL.ID1#'		
				AND    Weekday = '#i#'
		</cfquery>	
	</cfif>	
</cfloop>

</cfif>

</cftransaction>

<script language="JavaScript">   
     parent.window.close()
	 parent.opener.history.go() 
</script>  

	

