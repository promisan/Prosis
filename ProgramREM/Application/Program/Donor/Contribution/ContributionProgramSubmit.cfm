
<cfquery name="get" 
    datasource="AppsProgram">
	SELECT * 
	FROM   ProgramPeriod
	WHERE  ProgramId = '#URL.programid#'	
</cfquery>

<cfquery name="qCheck" 
    datasource="AppsProgram">
	SELECT * 
	FROM   ContributionProgram
	WHERE  ContributionId = '#URL.scope#'
	AND    ProgramCode = '#get.ProgramCode#'
</cfquery>

<cfif qCheck.recordcount eq 0>
	
	<cfquery name="qProgram" datasource="AppsProgram">
		INSERT INTO ContributionProgram
	           (ContributionId
	           ,ProgramCode
	           ,OfficerUserId
			   ,OfficerLastName
	           ,OfficerFirstName)
	     VALUES
	           ('#URL.scope#'
	           ,'#get.ProgramCode#'
	           ,'#SESSION.acc#'
	           ,'#SESSION.last#'
	           ,'#SESSION.first#')
	</cfquery>
	
<cfelse>

	<cfoutput>
		<script>
			alert('Contribution is already associated to the program #get.Reference#');
		</script>
	</cfoutput>
	
</cfif>

<cfset url.contributionid = url.scope>

<cfinclude template = "ContributionProgram.cfm">
