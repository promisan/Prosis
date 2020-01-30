
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


