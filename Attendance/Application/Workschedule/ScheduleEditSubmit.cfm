
<cfset dateValue = "">
<CF_DateConvert Value="#url.dateeffective#">
<cfset EFF = dateValue>
	
<cfquery name="Delete" 
    datasource="AppsEmployee" 
    username="#SESSION.login#" 
    password="#SESSION.dbpw#">
	DELETE FROM PersonWorkSchedule
	WHERE PersonNo = '#URL.ID#'
	AND   DateEffective = #eff#
	AND   Mission       = '#url.mission#'
</cfquery>
		  
<cfloop index="day" list="#url.ds#" delimiters="-">

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
						(PersonNo,
						 DateEffective,
						 Mission,
						 Weekday,
						 CalendarDateHour,
						 CalendarDateSlot,
						 Hourslots,
						 OfficerUserId,
						 OfficerLastName,
						 OfficerFirstName)
					VALUES
					    ('#URL.ID#',
						  #eff#,
						  '#url.mission#',
						  '#day#',
						  '#hr#',
						  '#sl#',
						  '#url.slots#',
						  '#SESSION.acc#',
						  '#SESSION.last#',
						  '#SESSION.first#')
			  </cfquery>
			  
		<cfcatch></cfcatch>
		</cftry>
		  
	</cfif>	  
	 
</cfloop>  

<cfinclude template="ScheduleEdit.cfm">