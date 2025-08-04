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
<cf_compression>

<cfquery name="Check" 
	datasource="AppsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT * FROM Ref_EntityDocument
	WHERE EntityCode = '#URL.entityCode#'
	AND   DocumentType = 'mail'
	AND   DocumentCode = '#URL.documentCode#'
</cfquery>

<cfset url.documentid = Check.documentid>

<cfif Check.mailto eq "List">
	
	<cfinclude template="../../EntityObject/MailList/MailList.cfm">

</cfif>