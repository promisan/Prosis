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
<cfajaximport tags="cfdiv,cfform,cfinput-autosuggest">

<cfsavecontent variable="option">
	<cfoutput>
		<input type="button" class="button10g" name="Search" id="Search" value="New Search" onClick="javascript: window.location = 'ItemSearch.cfm?idmenu=#url.idmenu#';">
	</cfoutput>
</cfsavecontent>

<cfoutput>
<script>

function recordadd(transaction) {
	recordeditcustomermapping('new','#url.getNulls#');
}

function recordeditcustomermapping(transaction,getnulls) {
	wd = 750;
    ht = 275;
 	ptoken.open("#SESSION.root#/workorder/maintenance/customerMapping/RecordEdit.cfm?ID1="+transaction+"&ts="+new Date().getTime(), null, "left=100, top=100, width="+wd+", height="+ht+",menubar=no, toolbar=no, status=yes, scrollbars=no, resizable=yes");			
}
 
</script>

</cfoutput>
	
<cf_divscroll>
	
<cfset Page         = "0">
<cfset add          = "1">
<cfinclude template = "../HeaderMaintain.cfm"> 		
	
<table width="99%" border="0"  cellspacing="0" cellpadding="1" align="center">

	<tr><td class="line"></td></tr>
    <tr><td height="4"></td></tr>				
	<tr>
	
	    <td width="100%" id="listing">
		   <cfinclude template="RecordListingDetail.cfm">
		</td>
		
	</tr>		
	<tr><td height="5"></td></tr>				

</table>	
				
</cf_divscroll>