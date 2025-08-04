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

<cfquery name="Type" 
datasource="AppsEmployee" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	DELETE FROM PersonLeaveBalanceInit 
	WHERE  PersonNo = '#Form.PersonNo#' 
</cfquery>

<cfloop index="Ln" from="1" to="#Form.No#" step="1">
  
	<cfset initleavetype         =  evaluate("Form.LeaveType"&#Ln#)>
	<cfset initdateeffective     =  evaluate("Form.DateEffective"&#Ln#)>
	<cfset initbalancedays       =  evaluate("Form.BalanceDays"&#Ln#)>
	<cfset initmemo              =  evaluate("Form.Memo"&#Ln#)>
	
	<cfif initdateeffective neq "" and initbalancedays neq "">
	
		<cfset dateValue = "">
	    <cfif initDateEffective neq ''>
	       <CF_DateConvert Value="#initDateEffective#">
	       <cfset DTE = dateValue>
	    </cfif>	
				
		<cfquery name="Insert" 
		datasource="AppsEmployee" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			INSERT INTO PersonLeaveBalanceInit 
				(PersonNo, LeaveType, BalanceDays, DateEffective, Memo, OfficerUserId, OfficerLastName, OfficerFirstName)
			VALUES 
				('#Form.PersonNo#','#initLeaveType#', '#initBalanceDays#', #DTE#, '#initMemo#', '#SESSION.acc#', '#SESSION.last#', '#SESSION.first#')
	   </cfquery>
	   
	   <!--- correct --->
	  	
		<cfquery name="Contract" 
		datasource="AppsEmployee" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT   TOP 1 L.*, 
				     R.Description as ContractDescription, 
				     A.Description as AppointmentDescription
		    FROM     PersonContract L, 
			         Ref_ContractType R,
				     Ref_AppointmentStatus A
			WHERE    L.PersonNo      = '#Form.PersonNo#'
			AND      L.ContractType = R.ContractType		
			AND      L.AppointmentStatus = A.Code
			AND      L.ActionStatus IN ('0','1')
			ORDER BY L.DateEffective DESC 
		</cfquery>
		
		<cfinvoke component = "Service.Process.Employee.PersonnelAction"
		    Method          = "getEOD"
		    PersonNo        = "#Form.PersonNo#"
			Mission         = "#Contract.Mission#"
		    ReturnVariable  = "EOD">	
	      
		<cfquery name="resetType" 
			datasource="AppsEmployee" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				UPDATE  PersonLeaveBalanceInit 
				SET     DateEffective = '#dateformat(eod,client.DateSQL)#'
				WHERE   PersonNo = '#Form.PersonNo#' 
				AND     DateEffective < '#dateformat(eod,client.DateSQL)#'
		</cfquery>
		
		
		
		<cfquery name="getType" 
			datasource="AppsEmployee" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			SELECT  *
			FROM    PersonLeaveBalanceInit 		
			WHERE   PersonNo = '#Form.PersonNo#' 
			AND     LeaveType = '#initLeaveType#'		
		</cfquery>
	        
	    <!--- recalculate balances --->
		
		<cfinvoke component = "Service.Process.Employee.Attendance"
			 method         = "LeaveBalance" 
			 PersonNo       = "#form.PersonNo#" 
			 LeaveType      = "#initLeaveType#" 
			 Mission        = "#Contract.mission#"
			 Mode           = "regular"
			 BalanceStatus  = "0"
			 StartDate      = "#dateformat(getType.DateEffective,client.DateSQL)#"
			 EndDate        = "12/31/#Year(now())#">			
      	   
   </cfif>
   
</cfloop> 

<cfset url.mode = "Balance">
<cfset url.id   = "#form.PersonNo#">

<cfinclude template="../LeaveBalances.cfm">


