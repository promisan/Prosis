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
<cfparam name="url.owner" default="">

<script language="JavaScript">

function selectexperienceall(chk) {

var count=1
while (count < 30) {
	
    se = document.getElementById("selected_"+count)
	if (se) {
	ln = document.getElementById("line"+count)
    
	if (chk == true) {
	     ln.className = "highLight5";
		 document.getElementById("experience"+count).className = "regular"
		 se.checked = true;
	} else {      
		 ln.className = "regular";
		 document.getElementById("experience"+count).className = "hide"
	     se.checked = false; 
	}		   
	}
    count++;
   }	
}

ie = document.all?1:0
ns4 = document.layers?1:0

function selectexperience(itm,fld,row){
   	 
     if (ie){
          while (itm.tagName!="TR")
          {itm=itm.parentElement;}
     }else{
          while (itm.tagName!="TR")
          {itm=itm.parentNode;}
     }	 	 		 	
	 if (fld != false){		
	 itm.className = "highLight5";
	 document.getElementById("experience"+row).className = "regular"
	 }else{		
     itm.className = "regular";		
	 document.getElementById("experience"+row).className = "hide"
	 }
  }

</script>

<cfquery name="Line" 
datasource="AppsSelection" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
	FROM ApplicantReview
	WHERE ReviewId = '#Object.ObjectKeyValue4#' 
</cfquery>

<cfif URL.Owner eq "">
	<cfset URL.Owner = Line.Owner>
</cfif>

<cfquery name="Priority" 
datasource="AppsSelection" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
	FROM Ref_Priority	
</cfquery>

<cfquery name="Reference" 
datasource="AppsSelection" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
	FROM Ref_ReviewClass
	WHERE Code IN (SELECT ReviewCode 
	               FROM ApplicantReview 
	               WHERE PersonNo = '#Object.ObjectKeyValue1#'
				   AND   ReviewId = '#Object.ObjectKeyValue4#') 
</cfquery>

<cfquery name="SearchResult" 
datasource="AppsSelection" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
   SELECT    A.Source AS Source, 
             B.*, 
			 C.ExperienceId as CurrentAssigned
	FROM     ApplicantSubmission A INNER JOIN
             ApplicantBackground B ON A.ApplicantNo = B.ApplicantNo LEFT OUTER JOIN
             ApplicantReviewBackground C ON B.ExperienceId = C.ExperienceId AND A.PersonNo = '#Object.ObjectKeyValue1#' AND ReviewId = '#Object.ObjectKeyValue4#'
    WHERE    A.ApplicantNo      = B.ApplicantNo
	AND      A.PersonNo         = '#Object.ObjectKeyValue1#'
	AND      B.Status           <> '9' 	
	AND      ExperienceCategory = '#Reference.ExperienceCategory#'
	ORDER BY A.Source, B.ExperienceStart DESC
</cfquery>

<cfinclude template="BackgroundDetail.cfm">

<cfoutput>
   <input name="savecustom" type="hidden"  value="Roster/Candidate/Details/Review/BackgroundSubmit.cfm">
   <input name="Key1" type="hidden"   value="#Object.ObjectKeyValue1#">  
   <input name="Owner" type="hidden"  value="#URL.owner#">
   <input name="Key4" type="hidden"   value="#Object.ObjectKeyValue4#">
</cfoutput> 
	
