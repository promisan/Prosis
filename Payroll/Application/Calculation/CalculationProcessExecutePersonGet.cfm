
<cfinvoke component = "Service.Process.Employee.PersonnelAction"
	    Method          = "getEOD"
	    PersonNo        = "#url.id#"
		Mission         = "#url.mission#"
		Type            = "last"
	    ReturnVariable  = "EOD">	
				
				
<cfswitch expression="#url.action#">
	
	<cfcase value="EOD">
		
		<!-- <cfform> -->
		
		<cfquery name="getMission" 
				datasource="AppsPayroll" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">				
		 		SELECT    MIN(DateEffective) as Date
		 		FROM      SalaryScheduleMission
		 		WHERE     Mission        = '#url.mission#'			 					 				 				 			
		</cfquery>
		
		<cfoutput>
			
			<cfquery name="getEOD" 
				datasource="AppsEmployee" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">				
			      SELECT  DateEffective as EODDate	
				  FROM    PersonContract					 
				  WHERE   PersonNo 	= '#url.id#'
				  AND     Mission 	= '#url.Mission#' 					 				  			
				  AND     ActionCode IN
					             (SELECT   ActionCode
					              FROM     Ref_Action
				                  WHERE    ActionSource = 'Contract' 
							      AND      ActionInitial = '1') 
	     		  AND     ActionStatus != '9'					  
				  ORDER BY DateEffective DESC
			 </cfquery>	  
			 			 
			 <cfset dte = dateformat(getMission.Date,client.dateformatshow)>
			 
			 <cfset start = "0">	
			
			<select name="dateEffective" id="dateEffective" class="regularxl">
			
				<cfif getEOD.recordcount eq "0">
										
						<option value="#dte#">#dateformat(getMission.date,client.dateformatshow)#</option>
							
				<cfelse>
				
					<cfloop query="getEOD">
					
					        <cfif EODDate gt getMission.date>	
							
								<option value="#dateformat(EODDate,client.dateformatshow)#" <cfif recordcount eq "1">selected</cfif>>#dateformat(EODDate,client.dateformatshow)#</option>
							
							<cfelse>
							
							    													
								<cfif start eq "0">
									<option value="#dte#" <cfif recordcount eq "1">selected</cfif>>#dateformat(getMission.date,client.dateformatshow)#</option>
									<cfset start = "1">
								</cfif>
								
							</cfif>				
					
					</cfloop>	
						
				</cfif>					
									
			</select>
			
		</cfoutput>				
		
		<cfset ajaxonload("doCalendar")>	
	
	<!-- </cfform>-->
	
	</cfcase>
	
	<cfcase value="Schedule">
		
	 <cfquery name="ScheduleList" 
		datasource="AppsEmployee" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT   SalarySchedule, MAX(DateExpiration) as DateLast
		FROM     PersonContract
		WHERE    PersonNo     = '#url.id#'	
		AND      Mission      = '#url.mission#'					
		AND      RecordStatus = '1'		
		GROUP BY SalarySchedule
		ORDER BY MAX(DateExpiration) DESC
   </cfquery>		
   	
	<table>
	<cfoutput query="schedulelist">
	<tr class="labelmedium">
	
	<td style="font-size:16px">#SalarySchedule#</td>	
	<td style="padding-top:3px;padding-left:4px;font-size:13px">last expiry : #dateformat(DateLast,client.dateformatshow)#</td>
			
	</tr>		
	</cfoutput>
	</tr></table>	
     	
	</cfcase>
	
	<cfcase value="period">
					
		 <cfquery name="ScheduleList" 
			datasource="AppsEmployee" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			SELECT   SalarySchedule, MAX(DateExpiration) as DateLast
			FROM     PersonContract
			WHERE    PersonNo     = '#url.id#'	
			AND      Mission      = '#url.mission#'					
			AND      RecordStatus = '1'		
			AND      SalarySchedule IN (SELECT SalarySchedule 
			                            FROM Payroll.dbo.SalarySchedule 
										WHERE Operational = 1)
			GROUP BY SalarySchedule
			ORDER BY MAX(DateExpiration) DESC
	   </cfquery>		
	   
	   <cfquery name="getMission" 
			datasource="AppsPayroll" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">				
		 		SELECT    MIN(DateEffective) as Date
		 		FROM      SalaryScheduleMission
		 		WHERE     Mission        = '#url.mission#'			 					 				 				 			
		</cfquery>
		
		<cfinvoke component = "Service.Process.Employee.PersonnelAction"
	    Method          = "getEOD"
	    PersonNo        = "#url.id#"
		Mission         = "#url.mission#"
		Type            = "first"
	    ReturnVariable  = "firstEOD">	
   
		<cfquery name="getPeriod" 
			datasource="AppsPayroll" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">				
		 		SELECT    RIGHT('00'+CAST(MONTH(PayrollStart) AS VARCHAR(2)),2) as SelMonth,
				          YEAR(PayrollStart) as SelYear, 						  
						  PayrollStart
		 		FROM      SalarySchedulePeriod
		 		WHERE     Mission        = '#url.mission#'			 					 				 		
		 		AND       PayrollEnd     >= '#firstEOD#'
				AND       SalarySchedule = '#ScheduleList.SalarySchedule#'
				AND       CalculationStatus IN ('1','2','3')	   		 		
		 		GROUP BY  RIGHT('00'+CAST(Month(PayrollStart) AS VARCHAR(2)),2) , YEAR(PayrollStart) , PayrollStart
					ORDER BY  YEAR(PayrollStart) DESC, 
				          Month(PayrollStart) DESC 					
		</cfquery>
		
		<cfoutput>
		 <select name="customPeriodStart" id="customPeriodStart" 
		     class="regularxl" style="width:100px" onchange="ptoken.navigate('#session.root#/payroll/application/calculation/CalculationProcessExecutePersonGo.cfm?id=#url.id#','progressbox')">
		 	<cfloop query="getPeriod">
		 		<OPTION style="<cfif payrollstart gt schedulelist.datelast>background-color:d8d8d8</cfif>" value="01/#selMonth#/#SelYear#" <cfif currentrow eq "1">selected</cfif>>#selMonth#-#SelYear#</OPTION>
		 	</cfloop>
		</select>
		</cfoutput>
		
	</cfcase>
	
	<cfcase value="enforce">
	
		<cfquery name="Last" 
		datasource="AppsEmployee" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT   MAX(DateExpiration) as DateLast
			FROM     PersonContract
			WHERE    PersonNo     = '#url.id#'	
			AND      Mission      = '#url.mission#'					
			AND      RecordStatus = '1'				
	   </cfquery>	
	   
	   <cfif Last.DateLast lt now()>
	   
	      <script>
		     document.getElementById('enforce').className     = "labelmedium"
			 document.getElementById('forcesettlement').value = '0'
	      </script>
	   
	      <cfoutput>
	      <input type="checkbox" 
		  	  id="force" 
			  value="1" 
			  class="radiol" 
			  onclick="if (this.checked) {document.getElementById('forcesettlement').value = '1'} else {document.getElementById('forcesettlement').value = '0'};ptoken.navigate('#session.root#/payroll/application/calculation/CalculationProcessExecutePersonGo.cfm?id=#url.id#','progressbox')">
	      </cfoutput>
		  
	   <cfelse>
	   		  	   
	      <script>
		     document.getElementById('enforce').className     = "hide"
			 document.getElementById('forcesettlement').value = '0'
	      </script>
	   
	   </cfif>
		
	</cfcase>

</cfswitch>