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
<cf_screentop html="No" jquery="Yes">

<table width="98%" height="100%">

<cfset Page         = "0">
<cfset add          = "1">
<cfset save         = "0"> 
<tr style="height:10px"><td><cfinclude template = "../HeaderMaintain.cfm"></td></tr>

<cfoutput>

<script>

	function recordadd(grp) {
		ptoken.open("RecordEdit.cfm?idmenu=#url.idmenu#&ID1=", "AddContributionClass", "left=80, top=80, width=550, height=300, toolbar=no, status=yes, scrollbars=no, resizable=yes");
	}
	
	function recordedit(id1) {
		ptoken.open("RecordEdit.cfm?idmenu=#url.idmenu#&ID1=" + id1, "EditContributionClass", "left=80, top=80, width=550, height=300, toolbar=no, status=yes, scrollbars=no, resizable=yes");
	}
	
	function recordpurge(id1) {
		if (confirm('Do you want to remove this contribution class ?')) {
			ptoken.navigate('RecordPurge.cfm?id1='+id1,'detail');
		}
	}

</script>

</cfoutput> 
	
<tr>
	<td colspan="2" valign="top" align="center">
		<cf_securediv id="detail" bind="url:RecordListingDetail.cfm">
	</td>

</table>
