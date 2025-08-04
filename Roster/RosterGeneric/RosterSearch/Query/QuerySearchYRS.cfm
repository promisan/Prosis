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

  <CFSET Value   = Attributes.FieldValue>
  <CFSET FileNo  = Attributes.FileNo>

  <CF_DropTable dbName="AppsQuery" tblName="tmp#SESSION.acc#_#fileNo#_YRS">
  <CF_DropTable dbName="AppsQuery" tblName="tmp#SESSION.acc#_#fileNo#_YRSSelect">

  <cfquery name="Result" 
   datasource="AppsSelection" 
      username="#SESSION.login#" 
       password="#SESSION.dbpw#">
       SELECT DISTINCT Fun.PersonNo, L.ExperienceStart, L.ExperienceEnd
       INTO   userQuery.dbo.tmp#SESSION.acc#_#fileNo#_YRS
       FROM   ApplicantBackground L, 
	          ApplicantSubmission S, 
	          userQuery.dbo.tmp#SESSION.acc#_#fileNo#_FunSelect Fun
	   WHERE  Fun.PersonNo         = S.PersonNo
       AND    L.Status             != '9'
	   <!--- only enabled submission --->
	   AND    S.RecordStatus = '1'
	   AND    L.ExperienceCategory = 'Employment'
	   AND    S.ApplicantNo = L.ApplicantNo
	   AND    L.ExperienceStart is not NULL  
   </cfquery>
   
   <cfquery name="Update" 
   datasource="AppsSelection" 
      username="#SESSION.login#" 
       password="#SESSION.dbpw#">
       UPDATE userQuery.dbo.tmp#SESSION.acc#_#fileNo#_YRS
	   SET    ExperienceEnd = '#dateFormat(now(), CLIENT.dateSQL)#'
	   WHERE  ExperienceEnd is NULL  
   </cfquery>
   
   <cfquery name="Step1" 
   datasource="AppsSelection" 
      username="#SESSION.login#" 
       password="#SESSION.dbpw#">
       SELECT   PersonNo, Min(ExperienceStart) as DateStart, Max(ExperienceEnd) as DateEnd, DateDiff(mm,Min(ExperienceStart), Max(ExperienceEnd)) as ExperienceMonth 
	   INTO     userQuery.dbo.tmp#SESSION.acc#_#fileNo#_YRSSelect
       FROM     userQuery.dbo.tmp#SESSION.acc#_#fileNo#_YRS
	   GROUP BY PersonNo
	   HAVING   DateDiff(mm,Min(ExperienceStart), Max(ExperienceEnd)) >= '#Value*12#' 
   </cfquery>
         
   <CF_DropTable dbName="AppsQuery" tblName="tmp#SESSION.acc#_#fileNo#_YRS">   
   