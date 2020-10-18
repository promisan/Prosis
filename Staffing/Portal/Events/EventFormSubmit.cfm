
<!--- form of events --->

<cf_assignid>

<cfset dateValue = "">
<CF_DateConvert Value="#dateformat(now(),client.dateformatshow)#">
<cfset dte = dateValue>

<cfset dateValue = "">
<CF_DateConvert Value="#Form.ActionDateEffective#">
<cfset eff = dateValue>

<cfset dateValue = "">
<CF_DateConvert Value="#Form.ActionDateExpiration#">
<cfset exp = dateValue>

<cfquery name="qInsert" 
	 datasource="AppsEmployee" 
	 username="#SESSION.login#" 
	 password="#SESSION.dbpw#">			 
		INSERT INTO PersonEvent
		          (EventId,
				   EventTrigger,
		           EventCode,
		           PersonNo,
		           Mission,
		           ReasonCode,
		           ReasonListCode,    				   
				   <cfif FORM.OrgUnit neq "">
				   OrgUnit,
				   </cfif>					   
				   <cfif FORM.PositionNo neq "">
				   PositionNo,
				   </cfif>
				   Source,			   
		           DateEvent,
		           DateEventDue,
				   ActionDateEffective,
				   ActionDateExpiration,
		           ActionStatus,			           
		           OfficerUserId,
		           OfficerLastName,
		           OfficerFirstName)
		VALUES  ('#rowguid#',
		         '#FORM.Trigger#',
		         '#FORM.EventCode#',
		         '#FORM.PersonNo#',
		         '#FORM.Mission#',		         
		         '#FORM.Reason#',
		         '#FORM.ReasonList#',				
				 <cfif FORM.OrgUnit neq "">
				     '#FORM.OrgUnit#',
				 </cfif>	
				 <cfif FORM.PositionNo neq "">
			         '#FORM.PositionNo#',
				 </cfif>	 
				 'Portal',				 
		         #dte#,
		         #eff#,
				 #eff#,
				 #exp#,
		         0,			         
		         '#SESSION.acc#',
		         '#SESSION.last#',
		         '#SESSION.first#')
	</cfquery>
	
	<cfset url.personNo       = form.PersonNo>
	<cfset url.mission        = form.Mission>
	<cfset url.trigger        = form.trigger>
	<cfset url.eventcode      = form.eventcode>
	<cfset url.reasoncode     = form.reason>
	<cfset url.reasonlistcode = form.reasonlist>
	
	<cfinclude template="EventBaseReasonWorkflow.cfm">

<script>
		
	ProsisUI.closeWindow('evdialog')

</script>
