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
datasource="AppsCaseFile" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT *
	FROM Ref_ClaimTypeTab
	WHERE 
	Mission = '#Form.Mission#'
	AND Code  = '#Form.Code#' 
	AND TabName = '#Form.TabName#' 
</cfquery>


	<cfif #Verify.recordCount# is 1>
		<cf_tl id="An record with this code has been registered already!" class="Message" var="1">
   <cfoutput>
   
   <script language="JavaScript">
   
     alert("#lt_text#")
     
   </script>  
   </cfoutput>
  
   <CFELSE>
  
   
	<cfquery name="Insert" 
	datasource="AppsCaseFile" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	INSERT INTO Ref_ClaimTypeTab
         (
		 Mission,
		 Code,
		 TabName, 
		 TabLabel,
		 TabOrder,
		 TabIcon,
		 TabTemplate,	
		 TabElementClass,
		 AccessLevelRead,
		 AccessLevelEdit,		
		 ModeOpen,
		 Operational,
		 Created)
  VALUES (
		 '#FORM.Mission#',
		 '#FORM.Code#',
		 '#FORM.TabName#', 
		 '#FORM.TabLabel#',
		 '#FORM.TabOrder#',
		 '#FORM.TabIcon#',
		 '#FORM.TabTemplate#',	
		 '#FORM.TabElementClass#',
		 '#FORM.AccessLevelRead#',
		 '#FORM.AccessLevelEdit#',		
		 '#FORM.ModeOpen#',
		 '#FORM.Operational#',  
  	      getDate())
	</cfquery>
		  
	</cfif>	  

</cfif>

<cfif ParameterExists(Form.Update)>
     

<cfquery name="Update" 
datasource="AppsCaseFile" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">

		UPDATE Ref_ClaimTypeTab
		SET 
		 Mission='#Form.Mission#',
		 Code='#Form.Code#',
		 TabName='#Form.TabName#', 
		 TabLabel='#Form.TabLabel#',
		 TabOrder='#Form.TabOrder#',
		 TabIcon='#Form.TabIcon#',
		 TabTemplate='#Form.TabTemplate#',	
		 TabElementClass = '#Form.TabElementClass#',
		 AccessLevelRead='#Form.AccessLevelRead#',
		 AccessLevelEdit='#Form.AccessLevelEdit#',		
		 ModeOpen='#Form.ModeOpen#',
		 Operational='#Form.Operational#'		
		WHERE 
		Mission = '#Form.MissionOld#'
		AND Code  = '#Form.Code#' 
		AND TabName = '#Form.TabNameOld#'  

</cfquery>

</cfif>


<cfif ParameterExists(Form.Delete)> 

	<cfquery name="Delete" 
	datasource="AppsCaseFile" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		DELETE FROM Ref_ClaimTypeTab
		WHERE 
		Mission = '#Form.MissionOld#'
		AND Code  = '#Form.Code#' 
		AND TabName = '#Form.TabNameOld#' 
    </cfquery>
	
</cfif>	
	
<script language="JavaScript">
     window.close()
     try {
		window.opener.document.getElementById("menu3").click()
	 } catch(err) {	}
</script>  