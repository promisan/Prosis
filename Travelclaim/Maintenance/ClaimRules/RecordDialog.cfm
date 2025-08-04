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

<cfparam name="URL.Id" default="{00000000-0000-0000-0000-000000000000}">

<cfquery name="Get" 
	datasource="AppsTravelClaim" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT *
	FROM  Ref_Validation R, Ref_ValidationClass C
	WHERE R.ValidationClass = C.Code
	AND   R.Code = '#URL.Id#'
</cfquery>

<cfquery name="Class" 
	datasource="AppsTravelClaim" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT *
	FROM  Ref_ValidationClass
</cfquery>

<cfif #Get.Recordcount# eq "0">
<cfset mode = "Insert">
<cfelse>
<cfset mode = "Modify">
</cfif>

<cfoutput>

<script language="JavaScript">

function toggle(ln) {
se = document.getElementById("selected_"+ln)
am = document.getElementById("amount_"+ln)

if (se.checked == true)	{
   am.className = "amount"
   } else {
   am.className = "hide" }

}
</script>

<cf_screentop height="100%" layout="webapp"  banner="yellow" scroll="Yes" label="Claim Validation #Mode#">

<input type="hidden" name="id" value="#URL.ID#">

<table width="98%" align="center">
	<tr>
		<td>	
			<cfinclude template="RecordDialogTab.cfm">
		</td>
	</tr>
</table>


</cfoutput>
