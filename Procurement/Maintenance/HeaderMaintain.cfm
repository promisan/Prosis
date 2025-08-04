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
<cfparam name="page"   default="1">
<cfparam name="add"    default="1">
<cfparam name="option" default="">
<cfparam name="header" default="">
<cfparam name="URL.IDRefer" default="">
<cfparam name="URL.IDMenu"  default="">

<cf_screenTopMaintenance>

<script language="JavaScript">

function menu() {
	ptoken.location("<cfoutput>#SESSION.root#</cfoutput>/procurement/maintenance/Menu.cfm")
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
		  systemModule   = "'Procurement'"
		  items          = "4"
		  Header1        = "System Tables"
          FunctionClass1 = "'System'"
          MenuClass1     = "'Main'"
		  
		  Header2        = "Requisition"
          FunctionClass2 = "'Maintain'"
          MenuClass2     = "'Requisition'"
		  
		  Header3        = "Purchase"
          FunctionClass3 = "'Maintain'"
          MenuClass3     = "'Purchase'"
		  
		  Header4        = "Invoice"
          FunctionClass4 = "'Maintain'"
          MenuClass4     = "'Invoice'">
	
</cfoutput>  	

<cfcatch></cfcatch>

</cftry>

<table width="100%" border="0" cellspacing="0" cellpadding="0" align="center" class="formpadding">
<tr><td height="1" class="line"></td></tr>
<tr><td height="28" align="left" style="padding-bottom:2px">
    <table width="100%" cellspacing="0" cellpadding="0">
	<tr><td style="padding-top:4px;padding-left:18px">
	<cfoutput>
	  <input type="button" value="Menu" style="width:120;height:25;font-size:13px" class="button10g"  onclick="menu()">	
	  <cfif add eq "1">
      <input type="button" value="Add" style="width:120;height:25;font-size:13px"  class="button10g" onclick="javascript:recordadd('')">
	  </cfif>
	  </td>
	  <cfif option neq ""><td align="right">#option#</td></cfif>
	</cfoutput>
	</tr>
	</table>
	</td>
</tr>
</table>

