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
<cf_screentop html="no">

<div style="position:absolute;width:100%;height:100%; overflow: auto; scrollbar-face-color: F4f4f4;">

<table width="99%" align="center"><tr><td>

<cfquery name="Document" 
 datasource="AppsOrganization"
 username="#SESSION.login#" 
 password="#SESSION.dbpw#">
 SELECT *
 FROM  OrganizationObjectAction OA
 WHERE ActionId  = '#URL.id#' 
 </cfquery>

<cfoutput>
#Document.ActionMemo#
</cfoutput>
</td></tr></table>
</div>

<cfif len(Document.ActionMemo) lte 500>

<cfoutput>
	<script>
	frm = parent.document.getElementById("document#url.box#")
	frm.height = 80
	</script>
</cfoutput>

</cfif>