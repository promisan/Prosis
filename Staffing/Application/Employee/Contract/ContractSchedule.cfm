	
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
