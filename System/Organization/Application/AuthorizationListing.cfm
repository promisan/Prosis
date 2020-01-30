	
<cfparam name="URL.ID1" default="all">
<cfparam name="URL.ID2" default="0">
<cfparam name="URL.ID3" default="0000">

<cfoutput>

<script>

w = #CLIENT.width# - 80;
h = #CLIENT.height# - 120;

function showtreerole(role) {	
	window.open("#SESSION.root#/System/Organization/Access/OrganizationRolesView.cfm?Mission=#url.id2#&Class=" + role, "_blank", "left=40, top=40, width=" + w + ", height= " + h + ", toolbar=no, status=yes, scrollbars=no, resizable=yes") 			
}
	
function show(par) {
	
	 se1 = document.getElementById(par+"Exp")
	 se2 = document.getElementById(par+"Min")
	 se = document.getElementsByName("g"+par)
	 cnt = 0
	 
	  if (se2.className == "regular") {
	 	 
		 se1.className = "regular"
		 se2.className = "hide"	 
		 while (se[cnt])  { se[cnt].className = "hide"; cnt++ }
		 		 
		 
	 } else  {	 

		 se1.className = "hide"
		 se2.className = "regular"
		 while (se[cnt]) { se[cnt].className = "regular"; cnt++ }
		 
	 }	 
	
	}	
	

</script>

</cfoutput>

<cf_screentop height="100%" scroll="yes" html="No" jQuery="yes">

<table width="99%" height="100%" align="center" border="0" cellspacing="0" cellpadding="0" class="formpadding">

<tr><td height="1" colspan="2">

<cfset url.header = 0>
<cfinclude template="OrganizationViewHeader.cfm">

</td></tr>

<tr>  
  
  <td height="100%" width="99%" align="center" colspan="2" valign="top">  
  
  		
  	<cfdiv id="tree" bind="url:../Access/OrganizationAuthorizationTabDetail.cfm?scope=tree&mode=direct&mission=#url.id2#">
	
	   
  </td>
  
</tr>
	   
</table>

<cf_screenbottom html="No">