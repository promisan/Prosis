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

<cfparam name="url.toggle" default="0">

<cfif URL.toggle eq "1">
	
	<cfquery name="Mission"
		datasource="AppsLedger" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			INSERT INTO Ref_AccountMission 
			(Mission,GLAccount,OfficerUserId,OfficerLastName,OfficerFirstName)
			VALUES ('#URL.Mission#','#URL.GLAccount#','#SESSION.acc#','#SESSION.last#','#SESSION.first#')
	</cfquery>

<cfelse>
	
	<cfquery name="Mission"
		datasource="AppsLedger" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			DELETE FROM Ref_AccountMission 
			WHERE  Mission = '#URL.Mission#' 
			AND    GLAccount = '#URL.GLAccount#'
	</cfquery>

</cfif>

<!--- update --->

<cfquery name="Mission"
	datasource="AppsLedger" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT  GLAccount 
		FROM    Ref_AccountMission 
		WHERE   Mission = '#URL.Mission#' 
		AND     GLAccount = '#URL.GLAccount#'
</cfquery>

<cfoutput>

	<cfif mission.recordcount eq "1">
				 
		 <img src="#SESSION.root#/Images/light_red1.gif"
			 border="0" alt="activate"
			 align="absmiddle"
			 style="cursor: pointer;" onClick="toggle('#URL.mission#','#URL.GLAccount#','1')">
			 
	<cfelse>
				 
		  <img src="#SESSION.root#/Images/light_green1.gif"
			 border="0" alt="deactivate"
			 align="absmiddle"
			 style="cursor: pointer;" onClick="toggle('#URL.mission#','#URL.GLAccount#','0')">
				
	</cfif>
			
</cfoutput>	
