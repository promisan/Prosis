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

<HTML><HEAD>
    <TITLE>Longlist</TITLE>
    <link rel="stylesheet" type="text/css" href="<cfoutput>#SESSION.root#/#client.style#</cfoutput>">
</HEAD>

<cfparam name="URL.Mode" default="Limited">
  
  <cfquery name="Clear" 
     datasource="AppsSelection" 
     username="#SESSION.login#" 
     password="#SESSION.dbpw#">
     DELETE RosterSearch 
   	  WHERE Status = '0' 
	  AND   OfficerUserId = '#SESSION.acc#'
	  AND   SearchId NOT IN (SELECT SearchId FROM RosterSearchLine)
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
     FROM Parameter</cfquery>
	 
	<cfquery name="Vacancy" 
        datasource="AppsVacancy" 
        username="#SESSION.login#" 
        password="#SESSION.dbpw#">
        SELECT *
		FROM Document D, Organization.dbo.Ref_Mission M
		WHERE D.DocumentNo = '#CLIENT.DocNo#'
		AND D.Mission = M.Mission
    </cfquery>	 
	 
   <cfset LastNo = #LastNo.SearchNo#>
        
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
	      'Longlist', 
		  '#URL.Mode#',
		  '#Owner.MissionOwner#',
		  'Vacancy',
		  '#CLIENT.DocNo#',
          '#SESSION.acc#',
    	  '#SESSION.last#',		  
	  	  '#SESSION.first#',
		  '#DateFormat(Now(),CLIENT.DateSQL)#')
    </cfquery>
	
	<cfquery name="Insert" 
        datasource="AppsSelection" 
        username="#SESSION.login#" 
        password="#SESSION.dbpw#">
        INSERT INTO RosterSearchLine
         (SearchId,
		 SearchClass,
		 SelectId, SelectDescription,SearchStage)
        VALUES ('#LastNo#',
	       'Announcement', 
          '#URL.VacNo#','#URL.VacNo#','1')
    </cfquery>
	
	<!--- insert criteria --->

     <cfquery name="Insert" 
        datasource="AppsSelection" 
        username="#SESSION.login#" 
        password="#SESSION.dbpw#">
        INSERT INTO RosterSearchLine
         (SearchId,
		 SearchClass,
		 SelectId, SelectDescription,SearchStage)
        VALUES ('#LastNo#',
	       'FunctionOperator', 
          'ANY','ANY','1')
     </cfquery>
	 	 			
	 <cfquery name="InsertFun" 
     datasource="AppsSelection" 
     username="#SESSION.login#" 
     password="#SESSION.dbpw#">
     INSERT INTO RosterSearchLine
         (SearchId,
		 SearchClass,
		 SelectId, SearchStage)
	 SELECT '#LastNo#',
	       'Function', 
          FunctionId,'1'
		  FROM FunctionOrganization
		  WHERE VacancyNo = '#URL.VacNo#'
      </cfquery>
	
	<cflocation url="Search4.cfm?ID=#LastNo#&Title=Long list for #Vacancy.ReferenceNo# [#Vacancy.FunctionalTitle# - #Vacancy.PostGrade#]" addtoken="No">
	
	