<cfquery name="qEvents" 
    datasource="AppsMaterials"  
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT  EC.EventCode, AE.Description 
	FROM    Ref_AssetEventCategory EC INNER JOIN Ref_AssetEvent AE ON EC.EventCode = AE.Code
	WHERE   EC.Category = '#URL.Category#' AND EC.ModeIssuance = '0' 	
</cfquery>

<CF_DateConvert Value="#URL.adate#">
<cfset tDate = dateValue>	

<cfloop query="qEvents">

	<cfset hour         = Evaluate("FORM.#qEvents.EventCode#_hour")>
	<cfset minute       = Evaluate("FORM.#qEvents.EventCode#_minute")>
	<cfset EventDetails = Evaluate("FORM.#qEvents.EventCode#_details")>
	
    <cfset vDate = DateAdd("h", hour, tDate)>		
    <cfset vDate = DateAdd("n", minute, vDate)>
	
	<cfif EventDetails neq "" and vDate neq "">
		<cfquery name = "qInsertMetric" 
	     datasource="AppsMaterials" 
	     username="#SESSION.login#" 
	     password="#SESSION.dbpw#">
			 DELETE AssetItemEvent
			 WHERE  AssetId          = '#URL.aid#'
			 AND    EventCode        = '#qEvents.EventCode#'
			 AND    DateTimePlanning = #vDate#
		 </cfquery>	
		
		<cfquery name = "qInsertMetric" 
	     datasource="AppsMaterials" 
	     username="#SESSION.login#" 
	     password="#SESSION.dbpw#">
			INSERT INTO AssetItemEvent
		    	 ( AssetId, 
				   EventCode, 
				   DateTimePlanning, 
				   EventDetails, 
				   TransactionId, 
				   ActionStatus, 
				   OfficerUserId,
				   OfficerLastName,
				   OfficerFirstName)
			VALUES ('#URL.aid#',
			       '#qEvents.EventCode#',
				   #vDate#,
				   '#EventDetails#',
				   NULL,
				   '1',
				   '#SESSION.acc#',
				   '#SESSION.last#',
				   '#SESSION.first#')
		</cfquery>		
	</cfif>	
	


	
</cfloop>	