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
<!--- integrity	

	1. Check if dates are sequential
	2. Define if person has an assignment on the enddate of the leave
	3. Check if the person has a contract on the enddate of the leave
	4. Check if attendance records have been closed
	5. Define days nominal and deduction and check if min/max is not exceeded
	6. Check if there is another draft = 0 request (deprecated 3/5/2018)
	7. Check if overlap with other leave ?
	8. Balance validation	
	9. Go, register and show result
	
--->

<cf_AssignId>

<cfparam name="FORM.LeaveType"             default="">
<cfparam name="FORM.GroupCode"             default="">
<cfparam name="FORM.GroupListCode"         default="">
<cfparam name="FORM.HandoverUserId"        default="">
<cfparam name="FORM.FirstReviewerUserid"   default="">
<cfparam name="FORM.SecondReviewerUserid"  default="">

<cfparam name="url.src"            default="Manual">
<cfparam name="url.balancestatus"  default="0">

<cf_tl id="Request can not be processed" var="requestCannot">
<cf_tl id="Your request for" var="yourRequest">
<cf_tl id="Sorry" var="vSorry">
<cf_tl id="Operation not allowed" var="vNotAllowed">
<cf_tl id="This request can not be processed as it would exceed leave balances calculated until" var="vExceedEntitlement">
   	 
<cfif FORM.LeaveType eq "">
 
  <cf_tl id="You have not identified a type of leave" var="vIdentifiedLeave">
  <cf_alert message = "#vIdentifiedLeave#. \n\n#vNotAllowed#."
  return = "back">
  <cfabort>

</cfif>

<!--- --------------------------------------------------------------------- --->
<!--- 1. check dates------------------------------------------------------- --->
<!--- --------------------------------------------------------------------- --->

<cfset dateValue = "">
<CF_DateConvert Value="#Form.DateEffective#">
<cfset STR = dateValue>

<CF_DateConvert Value="#Form.DateExpiration#">
<cfset END = dateValue>

<cfif STR gt END>
	
  <cf_tl id="Your requested end date lies before the start date" var="vBefore">
  
  <cf_message message = "#vBefore#. \n\n#vNotAllowed#."
  return = "no">

  <cfabort>

</cfif>

<!--- --------------------------------------------------------------------- --->
<!--- 2. define org unit for which the person is working on the last day of his leave 
	  AND   P.Incumbency > '0'
      AND   P.AssignmentClass = 'Regular' --->
<!--- --------------------------------------------------------------------- --->	  

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

<cfif orgUnit.recordcount eq "0">
  
  		<cf_tl id="but I am not able to define your current assignment" var="vAssignment">
  			
        <cf_message message = "#vSorry#, #vAssignment#. \n\n#requestCannot#!"
        	return = "no">
        <cfabort>
  
</cfif> 

<cfquery name="mandate" 
datasource="AppsEmployee" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT 	M.*
	FROM    Organization.dbo.Organization O, Organization.dbo.Ref_Mandate M
	WHERE	O.Mission = M.Mission
	AND     O.MandateNo = M.MandateNo
	AND     O.OrgUnit = '#orgunit.orgunit#'	
</cfquery>

<cfif Mandate.MandateStatus eq "0">

	  <cf_tl id="but the determined mandate is not cleared yet" var="vMandate">
	  	
      <cf_message message = "#vSorry#, #vMandate#. \n\n#requestCannot#!" return = "no">
      <cfabort>

</cfif>

<!--- 3/12/2019 added by Hanno as a quick resolve. Needs to be better embedded as a business rule in a
new table Ref_LeaveTypeRule --->

<cfif form.leaveType eq "Annual">
				
	<cfquery name="CTO" 
		   datasource="AppsEmployee" 
		   username="#SESSION.login#" 
		   password="#SESSION.dbpw#">

			SELECT     TOP (1) Balance
			FROM       PersonLeaveBalance
			WHERE      LeaveType = 'CTO' 
			AND        PersonNo = '#Form.PersonNo#'
			ORDER BY   DateEffective DESC
			
	</cfquery>		
	
	<cfif CTO.Balance gte "7.5">
			
	  <cf_tl id="Please amend your request to consume CTO first before submitting any annual leave" var="vCTO">
	  <cf_message message = "#vCTO#. \n\nYour current balance: #CTO.Balance# hours" return = "no">
	   
         <cfabort>
							
	</cfif>			
				
</cfif>
	
<cfquery name="LeaveType" 
datasource="AppsEmployee" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT   *
	FROM     Ref_LeaveType 
	WHERE    LeaveType = '#FORM.LeaveType#'
</cfquery>		

<cfparam name="Form.LeaveTypeClass" default="">

<cfquery name="LeaveTypeClass" 
datasource="AppsEmployee" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
SELECT   *
FROM     Ref_LeaveTypeClass 
WHERE    LeaveType = '#FORM.LeaveType#'
AND      Code      = '#FORM.LeaveTypeClass#'
</cfquery>		

<cfquery name="TimeClass" 
datasource="AppsEmployee" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT   *
	FROM     Ref_TimeClass 
	WHERE    TimeClass = '#LeaveType.LeaveParent#'
</cfquery>		

<!--- --------------------------------------------------------------------- --->	 				
<!--- 3. define if person still have a contract on the last day of his leave in the same mission;
   and we take the last contract for defining the allowable overdraw ------ --->
<!--- --------------------------------------------------------------------- --->	 

<cfquery name="contract" 
		datasource="AppsEmployee" 
		username="#SESSION.login#" 
        password="#SESSION.dbpw#">
   	    SELECT 	 *
       	FROM 	 PersonContract 
   		WHERE	 DateEffective <= #END# 
		  AND    PersonNo      = '#FORM.PersonNo#'
		  AND    ActionStatus != '9'
		  AND    (DateExpiration >= #END# or DateExpiration is NULL)	
		  AND    Mission       IN ('#orgunit.mission#','UNDEF')	
		ORDER BY DateEffective DESC   
</cfquery>
	
<cfif contract.recordcount neq "1" 
        and LeaveType.LeaveAccrual neq "0" 
		and LeaveType.LeaveBalanceEnforce eq "1">
	  
	  <cf_tl id ="Contractual status can not be determined and your request can not be processed" var="vContractual">
	  <cf_tl id ="Please contact your administrator" var="vContact">
	  	
      <cf_message message = "#vContractual#. \n#vContact#!"
           return = "no">
      <cfabort>
	  
</cfif> 		

<!--- --------------------------------------------------------------------- --->	 
<!--- 4. check if attendance records have been cleared already------------- --->
<!--- --------------------------------------------------------------------- --->	 

<cfquery name="attendance" 
		datasource="AppsEmployee" 
		username="#SESSION.login#" 
        password="#SESSION.dbpw#">
		SELECT  *
		FROM   PersonWork
		WHERE  PersonNo = '#form.PersonNo#'
		AND    CalendarDate >= #STR#
		AND    CalendarDate <= #END#
		AND    ActionStatus = 1
</cfquery>		

<cfif attendance.recordcount gte "1">
	
	  <cf_tl id="Your request covers an attendance period which has been closed/cleared already" var="vClosed">
	  	 	
      <cf_message message = "#vSorry#, #vClosed#!"
                return = "no">
      <cfabort>
</cfif> 	

<!--- ------------------------------------------------------------------------ --->	 
<!--- 5. go through the request leave days and define the calculated deduction --->
<!--- ------------------------------------------------------------------------ --->	 

<cfset classtype = "0">

<cfif LeaveTypeClass.PointerLeave lt "100">\
	<cfset DateEffectiveFull  = "1">
	<cfset DateExpirationFull = "1">
<cfelse>
	<cfset DateEffectiveFull  = Form.DateEffectiveFull>
	<cfset DateExpirationFull = Form.DateExpirationFull>
</cfif>

<cf_BalanceDays personno  = "#form.personNo#" 
           LeaveType      = "#Form.LeaveType#" 
		   leavetypeclass = "#Form.LeaveTypeClass#" 
		   start          = "#STR#" 
		   startfull      = "#DateEffectiveFull#" 
		   end            = "#END#" 
		   endfull        = "#DateExpirationFull#">	
		   
<cfif form.grouplistcode eq "" or form.grouplistcode eq "1"> 	   

		<!--- check min/max requirement --->
		
	    <cfif LeaveTypeClass.LeaveMaximum neq "0">
		
		    <!--- maximum is defined on the class level ---> 
			
			<cfif LeaveTypeClass.LeaveMaximumDeduct eq "1">
			
				<cfif Days gt LeaveTypeClass.LeaveMaximum>
					  <cf_tl id="days exceeds the maximum continuous authorised days for" var="dayContinuous">	
						
		        	  <cf_message message = "#yourRequest# #Days# #dayContinuous# #LeaveTypeClass.Description# [#LeaveTypeClass.LeaveMaximum#]. \n\n#requestCannot#!"
			          return = "no">
		    	      <cfabort>
					  
			    </cfif> 
				
			<cfelse>	
			
				<cfset num = dateDiff("d",str,end)+1>
				
				<cfif num gt LeaveTypeClass.LeaveMaximum>
					  <cf_tl id="days exceeds the maximum continuous calendar days for" var="dayContinuous">	
			
		        	  <cf_alert message = "#yourRequest# #num# #dayContinuous# #LeaveTypeClass.Description# [#LeaveTypeClass.LeaveMaximum#]. \n\n#requestCannot#!"
			          return = "back">
		    	      <cfabort>
					  
			    </cfif> 
				
			</cfif>	
	
		<cfelse>
		
			<!--- maximum is defined on the header type level ---> 
		
	    	<cfif Days gt LeaveType.LeaveMaximum>
				  
				  <cf_tl id="days exceed the maximum continuous allowed days for" var="dayExceeds">	
	
	        	  <cf_alert message = "#yourRequest# #Days# #dayExceeds# #LeaveType.Description# [#LeaveType.LeaveMaximum#]. \n\n#requestCannot#!"
		          return = "back">
	    	      <cfabort>
				  
		    </cfif> 
			
		</cfif>	
			
		<cfif LeaveTypeClass.LeaveMinimum neq "0">
		
		    <!--- maximum is defined on the class level ---> 
			
			<cfif LeaveTypeClass.LeaveMinimumDeduct eq "1">
			
				<cfif days lt LeaveTypeClass.LeaveMinimum>
				
				  <cf_tl id="days is less than the minimum continuous authorised days for" var="dayContinuous">	
	        	  <cf_alert message = "#yourRequest# #days# #dayContinuous# #LeaveTypeClass.Description# [#LeaveTypeClass.LeaveMinimum#]. \n\n#requestCannot#!"
		          return = "back">
	    	      <cfabort>
				  
				</cfif>  			 
				
			<cfelse>
			
				<cfset num = dateDiff("d",str,end)+1>	
							
				<cfif num lt LeaveTypeClass.LeaveMinimum>
				
				  <cf_tl id="days is less than the minimum continuous calendar days for" var="dayContinuous">	
	        	  <cf_alert message = "#yourRequest# #num# #dayContinuous# #LeaveTypeClass.Description# [#LeaveTypeClass.LeaveMinimum#]. \n\n#requestCannot#!"
		          return = "back">
	    	      <cfabort>
				  
				 </cfif> 
				  
		    </cfif> 
					
		<cfelse>
		
			<!--- minimum is not defined on the header type level ---> 
		    			
		</cfif>	
	
</cfif>

<!--- ------------------------------------------------------------------------ --->
<!--- 6. define is a prior request for the same leave type is pending approval --->
<!--- ------------------------------------------------------------------------  

Note : This validation is no longer needed, as we check for overlapping leave request and balance for
thresholds are checked until the end of the threshold period 

<cfif LeaveType.LeaveAccrual neq "0" and Form.Source neq "Manual">
		
	 <cfquery name="Check" 
	    datasource="AppsEmployee" 
	    username="#SESSION.login#" 
	    password="#SESSION.dbpw#">
		    SELECT   *
		    FROM     PersonLeave 
		    WHERE    PersonNo        = '#Form.PersonNo#'
			AND      LeaveType       = '#Form.LeaveType#'
			AND      LeaveTypeClass  = '#Form.LeaveTypeClass#'
			-- AND      DateExpiration < getDate()
			AND      Status IN ('0')		
	   </cfquery> 
	         
	   <cfif check.recordcount gte "1" and Form.Source neq "Manual">
		     <cf_alert message = "A leave request for the SAME type has not been submitted yet.\nA new request can't be saved until you submit the prior request.\nPlease contact your administrator if you need further assistance." return = "back">
		     <cfabort>   
	   </cfif>  
   
</cfif>     

---> 
 
<!--- ------------------------------------------------------------------- --->  
<!--- 7.- define if an existing request oonflicts with this request ----- --->
<!--- ------------------------------------------------------------------- --->


<!--- ------------------------------------------------------------------- --->  
<!--- 7.- define if an existing request oonflicts with this request ----- --->
<!--- ------------------------------------------------------------------- --->

<cfif TimeClass.AllowOverlap eq "0">

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
		   returnvariable="conflict">		
	
	<cfif conflict.overlap eq "1">
		 	      
	     <cf_alert message = "#conflict.message#.\n\n#conflict.content#\n\n#requestCannot#!"
	         return = "back">
	         <cfabort>
			 
	</cfif> 

</cfif>

<!--- ------------------------------------------------------------------- --->
<!--- 8. Balance validation --------------------------------------------- --->
<!--- ------------------------------------------------------------------- --->
	
<cfif LeaveType.LeaveAccrual neq "0"> <!--- in case of balance compare with balance --->
	
	<cfif days lte "0" and OrgUnit.WorkSchema eq "0">
	
		  <cf_tl id="Your request does not have any deductable days." var="deductable">
		  <cf_alert message = "#deductable#\n\n#requestCannot#!" return = "back">
   	      <cfabort>
		
	</cfif>
	
	<!--- check and update current balances prior to this record until the datemined date --->
		
	<cfinvoke component = "Service.Process.Employee.Attendance"  
		   method       = "LeaveBalance" 
		   PersonNo     = "#form.PersonNo#" 	
		   Mission      = "#OrgUnit.Mission#"				   
		   LeaveType    = "#form.LeaveType#"
		   BalanceStatus = "0"
		   StartDate    = "#STR#"
		   EndDate      = "#END#">			
		   
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
			
	<cfif cend gte end>
	
		<!--- generate and calculate the balances until the endtime --->		
					
		<cfinvoke component = "Service.Process.Employee.Attendance"  
		   method        = "LeaveBalance" 
		   PersonNo      = "#Form.PersonNo#" 
		   Mission       = "#OrgUnit.Mission#"		
		   LeaveType     = "#Form.LeaveType#"	
		   BalanceStatus = "0"	   
		   StartDate     = "#END#"
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
			   SELECT     TOP 1 *, 0 as NetTakenFuture
			   FROM       PersonLeaveBalance 
			   WHERE      PersonNo       = '#Form.PersonNo#'
			   AND        BalanceStatus  = '#url.balancestatus#'
			   AND        LeaveType      = '#Form.LeaveType#'
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
			             (SELECT ISNULL(SUM(Credit-Taken),0)
						 FROM   PersonLeaveBalance WITH(NOLOCK)
						 WHERE  PersonNo       = '#Form.PersonNo#'
						 AND    BalanceStatus  = '#url.balancestatus#'
			             AND    LeaveType      = '#Form.LeaveType#'
     						     AND    LeaveTypeClass is NULL									 
						 AND    DateExpiration > B.DateExpiration) as NetTakenFuture
																		  
			   FROM       PersonLeaveBalance  B
			   WHERE      PersonNo       = '#Form.PersonNo#'
			   AND        BalanceStatus  = '#url.balancestatus#'
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
			             (SELECT ISNULL(SUM(Credit-Taken),0)
						 FROM   PersonLeaveBalance WITH(NOLOCK)
						 WHERE  PersonNo       = '#Form.PersonNo#'
						 AND    BalanceStatus  = '#url.balancestatus#'
			             AND    LeaveType      = '#Form.LeaveType#'
     					 AND    LeaveTypeClass is NULL									 
						 AND    DateExpiration > B.DateExpiration) as NetTakenFuture
									  
		    FROM      PersonLeaveBalance B
		    WHERE     PersonNo   = '#Form.PersonNo#'
			AND       BalanceStatus  = '#url.balancestatus#'
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
	
		<cfif nettakenfuture lt 0>				
			<cfset balancecorrected = balance - takennew + nettakenfuture>										
		<cfelse>					
			<cfset balancecorrected = balance - takennew>							
		</cfif>
	   		
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
		
	
	<!--- we obtain the access rights as we allow admin and leave clearer to process --->
	
	<cfinvoke component  = "Service.Access" 
	      method         = "RoleAccess"				  	
		  role           = "'LeaveClearer'"		
		  returnvariable = "manager">						
		  
	<cfif manager eq "Granted" and form.PersonNo neq client.PersonNo>
				
		<!--- we allow this as an admin knows what to do --->  
   
   <cfelseif required gt "0" and LeaveType.LeaveBalanceEnforce eq "1">
      
	   <cfif form.source neq "Manual">	   				     
	   		<cf_tl id="Please contact your HR officer"    var="vOfficer">			  
	   <cfelse>		
			<cf_tl id="Please contact your Administrator" var="vOfficer">				  
	   </cfif>	 

	  <cf_alert message = "#vExceedEntitlement#  #dateformat(DateExpiration,client.dateformatshow)# (#required#).\n\n#vOfficer#." return = "back">
	  <cfabort>   	   
	  
   <cfelseif  required gt "0" and LeaveType.LeaveBalanceEnforce eq "0">   
      
	   <cfset classtype = "1">
   
   </cfif>
	  
</cfif> 



<!--- ------------------------------------------------------------------ --->
<!--- ------- 9. submit request and identify actions ------------------- --->
<!--- ------------------------------------------------------------------ --->

<cfquery name="Parameter" 
     datasource="AppsEmployee" 
     username="#SESSION.login#" 
     password="#SESSION.dbpw#">
     SELECT   *
     FROM     Parameter 
</cfquery>

<cfif Form.Source eq "Manual">

   <cfset type = "Manual">
   <cfset status = "0">
      
	<cfquery name="Workflow" 
	   datasource="AppsEmployee" 
	   username="#SESSION.login#" 
	   password="#SESSION.dbpw#">
		   SELECT *
		   FROM   Ref_LeaveType
		   WHERE  LeaveType       = '#Form.LeaveType#'  
		   AND    EntityClass IN (SELECT EntityClass FROM Organization.dbo.Ref_EntityClass WHERE EntityCode = 'EntLve')
	</cfquery> 
	
	<cfif Workflow.recordcount eq "0">
	
		 <cfset status = "1">
	
	</cfif>
      
<cfelse>

     <!--- portal --->
     <cfset type = "Request">   
     <cfset status = "0">
    
</cfif>

<cfif FORM.FirstReviewerUserid eq ""     and 
     LeaveType.LeaveParent neq "LWOP"    and 
	 LeaveType.LeaveParent neq "Excused" and 
	 LeaveType.LeaveParent neq "Suspend">

	<cf_tl id="You must select an approver" var="vSelectApprover">
	<cf_tl id="If the option is not visible please contact your administrator" var="vContactAdministrator">

	<cfoutput>
	<script language="JavaScript">	
			alert('#vSelectApprover#. \n\n#vContactAdministrator#.');
			Prosis.busy('no')
	</script>	
	</cfoutput>
	<cfabort>
	
</cfif>	

<!--- now we are ready to record the leave request --->
	 	
<cftransaction>  
	
	<cfparam name="Form.HandoverNote"     default="">
	<cfparam name="Form.HandoverUserId"   default="">
	<cfparam name="Form.LeaveTypeClass"   default="">
		
	<cfif Len(FORM.Memo) gt 500>
	     <cfset mem = left(Form.Memo,500)>
	<cfelse>
	     <cfset mem = Form.Memo>	 	
	</cfif>
	
	<cfif Len(FORM.HandoverNote) gt 400>
	     <cfset note = left(Form.HandoverNote,400)>
	<cfelse>
	     <cfset note = Form.HandoverNote>	 	
	</cfif>	
	
	<cfset num = end - str + 1>	
	
	<cf_assignid>
			
    <cfquery name="insert" 
     datasource="AppsEmployee" 
     username="#SESSION.login#" 
     password="#SESSION.dbpw#">
	 
		INSERT INTO	PersonLeave
				(LeaveId,
				PersonNo, 
				Mission,
				OrgUnit, 
				TransactionType,
				LeaveType, 
				LeaveTypeClass,
				GroupCode,
				GroupListCode,
				DateEffective, 
				DateEffectiveFull, 
				DateEffectiveHour,
				DateExpiration, 
				DateExpirationFull,  				
				DaysLeave,
				DaysDeduct,
				Status, 
				<cfif LeaveType.ReviewerActionCodeOne neq "">
				FirstReviewerUserId,
				SecondReviewerUserId,			
				</cfif>
				<cfif LeaveType.HandoverActionCode neq "">
				HandoverUserId,
				</cfif>
				HandoverNote,
				ContactLocation,
				ContactCallSign,			
				Memo,
				OfficerUserId,
				OfficerLastName, 
		    	OfficerFirstName)
		
		VALUES ('#rowguid#',
		        '#Form.PersonNo#',
				'#OrgUnit.Mission#',
		        '#OrgUnit.OrgUnit#', 
				'#type#',
		        '#Form.LeaveType#',
				<cfif Form.LeaveTypeClass neq "">
				'#Form.LeaveTypeClass#',
				<cfelse>
				NULL,
				</cfif>
				<cfif Form.GroupCode eq "">
					NULL,
					NULL,
				<cfelse>
					'#Form.GroupCode#',
					'#Form.GroupListCode#',
				</cfif>
				#STR#, 
				'#DateEffectiveFull#', 
				'#FORM.DateEffectiveHour#', 
				#END#,
                '#DateExpirationFull#', 				
				#Num#,
				#days#,
				'#Status#',
				<cfif LeaveType.ReviewerActionCodeOne neq "">
				'#Form.FirstReviewerUserid#',
				'#Form.SecondReviewerUserid#',
				</cfif>
				<cfif LeaveType.HandoverActionCode neq "">
				'#Form.HandoverUserId#',
				</cfif>				
				'#note#',				
				'#Form.ContactLocation#',
				'#Form.ContactCallSign#',
				'#mem#',				
				'#SESSION.acc#',
    		    '#SESSION.last#',
				'#SESSION.first#')
				
     </cfquery>
	 
	 <!--- record also the underlying details abtain from balance days --->
	 	  	 
	<cfoutput query="deduction">
	
		 <cfquery name="insert" 
	     datasource="AppsEmployee" 
	     username="#SESSION.login#" 
	     password="#SESSION.dbpw#">	 
			INSERT INTO	PersonLeaveDeduct
			(  LeaveId,
			   CalendarDate,
			   Deduction,
			   OfficerUserId,
			   OfficerLastName,
			   OfficerFirstName)
			VALUES
		    ('#rowguid#',
			 '#Date#',
			 '#Deduct#',
			 '#SESSION.acc#',
			 '#SESSION.last#',
			 '#SESSION.first#')
		  </cfquery>
	  			
	</cfoutput>
		 
	 <!--- sync entries in the attendance database --->
	 
	 <cfinvoke component     = "Service.Process.Employee.Attendance"  
				   method       = "LeaveAttendance" 
				   PersonNo     = "#Form.PersonNo#" 		
				   Mission      = "#orgunit.Mission#"	   					  
				   StartDate    = "#Form.DateEffective#"
				   EndDate      = "#Form.DateExpiration#"					  
				   Mode         = "reset">
	
	</cftransaction> 

<!--- update balance --->

<cfif LeaveType.LeaveAccrual neq "0">

		<cfinvoke component = "Service.Process.Employee.Attendance"  
		   method        = "LeaveBalance" 
		   PersonNo      = "#form.PersonNo#" 	
		   Mission       = "#OrgUnit.Mission#"				   
		   LeaveType     = "#form.LeaveType#"
		   BalanceStatus = "0"
		   StartDate     = "#STR#"
		   EndDate       = "#END#">				
			 
</cfif>		
		
<cfoutput>

<!--- check to record as a personnel action --->

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

<cfquery name="Person" 
	datasource="AppsEmployee" 
	username="#SESSION.login#" 
    password="#SESSION.dbpw#">
		SELECT  *
		FROM    Person
		WHERE   PersonNo = '#form.PersonNo#'		
</cfquery>		

<cfif Form.Source eq "Manual">

	<!--- option to turn-off/on per mission is not anbeld yet --->
	
	<cfif WorkFlow.recordcount eq "1" or CWorkflow.recordcount eq "1">
	
		<cfset link = "Attendance/Application/LeaveRequest/RequestView.cfm?id=#rowguid#">

		<!---- LeaveTypeClass has its own workflow and is not overruled by the classtype --->
		<cfif CWorkflow.recordcount eq "1" and classtype eq "0">
			<cfset WFClass = "#CWorkFlow.EntityClass#">
			<cfset ref     = "#CWorkflow.Description#">
		<cfelse>
			<cfset WFClass = "#WorkFlow.entityClass#">
			<cfset ref     = "#Workflow.Description#">
		</cfif>
						
		<cf_ActionListing 
		    EntityCode       = "EntLVE"
			EntityClass      = "#WFClass#"
			EntityGroup      = ""
			EntityStatus     = ""
			PersonNo         = "#Person.PersonNo#"
			Mission          = "#OrgUnit.Mission#"
			OrgUnit          = "#OrgUnit.OrgUnit#"
			ObjectReference  = "#ref# #Form.DateEffective# #Form.DateExpiration#"
			ObjectReference2 = "#Person.FirstName# #Person.LastName#" 
			ObjectKey1       = "#Person.PersonNo#"
		    ObjectKey4       = "#rowguid#"
			ObjectURL        = "#link#"
			ObjectDue        = "#dateformat(STR,client.dateSQL)#"
			Show             = "No"
			FlyActor         = "#Form.FirstReviewerUserid#"
			FlyActorAction   = "#LeaveType.ReviewerActionCodeOne#"
			FlyActor2        = "#Form.SecondReviewerUserid#"
			FlyActor2Action  = "#LeaveType.ReviewerActionCodeTwo#"
			FlyActor3        = "#Form.HandoverUserId#"
			FlyActor3Action  = "#LeaveType.HandoverActionCode#">	
		
	</cfif>	
		   
	<script language="JavaScript">
				
		 try { parent.right.document.getElementById('menu1').click() } catch(e) {}
		 parent.ProsisUI.closeWindow('leave',true)
		 
	</script>

<cfelse>

	<cfif WorkFlow.recordcount eq "1" or CWorkflow.recordcount eq "1">

		<cfset link = "Attendance/Application/LeaveRequest/RequestView.cfm?id=#rowguid#">
		
		<cfparam name="Form.FirstReviewerUserId" default="">
		<cfparam name="Form.SecondReviewerUserId" default="">
		
		<!---- LeaveTypeClass has its own workflow --->
		<cfif CWorkflow.recordcount eq "1">
			<cfset WFClass = "#CWorkFlow.EntityClass#">
		<cfelse>
			<cfset WFClass = "#WorkFlow.entityClass#">
		</cfif>		
		
		<cf_ActionListing 
		    EntityCode       = "EntLVE"
			EntityClass      = "#WFClass#"
			EntityGroup      = ""
			EntityStatus     = ""
			PersonNo         = "#Person.PersonNo#"
			Mission          = "#OrgUnit.Mission#"
			OrgUnit          = "#OrgUnit.OrgUnit#"
			ObjectReference  = "#LeaveType.Description# #Form.DateEffective# #Form.DateExpiration#"
			ObjectReference2 = "#Person.FirstName# #Person.LastName#" 
			ObjectKey1       = "#Person.PersonNo#"
		    ObjectKey4       = "#rowguid#"
			ObjectURL        = "#link#"
			ObjectDue        = "#dateformat(STR,client.dateSQL)#" 
			Show             = "No"			
			FlyActor         = "#Form.FirstReviewerUserid#"
			FlyActorAction   = "#LeaveType.ReviewerActionCodeOne#"
			FlyActor2        = "#Form.SecondReviewerUserid#"
			FlyActor2Action  = "#LeaveType.ReviewerActionCodeTwo#"
			FlyActor3        = "#Form.HandoverUserId#"
			FlyActor3Action  = "#LeaveType.HandoverActionCode#">	
			
			
	</cfif>			

     <script language="JavaScript">        
	  	      
      	  ptoken.navigate('#session.root#/Attendance/Application/LeaveRequest/RequestRecords.cfm?ID=#Form.PersonNo#','contentbox1')	
		  ptoken.navigate('#session.root#/Attendance/Application/LeaveRequest/getBalance.cfm?leavetype=#Form.LeaveType#&id=#Form.PersonNo#','balance')
		  personviewtoggle('leave')
		  Prosis.busy('no')	
	  	  
     </script> 
   
</cfif>   

<!--- check to record as a personnel action --->

<cfquery name="Action" 
   datasource="AppsEmployee" 
   username="#SESSION.login#" 
   password="#SESSION.dbpw#">
	   SELECT *
	   FROM   Ref_LeaveType
	   WHERE  LeaveType       = '#Form.LeaveType#'  
	   AND    ActionCode IN (SELECT ActionCode FROM Ref_Action)
</cfquery> 

<cfif Action.recordcount eq "1">

	<!--- ----------------------------------------- --->
	<!--- track action of the insert new leave----- --->
	<!--- ----------------------------------------- --->
			
	<cfinvoke component       = "Service.Process.Employee.PersonnelAction"  
		   method             = "ActionDocument" 
		   PersonNo           = "#Form.PersonNo#"
		   ActionCode         = "#Action.ActionCode#"
		   ActionDate         = "#Form.DateEffective#"
		   ActionSourceId     = "#rowguid#"	
		   ActionLink    	  = "Staffing/Application/Employee/Leave/EmployeeLeaveEdit.cfm?ID=#Form.PersonNo#&ID1="
		   ActionStatus       = "1">
		  		   
</cfif>

</cfoutput>
