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

<cfif url.referenceNo neq "Direct">
	
	<cfquery name="Exist" 
		datasource="AppsVacancy" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		  SELECT *
		  FROM   stAnnouncement
		  WHERE  VacancyNo   = '#URL.ReferenceNo#' 
	</cfquery>
	
	<cfquery name="FO" 
			datasource="AppsSelection" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			SELECT *
			FROM  FunctionOrganization
			WHERE ReferenceNo   = '#URL.ReferenceNo#' 
	</cfquery>
	
	<cfif Exist.recordCount eq 0 and FO.recordcount eq "0">
	
		<font color="FF0000">Job opening details must be recorded!</font>
		
	<cfelseif FO.recordcount gte "1">
	
		<font color="FF0000">Job Opening Track has been already issued!</font>
				  
	</cfif>	  

</cfif>