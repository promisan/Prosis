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

<!---
<cf_screentop height="100%" scroll="yes"   
   user="yes" 
   html="No"
   close="ColdFusion.Window.hide('dialogrequest')">
   --->

<table width="100%" bgcolor="white" height="100%">

<tr><td valign="top" style="padding:13px">
		
   		<cfform method="POST" name="cartform" onsubmit="return false">

   	   		<cfset url.mode = "dialog">
	   		<cfinclude template="StockRequestAdd.cfm"> 
  
   		</cfform>
  
	 </td>
</tr>

</table>
