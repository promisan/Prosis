
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

<table width="100%" border="0" cellspacing="0" cellpadding="0" align="center" class="formpadding">
	
	<tr><td class="line"></td></tr>
	
	<cf_tl id="Menu"   var="vMenu">
	<cf_tl id="Add"    var="vAdd">
	<cf_tl id="Update" var="vUpdate">
	<cf_tl id="Back"   var="vBack">
	
	<tr><td height="35" 
	   style="padding-left:20px;background-image:url('<cfoutput>#SESSION.root#</cfoutput>/Images/bg_back.jpg')">

	 <cfoutput>
	
	  <input type="button" value="#vMenu#" class="button10g"  onclick="menu()">		  
	  <cfif add eq "1">
      	<input type="button" value="#vAdd#" class="button10g" onclick="javascript:recordadd('')">
	  </cfif>
	  <cfif option neq "">#option# </cfif>
	  <cfif save eq "1">
	  	  <input type="submit" name="Update" id="Update" value="#vUpdate#" class="button10g">
	  </cfif>
	  
	 </cfoutput>
	
		</td>
	</tr>

</table>
