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
<link rel="stylesheet" type="text/css" href="<cfoutput>#SESSION.root#/#client.style#</cfoutput>"> 

<cfparam name="Form.Operational" default="0">
<cfparam name="Form.TriggerTrack" default="0">
<cfparam name="Form.ShowVacancy" default="0">

<cf_ColorConvert RGB	 ="#Form.PresentationColor#"
				 variable="vColor">
				 
<cfif ParameterExists(Form.Insert)> 

<cfquery name="Verify" 
datasource="AppsEmployee" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT *
	FROM   Ref_VacancyActionClass
	WHERE  Code  = '#Form.Code#' 
</cfquery>

   <cfif Verify.recordCount is 1>
   
   <script language="JavaScript">
   
     alert("a record with this code has been registered already!")
     
   </script>  
  
   <cfelse>
   
	<cfquery name="Insert" 
	datasource="AppsEmployee" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	INSERT INTO Ref_VacancyActionClass
	         (Code,
			 Description,
			 TriggerTrack,
			 PresentationColor,
			 ListingOrder,			
			 Operational,
			 ShowVacancy,
			 OfficerUserId,
			 OfficerLastName,
			 OfficerFirstName)
	  VALUES ('#Form.Code#',
	          '#Form.Description#', 
	          '#Form.TriggerTrack#', 
	          '#vColor#', 
	          '#Form.ListingOrder#', 			
			  '#Form.Operational#',
			  '#Form.ShowVacancy#',
			  '#SESSION.acc#',
	    	  '#SESSION.last#',		  
		  	  '#SESSION.first#')
	</cfquery>
		  
    </cfif>		  
           
</cfif>

<cfif ParameterExists(Form.Update)>

<cfquery name="Update" 
datasource="AppsEmployee" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	UPDATE Ref_VacancyActionClass
	SET    Code              = '#Form.Code#',
		   Description       = '#Form.Description#',
		   TriggerTrack      = '#Form.TriggerTrack#',
		   ShowVacancy       = '#Form.ShowVacancy#',
		   PresentationColor = '#vColor#',
		   ListingOrder      = '#Form.ListingOrder#',	
		   Operational       = '#Form.Operational#'
	WHERE  Code              = '#Form.CodeOld#'
</cfquery>

</cfif>	

<cfif ParameterExists(Form.Delete)> 

<cfquery name="CountRec" 
      datasource="AppsEmployee" 
      username="#SESSION.login#" 
      password="#SESSION.dbpw#">
      SELECT TOP 1 *
      FROM Position
      WHERE VacancyActionClass  = '#Form.Codeold#' 
    </cfquery>

    <cfif CountRec.recordCount gt 0>
		 
     <script language="JavaScript">    
	   alert("Class is in use. Operation aborted.")     
     </script>  
	 
    <cfelse>
			
		<cfquery name="Delete" 
		datasource="AppsEmployee" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			DELETE FROM Ref_VacancyActionClass
			WHERE Code = '#FORM.Code#'
	    </cfquery>
	
	</cfif>
	
</cfif>	

<script language="JavaScript">
   
     window.close()
	 opener.location.reload()
        
</script>  
