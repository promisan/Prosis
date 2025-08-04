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

<cfparam name="back"        default="1">
<cfparam name="menu"        default="0">
<cfparam name="page"        default="1">
<cfparam name="add"         default="1">
<cfparam name="save"        default="0">
<cfparam name="option"      default="">
<cfparam name="header"      default="">
<cfparam name="URL.IDRefer" default="">
<cfparam name="URL.IDMenu"  default="">
<cfparam name="URL.button"  default="1">

<cf_screenTopMaintenance>


<cfoutput>

<script language="JavaScript">

function menu() {
  
	ptoken.location("#SESSION.root#/System/parameter/Menu.cfm")
}	

</script>
</cfoutput>

<cfif menu eq "1">
	
	<cftry>
			
		<cfoutput>
		
			   <cf_menuTopSelectedItem
			   	  idrefer        = "#URL.IDRefer#"
				  idmenu         = "#URL.IDMenu#"
				  showPage       = "#Page#"
				  showAdd        = "#Add#"
				  addHeader      = "#Header#"
				  template       = "HeaderMenu1"
				  systemModule   = "'System'"
				  items          = "3"
				  Header1        = "User"
		          FunctionClass1 = "'User Admin'"
		          MenuClass1     = "'Main'"
				  Header2        = "Settings"
		          FunctionClass2 = "'Setting'"
		          MenuClass2     = "'Main'"
				  Header3        = "Utilities"
		          FunctionClass3 = "'Utility'"
		          MenuClass3     = "'Main'">
			
		</cfoutput>  	
	
		<cfcatch></cfcatch>
	
	</cftry>

</cfif>

<cfif url.button eq "1" and back eq "1">

	<table width="100%" align="center" align="center" class="formpadding">
	
		<cfif menu eq "1">
		<tr><td colspan="1" class="line"></td></tr>
		<cfelse>
		<tr><td height="6"></td></tr>
		</cfif>
		
		<tr><td align="center" style="padding-right:10px">
		
			<cfoutput>
			  <input type="button" value="Back" class="button10g"  onclick="javascript:menu()">	
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
			
		<cfif page eq "1">
		<tr bgcolor="ffffff">
			<td align="right" style="padding-right:20px">
				<cfinclude template="../../Tools/PageCount.cfm">
			    <select name="page" id="page" class="regularxl" size="1" onChange="javascript:reloadForm(this.value)">
			       <cfloop index="Item" from="1" to="#pages#" step="1">
				        <cfoutput><option value="#Item#"<cfif #URL.page# eq "#Item#">selected</cfif>>Page #Item# of #pages#</option></cfoutput>
			       </cfloop>	 
			    </SELECT>  
			</td>
		</tr>	
		</cfif>
	
	</table>
	
<cfelse>

	<table width="100%" align="center" align="center" class="formpadding"><tr class="line"><td></td></tr></table>

</cfif>
