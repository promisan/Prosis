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
<body leftmargin="3" topmargin="3" rightmargin="3" bottommargin="3"></body> 

<cfparam name="page"        default="1">
<cfparam name="add"         default="0">
<cfparam name="save"        default="0">
<cfparam name="option"      default="">
<cfparam name="header"      default="">
<cfparam name="URL.IDRefer" default="">
<cfparam name="URL.IDMenu"  default="">

<cf_screentopMaintenance>

<script language="JavaScript">

function menu() {
	ptoken.location("<cfoutput>#SESSION.root#</cfoutput>/CaseFile/maintenance/Menu.cfm")
}	

</script>

<cftry>

<cfoutput>

	 <cf_menuTopSelectedItem
	   	  idrefer        = "#URL.IDRefer#"
		  idmenu         = "#URL.IDMenu#"
		  showPage       = "#Page#"
		  showAdd        = "#Add#"
		  addHeader      = "#Header#"
		  template       = "HeaderMenu1"
		  systemModule   = "'Insurance'"
		  items          = "2"
		  Header1        = "Parameters"
		  FunctionClass1 = "'Maintain'"
		  MenuClass1     = "'Main'"
		  Header2        = "Reference Tables"
		  FunctionClass2 = "'Reference'"
		  MenuClass2     = "'Main'">
	
</cfoutput>  	

<cfcatch></cfcatch>

</cftry>

<table width="100%" border="0" cellspacing="0" cellpadding="0" align="center">
	<tr><td height="1" class="linedotted"></td></tr>
	<tr><td height="28" align="center">  <!--- style="background-image:url('<cfoutput>#SESSION.root#</cfoutput>/Images/bg_back.jpg');" --->
	<cfoutput>
	  <input type="button" value="Back" class="button10g"  onclick="menu()">	
	  <cfif add eq "1">
      <input type="button" value="Add" class="button10g"  onclick="javascript:recordadd('')">
	  </cfif>
	  <cfif option neq "">
	  #option#
	  </cfif>
	  <cfif save eq "1">
	  <input type="submit" name="Update" value="Update" class="button10g">
	  </cfif>
	</cfoutput>
	</td>
</tr>
<tr><td class="linedotted"></td></tr>
<tr><td height="7"></td></tr>
</table>



