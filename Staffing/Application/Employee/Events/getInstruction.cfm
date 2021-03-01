
<cfquery name="getInstruction" 
	 datasource="AppsEmployee" 
	 username="#SESSION.login#" 
	 password="#SESSION.dbpw#">
		SELECT *
		FROM   Ref_PersonEventMission 
		WHERE  PersonEvent    = '#url.eventcode#'
		AND    Mission = '#url.mission#'			
</cfquery>

<table style="width:100%">
<tr><td><cfoutput>#getInstruction.Instruction#</cfoutput></td></tr></table>
