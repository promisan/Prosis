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
<cfquery name="Object" 
datasource="AppsOrganization" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT   * 
    FROM     OrganizationObject
	WHERE    ObjectKeyValue4 =  '#URL.AjaxId#'
</cfquery>

<cfquery name="Get" 
	datasource="AppsPayroll" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
    	SELECT *
	    FROM   PersonOvertime
		WHERE  OvertimeId = '#URL.AjaxId#'
</cfquery>

<cfquery name="GetPayment" 
	datasource="AppsPayroll" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
    	SELECT *
	    FROM   PersonOvertimeDetail
		WHERE  OvertimeId = '#URL.AjaxId#'
		AND    BillingPayment = '1'
</cfquery>

<cfquery name="Person" 
	datasource="AppsEmployee" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT *
		FROM   Person
		WHERE  PersonNo = '#Get.PersonNo#' 
</cfquery>
			
<!--- defined the unit of the mission --->
		
 <cfquery name="OnBoard" 
	 datasource="AppsEmployee"
	 username="#SESSION.login#" 
	 password="#SESSION.dbpw#">
		 SELECT   P.*
		 FROM     PersonAssignment PA INNER JOIN Position P ON PA.PositionNo       = P.PositionNo
		 WHERE    PersonNo            = '#Get.PersonNo#'
		 AND      Mission             = '#Object.Mission#'		 
		 AND      PA.DateEffective    < getdate()		 
		 AND      PA.AssignmentStatus IN ('0','1')
		 AND      PA.AssignmentClass  = 'Regular'
		 AND      PA.AssignmentType   = 'Actual'
		 AND      PA.Incumbency       > 0 
		 ORDER BY PA.DateExpiration DESC
</cfquery>
	
<cfset link = "Payroll/Application/Overtime/OvertimeEdit.cfm?ID=#Get.PersonNo#&ID1=#url.ajaxid#">

<cfif Get.OvertimePayment eq "1" or getPayment.recordcount gte "1">
    <!-- extended flow --->
	<cfset class="Payroll">
<cfelse>
	<cfset class="Compensation">
</cfif>

<cfset vHours = Get.OvertimeHours>
<cfset vMin = Get.OvertimeMinutes>
<cfif len(vHours) eq 1>
	<cfset vHours = "0" & Get.OvertimeHours>
</cfif>
<cfif len(vMin) eq 1>
	<cfset vMin = "0" & Get.OvertimeMinutes>
</cfif>

<cfset vOTTime = vHours & ":" & vMin>
		
<cf_ActionListing 
	    EntityCode       = "EntOvertime"
		EntityClass      = "#class#"
		EntityGroup      = ""
		EntityStatus     = ""
		PersonNo         = "#Person.PersonNo#"
		Mission          = "#Object.Mission#"
		OrgUnit          = "#OnBoard.OrgUnitOperational#"
		ObjectReference  = "#Get.DocumentReference#"
		ObjectReference2 = "#Person.FirstName# #Person.LastName# (#Dateformat(Get.OvertimeDate, CLIENT.DateFormatShow)# #vOTTime#)"
	    ObjectKey1       = "#Get.PersonNo#"
		ObjectKey4       = "#Get.OvertimeId#"
		AjaxId           = "#Get.OvertimeId#"
		ObjectURL        = "#link#"
		Show             = "Yes"		
		Toolbar          = "No">
