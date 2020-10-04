
<cfparam name="URL.triggercode"  default="">
<cfparam name="URL.eventid"      default="">
<cfparam name="URL.mission"      default="">
<cfparam name="URL.portal"       default="0">
<cfparam name="URL.personNo"     default="0">
<cfparam name="URL.pevent"     	 default="">
<cfparam name="URL.preason"      default="">

<cfquery name="getTrigger" 
		 datasource="AppsEmployee" 
		 username="#SESSION.login#" 
		 password="#SESSION.dbpw#">
		 SELECT * 
		 FROM   Ref_EventTrigger
		 WHERE  Code = '#URL.TriggerCode#'
</cfquery>		

<cfquery name="getContract" 
	 datasource="AppsEmployee" 
	 username="#SESSION.login#" 
	 password="#SESSION.dbpw#">
		 SELECT   * 
		 FROM     PersonContract
		 WHERE    PersonNo = '#URL.PersonNo#'
		 AND      ActionStatus IN ('0','1')
		 AND      DateEffective < getDate()
		 AND      DateExpiration > getDate()
		 ORDER BY Created DESC
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
		<cfif getContract.ContractType neq "">
		AND    Code IN (SELECT PersonEvent 
			            FROM   Ref_PersonEventContract 
						WHERE  ContractType  = '#getContract.ContractType#')						
		</cfif>
		<cfif url.portal eq "1">
		AND   (EnablePortal = 1 or Code = '#qEvent.EventCode#')
		</cfif>
		ORDER BY ListingOrder		
</cfquery>

<cfif qEvents.recordcount eq "0">
	
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
			<cfif url.portal eq "1">
			AND   (EnablePortal = 1 or Code = '#qEvent.EventCode#')
			</cfif>
			ORDER BY ListingOrder		
	</cfquery>

</cfif>

<select name="eventcode" id="eventcode" class="regularxl" style="width:95%" 
    onchange="_cf_loadingtexthtml='';ptoken.navigate('<cfoutput>#SESSION.root#</cfoutput>/Staffing/Application/Employee/Events/getReason.cfm?triggercode='+document.getElementById('triggercode').value+'&eventcode='+this.value+'&eventid='+'&preason=#url.preason#','dReason')">
	<cfif qEvent.recordcount gt "1">
	<option value=""><cf_tl id="Please select">...</option>
	</cfif>
	<cfoutput query="qEvents">
		<option value="#Code#" <cfif Code eq qEvent.EventCode OR Code eq url.pevent>selected</cfif>>#Description#</option>
	</cfoutput>
<select>

<cfoutput>		

<cfloop list="VacCandidate,Requisition" index="itm">
	
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



