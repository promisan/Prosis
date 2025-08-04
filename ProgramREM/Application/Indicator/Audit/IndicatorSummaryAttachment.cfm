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

<table width="100%" height="100%" cellspacing="0" cellpadding="0"><tr><td>

<link href="<cfoutput>#SESSION.root#</cfoutput>/<cfoutput>#client.style#</cfoutput>" rel="stylesheet" type="text/css">

<cfparam name="URL.Row" default="1">

<cfquery name="Org"
datasource="AppsProgram" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">	
SELECT OrgUnit 
 FROM  Organization.dbo.Organization 
 WHERE Mission    = '#URL.Mission#'
  AND  MandateNo  = '#URL.Mandate#'
  AND  HierarchyCode >= '#HStart#' 
  AND  HierarchyCode < '#HEnd#'
</cfquery>						  

<cfinvoke component="Service.Access"
	Method="organization"
	OrgUnit="#Org.OrgUnit#"
	Period="#URL.Period#"
	Role="ProgramManager"
	ReturnVariable="AttachmentAccess">	

<cfquery name="Parameter"
datasource="AppsProgram" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">			  
SELECT * 
FROM   Parameter
</cfquery>

<cfif AttachmentAccess eq "NONE">

	<cf_filelibraryN
			DocumentPath = "#Parameter.DocumentLibrary#"
			SubDirectory = "#URL.Org#_#URL.Period#" 
			Filter       = ""
			rowheader    = "No"
			Insert       = "no"
			Remove       = "no"
			reload       = "true">	

<cfelse>

	<cf_filelibraryN
			DocumentPath="#Parameter.DocumentLibrary#"
			SubDirectory="#URL.Org#_#URL.Period#" 
			Filter=""
			Insert="yes"
			Remove="yes"
			reload="true">	
		
</cfif>		
</td></tr></table>