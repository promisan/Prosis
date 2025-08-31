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
<cf_screentop height="100%" jQuery="Yes" scroll="yes" html="No" menuaccess="context">
<cf_ListingScript>

<table width="99%" height="100%" border="0" cellspacing="0" cellpadding="0" align="center" bordercolor="silver" class="formpadding">

	<tr><td height="10" style="padding-left:7px">	
		  <cfset url.header = "0">
		  <cfset ctr      = "1">		
	      <cfset openmode = "close"> 
		  <cfinclude template="../PersonViewHeaderToggle.cfm">		  
		 </td>
	</tr>
	
	<tr>
	<td height="100%" valign="top">	
		<cfinclude template="ActionListContent.cfm">
	</td>
	</tr>

</table>
