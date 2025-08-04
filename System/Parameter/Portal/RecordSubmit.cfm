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

<cfparam name="Form.LocationFunctionId" default="">

<cfif ParameterExists(Form.Insert)> 

<cfif Form.class eq "Press">

	<cfif not DirectoryExists("#SESSION.rootDocumentPath#\PortalLinks\#URL.PortalId#")>
    	     
      <cfdirectory 
		  action   = "CREATE" 
	      directory= "#SESSION.rootDocumentPath#\PortalLinks\#URL.PortalId#">
	  
	</cfif>

	<CFFILE
			action="UPLOAD"
			fileField="LocationURL"
			destination="#SESSION.rootDocumentPath#\PortalLinks\#URL.PortalId#"
			nameConflict="MAKEUNIQUE">
		
		<cfset loc = "#form.LocationRoot#/PortalLinks/#URL.PortalId#/#File.ClientFile#">
		
<cfelse>

		<cfset loc = Form.LocationURL>
	
</cfif>	

<cfset dateValue = "">
<CF_DateConvert Value="#Form.ActivityDate#">
<cfset dte = dateValue>
   
<cfquery name="Insert" 
datasource="AppsSystem" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	INSERT INTO PortalLinks
	         (PortalId,
			 Class,
			 SystemFunctionId,
			 LanguageCode,
			 Description,
			 ListingOrder,
			 ActivityDate,
			 LocationURL,
			 LocationFunctionId,
			 LocationTarget,	
			 HostNameList,OfficerUserId, OfficerLastName, OfficerFirstName)
	  VALUES ('#URL.PortalId#',
	          '#Form.Class#',
			  <cfif Form.SystemFunctionId neq "">
			  '#Form.SystemFunctionId#',
			  <cfelse>
			  NULL,
			  </cfif> 			
			  <cfif Form.LanguageCode neq "">
			  '#Form.LanguageCode#',
			  <cfelse>
			  NULL,
			  </cfif>
	          '#Form.Description#', 
			  '#Form.ListingOrder#',
			  #dte#,
			  <cfif Form.LocationFunctionId eq "">
			  '#loc#',
			  NULL,
			  <cfelse>
			  '',
			  '#Form.LocationFunctionId#',
			  </cfif>
			  '#Form.LocationTarget#',
			  '#Form.HostNameList#',
			  '#SESSION.acc#',
			  '#SESSION.last#',
			  '#SESSION.first#')
</cfquery>

</cfif>		 
 
        
<cfif ParameterExists(Form.Update)>
	
	<cfquery name="Update" 
	datasource="AppsSystem" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	UPDATE PortalLinks
	SET 
	    Class          = '#Form.Class#',
	    Description    = '#Form.Description#',
		<cfif Form.SystemFunctionId neq "">
		SystemFunctionId = '#Form.SystemFunctionId#',
		</cfif>
		<cfif Form.LanguageCode neq "">
		LanguageCode     = '#Form.LanguageCode#', 
		</cfif>
		<cfif Form.LocationFunctionId eq "">
		LocationURL    = '#Form.LocationURL#',
		<cfelse>
		LocationFunctionId = '#Form.LocationFunctionId#',
		</cfif>
		LocationTarget = '#Form.LocationTarget#',
		ListingOrder   = '#Form.ListingOrder#',
		HostNameList   = '#Form.HostNameList#'
	WHERE PortalId     = '#url.PortalId#'
	</cfquery>

</cfif>	

<cfif ParameterExists(Form.Delete)> 
		
	<cfquery name="Delete" 
datasource="AppsSystem" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
DELETE FROM PortalLinks
WHERE PortalId = '#url.PortalId#'
    </cfquery>
	
</cfif>	

<script language="JavaScript">
   
     parent.window.close()
	 parent.opener.history.go()
	 
</script>  
