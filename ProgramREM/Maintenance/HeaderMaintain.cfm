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
<link rel="stylesheet" type="text/css" href="<cfoutput>#SESSION.root#/#client.style#</cfoutput>">
<body leftmargin="3" topmargin="3" rightmargin="3" bottommargin="3"></body> 

<cfparam name="page"        default="1">
<cfparam name="add"         default="1">
<cfparam name="save"        default="0">
<cfparam name="option"      default="">
<cfparam name="header"      default="">
<cfparam name="URL.IDRefer" default="">
<cfparam name="URL.IDMenu"  default="">

<cf_screenTopMaintenance>

<script language="JavaScript">

function menu() {
	ptoken.location("<cfoutput>#SESSION.root#</cfoutput>/ProgramRem/maintenance/Menu.cfm")
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
			  systemModule   = "'Program'"
			  items          = "4"
			  Header1        = "Settings"
	          FunctionClass1 = "'System'"
	          MenuClass1     = "'Main'"
			  Header2        = "Reference"
	          FunctionClass2 = "'Maintain'"
	          MenuClass2     = "'Main'"
			  Header3        = "Indicator"
	          FunctionClass3 = "'Maintain'"
	          MenuClass3     = "'Indicator'"
			  Header4        = "Allotment"
	          FunctionClass4 = "'Maintain'"
	          MenuClass4     = "'Allotment'">
		
	</cfoutput>  	

	<cfcatch></cfcatch>

</cftry>

<table width="100%" border="0" cellspacing="0" cellpadding="0" align="center">

	<tr><td class="line" height="1"></td></tr>
	<tr><td height="30" align="center">
		<cfoutput>
		  <input type="button" value="Menu" class="button10g"  onclick="menu()">	
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
	<tr><td class="line"></td></tr>
	<tr><td height="7"></td></tr>
	
</table>




