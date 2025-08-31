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
<CFSET Cde     = Attributes.Code>
<CFSET FileNo  = Attributes.FileNo>
<CFSET Param   = Attributes.SelectParameter>
    
  <!--- all valid potential combinations to be used for querying--->
  
      
  <CF_DropTable dbName="AppsQuery" tblName="tmp#SESSION.acc#_#fileNo#_REV#Cde#Select">
   
  <cfquery name = "All" 
   datasource="AppsSelection" 
   username="#SESSION.login#" 
   password="#SESSION.dbpw#">
   SELECT DISTINCT Fun.PersonNo  
   INTO	  userQuery.dbo.tmp#SESSION.acc#_#fileNo#_REV#Cde#Select
   FROM   ApplicantReview R, 
          userQuery.dbo.tmp#SESSION.acc#_#fileNo#_FunSelect Fun 
   WHERE  Fun.PersonNo = R.PersonNo 
    AND   R.ReviewCode = '#Cde#'
	AND   R.Owner      = '#Attributes.Owner#'
	<cfif #Param# eq "1">
    AND   R.Status = 1
	<cfelse>
	AND   R.Status != 0
		
	UNION
	SELECT DISTINCT Fun.PersonNo 
    FROM   userQuery.dbo.tmp#SESSION.acc#_#fileNo#_FunSelect Fun 
    WHERE  Fun.PersonNo NOT IN (SELECT PersonNo 
	                            FROM   ApplicantReview 
								WHERE  ReviewCode = '#Cde#') 
									
	</cfif>
    
  </cfquery>  
  
   
