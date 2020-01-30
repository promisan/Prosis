
<cfparam name="URL.ID" default="0">
<cfparam name="URL.ID1" default="0">

<!--- define vacancy candidates --->

<cfquery name="CheckCandidate" 
      datasource="#CLIENT.Datasource#" 
      username="#SESSION.login#" 
      password="#SESSION.dbpw#">
      SELECT PersonNo, Last_name, First_name
      FROM IMP_VacancyCandidate
	  WHERE VacancyNo = '#URL.ID1#'
	  AND Interview_Ind is not null
</cfquery>

<cfquery name="UpdateDocumentHeader" 
datasource="#CLIENT.Datasource#" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
UPDATE Document
SET ReferenceNo        = '#URL.ID1#'
WHERE DocumentNo       = '#URL.ID#'	
</cfquery>

<cfoutput query="CheckCandidate">

<cfquery name="Verify" 
      datasource="#CLIENT.Datasource#" 
      username="#SESSION.login#" 
      password="#SESSION.dbpw#">
      SELECT PersonNo
      FROM DocumentCandidate
	  WHERE DocumentNo = '#URL.ID#'
	  AND PersonNo = '#PersonNo#'
</cfquery>

<cfif Verify.recordCount eq 0>

<CF_RegisterAction 
   SystemFunctionId="1201" 
   ActionClass="Galaxy Candidate" 
   ActionType="Enter" 
   ActionReference="#URL.ID# #PersonNo#" 
   ActionScript="">    

   <cfquery name="InsertCandidate" 
    datasource="#CLIENT.Datasource#" 
    username="#SESSION.login#" 
    password="#SESSION.dbpw#">
  INSERT INTO DocumentCandidate
         (DocumentNo,
		 PersonNo,
		 LastName,
		 FirstName,
		 OfficerUserId,
		 OfficerLastName,
		 OfficerFirstName,	
		 Created)
  VALUES ('#URL.ID#',
          '#PersonNo#',
		  '#Last_Name#',
		  '#First_Name#',
		  '#SESSION.acc#',
    	  '#SESSION.last#',		  
	  	  '#SESSION.first#',
		  '#DateFormat(Now(),"mm/dd/yyyy")#')
  </cfquery>	
  
</cfif>  

</cfoutput>

<cfoutput>
<script>
	window.location = "../CandidateEntry.cfm?ID=#URL.ID#" 
</script>
</cfoutput>

