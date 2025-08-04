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

<cf_divscroll>

<cfset add          = "1">
<cfinclude template = "../HeaderMaintain.cfm"> 

<table width="97%" align="center">  

<cfoutput>

<script>

	function recordadd() {
		ptoken.open("RecordAdd.cfm?idmenu=#url.idmenu#", "Add", "left=80, top=80, width= 600, height= 300, toolbar=no, status=yes, scrollbars=no, resizable=yes");
	}
	
	function recordedit(id1) {
	    ptoken.open("RecordEdit.cfm?idmenu=#url.idmenu#&ID1=" + id1, "Edit", "left=80, top=80, width= 500, height= 400, toolbar=no, status=yes, scrollbars=no, resizable=yes");
	}

</script>	

</cfoutput>

<tr>

	<td colspan="2" id="tdListing">
		<cfinclude template="RecordListingDetail.cfm">
	</td>

</TABLE>

</cf_divscroll>