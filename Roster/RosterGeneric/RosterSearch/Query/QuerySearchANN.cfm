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
<CFSET Value   = Attributes.FieldValue>
<CFSET Operator  = Attributes.FieldStatus>
<CFSET FileNo  = Attributes.FileNo>

<!--- select the defined functions --->

<cfquery name="Select" 
        datasource="AppsSelection" 
        username="#SESSION.login#" 
        password="#SESSION.dbpw#">
        SELECT *
		FROM RosterSearchLine
		WHERE SearchId = '#URL.ID#'
		AND SearchClass = 'Announcement'
       </cfquery>

<cfoutput>

  <CF_DropTable dbName="AppsQuery" tblName="tmp#SESSION.acc#_#fileNo#_AnnSelect">

  <cfquery name="Result" 
   datasource="AppsSelection" 
      username="#SESSION.login#" 
       password="#SESSION.dbpw#">
       SELECT DISTINCT S.PersonNo
       INTO  userQuery.dbo.tmp#SESSION.acc#_#fileNo#_AnnSelect
       FROM  IMP_VacancyCandidate S
       WHERE  VacancyNo IN (SELECT SelectId
                    		FROM RosterSearchLine
                       		WHERE SearchId = '#URL.ID#'
                    		AND SearchClass = 'Announcement')
   </cfquery>
   
</cfoutput>
