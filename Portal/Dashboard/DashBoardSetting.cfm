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

<form name="formsetting" id="formsetting">

<table width="100%" height="100%" bgcolor="white" border="0" cellspacing="0" cellpadding="0" align="center" class="formpadding">
		
	<tr><td height="6"></td></tr>	
    <TR>
    <TD height="97%" class="labelit" valign="top">&nbsp;&nbsp;Dashboard Frames: &nbsp;</TD>
    <TD valign="top">
	
		<table width="100%" border="0" cellspacing="0" cellpadding="0">
		<tr>
		<td align="left"><input type="radio" name="Pref_Dashboard" <cfif Get.Pref_DashBoard eq "1:1">checked</cfif> value="1:1">&nbsp;</td>
    	<td>
		<table style="border:1px dotted silver" bgcolor="f4f4f4" cellspacing="0" cellpadding="0" class="formpadding">
		<tr><td style="border:1px dotted silver" height="23" width="75"></td></tr>
		<tr><td style="border:1px dotted silver" height="23" width="75"></td></tr>
		</table>
		</td>
		<td align="left"><input type="radio" name="Pref_Dashboard" <cfif Get.Pref_DashBoard eq "1:3:1">checked</cfif> value="1:3:1">&nbsp;</td>
    	<td>
		<table style="border:1px dotted silver" cellspacing="0" cellpadding="0" class="formpadding">
		<tr><td style="border:1px dotted silver" height="15" colspan="3"></td></tr>
		<tr>
		     <td style="border:1px dotted silver" height="15" width="25"></td>
			 <td style="border:1px dotted silver" width="25"></td>
			 <td width="25" style="border:1px dotted silver"></td>
		</tr>
		<tr><td height="15" style="border:1px dotted silver" colspan="3"></td></tr>
		</table>
		</td>
		<td align="left"><input type="radio" name="Pref_Dashboard" <cfif Get.Pref_DashBoard eq "1:1:1">checked</cfif> value="1:1:1">&nbsp;</td>
    	<td>
		<table style="border:1px dotted silver" bgcolor="f4f4f4" cellspacing="0" cellpadding="0" class="formpadding">
		<tr><td style="border:1px dotted silver" height="15" colspan="3"></td></tr>
		<tr><td style="border:1px dotted silver" height="15" width="75" colspan="3"></td></tr>
		<tr><td style="border:1px dotted silver" height="15" colspan="3"></td></tr>
		</table>
		</td>
		</tr>
		</table>
		
	</TD>
	</TR>
	
	<tr><td height="1" colspan="2" class="linedotted"></td></tr>
	
	<tr><td colspan="2" align="center" height="30">
	<input type="button" name="Cancel" onclick="javascript:ColdFusion.Window.hide('setting')" class="button10g" value="Close">
	<input type="button" name="Save"   onclick="ColdFusion.Window.hide('setting');ColdFusion.navigate('DashboardSettingSubmit.cfm','framescontent','','','POST','formsetting')" 
	   class="button10g" value="Save">
	</td></tr>

</table>

</form>	
	
