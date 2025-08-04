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

<link rel="stylesheet" type="text/css" href="<cfoutput>#SESSION.root#/#client.style#</cfoutput>">

<cfif url.action neq "delete"> 
	
		<cfif Len(Form.Remarks) gt 300>
		   <cfset remarks = Left(Form.Remarks, 300)>
		<cfelse>
		   <cfset remarks = Form.Remarks> 
		</cfif>
		
		<cfparam name="Form.OvertimePeriodStart" default="#Form.OvertimePeriodEnd#">
		<cfparam name="Form.OvertimeDate"        default="#Form.OvertimePeriodEnd#">
		
		<cfset dateValue = "">
		<CF_DateConvert Value="#Form.OvertimePeriodStart#">
		<cfset STR = dateValue>
		
		<cfset dateValue = "">
		<CF_DateConvert Value="#Form.OvertimeDate#">
		<cfset DTE = dateValue>
		
		<cfset dateValue = "">
		<CF_DateConvert Value="#Form.OvertimePeriodEnd#">
		<cfset END = dateValue>
		
		<cfif STR gt END>
										
			<cf_message message = "Invalid Period [#DateFormat(STR,CLIENT.DateFormatShow)#-#DateFormat(END,CLIENT.DateFormatShow)#].  Operation not allowed!"
			        return = "back">
		    <cfabort>
					 
		</cfif>   

</cfif>

<!--- verify if record exist --->

<cfquery name="Overtime" 
datasource="AppsPayroll" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
SELECT *
FROM   PersonOvertime
WHERE  OvertimeId  = '#Form.OvertimeId#'
</cfquery>

<cfparam name="Form.OvertimePayment" default="9">

<cfif Overtime.recordCount eq 1> 
	
	<cfif url.action eq "delete"> 
		
		<!---
		 <cfquery name="Clear" 
		   datasource="AppsPayroll" 
		   username="#SESSION.login#" 
		   password="#SESSION.dbpw#">
			   DELETE FROM PersonOvertime 	 
			   WHERE  OvertimeId  = '#Form.OvertimeId#' 
		   </cfquery>
		   --->
		   
		   <cfif Overtime.status lte "2">
		   		     			   
			   <!--- clear the overtime recorded in the timesheet for this person --->
			   
			   <cftransaction>
			   		   
				   <cfquery name="Clear" 
				   datasource="AppsPayroll" 
				   username="#SESSION.login#" 
				   password="#SESSION.dbpw#">
					   UPDATE PersonOvertime 	 
					   SET    Status = '9'
					   WHERE  OvertimeId  = '#Form.OvertimeId#' 
				   </cfquery>
				   
				    <cfquery name="Clear" 
				   datasource="AppsPayroll" 
				   username="#SESSION.login#" 
				   password="#SESSION.dbpw#">
					   DELETE FROM Employee.dbo.PersonWorkDetail 	 				   
					   WHERE  Source   = 'Overtime'
					   AND    SourceId = '#Form.OvertimeId#' 			   
				   </cfquery>
			   
			   </cftransaction>
			   
			   <cfset show = "No">   		    
		       <cfset enf  = "Yes">
		      
			   <cf_ActionListing 
				    EntityCode       = "EntOvertime"				
					EntityGroup      = ""
					EntityStatus     = ""	
					Personno         = "#Overtime.PersonNo#"				
				    ObjectKey1       = "#Overtime.PersonNo#"
					ObjectKey4       = "#Overtime.OvertimeId#"				
					Show             = "#show#"				
					CompleteCurrent  = "#enf#">	  			  
		   
		   </cfif>
			   
	<cfelse>	
	
		 <cfset url.overtimeid = Form.OvertimeId>	
		 
		 <cfif url.mode eq "Correction">	
		 
		 	 <cfquery name="Update" 
			   datasource="AppsPayroll" 
			   username="#SESSION.login#" 
			   password="#SESSION.dbpw#">
				   UPDATE PersonOvertime 
				   SET   OvertimeDate         = #DTE#,
				   		 OvertimePeriodStart  = #STR#,
					     OvertimePeriodEnd    = #END#,
						 DocumentReference    = '#Form.DocumentReference#',
						 OvertimeHours        = '#Form.OvertimeHours#',
						 OvertimeMinutes      = '#Form.OvertimeMinut#',
						 OvertimePayment      = '#Form.OvertimePayment#',
						 Remarks              = '#Form.Remarks#'
				   WHERE OvertimeId  = '#Form.OvertimeId#' 
			   </cfquery>	
			   
			   <cfquery name="purgeDetail" 
				datasource="AppsPayroll" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
					DELETE
					FROM 	PersonOvertimeDetail
					WHERE 	OvertimeId = '#Form.overtimeId#'
					AND 	PersonNo = '#Overtime.PersonNo#'
				</cfquery>
			   
			   <!-- update the details --->
			   
			   <cfif Form.Time neq "">
				
					<cfset vHours = evaluate("Form.Time")>
					
					<cfquery name="insertDetail" 
						datasource="AppsPayroll" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">
						INSERT INTO [dbo].[PersonOvertimeDetail]
							      (PersonNo,
								   OvertimeId,
								   SalaryTrigger,
								   OvertimeHours,					   
								   BillingPayment,
								   OfficerUserId,
								   OfficerLastName,
								   OfficerFirstName)
						VALUES ('#Form.PersonNo#',
						        '#url.overtimeId#',
								'Overtime100',
								'#vhours#',
								'0',
								'#session.acc#',
								'#session.last#',
								'#session.first#')
					</cfquery>		
		
				</cfif>
		
				<cfif Form.Pay neq "">
						
					<cfset vHours = evaluate("Form.Pay")>
					
					<cfquery name="insertDetail" 
						datasource="AppsPayroll" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">
						INSERT INTO [dbo].[PersonOvertimeDetail]
							      (PersonNo,
								   OvertimeId,
								   SalaryTrigger,
								   OvertimeHours,					   
								   BillingPayment,
								   OfficerUserId,
								   OfficerLastName,
								   OfficerFirstName)
								   
						VALUES ('#Form.PersonNo#',
						        '#url.overtimeId#',
								'Overtime100',
								'#vhours#',
								'1',
								'#session.acc#',
								'#session.last#',
								'#session.first#')
					</cfquery>
		
				</cfif> 
	
		 <cfelseif url.mode eq "Standard">	   
		
			 <cfquery name="Update" 
			   datasource="AppsPayroll" 
			   username="#SESSION.login#" 
			   password="#SESSION.dbpw#">
				   UPDATE PersonOvertime 
				   SET   OvertimeDate         = #DTE#,
				   		 OvertimePeriodStart  = #STR#,
					     OvertimePeriodEnd    = #END#,
						 DocumentReference    = '#Form.DocumentReference#',
						 OvertimeHours        = '#Form.OvertimeHours#',
						 OvertimeMinutes      = '#Form.OvertimeMinut#',
						 OvertimePayment      = '#Form.OvertimePayment#',
						 Remarks              = '#Form.Remarks#'
				   WHERE OvertimeId  = '#Form.OvertimeId#' 
			   </cfquery>	
			   
			   <cfset url.PersonNo = Overtime.PersonNo>
			   <cfinclude template="OvertimeDetailSubmit.cfm">
			   
			   <cf_embedHeaderFieldsSubmit entitycode="EntOvertime" entityid="#form.Overtimeid#">
		   
		   <cfelse>
		   
		   		<cfinvoke component = "Service.Process.Employee.Attendance"
						 method         = "LeaveBalance" 
						 PersonNo       = "#Form.PersonNo#" 
						 LeaveType      = "CTO" 
						 Mission        = "#Form.mission#"
						 Mode           = "batch"
						 BalanceStatus  = "0"
						 StartDate      = "01/01/2017"
						 EndDate        = "12/31/#Year(now())#">	
		   
		   		<cftransaction>
		   
			   		<cfinclude template="OvertimeScheduleSubmit.cfm">   
					
					<cfquery name="totalovertime" 
				  	datasource="AppsEmployee" 
				  	username="#SESSION.login#" 
				  	password="#SESSION.dbpw#">
						SELECT    SUM(HourSlotMinutes) AS Minutes
						FROM      PersonWorkDetail 
						WHERE     PersonNo        = '#form.PersonNo#' 
						AND       CalendarDate    = #str# 
						AND       TransactionType = '1'
						AND       Source          = 'Overtime'
						AND       SourceId        = '#form.overtimeid#'
						AND       BillingMode    != 'Contract'								
						
					</cfquery>
			
					<cfif totalovertime.minutes eq "0">
					   <cf_message message = "You must record overtime.  Please resubmit!" return = "back">
					   <cfabort>
					<cfelse>
					    <cfset vHour = int(totalovertime.minutes/60)>
						<cfset vMinu = totalovertime.minutes - (vHour*60)>
					</cfif>						
			   
				    <cfquery name="Update" 
					   datasource="AppsEmployee" 
					   username="#SESSION.login#" 
					   password="#SESSION.dbpw#">
						   UPDATE Payroll.dbo.PersonOvertime 
						   SET    OvertimeDate         = #DTE#,
						   		  OvertimePeriodStart  = #STR#,
							      OvertimePeriodEnd    = #END#,
								  DocumentReference    = '#Form.DocumentReference#',
								  OvertimeHours        = '#vHour#',
								  OvertimeMinutes      = '#vMinu#',				
								  Remarks              = '#Form.Remarks#'
						   WHERE  OvertimeId  = '#Form.OvertimeId#' 
					  </cfquery>
					  
					  <cfquery name="purgeDetail" 
						datasource="AppsEmployee" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">
							DELETE
							FROM 	Payroll.dbo.PersonOvertimeDetail
							WHERE 	OvertimeId = '#form.overtimeId#'
							AND 	PersonNo = '#form.PersonNo#'
						</cfquery>
						
						<!--- insert lines --->	
					
					  <cfquery name="details" 
				  	  datasource="AppsEmployee" 
				  	  username="#SESSION.login#" 
				  	  password="#SESSION.dbpw#">
							SELECT    BillingMode, BillingPayment, SUM(HourSlotMinutes) AS Minutes
							FROM      PersonWorkDetail AS P
							WHERE     PersonNo     = '#form.PersonNo#' 
							AND       CalendarDate = #str# 
							AND       TransactionType = '1'
							AND       Source       = 'Overtime'
							AND       SourceId     = '#form.overtimeid#'
							AND       BillingMode != 'Contract'
							GROUP BY  BillingMode, BillingPayment
					  </cfquery>
					  
					  <cfloop query="details">
					  
					  	   <cfset vHour = int(minutes/60)>
						   <cfset vMinu = minutes - (vHour*60)>
					  
						  <cfquery name="insertDetail" 
							datasource="AppsEmployee" 
							username="#SESSION.login#" 
							password="#SESSION.dbpw#">
				
								INSERT INTO Payroll.dbo.PersonOvertimeDetail
								           (PersonNo,
										    OvertimeId,
											SalaryTrigger,
											OvertimeHours,
											OvertimeMinutes,
											BillingPayment,
								            OfficerUserId,
								            OfficerLastName,
								            OfficerFirstName)
								VALUES    ('#form.PersonNo#',
								           '#Form.overtimeId#',
								           '#BillingMode#',
								           '#vHour#',
								           '#vMinu#',
										   '#BillingPayment#',
								           '#session.acc#',
								           '#session.last#',
								           '#session.first#')		
										   
							</cfquery>	  
					  
					  </cfloop>
					  
		         </cftransaction>
				 
				 <!--- check if the overtime has changed TO PAYMENT MODE TO TRIGGER A NEW WORKFLOW --->
										  
				  <cfquery name="getLines" 
					datasource="AppsEmployee" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
						SELECT * 
						FROM 	Payroll.dbo.PersonOvertimeDetail
						WHERE 	OvertimeId     = '#form.overtimeId#'
						AND 	PersonNo       = '#form.PersonNo#'
						AND     BillingPayment = '1'
				  </cfquery>
					  
				  <cfif Overtime.OvertimePayment eq "0" and getLines.recordcount gte "1">
				  
				  	  <cfquery name="Update" 
					   datasource="AppsEmployee" 
					   username="#SESSION.login#" 
					   password="#SESSION.dbpw#">
						   UPDATE Payroll.dbo.PersonOvertime 
						   SET    OvertimePayment = 1						
						   WHERE  OvertimeId  = '#Form.OvertimeId#' 
					  </cfquery>
				  
					  <cfset class = "Payroll">
					  					  
					  <cfquery name="Person" 
						datasource="AppsEmployee" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">
							SELECT   *
							FROM     Person
							WHERE    PersonNo = '#Form.PersonNo#' 
					  </cfquery>
				  				  
					  <cfquery name="Trigger" 
						 datasource="AppsPayroll"
						 username="#SESSION.login#" 
						 password="#SESSION.dbpw#">
						  SELECT   *
						  FROM     Ref_TriggerGroup
						  WHERE    TriggerGroup = 'Overtime'
						</cfquery>  						
										
					<!--- OrgUnit          = "#OrgUnit#" --->
					
						<cfset link = "Payroll/Application/Overtime/OvertimeEdit.cfm?ID=#Form.PersonNo#&ID1=#form.overtimeid#">
						
						<!--- close the workflow --->
						
						<cf_ActionListing 
						    EntityCode       = "EntOvertime"
							EntityClass      = "#class#"
							EntityGroup      = ""
							EntityStatus     = ""							
						    ObjectKey1       = "#Form.PersonNo#"
							ObjectKey4       = "#form.overtimeid#"							
							HideCurrent      = "Enforce" <!--- disactivates the current workflow to trigger a new one --->
							CompleteCurrent  = "Yes"	
							Show             = "No">		
						
						<!--- create a new one --->
							
						<cf_ActionListing 
						    EntityCode       = "EntOvertime"
							EntityClass      = "#class#"
							EntityGroup      = ""
							EntityStatus     = ""
							PersonNo         = "#form.PersonNo#"
							Mission          = "#Overtime.Mission#"						
							ObjectReference  = "Overtime : #Overtime.DocumentReference#"
							ObjectReference2 = "#Person.FirstName# #Person.LastName#"
						    ObjectKey1       = "#Form.PersonNo#"
							ObjectKey4       = "#form.overtimeid#"
							ObjectURL        = "#link#"
							FlyActor         = "#Overtime.FirstReviewerUserid#"
							FlyActorAction   = "#Trigger.ReviewerActionCodeOne#"
							FlyActor2        = "#Overtime.SecondReviewerUserid#"
							FlyActor2Action  = "#Trigger.ReviewerActionCodeTwo#"								
							Show             = "No">		
					  
					  <!--- we reset the workflow --->
					  
					  <script>
						alert('This record will need to be reviewed again')
					  </script>
						  
				  </cfif>
				  
		   </cfif>
	   
	</cfif>   

</cfif>
	  
<cfoutput>

<cf_SystemScript>

<cfif url.refer neq "workflow">
		
	<script>
		 ptoken.location("EmployeeOvertime.cfm?ID=#Overtime.PersonNo#");
	</script>	

<cfelse>

	<script>
		 ptoken.location("OvertimeEdit.cfm?ID=#Overtime.PersonNo#&ID1=#Overtime.OvertimeId#&refer=#url.refer#");
	</script>	

</cfif>

</cfoutput>	   
	

