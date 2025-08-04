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

<cfsilent>

<proUsr>administrator</proUsr>
<proOwn>Hanno van Pelt</proOwn>
<proDes>Laster update installed</proDes>
<proCom></proCom>
<proCM></proCM>

<proInfo>
<table width="100%" cellspacing="0" cellpadding="0">
<tr><td>
This template is part of the application framework and defines the toolbar menu to be presented to the user accessing the maintenance section of the Module travel Claim upon opening a maintenance function (usually a listing). 
Nb. The access rights defined will also affect the opions in the dropdown menu.
</td></tr>
</table>
</proInfo>

</cfsilent>

<cfparam name="page"        default="1">
<cfparam name="add"         default="1">
<cfparam name="save"        default="0">
<cfparam name="option"      default="">
<cfparam name="header"      default="">
<cfparam name="URL.IDRefer" default="">

<script language="JavaScript">

function menu() {
	window.location = "<cfoutput>#SESSION.root#</cfoutput>/travelclaim/maintenance/menu.cfm"
}	

</script>

<cf_screenTopMaintenance>

<cftry>

<cfoutput>

	   <cf_menuTopSelectedItem
	   	  idrefer        = "#URL.IDRefer#"
		  idmenu         = "#URL.IDMenu#"
		  showPage       = "#Page#"
		  showAdd        = "#Add#"
		  addHeader      = "#Header#"
		  template       = "HeaderMenu1"
		  systemModule   = "'TravelClaim'"
		  items          = "2"
		  Header1        = "Settings and Parameters"
		  FunctionClass1 = "'Maintain'"
		  MenuClass1     = "'Main'"
		  Header2        = "Reference Tables"
		  FunctionClass2 = "'Reference'"
		  MenuClass2     = "'Main'">
	
</cfoutput>  	

<cfcatch></cfcatch>

</cftry>

<table width="100%" cellspacing="0" cellpadding="1" align="center">
<tr><td height="1" class="line"></td></tr>
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
	  <input type="submit" name="Update" value="Update" class="button10g">
	  </cfif>
	</cfoutput>
	</td>
</tr>
</table>



