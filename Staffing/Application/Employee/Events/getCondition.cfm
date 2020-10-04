
<cfparam name="URL.eventid" default="">
<cfparam name="URL.preason" default="">

<cfif URL.eventId neq "">

	<cfquery name="qCurrentEvent" 
		 datasource="AppsEmployee" 
		 username="#SESSION.login#" 
		 password="#SESSION.dbpw#">
			 SELECT * 
			 FROM   PersonEvent
			 WHERE  EventId = '#URL.eventId#'
	</cfquery>		 

<cfelse>

	<cfquery name="qCurrentEvent" 
		 datasource="AppsEmployee" 
		 username="#SESSION.login#" 
		 password="#SESSION.dbpw#">
			 SELECT * 
			 FROM   PersonEvent
			 WHERE  1=0
	</cfquery>	
		
</cfif>	

<cfquery name="Event" 
	datasource="AppsEmployee" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT *
		FROM   Ref_PersonEvent
		WHERE  Code    = '#URL.eventcode#'		
</cfquery>		

<cfquery name="qEvent" 
	datasource="AppsEmployee" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT *
		FROM   Ref_PersonEventTrigger
		WHERE  EventCode    = '#URL.eventcode#'
		AND    EventTrigger = '#URL.triggercode#'
</cfquery>		 

<cfquery name="qReasons" 
	datasource="AppsEmployee" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT   GroupCode, 
				 GroupListCode, 
				 Description, 
				 GroupListOrder, 
				 Operational, 
				 Created
		FROM     Ref_PersonGroupList
		WHERE 	 GroupCode   = '#qEvent.ConditionCode#' 
		AND      Operational = '1'
		ORDER BY GroupListOrder
</cfquery>	


<cfif qReasons.recordcount neq 0>

    <script>
   	  document.getElementById("conditionbox").className = "labelmedium"
    </script>
    
	<cfoutput>
			
		<select name="conditioncode" id="conditioncode" class="regularxl" style="width:95%">
			<cfloop query="qReasons">
				<option value="#GroupListCode#" <cfif qCurrentEvent.Contractno eq GroupListCode OR GroupListCode eq URL.preason>selected</cfif>>#Description#</option>
			</cfloop>
		<select>			
		<input type="hidden" id="GroupConditionCode" name="GroupConditionCode" value="#qEvent.ConditionCode#">
		
	</cfoutput>
	
<cfelse>

   <script>
   	document.getElementById("conditionbox").className = "hide"	
   </script>
   
	N/A
	<input type="hidden" id="conditioncode" name="conditioncode" value="">
	<input type="hidden" id="GroupConditionCode"  name="GroupConditionCode"  value="">

</cfif>	


