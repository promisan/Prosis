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
<!--- assignment without contract --->

<!--- 

1. define the selection date from the mandate
2. show people
--->

<cf_ListingScript>

<cfparam name="url.id1" default="">

<cfquery name="Mandate" 
datasource="AppsOrganization" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT *
	FROM Ref_Mandate
	WHERE Mission = '#url.id2#'
	AND MandateNo = '#url.id3#'
</cfquery>


<cfif mandate.dateexpiration gte now()>
  <cfset sel = dateformat(now(),"YYYYMMDD")>  
<cfelse>
   <cfset sel = dateformat(Mandate.DateExpiration,"YYYYMMDD")>
</cfif>

<cfoutput>

	<cfsavecontent variable="myquery">

SELECT  PersonNo, 
	    FullName,
		LastName,
		FirstName,
		Nationality,
		BirthDate,
		Gender,
		IndexNo,
		PostOrder,
	    DateEffective, 
		DateExpiration,
		PostGrade,
		PostGradeParentDescription
FROM	vwAssignment
WHERE	Mission = '#url.id2#' 
<cfif url.id1 neq "">
AND		PostGradeParent = '#url.id1#' 
</cfif>
AND		DateEffective <= '#sel#'
AND		DateExpiration >= '#sel#' 
AND		AssignmentStatus IN ('0','1') 
AND		PositionNo IN (
	SELECT  PositionNo
    FROM	Position
    WHERE   DateEffective <= '#sel#' 
	AND		DateExpiration >= '#sel#'
	AND		Incumbency > 0)
AND PersonNo NOT IN (
	SELECT	p.PersonNo
	FROM	Person P 
	INNER JOIN PersonContract PC ON P.PersonNo = PC.PersonNo 
	INNER JOIN Ref_PostGrade AS R ON PC.ContractLevel = R.PostGrade <cfif url.id1 neq ""> AND R.PostGradeParent = '#url.id1#' </cfif>
	WHERE	PC.DateEffective <= '#sel#'
	AND	PC.DateExpiration IS NULL OR PC.DateExpiration >= '#sel#'
	AND	PC.ActionStatus != '9'
	AND (
		(PC.Mission = '#url.id2#'	 
	      OR  PC.PersonNo IN
	          		 (SELECT PA.PersonNo
		              FROM   PersonAssignment AS PA INNER JOIN
	    	                 Position AS P ON PA.PositionNo = P.PositionNo
	        	      WHERE  P.Mission = '#url.id2#'
					  AND    PA.DateExpiration >= '#sel#' AND PA.DateEffective <= '#sel#'  
					  AND    PA.AssignmentStatus IN ('0','1')
					  )
					  
		)
		)				  
	)

	</cfsavecontent>	

</cfoutput>		
	  
		
<cfparam name="client.header" default="">

<cfset fields=ArrayNew(1)>

<cfset fields[1] = {label   = "Category",                   
					field   = "PostGradeParentDescription",
					search  = "text"}>

<cfset fields[2] = {label   = "IndexNo",                 
					field   = "IndexNo",
					search  = "text"}>
					
<cfset fields[3] = {label   = "Last name",                
					field   = "LastName",
					width   = "100",
					search  = "text"}>					
					
<cfset fields[4] = {label   = "First name",                    
					field   = "FirstName",					
					search  = "text"}>
						
<cfset fields[5] = {label   = "S", 					
					field   = "Gender",					
					search  = "text"}>					
					
<cfset fields[6] = {label      = "Grade", 					
					field      = "PostGrade",
					fieldsort  = "PostOrder",
					search     = "text"}>					
								
<cfset fields[7] = {label      = "Effective",  					
					field      = "DateEffective",
					formatted  = "dateformat(DateEffective,'#CLIENT.DateFormatShow#')"}>	
					
<cfset fields[8] = {label      = "Expiration",  					
					field      = "DateEffective",
					formatted  = "dateformat(DateExpiration,'#CLIENT.DateFormatShow#')"}>										
							
<cf_listing
    header        = "#client.header#"
    box           = "contract"
	link          = "#SESSION.root#/Staffing/Application/Contract/AssignmentNoContract.cfm?id2=#url.id2#&id3=#url.id3#&id1=#url.id1#"
    html          = "No"
	show          = "40"
	datasource    = "AppsEmployee"
	listquery     = "#myquery#"
	listkey       = "personNo"
	listorder     = "LastName"
	listorderdir  = "ASC"
	headercolor   = "ffffff"
	listlayout    = "#fields#"
	filtershow    = "Yes"
	excelShow     = "No"
	drillmode     = "window"
	drillargument = "540;600;false;false"	
	drilltemplate = "Staffing/Application/Employee/PersonView.cfm?id="
	drillkey      = "PersonNo">
					  