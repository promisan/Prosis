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
<cfquery name="Insert" 
	datasource="AppsVacancy" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	INSERT INTO DocumentValidation
		(DocumentNo,ValidationCode,OfficerUserId,OfficerLastName,OfficerFirstName)
	VALUES
		('#url.documentNo#','OverwriteSelection','#SESSION.acc#','#SESSION.last#','#SESSION.first#')	
</cfquery>

<cfquery name="Validation" 
		datasource="AppsVacancy" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		    SELECT *
		    FROM  DocumentValidation
			WHERE DocumentNo = '#URL.documentNo#'
			AND   ValidationCode = 'OverwriteSelection'
	</cfquery>			

<cfoutput>

<table cellspacing="0" cellpadding="0">

	<cfif Validation.Recordcount eq "1">

	<tr><td height="20">	
		&nbsp;<font color="red">Candidate selection validation is disabled by <b>#Validation.OfficerFirstName# #Validation.OfficerLastName#</b> on #dateformat(Validation.created, CLIENT.DateFormatShow)#</font>
		</td>
	</tr>	
		
	<cfelse>
		
	<tr><td height="20">	
		 &nbsp;<a href="javascript:ptoken.navigate('#session.root#/Vactrack/Application/Document/DocumentCandidateValidation.cfm?documentNo=#url.documentno#','selectionvalidation')">		 
		 Press here to overwrite the candidate selection limitation		 
		 </a>
		</td>
	</tr>	
	

	</cfif>
</td></tr>
</table>	

</cfoutput>	