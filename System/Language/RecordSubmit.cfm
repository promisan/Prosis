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

<cfparam name="Form.SystemDefault" default="0">
<cfparam name="Form.Interface" default="0">

<cfif Form.SystemDefault eq "1">

<cfquery name="Update" 
	datasource="AppsSystem" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		UPDATE Ref_SystemLanguage
		SET  SystemDefault  = '0'
	</cfquery>
	
</cfif>	

<cfif ParameterExists(Form.Update)>

	<cfquery name="Update" 
	datasource="AppsSystem" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		UPDATE Ref_SystemLanguage
		SET    LanguageName   = '#Form.Description#',
		       Interface = '#form.Interface#',
		       Operational    = '#Form.Operational#',
			   SystemDefault  = '#Form.SystemDefault#'
		WHERE  Code = '#Form.Code#'
	</cfquery>
	
</cfif>	

<cfif Form.SystemDefault eq "1">

<cfquery name="Update" 
	datasource="AppsSystem" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		UPDATE Ref_SystemLanguage
		SET    Operational  = '2'
		WHERE  Operational < '2'
		AND    Code = '#Form.Code#' 		
	</cfquery>
	
</cfif>	

<!--- initializing --->

<script language="JavaScript">
   
     window.close()
	 opener.location.reload()
        
</script>  
