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

<cfoutput>

<cfparam name="URL.ID" default="0"> 

<cftree name="root"
   font="verdana"
   fontsize="11"		
   bold="No"   
   format="html"    
   required="No"> 
   
<cfquery name="Roster" 
datasource="AppsSystem" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
  SELECT *
  FROM Ref_ModuleControl M
  WHERE M.SystemModule = 'Roster'
  AND M.FunctionClass  = 'Applicant'
  AND M.FunctionName   = 'Roster'
</cfquery>
 
<cfquery name="Class" 
datasource="AppsSelection" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
  SELECT DISTINCT Excerciseclass
  FROM Ref_ExerciseClass C, Ref_SubmissionEdition S
  WHERE C.ExcerciseClass = S.ExerciseClass
  AND C.Roster = '1'
</cfquery>

<cfloop query = "Class">
 
  <cfset Cls = Class.Excerciseclass>
  
  <cftreeitem value="#cls#"
       display="<span style='padding-top:3px;padding-bottom:3px;color: B08C42;' class='labellarge'><b>#CLS#</span>"
       parent="Root"								
	   expand="Yes">	
  
  <cfquery name="Edition" 
datasource="AppsSelection" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
  SELECT *
  FROM Ref_SubmissionEdition
  WHERE ExerciseClass = '#Cls#'
</cfquery>

  <cfloop query="Edition">
     
	 <cfset ed = "#SubmissionEdition#">
	 
	  <cftreeitem value="#ed#"
	        display="#EditionDescription#"
			parent="#cls#"												
	        expand="No">		
			   	 
	 <cfquery name="AccessLevels" 
	 datasource="AppsOrganization"
	 username="#SESSION.login#" 
	 password="#SESSION.dbpw#">
		 SELECT 	*
		 FROM 		Ref_AuthorizationRole 		
		 WHERE 		Role = 'RosterClear' 
	</cfquery>
	
	<cfset accessLabel = ListToArray(AccessLevels.accesslevelLabelList)>
		 
	<cfloop index="level" from="0" to="#AccessLevels.accesslevels-1#">
	
	  <cftreeitem value="status_#accessLabel[level+1]#"
	        display="#accessLabel[level+1]#"
			parent="#ed#"									
			target="right"
			href="ControlListing.cfm?ID=#ed#&ID1=#level#"
	        expand="No">			
	  		
	 </cfloop>
		      
  </cfloop>
     
  </cfloop>
  


</cftree>  
    
</cfoutput>


