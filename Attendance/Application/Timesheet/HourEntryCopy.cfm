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
<cfparam name="URL.Date"     default="01/01/1900">
<cfparam name="URL.From"     default="">
<cfparam name="URL.Id"       default="7999">
<cfparam name="URL.cls"      default="">
<cfparam name="URL.cde"      default="">
<cfparam name="URL.hr"       default="">
<cfparam name="URL.context"  default="day">

<!--- 
1. save enties for each different hour
2. update personwork master record summary
3. refresh entry details
--->

<cfset dateValue = "">
<CF_DateConvert Value="#url.date#">
<cfset dte = dateValue>

<cfset dateValue = "">
<CF_DateConvert Value="#url.From#">
<cfset frm = dateValue>

<!--- insert --->

<cfquery name="clean" 
datasource="AppsEmployee" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	DELETE FROM PersonWork
	WHERE	CalendarDate = #dte#
	AND     PersonNo = '#URL.ID#'
</cfquery>

<cfquery name="assign" 
datasource="AppsEmployee" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
  	    SELECT 	P.*, O.OrgUnitName, O.Mission
      	FROM 	PersonAssignment P, 
		       Organization.dbo.Organization O
  		WHERE	P.DateEffective <= #dte# 
		  AND   P.DateExpiration   >= #dte#
		  AND   P.Incumbency       > 0
		  AND   P.AssignmentStatus IN ('0','1')
          AND   P.AssignmentClass = 'Regular'
          AND   P.AssignmentType  = 'Actual'
       	  AND   P.OrgUnit         = O.OrgUnit
  		  AND   P.PersonNo        = '#URL.ID#'
</cfquery>

<!--- reset summary --->

<cftransaction>

<cfloop index="tratpe" list="1,2">
	
	<cfquery name="insertHeader" 
	datasource="AppsEmployee" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
			INSERT INTO	PersonWork
				(PersonNo, 
				OrgUnit,
				CalendarDate,
				TransactionType,
				OfficerUserId,
				OfficerLastName, 
		    	OfficerFirstName )
			VALUES ('#URL.ID#',
			        '#assign.OrgUnit#',
					#dte#,
					'#tratpe#',
					'#SESSION.acc#',
	    		    '#SESSION.last#',
					'#SESSION.first#' )
	</cfquery>
	
	<cfquery name="insertLines" 
	datasource="AppsEmployee" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	
		INSERT INTO PersonWorkDetail
		
				   (PersonNo, 
				    CalendarDate, 
					TransactionType,
					CalendarDateHour,
					HourSlot,
					Hourslots,
					HourSlotMinutes,
					ActionClass,
					ActionCode,
					ActionMemo,
					LocationCode,
					BillingMode,
					BillingPayment,
					ActivityPayment,
					ParentHour,
					OfficerUserId,
				    OfficerLastName, 
			        OfficerFirstName)
				   
		SELECT     PersonNo, 
		           #dte#, 
				   '#tratpe#',
				   CalendarDateHour,				   
				   HourSlot,
				   Hourslots,
				   HourSlotMinutes,
				   ActionClass,
				   ActionCode,
				   ActionMemo,
				   LocationCode,
				   BillingMode,
				   BillingPayment,
				   ActivityPayment,
				   ParentHour,
				   '#SESSION.acc#',	
				   '#SESSION.last#', 
				   '#SESSION.first#'
				   
		FROM       PersonWorkDetail
		WHERE	   CalendarDate    = #frm#
		AND        PersonNo        = '#URL.ID#' 
		AND        TransactionType = '1'
		
	</cfquery>
	
</cfloop>	

</cftransaction>

<!--- calculate summary --->

<cf_summaryCalculation
	 personNo = "#URL.ID#"
	 date="#dte#">

<!--- refresh the cell of that person and date --->

<cfoutput>
	<script>	
	 try {					      			 
		 opener.opendaterefresh('#URL.id#','#day(dte)#','#month(dte)#','#year(dte)#')									
	  } catch(e) {}
	</script>
</cfoutput>
	 
<cfif url.context eq "day">	 

	<cfinclude template="DayViewListing.cfm">
	<cfoutput>
		<script>
			sum('#url.date#')	
		</script>
	</cfoutput>
	
<cfelseif url.context eq "week">

	<cfinclude template="WeekView.cfm">

</cfif>	
