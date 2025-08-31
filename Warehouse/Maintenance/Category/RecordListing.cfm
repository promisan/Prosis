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
<cf_screentop jquery="yes" html="no">
	
<cfset Page         = "0">
<cfset add          = "1">

<table width="97%" align="center" style="height:100%">

<tr><td style="height:10px">
	<cfinclude template = "../HeaderMaintain.cfm"> 
</td></tr>

<cfoutput>
	
	<script>
	
	function recordadd(grp) {
	      ptoken.open("RecordAdd.cfm?idmenu=#url.idmenu#", "Add category");
	}
	
	function recordedit(id1) {
	      ptoken.open("RecordEditTab.cfm?idmenu=#url.idmenu#&ID1=" + id1, id1);
	}
	
	function recordpurge(id1) {
		if (confirm('Do you want to remove this category ?')) {
			ptoken.navigate('RecordPurge.cfm?id1='+id1, 'divDetail');
		}
	}

</script>	

</cfoutput>

<tr><td colspan="2" style="padding-top:4px" style="height:100%">
	<cf_divscroll>
		<cfdiv id="divDetail" bind="url:RecordListingDetail.cfm">
	</cf_divscroll>
</td>

</TABLE>

