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
<!--- Create Criteria string for query from data entered thru search form --->

<cfset LastFrom = "">
<cfset LastWhere = "">

<cfoutput>

<cfquery name="General" 
        datasource="AppsEmployee" 
        username="#SESSION.login#" 
        password="#SESSION.dbpw#">
        SELECT *
		FROM PersonSearchLine
		WHERE SearchId = '#URL.ID#'
		AND SearchClass IN ('IndexNo','LastName','FirstName')
       </cfquery>
	   
<cfset #Personal# = "">
	   
<cfloop query="General">

    <cfset #Personal# = "AND Person."&#General.SearchClass#&" LIKE '%"&#General.SelectId#&"%'">
   
</cfloop>	   

<!--- gender --->

<cfquery name="Select" 
        datasource="AppsEmployee" 
        username="#SESSION.login#" 
        password="#SESSION.dbpw#">
        SELECT *
		FROM PersonSearchLine
		WHERE SearchId = '#URL.ID#'
		AND SearchClass = 'Gender'
       </cfquery>

<cfif #Select.SelectId# IS "F">
    <CFSET #Gender# = "Person.Gender = 'F'">
<cfelseif #Select.SelectId# IS "M">	
    <CFSET #Gender# = "Person.Gender = 'M'">
<cfelse>	
    <CFSET #Gender# = "Person.Gender in ('M','F')">	
</cfif> 

</cfoutput>

<cfquery name="SelectNat" 
        datasource="AppsEmployee" 
        username="#SESSION.login#" 
        password="#SESSION.dbpw#">
        SELECT *
		FROM PersonSearchLine
		WHERE SearchId = '#URL.ID#'
		AND SearchClass = 'Nationality'
</cfquery>


<cfif #SelectNat.recordCount# eq 0>
   <cfset nat = "">
<cfelse>
   <cfset nat = "AND Person.Nationality IN (SELECT SelectId FROM PersonSearchLine WHERE SearchId = '#URL.ID#' AND SearchClass = 'Nationality')">
</cfif>   

<cfquery name="Status" 
        datasource="AppsEmployee" 
        username="#SESSION.login#" 
        password="#SESSION.dbpw#">
        SELECT *
		FROM PersonSearchLine
		WHERE SearchId = '#URL.ID#'
		AND SearchClass = 'Status'
       </cfquery>

<CF_DropTable dbName="AppsQuery" tblName="tmp#SESSION.acc#PersonAll">

<cfswitch expression="#Status.SelectId#">

<cfcase value="All">
   
   <cfquery name="ResultBase" 
    datasource="AppsEmployee" 
    username="#SESSION.login#" 
    password="#SESSION.dbpw#">
    SELECT DISTINCT Person.PersonNo
    INTO  userQuery.dbo.tmp#SESSION.acc#PersonAll
    FROM  Person
    WHERE #PreserveSingleQuotes(Gender)# #PreserveSingleQuotes(Personal)# #PreserveSingleQuotes(Nat)#
  </cfquery>

</cfcase>

<cfcase value="OnBoard">
   
   <cfquery name="ResultBase" 
    datasource="AppsEmployee" 
    username="#SESSION.login#" 
    password="#SESSION.dbpw#">
    SELECT DISTINCT Person.PersonNo
    INTO  userQuery.dbo.tmp#SESSION.acc#PersonAll
    FROM  Person, PersonAssignment A
	WHERE #PreserveSingleQuotes(Gender)# #PreserveSingleQuotes(Personal)# #PreserveSingleQuotes(Nat)#
	AND   Person.PersonNo = A.PersonNo
	AND   DateExpiration > getDate()
  </cfquery>

</cfcase>

<cfcase value="History">
   
   <cfquery name="ResultBase" 
    datasource="AppsEmployee" 
    username="#SESSION.login#" 
    password="#SESSION.dbpw#">
    SELECT DISTINCT Person.PersonNo
    INTO  userQuery.dbo.tmp#SESSION.acc#PersonAll
    FROM  Person, PersonAssignment A
    WHERE #PreserveSingleQuotes(Gender)# #PreserveSingleQuotes(Personal)#  #PreserveSingleQuotes(Nat)#
	AND Person.PersonNo = A.PersonNo
	GROUP BY Person.PersonNo 
	HAVING Max(DateExpiration) < getDate()
  </cfquery>

</cfcase>

</cfswitch>

<cfquery name="Select" 
        datasource="AppsEmployee" 
        username="#SESSION.login#" 
        password="#SESSION.dbpw#">
        SELECT *
		FROM PersonSearchLine
		WHERE SearchId = '#URL.ID#'
		AND SearchClass = 'ContractExpiration'
       </cfquery>

<cfif #Select.RecordCount# gt 0>
	   
	   <cfset dateValue = "">
       <CF_DateConvert Value="#Select.SelectID#">
       <cfset DTE = #dateValue#>

	   <!--- remove people with contract after DTE --->
	   
	   <cfquery name="Contract" 
       datasource="AppsEmployee" 
       username="#SESSION.login#" 
       password="#SESSION.dbpw#">
 	   DELETE FROM userQuery.dbo.tmpadministratorPersonAll
       WHERE PersonNo IN (SELECT P.PersonNo FROM  userQuery.dbo.tmpadministratorPersonAll P, PersonContract C
                          WHERE     P.PersonNo = C.PersonNo AND DateExpiration > #DTE# )
	   </cfquery>
	   
</cfif>		
	
<!--- Mission --->

<cfquery name="Select" 
        datasource="AppsEmployee" 
        username="#SESSION.login#" 
        password="#SESSION.dbpw#">
        SELECT *
		FROM PersonSearchLine
		WHERE SearchId = '#URL.ID#'
		AND SearchClass = 'Mission'
</cfquery>

<cfquery name="SelectA" 
        datasource="AppsEmployee" 
        username="#SESSION.login#" 
        password="#SESSION.dbpw#">
        SELECT *
		FROM PersonSearchLine
		WHERE SearchId = '#URL.ID#'
		AND SearchClass = 'MissionOperator'
</cfquery>

<cfif #Select.RecordCount# gt 0>
   <cfset LastFrom  = #LastFrom#&", tmp#SESSION.acc#MISSelect">
   <cfset LastWhere = "WHERE tmp#SESSION.acc#MISSelect.PersonNo = tmp#SESSION.acc#PersonAll.PersonNo">
   <!--- run queries --->
   <CF_QuerySearchMIS 
   FieldValue="#URL.ID#"
   FieldStatus="#SelectA.SelectId#"> 
</cfif>

<!--- Grade --->

<cfquery name="SelectGrd" 
        datasource="AppsEmployee" 
        username="#SESSION.login#" 
        password="#SESSION.dbpw#">
        SELECT *
		FROM PersonSearchLine
		WHERE SearchId = '#URL.ID#'
		AND SearchClass = 'Grade'
</cfquery>

<cfquery name="SelectA" 
        datasource="AppsEmployee" 
        username="#SESSION.login#" 
        password="#SESSION.dbpw#">
        SELECT *
		FROM PersonSearchLine
		WHERE SearchId = '#URL.ID#'
		AND SearchClass = 'GradeOperator'
</cfquery>

<cfif #SelectGrd.RecordCount# gt 0>
   <cfif #LastWhere# neq "">
   <cfset LastFrom  = #LastFrom#&", tmp#SESSION.acc#GRDSelect">
   <cfset LastWhere = #LastWhere#&" AND tmp#SESSION.acc#GRDSelect.PersonNo = tmp#SESSION.acc#PersonAll.PersonNo">
   <cfelse>
   <cfset LastFrom  = #LastFrom#&", tmp#SESSION.acc#GRDSelect">
   <cfset LastWhere = " WHERE tmp#SESSION.acc#GRDSelect.PersonNo = tmp#SESSION.acc#PersonAll.PersonNo">
   </cfif>
   <!-- run queries --->
   <CF_QuerySearchGRD 
   FieldValue="#URL.ID#"
   FieldStatus="#SelectA.SelectId#"> 
</cfif>

<!--- Posttype --->

<cfquery name="SelectPTE" 
        datasource="AppsEmployee" 
        username="#SESSION.login#" 
        password="#SESSION.dbpw#">
        SELECT *
		FROM PersonSearchLine
		WHERE SearchId = '#URL.ID#'
		AND SearchClass = 'Category'
</cfquery>

<cfquery name="SelectA" 
        datasource="AppsEmployee" 
        username="#SESSION.login#" 
        password="#SESSION.dbpw#">
        SELECT *
		FROM PersonSearchLine
		WHERE SearchId = '#URL.ID#'
		AND SearchClass = 'CategoryOperator'
</cfquery>

<cfif #SelectPTE.RecordCount# gt 0>
   <cfif #LastWhere# neq "">
   <cfset LastFrom  = #LastFrom#&", tmp#SESSION.acc#PTESelect">
   <cfset LastWhere = #LastWhere#&" AND tmp#SESSION.acc#PTESelect.PersonNo = tmp#SESSION.acc#PersonAll.PersonNo">
   <cfelse>
   <cfset LastFrom  = #LastFrom#&", tmp#SESSION.acc#PTESelect">
   <cfset LastWhere = " WHERE tmp#SESSION.acc#PTESelect.PersonNo = tmp#SESSION.acc#PersonAll.PersonNo">
   </cfif>   
   <!-- run queries --->
   <CF_QuerySearchPTE 
   FieldValue="#URL.ID#"
   FieldStatus="#SelectA.SelectId#"> 
</cfif>

<!--- Final Query --->

<cfquery name="Result" 
       datasource="AppsQuery" 
       username="#SESSION.login#" 
       password="#SESSION.dbpw#">
	   INSERT INTO Employee.dbo.PersonSearchResult
	   (SearchId, PersonNo)
   	  SELECT DISTINCT '#URL.ID#', tmp#SESSION.acc#PersonAll.PersonNo
	  FROM   tmp#SESSION.acc#PersonAll 
			 #LastFrom#
	    #LastWhere#
	  </cfquery>
	
<CF_DropTable dbName="AppsQuery" tblName="tmp#SESSION.acc#PersonAll">	

<!--- upload to search result table --->

<cfoutput>
<script>

window.open("ResultView.cfm?ID=#URL.ID#&Mission=#URL.Mission#", "_top"); 

</script>
</cfoutput>

