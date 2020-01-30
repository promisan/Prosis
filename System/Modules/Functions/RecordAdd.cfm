
<cfparam name="URL.ID" default="">
			
	<cfquery name="Delete" 
	datasource="AppsSystem" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    DELETE FROM Ref_ReportControl
	    WHERE SystemModule is NULL
		AND OfficerUserId = '#SESSION.acc#'
	</cfquery>
			
	<cfquery name="Insert" 
	datasource="AppsSystem" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	   INSERT INTO Ref_ReportControl 
	          (Operational, OfficerUserId, OfficerLastName, OfficerFirstName, Created)
	VALUES ('0','#SESSION.acc#', '#SESSION.last#', '#SESSION.first#', getDate())
	</cfquery>
	
	<cfquery name="Check" 
	datasource="AppsSystem" 
	maxrows=1
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT ControlId
		FROM   Ref_ReportControl
	    WHERE  SystemModule is NULL
		  AND  OfficerUserId = '#SESSION.acc#'
		ORDER BY Created DESC
	</cfquery>
	
	<cflocation url="RecordEdit.cfm?ID=#Check.ControlId#" addtoken="No">
