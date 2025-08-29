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
	<cfset dateValue = "">
	<CF_DateConvert Value="#Form.SalaryEffective#">
	<cfset eff   = dateValue>
		
	<cfset dateValue = "">
	<CF_DateConvert Value="#Form.SalaryFirstApplied#">
	<cfset first = dateValue>
		
	<cfset scalenumber = form.scaleNo>	
	
	<cfif URL.Effective eq "">
		   
	   <!--- new rates --->
	   
	   <cfquery name="Check"
			datasource="AppsPayroll" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
		     SELECT * 
			 FROM   SalaryScale
		     WHERE  SalarySchedule  = '#URL.Schedule#'
		      AND   Mission         = '#URL.Mission#'
		      AND   ServiceLocation = '#URL.Location#'
			  AND   SalaryEffective   = #eff#
	   </cfquery>
			
	   <cfif Check.recordcount eq "0">
	   
	   	    <!--- ADD A NEW SCALE --->
			
			<cftransaction>
	   	
			<cfquery name="Scale"
			datasource="AppsPayroll" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			    INSERT INTO SalaryScale
				   	(SalarySchedule, 
					 Mission, 
					 ServiceLocation, 
					 SalaryEffective, 
					 SalaryFirstApplied,
					 OfficerUserid, 
					 OfficerLastName, 
					 OfficerFirstName)
				 SELECT DISTINCT 
				        SalarySchedule, 
						Mission, 
						ServiceLocation, 
						#Eff#,
						#First#,
						'#SESSION.acc#',
						'#SESSION.last#',
						'#SESSION.first#'
			     FROM   SalaryScale
			     WHERE  SalarySchedule  = '#URL.Schedule#'
			      AND   Mission         = '#URL.Mission#'
			      AND   ServiceLocation = '#URL.Location#'
		    </cfquery>
			
			<!--- prior --->
			
			<cfquery name="NewScale"
			datasource="AppsPayroll" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			    SELECT TOP 1 * 
				FROM  SalaryScale
				ORDER BY ScaleNo DESC			
		    </cfquery>
			
			<cfset scalenumber = NewScale.ScaleNo>
			
			<!--- copy details --->
			
			<cfquery name="Scale"
			datasource="AppsPayroll" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			    INSERT INTO SalaryScalePercentage
						(ScaleNo, 
						 ComponentName, 
						 EntitlementPointer, 
						 Percentage, 
						 CalculationBase, 
						 CalculationBaseFinal, 
						 CalculationBasePeriod, 
						 DetailMode,OfficerUserId,OfficerLastName,OfficerFirstName)
						 
				SELECT  '#NewScale.ScaleNo#', 
					     ComponentName, 
					     EntitlementPointer, 
					     Percentage, 
					     CalculationBase, 
					     CalculationBaseFinal, 
					     CalculationBasePeriod, 
					     DetailMode,'#SESSION.acc#','#SESSION.last#','#SESSION.first#'
				FROM     SalaryScalePercentage 
				WHERE    ScaleNo = '#form.scaleNo#'		   
		    </cfquery>
			
			<!--- copy details as well --->
			
			<cfquery name="ScaleDetails"
			datasource="AppsPayroll" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			    INSERT INTO SalaryScalePercentageDetail
					(ScaleNo, 
					 ComponentName, 
					 EntitlementPointer, 
					 DetailValue, 
					 Percentage)
				SELECT '#NewScale.ScaleNo#', 
					 ComponentName, 
					 EntitlementPointer, 
					 DetailValue,
					 Percentage
				FROM SalaryScalePercentageDetail 
				WHERE ScaleNo = '#form.scaleNo#'			   
		    </cfquery>
			
			</cftransaction>
						
	  </cfif>
	  						
	</cfif>	
	
	<cfquery name="update"
			datasource="AppsPayroll" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
		     UPDATE SalaryScale
			 SET    SalaryFirstApplied = #first# 
		     WHERE  ScaleNo            = '#form.scaleNo#'		     
   </cfquery>
	
	<cfif url.mode eq "Percentage">
			
		<!--- percentages --->
		
		<cfquery name="Percentage"
		datasource="AppsPayroll" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		    SELECT *
			FROM   SalaryScaleComponent C,
				   Ref_PayrollComponent Com,
				   Ref_PayrollTrigger T
			WHERE  C.ScaleNo          = '#form.scaleNo#'
			AND    C.Period           = 'PERCENT'
			AND    Com.Code           = C.ComponentName
			AND    T.SalaryTrigger    = Com.SalaryTrigger
		</cfquery>
		
		<cfquery name="Clear"
				datasource="AppsPayroll" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
			    DELETE FROM SalaryScalePercentage
			    WHERE  ScaleNo    = '#ScaleNumber#'	
				AND    ComponentName NOT IN (SELECT ComponentName
									    	 FROM   SalaryScaleComponent C,
											        Ref_PayrollComponent Com,
												    Ref_PayrollTrigger T
										     WHERE  Com.Code = C.ComponentName
											 AND    T.SalaryTrigger   = Com.SalaryTrigger
											 AND    C.ScaleNo  = '#Form.ScaleNo#'
											 AND    C.Period = 'PERCENT' 		
										 )	
		</cfquery>
	
		<cfloop query="Percentage">
		
			<cfif TriggerConditionPointer neq "">
			   <cfset pointer = "#TriggerConditionPointer#">
			<cfelse>
			   <cfset pointer = "0">
			</cfif>
			
			<cfloop index="pt" list="#pointer#" delimiters=","> 
		
		        <cfset com = "#replace(ComponentName,' ','','ALL')#">
				<cfset com = "#replace(com,'-','','ALL')#">
				<cfset com = "#replace(com,'.','','ALL')#">
		
				<cfparam name="Form.#Com#_CalculationBase_#pt#" default="Net">
				<cfparam name="Form.#Com#_CalculationBaseFinal_#pt#" default="Net">
				<cfparam name="Form.#Com#_Percentage_#pt#" default="0">  
				<cfparam name="Form.#Com#_DetailMode_#pt#" default="0">  
				<cfparam name="Form.#Com#_CorrectionTrigger_#pt#" default="">
				<cfparam name="Form.#Com#_CorrectionPayrollItem_#pt#" default="">
				<cfparam name="Form.#Com#_CalculationBasePeriod_#pt#" default="">
				<cfparam name="Form.#Com#_SettleUntilPeriod_#pt#" default="">
				
				<cfset CalculationBase       =   Evaluate("Form.#Com#_CalculationBase_#pt#")>
				<cfset CalculationBaseFinal  =   Evaluate("Form.#Com#_CalculationBaseFinal_#pt#")>
				<cfset percentage            =   Evaluate("Form.#Com#_Percentage_#pt#")>
				<cfset detailmode            =   Evaluate("Form.#Com#_DetailMode_#pt#")>
				<cfset CorrectionTrigger     =   Evaluate("Form.#Com#_CorrectionTrigger_#pt#")>
				<cfset CorrectionPayrollItem =   Evaluate("Form.#Com#_CorrectionPayrollItem_#pt#")>
				<cfset CalculationBasePeriod =   Evaluate("Form.#Com#_CalculationBasePeriod_#pt#")>
				
				<cfquery name="Check"
						datasource="AppsPayroll" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">
						SELECT * 
						FROM   SalaryScalePercentage
						WHERE  ScaleNo            = '#scalenumber#'
						AND    ComponentName      = '#ComponentName#'
						AND    EntitlementPointer = '#pt#'	
				</cfquery>		
				
				<cfif DetailMode eq "hour">				
					<cfset percentage = percentage / (21.75 * 8)>				
				</cfif>
				
				<cfif check.recordcount eq "0">			
							
					<cfquery name="Percentage"
							datasource="AppsPayroll" 
							username="#SESSION.login#" 
							password="#SESSION.dbpw#">
							INSERT INTO SalaryScalePercentage
								(ScaleNo, 
								 ComponentName, 
								 EntitlementPointer,
								 Percentage, 
								 CalculationBase, 
								 CalculationBaseFinal,
								 DetailMode,
								 CalculationBasePeriod,
								 OfficerUserId,
								 OfficerLastName,
								 OfficerFirstName)
							VALUES
								('#scalenumber#',
								 '#ComponentName#',
								 '#pt#',
								 '#Percentage#',
								 '#CalculationBase#',
								 '#CalculationBaseFinal#',
								 '#DetailMode#',
								 '#CalculationBasePeriod#',
								 '#SESSION.acc#',
								 '#SESSION.last#',
								 '#SESSION.first#')
					</cfquery>
				
				<cfelse>
				
					<cfquery name="Check"
							datasource="AppsPayroll" 
							username="#SESSION.login#" 
							password="#SESSION.dbpw#">
						    UPDATE  SalaryScalePercentage
						    SET     Percentage            = '#Percentage#',
							        CalculationBase       = '#CalculationBase#',
								    CalculationBaseFinal  = '#CalculationBaseFinal#',
								    DetailMode            = '#DetailMode#',
								    CalculationBasePeriod = '#CalculationBasePeriod#'				
						    WHERE   ScaleNo               = '#scalenumber#'
						    AND     ComponentName         = '#ComponentName#'
						    AND     EntitlementPointer    = '#pt#'	
					</cfquery>	
							
				</cfif>
					   
				</cfloop>	   
						
		</cfloop>
	
	<cfelseif url.mode eq "Rate">
	
	    <!--- flat  rates --->
		
		<cfquery name="Schedule"
		datasource="AppsPayroll" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		    SELECT *
			FROM SalarySchedule
			WHERE SalarySchedule = '#URL.Schedule#'
		</cfquery>
			
		<cfquery name="Component"
			datasource="AppsPayroll" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			    SELECT *
				FROM   SalaryScaleComponent
				WHERE  Period != 'Percent' 
				AND    RateStep = '9'
				AND    ScaleNo = '#Form.ScaleNo#'
				ORDER BY ListingOrder 
			</cfquery>
		
		<!--- define scales --->	
		
		<cfquery name="Grade"
			datasource="AppsPayroll" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
	    	SELECT *
			FROM   SalaryScheduleServiceLevel P, 
			       Employee.dbo.Ref_PostGrade R
			WHERE  P.ServiceLevel = R.PostGrade		
			AND    P.SalarySchedule = '#url.schedule#'			
			ORDER BY R.PostOrder
		</cfquery>
		
		<cfquery name="Delete"
			datasource="AppsPayroll" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">			
				DELETE FROM SalaryScaleLine
				WHERE  ScaleNo       = '#Form.ScaleNo#'
				AND    ServiceLevel NOT IN (SELECT ServiceLevel 
				                            FROM   SalaryScheduleServiceLevel
											WHERE  SalarySchedule = '#url.schedule#'	
											AND    Operational = 1)	
				
		 </cfquery>
	
		<cfoutput query="Grade">
				
		    <cfset grd   = PostGrade> 
			<cfset steps = PostGradeSteps> 
			
			<cfset gr = "#replace(PostGrade,'-','')#">
			<cfset gr = "#replace(gr,' ','')#">	
			
			<cfset no = scalenumber>
				
			<!--- define steps --->
			
			<cfloop query="Component">
			
				<cfloop index="st" from="1" to="#steps#" step="1">	
				
					<!--- define component --->
						
					  <cfset cp = "#replace(ComponentName,' ','','ALL')#">
					  <cfset cp = "#replace(cp,'-','','ALL')#">
					  
					  <cfparam name="Form.#cp#"     default="0">
					  <cfparam name="Form.#cp#_old" default="0">
					  
					  <cfset curr      =  evaluate("Form.currency_#cp#")>
					  <cfset curr_old =   Evaluate("Form.currency_#cp#_old")>
									  
					  <cfset amt     =   Evaluate("Form.Amount_#cp#")>
					  <cfset amt_old =   Evaluate("Form.Amount_#cp#_old")>
					 					  
					  <cfset amt = Replace(amt, ",", "","ALL")>
					  
					  <cfif amt eq "">
					      <cfset amt = 0>
					  </cfif>
					 						 		  
					  <cfif amt neq amt_old or curr neq curr_old>
					  
					  	 <cfquery name="Delete"
							datasource="AppsPayroll" 
							username="#SESSION.login#" 
							password="#SESSION.dbpw#">
								DELETE FROM SalaryScaleLine
								WHERE  ScaleNo       = '#No#'
								AND    ServiceLevel  = '#grd#'
								AND    ServiceStep   = '<cfif st lt 10>0</cfif>#st#'
								AND    ComponentName = '#ComponentName#'
						 </cfquery>
						 
						 <cfif amt neq "0">
					  		  		  		
							 <cfquery name="Scale"
								datasource="AppsPayroll" 
								username="#SESSION.login#" 
								password="#SESSION.dbpw#">
								INSERT INTO SalaryScaleLine
									(ScaleNo,
									 SalarySchedule, 
									 ServiceLevel, 
									 ServiceStep, 
									 ComponentName, 
									 Currency, 
									 Amount)
								VALUES
									('#No#',
									 '#URL.Schedule#',
									 '#grd#',
									 '<cfif st lt 10>0</cfif>#st#',
									 '#ComponentName#',
									 '#curr#',
									 '#amt#')
							  </cfquery>
						  
						  </cfif>
					  
					   </cfif>
								  							
				</cfloop>
			
			</cfloop>			
		
		</cfoutput>
	
		
	<cfelse>
		
		<!--- component grade/step rates --->
		
		<cfquery name="Schedule"
		datasource="AppsPayroll" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		    SELECT *
			FROM SalarySchedule
			WHERE SalarySchedule = '#URL.Schedule#'
		</cfquery>
			
		<cfquery name="Component"
			datasource="AppsPayroll" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
		    SELECT   *
			FROM     SalaryScaleComponent
			WHERE    Period != 'Percent' and RateStep NOT IN ('9','8')
			AND      ScaleNo = '#Form.ScaleNo#'
			AND      RateComponentName is NULL
			ORDER BY ListingOrder 
		</cfquery>
		
		<!--- define scales --->	
		
		<cfquery name="Grade"
			datasource="AppsPayroll" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
	    	SELECT *
			FROM   SalaryScheduleServiceLevel P, 
			       Employee.dbo.Ref_PostGrade R
			WHERE  P.ServiceLevel = R.PostGrade		
			AND    P.SalarySchedule = '#url.schedule#'
			AND    P.Operational = 1
			ORDER BY R.PostOrder
		</cfquery>
		
		<cfquery name="Delete"
			datasource="AppsPayroll" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">			
				DELETE FROM SalaryScaleLine
				WHERE  ScaleNo       = '#Form.ScaleNo#'
				AND    ServiceLevel NOT IN (SELECT ServiceLevel 
				                            FROM   SalaryScheduleServiceLevel
											WHERE  SalarySchedule = '#url.schedule#'	
											AND    Operational = 1)	
				
		 </cfquery>
	
		<cfoutput query="Grade">
				
		    <cfset grd   = PostGrade> 
			<cfset steps = PostGradeSteps> 
			
			<cfset gr = "#replace(PostGrade,'-','')#">
			<cfset gr = "#replace(gr,' ','')#">	
			
			<cfset no = scalenumber>
				
			<!--- define steps --->
			
			<cfloop query="Component">
			
				<cfloop index="st" from="1" to="#steps#" step="1">	
				
					<!--- define component --->
						
					  <cfset cp = "#replace(ComponentName,' ','','ALL')#">
					  <cfset cp = "#replace(cp,'-','','ALL')#">
					  
					  <cfparam name="Form.#gr#_#st#_#cp#"     default="0">
					  <cfparam name="Form.#gr#_#st#_#cp#_old" default="0">
					  
					  <cfset curr      =  evaluate("Form.currency_#cp#")>
					  <cfset curr_old =   Evaluate("Form.currency_#cp#_old")>
									  
					  <cfset amt     =   Evaluate("Form.#gr#_#st#_#cp#")>
					  <cfset amt_old =   Evaluate("Form.#gr#_#st#_#cp#_old")>
					  
					  <!--- carry over to all steps --->
					  <cfif (amt eq "" or amt eq "0") and st gt "1">
					    <cfset amt = Evaluate("Form.#gr#_1_#cp#")>
					  </cfif>
					  
					  <cfset amt = Replace(amt, ",", "","ALL")>
					  
					  <cfif amt eq "">
					      <cfset amt = 0>
					  </cfif>
					 						 		  
					  <cfif amt neq amt_old or curr neq curr_old>
					  
					  		<cfquery name="Delete"
							datasource="AppsPayroll" 
							username="#SESSION.login#" 
							password="#SESSION.dbpw#">
							DELETE FROM SalaryScaleLine
							WHERE  ScaleNo       = '#No#'
							AND    ServiceLevel  = '#grd#'
							AND    ServiceStep   = '<cfif st lt 10>0</cfif>#st#'
							AND    ComponentName = '#ComponentName#'
						 </cfquery>
						 											 
						 <cfif amt neq "0" and LSIsNumeric(amt)>
					  		  		  		
							 <cfquery name="Scale"
								datasource="AppsPayroll" 
								username="#SESSION.login#" 
								password="#SESSION.dbpw#">
								INSERT INTO SalaryScaleLine
									(ScaleNo,
									 SalarySchedule, 
									 ServiceLevel, 
									 ServiceStep, 
									 ComponentName, 
									 Currency, 
									 Amount)
								VALUES
									('#No#',
									 '#URL.Schedule#',
									 '#grd#',
									 '<cfif st lt 10>0</cfif>#st#',
									 '#ComponentName#',
									 '#curr#',
									 '#amt#')
							  </cfquery>
						  
						  </cfif>
					  
					   </cfif>
								  							
				</cfloop>
			
			</cfloop>			
		
		</cfoutput>
		
		<cfquery name="Inherit"
			datasource="AppsPayroll" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
		    SELECT   *
			FROM     SalaryScaleComponent
			WHERE    Period != 'Percent' and RateStep != '9'
			AND      ScaleNo = '#Form.ScaleNo#'
			AND      RateComponentName is NOT NULL 
		</cfquery>
		
		<cfloop query="Inherit">
		
			<cfquery name="Delete"
				datasource="AppsPayroll" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				DELETE FROM SalaryScaleLine
				WHERE  ScaleNo       = '#No#'							
				AND    ComponentName = '#ComponentName#'
			</cfquery>
		
			<cfquery name="Insert"
				datasource="AppsPayroll" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				INSERT INTO SalaryScaleLine 
				        (ScaleNo, ServiceLevel, ServiceStep, SalarySchedule, ComponentName,Currency,Amount)
						
				SELECT  ScaleNo, 
				        ServiceLevel, 
						ServiceStep,
						SalarySchedule,
						'#ComponentName#',
						Currency,
						ROUND((SUM(Amount)*#RatePercentage#)/100,3)
						
				FROM     SalaryScaleLine
				
				WHERE    ScaleNo       = '#Form.ScaleNo#' 
				
				AND      ComponentName IN (SELECT  R.Code
										   FROM    Ref_CalculationBaseItem I INNER JOIN Ref_PayrollComponent R ON I.PayrollItem = R.PayrollItem
										   WHERE   I.Code           = '#RateComponentName#' 
										   AND     I.SalarySchedule = '#URL.Schedule#' 
										   AND     R.Period IN ('Year'))			
				
				GROUP BY ScaleNo, 
				         ServiceLevel, 
						 ServiceStep,
						 SalarySchedule,
						 Currency
						 
						 
			</cfquery>		
		
		</cfloop>
		
	</cfif>	
		
<cfoutput>
		
	<script language="JavaScript">
	   	window.location = "RateEdit.cfm?Effective=#DateFormat(eff, client.DateSQL)#&Schedule=#URL.Schedule#&Mission=#URL.Mission#&Location=#URL.Location#&mode=#url.mode#&operational=#url.operational#"
	</script>
	
</cfoutput>
