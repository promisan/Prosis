<cfparam name="URL.triggercode"  default="">
<cfparam name="URL.eventid"  default="">
<cfparam name="URL.mission" default="">

<cfquery name="getTrigger" 
		 datasource="AppsEmployee" 
		 username="#SESSION.login#" 
		 password="#SESSION.dbpw#">
			 SELECT * 
			 FROM   Ref_EventTrigger
			 WHERE  Code = '#URL.TriggerCode#'
</cfquery>		 

<cfif URL.eventId neq "">

	<cfquery name="qEvent" 
		 datasource="AppsEmployee" 
		 username="#SESSION.login#" 
		 password="#SESSION.dbpw#">
			 SELECT * 
			 FROM   PersonEvent
			 WHERE  EventId = '#URL.eventId#'
	</cfquery>		 

<cfelse>
	<cfquery name="qEvent" 
		 datasource="AppsEmployee" 
		 username="#SESSION.login#" 
		 password="#SESSION.dbpw#">
			 SELECT * 
			 FROM   PersonEvent
			 WHERE  1=0
	</cfquery>		
</cfif>	

<cfquery name="qEvents" 
	 datasource="AppsEmployee" 
	 username="#SESSION.login#" 
	 password="#SESSION.dbpw#">
		SELECT Code,
		       Description
		FROM   Ref_PersonEvent RPE 
		WHERE  Code IN (SELECT EventCode 
		                FROM   Ref_PersonEventTrigger 
						WHERE  EventTrigger = '#url.triggercode#')
		<cfif URL.mission neq "">
			AND    Code IN (SELECT PersonEvent 
			                FROM   Ref_PersonEventMission 
							WHERE  Mission  = '#URL.mission#')
		</cfif>		
		ORDER BY ListingOrder		
</cfquery>
	
<select name="eventcode" id="eventcode" class="regularxl" style="width:300px" 
    onchange="_cf_loadingtexthtml='';ptoken.navigate('<cfoutput>#SESSION.root#</cfoutput>/Staffing/Application/Employee/Events/getReason.cfm?triggercode='+document.getElementById('triggercode').value+'&eventcode='+this.value+'&eventid=','dReason')">
	<option value=""><cf_tl id="Please select">...</option>
	<cfoutput query="qEvents">
		<option value="#Code#" <cfif Code eq qEvent.EventCode>selected</cfif>>#Description#</option>
	</cfoutput>
<select>

<cfoutput>		

<cfloop list="PersonContract,VacCandidate,Requisition" index="itm">
	
	<cfif getTrigger.entitycode eq itm>
			<script>		    
				se = document.getElementsByName('#itm#')	
				i = 0
				while (se[i]) {			  
				  se[i].className = "labelmedium"
				  i++ }
			</script>
			
			<cfif itm eq "Requisition">
				<script>		    
					se = document.getElementsByName('VacCandidate')	
					i = 0
					while (se[i]) {			  
					  se[i].className = "labelmedium"
					  i++ }
				</script>
			</cfif>	 			
		
	<cfelse>
	
		<script>		    
			se = document.getElementsByName('#itm#')
			i = 0
			while (se[i]) {
			  se[i].className = "hide"
			  i++ }
		</script>
			
	</cfif>

</cfloop>

</cfoutput>	

<cfset AjaxOnLoad("checkreason")>