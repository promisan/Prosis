<cfparam name="URL.triggercode"  default="">
<cfparam name="URL.requestId"  default="">
<cfparam name="URL.mission" default="">

<cfif URL.requestId neq "">

	<cfquery name="qRequest" 
		 datasource="AppsEmployee" 
		 username="#SESSION.login#" 
		 password="#SESSION.dbpw#">
			SELECT PR.*,E.Description AS EventDescription,PEM.Instruction, ET.EventTrigger, TRI.Description TriggerDescription
			 FROM PersonRequest PR INNER JOIN Ref_PersonEvent E
			 ON E.Code = PR.EventCode INNER JOIN Ref_PersonEventMission PEM
			 ON PEM.PersonEvent = E.Code INNER JOIN Ref_PersonEventTrigger ET
			 ON ET.EventCode= E.Code INNER JOIN Ref_EventTrigger TRI
			 ON TRI.Code = ET.EventTrigger 
			 WHERE PEM.EnablePortal = '1'
			 AND RequestId = '#URL.requestId#'
	</cfquery>		 
	
	<cfset URL.triggercode = qRequest.EventTrigger>

<cfelse>
	<cfquery name="qRequest" 
		 datasource="AppsEmployee" 
		 username="#SESSION.login#" 
		 password="#SESSION.dbpw#">
			SELECT PR.*,E.Description AS EventDescription,PEM.Instruction, ET.EventTrigger, TRI.Description TriggerDescription
			 FROM PersonRequest PR INNER JOIN Ref_PersonEvent E
			 ON E.Code = PR.EventCode INNER JOIN Ref_PersonEventMission PEM
			 ON PEM.PersonEvent = E.Code INNER JOIN Ref_PersonEventTrigger ET
			 ON ET.EventCode= E.Code INNER JOIN Ref_EventTrigger TRI
			 ON TRI.Code = ET.EventTrigger 
			 WHERE PEM.EnablePortal = '1'
			 AND 1 = 0

	</cfquery>		
</cfif>	

<cfquery name="qConditions" 
	 datasource="AppsEmployee" 
	 username="#SESSION.login#" 
	 password="#SESSION.dbpw#">
		SELECT E.Code,
		       E.Description
		FROM   Ref_PersonEvent E INNER JOIN Ref_PersonEventTrigger ET
 			ON ET.EventCode= E.Code
		WHERE  ET.EventTrigger = '#url.triggercode#'
		ORDER BY ListingOrder		
</cfquery>
	
<select name="EventCode" id="EventCode" class="regularxl" style="width:300px">
	<option value=""><cf_tl id="Please select">...</option>
	<cfoutput query="qConditions">
		<option value="#Code#" <cfif Code eq qRequest.EventCode>selected</cfif>>#Description#</option>
	</cfoutput>
<select>
