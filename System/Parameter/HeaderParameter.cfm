
<cf_screenTopMaintenance>

<cfparam name="back"        default="1">
<cfparam name="page"        default="1">
<cfparam name="add"         default="1">
<cfparam name="save"        default="0">
<cfparam name="option"      default="">
<cfparam name="header"      default="">
<cfparam name="URL.IDRefer" default="">
<cfparam name="URL.IDMenu"  default="">
<cfparam name="URL.button"  default="1">

<!--- ----------------------------------------------------------- --->		 
<!--- ----------------------------------------------------------- --->		 
<!--- ----------------------------------------------------------- --->		

<cfoutput>

<script language="JavaScript">

function menu() {
  
	ptoken.location("#SESSION.root#/System/parameter/Menu.cfm")
}	

</script>
</cfoutput>

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
			  items          = "2"			 
			  Header1        = "Settings"
	          FunctionClass1 = "'Setting'"
	          MenuClass1     = "'Main'"
			  Header2        = "Utilities and Localization"
	          FunctionClass2 = "'Utility'"
	          MenuClass2     = "'Main'">
		
	</cfoutput>  	

	<cfcatch></cfcatch>

</cftry>

<cfif url.button eq "1" and back eq "1">
	
	<table width="100%" border="0" cellspacing="0" cellpadding="0" align="center">
	<tr><td height="1" class="linedotted"></td></tr>
	<tr><td height="28" align="center">
		<cfoutput>		
		  <input type="button" value="Back" class="button10g"  onclick="menu()">	
		  <cfif add eq "1">
	      <input type="button" value="Add" class="button10g"  onclick="recordadd('')">
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
		<td align="right">
			<cfinclude template="../../Tools/PageCount.cfm">
		    <select name="page" id="page" size="1" onChange="javascript:reloadForm(this.value)">
		       <cfloop index="Item" from="1" to="#pages#" step="1">
			        <cfoutput><option value="#Item#"<cfif URL.page eq "#Item#">selected</cfif>>Page #Item# of #pages#</option></cfoutput>
		       </cfloop>	 
		    </SELECT>  
		</td>
	</tr>	
		</cfif>
	<tr><td height="1" class="linedotted"></td></tr>
	</table>

</cfif>




