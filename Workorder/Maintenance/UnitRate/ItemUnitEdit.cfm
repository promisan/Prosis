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
<cfquery name="ServiceItem" 
		datasource="AppsWorkorder" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT *
		FROM   ServiceItem
		WHERE  Code = '#URL.ID1#'		
</cfquery>	 	

<cf_screentop height="100%" label="Provisioning #serviceitem.description#" scroll="No" jquery="Yes" option="Service Item Unit Maintenance [#url.id1#]" bannerheight="75"  line="no" layout="webapp" banner="gray">
	
<table height="100%" width="100%" class="formpadding" align="center">
			
 <tr class="hide"><td><iframe name="process" id="process" frameborder="0"></iframe></td></tr>
 
 <tr><td height="100%" style="padding-left:20px;padding-right:20px">

<CFFORM style="height:100%" action="ItemUnitSubmit.cfm?id1=#url.id1#&id2=#url.id2#" target="process" method="post" name="formunit">

	<cf_divscroll style="height:100%" id="divServiceItemUnit">
	<cfinclude template="ItemUnitEditContent.cfm">
	</cf_divscroll>

</cfform>

</td></tr>

</table>

	<script language="JavaScript">
		
		function ask() {
			if (confirm("Do you want to remove this record ?")) {			
			return true 			
			}			
			return false			
		}	
		
		function labelme(val) {
		
		   if (val == "Detail") {
		    document.getElementById("labelling").className = "regular"
		   } else {
		    document.getElementById("labelling").className = "hide"
		   }
		}
	
	</script>
	

