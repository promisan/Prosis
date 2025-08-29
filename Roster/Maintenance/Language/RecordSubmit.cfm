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
FROM Ref_Language
WHERE LanguageId   = '#Form.LanguageId#' 

</cfquery>

    <cfif #Verify.recordCount# is 1>
   
   <script language="JavaScript">
   
     alert("a record with this code has been registered already!")
     
   </script>  
  
   <CFELSE>
   
<CF_RegisterAction 
SystemFunctionId="0999" 
ActionClass="Language" 
ActionType="Enter" 
ActionReference="#Form.LanguageId#" 
ActionScript="">      
   
<cfquery name="Insert" 
datasource="AppsSelection" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
INSERT INTO Ref_Language
         (LanguageId,
		 LanguageName, 
		 LanguageClass,
		 OfficerUserId,
		 OfficerLastName,
		 OfficerFirstName,	
		 Created)
  VALUES ('#Form.LanguageId#', 
          '#Form.LanguageName#',
		  '#Form.LanguageClass#',
		  '#SESSION.acc#',
    	  '#SESSION.last#',		  
	  	  '#SESSION.first#',
		  getDate())</cfquery>
		  
	</cfif>	  

</cfif>

<cfif ParameterExists(Form.Update)>

<CF_RegisterAction 
SystemFunctionId="0999" 
ActionClass="Language" 
ActionType="Update" 
ActionReference="#Form.LanguageId#" 
ActionScript="">       

<cfquery name="Update" 
datasource="AppsSelection" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	UPDATE Ref_Language
	SET LanguageName      = '#Form.LanguageName#',
		LanguageClass     = '#Form.LanguageClass#',
		LanguageId  	  = '#Form.LanguageId#'
	WHERE LanguageId      = '#Form.LanguageIdOld#'
</cfquery>

</cfif>


<cfif ParameterExists(Form.Delete)> 

    <cfquery name="CountRec" 
     datasource="AppsSelection" 
     username="#SESSION.login#" 
     password="#SESSION.dbpw#">
     SELECT    LanguageId
     FROM      ApplicantLanguage
     WHERE     LanguageId  = '#Form.LanguageId#'
    </cfquery>

    <cfif #CountRec.recordCount# gt 0>
		 
     <script language="JavaScript">
    
	   alert("Id is in use. Operation aborted.")
     
     </script>  
	 	 
    <cfelse>

 <CF_RegisterAction 
SystemFunctionId="0999" 
ActionClass="Language" 
ActionType="Remove" 
ActionReference="#Form.LanguageId#" 
ActionScript="">   
		
	<cfquery name="Delete" 
datasource="AppsSelection" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
DELETE FROM Ref_Language 
WHERE LanguageId   = '#Form.LanguageId#'
    </cfquery>
	
    </cfif>	
	
</cfif>	
	
<script language="JavaScript">
   
     window.close()
	 opener.location.reload()
        
</script>  
	
