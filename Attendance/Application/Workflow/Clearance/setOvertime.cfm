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

<!--- apply the results of process for Werner to apply --->

<!--- steps : obtain the context of overtime = night different --->

<!--- first we check if the overtime has been recorded already and one of the records has a status = '5' which we 
then do not allow to process (unless ..... )

loop by person and record overtime + details + workflow --->

<cfquery name="get" 
	datasource="AppsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">		  
	  SELECT *
	  FROM   OrganizationAction
	  WHERE  OrgUnitActionid = '#Object.ObjectKeyValue4#'			
</cfquery>	

<cfquery name="param" 
	datasource="AppsEmployee" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">		  
	  SELECT *
	  FROM   Parameter	 		
</cfquery>

<cfset breakminutes = (Param.HoursInDay - Param.HoursWorkDefault) * 60>

<cfquery name="unit" 
	datasource="AppsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">		  
	  SELECT *
	  FROM   Organization
	  WHERE  OrgUnit = '#get.Orgunit#'			
</cfquery>	

<cfquery name="getPersons" 
	  datasource="AppsEmployee" 
	  username="#SESSION.login#" 
	  password="#SESSION.dbpw#">
	  
	  SELECT *, Postorder
	  FROM (
				SELECT 	DISTINCT P.PersonNo, 
				        P.LastName, 
						P.ListingOrder,
						P.FirstName, 
						A.FunctionDescription, 
						A.LocationCode,
						P.IndexNo, 
						A.AssignmentNo, 
						A.DateEffective, 
						A.DateExpiration,
						(SELECT   TOP 1 ContractLevel
						 FROM     PersonContract
						 WHERE    PersonNo     = P.PersonNo
						 AND      Mission      = Pos.Mission
						 AND      ActionStatus IN ('0','1')
						 AND      DateEffective <= '#get.CalendarDateEnd#'
						 ORDER BY DateEffective DESC) as PostGrade
				FROM 	Person P 
				        INNER JOIN PersonAssignment A ON P.PersonNo = A.PersonNo
						INNER JOIN Position Pos ON A.PositionNo = Pos.PositionNo
						
				WHERE   P.PersonNo = A.PersonNo
				<!--- the unit of the operational assignment --->
				AND     A.OrgUnit = '#get.Orgunit#'
				-- AND     A.Incumbency       > '0'
				AND     A.AssignmentStatus IN ('0','1')
				-- AND     A.AssignmentClass  = 'Regular'	<!--- not needed anymore as loaned people have leave as well --->		
				AND     A.AssignmentType   = 'Actual'
				AND     A.DateEffective   <= '#get.CalendarDateEnd#'
				AND     A.DateExpiration  >= '#get.CalendarDateStart#'
		
			) as P INNER JOIN Ref_PostGrade R ON P.PostGrade = R.PostGrade
					
		ORDER BY P.ListingOrder, R.PostOrder, P.LastName, P.DateEffective
					
</cfquery>	

<cfquery name="basedataset" 
	  datasource="AppsEmployee" 
	  username="#SESSION.login#" 
	  password="#SESSION.dbpw#">	
	  
		SELECT PersonNo,			 
			     BillingMode, 
			     BillingPayment,
			     ActivityPayment,
				 Modality,
				 SUM(Days) as Days,
				 SUM(Hours) as Hours,			 
				 SUM(OvertimePayroll) as OvertimePayroll
			 
	   FROM (		
	   
	   	  <!--- overtime --->		  
		  SELECT    PersonNo,
					CalendarDate,
		            BillingMode, 
		            BillingPayment,
		            0 as ActivityPayment,
					(CASE WHEN LeaveId is NULL THEN 'Work' ELSE 'Leave' END)               AS Modality,
		            SUM(CONVERT(float, HourSlotMinutes)) / (60 * #Param.HoursInDay#)       AS Days,					
					SUM(CONVERT(float, HourSlotMinutes)) / 60                              AS Hours,
					
					<!--- express overtime to be settled to a maximum --->
					
					 CASE WHEN BillingMode != 'Contract' 
					       THEN (CASE WHEN  SUM(CONVERT(float, HourSlotMinutes)) / 60 > #Param.HoursWorkDefault# 
								      THEN (SUM(CONVERT(float, HourSlotMinutes))-#breakminutes#) / 60  <!--- limit overtime --->
							 	      ELSE  SUM(CONVERT(float, HourSlotMinutes)) / 60 END) 
                           ELSE 0 END AS OvertimePayroll					
					
		  FROM      PersonWorkDetail W
		  
		  WHERE     PersonNo IN (#quotedValueList(getPersons.PersonNo)#)
		  AND       ActionClass IN (SELECT ActionClass
		                            FROM   Ref_WorkAction
        		                    WHERE  ActionParent = 'worked')
					
	      AND	    CalendarDate >= '#get.CalendarDateStart#' 
		  AND       CalendarDate <= '#get.CalendarDateEnd#'  	
		  AND       TransactionType     = '1'
		  AND       BillingMode != 'Contract'
		  
		  AND       W.PersonNo NOT IN (SELECT 'X'
		                               FROM  Payroll.dbo.PersonOvertime
									   WHERE PersonNo = W.PersonNo    
									   AND   Status = '5'
									   AND   Source = 'Schedule'
									   AND   SourceId = '#Object.ObjectKeyValue4#')
		  
		  GROUP BY  PersonNo,
		  			CalendarDate,
		  			(CASE WHEN LeaveId is NULL THEN 'Work' ELSE 'Leave' END),					
		            BillingMode, 
		            BillingPayment		
					
					
		  UNION ALL
		  
		  <!--- ND --->
		  
		  SELECT    PersonNo,
					CalendarDate,
		            'Contract', 
		            BillingPayment,
		            '1' as ActivityPayment,
					(CASE WHEN LeaveId is NULL THEN 'Work' ELSE 'Leave' END)               AS Modality,
		            SUM(CONVERT(float, HourSlotMinutes)) / (60 * #Param.HoursInDay#)       AS Days,					
					SUM(CONVERT(float, HourSlotMinutes)) / 60                              AS Hours,
					
					<!--- express overtime to be settled to a maximum --->
					
					 CASE WHEN BillingMode != 'Contract' 
					       THEN (CASE WHEN  SUM(CONVERT(float, HourSlotMinutes)) / 60 > #Param.HoursWorkDefault# 
								      THEN (SUM(CONVERT(float, HourSlotMinutes))-#breakminutes#) / 60  <!--- limit overtime --->
							 	      ELSE  SUM(CONVERT(float, HourSlotMinutes)) / 60 END) 
                           ELSE 0 END AS OvertimePayroll					
					
		  FROM      PersonWorkDetail W
		  
		  WHERE     PersonNo IN (#quotedValueList(getPersons.PersonNo)#)
		  AND       ActionClass IN (SELECT ActionClass
		                            FROM   Ref_WorkAction
        		                    WHERE  ActionParent = 'worked')
					
	      AND	    CalendarDate >= '#get.CalendarDateStart#' 
		  AND       CalendarDate <= '#get.CalendarDateEnd#'  	
		  AND       TransactionType     = '1'
		  AND       ActivityPayment     = '1'
		  
		  AND       W.PersonNo NOT IN (SELECT 'X'
		                               FROM  Payroll.dbo.PersonOvertime
									   WHERE PersonNo = W.PersonNo    
									   AND   Status = '5'
									   AND   Source = 'Schedule'
									   AND   SourceId = '#Object.ObjectKeyValue4#')
		  
		  GROUP BY  PersonNo,
		  			CalendarDate,
		  			(CASE WHEN LeaveId is NULL THEN 'Work' ELSE 'Leave' END),					
		            BillingMode, 
		            BillingPayment	
		  		
					
					
					) as D
					
		  GROUP BY 	PersonNo,		  			
		  			Modality,			
		            BillingMode, 
		            BillingPayment, 
					ActivityPayment			
					
									
				
</cfquery>  

<cfquery name="check" 
    datasource="AppsPayroll" 
    username="#SESSION.login#" 
    password="#SESSION.dbpw#">
		SELECT *
		FROM   PersonOvertime
		WHERE  SourceId = '#Object.ObjectKeyValue4#'
		AND    Status > '0'
</cfquery>	 

<cfif check.recordcount gte "1">

	<cf_tl id="Problem, it appears the records have been processed already for this closing">	
	<cfabort>
	
<cfelse>

		<cftransaction>
		
			<cfquery name="check" 
			    datasource="AppsPayroll" 
			    username="#SESSION.login#" 
			    password="#SESSION.dbpw#">
				DELETE FROM   PersonOvertime
				WHERE  Source   = 'Schedule'
				AND    SourceId = '#Object.ObjectKeyValue4#'								
			</cfquery>	
		
			<cfloop query="getPersons">
			
				 <cfset per = PersonNo>
			
				<!--- payment or time --->
			
				<cfloop index="itm" list="1,0">						
				
					<!--- check for data --->	
					
					<cfquery name="hasData" dbtype="query">
						SELECT  *
						FROM    basedataset
						WHERE   PersonNo       = '#Per#'
						<cfif itm eq "1">
						AND    ( BillingPayment = '1' OR ActivityPayment = '1' )
						<cfelse>
						AND    BillingPayment = '0'						
						</cfif>			
					</cfquery>	
					
					<cfif hasData.recordcount gte "1">
			
							<!--- record header for payable overtime --->										
							
							<cf_assignid>
							<cfset overtimeid = rowguid>
							
							<cfquery name="InsertOvertime" 
						     datasource="AppsPayroll" 
						     username="#SESSION.login#" 
						     password="#SESSION.dbpw#">
						     INSERT INTO PersonOvertime 
							            (PersonNo,			
										 Mission,
										 OvertimeId,
										 OvertimePeriodStart,
										 OvertimePeriodEnd,
										 OvertimeDate,			 
										 DocumentReference,
										 OvertimeHours,
										 OvertimeMinutes,
										 OvertimePayment,
										 Source,
										 SourceId,			 
										 OfficerUserId,
										 OfficerLastName,
										 OfficerFirstName)
							      VALUES ('#Per#',		          								    
										  '#unit.mission#', 			
										  '#overtimeid#',
								    	  '#get.CalendarDateStart#',
										  '#get.CalendarDateEnd#',
										  '#dateformat(now(),client.dateSQL)#',
										  'Attendance Timesheet',
										  '0',
										  '0',
										  '#itm#',
										  'Schedule',
										  '#Object.ObjectKeyValue4#',			  
										  '#SESSION.acc#',
								    	  '#SESSION.last#',		  
									  	  '#SESSION.first#')
							 </cfquery>	 
							 
							 <cfif itm eq "1">
							 
							     <!--- ---------------------------- --->
							 	 <!--- Obtain hours with overcharge --->
								 <!--- ---------------------------- --->
								
								 <cfquery name="act" dbtype="query">
										SELECT SUM(Hours) as Hours 
										FROM   baseDataSet 
										WHERE  PersonNo = '#Per#' 
										AND    ActivityPayment = '1'	
										HAVING SUM(Hours)> 0	
								 </cfquery>  
								 
								 <cfif act.hours gt "0">
								 
									 <cfset hr = int(act.hours)>		
								 
								 	 <cfif int(act.hours) lt ceiling(act.hours)>
									 	<cfset min = "30">
									 <cfelse>
									 	<cfset min = "0">
									 </cfif>
									 							  
									 <cfquery name="insertNight" 
											datasource="AppsPayroll" 
											username="#SESSION.login#" 
											password="#SESSION.dbpw#">
											INSERT INTO PersonOvertimeDetail
											        (PersonNo,
													 OvertimeId,SalaryTrigger,
													 BillingPayment,
													 OvertimeHours,OvertimeMinutes,
													 OfficerUserId,OfficerLastName,OfficerFirstName)
										    VALUES ('#Per#',
											         '#overtimeid#',
													 'NightDiff',
													 '#itm#',
													 '#hr#','#min#',
													 '#session.acc#',
													 '#session.last#',
													 '#session.first#')
									 </cfquery>
								 
								 </cfif>
							 
							 </cfif>
							 
							 <!--- -------------------------------- --->
							 <!--- populate payable time / overtime --->
							 <!--- -------------------------------- --->
								 	  
							 <cfquery name="overtime" dbtype="query">	
									SELECT BillingMode,
									       SUM(OvertimePayroll) as Hours 
									FROM   baseDataSet
									WHERE  PersonNo         = '#Per#' 
									AND    BillingPayment   = '#itm#'	
									AND    BillingMode     != 'Contract'  <!--- exclude contractual hours ---> 
									AND    BillingPayment   = '#itm#'		
									GROUP BY BillingMode	
									HAVING SUM(OvertimePayroll)> 0									
							 </cfquery> 	
							 
														 
							 <cfloop query="overtime">	
							 							 
							     <cfset hr = int(hours)>		
							 
							 	 <cfif int(hours) lt ceiling(hours)>
								 	<cfset min = "30">
								 <cfelse>
								 	<cfset min = "0">
								 </cfif>					 			 
							
								 <cfquery name="insertOvertime" 
										datasource="AppsPayroll" 
										username="#SESSION.login#" 
										password="#SESSION.dbpw#">
										INSERT INTO PersonOvertimeDetail
										           (PersonNo,
													OvertimeId,
													SalaryTrigger,
													BillingPayment,
													OvertimeHours,
													OvertimeMinutes,
													OfficerUserId,
													OfficerLastName,
													OfficerFirstName)
										VALUES ('#Per#',
										        '#overtimeid#',
												'#billingmode#',
												'#itm#',
											 	'#hr#',
												'#min#',
												'#session.acc#',
												'#session.last#',
												'#session.first#') 
								 </cfquery>
							 
							 </cfloop>
						 
							 <!--- total --->
							 
							 <cfquery name="getTotal" 
								datasource="AppsPayroll" 
								username="#SESSION.login#" 
								password="#SESSION.dbpw#">
									SELECT    SUM(OvertimeHours) as Hours,
									          SUM(OvertimeMinutes) as Minutes
									FROM      PersonOvertimeDetail
									WHERE     PersonNo   = '#Per#'
									AND       OvertimeId = '#overtimeid#'						
							 </cfquery>
														 
							  <cfquery name="setTotal" 
								datasource="AppsPayroll" 
								username="#SESSION.login#" 
								password="#SESSION.dbpw#">
									UPDATE    PersonOvertime
									SET 	  OvertimeHours   = '#gettotal.Hours#',	
									          OvertimeMinutes = '#gettotal.Minutes#'	 
									WHERE     PersonNo      = '#Per#'
									AND       OvertimeId    = '#overtimeid#'				
							 </cfquery>					
							  
							  <cfquery name="Person" 
						       datasource="AppsPayroll" 
						       username="#SESSION.login#" 
						       password="#SESSION.dbpw#">
							     	SELECT * 
									FROM   Employee.dbo.Person
									WHERE  PersonNo = '#Per#'	
							 </cfquery>	
						 
							 <!--- create workflow --->
							 
							 <cfset link = "Payroll/Application/Overtime/OvertimeEdit.cfm?ID=#Per#&ID1=#overtimeid#">
							 
							 <cf_ActionListing 
							    EntityCode       = "EntOvertime"
								EntityClass      = "Schedule"
								DataSource       = "AppsPayroll"
								EntityGroup      = ""
								EntityStatus     = ""
								PersonNo         = "#Per#"
								Mission          = "#unit.Mission#"
								OrgUnit          = "#get.OrgUnit#"
								ObjectReference  = "Overtime : #dateformat(get.CalendarDateEnd,'MMM/YY')#"
								ObjectReference2 = "#Person.FirstName# #Person.LastName# - #getTotal.hours#:#getTotal.minutes#"
							    ObjectKey1       = "#Per#"
								ObjectKey4       = "#overtimeid#"
								ObjectURL        = "#link#"	
								Show             = "No">		
															
						</cfif>		
									
				</cfloop>	
				 
			</cfloop>
			
			<cfquery name="reset" 
				datasource="AppsPayroll" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				DELETE PersonOvertime
				FROM PersonOvertime P		
				WHERE NOT EXISTS (SELECT 'X' 
				                  FROM PersonOvertimeDetail 
								  WHERE PersonNo = P.PersonNo 
								  AND OvertimeId  = P.Overtimeid)
				 AND SourceId = '#Object.ObjectKeyValue4#'	
			 </cfquery>		
			
		</cftransaction>

</cfif>
