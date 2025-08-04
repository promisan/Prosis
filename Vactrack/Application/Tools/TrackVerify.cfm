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

<CF_DropTable dbName="AppsQuery"    full="yes" tblName="VacDocument">
<CF_DropTable dbName="AppsQuery"    full="yes" tblName="VacCandidate">

<cfquery name="Document" 
datasource="AppsVacancy" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT    D.DocumentNo, COUNT(*) AS Posts
	INTO      userQuery.dbo.VacDocument
	FROM      Document D, DocumentPost P
	WHERE     D.DocumentNo = P.DocumentNo
	AND       Status = 0
	GROUP BY  D.DocumentNo    
</cfquery>

<cfquery name="Document" 
datasource="AppsVacancy" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT    V.DocumentNo, V.Posts, COUNT(*) AS Completed
	INTO      userQuery.dbo.VacCandidate
	FROM      DocumentCandidate D, 
	          userQuery.dbo.VacDocument V
	WHERE     D.DocumentNo = V.DocumentNo		  
	AND       D.Status = '3'
	GROUP BY V.DocumentNo, V.Posts
</cfquery>

<cfquery name="Reset" 
datasource="AppsVacancy" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	UPDATE Document
	SET Status = '1',
	    StatusDate = getDate(), 
		StatusOfficerUserId = 'ETL_script'
	FROM userQuery.dbo.VacCandidate S, Document D
	WHERE S.DocumentNo = D.DocumentNo
	AND  S.Posts <= S.Completed
	AND Status = '0'
</cfquery>

<!--- safeguard : close remaining action of closed tracks only --->

<cfquery name="Check" 
   datasource="AppsOrganization" 
   username="#SESSION.login#" 
   password="#SESSION.dbpw#">
	 UPDATE OrganizationObjectAction 
	 SET    ActionStatus = 2
	 WHERE  Objectid IN (SELECT Objectid 
	                     FROM   OrganizationObject
						 WHERE  ObjectKeyValue1 IN (SELECT DocumentNo 
						                            FROM   Vacancy.dbo.Document 
												    WHERE  Status = '1') 
						AND EntityCode = 'VacDocument')
	AND     ActionStatus = '0'					
</cfquery>  

<CF_DropTable dbName="AppsQuery"    full="yes" tblName="VacDocument">
<CF_DropTable dbName="AppsQuery"    full="yes" tblName="VacCandidate">