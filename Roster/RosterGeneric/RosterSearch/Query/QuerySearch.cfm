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
<cf_screentop html="no" jquery="yes">

<cfset LastFrom = "">
<cfset LastWhere = "">

<cfset FileNo = round(Rand()*20)>

<!---
<cftry>
--->

<!--- Functions --->

<cfquery name="RosterSearch" 
        datasource="AppsSelection" 
        username="#SESSION.login#" 
        password="#SESSION.dbpw#">
        SELECT * 
		FROM   RosterSearch
		WHERE  SearchId = '#URL.ID#' 
</cfquery>

<cfquery name="Select" 
        datasource="AppsSelection" 
        username="#SESSION.login#" 
        password="#SESSION.dbpw#">
        SELECT *
		FROM   RosterSearchLine
		WHERE  SearchId = '#URL.ID#'
		AND    SearchClass = 'Function' 
</cfquery>

<cfquery name="SelectA" 
        datasource="AppsSelection" 
        username="#SESSION.login#" 
        password="#SESSION.dbpw#">
        SELECT *
		FROM   RosterSearchLine
		WHERE  SearchId = '#URL.ID#'
		AND    SearchClass = 'FunctionOperator'
</cfquery>

<cfif Select.RecordCount gt 0>
   
   <cfset LastFrom  = #LastFrom#&", tmp#SESSION.acc#_#fileNo#_FunSelect">
   <cfset LastWhere = "WHERE tmp#SESSION.acc#_#fileNo#_FunSelect.PersonNo = tmp#SESSION.acc#_#fileNo#_RosterAll.PersonNo">
   <!--- run queries --->
      
   <CF_QuerySearchFUN 
	   FileNo      = "#FileNo#"
	   FieldValue  = "#URL.ID#"
	   FieldStatus = "#SelectA.SelectId#"> 	 
	 	 	 
<cfelse>   
	
	<cf_message message="Problem, no buckets were selected." return="No">

	<cfabort>
	
</cfif>	
   
<cfoutput>

	<cfquery name="Select" 
        datasource="AppsSelection" 
        username="#SESSION.login#" 
        password="#SESSION.dbpw#">
        SELECT * 
		FROM   RosterSearchLine
		WHERE  SearchId = '#URL.ID#'
		AND    SearchClass = 'CandidateClass' 
    </cfquery>

	<cfif Select.SelectId IS "0">
	    <CFSET Board = "A.ApplicantClass = '0'">
	<cfelseif Select.SelectId IS "1">	
	    <CFSET Board = "A.ApplicantClass = '1'">
	<cfelseif Select.SelectId IS "2">	
	    <CFSET Board = "A.ApplicantClass = '2'">	
	<cfelse>
	    <CFSET Board = "">	
	</cfif> 

	<!--- age --->
	
	<cfquery name="Select" 
        datasource="AppsSelection" 
        username="#SESSION.login#" 
        password="#SESSION.dbpw#">
        SELECT *
		FROM RosterSearchLine
		WHERE SearchId = '#URL.ID#'
		AND SearchClass = 'AgeFrom'
	</cfquery>
		   
	<cfif Select.recordCount eq 0>
	      <CFSET AgeFrom = "">
	<cfelse>	
	      <cfset dte = DateAdd("yyyy", "-#Select.SelectId#", now())>
	      <CFSET AgeFrom = " AND A.DOB <= #dte#">
	</cfif>	 
	
	<cfquery name="Select" 
	    datasource="AppsSelection" 
	    username="#SESSION.login#" 
	    password="#SESSION.dbpw#">
	        SELECT *
			FROM   RosterSearchLine
			WHERE  SearchId = '#URL.ID#'
			AND    SearchClass = 'AgeUntil'
    </cfquery>
		   
	<cfif Select.recordCount eq 0>
	      <CFSET AgeUntil = "">
	<cfelse>	
	      <cfset dte = #DateAdd("yyyy", "-#Select.SelectId#", now())#>
	      <CFSET AgeUntil = " AND A.DOB >= #dte#">
	</cfif>	  

	<cfquery name="Select" 
        datasource="AppsSelection" 
        username="#SESSION.login#" 
        password="#SESSION.dbpw#">
        SELECT *
		FROM   RosterSearchLine
		WHERE  SearchId = '#URL.ID#'
		AND    SearchClass = 'Name'
    </cfquery>
	   
<cfif Select.recordCount eq 0>
      <CFSET Name = "">
<cfelse>	
      <CFSET Name = " (A.LastName LIKE '%#Select.SelectId#%' or A.FirstName LIKE '%#Select.SelectId#%') ">
</cfif>	        

<cfquery name="Select" 
        datasource="AppsSelection" 
        username="#SESSION.login#" 
        password="#SESSION.dbpw#">
        SELECT *
		FROM   RosterSearchLine
		WHERE  SearchId    = '#URL.ID#'
		AND    SearchClass = 'Gender'
       </cfquery>

<cfif Select.SelectId IS "F">
    <CFSET Gender = "A.Gender = 'F'">
<cfelseif Select.SelectId IS "M">	
    <CFSET Gender = "A.Gender = 'M'">
<cfelse>	
    <CFSET Gender = "">	
</cfif> 

</cfoutput>


<cfquery name="SelectNat" 
        datasource="AppsSelection" 
        username="#SESSION.login#" 
        password="#SESSION.dbpw#">
        SELECT *
		FROM   RosterSearchLine
		WHERE  SearchId = '#URL.ID#'
		AND    SearchClass = 'Nationality'
</cfquery>

<cfoutput>

<CF_DropTable dbName="AppsQuery" tblName="tmp#SESSION.acc#_#fileNo#_RosterAll">

<cfif SelectNat.recordCount eq 0>

	<cfquery name="ResultBase" 
	datasource="AppsSelection" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT DISTINCT A.PersonNo
	INTO  userQuery.dbo.tmp#SESSION.acc#_#fileNo#_RosterAll
	FROM  Applicant A, 
	      ApplicantSubmission S,
	      userQuery.dbo.tmp#SESSION.acc#_#fileNo#_FunSelect Fun  
	WHERE A.PersonNo = S.PersonNo	
	
	<!--- prevent to show people that are on the do not hire list --->
	
	<cfif SESSION.isAdministrator eq "No" and not findNoCase(RosterSearch.owner,SESSION.isOwnerAdministrator)>
	AND   A.PersonNo NOT IN (SELECT A.PersonNo 
	                         FROM   ApplicantAssessment A, 
							        Ref_PersonStatus R
							 WHERE  A.PersonStatus = R.Code
							 AND    R.RosterHide   = 1
							 AND    A.Owner        = '#RosterSearch.Owner#')
	</cfif>						 
	AND   A.PersonNo = Fun.PersonNo
	<cfif Name neq "">
	AND   #PreserveSingleQuotes(Name)#
	</cfif>
	<cfif Gender neq "">
	AND   #PreserveSingleQuotes(Gender)#
	</cfif>
	<cfif Board neq "">
	AND   #PreserveSingleQuotes(Board)#
	</cfif>
	<cfif AgeUntil eq "110" and AgeFrom eq "15">
	   <!--- nada --->
	<cfelse>
	   #PreserveSingleQuotes(AgeFrom)#
	   #PreserveSingleQuotes(AgeUntil)#
	</cfif>   
	</cfquery>
	
<cfelse>

	<cfquery name="SelectNatMode" 
        datasource="AppsSelection" 
        username="#SESSION.login#" 
        password="#SESSION.dbpw#">
        SELECT *
		FROM   RosterSearchLine
		WHERE  SearchId = '#URL.ID#'
		AND    SearchClass = 'NationalityMode'
	</cfquery>

	<cfquery name="ResultBase" 
	datasource="AppsSelection" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT DISTINCT A.PersonNo
		INTO  userQuery.dbo.tmp#SESSION.acc#_#fileNo#_RosterAll
		FROM  Applicant A, ApplicantSubmission S
		WHERE A.PersonNo = S.PersonNo
		
		<cfif SESSION.isAdministrator eq "No" and not findNoCase(RosterSearch.owner,SESSION.isOwnerAdministrator)>
		AND   A.PersonNo NOT IN (SELECT AR.PersonNo 
		                         FROM   ApplicantAssessment AR, 
								        Ref_PersonStatus R
								 WHERE  AR.PersonStatus = R.Code
								 AND    AR.PersonNo    = A.PersonNo
								 AND    R.RosterHide   = 1
								 AND    AR.Owner        = '#RosterSearch.Owner#')
		</cfif>						 
					
		<cfif Gender neq "">
		AND   #PreserveSingleQuotes(Gender)#
		</cfif>
		<cfif Board neq "">
		AND   #PreserveSingleQuotes(Board)#
		</cfif>
		<cfif SelectNatMode.selectId eq "1">
		AND   A.Nationality NOT IN (SELECT SelectId FROM RosterSearchLine
				WHERE SearchId = '#URL.ID#'
				AND SearchClass = 'Nationality')
		<cfelse>
		AND   A.Nationality IN (SELECT SelectId FROM RosterSearchLine
				WHERE SearchId = '#URL.ID#'
				AND SearchClass = 'Nationality')
		</cfif>		
		
	</cfquery>
	
</cfif>

</cfoutput>

<!--- wORKYEAR ; longlist only --->

<cfquery name="Select" 
        datasource="AppsSelection" 
        username="#SESSION.login#" 
        password="#SESSION.dbpw#">
        SELECT *
		FROM RosterSearchLine
		WHERE SearchId = '#URL.ID#'
		AND SearchClass = 'WorkExperience'
</cfquery>

<cfif Select.RecordCount gt 0>
   
   <cfset LastFrom  = #LastFrom#&", tmp#SESSION.acc#_#fileNo#_YRSSelect">
   <cfset LastWhere = "WHERE tmp#SESSION.acc#_#fileNo#_YRSSelect.PersonNo = tmp#SESSION.acc#_#fileNo#_RosterAll.PersonNo">
   
   <!-- run queries --->
   <CF_QuerySearchYRS FileNo="#FileNo#"
		   FieldValue="#Select.SelectId#"
		   FieldStatus=""> 
		   
</cfif>

<!--- Announcement ; longlist only --->

<cfquery name="Select" 
        datasource="AppsSelection" 
        username="#SESSION.login#" 
        password="#SESSION.dbpw#">
        SELECT *
		FROM   RosterSearchLine
		WHERE  SearchId = '#URL.ID#'
		AND    SearchClass = 'Announcement'
</cfquery>

<cfif Select.RecordCount gt 0>
   <cfset LastFrom  = #LastFrom#&", tmp#SESSION.acc#_#fileNo#_ANNSelect">
   <cfset LastWhere = "WHERE tmp#SESSION.acc#_#fileNo#_ANNSelect.PersonNo = tmp#SESSION.acc#_#fileNo#_RosterAll.PersonNo">
   <!-- run queries --->
   <CF_QuerySearchANN FileNo="#FileNo#" FieldValue="#URL.ID#" FieldStatus=""> 
</cfif>

<!--- Minimum requirements --->

<cfquery name="Check" 
  datasource="AppsSelection" 
  username="#SESSION.login#" 
  password="#SESSION.dbpw#">
  SELECT     *
  FROM         Ref_ParameterOwner
  WHERE     (Owner = '#RosterSearch.Owner#')
</cfquery>  

<cfif Check.RosterSearchMinimum eq "1">

   <cfset go = 1>

   <CF_QuerySearchMatching SearchId="#URL.ID#" FileNo="#FileNo#"> 
   
   <cfif go eq "1">
	   	<cfset LastFrom  = #LastFrom#&", tmp#SESSION.acc#_#fileNo#_MinimumSelect">
	    <cfset LastWhere = #LastWhere#&" AND tmp#SESSION.acc#_#fileNo#_MinimumSelect.PersonNo = tmp#SESSION.acc#_#fileNo#_RosterAll.PersonNo">
   </cfif>

</cfif>

<!--- Languages --->

<cfquery name="SelectLan" 
        datasource="AppsSelection" 
        username="#SESSION.login#" 
        password="#SESSION.dbpw#">
        SELECT *
		FROM   RosterSearchLine
		WHERE  SearchId = '#URL.ID#'
		AND    SearchClass = 'Language'
</cfquery>

<cfquery name="SelectA" 
        datasource="AppsSelection" 
        username="#SESSION.login#" 
        password="#SESSION.dbpw#">
        SELECT *
		FROM   RosterSearchLine
		WHERE  SearchId = '#URL.ID#'
		AND    SearchClass = 'LanguageOperator'
</cfquery>

<cfif SelectLan.RecordCount gt 0>

   <cfset LastFrom  = #LastFrom#&", tmp#SESSION.acc#_#fileNo#_LanSelect">
   <cfset LastWhere = #LastWhere#&" AND tmp#SESSION.acc#_#fileNo#_LanSelect.PersonNo = tmp#SESSION.acc#_#fileNo#_RosterAll.PersonNo">
   <!-- run queries --->
   <CF_QuerySearchLAN 
   FileNo="#FileNo#"
   FieldValue="#URL.ID#"
   FieldStatus="#SelectA.SelectId#"> 
   
</cfif>

<!--- Assessed Skills --->
	
<cfquery name="SelectSAS" 
        datasource="AppsSelection" 
        username="#SESSION.login#" 
        password="#SESSION.dbpw#">
        SELECT *
		FROM   RosterSearchLine
		WHERE  SearchId = '#URL.ID#'
		AND    SearchClass = 'SelfAssessment'
</cfquery>
	
<cfquery name="SelectA" 
        datasource="AppsSelection" 
        username="#SESSION.login#" 
        password="#SESSION.dbpw#">
        SELECT *
		FROM   RosterSearchLine
		WHERE  SearchId = '#URL.ID#'
		AND    SearchClass = 'SelfAssessmentOperator'
</cfquery>
	
<cfif SelectSAS.RecordCount gt 0>
	
   <cfset LastFrom  = "#LastFrom#,tmp#SESSION.acc#_#fileNo#_SASSelect">
   <cfset LastWhere = "#LastWhere# AND tmp#SESSION.acc#_#fileNo#_SASSelect.PersonNo = tmp#SESSION.acc#_#fileNo#_RosterAll.PersonNo">	  
   <CF_QuerySearchSAS FileNo="#FileNo#" FieldValue="#URL.ID#" FieldStatus="#SelectA.SelectId#"> 
	   
</cfif>

<!--- Assessed Skills --->

<cfquery name="SourceList" 
        datasource="AppsSelection" 
        username="#SESSION.login#" 
        password="#SESSION.dbpw#">
		SELECT   *
		FROM     Ref_Source
		WHERE    AllowAssessment = 1		
    </cfquery>	
	
<cfloop query="SourceList">
	
	<cfquery name="SelectSKL" 
	        datasource="AppsSelection" 
	        username="#SESSION.login#" 
	        password="#SESSION.dbpw#">
	        SELECT *
			FROM   RosterSearchLine
			WHERE  SearchId = '#URL.ID#'
			AND    SearchClass = 'Assessed#source#'
	</cfquery>
	
	<cfquery name="SelectA" 
	        datasource="AppsSelection" 
	        username="#SESSION.login#" 
	        password="#SESSION.dbpw#">
	        SELECT *
			FROM   RosterSearchLine
			WHERE  SearchId = '#URL.ID#'
			AND    SearchClass = 'Assessed#source#Operator'
	</cfquery>
	
	<cfif SelectSKL.RecordCount gt 0>
	
	   <cfset LastFrom  = "#LastFrom#,tmp#SESSION.acc#_#fileNo#_SKL#source#Select">
	   <cfset LastWhere = "#LastWhere# AND tmp#SESSION.acc#_#fileNo#_Skl#source#Select.PersonNo = tmp#SESSION.acc#_#fileNo#_RosterAll.PersonNo">	  
	   <CF_QuerySearchSKL FileNo="#FileNo#" Source="#source#" FieldValue="#URL.ID#" FieldStatus="#SelectA.SelectId#"> 
	   
   	</cfif>

</cfloop>	


<!--- Review class --->

	<cfquery name="RevClass" 
        datasource="AppsSelection" 
        username="#SESSION.login#" 
        password="#SESSION.dbpw#">
        SELECT *
		FROM   RosterSearchLine
		WHERE  SearchId = '#URL.ID#'
   	    AND    SearchClass = 'ReviewClass' 
	</cfquery>
	
	<cfloop query="RevClass">					
								
		   <cfset LastFrom  = #LastFrom#&", tmp#SESSION.acc#_#fileNo#_REV#SelectId#Select">
		   <cfset LastWhere = #LastWhere#&" AND tmp#SESSION.acc#_#fileNo#_REV#SelectId#Select.PersonNo = tmp#SESSION.acc#_#fileNo#_RosterAll.PersonNo">
		   
		   <!-- run queries --->
		   <CF_QuerySearchREV 
		   Code="#SelectId#"
		   FileNo="#FileNo#"
		   Owner="#RosterSearch.Owner#"
		   SelectParameter="#SelectParameter#"
		   FieldValue="#URL.ID#"> 
				
	</cfloop>	
	
<!--- Interview --->

	<cfquery name="RevClass" 
        datasource="AppsSelection" 
        username="#SESSION.login#" 
        password="#SESSION.dbpw#">
        SELECT *
		FROM   RosterSearchLine
		WHERE  SearchId = '#URL.ID#'
   		AND    SearchClass = 'Interview' 
	</cfquery>
	
	<cfloop query="RevClass">
								
		   <cfset LastFrom  = #LastFrom#&", tmp#SESSION.acc#_#fileNo#_INTSelect">
		   <cfset LastWhere = #LastWhere#&" AND tmp#SESSION.acc#_#fileNo#_INTSelect.PersonNo = tmp#SESSION.acc#_#fileNo#_RosterAll.PersonNo">
		   
		   <!-- run queries --->
		   <CF_QuerySearchINT FileNo="#FileNo#"
		   Owner="#RosterSearch.Owner#"
		   SelectParameter="#SelectParameter#"
		   FieldValue="#URL.ID#"> 
				
	</cfloop>		
	
<!--- keywords --->

<cfquery name="Class" 
        datasource="AppsSelection" 
        username="#SESSION.login#" 
        password="#SESSION.dbpw#">
        SELECT *
		FROM   Ref_ExperienceParent
		WHERE  SearchEnable = 1
</cfquery>


<cfquery name="Owner" 
        datasource="AppsSelection" 
        username="#SESSION.login#" 
        password="#SESSION.dbpw#">
        SELECT * 
		FROM   RosterSearchLine
		WHERE  SearchId = '#URL.ID#'
		AND    SearchClass = 'OwnerKeyWord'  
</cfquery>

<!---main classes which is treated independently --->

<cfloop query="Class">

	<cfquery name="SelectKey" 
	        datasource="AppsSelection" 
	        username="#SESSION.login#" 
	        password="#SESSION.dbpw#">
	        SELECT *
			FROM   RosterSearchLine
			WHERE  SearchId = '#URL.ID#'
			AND    SearchClass = '#Parent#' 
	</cfquery>

	<cfquery name="SelectA" 
	   datasource="AppsSelection" 
	   username="#SESSION.login#" 
	   password="#SESSION.dbpw#">
	        SELECT *
			FROM   RosterSearchLine
			WHERE  SearchId = '#URL.ID#'
			AND    SearchClass = '#Parent#Operator' 
	</cfquery>

	<cfif SelectKey.RecordCount gt 0>
	
	   <cfset LastFrom     = #LastFrom#&", tmp#SESSION.acc#_#fileNo#_#Parent#Select">
	   <cfset LastWhere    = #LastWhere#&" AND tmp#SESSION.acc#_#fileNo#_#Parent#Select.PersonNo = tmp#SESSION.acc#_#fileNo#_RosterAll.PersonNo">
 
`	   <cfset FieldValue   = "#URL.ID#">
	   <cfset FieldStatus  = "#SelectA.SelectId#">
	   <cfset Class        = "#Parent#">
	   <cfset Par          = "#Parent#">
	   <cfinclude template = "QuerySearchKeyword.cfm">
  
	</cfif>
	
</cfloop>	


<!--- Mission --->

<cfquery name="SelectDeg" 
        datasource="AppsSelection" 
        username="#SESSION.login#" 
        password="#SESSION.dbpw#">
        SELECT *
		FROM RosterSearchLine
		WHERE SearchId = '#URL.ID#'
		AND SearchClass = 'Mission' 
</cfquery>

<cfquery name="SelectA" 
        datasource="AppsSelection" 
        username="#SESSION.login#" 
        password="#SESSION.dbpw#">
        SELECT *
		FROM RosterSearchLine
		WHERE SearchId = '#URL.ID#'
		AND SearchClass = 'MissionOperator'
</cfquery>

<cfif SelectDeg.RecordCount gt 0>
   <cfset LastFrom  = #LastFrom#&", tmp#SESSION.acc#_#fileNo#_MisSelect">
   <cfset LastWhere = #LastWhere#&" AND tmp#SESSION.acc#_#fileNo#_MisSelect.PersonNo = tmp#SESSION.acc#_#fileNo#_RosterAll.PersonNo">
	<CF_QuerySearchMIS
	   FileNo="#FileNo#"
	   FieldValue="#URL.ID#"
	   FieldStatus="#SelectA.SelectId#"> 
</cfif>

<!--- Requirement --->

<cfquery name="SelectReq" 
        datasource="AppsSelection" 
        username="#SESSION.login#" 
        password="#SESSION.dbpw#">
        SELECT *
		FROM   RosterSearchLine
		WHERE  SearchId = '#URL.ID#'
		AND    SearchClass = 'Requirement'
</cfquery>

<cfquery name="SelectA" 
        datasource="AppsSelection" 
        username="#SESSION.login#" 
        password="#SESSION.dbpw#">
        SELECT *
		FROM   RosterSearchLine
		WHERE  SearchId = '#URL.ID#'
		AND    SearchClass = 'RequirementOperator'
</cfquery>

<cfif SelectReq.RecordCount gt 0>

   <cfset LastFrom  = #LastFrom#&", tmp#SESSION.acc#_#fileNo#_ReqSelect">
   <cfset LastWhere = #LastWhere#&" AND tmp#SESSION.acc#_#fileNo#_ReqSelect.PersonNo = tmp#SESSION.acc#_#fileNo#_RosterAll.PersonNo">
   <!-- run queries --->
   <CF_QuerySearchREQ FileNo="#FileNo#" FieldValue="#URL.ID#" FieldStatus="#SelectA.SelectId#"> 
   
</cfif>

<!--- Background keywords --->

<cfquery name="SelectBck" 
        datasource="AppsSelection" 
        username="#SESSION.login#" 
        password="#SESSION.dbpw#">
        SELECT *
		FROM   RosterSearchLine
		WHERE  SearchId = '#URL.ID#'
		AND    SearchClass = 'Background'
</cfquery>

<cfquery name="SelectA" 
        datasource="AppsSelection" 
        username="#SESSION.login#" 
        password="#SESSION.dbpw#">
        SELECT *
		FROM   RosterSearchLine
		WHERE  SearchId = '#URL.ID#'
		AND    SearchClass = 'BackgroundOperator'
</cfquery>

<cfif SelectBck.RecordCount gt 0>
   
   <cfset LastFrom  = #LastFrom#&", tmp#SESSION.acc#_#fileNo#_BckSelect">
   <cfset LastWhere = #LastWhere#&" AND tmp#SESSION.acc#_#fileNo#_BckSelect.PersonNo = tmp#SESSION.acc#_#fileNo#_RosterAll.PersonNo">
   <!-- run queries --->
   <CF_QuerySearchBCK FileNo="#FileNo#" FieldValue="#URL.ID#" FieldStatus="#SelectA.SelectId#"> 
   
</cfif>

<cfif SelectA.SelectId eq "ALL">
	
	<!--- Background keywords --->
	
	<cfloop index="itm" from="1" to="3">
	
		<cfquery name="SelectBck" 
		        datasource="AppsSelection" 
		        username="#SESSION.login#" 
		        password="#SESSION.dbpw#">
		        SELECT *
				FROM   RosterSearchLine
				WHERE  SearchId = '#URL.ID#'
				AND    SearchClass = 'Background#itm#'
		</cfquery>
		
		<cfif SelectBck.RecordCount gt 0>
		
		   <cfset LastFrom  = #LastFrom#&", tmp#SESSION.acc#_#fileNo#_Bck#itm#Select">
		   <cfset LastWhere = #LastWhere#&" AND tmp#SESSION.acc#_#fileNo#_Bck#itm#Select.PersonNo = tmp#SESSION.acc#_#fileNo#_RosterAll.PersonNo">
		
		   <!-- run queries --->
		   <CF_QuerySearchBCK FileNo="#FileNo#" FieldValue="#URL.ID#" FieldStatus="#SelectA.SelectId#" cluster="#itm#"> 
		   
		</cfif>
	
	</cfloop>

</cfif>

<!--- Topic/Questions keywords --->

<cfquery name="SelectTopic" 
    datasource="AppsSelection" 
    username="#SESSION.login#" 
    password="#SESSION.dbpw#">
        SELECT *
		FROM   RosterSearchLine
		WHERE  SearchId = '#URL.ID#'
		AND    SearchClass = 'Topic'
</cfquery>

<cfif SelectTopic.RecordCount gt 0>

   <cfset LastFrom  = #LastFrom#&", tmp#SESSION.acc#_#fileNo#_TopSelect">
   <cfset LastWhere = #LastWhere#&" AND tmp#SESSION.acc#_#fileNo#_TopSelect.PersonNo = tmp#SESSION.acc#_#fileNo#_RosterAll.PersonNo">
   
   <!-- run queries --->
   <CF_QuerySearchTOP  FileNo="#FileNo#"  FieldValue="#URL.ID#"> 
   
</cfif>

<!--- Final Query --->

<cfquery name="Empty" 
       datasource="AppsSelection" 
       username="#SESSION.login#" 
       password="#SESSION.dbpw#">
	   DELETE FROM RosterSearchResult
	   WHERE   SearchId = '#URL.ID#'
</cfquery>	  

<cfquery name="Add" 
       datasource="AppsQuery" 
       username="#SESSION.login#" 
       password="#SESSION.dbpw#">
	   INSERT INTO Applicant.dbo.RosterSearchResult 
	          (SearchId, PersonNo)
   	   SELECT DISTINCT '#URL.ID#',
	          tmp#SESSION.acc#_#fileNo#_RosterAll.PersonNo
	   FROM   userQuery.dbo.tmp#SESSION.acc#_#fileNo#_RosterAll 
			  #LastFrom#     
	          #LastWhere# 
</cfquery>

<!---
 
 <cfcatch>
 
 		<cf_waitEnd>			
				
  		<cf_ErrorInsert
			 ErrorSource      = "CFCATCH"
			 ErrorReferer     = ""
			 ErrorDiagnostics = "#CFCatch.Message# - #CFCATCH.Detail#"
			 Email = "0">			 			 		
							   			
		<cf_message message="We are sorry but your request could not be completed. <br>Press <b>BACK</b> and submit your search again. <br><br>If your problem persists contact your administrator" return="back">
		<cfabort>
				 
 </cfcatch>
  
</cftry>	 

--->

   
 <!--- update remarks to indicator recent selections per owner --->
 
<cfif RosterSearch.Owner neq "">
 
	 <cfquery name="Update" 
	       datasource="AppsSelection" 
	       username="#SESSION.login#" 
	       password="#SESSION.dbpw#">
		   UPDATE Applicant.dbo.RosterSearchResult
		   SET    Remarks = 'Recent'
		   FROM   RosterSearchResult R, 
		          Vacancy.dbo.skCandidateSelected_#RosterSearch.Owner# O
		   WHERE  R.PersonNo  = O.PersonNo
		   AND    SearchId    = '#URL.ID#'
	 </cfquery>
 
</cfif>
	
<CF_DropTable dbName="AppsQuery" tblName="tmp#SESSION.acc#_#fileNo#_RosterAll">	

<!--- upload to search result table --->

<cfoutput>

<cfquery name="Check" 
       datasource="AppsSelection" 
       username="#SESSION.login#" 
       password="#SESSION.dbpw#">
	   SELECT count(*) as total
	   FROM   RosterSearchResult
	   WHERE  SearchId = '#URL.ID#'
</cfquery>

<cfif Check.total gt 0>

	<script LANGUAGE = "JavaScript">
	
		ptoken.location("#SESSION.root#/Roster/RosterGeneric/RosterSearch/ResultView.cfm?mode=#url.mode#&docno=#url.docno#&ID=#URL.ID#&height="+$(document).height()) 		 
		 
	</script>

<cfelse>
 
	<script LANGUAGE = "JavaScript">	
	  
	    ptoken.location("#SESSION.root#/Roster/RosterGeneric/RosterSearch/Search4NoResult.cfm?mode=#url.mode#&docno=#url.docno#&id=#URL.ID#")	
			 
	</script>

</cfif>

</cfoutput>

