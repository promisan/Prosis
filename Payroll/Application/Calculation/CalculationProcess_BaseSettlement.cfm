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
<!--- 
1. initialize settlement data  clean settlement made beyond the next due payment month 
--->

<!--- define the first OPEN month --->
<cfquery name="FirstOpenMonth" 
	datasource="AppsPayroll" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT TOP 1 PayrollEnd
		FROM     SalarySchedulePeriod
		WHERE    Mission            = '#Form.Mission#'
	    AND      SalarySchedule     = '#Form.Schedule#'		
		<cfif settlement eq "Initial">
		AND      CalculationStatus IN ('0','1')     <!--- for initial a '2' is not pending but closed, so it will go to the next month --->
		<cfelse>					
	    AND      CalculationStatus IN ('0','1','2')	<!--- the first month which is pending --->						
		</cfif>
		AND      PayrollStart >= #SALSTR#							
		ORDER BY PayrollEnd 
</cfquery>	

<!--- reset all settlements for this and future months of this schedule --->

<cfif FirstOpenMonth.recordcount gte "1">

	<!--- we ONLY clear full settlement record with all its line if the person is no longer present in
	the organization but only for in-cycle events  ---> 
							
	<cfquery name="ClearFullSettlement" 
		datasource="AppsPayroll" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		
			DELETE EmployeeSettlement
			FROM   EmployeeSettlement S
			WHERE  Mission        = '#Form.Mission#'
			AND    SalarySchedule = '#Form.Schedule#'	
			
			<!--- 29/8/2018 only IN CYCLE records to be removed, for now we keep off-cycle always alive until we know more --->	
			AND    PaymentStatus  = '0'  	
			
			<cfif processmodality eq "InCycleBatch">
			   <!--- we exclude records which have to be 
			    cleared (actionstatus=0) in the workflow for settlement first usually these are final payment --->
				AND    PersonNo NOT IN (#preservesingleQuotes(selper)#)			
			<cfelse>	
			    AND    PersonNo = '#Form.PersonNo#'	
			</cfif>	  	
			
			<!--- 20/10/2019 : new provision to NOT delete a settlement which has been associated to another schedule which
			has been locked already --->
			
			AND  NOT EXISTS (SELECT 'X' 
			                 FROM   SalarySchedulePeriod
			                 WHERE  Mission           = S.Mission
							 AND    SalarySchedule    = S.SettlementSchedule
							 AND    PayrollEnd        = S.PaymentDate
							 AND    CalculationStatus = '3')		
										
						
			<!--- settlement is not created through a workflow like Final payment and it has a workflow, then we leave it alone --->									
			AND    NOT EXISTS (SELECT 'X'
			                   FROM   Organization.dbo.OrganizationObject
							   WHERE  ObjectKeyValue4 = S.SettlementId
							   AND    Operational = 1)							
			
			<!--- Only remove records for which we do not detect any presence in todays contract/assignment combination or
			   if the settlement is for a draft period --->
			   
			AND   (
			
			      PaymentDate > '#firstOpenMonth.PayrollEnd#' <!--- august is the open month we can savely clear September --->
				  
				  <!--- below is no longer needed : can be removed anytime 
				  								  
					
					<cfif settleinitialmode eq "0" or settlement eq "Initial">
						<cfset op = ">=">	
					<cfelse>
					    <!--- we don't want to miss with already recorded settlement records for this month, we focus on the delta later on to balance matters --->
						<cfset op = ">">
					</cfif>		
				  
				  PaymentDate > #op# '#firstMonth.PayrollEnd#'
				  
				  OR  
			
					<!--- this is to remove settlements recorded for staff under a month for which in the
					current contract legs he / she is no longer working, otherwise these would remain 
					as its amount would no longer be considered for calcuation to be corrected in the next
					run. Dev:  I am not sure if this is a good idea to remove at the moment I write this comment.
					--->
						
				  		( PersonNo NOT IN (SELECT PersonNo FROM userTransaction.dbo.sal#SESSION.thisprocess#Payroll) 	
						    AND PaymentDate = #SALSTR#')		
							
					--->		
							
				  )										   
											
	</cfquery>	
	
	  <!--- The above query clears the IN cycle settlements after the CURRENT settlement month
		
	   However we  DO want to remove information of CURRENT settlement month on the settlementline level as we re-process each month	   
	   but only if this does not relate to retro information which has been generated for this settlement month from
	   a prior month of calculation compared to the current iteration of the calcualtion with the SALSTR month --->		
	
	<cfquery name="CleanSettlementLine" 
		datasource="AppsPayroll" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
				
			DELETE EmployeeSettlementLine
			FROM   EmployeeSettlement AS S INNER JOIN
                   EmployeeSettlementLine AS SL ON S.PersonNo = SL.PersonNo AND S.Mission = SL.Mission AND S.SalarySchedule = SL.SalarySchedule AND 
                   S.PaymentDate = SL.PaymentDate AND S.PaymentStatus = SL.PaymentStatus
			
			WHERE  S.Mission        = '#Form.Mission#'			
			AND    S.SalarySchedule = '#Form.Schedule#'	
									
					<!--- we only make sure we remove records in the OPEN month for records generated for the open month. 
					No longer we remove retro-active reocrds which will have an earlier PayrollEnd 				
										
					remove records from the first open month equal to the select, so this moves to 09 if 09 is
					calculated even though 08 = open as well 
					
					Attention: CHECK this for the mode of having 2 payment cycles like Fomtex and STA 
					
					--->
			
			AND		
					(
					
					<!--- settlements for entitlements of the CURRENT month = open month --->
					
					PayrollEnd = ( SELECT   TOP 1 PayrollEnd
			                       FROM     SalarySchedulePeriod
								   WHERE    Mission            = '#Form.Mission#'
								   AND      SalarySchedule     = '#Form.Schedule#'							
								   AND      CalculationStatus  = '2'							
								   AND      PayrollStart >= #SALSTR#							
								   ORDER BY PayrollEnd	)
								   
					     OR
					 
					   <!--- settlements for the inline calculation month that settle in the open month --->
					 
						 ( PayrollStart = #SALSTR# AND S.PaymentDate = (SELECT   TOP 1 PayrollEnd
												                        FROM     SalarySchedulePeriod
															  	        WHERE    Mission            = '#Form.Mission#'
																	    AND      SalarySchedule     = '#Form.Schedule#'							
																	    AND      CalculationStatus  = '2'							
																	    AND      PayrollStart >= #SALSTR#							
																	    ORDER BY PayrollEnd )   																	  
						  ) 				   
					 
					 
					 )										  
			
			
			<!--- 20/10/2019 : new provision to NOT delete a settlement which has been associated to another schedule which
			has been locked already --->
			
			AND  NOT EXISTS (SELECT 'X' 
			                 FROM   SalarySchedulePeriod
			                 WHERE  Mission           = S.Mission
							 AND    SalarySchedule    = S.SettlementSchedule
							 AND    PayrollEnd        = S.PaymentDate
							 AND    CalculationStatus = '3')		
							 					  			  									 
			<!--- remove only final settlement record FOR THIS CALCULATION --->					
			<cfif settlement eq "Initial">
				<!--- we remove all records : initial and final --->
			<cfelseif settlement eq "Final">						 		
			AND    SettlementPhase = 'Final'  <!--- note : keep in mind that if intial is not relevant records will have 'final' and will thus be removed --->
			</cfif>		
			
			<cfif wffinal eq "1">					
			
				AND    PersonNo = '#Form.PersonNo#'		
				
				<!--- we can remove in- and off cycle here --->					
				
			<cfelse>
			
				<cfif Form.PersonNo neq "">			
				AND    S.PersonNo = '#Form.PersonNo#'									
				<cfelse>	
				<!--- this is the IN-CYCLE batch process that is running staff with pending settlement actionstatus = 0 or off-cycle settlement actionstatus = 3 --->			
				AND    S.PersonNo NOT IN (#preservesingleQuotes(selper)#)													
				</cfif>
				
				AND    S.PaymentStatus = '0'  <!--- 29/8/2018 only IN CYCLE --->
				
				<!--- ------------------------------------------------------------------------------------------------ --->
				<!--- 24/8/2018 we are not clearing records that were generated and prepared for IN-CYCLE under
				a workflow (like Final Payment)                                                                        --->  
				<!--- ------------------------------------------------------------------------------------------------ --->			
						
				AND   NOT EXISTS (SELECT 'X'
				                  FROM   EmployeeSettlement ES INNER JOIN Organization.dbo.OrganizationObject ON ObjectKeyValue4  = ES.SettlementId
								  AND    Operational       = 1
								  AND    ES.Mission        = S.Mission 
								  AND    ES.SalarySchedule = S.SalarySchedule 
								  AND    ES.PersonNo       = S.PersonNo 
								  AND    ES.PaymentDate    = S.PaymentDate  )					   																		
				<!--- ------------------------------------------------------------------------------------------------ --->		
				
			</cfif>	
			
	</cfquery>
	
</cfif>