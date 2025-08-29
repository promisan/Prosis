<!--
    Copyright © 2025 Promisan B.V.

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
<cfquery name="getInstruction" 
	 datasource="AppsEmployee" 
	 username="#SESSION.login#" 
	 password="#SESSION.dbpw#">
		SELECT *
		FROM   Ref_PersonEventMission 
		WHERE  PersonEvent    = '#url.eventcode#'
		AND    Mission = '#url.mission#'			
</cfquery>

<table style="width:98%">
<tr><td style="padding-top:8px;padding-left:10px;padding-right:5px"><cfoutput>#getInstruction.Instruction#</cfoutput></td></tr></table>
