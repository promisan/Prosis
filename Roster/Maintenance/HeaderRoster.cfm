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
<cfparam name="page"   default="1">
<cfparam name="add"    default="1">
<cfparam name="header" default="">
<cfparam name="URL.IDRefer" default="">
<cfparam name="URL.IDMenu"  default="">

<cf_screentopMaintenance>	

<script language="JavaScript">

function menu() {
	ptoken.location("<cfoutput>#SESSION.root#</cfoutput>/roster/maintenance/Menu.cfm")
}	

</script>

<body leftmargin="0" topmargin="0" rightmargin="0" bottommargin="0"></body>
<cftry>
	
	<cfoutput>
	
		   <cf_menuTopSelectedItem
		   	  idrefer        = "#URL.IDRefer#"
			  idmenu         = "#URL.IDMenu#"
			  showPage       = "#Page#"
			  showAdd        = "#Add#"
			  addHeader      = "#Header#"
			  template       = "HeaderMenu1"
			  systemModule   = "'Roster'"
			  items          = "3"
			  Header1        = "Bucket"
	          FunctionClass1 = "'Maintain'"
	          MenuClass1     = "'Bucket'"
	          Header2        = "PHP"
	          FunctionClass2 = "'Maintain'"
	          MenuClass2     = "'PHP'"
			  Header3        = "Roster"
	          FunctionClass3 = "'Maintain'"
	          MenuClass3     = "'Roster'">
		
	</cfoutput>  	

	<cfcatch></cfcatch>

</cftry>

<cfif add eq "1">
	<table width="100%" align="center" class="formpadding">
	<tr><td height="1" class="linedotted"></td></tr>
	<tr><td height="28" align="center">
		<cfoutput>
		  <input type="button" value="Back" class="button10g"  onclick="menu()">	
	      <input type="button" value="Add"  class="button10g"  onclick="javascript:recordadd('')">
		</cfoutput>
		</td>
	</tr>
	<tr><td height="1" class="linedotted"></td></tr>
	</table>
</cfif>		



