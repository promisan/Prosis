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

<!--- edit of the log fields --->

<cfparam name="url.field" default="">
<cfparam name="url.mode" default="view">
<cfparam name="url.value" default="">

<cfif url.mode eq "save">

	<cfquery name="update" 
	datasource="AppsPurchase" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    UPDATE PurchaseLineAmendment
		SET #url.field# = '#url.value#'  
		WHERE  RequisitionNo = '#url.requisitionno#'
		AND    AmendmentId = '#url.id#'
	</cfquery>

	<cfset url.mode = "view">

</cfif>

<cfquery name="get" 
datasource="AppsPurchase" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
    FROM   PurchaseLineAmendment
	WHERE  RequisitionNo = '#url.requisitionno#'
	AND    AmendmentId = '#url.id#'
</cfquery>

<cfoutput>

<cfset fld = url.field>

<cfif url.mode eq "view">
		
	<table width="100%" cellspacing="0" cellpadding="0">
		<tr>	
		<td class="labelit" width="90%">#evaluate("get.#fld#")#</td>	
		<td>&nbsp;</td>		
		<td width="20" align="center" style="padding-right:5px">		
			<cf_img icon="edit" onclick="ColdFusion.navigate('PurchaseLineEditLogField.cfm?requisitionno=#url.requisitionno#&id=#url.id#&mode=edit&field=#fld#','box#fld#_#url.id#')">
	    </td>
		</tr>
	</table>	
		
<cfelse>

	<cfif url.field eq "Reference">
	    <cfset max = "20">
	<cfelse>
		<cfset max = "100">
	</cfif>		
		
	<table width="100%" cellspacing="0" cellpadding="0">
		<tr>
		<td width="90%"><input type="text" id="#fld#_#url.id#" value="#get.Reference#" maxlength="#max#" class="regular" style="width:100%">		
		<td>&nbsp;</td>	
		<td width="20" align="center"><img src="#SESSION.root#/images/save_template1.gif" alt="save" style="cursor:pointer" height="13" width="13" alt="" border="0"
		onclick="ColdFusion.navigate('PurchaseLineEditLogField.cfm?requisitionno=#url.requisitionno#&id=#url.id#&mode=save&field=#fld#&value='+document.getElementById('#fld#_#url.id#').value,'box#fld#_#url.id#')"></td>
		<td>&nbsp;&nbsp;</td>
		</td>			
		</tr>
	</table>			

</cfif>

</cfoutput>