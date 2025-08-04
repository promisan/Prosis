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

<cfquery name="Entity" 
	datasource="AppsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT *
	FROM Ref_Entity
	WHERE EntityCode = '#URL.EntityCode#'
</cfquery>

<cfquery name="Class" 
	datasource="AppsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT *
	FROM Ref_EntityClass
	WHERE EntityCode  = '#URL.EntityCode#'
	AND   EntityClass = '#URL.EntityClass#'	
</cfquery>

<cfquery name="Embed" 
	datasource="AppsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT *
	FROM Ref_EntityClass
	WHERE EntityCode = '#URL.EntityCode#'
	AND EmbeddedFlow = '1'
</cfquery>

<cfquery name="Dialog" 
	datasource="AppsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT *
	FROM Ref_EntityDocument
	WHERE EntityCode = '#URL.EntityCode#'
	AND DocumentType = 'Dialog'
	ORDER BY DocumentDescription
	</cfquery>
	
<cfquery name="Mail" 
	datasource="AppsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT *
	FROM  Ref_EntityDocument
	WHERE EntityCode = '#URL.EntityCode#'
	AND   DocumentType = 'Mail'
	ORDER BY DocumentDescription
	</cfquery>	
	
<cfquery name="Script" 
	datasource="AppsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT *
	FROM  Ref_EntityDocument
	WHERE EntityCode = '#URL.EntityCode#'
	AND   DocumentType = 'Script'
	ORDER BY DocumentDescription
	</cfquery>			

	