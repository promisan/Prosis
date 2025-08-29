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
datasource="AppsPurchase" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
SELECT *
FROM Ref_JobCategory
WHERE Code  = '#Form.Code#' 

</cfquery>

    <cfif #Verify.recordCount# is 1>
   
   <script language="JavaScript">
   
     alert("A record with this code has been registered already!")
     
   </script>  
  
 <CFELSE>
  
   
<cfquery name="Insert" 
datasource="AppsPurchase" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
INSERT INTO Ref_JobCategory
         (Code,
		 Description,
		 OfficerUserId,
		 OfficerLastName,
		 OfficerFirstName,	
		 Created)
  VALUES ('#Form.Code#', 
          '#Form.Description#',
		  '#SESSION.acc#',
    	  '#SESSION.last#',		  
	  	  '#SESSION.first#',
		  getDate()) 
</cfquery>
		  
	</cfif>	  

</cfif>

<cfif ParameterExists(Form.Update)>

	<cfquery name="Update" 
	datasource="AppsPurchase" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	UPDATE Ref_JobCategory
	SET   Description    = '#Form.Description#' ,
	      Code           = '#Form.Code#'
	WHERE Code    = '#Form.CodeOld#' 
	</cfquery>

</cfif>


<cfif ParameterExists(Form.Delete)> 

    <cfquery name="CountRec" 
     datasource="AppsPurchase" 
     username="#SESSION.login#" 
     password="#SESSION.dbpw#">
     SELECT    *
     FROM     Job
     WHERE    JobCategory = '#Form.Code#'  
	 </cfquery>
	
    <cfif #CountRec.recordCount# gt 0 >
		 
     <script language="JavaScript">
    
	   alert("Job Group is in use. Operation aborted.")
     
     </script>  
	 	 
    <cfelse>	
			
		<cfquery name="Delete" 
		datasource="AppsPurchase" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			DELETE FROM Ref_JobCategory
			WHERE Code = '#Form.code#'
	    </cfquery>
		
		<cfquery name="Check" 
		datasource="AppsOrganization" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT  *
			FROM    OrganizationObject
			WHERE   (EntityCode = 'ProcJob') AND (EntityGroup = '#Form.Code#')
	    </cfquery>
		
		<cfif Check.recordcount eq "0">
		
			<cfquery name="Update" 
		datasource="AppsOrganization" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			DELETE FROM Ref_EntityGroup			
			WHERE  EntityCode = 'ProcJob'
			AND    EntityGroup = '#Form.code#'
	    </cfquery>
		
		
		<cfelse>
				
		<cfquery name="Update" 
		datasource="AppsOrganization" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			UPDATE Ref_EntityGroup
			SET    Operational = 0
			WHERE  EntityCode = 'ProcJob'
			AND    EntityGroup = '#Form.code#'
	    </cfquery>
		
		</cfif>
	
    </cfif>	
	
</cfif>	

<cfquery name="Group" 
	datasource="AppsPurchase" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT * 
	FROM Ref_JobCategory
	</cfquery>				  	
		
<cfloop query="Group">
			
	  <cf_insertEntityGroup  
		      EntityCode="ProcJob"   
              EntityGroup="#Code#"
              EntityGroupName="#Description#">	
					 
</cfloop>	
	
<script language="JavaScript">
   
     window.close()
	 opener.location.reload()
        
</script>  