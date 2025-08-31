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
<cfset LastFrom = "">
<cfset LastWhere = "">

<cfoutput>

<cfquery name="General" 
        datasource="AppsProgram" 
        username="#SESSION.login#" 
        password="#SESSION.dbpw#">
        SELECT *
		FROM ProgramSearchLine
		WHERE SearchId = '#URL.ID#'
		AND SearchClass IN ('ProgramCode','ProgramName','ProgramGoal')
       </cfquery>
	   
<cfset #Personal# = "">
	   
<cfloop query="General">

    <cfset #Personal# = "AND P."&#General.SearchClass#&" LIKE '%"&#General.SelectId#&"%'">
   
</cfloop>	 

<cfquery name="SelectMission" 
        datasource="AppsProgram" 
        username="#SESSION.login#" 
        password="#SESSION.dbpw#">
        SELECT *
		FROM ProgramSearchLine
		WHERE SearchId = '#URL.ID#'
		AND SearchClass = 'Mission'
</cfquery>

<cfif #SelectMission.recordCount# eq 0>
   <cfset nat = "">
<cfelse>
   <cfset nat = "AND O.Mission IN (SELECT SelectId FROM PersonSearchLine WHERE SearchId = '#URL.ID#' AND SearchClass = 'Mission')">
</cfif>   
  

<CF_DropTable dbName="AppsQuery" tblName="tmp#SESSION.acc#ProgramAll">
   
   <cfquery name="ResultBase" 
    datasource="AppsProgram" 
    username="#SESSION.login#" 
    password="#SESSION.dbpw#">
    SELECT DISTINCT Pe.ProgramId
    INTO  userQuery.dbo.tmp#SESSION.acc#ProgramAll
    FROM  Program P, ProgramPeriod Pe, Organization.dbo.Organization O
    WHERE P.ProgramCode = Pe.ProgramCode 
	AND   P.OrgUnit = O.OrgUnit
	#PreserveSingleQuotes(Personal)# 
  </cfquery>

<!--- Category --->

<cfquery name="Select" 
        datasource="AppsProgram" 
        username="#SESSION.login#" 
        password="#SESSION.dbpw#">
        SELECT *
		FROM ProgramSearchLine
		WHERE SearchId = '#URL.ID#'
		AND SearchClass = 'Category'
</cfquery>

<cfquery name="SelectA" 
        datasource="AppsProgram" 
        username="#SESSION.login#" 
        password="#SESSION.dbpw#">
        SELECT *
		FROM ProgramSearchLine
		WHERE SearchId = '#URL.ID#'
		AND SearchClass = 'CategoryOperator'
</cfquery>

<cfif #Select.RecordCount# gt 0>
   <cfset LastFrom  = #LastFrom#&", tmp#SESSION.acc#CATSelect">
   <cfset LastWhere = "WHERE tmp#SESSION.acc#CATSelect.ProgramId = tmp#SESSION.acc#ProgramAll.ProgramId">
   <!--- run queries --->
   <CF_QuerySearchCAT 
   FieldValue="#URL.ID#"
   FieldStatus="#SelectA.SelectId#"> 
</cfif>

<!--- Funding --->

<cfquery name="Select" 
        datasource="AppsProgram" 
        username="#SESSION.login#" 
        password="#SESSION.dbpw#">
        SELECT *
		FROM ProgramSearchLine
		WHERE SearchId = '#URL.ID#'
		AND SearchClass = 'Funding'
</cfquery>

<cfquery name="SelectA" 
        datasource="AppsProgram" 
        username="#SESSION.login#" 
        password="#SESSION.dbpw#">
        SELECT *
		FROM ProgramSearchLine
		WHERE SearchId = '#URL.ID#'
		AND SearchClass = 'FundingOperator'
</cfquery>

<cfset #src# = "FUN">

<cfif #Select.RecordCount# gt 0>
    <cfif #LastWhere# neq "">
   <cfset LastFrom  = #LastFrom#&", tmp#SESSION.acc##src#Select">
   <cfset LastWhere = #LastWhere#&" AND tmp#SESSION.acc##src#Select.ProgramId = tmp#SESSION.acc#ProgramAll.ProgramId">
   <cfelse>
   <cfset LastFrom  = #LastFrom#&", tmp#SESSION.acc##src#Select">
   <cfset LastWhere = " WHERE tmp#SESSION.acc##src#Select.ProgramId = tmp#SESSION.acc#ProgramAll.ProgramId">
   </cfif>   
   <!-- run queries --->
   <CF_QuerySearchFUN
   FieldValue="#URL.ID#"
   FieldStatus="#SelectA.SelectId#"> 
</cfif>

<!--- Resource --->

<cfquery name="Select" 
        datasource="AppsProgram" 
        username="#SESSION.login#" 
        password="#SESSION.dbpw#">
        SELECT *
		FROM ProgramSearchLine
		WHERE SearchId = '#URL.ID#'
		AND SearchClass = 'Resource'
</cfquery>

<cfquery name="SelectA" 
        datasource="AppsProgram" 
        username="#SESSION.login#" 
        password="#SESSION.dbpw#">
        SELECT *
		FROM ProgramSearchLine
		WHERE SearchId = '#URL.ID#'
		AND SearchClass = 'ResourceOperator'
</cfquery>

<cfset #src# = "RES">

<cfif #Select.RecordCount# gt 0>
    <cfif #LastWhere# neq "">
   <cfset LastFrom  = #LastFrom#&", tmp#SESSION.acc##src#Select">
   <cfset LastWhere = #LastWhere#&" AND tmp#SESSION.acc##src#Select.ProgramId = tmp#SESSION.acc#ProgramAll.ProgramId">
   <cfelse>
   <cfset LastFrom  = #LastFrom#&", tmp#SESSION.acc##src#Select">
   <cfset LastWhere = " WHERE tmp#SESSION.acc##src#Select.ProgramId = tmp#SESSION.acc#ProgramAll.ProgramId">
   </cfif>   
   <!-- run queries --->
   <CF_QuerySearchRES
   FieldValue="#URL.ID#"
   FieldStatus="#SelectA.SelectId#"> 
</cfif>

<!--- Period --->

<cfquery name="Select" 
        datasource="AppsProgram" 
        username="#SESSION.login#" 
        password="#SESSION.dbpw#">
        SELECT *
		FROM ProgramSearchLine
		WHERE SearchId = '#URL.ID#'
		AND SearchClass = 'Period'
</cfquery>

<cfquery name="SelectA" 
        datasource="AppsProgram" 
        username="#SESSION.login#" 
        password="#SESSION.dbpw#">
        SELECT *
		FROM ProgramSearchLine
		WHERE SearchId = '#URL.ID#'
		AND SearchClass = 'PeriodOperator'
</cfquery>

<cfset #src# = "PER">

<cfif #Select.RecordCount# gt 0>
    <cfif #LastWhere# neq "">
   <cfset LastFrom  = #LastFrom#&", tmp#SESSION.acc##src#Select">
   <cfset LastWhere = #LastWhere#&" AND tmp#SESSION.acc##src#Select.ProgramId = tmp#SESSION.acc#ProgramAll.ProgramId">
   <cfelse>
   <cfset LastFrom  = #LastFrom#&", tmp#SESSION.acc##src#Select">
   <cfset LastWhere = " WHERE tmp#SESSION.acc##src#Select.ProgramId = tmp#SESSION.acc#ProgramAll.ProgramId">
   </cfif>   
   <!-- run queries --->
   <CF_QuerySearchPER
   FieldValue="#URL.ID#"
   FieldStatus="#SelectA.SelectId#"> 
</cfif>

<!--- activity class --->

<cfquery name="Select" 
        datasource="AppsProgram" 
        username="#SESSION.login#" 
        password="#SESSION.dbpw#">
        SELECT *
		FROM ProgramSearchLine
		WHERE SearchId = '#URL.ID#'
		AND SearchClass = 'Class'
</cfquery>

<cfquery name="SelectA" 
        datasource="AppsProgram" 
        username="#SESSION.login#" 
        password="#SESSION.dbpw#">
        SELECT *
		FROM ProgramSearchLine
		WHERE SearchId = '#URL.ID#'
		AND SearchClass = 'ClassOperator'
</cfquery>

<cfset #src# = "CLS">

<cfif #Select.RecordCount# gt 0>
    <cfif #LastWhere# neq "">
   <cfset LastFrom  = #LastFrom#&", tmp#SESSION.acc##src#Select">
   <cfset LastWhere = #LastWhere#&" AND tmp#SESSION.acc##src#Select.ProgramId = tmp#SESSION.acc#ProgramAll.ProgramId">
   <cfelse>
   <cfset LastFrom  = #LastFrom#&", tmp#SESSION.acc##src#Select">
   <cfset LastWhere = " WHERE tmp#SESSION.acc##src#Select.ProgramId = tmp#SESSION.acc#ProgramAll.ProgramId">
   </cfif>   
   <!-- run queries --->
   <CF_QuerySearchCLS
   FieldValue="#URL.ID#"
   FieldStatus="#SelectA.SelectId#"> 
</cfif>

<!--- Combine all searches --->

<CF_DropTable dbName="AppsQuery" tblName="tmp#SESSION.acc#Final">	

<cfquery name="Result" 
       datasource="AppsQuery" 
       username="#SESSION.login#" 
       password="#SESSION.dbpw#">
	  SELECT DISTINCT '#URL.ID#' as SearchId, tmp#SESSION.acc#ProgramAll.ProgramId
	  INTO tmp#SESSION.acc#Final
	  FROM   tmp#SESSION.acc#ProgramAll 
		#LastFrom#
	    #LastWhere#
</cfquery>

<!--- now we have all programs but we also need to have the parent --->
<!--- to this table to have a complete picture --->

<cfloop index="i" from="1" to="2" step="1">

<cfquery name = "Component" 
   datasource="AppsProgram" 
   username="#SESSION.login#" 
   password="#SESSION.dbpw#">
   INSERT INTO userQuery.dbo.tmp#SESSION.acc#Final
      (SearchId, ProgramId)
   SELECT DISTINCT '#URL.ID#' as SearchId, Pce.ProgramId
       FROM  userQuery.dbo.tmp#SESSION.acc#Final S, ProgramPeriod Pe, Program P, ProgramPeriod Pce
	   WHERE S.ProgramId = Pe.ProgramId
	   AND  Pe.ProgramCode = P.ProgramCode 
	   AND  (P.ParentCode is not NULL and P.ParentCode <> '')
	   AND  P.ParentCode = Pce.ProgramCode
  </cfquery>  


</cfloop>

<!--- Final Query --->

<cfquery name="Result" 
       datasource="AppsProgram" 
       username="#SESSION.login#" 
       password="#SESSION.dbpw#">
	   INSERT INTO ProgramSearchResult
	   (SearchId, ProgramId)
      SELECT DISTINCT '#URL.ID#', userQuery.dbo.tmp#SESSION.acc#Final.ProgramId
	  FROM   UserQuery.dbo.tmp#SESSION.acc#Final
</cfquery>


<CF_DropTable dbName="AppsQuery" tblName="tmp#SESSION.acc#ProgramAll">	
<CF_DropTable dbName="AppsQuery" tblName="tmp#SESSION.acc#Final">	

<!--- upload to search result table --->


<script>

window.open("ResultView.cfm?ID=#URL.ID#&Mission=#URL.Mission#&IDForm=Search3.cfm", "_top"); 

</script>
</cfoutput>

