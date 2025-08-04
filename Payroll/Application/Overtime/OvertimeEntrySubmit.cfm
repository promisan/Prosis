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

<!--- ------------------------------------------- --->
<!--- overtime transaction have 4 status supported	 
	 0 pending
	 2 cleared
	 5 paid
	 9 cancelled	 
--->

<cfparam name="Form.FirstReviewerUserId" default="">
<cfparam name="Form.OvertimePeriodStart" default="#Form.OvertimePeriodEnd#">
<cfparam name="Form.OvertimeDate"        default="#Form.OvertimePeriodEnd#">
<cfparam name="Form.FirstReviewerUserId" default="">
<cfparam name="Form.OvertimePayment"     default="0">
<cfparam name="Form.OvertimeHours"       default="">
<cfparam name="Form.OvertimeMinut"       default="">

<cfif Len(Form.Remarks) gt 300>
   <cfset remarks = Left(Form.Remarks, 300)>
<cfelse>
   <cfset remarks = Form.Remarks> 
</cfif>

<cfset dateValue = "">
<CF_DateConvert Value="#Form.OvertimePeriodStart#">
<cfset STR = dateValue>

<cfset dateValue = "">
<CF_DateConvert Value="#Form.OvertimeDate#">
<cfset DTE = dateValue>

<cfset dateValue = "">
<CF_DateConvert Value="#Form.OvertimePeriodEnd#">
<cfset END = dateValue>

<cfif Form.FirstReviewerUserId eq "">
   <cf_message message = "You must select a reviewer.  Please resubmit!" return = "back">
   <cfabort>
</cfif>

<cfif STR gt END>
								
	  <cf_message message = "Invalid Period [#DateFormat(STR,CLIENT.DateFormatShow)#-#DateFormat(END,CLIENT.DateFormatShow)#].  Operation not allowed!"
	  return = "back">
      <cfabort>
			 
</cfif>   

<!--- verify if record exist --->

<cfquery name="Person" 
datasource="AppsEmployee" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT   *
	FROM     Person
	WHERE    PersonNo = '#Form.PersonNo#' 
</cfquery>

<cfquery name="Overtime" 
datasource="AppsEmployee" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT   *
	FROM     Payroll.dbo.PersonOvertime
	WHERE    OvertimeId = '#url.OvertimeId#'
</cfquery>

<cfif Overtime.recordCount gte "1"> 
	
	<cfoutput>
	
	<cfparam name="URL.ID" default="#Overtime.PersonNo#">
	<cfinclude template="../../../Staffing/Application/Employee/PersonViewHeader.cfm">
	
	<script language="JavaScript">
	
	function edit() {
		window.location = "#session.root#/Payroll/Application/Overtime/OvertimeEdit.cfm?ID=#URL.ID#&ID1=#Overtime.OvertimeId#"
	}	
	</script>
	<p align="center">
	
	<font face="Verdana" size="2" color="FF0000"><b>An overtime record with this effective date was already registered</font></b></p>
	<hr>
	&nbsp;
	<input type="button" class="button10g" value="Edit Overtime" onClick="javascript:edit();">
	
	</cfoutput>

<CFELSE>

	<cf_verifyOnboard personNo = "#form.PersonNo#">
	
	<cfif url.mode eq "Correction">
	
		<cftransaction>
	
		<cfquery name="InsertOvertime" 
		     datasource="AppsPayroll" 
		     username="#SESSION.login#" 
		     password="#SESSION.dbpw#">
		     INSERT INTO PersonOvertime 
		            (PersonNo,
					 OvertimeId,
					 Mission,
					 OvertimePeriodStart,
					 OvertimePeriodEnd,
					 OvertimeDate,			 
					 DocumentReference,
					 OvertimeHours,					
					 OvertimePayment,
					 Remarks,
					 TransactionType,
					 FirstReviewerUserId,
					 SecondReviewerUserId,
					 OfficerUserId,
					 OfficerLastName,
					 OfficerFirstName)
		      VALUES ('#Form.PersonNo#',	
			          '#url.overtimeid#',   
					  '#Form.Mission#',  
			    	  #STR#,
					  #END#,
					  #DTE#,
					  '#Form.DocumentReference#',
					  '#Form.Time#',	
					  <cfif Form.Pay gte "1">'1',<cfelse>'0',</cfif>				  					  
					  '#Remarks#',
					  'Correction',
					  '#Form.FirstReviewerUserId#',
					  '#Form.SecondReviewerUserId#',
					  '#SESSION.acc#',
			    	  '#SESSION.last#',		  
				  	  '#SESSION.first#')
		</cfquery>			

		<cfif Form.Time neq "">
				
			<cfset vHours = evaluate("Form.Time")>
			
			<cfquery name="insertDetail" 
				datasource="AppsPayroll" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				INSERT INTO PersonOvertimeDetail
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
						'#vhours*-1#',
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
				INSERT INTO PersonOvertimeDetail
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
		
		</cftransaction>
		
    <cfelseif url.mode eq "Standard">
	
		<cfif Form.OvertimeHours eq "" or Form.OvertimeMinut eq "">
			   <cf_message message = "You must record overtime.  Please resubmit!" return = "back">
			   <cfabort>
		</cfif>
		
		<cfquery name="InsertOvertime" 
		     datasource="AppsPayroll" 
		     username="#SESSION.login#" 
		     password="#SESSION.dbpw#">
			 			 
		     INSERT INTO PersonOvertime 
		            (PersonNo,
					 OvertimeId,
					 Mission,
					 OvertimePeriodStart,
					 OvertimePeriodEnd,
					 OvertimeDate,			 
					 DocumentReference,
					 OvertimeHours,
					 OvertimeMinutes,
					 OvertimePayment,
					 Remarks,
					 FirstReviewerUserId,
					 SecondReviewerUserId,
					 OfficerUserId,
					 OfficerLastName,
					 OfficerFirstName)
		      VALUES ('#Form.PersonNo#',	
			          '#url.overtimeid#',   
					  '#Form.Mission#',  
			    	  #STR#,
					  #END#,
					  #DTE#,
					  '#Form.DocumentReference#',
					  '#Form.OvertimeHours#',
					  '#Form.OvertimeMinut#',
					  '#Form.OvertimePayment#',
					  '#Remarks#',
					  '#Form.FirstReviewerUserId#',
					  '#Form.SecondReviewerUserId#',
					  '#SESSION.acc#',
			    	  '#SESSION.last#',		  
				  	  '#SESSION.first#')
		</cfquery>	  	
			 		 
		<cfset url.PersonNo = Form.PersonNo>
		<cfinclude template="OvertimeDetailSubmit.cfm">
			 		  
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
					AND       BillingMode    != 'Contract'
					AND       Source          = 'Overtime'
					AND       SourceId        = '#url.overtimeid#'				
				</cfquery>
							
				<cfif totalovertime.minutes eq "0" or totalovertime.minutes eq "">
				   <cf_message message = "You must record some overtime. Please resubmit!" return = "back">
				   <cfabort>
				<cfelse>
				    <cfset vHour = int(totalovertime.minutes/60)>
					<cfset vMinu = totalovertime.minutes - (vHour*60)>
				</cfif>
				
				<!--- insert header --->		
				
				<cfquery name="InsertOvertime" 
			     datasource="AppsEmployee" 
			     username="#SESSION.login#" 
			     password="#SESSION.dbpw#">
			     INSERT INTO Payroll.dbo.PersonOvertime 
				            (PersonNo,
							 OvertimeId,
							 Mission,
							 OvertimePeriodStart,
							 OvertimePeriodEnd,
							 OvertimeDate,			 
							 DocumentReference,
							 OvertimeHours,
							 OvertimeMinutes,					
							 Remarks,
							 TransactionType,
							 FirstReviewerUserId,
							 SecondReviewerUserId,
							 OfficerUserId,
							 OfficerLastName,
							 OfficerFirstName)
			      VALUES ('#Form.PersonNo#',	
				          '#url.overtimeid#',   
						  '#Form.Mission#',  
				    	  #STR#,
						  #END#,
						  #DTE#,
						  '#Form.DocumentReference#',
						  '#vHour#',
						  '#vMinu#',					  
						  '#Remarks#',
						  'Schedule',
						  '#Form.FirstReviewerUserId#',
						  '#Form.SecondReviewerUserId#',
						  '#SESSION.acc#',
				    	  '#SESSION.last#',		  
					  	  '#SESSION.first#')
				  </cfquery>	 
							  
				  <!--- insert lines --->	
						
				  <cfquery name="details" 
			  	  datasource="AppsEmployee" 
			  	  username="#SESSION.login#" 
			  	  password="#SESSION.dbpw#">
						SELECT    BillingMode, BillingPayment, SUM(HourSlotMinutes) AS Minutes
						FROM      PersonWorkDetail AS P
						WHERE     PersonNo        = '#form.PersonNo#' 
						AND       CalendarDate    = #str# 
						AND       TransactionType = '1'
						AND       Source          = 'Overtime'
						AND       SourceId        = '#url.overtimeid#'
						AND       BillingMode    != 'Contract'
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
							           '#url.overtimeId#',
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
			  
			  <cfinvoke component = "Service.Process.Employee.Attendance"
				 method         = "LeaveBalance" 
			     PersonNo       = "#Form.PersonNo#" 
				 LeaveType      = "CTO" 
				 Mission        = "#Form.mission#"
				 Mode           = "batch"
				 BalanceStatus  = "0"
				 StartDate      = "01/01/2017"
				 EndDate        = "12/31/#Year(now())#">			
								
		</cfif>  
	  
    <cfoutput>
	
	 <cfquery name="OnBoard" 
	 datasource="AppsEmployee"
	 username="#SESSION.login#" 
	 password="#SESSION.dbpw#">
		 SELECT   P.*
		 FROM     PersonAssignment PA, Position P
		 WHERE    PersonNo           = '#FORM.PersonNo#'
		 AND      PA.PositionNo      = P.PositionNo
		 AND      PA.DateEffective   < getdate()		
		 AND      PA.AssignmentStatus IN ('0','1')
		 AND      PA.AssignmentClass = 'Regular'
		 AND      PA.AssignmentType  = 'Actual'
		 AND      PA.Incumbency      = '100' 
		 ORDER BY PA.DateExpiration DESC
	</cfquery>
		
	<!--- create wf record --->
	
	<cfparam name="Form.FirstReviewerUserId"  default="">
	<cfparam name="Form.SecondReviewerUserId" default="">
	
	<cfset link = "Payroll/Application/Overtime/OvertimeEdit.cfm?ID=#Form.PersonNo#&ID1=#url.overtimeid#">
	
	<cfquery name="GetPayment" 
	datasource="AppsPayroll" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
    	SELECT *
	    FROM   PersonOvertimeDetail
		WHERE  OvertimeId = '#url.overtimeid#'
		AND    BillingPayment = '1'
	</cfquery>
	
	<cfif url.mode eq "Correction">
		<cfset class = "Correction">	
		
		<cfquery name="setHeader" 
		datasource="AppsPayroll" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
	    	UPDATE PersonOvertime
			SET    OvertimePayment = '1'
			WHERE  OvertimeId = '#url.overtimeid#'		
		</cfquery>
		
	<cfelseif Form.OvertimePayment eq "1" or getPayment.recordcount gte "1">		
		<cfset class="Payroll">
		
		<cfquery name="setHeader" 
		datasource="AppsPayroll" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
	    	UPDATE PersonOvertime
			SET    OvertimePayment = '1'
			WHERE  OvertimeId = '#url.overtimeid#'		
		</cfquery>
		
	<cfelse>
		<cfset class="Compensation">
	</cfif>
	
	<cfquery name="Trigger" 
	 datasource="AppsPayroll"
	 username="#SESSION.login#" 
	 password="#SESSION.dbpw#">
	  SELECT   *
	  FROM     Ref_TriggerGroup
	  WHERE    TriggerGroup = 'Overtime'
	</cfquery>  
		
	<cf_ActionListing 
	    EntityCode       = "EntOvertime"
		EntityClass      = "#class#"
		EntityGroup      = ""
		EntityStatus     = ""
		PersonNo         = "#Person.PersonNo#"
		Mission          = "#form.Mission#"
		OrgUnit          = "#OnBoard.OrgUnit#"
		ObjectReference  = "Overtime : #Form.DocumentReference#"
		ObjectReference2 = "#Person.FirstName# #Person.LastName# - #Form.OvertimeHours#:#Form.OvertimeMinut#"
	    ObjectKey1       = "#Form.PersonNo#"
		ObjectKey4       = "#url.overtimeid#"
		ObjectURL        = "#link#"
		FlyActor         = "#Form.FirstReviewerUserid#"
		FlyActorAction   = "#Trigger.ReviewerActionCodeOne#"
		FlyActor2        = "#Form.SecondReviewerUserid#"
		FlyActor2Action  = "#Trigger.ReviewerActionCodeTwo#"		
		Show             = "No">		
				
	<cf_SystemScript>
		
	<!--- save costom fields --->
	
	<cf_embedHeaderFieldsSubmit entitycode="EntOvertime" entityid="#url.Overtimeid#">
		
    <script language = "JavaScript">
	     ptoken.location("#session.root#/Payroll/Application/Overtime/EmployeeOvertime.cfm?ID=#Form.PersonNo#");
    </script>	
	 		 
	</cfoutput>	   
	
</cfif>	

