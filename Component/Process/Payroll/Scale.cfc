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
<!---  Name: /Component/Process/Procurement/PurchaseLine.cfc
       Description: Purchase Line procedures      
---> 

<cfcomponent>

    <cfproperty name="name" type="string">
    <cfset this.name = "Payroll Routines">
	
	<cffunction name="setScaleComponent"
             access="public"
             returntype="string"
             displayname="getCommission">
		
		<cfargument name="scaleNo"     type="string" required="true"   default="">	
		<cfargument name="Force"       type="string" required="true"  default="No">					
		
		<cfquery name="Scale"
		datasource="AppsPayroll" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		    SELECT *
			FROM   SalaryScale
			WHERE ScaleNo = '#ScaleNo#'		
		</cfquery>
		
		<cfif scale.recordcount eq "1">
		
			<cfquery name="ScaleComponent"
			datasource="AppsPayroll" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			    SELECT *
				FROM   SalaryScaleComponent
				WHERE ScaleNo = '#ScaleNo#'		
			</cfquery>
			
			<cfif scalecomponent.recordcount eq "0" or force eq "Yes">
			
					<cftransaction>					
								
					<cfquery name="ScaleComponent"
					datasource="AppsPayroll" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
					    DELETE FROM SalaryScaleComponent
						WHERE ScaleNo = '#ScaleNo#'		
					</cfquery>
					
					<cfquery name="Add"
					datasource="AppsPayroll" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
						INSERT INTO SalaryScaleComponent
	                             (ScaleNo, 
								  ComponentName,
								  ParentComponent, 
								  Source,
								  SalaryTrigger,  
								  TriggerGroup, 
								  TriggerCondition,
								  TriggerConditionPointer, 
								  TriggerDependent,
								  EntitlementClass, 
								  EntitlementGrade,
								  EntitlementGradePointer,
								  EnableContract,
								  
								  PayrollItem, 
								  
								  RateComponentName,
								  RatePercentage,
								  
								  EntitlementGroup, 
								  EntitlementPriority,
								  EntitlementPointer, 
								  EntitlementBirthDay, 
								  EntitlementRecurrent,
								  SalaryMultiplier, 
								  Period, 
								  SalaryDays,
								  RateStep,
								  SettleUntilPeriod, 
								  ListingOrder,
								  OfficerUserId,
								  OfficerLastName,
								  OfficerFirstName)
								  
						SELECT   '#ScaleNo#',
						          S.ComponentName,
								  C.ParentComponent,
								  I.Source,
						          R.SalaryTrigger,  
								  R.TriggerGroup, 
								  R.TriggerCondition,
								  R.TriggerConditionPointer, 
								  R.TriggerDependent,
								  C.EntitlementClass, 
								  C.EntitlementGrade,
								  C.EntitlementGradePointer,
								  R.EnableContract,				  
						          
								  S.PayrollItem, 
								  
								  (SELECT TOP 1 RateComponentName
								  FROM   SalaryScheduleComponentRate
								  WHERE  SalarySchedule = '#Scale.SalarySchedule#'
								  AND    ComponentName = C.Code) as RateComponentName,
								  
								  (SELECT TOP 1 RatePercentage
								  FROM   SalaryScheduleComponentRate
								  WHERE  SalarySchedule = '#Scale.SalarySchedule#'
								  AND    ComponentName = C.Code) as RatePercentage,
								  
								  S.EntitlementGroup, 
								  G.EntitlementPriority,
								  S.EntitlementPointer, 
								  S.EntitlementBirthDay, 
								  S.EntitlementRecurrent,
								  S.SalaryMultiplier, 
								  S.Period, 
								  S.SalaryDays,								  
								  S.RateStep,
								  S.SettleUntilPeriod, 
								  S.ListingOrder,
								  '#session.acc#',
								  '#session.last#',
								  '#session.first#'
						FROM      SalaryScheduleComponent S INNER JOIN
								  Ref_PayrollComponent C ON S.ComponentName = C.Code INNER JOIN
				                  Ref_PayrollTrigger R ON C.SalaryTrigger = R.SalaryTrigger	INNER JOIN
								  Ref_PayrollTriggerGroup G ON R.SalaryTrigger = G.SalaryTrigger AND C.EntitlementGroup = G.EntitlementGroup INNER JOIN
								  Ref_PayrollItem I ON S.PayrollItem = I.PayrollItem			
						WHERE     SalarySchedule = '#Scale.SalarySchedule#'
						AND       (
						           EXISTS (SELECT 'X' 
						                   FROM   SalaryScheduleComponentLocation
										   WHERE  SalarySchedule = '#Scale.SalarySchedule#'
										   AND    ComponentName  = S.ComponentName
										   AND    LocationCode   = '#scale.servicelocation#')
										   
									OR
									
								    NOT EXISTS (SELECT 'X' 
						                        FROM   SalaryScheduleComponentLocation
										        WHERE  SalarySchedule = '#Scale.SalarySchedule#'
										        AND    ComponentName  = S.ComponentName)
								  )						   
					
					</cfquery>
					
					
										
					
					</cftransaction>
							
			</cfif>
								
		 </cfif>
		 
   </cffunction>		
	
</cfcomponent>	 