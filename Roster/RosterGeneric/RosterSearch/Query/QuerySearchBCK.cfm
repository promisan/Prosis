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
<cfparam name="Attributes.cluster" default="">

<CFSET tbl = "BCK#Attributes.cluster#">

<!--- query ---->

<cfquery name="Result" 
 datasource="AppsSelection" 
 username="#SESSION.login#" 
 password="#SESSION.dbpw#">
	 SELECT SelectId, SelectDescription
	 FROM   RosterSearchLine
	 WHERE  SearchId = '#Value#'
	 AND    SearchClass = 'Background#Attributes.cluster#'
</cfquery>

<cfset cond = "">

<cfoutput query = "Result">

	<cfif cond eq "">
	 <cfset cond = "BCK.TopicValue LIKE '%#SelectDescription#%'"> 
	<cfelse>
	 <cfset cond = cond & " OR BCK.TopicValue LIKE '%#SelectDescription#%'"> 
	</cfif> 

</cfoutput>
 
<cfoutput>

  <CF_DropTable dbName="AppsQuery" tblName="tmp#SESSION.acc#_#fileNo#_#tbl#Select">

  <cfquery name="Result" 
   datasource="AppsSelection" 
      username="#SESSION.login#" 
       password="#SESSION.dbpw#">
       SELECT DISTINCT S.PersonNo
       INTO  userQuery.dbo.tmp#SESSION.acc#_#fileNo#_#tbl#Select
       FROM  ApplicantBackgroundDetail BCK, 
	         ApplicantSubmission S, 
			 userQuery.dbo.tmp#SESSION.acc#_#fileNo#_FunSelect T
       WHERE S.ApplicantNo = BCK.ApplicantNo   
	   AND   T.PersonNo = S.PersonNo
	   <!--- only enabled submission --->
	   AND   S.RecordStatus = '1'
	   AND   (#PreserveSingleQuotes(cond)#) 
   </cfquery>
   
</cfoutput>
