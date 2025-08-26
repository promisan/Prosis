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

<!--- assign a modification --->

<cftransaction>

<cfparam name="Form.Workgroup" default="">

<!--- Don't think this is needed anymore, dev: 24/04/2012
<cfif form.workgroup eq "">

	<script>
		alert("Workflow has not been configured or published.")
	</script>
	<CFABORT>

</cfif>--->

<cfquery name="Last" 
	datasource="AppsControl" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT   TOP 1 *
		FROM     Observation
		WHERE    Owner = '#Form.Owner#'		
		ORDER BY ObservationNo DESC
</cfquery>

<cfif last.recordcount eq "0">
	<cfset la = 1>
	<cfset ref = "#Form.Owner#000#la#">
<cfelse>
	<cfset la = last.observationNo+1>

	<cfif len(la) eq "1">
		<cfset ref = "#Form.Owner#000#la#">
	<cfelseif len(la) eq "2">
	    <cfset ref = "#Form.Owner#00#la#">
	<cfelseif len(la) eq "3">
	    <cfset ref = "#Form.Owner#0#la#">
	<cfelse>
	    <cfset ref = "#Form.Owner#0#la#">	
	</cfif>

</CFIF>

<!--- check if exists --->

<cfquery name="get" 
	datasource="AppsControl" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT   *
		FROM     Observation
		WHERE    ObservationId = '#Form.ObservationId#'				
</cfquery>

<cfset dateValue = "">
<CF_DateConvert Value="#Form.ObservationDate#">
<cfset DTE = dateValue>		

<cfif get.recordcount eq "0">

	<cfquery name="Logging" 
		 datasource="AppsControl" 
		 username="#SESSION.login#" 
		 password="#SESSION.dbpw#">
		 INSERT INTO Observation
				  (ObservationId,
				   Owner,			   
				   Reference,
				   ObservationNo, 
				   ObservationClass,
				   <cfif url.observationclass eq "Inquiry">
				   Mission,
				   ApplicationServer,
				   </cfif>
				   SystemModule, 
				   RequestName, 
				   Requester,
				   RequestPriority,
				   ObservationDate,
				   ObservationFrequency,
				   ObservationImpact,
				   ObservationOutline,
				   OfficerUserId, 
				   OfficerLastName, 
				   OfficerFirstName)
		 VALUES   ('#Form.ObservationId#',
		           '#Form.Owner#', 
				   '#Ref#',
		           '#La#', 
				   '#url.observationclass#',
	   			   <cfif url.observationclass eq "Inquiry">
				   '#Form.Mission#',
				   '#Form.ApplicationServer#',
				   </cfif>
				   '#Form.SystemModule#', 
				   '#Form.RequestName#',
				   '#form.Requester#',
				   '#Form.RequestPriority#',
				   #dte#,
				   '#Form.ObservationFrequency#',
				   '#Form.ObservationImpact#',
				   '#Form.ObservationOutline#',
				   '#SESSION.acc#', 
				   '#SESSION.last#', 
				   '#SESSION.first#'
				   )		
	</cfquery>	
	
</cfif>	

<!--- check if wf exists --->

</cftransaction>

<cfif get.recordcount neq 0>

	<cf_alert message="We detected a problem with your submission. Please close this screen and resubmit it">
	<script language="JavaScript">
		parent.window.close()
		Prosis.busy('no')
	</script>
    <cfabort>	

<cfelse>

	<!--- establish the workflow object --->	
	
	<cfset link = "System/Modification/DocumentView.cfm?id=#Form.ObservationId#">
	
	<cfif url.observationclass eq "Inquiry">
	
		<cfset entitycode = "SysTicket">		
			
		<cf_ActionListing 
			EntityCode       = "#entitycode#"
			EntityGroup      = "#Form.rapplication#"
			EntityClass      = "#Form.EntityClass#"
			EntityStatus     = "0"		
			PersonEMail      = "#Form.eMail#"
			ObjectReference  = "#Form.rapplication# Ticket No: #Ref#"
			ObjectReference2 = "#SESSION.first# #SESSION.last#"
			ObjectKey4       = "#Form.ObservationId#"
			ObjectURL        = "#link#"
			Show             = "No"
			Toolbar          = "No"
			Framecolor       = "ECF5FF"
			CompleteFirst    = "No">	
		
	<cfelse>
	
		<cfset entitycode = "SysChange">	
			
		<cf_ActionListing 
			EntityCode       = "#entitycode#"
			EntityGroup      = "#Form.amendWorkgroup#"
			EntityClass      = "#Form.EntityClass#"
			EntityStatus     = "0"		
			PersonEMail      = "#Form.eMail#"
			ObjectReference  = "Amendment for #Form.SystemModule# No: #Ref#"
			ObjectReference2 = "#SESSION.first# #SESSION.last#"
			ObjectKey4       = "#Form.ObservationId#"
			ObjectURL        = "#link#"
			Show             = "No"
			Toolbar          = "No"
			Framecolor       = "ECF5FF"
			CompleteFirst    = "No">	
	</cfif>
	
</cfif>

<cfoutput>	

	<cfset oSecurity = CreateObject("component","Service.Process.System.UserController")/>
	<cfset mid = oSecurity.gethash()/>      			
				 
	<script>		
	   
		try {	
		parent.opener.applyfilter('','','content') } 
		catch(e) {}
		parent.ptoken.location('DocumentView.cfm?mid=#mid#&drillid=#form.observationid#')
		
	</script>

</cfoutput>


