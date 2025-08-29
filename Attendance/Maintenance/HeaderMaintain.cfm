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
<link rel="stylesheet" type="text/css" href="<cfoutput>#SESSION.root#/#client.style#</cfoutput>">
<body leftmargin="0" topmargin="0" rightmargin="0" bottommargin="0"></body>

<script language="JavaScript">

function menu() {
	ptoken.location("<cfoutput>#SESSION.root#</cfoutput>/attendance/maintenance/Menu.cfm")
}	

</script>

<cfparam name="page"        default="1">
<cfparam name="add"         default="1">
<cfparam name="save"        default="0">
<cfparam name="option"      default="">
<cfparam name="header"      default="">
<cfparam name="URL.IDRefer" default="">
<cfparam name="URL.IDMenu"  default="">

<cf_screentopMaintenance>

<cftry>
	
	<cfoutput>
	
		   <cf_menuTopSelectedItem
		   	  idrefer        = "#URL.IDRefer#"
			  idmenu         = "#URL.IDMenu#"
			  showPage       = "#Page#"
			  showAdd        = "#Add#"
			  addHeader      = "#Header#"
			  template       = "HeaderMenu1"
			  systemModule   = "'Attendance'"
			  items          = "1"
			  Header1        = "Reference Tables"
	          FunctionClass1 = "'Maintain'"
	          MenuClass1     = "'Main'">
		
	</cfoutput>  	

	<cfcatch></cfcatch>

</cftry>

<table width="100%" border="0" cellspacing="0" cellpadding="0" class="formpadding" align="center">
<tr><td class="linedotted" height="1"></td></tr>
<tr><td height="28" align="center">
	<cfoutput>
	  <input type="button" value="Back" class="button10g"  onclick="menu()">	
	  <cfif add eq "1">
      <input type="button" value="Add" class="button10g"  onclick="javascript:recordadd('')">
	  </cfif>
	  <cfif option neq "">
	  #option#
	  </cfif>
	  <cfif save eq "1">
	  <input type="submit" name="Update" id="Update" value="Update" class="button10g">
	  </cfif>
	</cfoutput>
	</td>
</tr>
<tr><td class="linedotted" height="1"></td></tr>
</table>




