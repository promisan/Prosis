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
<link rel="stylesheet" type="text/css" href="<cfoutput>#SESSION.root#/#client.style#</cfoutput>"> 

<cf_wait>

<!--- process decision --->

<!--- update status --->

<cfquery name="update" 
     datasource="AppsEmployee" 
     username="#SESSION.login#" 
     password="#SESSION.dbpw#">
	 UPDATE PersonLeaveAction
	 SET Status           = '#FORM.Status#',
	     ActionMemo       = '#Form.Memo#',
		 OfficerUserId    = '#SESSION.acc#',
		 OfficerLastName  = '#SESSION.last#',
    	 OfficerFirstName = '#SESSION.first#',
		 OfficerDate      = getDate()
	 WHERE LeaveId = '#Form.Leaveid#'
	 AND Role IN (SELECT O.Role
      		FROM   Organization.dbo.OrganizationAuthorization O, Organization.dbo.Ref_AuthorizationRole R 
		    WHERE  O.UserAccount = '#SESSION.acc#' 
    		AND    O.AccessLevel IN ('1','2')
    		AND    R.Area = 'Leave'
	    	AND    R.Role = O.Role
    		AND    O.OrgUnit = '#FORM.OrgUnit#')
</cfquery>

<!--- update master status --->

<cfif #FORM.Status# eq "9">

   <cfquery name="update" 
     datasource="AppsEmployee" 
     username="#SESSION.login#" 
     password="#SESSION.dbpw#">
	 UPDATE PersonLeave
	 SET Status = '#FORM.Status#'
	 WHERE LeaveId = '#Form.Leaveid#'
   </cfquery>
   
   <cfquery name="get" 
     datasource="AppsEmployee" 
     username="#SESSION.login#" 
     password="#SESSION.dbpw#">
	 SELECT L.PersonNo, R.LeaveAccrual, L.LeaveType, L.DateEffective, L.DateExpiration
	 FROM Ref_LeaveType R, PersonLeave L
	 WHERE LeaveId = '#Form.Leaveid#'
	 AND   R.LeaveType = L.LeaveType
   </cfquery>
   
   <cfif get.LeaveAccrual eq "1">
            <cf_Balance 
             PersonNo="#get.PersonNo#" 
			 LeaveType="#get.LeaveType#"
			 StartDate=#get.DateEffective#
			 EndDate=#get.DateExpiration#>
   </cfif>		
  
   <!--- Pending : now send eMail ---->

<cfelse>

   <cfquery name="check" 
     datasource="AppsEmployee" 
     username="#SESSION.login#" 
     password="#SESSION.dbpw#">
	 SELECT Min(Status) as Status
	 FROM PersonLeaveAction
	 WHERE Leaveid = '#Form.Leaveid#'
   </cfquery>
   
   <cfif check.status eq '1'>
   
      <cfquery name="update" 
       datasource="AppsEmployee" 
       username="#SESSION.login#" 
       password="#SESSION.dbpw#">
	   UPDATE PersonLeave
	   SET Status = '1'
	   WHERE LeaveId = '#Form.Leaveid#'
      </cfquery>
	  
	  <!--- Pending : now send an eMail ---->
        
   </cfif>
   
</cfif>

<cf_waitEnd frm="">

 <cf_message 
  status  = "Notification"
  message = "An eMail has been sent to notify the employee."
  return  = "../ClearanceListing.cfm">




