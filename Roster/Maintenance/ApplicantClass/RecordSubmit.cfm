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

<link rel="stylesheet" type="text/css" href="<cfoutput>#SESSION.root#/#client.style#</cfoutput>"> 

<cfif ParameterExists(Form.Insert)> 

<cfquery name="Verify" 
datasource="AppsSelection" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT *
	FROM Ref_ApplicantClass
	WHERE ApplicantClassId  = '#Form.ApplicantClassId#' 
</cfquery>

   <cfif #Verify.recordCount# is 1>
   
	   <script language="JavaScript">
	   
	     alert("a record with this code has been registered already!")
	     
	   </script>  
	  
   <cfelse>
   
		<cfquery name="Insert" 
		datasource="AppsSelection" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			INSERT INTO Ref_ApplicantClass (ApplicantClassId,Scope, Description)
			VALUES ('#Form.ApplicantClassId#','#Form.Scope#','#Form.Description#')
			
		</cfquery>
		  
    </cfif>		  
           
</cfif>

<cfif ParameterExists(Form.Update)>

<cfquery name="Update" 
datasource="AppsSelection" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	UPDATE Ref_ApplicantClass
	SET    ApplicantClassId = '#Form.ApplicantClassId#',
    	   Description      = '#Form.Description#',
		   Scope            = '#Form.Scope#'
	WHERE  ApplicantClassId = '#Form.ApplicantClassIdOld#'
</cfquery>

</cfif>	

<cfif ParameterExists(Form.Delete)> 

	<cfquery name="CountRec" 
      datasource="AppsSelection" 
      username="#SESSION.login#" 
      password="#SESSION.dbpw#">
     	 SELECT TOP 1 ApplicantClass
     	 FROM   Applicant
    	 WHERE  ApplicantClass  = '#Form.ApplicantClassIdOld#' 
    </cfquery>

    <cfif CountRec.recordCount gt 0>
		 
     <script language="JavaScript">
    
	   alert(" Class is in use. Operation aborted.")
     
     </script>  
	 
    <cfelse>
			
		<cfquery name="Delete" 
		datasource="AppsSelection" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			DELETE FROM Ref_ApplicantClass
			WHERE  ApplicantClassId    = '#Form.ApplicantClassIdOld#'
	    </cfquery>
	
	</cfif>
		
</cfif>	

<script language="JavaScript">
   
     window.close()
	 opener.location.reload()
        
</script>  
