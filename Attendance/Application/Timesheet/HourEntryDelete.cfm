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

<cfparam name="URL.Date" default="01/01/1900">
<cfparam name="URL.Id" default="7999">
<cfparam name="URL.cls" default="">
<cfparam name="URL.cde" default="">
<cfparam name="URL.hr" default="">
<cfparam name="URL.slot" default="">
<cfparam name="URL.context" default="Day">

<!--- 
1. save enties for each different hour
2. update personwork master record summary
3. refresh entry details
--->

<cfset dateValue = "">
<CF_DateConvert Value="#url.date#">
<cfset dte = dateValue>

<!--- regardless the transaction type : 1 or 2 --->
	
<cfquery name="Delete" 
  datasource="AppsEmployee" 
  username="#SESSION.login#" 
  password="#SESSION.dbpw#">
      DELETE FROM PersonWorkDetail
	  WHERE  PersonNo        = '#URL.id#'
	  AND    CalendarDate     = #dte#
	  <cfif url.hr neq "">
	  AND    CalendarDateHour = '#url.hr#'
	  AND    HourSlot         = '#url.slot#'
	  </cfif>
</cfquery>

<!--- check if we can remove the header --->

<cfquery name="check" 
  datasource="AppsEmployee" 
  username="#SESSION.login#" 
  password="#SESSION.dbpw#">
      SELECT TOP 1 * FROM PersonWorkDetail
	  WHERE  PersonNo        = '#URL.id#'
	  AND    CalendarDate     = #dte#	 
</cfquery>

<cfif check.recordcount eq "0">
	
	<cfquery name="Delete" 
	  datasource="AppsEmployee" 
	  username="#SESSION.login#" 
	  password="#SESSION.dbpw#">
	      DELETE FROM PersonWork
		  WHERE  PersonNo        = '#URL.id#'
		  AND    CalendarDate     = #dte#	 
	</cfquery>

</cfif>

<!--- reset summary --->

<cfquery name="update" 
	  datasource="AppsEmployee" 
	  username="#SESSION.login#" 
	  password="#SESSION.dbpw#">
		DELETE  PersonWorkClass			
		WHERE	CalendarDate        = #dte#
		AND     PersonNo            = '#URL.ID#'
</cfquery>
	
<!--- calculate summary --->

<cf_summaryCalculation
	 personNo = "#URL.ID#"
	 date="#dte#">
 
<cfif url.context eq "day">	 

	<cfinclude template="DayViewListing.cfm">
	<cfoutput>
		<script>
			sum('#url.date#')	
		</script>
	</cfoutput>
	
<cfelseif url.context eq "week">
	
	<cfoutput>
	
		<!--- refresh the cell of that person and date --->
	
		<script>	
	    
		 try {					      			 
			 opener.opendaterefresh('#URL.id#','#day(dte)#','#month(dte)#','#year(dte)#')									
		  } catch(e) {}
			
		</script>
			
	<cfinclude template="WeekView.cfm">
	
	</cfoutput>

</cfif>	

