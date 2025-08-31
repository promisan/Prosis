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
<cf_systemscript>

<!--- 0. remove old --->

<cfquery name="old" 
     datasource="AppsEmployee" 
     username="#SESSION.login#" 
     password="#SESSION.dbpw#">
		SELECT *
		FROM  PersonLeave
		WHERE LeaveId = '#Form.LeaveId#'
 </cfquery>
  
<cfquery name="orgunit" 
     datasource="AppsOrganization" 
     username="#SESSION.login#" 
     password="#SESSION.dbpw#">
		SELECT *
		FROM  Organization
		WHERE OrgUnit = '#old.OrgUnit#'
 </cfquery>
   
 <cfif ParameterExists(Form.Delete)>
 
 		 <cfquery name="LeaveType" 
	     datasource="AppsEmployee" 
    	 username="#SESSION.login#" 
	     password="#SESSION.dbpw#">
			SELECT *
			FROM   Ref_LeaveType
			WHERE  LeaveType = '#old.LeaveType#'
		 </cfquery>
		 
	 	<cfquery name="Person" 
		datasource="AppsEmployee" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT *
			FROM   Person
			WHERE  PersonNo = '#old.PersonNo#' 
		</cfquery>
 	
 	    <cftransaction>
  
			<cfquery name="recordcancellation" 
		     datasource="AppsOrganization" 
		     username="#SESSION.login#" 
		     password="#SESSION.dbpw#">
				UPDATE Employee.dbo.PersonLeave
				SET    Status           = '8',
				       OfficerUserId    = '#SESSION.acc#', 
				       OfficerLastname  = '#SESSION.last#', 
					   OfficerFirstName = '#SESSION.first#',
					   Created          = getDate()
				WHERE  LeaveId          = '#Form.LeaveId#'
			</cfquery>
			
			<!--- only if this exists --->
			 
			<cfquery name="RevertPA" 
		    datasource="AppsOrganization" 
		    username="#SESSION.login#" 
		    password="#SESSION.dbpw#">
		    	 UPDATE Employee.dbo.EmployeeAction 
				 SET    ActionStatus      = '9', 				        
						ActionDescription = 'Reverted [lve]'
				 WHERE  ActionSourceId    = '#Form.LeaveId#'	
			</cfquery>	
									
			<cfquery name="leavetype" 
		     datasource="AppsOrganization" 
		     username="#SESSION.login#" 
		     password="#SESSION.dbpw#">
				SELECT *
				FROM  Employee.dbo.Ref_LeaveType
				WHERE LeaveType= '#old.LeaveType#'
			</cfquery>
			
			<!--- only if there is a workflow --->
			
			<cfquery name="Object" 
		    datasource="AppsOrganization" 
		    username="#SESSION.login#" 
		    password="#SESSION.dbpw#">
		    	 SELECT * FROM OrganizationObject
				 WHERE ObjectKeyValue4 =  '#Form.LeaveId#'	
				 AND   Operational = 1			 
			</cfquery>	
			
			<cfif Object.recordcount gte "1">
		 
			    <cfset show = "No">   		    
			    <cfset enf  = "Yes">
			    <cfset link = "Attendance/Application/LeaveRequest/RequestView.cfm?id=#old.LeaveId#">
			
				<cf_ActionListing 
				    EntityCode       = "EntLVE"				
					EntityGroup      = ""
					EntityStatus     = ""	
					Personno         = "#Person.PersonNo#"
					ObjectReference  = "#LeaveType.Description#"
					ObjectReference2 = "#Person.FirstName# #Person.LastName#"
				    ObjectKey1       = "#Person.PersonNo#"
					ObjectKey4       = "#old.LeaveId#"
					AjaxId           = "#old.LeaveId#"	
					Show             = "#show#"				
					CompleteCurrent  = "#enf#"
					ObjectURL        = "#link#">	
				
			</cfif>		 
		 
		 </cftransaction>	
		 		
		 <!--- reset balances --->
		 
		 <cfif LeaveType.LeaveAccrual neq "0">
		 
		 	<CF_DateConvert Value="#dateformat(old.DateEffective,client.dateformatshow)#">						
			<cfset STR  = CreateDate(Year(dateValue),Month(dateValue),1)>
				 		 
		 	<cfinvoke component = "Service.Process.Employee.Attendance"  
			   method         = "LeaveBalance" 
			   PersonNo       = "#Form.PersonNo#" 
			   Mission        = "#Object.mission#"
			   LeaveType      = "#Form.LeaveType#"
			   BalanceStatus  = "0"
			   StartDate      = "#STR#"
			   EndDate        = "#STR+100#">						
		  						  
		 </cfif>	
		 		 
		 <cfinvoke component     = "Service.Process.Employee.Attendance"  
				   method       = "LeaveAttendance" 
				   PersonNo     = "#Form.PersonNo#" 		
				   Mission      = "#Object.Mission#"	   					  
				   StartDate    = "#dateformat(old.DateEffective,client.dateformatshow)#"
				   EndDate      = "#dateformat(old.DateExpiration,client.dateformatshow)#"					  
				   Mode         = "reset">			
		 
			
		 <cfif url.scope eq "backoffice">
		
	 		<cfoutput>
			   <script language="JavaScript">
			      window.location = "EmployeeLeave.cfm?ID=#PersonNo#"	
			   </script>
		    </cfoutput>    
	   
	    <cfelse>
	   
		   	<cfset oSecurity = CreateObject("component","Service.Process.System.UserController")/>
			<cfset mid = oSecurity.gethash()/>   
	   
		   <cfoutput>
			   <script language="JavaScript">			      			     			   			   
			      window.location = "#SESSION.root#/Attendance/Application/LeaveRequest/EmployeeRequest.cfm?scope=#url.scope#&ID=#PersonNo#&mid=#mid#"					 
			   </script>
		    </cfoutput> 
	   	  	   
	    </cfif>
 
 <cfelse> 
	 
	 <!--- EDIT --->
 
     <cfparam name="FORM.GroupCode"             default="">
	 <cfparam name="FORM.GroupListCode"         default="">
 	 <cfparam name="FORM.FirstReviewerUserId"   default="">
	 <cfparam name="FORM.SecondReviewerUserId"  default="">
	 <cfparam name="FORM.HandoverUserId"        default="">
	 <cfparam name="FORM.LeaveTypeClass"        default="">
	 
	 <cfif Form.LeaveTypeClass eq "">
          <cf_message message = "No leave class has been set" return = "back">
	      <cfabort> 
	 </cfif>			 
  	
	 <cfset dateValue = "">
	 <CF_DateConvert Value="#Form.DateEffective#">
	 <cfset STR = dateValue>
	
	 <CF_DateConvert Value="#Form.DateExpiration#">
	 <cfset END = dateValue>
	 
	 <cfif Form.LeaveType            eq old.LeaveType            AND
	       STR                       eq old.DateEffective        AND
		   Form.DateEffectiveFull    eq old.DateEffectiveFull    AND
		   Form.DateExpirationFull   eq old.DateExpirationFull   AND
		   END                       eq old.DateExpiration       AND
		   Form.Memo                 eq old.Memo                 AND
	       Form.ContactLocation      eq old.ContactLocation      AND
		   Form.ContactCallsign      eq old.ContactCallSign      AND
		   Form.HandoverNote         eq old.HandoverNote         AND
		   Form.FirstReviewerUserId  eq old.FirstReviewerUserId  AND
		   Form.SecondReviewerUserId eq old.SecondReviewerUserId AND
		   Form.HandoverUserId       eq old.HandoverUserId       AND
		   Form.LeaveTypeClass       eq old.LeaveTypeClass       AND 
		   Form.GroupListCode        eq old.GroupListCode        AND 
		   Form.DateExpirationFull   eq old.DateExpirationFull   AND
		   Form.DateEffectiveFull    eq old.DateEffectiveFull    AND
		   ParameterExists(Form.Submit)                          AND
		   old.status gte "2"                                    AND
		   getAdministrator("*") eq "0">
		   
		  <cf_tl id="Operation not allowed, You have NOT made any changes." var="1">	   
	            <cf_message message = "#lt_text#" return = "back">
	      <cfabort> 
		  
	 <cfelse>	   
	 	 	 
		 <cfquery name="leavetype" 
		     datasource="AppsEmployee" 
		     username="#SESSION.login#" 
		     password="#SESSION.dbpw#">
				SELECT *
				FROM  Ref_LeaveType
				WHERE LeaveType= '#old.LeaveType#'
		 </cfquery>							
		 		 						
		 <cfif STR gt END>
		  
			  <cf_message message = "Your requested end date lies before the start date. Operation not allowed."
			  return = "back">
			
			  <cfabort>
		
		 </cfif>
							 
		<cfquery name="TimeClass" 
		datasource="AppsEmployee" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT   *
			FROM     Ref_TimeClass 
			WHERE    TimeClass = '#LeaveType.LeaveParent#'
		</cfquery>		
		 
		 <!--- ---------------------- --->
		 <!--- validation for overlap --->
		 <!--- ---------------------- --->
		
		<cf_tl id="Request can not be processed" var="requestCannot">		 
				 
		<cfif TimeClass.AllowOverlap eq "0">
		
			<cfparam name="Form.DateEffectiveHour" default="0">
		
			<cfinvoke component       = "Service.Process.Employee.Attendance"  
				   method             = "LeaveConflict" 
				   PersonNo           = "#form.PersonNo#" 	
				   Mission            = "#OrgUnit.Mission#"		   
				   LeaveType          = "#form.LeaveType#"		  
				   DateEffective      = "#dateformat(STR,client.dateformatshow)#"
				   DateExpiration     = "#dateformat(END,client.dateformatshow)#"
				   DateEffectiveFull  = "#DateEffectiveFull#"
				   DateEffectiveHour  = "#Form.DateEffectiveHour#"
				   DateExpirationFull = "#DateExpirationFull#"
				   CurrentLeaveId     = "#Form.LeaveId#"
				   returnvariable     = "conflict">		
			
			<cfif conflict.overlap eq "1">
				 	      
			     <cf_alert message = "#conflict.message#.\n\n#conflict.content#\n\n#requestCannot#!"
			         return = "back">
			         <cfabort>
					 
			</cfif> 
		
		</cfif>
		
		
		<cf_tl id="Your request for" var="yourRequest">
		<cf_tl id="Sorry" var="vSorry">
		<cf_tl id="Operation not allowed" var="vNotAllowed">
		<cf_tl id="This request can not be processed as it would exceed leave balances calculated until" var="vExceedEntitlement">
		
		<cf_BalanceDays personno  = "#form.personno#" 
			    LeaveType         = "#form.LeaveType#" 
				leavetypeclass    = "#form.Leavetypeclass#" 
				start             = "#STR#" 
				startfull         = "#Form.DateEffectiveFull#" 
				end               = "#END#" 
				endfull           = "#Form.DateExpirationFull#">					
						
		<cfquery name="LeaveTypeClass" 
			datasource="AppsEmployee" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			SELECT   *
			FROM     Ref_LeaveTypeClass 
			WHERE    LeaveType = '#FORM.LeaveType#'
			AND      Code      = '#FORM.LeaveTypeClass#'
		</cfquery>				
				
		<cfif form.grouplistcode eq "" or form.grouplistcode eq "1"> 	   

			<!--- check min/max requirement --->
		
		    <cfif LeaveTypeClass.LeaveMaximum neq "0">
			
			    <!--- maximum is defined on the class level ---> 
				
				<cfif LeaveTypeClass.LeaveMaximumDeduct eq "1">
				
					<cfif Days gt LeaveTypeClass.LeaveMaximum>
						  <cf_tl id="days exceeds the maximum continuous authorised days for" var="dayContinuous">	
				
			        	  <cf_message message = "#yourRequest# #Days# #dayContinuous# #LeaveTypeClass.Description# [#LeaveTypeClass.LeaveMaximum#]. <br>#requestCannot#!"
				          return = "back">
			    	      <cfabort>
						  
				    </cfif> 
					
				<cfelse>	
				
					<cfset num = dateDiff("d",str,end)+1>
					
					<cfif num gt LeaveTypeClass.LeaveMaximum>
						  <cf_tl id="days exceeds the maximum continuous calendar days for" var="dayContinuous">	
				
			        	  <cf_message message = "#yourRequest# #num# #dayContinuous# #LeaveTypeClass.Description# [#LeaveTypeClass.LeaveMaximum#]. <br>#requestCannot#!"
				          return = "back">
			    	      <cfabort>
						  
				    </cfif> 
					
				</cfif>	
		
			<cfelse>
			
				<!--- maximum is defined on the header type level ---> 
			
		    	<cfif Days gt LeaveType.LeaveMaximum>
					  
					  <cf_tl id="days exceed the maximum continuous allowed days for" var="dayExceeds">	
		
		        	  <cf_message message = "#yourRequest# #Days# #dayExceeds# #LeaveType.Description# [#LeaveType.LeaveMaximum#]. <br>#requestCannot#"
			          return = "back">
		    	      <cfabort>
					  
			    </cfif> 
				
			</cfif>	
			
			<cfif LeaveTypeClass.LeaveMinimum neq "0">
			
			    <!--- maximum is defined on the class level ---> 
				
				<cfif LeaveTypeClass.LeaveMinimumDeduct eq "1">
				
					<cfif days lt LeaveTypeClass.LeaveMinimum>
					
					  <cf_tl id="days is less than the minimum continuous authorised days for" var="dayContinuous">	
		        	  <cf_message message = "#yourRequest# #days# #dayContinuous# #LeaveTypeClass.Description# [#LeaveTypeClass.LeaveMinimum#]. <br>#requestCannot#!"
			          return = "back">
		    	      <cfabort>
					  
					</cfif>  			 
					
				<cfelse>
				
					<cfset num = dateDiff("d",str,end)+1>	
								
					<cfif num lt LeaveTypeClass.LeaveMinimum>
					
					  <cf_tl id="days is less than the minimum continuous calendar days for" var="dayContinuous">	
		        	  <cf_message message = "#yourRequest# #num# #dayContinuous# #LeaveTypeClass.Description# [#LeaveTypeClass.LeaveMinimum#]. <br>#requestCannot#!"
			          return = "back">
		    	      <cfabort>
					  
					 </cfif> 
					  
			    </cfif> 
						
			<cfelse>
			
				<!--- minimum is not defined on the header type level ---> 
			    			
			</cfif>	
	
		</cfif>			
		
		<cfinvoke component  = "Service.Access" 
	      method         = "RoleAccess"				  	
		  role           = "'LeaveClearer'"		
		  returnvariable = "manager">		
		  
		 <cfif manager eq "Granted">
		 
			 <!--- we bypass this --->
				 
		 <cfelseif LeaveType.LeaveAccrual neq "0">	
		 		 			 
			  <cfquery name="contract" 
				datasource="AppsEmployee" 
				username="#SESSION.login#" 
		        password="#SESSION.dbpw#">
		   	    SELECT 	 *
		       	FROM 	 PersonContract P
		   		WHERE	 DateEffective <= #END# 
				  AND    PersonNo         = '#FORM.PersonNo#'
				  AND    ActionStatus    != '9'
				  AND    (DateExpiration >= #END# or DateExpiration is NULL)	
				  AND    Mission = '#orgunit.mission#'	
				ORDER BY DateEffective DESC   
		     </cfquery>	 	 
							 
			 <!--- check and update current balances prior to this record until the datemined date --->
			 
			 <!--- reset balances --->
		 				
			  <cfquery name="credit" 
			  datasource="AppsEmployee" 	 
			  username="#SESSION.login#" 
			  password="#SESSION.dbpw#">
		        SELECT   	TOP 1 *
				FROM     	Ref_LeaveTypeCredit
				WHERE    	LeaveType      = '#Form.LeaveType#'
				AND      	ContractType   = '#Contract.ContractType#'
				AND      	DateEffective <= #STR# 
				ORDER BY 	DateEffective DESC 
			</cfquery>
							
			<cfif Credit.AdvanceInCredit eq "">
			    <cfset mycredit = 0>
			<cfelse>
				<cfset mycredit = Credit.AdvanceInCredit> 
			</cfif>
			
			<!--- we are adding 4 months beyond the expiration date of the leave request --->					
			<cfset overdrawdate = dateadd("m",mycredit,END)>
					
			<cfif Contract.DateExpiration eq "">
						 
				<cfset CEND = overdrawdate>	 
			
			<cfelseif overdrawdate gt Contract.DateExpiration> 
			
				<cfquery name="currentcontract" 
				datasource="AppsEmployee" 
				username="#SESSION.login#" 
		        password="#SESSION.dbpw#">
			   	    SELECT 	 TOP 1 *
			       	FROM 	 PersonContract 
			   		WHERE	 PersonNo      = '#FORM.PersonNo#'
					AND      Mission       = '#orgunit.mission#'	
					AND      ActionStatus != '9'			
					ORDER BY DateExpiration DESC  		
				</cfquery>	
						
				<CF_DateConvert Value="#dateformat(CurrentContract.DateExpiration,client.dateformatshow)#">
				<cfset CEND = dateValue>
					 
			<cfelse>
					
				<cfset CEND = overdrawdate>
					 
			</cfif>		
			
			 <cfif old.DateEffective lt str>
														
				<cfinvoke component = "Service.Process.Employee.Attendance"  
				    method        = "LeaveBalance" 
				    PersonNo      = "#Form.PersonNo#" 
					Mission       = "#orgunit.mission#"
					LeaveType     = "#Form.LeaveType#"
					BalanceStatus = "0"					
					StartDate     = "#old.DateEffective#"
					LeaveId       = "#Form.Leaveid#"
					EndDate       = "#CEND#"> 
			
			<cfelse>
													
				<cfinvoke component = "Service.Process.Employee.Attendance"  
				    method        = "LeaveBalance" 
				    PersonNo      = "#Form.PersonNo#" 
					Mission       = "#orgunit.mission#"
					LeaveType     = "#Form.LeaveType#"		
					BalanceStatus = "0"
					LeaveId       = "#Form.Leaveid#"			
					StartDate     = "#STR#"
					EndDate       = "#CEND#"> 
				
			</cfif>			
			
			
			<!--- now we obtain the balance record to be used for comparison --->
			
			<cfquery name="checkThreshold" 
			   datasource="AppsEmployee" 
			   username="#SESSION.login#" 
			   password="#SESSION.dbpw#">	  
				   SELECT     *
				   FROM       Ref_LeaveTypeThreshold
				   WHERE      LeaveType      = '#Form.LeaveType#'
				   AND        LeaveTypeClass = '#Form.LeaveTypeClass#'		  
			</cfquery> 	
			
			<cfif checkThreshold.recordcount eq "1">	
			
				<cfset thresholddate = createDate(year(end), checkThreshold.ThresholdMonth, 1)>
				<cfif end gt thresholddate>
				  <cfset thresholddate = createDate(year(end)+1, checkThreshold.ThresholdMonth, 1)>
				</cfif>
									
				<cfquery name="Balance" 
				   datasource="AppsEmployee" 
				   username="#SESSION.login#" 
				   password="#SESSION.dbpw#">	  
					   SELECT     TOP 1 *, 0 as TakenFuture
					   FROM       PersonLeaveBalance 
					   WHERE      PersonNo       = '#Form.PersonNo#'
					   AND        LeaveType      = '#Form.LeaveType#'
					   AND        BalanceStatus  = '0'
					   AND        LeaveTypeClass = '#Form.LeaveTypeClass#'
					   AND        DateExpiration >= #END#	  <!--- this will take the correct balance record to be used for comparison --->
					   AND        DateExpiration < #ThresholdDate# 		
					   ORDER BY   DateEffective DESC			   
				</cfquery> 			
			
			<cfelse>
								
				<cfquery name="Balance" 
				   datasource="AppsEmployee" 
				   username="#SESSION.login#" 
				   password="#SESSION.dbpw#">	  
					   SELECT     *, 
								            (SELECT ISNULL(SUM(Taken),0)
											 FROM   PersonLeaveBalance 
											 WHERE  PersonNo       = '#Form.PersonNo#'
								             AND    LeaveType      = '#Form.LeaveType#'
											 AND    BalanceStatus  = '0'
		        						     AND    LeaveTypeClass is NULL
											 AND    DateExpiration > B.DateExpiration) as TakenFuture
					   FROM       PersonLeaveBalance  B
					   WHERE      PersonNo       = '#Form.PersonNo#'
					   AND        BalanceStatus  = '0'
					   AND        LeaveType      = '#Form.LeaveType#'
					   AND        LeaveTypeClass = '#Form.LeaveTypeClass#'
					   AND        DateExpiration >= #END#	  <!--- this will take the correct balance record to be used for comparison --->
					   AND        DateEffective  <= #CEND# 		
					   ORDER BY   DateEffective		   
				</cfquery> 		
			
			</cfif>
															
			<cfif Balance.recordcount eq "0">	
		
			   <cfquery name="Balance" 
			    datasource="AppsEmployee" 
			    username="#SESSION.login#" 
			    password="#SESSION.dbpw#">			
				    SELECT    *, 
								            (SELECT ISNULL(SUM(Taken),0)
											 FROM   PersonLeaveBalance 
											 WHERE  PersonNo       = '#Form.PersonNo#'
											 AND    BalanceStatus  = '0'
								             AND    LeaveType      = '#Form.LeaveType#'
		        						     AND    LeaveTypeClass is NULL
											 AND    DateExpiration > B.DateExpiration) as TakenFuture
				    FROM      PersonLeaveBalance B
				    WHERE     PersonNo   = '#Form.PersonNo#'
					AND       BalanceStatus  = '0'
					AND       LeaveType  = '#Form.LeaveType#'
					AND       LeaveTypeClass is NULL
					AND       DateExpiration >= #END#	
					AND       DateEffective <= #CEND# 
					ORDER BY  DateEffective
			   </cfquery>   
			   
			</cfif>   
			
			<cfset required = days>				
			<cfset takennew = 0>
			     
		    <cfloop query="Balance">
		   
		   		<cfset balancecorrected = balance - takenfuture - takennew>		
				
				<cfif balancecorrected lte 0>
					<cfset source = "0">
				<cfelseif balancecorrected gte required>
					<cfset source = required>
				<cfelse>
					<cfset source = balancecorrected>
		    	</cfif>
				
				<cfif source gt "0">
					<cfset required = required - source>
					<cfset takennew = takennew + source>
				</cfif>	
						   	     
		    </cfloop>
											   
		   <cfif required gt "0">
		   						     
				  <cf_message message = "Your request can not be processed as you would exceed your leave entitlements that were calculated until #dateformat(DateExpiration,client.dateformatshow)#. Please contact your HR officer."
				  return = "back">
				  <cfabort>   	
				  
			<cfelse>
														
				<cfinvoke component = "Service.Process.Employee.Attendance"  
				    method    = "LeaveBalance"  
				    PersonNo  = "#Form.PersonNo#" 
					LeaveType = "#Form.LeaveType#"		
					BalanceStatus = "0"			
					StartDate = "#STR#"
					EndDate   = "#CEND#"> 					  
											   
		   </cfif>	 
		 		 
		 </cfif>
				 
		 <cfset resetworkflow = "0">
		 		 
		 <cftransaction>	
				 		 		 
		 <cfif Form.LeaveType          eq old.LeaveType 
		   AND STR                     eq old.DateEffective 
		   AND END                     eq old.DateExpiration 
		   AND Form.LeaveTypeClass     eq old.LeaveTypeClass 
		   AND Form.DateExpirationFull eq old.DateExpirationFull 
		   AND Form.DateEffectiveFull  eq old.DateEffectiveFull>
		   		   
		   <cfquery name="log" 
				     datasource="AppsEmployee" 
				     username="#SESSION.login#" 
				     password="#SESSION.dbpw#">
						INSERT INTO PersonLeaveLog
						    (LeaveId,
							 LeaveType,
							 LeaveTypeClass,
							 DateEffective,
							 DateExpiration,
							 DateEffectiveFull,
							 DateExpirationFull, 
							 OfficerUserId, 
							 OfficerLastName,
							 OfficerFirstName,
							 Created)
						VALUES (
							'#Form.LeaveId#',
							'#old.LeaveType#',
							'#old.LeaveTypeClass#',
							'#old.DateEffective#',
							'#old.DateExpiration#',
							'#old.DateEffectiveFull#',
							'#old.DateExpirationFull#',
							'#old.OfficerUserId#',
							'#old.OfficerLastName#',
							'#old.OfficerFirstName#',
							'#old.Created#')				
				</cfquery>		      					
				
		   <cfelse>
		   
			   	<cfquery name="reset" 
			     datasource="AppsEmployee" 
			     username="#SESSION.login#" 
			     password="#SESSION.dbpw#">
					UPDATE PersonLeave
					SET    OfficerUserId     = '#SESSION.acc#', 
					       OfficerLastname   = '#SESSION.last#', 
						   OfficerFirstName  = '#SESSION.first#',
						   Created           = getDate()
					WHERE  LeaveId = '#Form.LeaveId#'
			 	</cfquery>
			 
				<cfquery name="log" 
				     datasource="AppsEmployee" 
				     username="#SESSION.login#" 
				     password="#SESSION.dbpw#">
						INSERT INTO PersonLeaveLog
						    (LeaveId,
							 LeaveType,
							 LeaveTypeClass,
							 DateEffective,
							 DateExpiration,
							 DateEffectiveFull,
							 DateExpirationFull, 
							 OfficerUserId, 
							 OfficerLastName,
							 OfficerFirstName,
							 Created)
						VALUES (
							'#Form.LeaveId#',
							'#old.LeaveType#',
							'#old.LeaveTypeClass#',
							'#old.DateEffective#',
							'#old.DateExpiration#',
							'#old.DateEffectiveFull#',
							'#old.DateExpirationFull#',
							'#old.OfficerUserId#',
							'#old.OfficerLastName#',
							'#old.OfficerFirstName#',
							'#old.Created#')				
				</cfquery>
				
				<!--- check if the workflow would need to be changed --->
												
				<cfquery name="Workflow" 
				   datasource="AppsEmployee" 
				   username="#SESSION.login#" 
				   password="#SESSION.dbpw#">
					   SELECT *
					   FROM   Ref_LeaveType
					   WHERE  LeaveType = '#Form.LeaveType#'  
					   AND    EntityClass IN (SELECT EntityClass 
					                          FROM   Organization.dbo.Ref_EntityClassPublish 
											  WHERE  EntityCode = 'EntLve')
				</cfquery> 
				
				<!---- Check if LeaveTypeClass has its own workflow --->
				<cfquery name="CWorkflow" 
				   datasource="AppsEmployee" 
				   username="#SESSION.login#" 
				   password="#SESSION.dbpw#">
					   SELECT *
					   FROM   Ref_LeaveTypeClass
					   WHERE  LeaveType = '#Form.LeaveType#' 
					   AND    Code      = '#FORM.LeaveTypeClass#'  
					   AND    EntityClass IN (SELECT EntityClass 
					                          FROM   Organization.dbo.Ref_EntityClassPublish 
											  WHERE  EntityCode = 'EntLve')
				</cfquery>
								
				<!---- LeaveTypeClass has its own workflow --->
				<cfif CWorkflow.recordcount eq "1">
					<cfset WFClass = CWorkFlow.EntityClass>
				<cfelse>
					<cfset WFClass = WorkFlow.entityClass>
				</cfif>		
				
				<cfquery name="Object" 
			     datasource="AppsEmployee" 
			     username="#SESSION.login#" 
			     password="#SESSION.dbpw#">
					SELECT * 
					FROM   Organization.dbo.OrganizationObject
					WHERE  ObjectKeyValue4 = '#form.leaveId#'	
					AND    Operational = 1				
			 	</cfquery>
				
				<!--- if the workflow is different we reinitate it --->
				
				<cfif WFClass neq Object.EntityClass>					
					<cfset resetWorkflow = "1">										
				</cfif> 
		 
		</cfif>
		 
		<cfset num = end - str + 1>	
		 
		<!--- determine the number of days as calculated leave ---> 
				   
		 <cfparam name="Form.FirstReviewerUserid"  default="">  
		 <cfparam name="Form.SecondReviewerUserid" default="">
		 <cfparam name="Form.HandoverUserid"       default="">
		 <cfparam name="Form.HandoverNote"         default="">
		 
		 <cfquery name="reset" 
		     datasource="AppsEmployee" 
		     username="#SESSION.login#" 
		     password="#SESSION.dbpw#">
				UPDATE PersonLeave
				SET    DateEffective         = #STR#,
				       DateExpiration        = #END#,
					   LeaveType             = '#Form.LeaveType#',
					   <cfif form.LeaveTypeClass eq "">
					   		LeaveTypeClass     = NULL,
					   <cfelse>
					   		LeaveTypeClass     = '#form.LeaveTypeClass#',
					   </cfif>
					   <cfif Form.GroupCode neq "">
						   GroupCode         	 = '#Form.GroupCode#',
					   <cfelse>
						   GroupCode         	 = NULL,
					   </cfif>
   					   <cfif Form.GroupListCode neq "">
					   	   GroupListCode         = '#Form.GroupListCode#',
					   <cfelse>
						   GroupListCode         = NULL,
					   </cfif>
					   DateEffectiveFull     = '#Form.DateEffectiveFull#',
					   DateExpirationFull    = '#Form.DateExpirationFull#',
					   DaysLeave             = '#num#',
					   DaysDeduct            = '#days#',
					   Memo                  = '#Form.Memo#',
					   ContactCallSign       = '#Form.ContactCallSign#', 
					   ContactLocation       = '#Form.ContactLocation#',
					   FirstReviewerUserId   = '#Form.FirstReviewerUserId#', 
					   SecondReviewerUserId  = '#Form.SecondReviewerUserId#', 
					   HandoverUserId        = '#Form.HandoverUserId#', 
					   HandoverNote          = '#Form.HandoverNote#',
					   OfficerUserId         = '#SESSION.acc#',
					   OfficerLastName       = '#SESSION.last#',
					   OfficerFirstName      = '#SESSION.first#',
					   Created               = getDate()
				WHERE  LeaveId               = '#Form.LeaveId#'
		 </cfquery>
		 
		 <cfquery name="reset" 
		     datasource="AppsEmployee" 
		     username="#SESSION.login#" 
		     password="#SESSION.dbpw#">
			 	DELETE FROM PersonLeaveDeduct
				WHERE  Leaveid = '#Form.LeaveId#'
		 </cfquery>	 
		 
		 <cfquery name="reset" 
		     datasource="AppsEmployee" 
		     username="#SESSION.login#" 
		     password="#SESSION.dbpw#">
			 	UPDATE Organization.dbo.OrganizationObject
				SET    ObjectDue       = #STR#
				WHERE  ObjectKeyValue4 = '#Form.LeaveId#'
				AND    Operational     = 1
		</cfquery>	 
		
		<cfoutput query="deduction">
		
			<cfset dte = dateformat(date,client.dateSQL)>
	
			 <cfquery name="insert" 
		     datasource="AppsEmployee" 
		     username="#SESSION.login#" 
		     password="#SESSION.dbpw#">	 
				INSERT INTO	PersonLeaveDeduct
				(LeaveId,CalendarDate,Deduction,OfficerUserId,OfficerLastName,OfficerFirstName)
				VALUES
			    ('#Form.LeaveId#','#dte#','#Deduct#','#SESSION.acc#','#SESSION.last#','#SESSION.first#')								
			  </cfquery>
	  			
	     </cfoutput>
			 
		</cftransaction>   
		
		<cfif resetworkflow eq "1">
		
			<cfquery name="Person" 
			     datasource="AppsEmployee" 
			     username="#SESSION.login#" 
			     password="#SESSION.dbpw#">
					SELECT * 
					FROM   Person
					WHERE  PersonNo = '#old.PersonNo#'					
			</cfquery>
									
			<cfset link = "Attendance/Application/LeaveRequest/RequestView.cfm?id=#old.LeaveId#">
				
				<!--- close the workflow, so a new workflow can be generated open uponing the screen after the submit --->
			
			<cf_ActionListing 
			    EntityCode       = "EntLVE"	
				EntityClass      = "#WFClass#"
				EntityGroup      = ""						
				Personno         = "#Person.PersonNo#"
				ObjectReference  = "#LeaveType.Description#"
				ObjectReference2 = "#Person.FirstName# #Person.LastName#"
			    ObjectKey1       = "#Person.PersonNo#"
				ObjectKey4       = "#old.LeaveId#"
				AjaxId           = "#old.LeaveId#"	
				Show             = "No"
				HideCurrent      = "Enforce" <!--- disactivates the current workflow to trigger a new one --->
				CompleteCurrent  = "Yes"
				ObjectURL        = "#link#">	
				
				<!--- reobtain the current orgunit --->
				
				<cfquery name="orgunit" 
				datasource="AppsEmployee" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				    SELECT 	   O.OrgUnit, O.OrgUnitName, O.Mission, O.WorkSchema
				   	FROM 	   PersonAssignment P INNER JOIN Organization.dbo.Organization O ON P.OrgUnit = O.OrgUnit
					WHERE	   P.PersonNo          = '#FORM.PersonNo#'  
					AND        P.DateEffective     <= #STR# 
					AND        P.DateExpiration    >= #STR#
					AND        P.AssignmentStatus  < '8' <!--- planned and approved --->
				    AND        P.AssignmentType    = 'Actual'   	 
					ORDER BY   P.Incumbency DESC <!--- first the highest --->	  
			  </cfquery>
				
			<!--- create the new one --->	
				
			<cf_ActionListing 
			    EntityCode       = "EntLVE"	
				EntityClass      = "#WFClass#"
				EntityGroup      = ""						
				Personno         = "#Form.PersonNo#"
				Mission          = "#OrgUnit.Mission#"
			    OrgUnit          = "#OrgUnit.OrgUnit#"
				ObjectReference  = "#LeaveType.Description#"
				ObjectReference2 = "#Person.FirstName# #Person.LastName#"
			    ObjectKey1       = "#Form.PersonNo#"
				ObjectKey4       = "#old.LeaveId#"
				AjaxId           = "#old.LeaveId#"	
				Show             = "No"				
				ObjectURL        = "#link#"
				ObjectDue        = "#dateformat(STR,client.dateSQL)#"
				FlyActor         = "#Form.FirstReviewerUserId#"
		        FlyActorAction   = "#LeaveType.ReviewerActionCodeOne#"
       		    FlyActor2        = "#Form.SecondReviewerUserId#"
        		FlyActor2Action  = "#LeaveType.ReviewerActionCodeTwo#"
		        FlyActor3        = "#Form.HandoverUserId#"
        		FlyActor3Action  = "#LeaveType.HandoverActionCode#">						
						
		</cfif>				
				
		<!--- revalidate the leave balance all together --->	
				  
		
		<cfinvoke component   = "Service.Process.Employee.Attendance"  
			  Method          = "LeaveBalance" 
			  PersonNo        = "#Form.PersonNo#" 
			  Mission         = "#orgunit.mission#"
		      LeaveType       = "#Form.LeaveType#" 
			  BalanceStatus   = "0"
			  StartDate       = "#Form.DateEffective#">		
			  									 						  
		<!--- merge entries --->
		
		<cfif STR lt old.DateEffective>
			<cfset BEG = STR>
		<cfelse>
			<cfset BEG = old.DateEffective>		
		</cfif>
		
		<cfif END gt old.DateExpiration>
			<cfset UNT = END>
		<cfelse>
			<cfset UNT = old.DateExpiration>		
		</cfif>		
		
		<cfinvoke component     = "Service.Process.Employee.Attendance"  
				   method       = "LeaveAttendance" 
				   PersonNo     = "#Form.PersonNo#" 		
				   Mission      = "#orgunit.Mission#"	   					  
				   StartDate    = "#dateformat(BEG,client.dateformatshow)#"
				   EndDate      = "#dateformat(UNT,client.dateformatshow)#"					  
				   Mode         = "reset">			
				   				
	</cfif>
					
	<cfif parameterExists(Form.Submit)> 
			
		<cfif url.scope eq "backoffice">
							
	 		<cfoutput>
			   <script language="JavaScript">
			      ptoken.open("EmployeeLeave.cfm?ID=#PersonNo#","_self")	
			   </script>
		    </cfoutput>   
			
		<cfelseif url.scope eq "attendance">
		
			<cfoutput>
			   <script language="JavaScript">			   
				 try { opener.applyfilter('','','#form.leaveid#') } catch(e) {}
				 window.close()	 
			   </script>
			</cfoutput>   	 
	   
	   <cfelse>	   
	   			   
		   <cfoutput>
		  
			   <script language="JavaScript">					   			     			   			   
			      ptoken.open("#SESSION.root#/Attendance/Application/LeaveRequest/EmployeeRequest.cfm?scope=#url.scope#&ID=#PersonNo#","_self")					 
			   </script>
			   
		    </cfoutput> 
	   
	   </cfif> 
	
	</cfif>
	
</cfif>	
