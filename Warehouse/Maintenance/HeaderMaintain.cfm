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
		ptoken.location("<cfoutput>#SESSION.root#</cfoutput>/warehouse/maintenance/Menu.cfm")
	}	

</script>

<link rel="stylesheet" type="text/css" href="<cfoutput>#SESSION.root#/#client.style#</cfoutput>">

<cftry>
	
	<cfoutput>
	
		   <cf_menuTopSelectedItem
		   	  idrefer         = "#URL.IDRefer#"
			  idmenu          = "#URL.IDMenu#"
			  showPage        = "#Page#"
			  showAdd         = "#Add#"
			  addHeader       = "#Header#"
			  template        = "HeaderMenu1"
			  systemModule    = "'Warehouse'"
			  items           = "4"
			  Header1         = "Settings"
	          FunctionClass1  = "'Maintain'"
	          MenuClass1      = "'System'"
			  Header2         = "Stock Control"
	          FunctionClass2  = "'Maintain'"
	          MenuClass2      = "'Stock'"			  
			  Header3         = "Asset Control"
	          FunctionClass3  = "'Maintain'"
	          MenuClass3      = "'Asset'"
			  Header4         = "Lookup"
	          FunctionClass4  = "'Maintain'"
	          MenuClass4      = "'Lookup'">
		
	</cfoutput>  	

	<cfcatch></cfcatch>

</cftry>

	<table width="100%">
		
		<tr><td colspan="4" class="line"></td></tr>
		
		<cfif add eq "1" or option neq "" or save eq "1">
		
		<cf_tl id="Menu"   var="vMenu">
		<cf_tl id="Add"    var="vAdd">
		<cf_tl id="Update" var="vUpdate">
		<cf_tl id="Back"   var="vBack">
		
		<tr>
	
		 <cfoutput>
		  <td style="width:10px;padding-left:10px;padding-right:4px">
		  <input type="button" value="#vMenu#" class="button10g"  onclick="menu()">		  
		  </td>
		  <cfif add eq "1">
		  	<td style="padding-left:3px">
	      	<input type="button" value="#vAdd#" class="button10g" onclick="javascript:recordadd('')">
			</td>
		  </cfif>
		  <cfif option neq ""><td style="padding-left:3px">#option#</td></cfif>
		  <cfif save eq "1">
		  	  <td style="padding-left:3px">
		  	  <input type="submit" name="Update" id="Update" value="#vUpdate#" class="button10g">
			  </td>
		  </cfif>	  
		 </cfoutput>
		
		</tr>
		
		</cfif>
	
	</table>


