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
<cfif ParameterExists(Form.Insert)> 

<cfquery name="Verify" 
datasource="AppsSelection" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT *
	FROM Ref_GradeDeployment
	WHERE GradeDeployment  = '#Form.GradeDeployment#' 
</cfquery>

    <cfif #Verify.recordCount# is 1>
   
   <script language="JavaScript">
   
     alert("a record with this code has been registered already!")
     
   </script>  
  
   <CFELSE>
      
<cfquery name="Insert" 
datasource="AppsSelection" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
INSERT INTO Ref_GradeDeployment
         (GradeDeployment,
		 Description, 
		 PostGradeBudget,
		 PostGradeParent,
		 ListingOrder,
		 OfficerUserId,
		 OfficerLastName,
		 OfficerFirstName,	
		 Created)
  VALUES ('#Form.GradeDeployment#', 
          '#Form.Description#',
		  '#Form.PostGradeBudget#',
		  '#Form.PostGradeParent#',
		  '#Form.ListingOrder#',
		  '#SESSION.acc#',
    	  '#SESSION.last#',		  
	  	  '#SESSION.first#',
		  getDate())</cfquery>
		  
	</cfif>	  

</cfif>

<cfif ParameterExists(Form.Update)>
	
	<cfquery name="Update" 
	datasource="AppsSelection" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	UPDATE Ref_GradeDeployment
	SET    Description      = '#Form.Description#', 
	       PostGradeBudget = '#form.PostGradeBudget#', 
		   ListingOrder    = '#Form.ListingOrder#',
		   PostGradeParent = '#Form.PostGradeParent#'
	WHERE GradeDeployment   = '#Form.GradeDeployment#'
	</cfquery>

</cfif>

<cfif ParameterExists(Form.Delete)> 

    <cfquery name="CountRec" 
     datasource="AppsSelection" 
     username="#SESSION.login#" 
     password="#SESSION.dbpw#">
     SELECT    GradeDeployment
     FROM      ApplicantDeploymentLevel
     WHERE     GradeDeployment  = '#Form.GradeDeployment#'
	 UNION
	 SELECT   GradeDeployment
	 FROM     FunctionOrganization
	 WHERE     GradeDeployment  = '#Form.GradeDeployment#'
    </cfquery>

    <cfif CountRec.recordCount gt 0>
		 
     <script language="JavaScript">
    
	   alert("GradeDeployment is in use. Operation aborted.")
     
     </script>  
	 	 
    <cfelse>
		
	<cfquery name="Delete" 
	datasource="AppsSelection" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	DELETE FROM Ref_GradeDeployment
	WHERE GradeDeployment  = '#Form.GradeDeployment#'
	    </cfquery>
	
    </cfif>	
	
</cfif>	
	
<script language="JavaScript">
   
     window.close()
	 opener.location.reload()
        
</script>  
	
