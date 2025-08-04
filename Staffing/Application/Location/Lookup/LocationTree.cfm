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

<cf_screentop html="No" label="Select Location">

<cfoutput>

<script language="JavaScript1.2">

function check() {
	
	if (window.event.keyCode == "13") {
	   se = document.getElementById("search");
	   se.click()
	}
}

function refreshTree() {
	location.reload(); }

function search(condition) {
	
	<cfif #URL.Mode# eq "Lookup">
		parent.right.location="LocationListingFlat.cfm?Mode=#URL.Mode#&Mission=#URL.Mission#&ID1=" + condition + "&FormName=#URL.formname#&fldlocationcode=#URL.fldlocationcode#&fldlocationname=#URL.fldlocationname#"
	<cfelse>
		parent.right.location="LocationListingFlat.cfm?Mode=#URL.Mode#&Mission=#URL.Mission#&ID1=" + condition
	</cfif>

}

</script>

<table border="0" cellspacing="0" cellpadding="0">
  
  <tr><td height="10"></td></tr>
  
  <tr>
  	<td style="padding-left:5px;padding-right:6px" class="labelmedium2"><cf_tl id="Find">:</td>
	
	<td>
	  <input type="text" onKeyUp="javascript:check()" id="condition" name="condition" size="10" maxlength="20" class="regularxxl">
    </td>
	
    <td onClick="search(condition.value)" id="search" style="padding-left:1px;cursor:pointer"></td>
   
  </tr>
 
  </table>
  
</cfoutput>
