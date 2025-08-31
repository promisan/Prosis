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

	SELECT     MAX(PA.DateExpiration) AS AssignmentExpiration, 
	           Pers.PersonNo, 
			   Pers.IndexNo, 
			   Pers.LastName, 
			   Pers.MiddleName, 
			   Pers.FirstName, 
			   Pers.Gender, 
	           Pers.Nationality, 
			   MAX(PC.DateExpiration) AS ContractExpiration, 
			   Post.OrgUnitOperational, 
			   Organization.dbo.Organization.OrgUnitName
	FROM       Position Post INNER JOIN
	           PersonAssignment PA ON Post.PositionNo = PA.PositionNo INNER JOIN
	           Person Pers ON PA.PersonNo = Pers.PersonNo INNER JOIN
	           PersonContract PC ON Pers.PersonNo = PC.PersonNo INNER JOIN
	           Organization.dbo.Organization ON Post.OrgUnitOperational = Organization.dbo.Organization.OrgUnit
	WHERE     (Post.Mission = '#URL.ID2#') 
	AND       (Post.MandateNo = '#URL.ID3#')
	AND       PA.AssignmentStatus IN ('0','1')
	GROUP BY  Pers.PersonNo, 
	          Pers.IndexNo, 
			  Pers.LastName, 
			  Pers.MiddleName,
			  Pers.FirstName, 
			  Pers.Gender, 
			  Pers.Nationality, 
			  Post.OrgUnitOperational, 
	          Organization.dbo.Organization.OrgUnitName
			  
	HAVING    (MAX(PC.DateExpiration) < MAX(PA.DateExpiration))

</cfsavecontent>

</cfoutput>


<cfset fields=ArrayNew(1)>

<cfset itm = 0>
					
<cfset itm = itm+1>		
<cf_tl id="Index" var="vIndexNo">
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
<cf_tl id="Sex" var="vGender">
<cfset fields[itm] = {label         = "#vGender#", 
                      labelfilter   = "Gender",
					  field         = "Gender",
				      searchfield   = "Gender",
					  filtermode    = "2",
					  search        = "text"}>	
	  
<cfset itm = itm+1>		
<cf_tl id="Nat." var="vNationality">
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
<cf_tl id="Ass.Expiry" var="vAssignment">
<cfset fields[itm] = {label       = "#vAssignment#",  					
					  field       = "AssignmentExpiration",
					  search      = "date",
					  formatted   = "dateformat(AssignmentExpiration,'#CLIENT.DateFormatShow#')"}>	
					  
<cfset itm = itm+1>		
<cf_tl id="Contract" var="vContract">
<cfset fields[itm] = {label       = "#vContract#",  					
					  field       = "ContractExpiration",
					  search      = "date",
					  formatted   = "dateformat(ContractExpiration,'#CLIENT.DateFormatShow#')"}>	
					  
<cf_listing
    header         = "Contract"
    box            = "detail"
	link           = "ContractExpirationListing.cfm?id2=#url.id2#&id3=#url.id3#"
    html           = "No"
	show           = "40"
	datasource     = "AppsEmployee"
	listquery      = "#myquery#"			
	listorder      = "ContractExpiration"
	listorderdir   = "DESC"
	headercolor    = "ffffff"
	listlayout     = "#fields#"
	filterShow     = "Hide"
	excelShow      = "Yes">
