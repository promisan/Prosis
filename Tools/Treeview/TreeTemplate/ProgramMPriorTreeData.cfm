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
<cfoutput>

<cfquery name="Date" 
datasource="AppsProgram" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
  SELECT DISTINCT Created
  FROM ProgramSearch
  WHERE Status = '1'
  AND SearchCategory = '#Request.ArchiveClass#'
  AND OfficerUserId = '#SESSION.acc#'
</cfquery>

<cfif Date.recordCount neq "0">

['Prior Roster searches',null, 

<cfloop query = "Date">
 
  <cfset #CreatedDate# = #DateFormat(Date.Created, CLIENT.DateFormatShow)#>

  ['#CreatedDate#',null,
  
  <cfquery name="Datesearch" 
datasource="AppsProgram" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
  SELECT DISTINCT SearchId, Description
  FROM ProgramSearch
  WHERE Status = '1'
  AND SearchCategory = '#Request.ArchiveClass#'
  AND OfficerUserId = '#SESSION.acc#'
  AND Created = '#Date.Created#' 
     
</cfquery>

  <cfloop query="DateSearch">

  ['#SearchId# #Description#','ResultView.cfm?ID=#DateSearch.SearchId#'],
  
  </cfloop>],
  
  </cfloop>]  
  
</cfif>  
  
</cfoutput>


