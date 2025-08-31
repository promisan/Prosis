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
<cfset add          = "1">
<cfset Header       = "Bank Accounts">

<cf_screentop html="No" jquery="Yes">

<table height="100%" width="94%" align="center" cellspacing="0" cellpadding="0" align="center">

<tr><td style="height:10">

<cfinclude template = "../HeaderMaintain.cfm"> 

</td></tr>


<cfquery name="SearchResult"
datasource="AppsLedger" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT B.*, R.GLAccount, R.Description
	FROM    Ref_BankAccount B LEFT OUTER JOIN
        Ref_Account R ON B.BankId = R.BankId
</cfquery>

<cfoutput>
	
	<script>
	
	function recordadd(grp) {
         ptoken.open("RecordAdd.cfm?idmenu=#url.idmenu#", "Add", "left=80, top=80, width=890, height=790, toolbar=no, status=yes, scrollbars=no, resizable=no");
	}
	
	function recordedit(id) {
         ptoken.open("RecordEdit.cfm?idmenu=#url.idmenu#&ID=" + id, "Edit", "left=80, top=80, width=890, height=790, toolbar=no, status=yes, scrollbars=no, resizable=no");
	}
	
	</script>	

</cfoutput>

<tr><td>
	
	<cf_divscroll>
	
		
		<table width="99%" align="center" class="navigation_table">
		
			<tr class="labelmedium2 fixrow fixlengthlist">
			    <td></td>
			    <td><cf_tl id="Bank"></td>
				<td><cf_tl id="Curr"></td>				
				<td><cf_tl id="AccountNo"></td>
				<td><cf_tl id="Bank Address"></td>
			    <td><cf_tl id="GL Account"></td>
			</tr>			
			
				<cfoutput query="SearchResult">
				    <tr class="navigation_row line labelmedium2 fixlengthlist">
						<td align="center" style="width:30px">
							  <cf_img icon="select" navigation="yes" onclick="recordedit('#BankId#')">
						</td>
						<td title="#BankName#">#BankName#</td>
						<td>#Currency#</td>
						<td>#AccountNo#</td>
						<!---
						<td>#AccountName#</td>
						--->
						<td title="#Bankaddress#">#BankAddress#</td>
						<td title="#GLAccount# #Description#">#GLAccount# #Description#</td>
				    </tr>
				</cfoutput>
			
		
		</table>
	
	</cf_divscroll>

</td>

</table>

<cfset ajaxonload("doHighlight")>