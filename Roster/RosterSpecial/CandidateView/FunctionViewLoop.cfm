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
<cfparam name="URL.IDFunction" default="">
<cfparam name="URL.IDVacancy" default="">
<cfparam name="URL.Ajax"      default="Yes">

<cfif URL.IDFunction eq "" and URL.IDVacancy neq "">

	<cfquery name="Check" 
	 datasource="AppsSelection" 
	 username="#SESSION.login#" 
	 password="#SESSION.dbpw#">
	 SELECT *
	 FROM   FunctionOrganization 
	 WHERE  ReferenceNo = '#URL.IDVacancy#' 
	</cfquery>
	
	<cfset URL.IDFunction = Check.FunctionId>

</cfif>

<cfif URL.IDFunction eq "">

	<cf_message message="No Bucket associated" return="No">
	<cfabort>

</cfif>
   
<cfquery name="Function" 
 datasource="AppsSelection" 
 username="#SESSION.login#" 
 password="#SESSION.dbpw#">
	 SELECT F.*, 
	        Fo.*, 
			R.Owner, 			
			( SELECT TOP 1  Description FROM Organization.dbo.Ref_AuthorizationRoleOwner WHERE Code = R.Owner) as OwnerDescription,
			R.EnableManualEntry, 
			R.EditionDescription, 
			R.ActionStatus as SubmissionStatus, 
			ExerciseClass
	 FROM   FunctionTitle F, 
	        FunctionOrganization Fo, 
		    Ref_SubmissionEdition R
	 WHERE  F.FunctionNo = Fo.FunctionNo
	 AND    Fo.FunctionId = '#URL.IDFunction#'
	 AND    R.SubmissionEdition = Fo.SubmissionEdition 
</cfquery>
	
<cfset FileNo = round(Rand()*10)>

<cfparam name="URL.Inquiry" default="No">

<cfif URL.Inquiry eq "No">
  <cfset mode = "1">
<cfelse>
  <cfset mode = "0">  
</cfif>

<cfquery name="Check" 
	datasource="AppsSelection" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT * 
	FROM FunctionOrganization
	WHERE FunctionId = '#URL.IDFunction#' 
</cfquery>

<cfif Check.recordcount eq "0">

	<cf_message status = "Problem" message = "This bucket has been removed from the database.">
    <cfabort>

</cfif>

<!--- Parameter values --->
<cfparam name="URL.ID" default="0">

<cfinvoke component="Service.Access"  
   method="Bucket" 
   role="RosterClear" 
   functionId="#URL.IDFunction#"
   level="1"
   returnvariable="Access">
   
<!--- not sure if we still need this : Dev --->
   
<cfinvoke component="Service.Access"  
   method="Bucket" 
   role="RosterClear" 
   functionId="#URL.IDFunction#"
   level="2"
   returnvariable="Access2">   
  
<cfif Access eq "EDIT" or Access2 eq "EDIT">
	<cfset URL.Caller = "Actor">
<cfelse>	
    <cfset URL.Caller = "Read-only">
</cfif>

<cfinvoke component="Service.Access"  
 method="roster" 
 returnvariable="AccessRoster"
 role="'AdminRoster','RosterClear'">

<cf_textareascript>

<cf_screentop height="100%" 
	   band="No" 
	   html="No"
	   layout="webapp" 
	   banner="yellow"
	   SystemModule="Roster"
	   FunctionClass="Window"
	   FunctionName="Roster Bucket"	   
	   label="Process Bucket #Function.GradeDeployment# #Function.FunctionDescription# [Mode:#Caller#]" 
	   scroll="No"
	   jQuery="Yes">	

<cfinclude template="../RosterProcess/LevelBatchDenial.cfm">

<cfparam name="URL.Selection" default="Hide">

<cf_droptable dbname="AppsQuery" tblname="#SESSION.acc#CandidateTmp#FileNo#">
<cf_droptable dbname="AppsQuery" tblname="#SESSION.acc#CandidateTmp2#FileNo#">

<cfquery name="FunctionTopic" 
 datasource="AppsSelection" 
 username="#SESSION.login#" 
 password="#SESSION.dbpw#">
	 SELECT *
	 FROM FunctionOrganizationTopic
	 WHERE FunctionId = '#URL.IDFunction#'
	 ORDER BY Parent, TopicOrder
</cfquery>

<cfinclude template="FunctionViewScript.cfm">
	
<cfquery name="Check"
	   datasource="AppsSelection"
	   username="#SESSION.login#"
	   password="#SESSION.dbpw#">
		SELECT		DISTINCT S.PersonNo, F.FunctionId, F.Status, min(F.Created) as Created
		INTO        userQuery.dbo.#SESSION.acc#CandidateTmp#FileNo#
		FROM		ApplicantFunction F, 
		            ApplicantSubmission S 
		WHERE   	F.FunctionId = '#URL.IDFunction#'
		AND         S.ApplicantNo = F.ApplicantNo
		GROUP BY    S.PersonNo, F.ApplicantNo, F.FunctionId, F.Status
		ORDER BY 	F.Status
</cfquery>

<cfquery name="Check"
	   datasource="AppsSelection"
	   username="#SESSION.login#"
	   password="#SESSION.dbpw#">
		SELECT		count(*) as count 
		FROM		userQuery.dbo.#SESSION.acc#CandidateTmp#FileNo# 
</cfquery>
   
<cfquery name="Nationality"
   datasource="AppsSelection"
   username="#SESSION.login#"
   password="#SESSION.dbpw#">
   SELECT DISTINCT Applicant.Nationality, SNation.Name
   FROM      Applicant INNER JOIN
             System.dbo.Ref_Nation SNation ON Applicant.Nationality = SNation.Code
   WHERE     Applicant.PersonNo IN (SELECT DISTINCT PersonNo FROM userQuery.dbo.#SESSION.acc#CandidateTmp#FileNo# A)
</cfquery>	

<cfoutput>

	<script>
	
	var root = "#root#";
	
	w = 0
	h = 0
	if (screen) {
		w = #CLIENT.width# - 60
		h = #CLIENT.height# - 110
	}
	
	function ask() {
	
	itm = document.getElementById("FunctionNew")
	
	if (confirm("Reaassign bucket to: "+itm.value+" ?")) {
	      return true		
	   	} else {
		  return false
		}
	}
	
	function showdocument(vacno) {
		    ptoken.open("#SESSION.root#/Vactrack/Application/Document/DocumentEdit.cfm?ID=" + vacno, vacno);
	}
	
	function purge(id) {
		    window.location = "FunctionViewPurge.cfm?ID=#URL.IDFunction#";
	}
	
	function access(id,row,ra,src) {
	  
		 icM  = document.getElementById(row+"Min")
		 icE  = document.getElementById(row+"Exp")
		 se   = document.getElementById(row);
		 	 	 		 
		 if (se.className == "hide") {
		   	  icM.className = "regular";
		      icE.className = "hide";
	    	  se.className  = "regular";
			  _cf_loadingtexthtml='';	
			  ptoken.navigate('FunctionViewLoopGrantUser.cfm?source='+src+'&rosteraction='+ra+'&mode=roster&ID=#URL.IDFunction#&status='+row+'&FunctionId='+id+'&row='+row,'i'+row)
		 } else {
		   	 icM.className = "hide";
		     icE.className = "regular";
	     	 se.className  = "hide"
		 }
			 		
	  }
	  
	</script>

</cfoutput>   		     	   
   	
   <cfquery name="Missing"
	   datasource="AppsSelection"
	   username="#SESSION.login#"
	   password="#SESSION.dbpw#">
	   SELECT *
	   FROM  ApplicantFunction F
	   WHERE F.FunctionId = '#URL.IDFunction#'
	   <!---
		AND   F.Status != '9'
		--->
		AND   F.FunctionId NOT IN (SELECT FunctionId 
			                       FROM   ApplicantFunctionAction
								   WHERE  FunctionId = '#URL.IDFunction#'
								    AND   Status = '0')  
   </cfquery>
   
   <cfif Missing.recordcount gt "0">
   
	   <cf_RosterActionNo 
		    ActionRemarks="Correction" 
			ActionCode="FUN"
			Date="01/01/2004">  
   
	   <cf_RosterActionNo ActionRemarks="Opened application - no action" ActionCode="FUN"> 
	   
	   <cfquery name="PopulateMissing"
		   datasource="AppsSelection"
		   username="#SESSION.login#"
		   password="#SESSION.dbpw#">
			INSERT INTO ApplicantFunctionAction
			(ApplicantNo, FunctionId, RosterActionNo, Status)
			SELECT F.ApplicantNo, '#URL.IDFunction#', #RosterActionNo#,'0'
			FROM  ApplicantFunction F
			WHERE F.FunctionId = '#URL.IDFunction#'
			<!---
			AND   F.Status != '9'
			--->
			AND   F.FunctionId NOT IN (SELECT FunctionId 
			                           FROM ApplicantFunctionAction
									   WHERE F.FunctionId = '#URL.IDFunction#'
									   AND  F.Status = '0') 
	   </cfquery>
     
   </cfif>
      
<cfquery name="SearchResult"
	   datasource="AppsSelection"
	   username="#SESSION.login#"
	   password="#SESSION.dbpw#">
		SELECT		DISTINCT F.Status,
		            F.Status as ProcessStatus, 
					 
					 (SELECT Meaning 
					  FROM   Ref_StatusCode H 
					  WHERE  F.Status = H.Status 
					  AND    H.Id     = 'FUN' 
					  AND    H.Owner  = '#Function.Owner#') as ProcessMeaning,
					 COUNT(*) AS Total
		
		FROM		userQuery.dbo.#SESSION.acc#CandidateTmp#FileNo# F 
		WHERE   	F.FunctionId = '#URL.IDFunction#'
		AND         F.Status != '9'
	
		GROUP BY 	F.Status, F.Status
		UNION
		SELECT      DISTINCT F.Status, 
		            FA.Status as ProcessStatus,
				    (SELECT Meaning 
					  FROM   Ref_StatusCode H 
					  WHERE  FA.Status = H.Status 
					  AND    H.Id     = 'FUN' 
					  AND    H.Owner  = '#Function.Owner#') as ProcessMeaning, 
				    COUNT(DISTINCT S.PersonNo) AS Total
        FROM        ApplicantFunctionAction FA, 
		            ApplicantFunction F, 
				    ApplicantSubmission S
		WHERE       F.FunctionId = '#URL.IDFunction#'
		AND         F.Status = '9' 
		AND         FA.ApplicantNo = F.ApplicantNo 
		AND         FA.FunctionId  = F.FunctionId
		AND         S.ApplicantNo = F.ApplicantNo 
        AND         FA.Status < '5'
        GROUP BY 	F.Status, FA.Status
		ORDER BY 	F.Status
</cfquery>
  
<cf_LayoutScript>

<cf_dialogStaffing>
<cfajaximport tags="cfdiv,cfform">
   		 
<cfset attrib = {type="Border",name="mybox",fitToWindow="Yes"}>

<cf_layout attributeCollection="#attrib#">

	<cf_layoutarea position="header" name="header" minsize= "40px" maxsize= "40px" size= "40px">
	
	    <cf_tl id="Bucket processing" var="1">
		
		<cf_ViewTopMenu label="#lt_text# #Function.OwnerDescription#" background="linesBlue">
	
	</cf_layoutarea>	
		
	<cf_layoutarea position="center" name="box">
				
		 <cfinclude template="FunctionViewLoopMain.cfm">
					
	</cf_layoutarea>	
	
	<cf_layoutarea 
	    position    = "left" 
		name        = "treebox" 
		maxsize     = "270" 		
		size        = "270" 
		minsize     = "270"
		collapsible = "true" 
		splitter    = "true"
		overflow    = "scroll">
   
	<table width="99%" height="100%" align="center">
	
	<tr>
	<td width="260" valign="top">
	   
		<cfinclude template="FunctionViewLoopTab.cfm">
		
	</td>
	
	</tr>
	</table>  
	
	</cf_layoutarea>	
	 
</cf_layout>

<cf_screenbottom layout="innerbox">
