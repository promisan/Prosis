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

<!--- withdraw script --->

<cfparam name="Form.Mentor" default="">

<cfif Form.Mentor neq "">
	
	<cfquery name="reset" 
	 datasource="AppsSelection" 
	 username="#SESSION.login#" 
	 password="#SESSION.dbpw#">
		 DELETE FROM ApplicantMentor
		 WHERE DocumentNo = '#Form.Key1#'	
	</cfquery>
	
	<cfif Form.Mentor neq "">
	
		<cfquery name="Insert" 
			 datasource="AppsSelection" 
			 username="#SESSION.login#" 
			 password="#SESSION.dbpw#">
			 INSERT INTO ApplicantMentor
			 (Personno,MentorPersonNo,DateEffective,DocumentNo,OfficerUserid,OfficerLastName,OfficerFirstName)
			 VALUES
			 ('#Form.Key2#',
			  '#Form.Mentor#',
			  '#dateformat(now(),client.dateformatshow)#',
			  '#Form.Key1#',
			  '#session.acc#',
			  '#session.last#',
			  '#session.first#')	
			</cfquery>	
	
	</cfif>

</cfif>

