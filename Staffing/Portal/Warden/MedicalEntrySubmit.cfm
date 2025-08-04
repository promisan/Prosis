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
<cfquery name = "qTopicValue" 
	datasource = "AppsEmployee"
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT RT.ListValue
	FROM Ref_TopicList RT 
	WHERE 
	RT.Code = '#FORM.Code#'
	AND RT.ListCode = '#FORM.ListCode#'
</cfquery>


<cfset dateValue = "">
<CF_DateConvert Value="#Form.DateEffective#">
<cfset STR = dateValue>

<cfset dateValue = "">
<CF_DateConvert Value="#Form.DateExpiration#">
<cfset END = dateValue>


<cfquery name = "qTopicValue" 
	datasource = "AppsEmployee"
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT RT.ListValue
	FROM Ref_TopicList RT 
	WHERE 
	RT.Code = '#FORM.Code#'
	AND RT.ListCode = '#FORM.ListCode#'
</cfquery>

<cfquery name = "check" 
	datasource = "AppsEmployee"
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT * 
	FROM PersonMedicalStatus
	WHERE Topic = '#FORM.Code#'
	AND ListCode = '#FORM.ListCode#'
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
			'#FORM.Code#',
			'#FORM.ListCode#',
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
	WHERE Topic = '#FORM.Code#'
	AND ListCode = '#FORM.ListCode#'
	AND PersonNo = '#CLIENT.PersonNo#'
	AND DateEffective = #STR#
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
				DateExpiration, 
				Remarks,
				OfficerUserId, 
				OfficerLastName, 
				OfficerFirstName)
			VALUES 		
			('#CLIENT.PersonNo#',
			'#FORM.Code#',
			'#FORM.ListCode#',
			'#qTopicValue.ListValue#',
			#STR#,
			#END#,
			'#FORM.Remarks#',
			'#SESSION.acc#',
			'#SESSION.last#',
			'#SESSION.first#')
		</cfquery>
</cfif>


<script>	     
		 parent.ColdFusion.Window.hide('MDetails')
		 parent.history.go()
</script>	
