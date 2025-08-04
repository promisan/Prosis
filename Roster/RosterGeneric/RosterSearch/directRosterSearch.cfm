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

<!--- store search request --->
	
    <cfquery name="Clear" 
     datasource="AppsSelection" 
     username="#SESSION.login#" 
     password="#SESSION.dbpw#">
	     DELETE RosterSearch 
		 FROM   RosterSearch S
   		 WHERE  Status = '0' 
		 AND    OfficerUserId = '#SESSION.acc#'
		 AND    SearchId NOT IN (SELECT SearchId 
		                         FROM   RosterSearchLine
								 WHERE  SearchId = S.SearchId)
     </cfquery>

	<cfquery name="AssignNo" 
     datasource="AppsSelection" 
     username="#SESSION.login#" 
     password="#SESSION.dbpw#">
     	UPDATE Parameter SET SearchNo = SearchNo+1
     </cfquery>

	<cfquery name="LastNo" 
     datasource="AppsSelection" 
     username="#SESSION.login#" 
     password="#SESSION.dbpw#">
	     SELECT *
	     FROM Parameter
	</cfquery>
	 
   	<cfset LastNo = LastNo.SearchNo>
        
   	<cfquery name="InsertSearch" 
     datasource="AppsSelection" 
     username="#SESSION.login#" 
     password="#SESSION.dbpw#">
	     INSERT INTO RosterSearch
		         (SearchId,
				 Description,
				 Mode,
				 Owner,
				 SearchCategory,
				 SearchCategoryId,
				 OfficerUserId,
				 OfficerLastName,
				 OfficerFirstName,	
				 Created)
	      VALUES ('#LastNo#',
			      'Shortlist', 		  
				  '#URL.Mode#',
				  '#URL.Owner#',
				  'Vacancy',
				  '#URL.DocNo#',
		          '#SESSION.acc#',
		    	  '#SESSION.last#',		  
			  	  '#SESSION.first#',
				  '#DateFormat(Now(),CLIENT.DateSQL)#')
      </cfquery>
	
	  	<!--- insert criteria --->

     	<cfquery name="Vacancy" 
        datasource="AppsVacancy" 
        username="#SESSION.login#" 
        password="#SESSION.dbpw#">
	        SELECT *
			FROM   Document
			WHERE  DocumentNo = '#URL.DocNo#'
        </cfquery>

<!--- see comment on line 97.. --->
		
<cfset url.id = lastno>		
<cfset url.mode = "vacancy">
<cfset url.functionno = Vacancy.FunctionNo>
<cfinclude template="Search2Shortlist.cfm">

				