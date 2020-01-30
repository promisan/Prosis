<HTML><HEAD>
	<TITLE>User preferences</TITLE>
</HEAD><body bgcolor="#FFFFFF" leftmargin="0" topmargin="0" rightmargin="0" onLoad="window.focus()">
 <link rel="stylesheet" type="text/css" href="<cfoutput>#SESSION.root#/#client.style#</cfoutput>">

<cfquery name="Get" 
datasource="AppsSystem" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT *
	FROM   UserNames 
	WHERE  Account = '#SESSION.acc#'
</cfquery>

<cfparam name="URL.db" default="#Get.Pref_DashBoard#">

<cfoutput>

<script language="JavaScript">

function scr(frm,scroll) {  
    window.location = "UserEditDashboardScroll.cfm?frm="+frm+"&scroll="+scroll
	}

function item(id,frm) {  
    window.open("../Dashboard/DashboardSelect.cfm?reportid="+id+"&frm="+frm, "edit","width=700, height=700, status=yes, toolbar=no, scrollbars=yes, resizable=yes")
	}
	
	
function edit(id,tpe,path) {
  if (tpe == "Topic") {  
    window.open("#SESSION.root#/Portal/Topics/"+path+"/TopicEdit.cfm?acc=#SESSION.acc#&id="+id, "edit", "width=580, height=590, status=yes, toolbar=no, scrollbars=yes, resizable=yes")
	} else {  
	w = #CLIENT.width# - 16;
    h = #CLIENT.height# - 78;
    window.open("#SESSION.root#/tools/cfreport/SubmenuReportView.cfm?id="+id+"&context=subscription", "_blank", "left=0, top=0, width=" + w + ", height= " + h + ", menubar=no, toolbar=no, status=yes, scrollbars=yes, resizable=yes");
	}
	
}	
	
</script>

</cfoutput>
	
<table width="100%" border="0" cellspacing="0" cellpadding="0" align="center">

<tr><td>

<!--- Entry form --->

<cfoutput>

<table width="93%" height="80%" align="center" cellspacing="0" class="formpadding">
	
	<tr><td height="3"></td></tr>
	
	<tr><td colspan="2"><font size="2"><b>Dashboard</b></font></td></tr>
	<tr><td height="10"></td></tr>
			
	 <!--- Field: Ref_SMS--->
    <TR>
    <td align="center">
		<table width="100%" border="0" cellspacing="0" cellpadding="0" align="center">
		<tr>
		<td>
		<cfswitch expression="#URL.DB#">
		
			<cfcase value="1:1:1">
			
				<cfset w = "480">
				<cfset h = "170">
								
				<table border="1" align="center" bgcolor="f4f4f4" cellspacing="0" cellpadding="0" bordercolor="silver" class="formpadding">
				<tr><cfset col = "1">
				    <cfset frm="1">    <cfinclude template="UserEditDashboardItem.cfm">     				
				</tr>
				<tr><cfset col = "1">
					<cfset frm="3">    <cfinclude template="UserEditDashboardItem.cfm">
     			</tr>
				<tr><cfset col = "1">
				    <cfset frm="5">    <cfinclude template="UserEditDashboardItem.cfm">     				
				</tr>
				</table>
			</cfcase>
						
			<cfcase value="1:1">
			
				<cfset w = "240">
				<cfset h = "240">
				<table border="1" align="center" bgcolor="f4f4f4" cellspacing="0" cellpadding="0" bordercolor="silver" class="formpadding">
				<tr><cfset col = "1">
				    <cfset frm="1">    <cfinclude template="UserEditDashboardItem.cfm">     				
				</tr>
				<tr>
				    <cfset col = "3">
					<cfset frm="3">    <cfinclude template="UserEditDashboardItem.cfm">
				</tr>
				</table>
			</cfcase>
			
			<cfdefaultcase>
			
				<cfset w = "240">
				<cfset h = "170">
				
				<table border="1" align="center" bgcolor="f4f4f4" cellspacing="0" cellpadding="0" bordercolor="silver" class="formpadding">
				<tr><cfset col = "3">
				    <cfset frm="1">    <cfinclude template="UserEditDashboardItem.cfm">     				
				</tr>
				<tr><cfset col = "1">
					<cfset frm="2">    <cfinclude template="UserEditDashboardItem.cfm">
     				<cfset frm="3">    <cfinclude template="UserEditDashboardItem.cfm">
					<cfset frm="4">    <cfinclude template="UserEditDashboardItem.cfm">
				</tr>
				<tr><cfset col = "3">
				    <cfset frm="5">    <cfinclude template="UserEditDashboardItem.cfm">     				
				</tr>
				</table>
			</cfdefaultcase>
			
		</cfswitch>
		</td>
		</tr>
		</table>
		
	</td>
	</TR>
		
	<tr><td height="3"></td></tr>
		
	</cfoutput>

</table>

</td></tr>

</table>

<script>
	Prosis.busy('no');	
</script>
	

</BODY></HTML>