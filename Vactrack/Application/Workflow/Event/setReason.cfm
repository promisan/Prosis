
<cfquery name="qEvent" 
	datasource="AppsEmployee" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT ReasonCode
		FROM   Ref_PersonEventTrigger
		WHERE  EventTrigger = '#URL.triggercode#'
		AND    EventCode    = '#URL.eventcode#'   
</cfquery>		 

<cfquery name="qReasons" 
	datasource="AppsEmployee" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT  GroupCode, 
				GroupListCode, 
				Description, 
				GroupListOrder, 
				Operational, 
				Created
		FROM    Ref_PersonGroupList
		WHERE 	GroupCode = '#qEvent.ReasonCode#' AND Operational = '1'
		ORDER BY GroupListOrder
</cfquery>	

<cfoutput>	

<cfif qReasons.recordcount gte "1"> 
	
	<select name="reasoncode" id="reasoncode" class="regularxl">
		<cfloop query="qReasons">
			<option value="#GroupListCode#" <cfif url.ReasonListCode eq GroupListCode>selected</cfif>>#GroupListCode#-#Description#</option>
		</cfloop>
	<select>		
			
	<input type="hidden" id="Reason" name="Reason" value="#qEvent.ReasonCode#">
	
	<script>
	 document.getElementById('reasonbox').className = "labelmedium"
	</script>
	
<cfelse>

	<input type="hidden" id="GroupCode" name="GroupCode"   value="">
	<input type="hidden" id="Reason" name="Reason" value="">
	
	<script>
	 document.getElementById('reasonbox').className = "hide"
	</script>

</cfif>	

</cfoutput>