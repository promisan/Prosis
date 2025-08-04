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
		TopicValue, 
		OfficerUserId, 
		OfficerLastName, 
		OfficerFirstName)
	VALUES 		
	('#CLIENT.PersonNo#',
	'#URL.Code#',
	'#URL.Value#',
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


<cfquery name = "PMA" 
	datasource= "AppsEmployee"
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	INSERT INTO PersonMedicalAction (
		PersonNo, 
		Topic, 
		TopicValue,
		DateEffective, 
		OfficerUserId, 
		OfficerLastName, 
		OfficerFirstName)
	VALUES 		
	('#CLIENT.PersonNo#',
	'#URL.Code#',
	'#URL.Value#',
	'#DateFormat(now(),CLIENT.DateSQL)#',
	'#SESSION.acc#',
	'#SESSION.last#',
	'#SESSION.first#')
</cfquery>



