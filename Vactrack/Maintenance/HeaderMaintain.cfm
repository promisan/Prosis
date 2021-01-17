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
	ptoken.location("<cfoutput>#SESSION.root#</cfoutput>/staffing/maintenance/Menu.cfm")
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
			  systemModule   = "'Vacancy'"
			  items          = "1"
			  Header1        = "System"
	          FunctionClass1 = "'Maintain'"
	          MenuClass1     = "'Main'">
		
	</cfoutput>  	

	<cfcatch></cfcatch>

</cftry>


<table width="100%" border="0" cellspacing="0" cellpadding="0" align="center">
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
	  <input type="submit" onClick="document.getElementById('save').click()" name="Update" value="Update" class="button10g">
	  </cfif>
	</cfoutput>
	</td>
</tr>
<tr><td class="linedotted" height="1"></td></tr>
<tr><td height="3"></td></tr>
</table>





