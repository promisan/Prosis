
<cfparam name="page"   default="1">
<cfparam name="add"    default="1">
<cfparam name="header" default="">
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
		  systemModule   = "'Payroll'"
		  items          = "1"
		  Header1        = "Reference Tables"
          FunctionClass1 = "'Maintain'"
          MenuClass1     = "'Main'">
	
</cfoutput>  	

<cfcatch></cfcatch>

</cftry>

<body leftmargin="0" topmargin="0" rightmargin="0" bottommargin="0"></body>
<cfif add eq "1">
	<table width="100%" border="0" cellspacing="0" cellpadding="0" align="center" class="formpadding">
	<tr><td colspan="7" class="line"></td></tr>
	<tr><td height="28" align="center">
		<cfoutput>
		  <input type="button" value="Back" class="button10g"  onclick="history.back()">	
	      <input type="button" value="Add" class="button10g"  onclick="javascript:recordadd('')">
		</cfoutput>
		</td>
	</tr>
	
	</table>
</cfif>		



