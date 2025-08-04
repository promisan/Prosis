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
	
<cfquery name="Delete" 
    datasource="AppsEmployee" 
    username="#SESSION.login#" 
    password="#SESSION.dbpw#">
	DELETE FROM PersonWorkSchedule
	WHERE PersonNo      = '#Form.PersonNo#'
	AND   DateEffective = #STR#
	AND   Mission       = '#form.mission#'
</cfquery>

<cfquery name="Delete" 
    datasource="AppsEmployee" 
    username="#SESSION.login#" 
    password="#SESSION.dbpw#">
	DELETE FROM PersonWorkSchedule
	WHERE PersonNo   = '#Form.PersonNo#'
	AND   Contractid = '#Form.ContractId#'	
</cfquery>
		  
<cfloop index="day" list="#form.dayhour#" delimiters="-">

	<cfset cnt = 1>
	
	<cfloop index="itm" list="#day#" delimiters="_">
	
	   <cfif cnt eq "1">
	   	  <cfset day = itm>
	   <cfelseif cnt eq "2">
	   	  <cfset hr  = itm>	
	   <cfelse>
	      <cfset sl  = itm>	
	   </cfif>
	   <cfset cnt = cnt +1>
	
	</cfloop>   
		   
	<cfif hr neq "">
		  
	  <cftry>
	    
			  <cfquery name="Update" 
			    datasource="AppsEmployee" 
			    username="#SESSION.login#" 
			    password="#SESSION.dbpw#">
			    INSERT PersonWorkSchedule
				(PersonNo,DateEffective,Mission,Weekday,CalendarDateHour,CalendarDateSlot,Hourslots,ContractId,OfficerUserId,OfficerLastName,OfficerFirstName)
				VALUES
				('#Form.PersonNo#',#STR#,'#FORM.mission#','#day#','#hr#','#sl#','2','#form.contractid#','#SESSION.acc#','#SESSION.last#','#SESSION.first#')
			  </cfquery>
			  
	  <cfcatch></cfcatch>
	  </cftry>
		  
	</cfif>	  
	 
</cfloop>  
