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
<cf_listingscript>

<cfoutput>

<script>
	function recordadd() {
    	 window.open("RecordEdit.cfm?mode=add&idmenu=#url.idmenu#", "Add", "left=80, top=80, width=800,height=690, toolbar=no, status=yes, scrollbars=no, resizable=no");
	}
</script>  
                     
</cfoutput>		

<cfset url.systemfunctionid = url.idmenu>

<cfparam name="page"        default="1">
<cfparam name="add"         default="0">
<cfparam name="save"        default="0">
<cfparam name="option"      default="">
<cfparam name="header"      default="">
<cfparam name="URL.IDRefer" default="">
<cfparam name="URL.IDMenu"  default="">

<cf_screentop height="100%" scroll="Yes" html="No">

<table width="100%" 
       height="100%" 
	   align="center" 
	   border="0" 
	   cellspacing="0" 
	   cellpadding="0">
	   
	<tr><td height="40">
		
		<cfset Page         = "0">		
		<cfinclude template="../HeaderParameter.cfm"> 
	
	</td></tr>
	
	<tr>
	<td height="100%" valign="top">
	
		<table width="98%" height="100%" align="center">
		
		<tr><td height="99%" align="center" style="padding-left:15px;padding-right:15px">
		      <cfinclude template="RecordListingContent.cfm">	
		</td></tr>
		
		</table>
		
	</td>
	</tr>

</table>