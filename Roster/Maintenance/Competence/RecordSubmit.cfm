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

<cfif ParameterExists(Form.Insert)> 

<cfquery name="Verify" 
datasource="AppsSelection" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
SELECT *
FROM Ref_Competence
WHERE CompetenceId   = '#Form.CompetenceId#' 

</cfquery>

    <cfif Verify.recordCount is 1>
   
	   <script language="JavaScript">
	   
	     alert("A record with this code has been registered already!")
	     
	   </script>  
  
   <CFELSE>
    
		<cfquery name="Insert" 
		datasource="AppsSelection" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		INSERT INTO Ref_Competence
		         (CompetenceId,
				 Description, 
				 ListingOrder,
				 CompetenceCategory,
				 Operational,
				 OfficerUserId,
				 OfficerLastName,
				 OfficerFirstName,	
				 Created)
		  VALUES ('#Form.CompetenceId#', 
		          '#Form.Description#',
				  '#Form.ListingOrder#',
				  '#Form.CompetenceCategory#',
				  '#Form.Operational#',
				  '#SESSION.acc#',
		    	  '#SESSION.last#',		  
			  	  '#SESSION.first#',
				  getDate())
		</cfquery>
		  
	</cfif>	  

</cfif>

<cfif ParameterExists(Form.Update)>

	<cfquery name="Update" 
	datasource="AppsSelection" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	UPDATE Ref_Competence
	SET    CompetenceId 	   = '#Form.CompetenceId#',
		   Description         = '#Form.Description#',
	       ListingOrder        = '#Form.ListingOrder#',
	       CompetenceCategory  = '#Form.CompetenceCategory#',
		   Operational         = '#Form.Operational#'
	WHERE  CompetenceId        = '#Form.CompetenceIdOld#'
	</cfquery>

</cfif>


<cfif ParameterExists(Form.Delete)> 

    <cfquery name="CountRec" 
     datasource="AppsSelection" 
     username="#SESSION.login#" 
     password="#SESSION.dbpw#">
     SELECT    CompetenceId
     FROM      ApplicantCompetence
     WHERE     CompetenceId  = '#Form.CompetenceId#'
    </cfquery>

    <cfif #CountRec.recordCount# gt 0>
		 
     <script language="JavaScript">
    
	   alert("Id is in use. Operation aborted.")
     
     </script>  
	 	 
    <cfelse>

 <CF_RegisterAction 
SystemFunctionId="0999" 
ActionClass="Competence" 
ActionType="Remove" 
ActionReference="#Form.CompetenceId#" 
ActionScript="">   
		
	<cfquery name="Delete" 
datasource="AppsSelection" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
DELETE FROM Ref_Competence 
WHERE CompetenceId   = '#Form.CompetenceId#'
    </cfquery>
	
    </cfif>	
	
</cfif>	
	
<script language="JavaScript">
   
     window.close()
	 opener.location.reload()
        
</script>  
	
