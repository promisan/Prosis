<cfquery name="qCheck" 
    datasource="AppsProgram">
	SELECT * 
	FROM   ContributionLineLocation
	WHERE  ContributionLineId = '#URL.LineId#'
	AND    LocationCode       = '#URL.LocationCode#'
</cfquery>

<cfif qCheck.recordcount eq 0>
	
	<cfquery name="qProgram" datasource="AppsProgram">
		INSERT INTO ContributionLineLocation
	           (ContributionLineId
	           ,LocationCode
	           ,OfficerUserId
			   ,OfficerLastName
	           ,OfficerFirstName)
	     VALUES
	           ('#URL.LineId#'
	           ,'#URL.LocationCode#'
	           ,'#SESSION.acc#'
	           ,'#SESSION.last#'
	           ,'#SESSION.first#')
	</cfquery>

<cfelse>

	<cfoutput>
		<script>
			alert('Line is already associated to the Location #URL.LocationCode#');
		</script>
	</cfoutput>
	
</cfif>

<cfinclude template = "ContributionLineEarmark.cfm">
