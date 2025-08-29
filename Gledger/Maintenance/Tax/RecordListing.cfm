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
<cfquery name="SearchResult"
datasource="AppsLedger" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
	FROM Ref_Tax
</cfquery>

<cf_screentop html="No" jquery="Yes">

<cfset Page         = "0">
<cfset add          = "1">
<cfset Header       = "Tax Code">

<table height="100%" width="94%" align="center" cellspacing="0" cellpadding="0" align="center">

<tr><td>

<cfinclude template = "../HeaderMaintain.cfm"> 

</td></tr>

<cfoutput>

<script>

function recordadd(grp) {
     ptoken.open("RecordAdd.cfm?idmenu=#url.idmenu#", "Add", "left=80, top=80, width=700, height= 450, toolbar=no, status=yes, scrollbars=no, resizable=no");
}

function recordedit(id) {
     ptoken.open("RecordEdit.cfm?idmenu=#url.idmenu#&ID1=" + id, "Edit", "left=80, top=80, width=700, height= 450, toolbar=no, status=yes, scrollbars=no, resizable=no");
}

</script>

</cfoutput>

<tr>
<td style="height:100%">

<cf_divscroll>

<table width="100%" class="navigation_table">

<tr class="fixrow labelmedium2 line fixlengthlist">
    <td align="left"></td>
    <td align="left">Code</td>
	<td align="left">Description</td>
	<td align="left">Percentage</td>
	<td align="left">Calculation</td>
	<td align="left">Rounding</td>
	<td align="left">Account Paid</td>
	<td align="left">Account Received</td>
	<td align="left">Officer</td>
    <td align="left">Entered</td>
</tr>

<cfset i = 0>
<cfoutput query="SearchResult">
    
    <tr class="navigation_row labelmedium2 line fixlengthlist">
	<td align="center" style="padding-top:1px">
		  <cf_img icon="open" navigation="Yes" onclick="recordedit('#TaxCode#')">
	</td>
	<td height="23">#TaxCode#</td>
	<td>#Description#</td>
	<td align="right">#NumberFormat(Percentage*100,'.___')#%</td>
	<td>#TaxCalculation#</td>
	<td><cfif TaxRounding eq "1">Yes<cfelse>No</cfif></td>
	<td>#GLAccountPaid#</td>
	<td>#GLAccountreceived#</td>
	<td>#OfficerFirstName# #OfficerLastName#</td>
	<td>#Dateformat(Created, "#CLIENT.DateFormatShow#")#</td>
    </tr>

</cfoutput>

</table>

</cf_divscroll>

</td></tr>

</table>

<cfset ajaxonload("doHighlight")>
