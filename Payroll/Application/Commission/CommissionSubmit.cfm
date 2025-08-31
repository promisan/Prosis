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
<cfquery name="org" 
	datasource="AppsPayroll" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">			
	SELECT * FROM Organization.dbo.Organization WHERE OrgUnit = '#url.orgunit#'	
</cfquery>	

 <cfquery name="Schedule" 
		datasource="AppsPayroll"
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		    SELECT    *
			FROM      SalarySchedule
			WHERE     SalarySchedule = '#form.salaryschedule#' 
 </cfquery>	

 <cfquery name="Period" 
		datasource="AppsPayroll"
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		    SELECT    TOP 1 Mission, SalarySchedule, PayrollStart, PayrollEnd
			FROM      SalarySchedulePeriod
			WHERE     Mission = '#org.mission#' 
			AND       CalculationStatus IN ('0', '1', '2') 
			AND       SalarySchedule = '#form.salaryschedule#' 
 </cfquery>	

<!--- add record --->
			 
<CF_DateConvert Value="#dateformat(Period.PayrollStart,client.dateformatshow)#">
<cfset str = datevalue>
 
<CF_DateConvert Value="#dateformat(Period.PayrollEnd,client.dateformatshow)#">
<cfset end = datevalue>

<cf_assignId>

<cftransaction>

<cfif url.ajaxid eq "">
	
	<cfquery name="Insert" 
		datasource="AppsPayroll" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">			
		INSERT INTO Organization.dbo.OrganizationAction
	        	(OrgUnitActionId,OrgUnit,CalendarDateStart,CalendarDateEnd,WorkAction,Remarks,OfficerUserId,OfficerLastName,OfficerFirstName)
		VALUES	('#rowguid#',
				 '#url.orgunit#',
				 #str#,#end#,
				 '#form.salaryschedule#',
				 '#form.remarks#',
				 '#session.acc#','#session.last#','#session.first#')
	</cfquery>	
	
	<cfloop index="per" list="#Form.PersonNo#">
	
	    <cfparam name = "Form.Amount_#per#" default="">
		<cfparam name = "Form.documentReference_#per#" default="">
	    <cfset amt    = evaluate("Form.Amount_#per#")>
		<cfset amt    = replace("#amt#",",","")>
		<cfset mem    = evaluate("Form.documentReference_#per#")> 
		
		<cfif amt neq "" and amt neq "0">
		
			<cfquery name="Insert" 
				datasource="AppsPayroll" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">			
				INSERT INTO PersonMiscellaneous
				     (PersonNo, Mission, EntityClass,DateEffective, DateExpiration, DocumentDate, DocumentReference, 
					  PayrollItem, PayrollStart, EntitlementClass, Quantity, Currency, Rate, Amount,
					  Source, SourceId, OfficerUserId, OfficerLastName, OfficerFirstName)	
				VALUES	
					 ('#per#','#org.mission#',NULL,#str#,#end#,getdate(),'#mem#',
					 '#form.payrollitem#',#end#,'#form.entitlementclass#','1','#schedule.paymentcurrency#','#amt#','#amt#',
					 'unit','#rowguid#','#session.acc#','#session.last#','#session.first#')
					 
			</cfquery>	
		
		</cfif>
	
	</cfloop>
	
<cfelse>

	<cfquery name="update" 
		datasource="AppsPayroll" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">			
		UPDATE Organization.dbo.OrganizationAction
		SET    Remarks  = '#form.remarks#'
		WHERE  OrgUnitActionId = '#url.ajaxid#' 								 
	</cfquery>	

	<cfloop index="per" list="#Form.PersonNo#">
	
	    <cfparam name = "Form.Amount_#per#" default="">
		<cfparam name = "Form.documentReference_#per#" default="">
	    <cfset amt    = evaluate("Form.Amount_#per#")>
		<cfset amt    = replace("#amt#",",","")>
		<cfset mem    = evaluate("Form.documentReference_#per#")> 
				
		<cfquery name="check" 
			datasource="AppsPayroll" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">			
			SELECT * FROM PersonMiscellaneous				
			WHERE  Source = 'Unit' 
			AND    SourceId = '#url.ajaxid#' 
			AND    Personno = '#per#'				 
		</cfquery>	
	
	    <cfif check.recordcount gte "1">
		
			<cfif amt neq "" and amt neq "0">	
			
				<cfquery name="update" 
					datasource="AppsPayroll" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">			
					UPDATE PersonMiscellaneous
					SET    DocumentReference = '#mem#',
					       Rate     = '#amt#',
						   Amount   = '#amt#'
					WHERE  Source   = 'Unit' 
					AND    SourceId = '#url.ajaxid#' 
					AND    Personno = '#per#'				 
				</cfquery>	
			
			<cfelse>
			
				<cfquery name="check" 
					datasource="AppsPayroll" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">			
					DELETE PersonMiscellaneous				
					WHERE  Source = 'Unit' 
					AND    SourceId = '#url.ajaxid#' 
					AND    Personno = '#per#'				 
				</cfquery>	
						
			</cfif>
		
		<cfelse>		
		
			<cfif amt neq "" and amt neq "0">	
		
				<cfquery name="Insert" 
					datasource="AppsPayroll" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">			
					INSERT INTO PersonMiscellaneous
					     (PersonNo, Mission, EntityClass,DateEffective, DateExpiration, DocumentDate, DocumentReference, 
						  PayrollItem, PayrollStart, EntitlementClass, Quantity, Currency, Rate, Amount,
						  Source, SourceId, OfficerUserId, OfficerLastName, OfficerFirstName)	
					VALUES	
						 ('#per#','#org.mission#',NULL,#str#,#end#,getdate(),'#mem#',
						 '#form.payrollitem#',#end#,'#form.entitlementclass#','1','#schedule.paymentcurrency#','#amt#','#amt#',
						 'unit','#url.ajaxid#','#session.acc#','#session.last#','#session.first#')
						 
				</cfquery>	
			
			</cfif>
		
		</cfif>
			
		
	
	</cfloop>

     


</cfif>	

</cftransaction>

<!--- refresh the detail screen and show the workflow --->

<cfinclude template="CommissionListingDetail.cfm">