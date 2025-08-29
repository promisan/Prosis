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
<cfparam name="CLIENT.Sort" default="Gender">

<cfif CLIENT.Sort neq "Continent" and
      CLIENT.Sort neq "Gender" and
      CLIENT.Sort neq "LastName" and
	  CLIENT.Sort neq "DOB">
	  <cfset deleted = deleteClientVariable("Sort")>
</cfif>   

<cfparam name="CLIENT.Sort" default="Gender">
<cfparam name="URL.Sort"    default="#CLIENT.Sort#">
<cfparam name="URL.Lay"     default="Listing">
<cfparam name="URL.Height"  default="600">

<cfset condA = "">

<cfparam name="URL.page" default="1">
<cfset CLIENT.sort = URL.Sort>

<cfquery name="SearchAction" 
datasource="AppsSelection" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
    FROM   RosterSearch
    WHERE  SearchId = '#URL.ID1#' 
</cfquery>

<cfparam name="url.mode" default="#SearchAction.Mode#">

<cfquery name="Criteria" 
datasource="AppsSelection" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
  SELECT *
  FROM   RosterSearchLine
  WHERE  SearchId = '#URL.ID1#' 
</cfquery>

<cfif Criteria.recordcount eq "0" and SearchAction.Mode neq "vacancy" and SearchAction.Mode neq "ssa">

	   <cf_message message="A problem was detected with the search criteria. Please resubmit your search" return="no">	  
	   <cfabort>

</cfif>

<cfquery name="Parameter" 
  datasource="AppsSelection" 
  username="#SESSION.login#" 
  password="#SESSION.dbpw#">
  SELECT *
  FROM   Ref_ParameterOwner
  WHERE  Owner = '#SearchAction.Owner#' 
</cfquery>

<cfquery name="ParameterMain" 
  datasource="AppsSelection" 
  username="#SESSION.login#" 
  password="#SESSION.dbpw#">
  SELECT *
  FROM Parameter
</cfquery>
		
<cfquery name="VA" 
  datasource="AppsSelection" 
  username="#SESSION.login#" 
  password="#SESSION.dbpw#">
	  SELECT *
	  FROM   RosterSearchLine R, 
	         FunctionOrganization F
	  WHERE  R.SearchId = '#URL.ID1#'
	  AND    R.SearchClass = 'Function'
	  AND    R.SelectId = F.FunctionId
</cfquery>
 

<cfinclude template="ResultListingScript.cfm">

<!--- temp file --->
 
<cfset cond = "">

<cfswitch expression="#URL.ID#">

	<cfcase value="GEN">
	
		 <cfif URL.ID2 neq "B">
		     <cfset cond = "AND A.Gender = '#URL.ID2#'">
		 </cfif>
	 
	</cfcase>
	
	<cfcase value="CON"><cfset cond = "AND N.Continent = '#URL.ID2#'"></cfcase>
	<cfcase value="COU"><cfset cond = "AND N.Code = '#URL.ID2#'"></cfcase>
	
	<cfcase value="CLS">
	
		<cfif URL.ID2 neq "B">
		  <cfset cond = "AND A.ApplicantClass = '#URL.ID2#'">
		</cfif>  
	
	</cfcase>
	
	<cfcase value="STA">
	
		<cfif URL.ID2 neq "B">
		  <cfset cond = "AND A.PersonNo IN (SELECT PersonNo FROM ApplicantAssessment WHERE PersonStatus = '#URL.ID2#')">
		</cfif>  
	
	</cfcase>
	
	<cfcase value="AGE">
	
	  <cfswitch expression="#URL.ID2#">
	  
	    <cfcase value="0">
		
		   <cfset dte  = #DateAdd("yyyy", "-20", now())#>
		   <CFSET cond = " AND A.DOB > #dte#">
		
		</cfcase>
		
		<cfcase value="20">
		
    	   <cfset dts  = #DateAdd("yyyy", "-20", now())#>
		   <cfset dte  = #DateAdd("yyyy", "-30", now())#>
		   <CFSET cond = " AND A.DOB > #dte# AND A.DOB <= #dts#">
		
		</cfcase>
		
		<cfcase value="30">
		
    	   <cfset dts  = #DateAdd("yyyy", "-30", now())#>
		   <cfset dte  = #DateAdd("yyyy", "-40", now())#>
		   <CFSET cond = " AND A.DOB > #dte# AND A.DOB <= #dts#">
		
		</cfcase>
		
		<cfcase value="40">
		
    	   <cfset dts  = #DateAdd("yyyy", "-40", now())#>
		   <cfset dte  = #DateAdd("yyyy", "-50", now())#>
		   <CFSET cond = " AND A.DOB > #dte# AND A.DOB <= #dts#">
		
		</cfcase>
		
		<cfcase value="50">
		
    	   <cfset dts  = #DateAdd("yyyy", "-50", now())#>
		   <cfset dte  = #DateAdd("yyyy", "-60", now())#>
		   <CFSET cond = " AND A.DOB > #dte# AND A.DOB <= #dts#">
		
		</cfcase>
		
		<cfcase value="60">
		
    	   <cfset dts  = #DateAdd("yyyy", "-60", now())#>
		   <CFSET cond = " AND A.DOB <= #dts#">
		
		</cfcase>
		
		</cfswitch>
	
	</cfcase>

</cfswitch>

   <cfswitch expression = "#URL.Sort#">
         	 
     <cfcase value="Continent">  <cfset orderby = "N.Continent, A.Nationality"></cfcase>
     <cfcase value="Gender">     <cfset orderby = "A.Gender"></cfcase>
     <cfcase value="LastName">   <cfset orderby = "A.LastName, A.FirstName"></cfcase>
     <cfcase value="DOB">        <cfset orderby = "A.DOB"></cfcase>
	 <cfdefaultcase>
	      	<cfset orderby = "A.LastName, A.FirstName">
	 </cfdefaultcase>

   </cfswitch>   
   		
   <cfquery name="SearchResult" 
		datasource="AppsSelection" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		  SELECT DISTINCT 
		  
		        <cfif SearchAction.SearchCategory eq "Vacancy">
				    <!--- ------------------------------------------------------------------------ --->
				    <!--- define if the persaon will be preselected in the screen for shortlisting --->
					<!--- ------------------------------------------------------------------------ --->
					(
					 SELECT  Status 
					 FROM    Vacancy.dbo.DocumentCandidate 
					 WHERE   DocumentNo = '#SearchAction.SearchCategoryId#'
					 AND     PersonNo = R.PersonNo
					) as Status,
				<cfelse>
					R.Status,
				</cfif>
				
				R.Remarks as Indicator,
				A.*, 
				<cfif Parameter.showLastAssignment eq "1">				
					  (SELECT count(*)  
					   FROM   Employee.dbo.PersonAssignment E 
			           WHERE  E.PersonNo = A.EmployeeNo
					   AND    E.AssignmentStatus IN ('0','1')
					   AND    DateEffective < getDate()
					   AND    DateExpiration > getDate()) as ShowAssignment, 
				 <cfelse>
					 '0' as ShowAssignment, 
				</cfif>
		        N.Continent, 				
				C.ContractLevel, 
				C.ContractStep, 
				C.DateExpiration,
				C.PersonStatusDescription,
				C.PersonStatus				
				<cfif URL.Lay eq "Question">
				,(SELECT TOP 1 ApplicantNo FROM ApplicantSubmission WHERE PersonNo = H.PersonNo) as ApplicantNo
				</cfif>		
				
		   FROM    RosterSearchResult R INNER JOIN
                   Applicant A ON R.PersonNo = A.PersonNo INNER JOIN
                   ApplicantSubmission H ON R.PersonNo = H.PersonNo INNER JOIN
                   System.dbo.Ref_Nation N ON A.Nationality = N.Code LEFT OUTER JOIN				   
                   Employee.dbo.skPersonContract C ON A.IndexNo = C.IndexNo	AND C.IndexNo <> '' <!--- added by Hanno to prevent duplicates --->	
				   
		  WHERE  R.SearchId = #URL.ID1#	   					  
			 
		  <cfif SESSION.isAdministrator eq "No" and not findNoCase(SearchAction.Owner,SESSION.isOwnerAdministrator)>	 
		  
		  AND    A.PersonNo NOT IN ( SELECT AR.PersonNo 
			                         FROM   ApplicantAssessment AR, 
									        Ref_PersonStatus R
									 WHERE  AR.PersonStatus = R.Code
									 AND    AR.PersonNo     = A.PersonNo
									 AND    R.RosterHide    = 1
									 AND    AR.Owner        = '#SearchAction.Owner#'
									)
		  </cfif>						
			
		  <!--- 
			AND H.Source = '#ParameterMain.PHPsource#'
		  ---> 
			
			#PreserveSingleQuotes(cond)# 
				
		  ORDER BY #orderby# <cfif #orderby# neq "A.LastName, A.FirstName">,A.LastName, A.FirstName</cfif>
		  
    </cfquery>
		
	<cfif URL.Lay eq "Function">
			
		<cfinvoke component="Service.Access"  
			   method="roster" 
			   owner="" 
			   role="'AdminRoster'"
			   returnvariable="accessRoster">	
		   
		   <cfinvoke component="Service.Access"  
			   method="roster" 
			   owner="" 
			   accesslevel="0"
			   role="'RosterClear'"
			   returnvariable="accessRead">			   
		 				
	  	   <cfquery name="FunctionSet" 
			  datasource="AppsSelection" 
			  username="#SESSION.login#" 
			  password="#SESSION.dbpw#">
			  SELECT S.PersonNo,
			         S.SubmissionEdition, 
			         F1.FunctionId, 
					 F.FunctionDescription, 
					 O.Description,
					 R.OrganizationCode, 
					 F1.GradeDeployment,
		             R.OrganizationDescription, 
					 A.RosterGroupMemo,
					 A.FunctionJustification,
					 R.HierarchyOrder, 
					 F1.ReferenceNo,
					 F1.PostSpecific,
					 F1.AnnouncementClass,
					 F1.DocumentNo,
		             A.Status, 
					 A.FunctionJustification, 					 
					 A.StatusDate,
					 RS.EnableStatusDate,
					 S.ApplicantNo,
					 RS.Meaning,					
					 (SELECT SearchId 
					  FROM   RosterSearchLine
					  WHERE  SearchId    = #URL.ID1#
			          AND    SearchClass = 'Function'
					  AND    SelectId    = F1.FunctionId) as SearchId
		      FROM   ApplicantSubmission S,
		             ApplicantFunction A, 
		             FunctionTitle F, 
				     OccGroup O,
		      	     FunctionOrganization F1, 
				     Ref_SubmissionEdition SE,
			         Ref_Organization R,
				     Ref_StatusCode RS
			  WHERE  S.PersonNo  IN (
			                        SELECT PersonNo 
			                        FROM   RosterSearchResult 
									WHERE  SearchId = '#URL.ID1#'
									)
		       AND   S.ApplicantNo        = A.ApplicantNo
		       AND   A.FunctionId         = F1.FunctionId
			   AND   O.OccupationalGroup  = F.OccupationalGroup
		       AND   F1.FunctionNo        = F.FunctionNo
			   AND   F1.SubmissionEdition = SE.SubmissionEdition 
			   
			   <cfif accessRoster eq "EDIT" or accessRoster eq "ALL" or accessRead eq "READ">
			  		  
			   <!--- new show only from the same occgroup here --->
			   AND F.OccupationalGroup IN (SELECT OccupationalGroup
			                               FROM   FunctionTitle F,
										          FunctionOrganization FO
										   WHERE  F.FunctionNo = FO.FunctionNo
										   AND    FO.FunctionId IN (SELECT SelectID
										                            FROM   RosterSearchLine
																    WHERE  SearchId    = #URL.ID1#
																    AND    SearchClass = 'Function')) 	
			   
			   <!--- added on the request of charles --->
			   																		
			   AND A.Status IN (
			   		      SELECT SelectID 
						  FROM   RosterSearchLine
						  WHERE  SearchId    = '#URL.ID1#'
						  AND    SearchClass = 'Assessment' 
			   )															 
			   
			   <cfelse>		
			   	  
			   AND A.Status IN (
				      SELECT SelectID 
					  FROM   RosterSearchLine
					  WHERE  SearchId    = '#URL.ID1#'
					  AND    SearchClass = 'Assessment' 
			   )
			   
			   </cfif>													 			 
			   AND RS.Id = 'Fun'
			   AND RS.Owner = SE.Owner
			   AND A.Status = RS.Status
		       AND R.OrganizationCode = F1.OrganizationCode 
			   AND A.Status NOT IN ('5','9')
		     ORDER BY A.Status
		 </cfquery>
		 
	</cfif>		

		