<cfparam name="URL.RequestId" default="">

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

<cfquery name="qTriggers" 
	datasource="AppsEmployee" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT   Code,
		         Description,
		         ListingOrder,
		         OfficerUserId,
		         OfficerLastName,
		         OfficerFirstName,
		         Created
		FROM     Ref_EventTrigger
		WHERE    Code IN (
				  	SELECT  EventTrigger
					FROM    Ref_PersonEventTrigger ET INNER JOIN 
					        Ref_PersonEvent PE         ON  ET.EventCode=PE.Code INNER JOIN 
							Ref_PersonEventMission REM ON  REM.PersonEvent=ET.EventCode
					WHERE   REM.Mission='#url.mission#'
					AND     REM.EnablePortal = '1'
		         )
		ORDER BY ListingOrder
</cfquery>
	
<select name="EventTrigger"
        id="EventTrigger" 
		style="width:300px" 
		class="regularxl" 
		onchange="javascript:getevent(this.value)">
		
		<option value="">Please select...</option>
		<cfoutput query="qTriggers">
			<option value="#Code#" <cfif Code eq qRequest.EventTrigger>selected</cfif>>#Description#</option>
		</cfoutput>
		
<select>		

<!---
 cfset AjaxOnLoad("checkevent")
---> 