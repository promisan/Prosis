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
<!--- Criteria:  1. SM that had a valid assignment expiring during last year
                 2. and that don't have a valid assignment now
				 3. and that have a valid contract
---->

<cf_listingscript>

<cfoutput>

<cfsavecontent variable="myquery">

	SELECT P.PersonNo, P.IndexNo, P.LastName, P.FirstName, P.BirthDate, P.Gender, P.Nationality, PC.DateEffective, PC.DateExpiration
	FROM   Person  P
	INNER  JOIN PersonContract PC
		ON P.PersonNo = PC.PersonNo
	WHERE  EXISTS ( --- Once had an assignment, in the last year, in this mission
		SELECT 'X'
		FROM   PersonAssignment
		WHERE  P.PersonNo = PersonNo
		AND    AssignmentStatus != '9'
		AND    DateExpiration >= DATEADD(Year,-1,GETDATE()) AND DateExpiration < getdate() --- in the last year
		AND    PositionNo IN (
			SELECT PositionNo
			FROM   Position
			WHERE  Mission = '#URL.ID2#' AND MandateNo = '#URL.ID3#'
		)
	)
	AND  NOT EXISTS ( --- and currently don't have an assignment in this mission
		SELECT 'X'
		FROM    PersonAssignment
		WHERE   P.PersonNo = PersonNo
		AND     AssignmentStatus != '9'
		AND     DateEffective <= getdate() and DateExpiration >= getdate()
		AND     PositionNo IN (
			SELECT PositionNo
			FROM   Position
			WHERE  Mission = '#URL.ID2#' AND MandateNo = '#URL.ID3#'
		)
	)
	AND  PC.DateEffective<= getdate() and PC.DateExpiration >= getdate()

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
                      labelfilter   = "Gender",
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
<cf_tl id="Contract Eff" var="vContractEff">
<cfset fields[itm] = {label       = "#vContractEff#",  					
					  field       = "DateEffective",
					  search      = "date",
					  formatted   = "dateformat(DateEffective,'#CLIENT.DateFormatShow#')"}>	
					  
<cfset itm = itm+1>		
<cf_tl id="Contract End" var="vContract">
<cfset fields[itm] = {label       = "#vContract#",  					
					  field       = "DateExpiration",
					  search      = "date",
					  formatted   = "dateformat(DateExpiration,'#CLIENT.DateFormatShow#')"}>	

<cf_listing
    header         = "Contract"
    box            = "detail"
	link           = "ContractNoAssignmentListing.cfm?id2=#url.id2#&id3=#url.id3#"
    html           = "No"
	show           = "40"
	datasource     = "AppsEmployee"
	listquery      = "#myquery#"			
	listorder      = "DateExpiration"
	listorderdir   = "DESC"
	headercolor    = "ffffff"
	listlayout     = "#fields#"
	filterShow     = "Hide"
	excelShow      = "Yes">
	