
<cf_screentop height="100%" jquery="Yes" scroll="no" html="No" label="User Role Authorization">

<cfparam name="URL.Search" default="">
<cfparam name="client.box" default="">

<cfset back         = "0">
<cfset Page         = "0">
<cfset add          = "0">
<cfset save         = "0"> 
<cfset menu         = "1"> 

<cfoutput>

<script language="JavaScript">

w = #CLIENT.width# - 80;
h = #CLIENT.height# - 120;

function showglobalrole(role)	{		
	ptoken.open("#SESSION.root#/System/Access/Global/OrganizationRolesView.cfm?Class=" + role, "role"+role) 	
	}
	
function showsystemrole(role)	{	
	ptoken.open("#SESSION.root#/System/Access/Global/OrganizationRolesView.cfm?Class=" + role, "role"+role) 	
	}	

function showtreerole(role) {	
	mis = document.getElementById("mission")
	ptoken.open("#SESSION.root#/System/Organization/Access/OrganizationRolesView.cfm?Mission="+document.getElementById('mission').value+"&Class=" + role, "role"+role) 			
	}
	
function show(par) {
	
	se1 = document.getElementById(par+"Exp")
	se2 = document.getElementById(par+"Min")
	se = document.getElementsByName("g"+par)
	cnt = 0

	if (se2.className == "regular navigation_row") {
	 	 
		se1.className = "regular"
		se2.className = "hide"	 
		while (se[cnt])  { se[cnt].className = "hide"; cnt++ }		 		 
		 
	} else  {	 

	    se1.className = "hide"
		se2.className = "regular navigation_row"
		while (se[cnt]) { se[cnt].className = "regular line navigation_row"; cnt++ }
		 
	}	 
	
	}	
	
function showtext(r) {
	se = document.getElementById(r)	
	if (se.className == "regular")
		{ se.className = "hide" 
	  } else { 
	     se.className = "regular" }
	  }
		
function refresh() {
	document.getElementById("initme").className = "hide"
	url = "OrganizationAuthorizationInit.cfm"
	ptoken.navigate(url,'init')	
}

function reloadform(mis) {
	url = "OrganizationRolesDetail.cfm?mission="+mis
	ptoken.navigate(url,'treedet')	
	}
	
</script>
</cfoutput>

<table width="99%" height="100%" align="center">

<tr><td><cfinclude template="../../Access/HeaderMaintain.cfm"></td></tr>

<!---
<tr><td style="height:20px;">
   
    <table cellspacing="0" cellpadding="0">
	
		<tr class="line">		
		<td bgcolor="white" style="font-size:25px;padding-left:25px;padding-right:25px;border:0px solid gray;margin-bottom:0px;" height="25">
            <!---<cfoutput><img src="#SESSION.root#/Images/Logos/System/Access.png" style="height:48px;float:left;">--->
			Grant User and Usergroup <strong>Access</strong>
		
		</td>		
		</tr>
		
	</table>
	
	</td>
</tr>
--->

<tr><td style="height:100%">
	
	  <cfinclude template="OrganizationAuthorizationTab.cfm">	
			
	<cfoutput>		
		<script language="JavaScript">
		try { document.getElementById("#client.box#Exp").click() } catch(e) {}
		</script>
	</cfoutput>			

</td></tr>

</table>
