
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

<script language="JavaScript">

function menu() {
	window.location = "<cfoutput>#SESSION.root#</cfoutput>/System/Access/Menu.cfm"
}	

</script>

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

<cfif url.button eq "1">

	<table width="100%" align="center" align="center" class="formpadding">
	
		<cfif menu eq "1">
		<tr><td colspan="1" class="line"></td></tr>
		<cfelse>
		<tr><td height="6"></td></tr>
		</cfif>
		
		<tr><td align="center" style="padding-right:10px">
		
			<cfoutput>
			  <input type="button" value="Menu" class="button10g"  onclick="javascript:menu()">	
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

</cfif>




