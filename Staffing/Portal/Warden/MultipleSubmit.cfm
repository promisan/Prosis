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
<cfparam name = "URL.action" default = "select">

<cfswitch expression="#URL.action#">
<cfcase value =  "unselect">

	<cfquery name = "Init" 
		datasource= "AppsEmployee"
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		DELETE FROM PersonMedicalStatus
		WHERE PersonNo = '#Client.PersonNo#'
		AND   Topic    = '#URL.Code#'
		AND   ListCode = '#URL.ListCode#'
	</cfquery>

	<cfquery name = "Update_PMA" 
		datasource= "AppsEmployee"
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		UPDATE PersonMedicalAction 
		SET DateExpiration = '#DateFormat(now(),CLIENT.DateSQL)#'
		WHERE PersonNo = '#Client.PersonNo#'
		AND   Topic    = '#URL.Code#'
		AND   ListCode = '#URL.ListCode#'		
	</cfquery>
	
	
	<cfquery name = "Delete_PMA"
		datasource= "AppsEmployee"
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		DELETE FROM PersonMedicalAction
		WHERE PersonNo = '#Client.PersonNo#'
		AND   Topic    = '#URL.Code#'
		AND   ListCode = '#URL.ListCode#'	
		AND   DateEffective = DateExpiration
	</cfquery>	
	
</cfcase>	
<cfcase value =  "none">
			<cfquery name = "Init" 
				datasource= "AppsEmployee"
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				DELETE FROM PersonMedicalStatus
				WHERE PersonNo = '#Client.PersonNo#'
				AND   Topic    = '#URL.Code#'
			</cfquery>		

			<cfquery name = "PS" 
				datasource= "AppsEmployee"
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				INSERT INTO PersonMedicalStatus (
					PersonNo, 
					Topic, 
					OfficerUserId, 
					OfficerLastName, 
					OfficerFirstName)
				VALUES 		
				('#CLIENT.PersonNo#',
				'#URL.Code#',
				'#SESSION.acc#',
				'#SESSION.last#',
				'#SESSION.first#')
			</cfquery>
			
			<cfquery name = "Update_PMA" 
				datasource= "AppsEmployee"
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				UPDATE PersonMedicalAction 
				SET DateExpiration = '#DateFormat(now(),CLIENT.DateSQL)#'
				WHERE PersonNo = '#Client.PersonNo#'
				AND   Topic    = '#URL.Code#'
			</cfquery>
	
	
			<cfquery name = "Delete_PMA" 
				datasource= "AppsEmployee"
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				DELETE FROM PersonMedicalAction
				WHERE PersonNo = '#Client.PersonNo#'
				AND   Topic    = '#URL.Code#'
				AND   DateEffective = DateExpiration
			</cfquery>	
</cfcase>				
<cfdefaultcase>


		<cfquery name = "dNone" 
			datasource = "AppsEmployee"
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			DELETE PersonMedicalStatus
			WHERE 
			PersonNo = '#Client.PersonNo#'
			AND Topic = '#URL.Code#'
			AND ListCode IS NULL
		</cfquery>


		<cfquery name = "qTopicValue" 
			datasource = "AppsEmployee"
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			SELECT RT.ListValue
			FROM Ref_TopicList RT 
			WHERE 
			RT.Code = '#URL.Code#'
			AND RT.ListCode = '#URL.ListCode#'
		</cfquery>
		
		<cfquery name = "check" 
			datasource = "AppsEmployee"
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			SELECT * 
			FROM PersonMedicalStatus
			WHERE Topic = '#URL.Code#'
			AND ListCode = '#URL.ListCode#'
			AND PersonNo = '#CLIENT.PersonNo#'
		</cfquery>
		
		<cfif check.recordcount eq 0>
				<cfquery name = "PS" 
					datasource= "AppsEmployee"
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
					INSERT INTO PersonMedicalStatus (
						PersonNo, 
						Topic, 
						ListCode, 
						TopicValue, 
						OfficerUserId, 
						OfficerLastName, 
						OfficerFirstName)
					VALUES 		
					('#CLIENT.PersonNo#',
					'#URL.Code#',
					'#URL.ListCode#',
					'#qTopicValue.ListValue#',
					'#SESSION.acc#',
					'#SESSION.last#',
					'#SESSION.first#')
				</cfquery>
		</cfif>
		
		
		<cfquery name = "check_PMA" 
			datasource = "AppsEmployee"
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			SELECT * 
			FROM PersonMedicalAction
			WHERE Topic = '#URL.Code#'
			AND ListCode = '#URL.ListCode#'
			AND PersonNo = '#CLIENT.PersonNo#'
			AND DateEffective = '#DateFormat(now(),CLIENT.DateSQL)#'
		</cfquery>
		
		
		<cfif check_PMA.recordcount eq 0>
				<cfquery name = "PMA" 
					datasource= "AppsEmployee"
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
					INSERT INTO PersonMedicalAction (
						PersonNo, 
						Topic, 
						ListCode, 
						TopicValue,
						DateEffective, 
						OfficerUserId, 
						OfficerLastName, 
						OfficerFirstName)
					VALUES 		
					('#CLIENT.PersonNo#',
					'#URL.Code#',
					'#URL.ListCode#',
					'#qTopicValue.ListValue#',
					'#DateFormat(now(),CLIENT.DateSQL)#',
					'#SESSION.acc#',
					'#SESSION.last#',
					'#SESSION.first#')
				</cfquery>
		</cfif>
		
</cfdefaultcase>
</cfswitch>
