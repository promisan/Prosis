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
	    FROM   PersonEntitlement
		WHERE  EntitlementId = '#URL.AjaxId#'
</cfquery>

<cfquery name="Person" 
	datasource="AppsEmployee" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT *
		FROM   Person
		WHERE  PersonNo = '#Get.PersonNo#' 
</cfquery>

<cfif Object.Mission neq "">

	<cfset mission = object.Mission>
	
<cfelse>
	
		 <cfquery name="Mission" 
			 datasource="AppsEmployee"
			 username="#SESSION.login#" 
			 password="#SESSION.dbpw#">
				 SELECT   TOP 1 *
				 FROM     PersonContract
				 WHERE    PersonNo    = '#Get.PersonNo#'
				 AND      ActionStatus != '9'					 
				 ORDER BY DateEffective DESC
		</cfquery>
		
		<cfif Mission.Mission eq "">
			 
			 <cfquery name="Mission" 
			 datasource="AppsEmployee"
			 username="#SESSION.login#" 
			 password="#SESSION.dbpw#">
				 SELECT   TOP 1 P.*
				 FROM     PersonAssignment PA, Position P
				 WHERE    PersonNo = '#Get.PersonNo#'
				 AND      PA.PositionNo = P.PositionNo		
				 AND      PA.AssignmentStatus IN ('0','1')
				 AND      PA.AssignmentClass = 'Regular'
				 AND      PA.AssignmentType  = 'Actual'
				 AND      PA.Incumbency      = '100' 
				 ORDER BY PA.DateExpiration DESC
			</cfquery>
		
		</cfif>			

		<cfset mission = mission.mission>	
		
</cfif>

			
<!--- defined the unit of the mission --->
		
 <cfquery name="OnBoard" 
	 datasource="AppsEmployee"
	 username="#SESSION.login#" 
	 password="#SESSION.dbpw#">
		 SELECT   P.*
		 FROM     PersonAssignment PA, Position P
		 WHERE    PersonNo            = '#Get.PersonNo#'
		 AND      Mission             = '#Mission#'
		 AND      PA.PositionNo       = P.PositionNo
		 AND      PA.DateEffective    < getdate()
		 AND      PA.DateExpiration   > getDate()
		 AND      PA.AssignmentStatus IN ('0','1')
		 AND      PA.AssignmentClass  = 'Regular'
		 AND      PA.AssignmentType   = 'Actual'
		 AND      PA.Incumbency       > 0 
		 ORDER BY PA.DateExpiration DESC
</cfquery>

	
<cfif get.PayrollItem eq "">

	<cfset gr = "Rate">
	<cfset rf = "#get.SalaryTrigger#">
	<cfset link = "Staffing/Application/Employee/Entitlement/EntitlementEditTrigger.cfm?ID=#Get.PersonNo#&ID1=#url.ajaxid#">

<cfelse>

	<cfset gr = "Individual">		
		
	<cfquery name="Item" 
		datasource="AppsPayroll" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT *
			FROM   Ref_PayrollItem
			WHERE  PayrollItem = '#Get.PayrollItem#' 
	</cfquery>
				
	<cfset rf = "#item.PayrollItemName#">
	
	<cfset link = "Staffing/Application/Employee/Entitlement/EntitlementEdit.cfm?ID=#Get.PersonNo#&ID1=#url.ajaxid#">
	
</cfif>
		
<cf_ActionListing 
	    EntityCode       = "EntEntitlement"
		EntityClass      = "Standard"
		EntityGroup      = "#gr#"
		EntityStatus     = ""
		PersonNo         = "#Person.PersonNo#"
		Mission          = "#mission#"
		OrgUnit          = "#OnBoard.OrgUnitOperational#"
		ObjectReference  = "#rf#"
		ObjectReference2 = "#Person.FirstName# #Person.LastName#"
	    ObjectKey1       = "#Get.PersonNo#"
		ObjectKey4       = "#Get.EntitlementId#"
		AjaxId           = "#Get.EntitlementId#"
		ObjectURL        = "#link#"
		Show             = "Yes"		
		Toolbar          = "No">
