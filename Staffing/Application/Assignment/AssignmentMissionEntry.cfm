
<cfparam name="Attributes.PersonNo" default = "">
<cfparam name="Attributes.Mission"  default = "">

<cfquery name="GetAssignments" 
	 datasource="AppsEmployee" 
	 username="#SESSION.login#" 
	 password="#SESSION.dbpw#">
		SELECT   *
		FROM     PersonAssignment A INNER JOIN
	             Position P ON A.PositionNo = P.PositionNo INNER JOIN
	             PositionParent PP ON P.PositionParentId = PP.PositionParentId AND P.PositionParentId = PP.PositionParentId INNER JOIN
	             Organization.dbo.Organization O ON PP.OrgUnitOperational = O.OrgUnit
		WHERE    O.Mission  = '#Attributes.Mission#'
		AND      A.PersonNo = '#Attributes.PersonNo#'	
		AND      A.AssignmentStatus IN ('0','1')
		AND      A.Incumbency > 0
		AND      A.DateExpiration >= A.DateEffective
		ORDER BY A.PersonNo, A.DateEffective DESC	
</cfquery>


<cfset arrival   = "">
<cfset departure = "">

<cfoutput query="GetAssignments">

	<cfif arrival eq "" or dateadd("d",1,DateExpiration) eq arrival>
		<cfset arrival = DateEffective>
	</cfif>

	<cfif departure eq "">
		<cfset departure = DateExpiration>
	</cfif>

</cfoutput>

<cfquery name="PersonMission" 
	 datasource="AppsEmployee" 
	 username="#SESSION.login#" 
	 password="#SESSION.dbpw#">

		SELECT *
		FROM   PersonMission
		WHERE  PersonNo = '#Attributes.PersonNo#'
		AND    Mission  = '#Attributes.Mission#'

</cfquery>

<cfif PersonMission.RecordCount eq 0>
	
	<cfquery name="Insert" 
	 datasource="AppsEmployee" 
	 username="#SESSION.login#" 
	 password="#SESSION.dbpw#">

		INSERT INTO PersonMission 
				(PersonNo, 
				 Mission,
				 DateArrival, 
				 DateDeparture,
				 OfficerUserId,
				 OfficerLastName,
				 OfficerFirstName)
		VALUES('#Attributes.PersonNo#',
		       '#Attributes.Mission#',
			   '#arrival#',
			   '#departure#',
			   '#SESSION.acc#',
			   '#SESSION.last#',
			   '#SESSION.first#')
		
	</cfquery>
	
<cfelse>

	<cfquery name="Update" 
	 datasource="AppsEmployee" 
	 username="#SESSION.login#" 
	 password="#SESSION.dbpw#">

		UPDATE PersonMission
		SET    DateArrival   = '#arrival#', 
		       DateDeparture = '#departure#'
		WHERE  PersonNo     = '#Attributes.PersonNo#'
		AND    Mission      = '#Attributes.Mission#'
			
	</cfquery>
	
</cfif>
