
<cfquery name="getInstruction" 
	 datasource="AppsEmployee" 
	 username="#SESSION.login#" 
	 password="#SESSION.dbpw#">
		SELECT *
		FROM   Ref_PersonEventMission 
		WHERE  PersonEvent    = '#url.eventcode#'
		AND    Mission = '#url.mission#'			
</cfquery>

<table style="width:98%;background-color:f4f4f4">
<tr><td style="padding-top:8px;padding-left:10px;padding-right:5px"><cfoutput>#getInstruction.Instruction#</cfoutput></td></tr></table>
