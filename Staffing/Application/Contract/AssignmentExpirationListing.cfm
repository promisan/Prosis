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
<cfoutput>

<cfsavecontent variable="myquery">

	SELECT 
	P.PersonNo, 
	P.IndexNo, 
	P.LastName, 
	P.MiddleName, 
	P.FirstName, 
	P.Gender, 
	P.Nationality, 
	Pos.OrgUnitOperational, 
	O.OrgUnitName,
	PA.DateEffective,
	PA.DateExpiration
	FROM   PersonAssignment PA
		   INNER JOIN Person P
				ON PA.PersonNo = P.PersonNo
		   INNER JOIN Position Pos
				ON Pos.PositionNo = PA.PositionNo
		   INNER JOIN Organization.dbo.Organization O
				ON O.OrgUnit = Pos.OrgUnitOperational
	
	<!--- cleared assignments only --->
	WHERE  AssignmentStatus IN ('0','1')
	
	<!--- only used assignments --->
	AND  PA.Incumbency > 0	
		
	<!--- assignments expiring in the coming month --->	
	AND    PA.DateEffective <= getdate() AND PA.DateExpiration >= getdate() AND PA.DateExpiration <= DATEADD(Month,1,GETDATE())	
	
	<!--- valid position in this mandate --->	
	AND    PA.PositionNo IN(
				SELECT PositionNo
				FROM   Position
				WHERE  Mission = '#URL.ID2#' AND MandateNo = '#URL.ID3#'
	       )
	
	<!--- has a contract beyond the expiration of the assignment --->
	AND  EXISTS(
		SELECT 'X'
		FROM   PersonContract PC
		WHERE  PC.PersonNo = PA.PersonNo
		AND    PC.DateExpiration >= PA.DateExpiration
		AND    PC.Mission IN ('#URL.ID2#','UNDEF')
		
	) 
	
	<!--- and doesn't have a valid assignment in the future --->
	AND NOT EXISTS(
		SELECT 'X'
		FROM   PersonAssignment PA2
		WHERE  PA2.PersonNo = PA.PersonNo
		AND    PA2.DateExpiration > DATEADD(Month,1,PA.DateExpiration)
		AND    PA2.AssignmentStatus IN ('0','1')
		AND    PA2.Incumbency > 0	
	)

</cfsavecontent>

</cfoutput>


<cfset fields=ArrayNew(1)>

<cfset itm = 0>
					
<cfset itm = itm+1>		
<cf_tl id="IndexNo" var="vIndexNo">
<cfset fields[itm] = {label         = "#vIndexNo#", 
					  field         = "IndexNo",
				      searchfield   = "IndexNo",
					  filtermode    = "0",
					  search        = "text"}>			

<cfset itm = itm+1>		
<cf_tl id="Last Name" var="vLast">
<cfset fields[itm] = {label         = "#vLast#", 
					  field         = "LastName",
					  searchfield	= "LastName",
  					  filtermode    = "0",
					  search		= "text"}>					

<cfset itm = itm+1>		
<cf_tl id="First Name" var="vFirst">
<cfset fields[itm] = {label         = "#vFirst#", 
					  field         = "FirstName",
				      searchfield   = "FirstName",
					  filtermode    = "0",
					  search        = "text"}>	

<cfset itm = itm+1>		
<cf_tl id="Gender" var="vGender">
<cfset fields[itm] = {label         = "#vGender#", 
					  field         = "Gender",
				      searchfield   = "Gender",
					  filtermode    = "2",
					  search        = "text"}>	
	  
<cfset itm = itm+1>		
<cf_tl id="Nationality" var="vNationality">
<cfset fields[itm] = {label         = "#vNationality#", 
					  field         = "Nationality",
				      searchfield   = "Nationality",
					  filtermode    = "2",
					  search        = "text"}>	
					  
<cfset itm = itm+1>		
<cf_tl id="Unit" var="vUnit">
<cfset fields[itm] = {label         = "#vUnit#", 
					  field         = "OrgUnitName",
				      searchfield   = "OrgUnitName",
					  filtermode    = "2",
					  search        = "text"}>	
	  
<cfset itm = itm+1>		
<cf_tl id="Assignm. Eff" var="vAssignmentEff">
<cfset fields[itm] = {label       = "#vAssignmentEff#",  					
					  field       = "DateEffective",
					  search      = "date",
					  formatted   = "dateformat(DateEffective,'#CLIENT.DateFormatShow#')"}>	
					  
<cfset itm = itm+1>		
<cf_tl id="Assignm. Exp" var="vAssignmentExp">
<cfset fields[itm] = {label       = "#vAssignmentExp#",  					
					  field       = "DateExpiration",
					  search      = "date",
					  formatted   = "dateformat(DateExpiration,'#CLIENT.DateFormatShow#')"}>	
					  
<cf_listing
    header         = "AssignmentExpiration"
    box            = "detail"
	link           = "AssignmentExpirationListing.cfm?id2=#url.id2#&id3=#url.id3#"
    html           = "No"
	show           = "40"
	datasource     = "AppsEmployee"
	listquery      = "#myquery#"		
	listorderalias = "PA"	
	listorder      = "DateExpiration"
	listorderdir   = "DESC"
	headercolor    = "ffffff"
	listlayout     = "#fields#"
	filterShow     = "Hide"
	excelShow      = "Yes">
	
