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
<cfif URL.PublishNo eq "">

	<cfquery name="Line" 
	datasource="AppsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT *
	FROM Ref_EntityClassAction
	WHERE ActionCode  = '#GetAction.ActionCode#'
	AND   EntityClass = '#URL.EntityClass#'
	AND   EntityCode  = '#URL.EntityCode#' 
	</cfquery>
	
<cfelse>

	<cfquery name="Line" 
	datasource="AppsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT *
	FROM Ref_EntityActionPublish A
	WHERE A.ActionCode    = '#GetAction.ActionCode#'
	AND A.ActionPublishNo = '#URL.PublishNo#'
	</cfquery>
	
</cfif>	
	
<cfoutput>

<table width="97%" border="0" cellspacing="0" align="center" cellpadding="0">
	<tr><td height="6"></td></tr>
	<tr>
        <td>#Line.ActionSpecification#</td>
	</TR>
</table>
			
</cfoutput>	