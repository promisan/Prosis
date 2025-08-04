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

<cfoutput>

<script language="JavaScript">

function refreshTree() {
	location.reload();
}

</script>
</cfoutput>

<cfset Criteria = ''>

<table width="100%" height="100%" align="center" class="tree">

   <tr><td valign="top" style="padding-left:6px">
    <table width="97%" align="center">
		
	  <tr class="line"><td style="height:20px"></td></tr>
	  <tr><td style="height:10px"></td></tr>		  
	  
      <tr><td><cf_FunctionTreeData></td></tr>
    </table></td>
  </tr>
</table>
