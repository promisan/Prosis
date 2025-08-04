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

<cfparam name="Form.AllowEdit" 		 default="0">
<cfparam name="Form.AllowAssessment" default="0">
<cfparam name="Form.Operational" 	 default="0">

<cfif ParameterExists(Form.Insert)> 

	<cfquery name="Verify" 
	datasource="AppsSelection" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT  *
		FROM    Ref_Source
		WHERE   Source  = '#Form.Source#' 
	</cfquery>

   <cfif Verify.recordCount is 1>
   
   <script language="JavaScript">
   
     alert("A Source with this code has been registered already!")
     
   </script>  
  
   <cfelse>

		<cfquery name="Insert" 
		datasource="AppsSelection" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
	
			INSERT INTO Ref_Source
			       (Source, 
				    Description, 
					AllowEdit,
					AllowAssessment,
					Operational,
					EntityClass,
					OfficerUserId,
					OfficerLastName,
					OfficerFirstName)
			VALUES ('#Form.Source#',
			        '#Form.Description#',
					'#Form.AllowEdit#',
					'#Form.AllowAssessment#',
					'#Form.Operational#',
					<cfif Form.EntityClass eq "">
			   		NULL,
				    <cfelse>
				    '#Form.EntityClass#',
			   	    </cfif>
					'#session.acc#',
					'#session.last#',
					'#session.first#'
					)	
		 </cfquery>
		  
    </cfif>		  
           
<cfelseif ParameterExists(Form.Update)>

	<cfquery name="Update" 
	datasource="AppsSelection" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		UPDATE Ref_Source
		SET    Description		= '#Form.Description#',
			   AllowAssessment  = '#Form.AllowAssessment#',
			   AllowEdit		= '#Form.AllowEdit#',
			   Operational		= '#Form.Operational#',
			   <cfif Form.EntityClass eq "">
			   EntityClass      = NULL,
			   <cfelse>
			   EntityClass      = '#Form.EntityClass#',
			   </cfif>
			   PHPMode			= '#Form.PHPMode#'
		WHERE  Source 			= '#Form.Source#'
	</cfquery>

<cfelseif ParameterExists(Form.Delete)> 

	<cfquery name="CountRec" 
      datasource="AppsSelection" 
      username="#SESSION.login#" 
      password="#SESSION.dbpw#">
	  	  SELECT Source
		  FROM   Ref_Topic
		  WHERE  Source = '#Form.Source#'
		  
		  UNION
		  
      	  SELECT Source
	      FROM   ApplicantSubmission
    	  WHERE  Source  = '#Form.Source#' 
    </cfquery>

    <cfif CountRec.recordCount gt 0>
			 
	     <script language="JavaScript">
	    
		   alert(" Source is in use. Operation aborted.")
	     
	     </script>  
	 
    <cfelse>
	
			
		<cfquery name="Delete" 
		datasource="AppsSelection" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			DELETE FROM Ref_Source
			WHERE  Source = '#FORM.Source#'
	    </cfquery>
	
	</cfif>
	
	
</cfif>	

<script language="JavaScript">
   
     window.close()
	 opener.location.reload()
        
</script>  
