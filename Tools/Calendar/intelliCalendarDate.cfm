
<cfparam name="attributes.mode" default="8">

<cfif attributes.mode is "7">
	<cfinclude template="intelliCalendarDate7.cfm">	 		 		 
<cfelse>	
	<cfinclude template="intelliCalendarDate7.cfm">	 
</cfif>

<!---
<cfinclude template="intelliCalendarDate7.cfm">	
---> 