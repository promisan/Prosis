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
<cf_screentop height="100%" jquery="yes" scroll="Yes" html="No">

<table width="98%" height="100%" align="center">
		   
	<tr><td>
		
		<cfset back         = "0">
		<cfset Page         = "0">
		<cfset url.button   = "1">
		<cfset add          = "0">
		<cfset menu         = "1">
		<cfinclude template = "../HeaderMaintain.cfm"> 
	
	</td>
	</tr>

	<tr><td height="100%" valign="top">
	
		<table width="96%" height="99%" align="center">
		<tr>
		<td style="padding-top:4px:">
		
		<cf_listingscript>
		 
		<script>
				 
			function recordadd(grp) {
			     ptoken.open('FunctionAdd.cfm','role','left=80, top=80, width=700, height=580, toolbar=no, status=yes, scrollbars=no, resizable=no')			 	
			}
		
		</script>	
		
		<cfset url.systemfunctionid = url.idmenu>		
		<cfinclude template="RecordListingContent.cfm">
		
		</td>
		</tr>		
		</table>
		
	</td>
	</tr>

</table>