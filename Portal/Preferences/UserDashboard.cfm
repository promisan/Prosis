
<cfquery name="Get" 
datasource="AppsSystem" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
SELECT *
FROM UserNames 
WHERE Account = '#SESSION.acc#'
</cfquery>

<cfform action="UserEditSubmit.cfm?id=dashboard"
        method="POST"
        id="formsetting">
 	
<table width="97%" cellspacing="0" cellpadding="0" align="center" class="formpadding">

  <tr><td height="4"></td></tr>
  
  	<tr><td colspan="2"><font size="2"><b>Dashboard</b></font></td></tr>
	<tr><td height="10"></td></tr>
	
	<tr>
    <TD>Launch Dashboard: &nbsp;</TD>
    <TD>
		
		<cfoutput query="get">	
		<input type="radio" name="Pref_LoadDashboard" value="1" <cfif #Pref_LoadDashboard# eq "1">checked</cfif>>&nbsp;After logon
		<input type="radio" name="Pref_LoadDashboard" value="0" <cfif #Pref_LoadDashboard# eq "0">checked</cfif>>&nbsp;Show as option
		</cfoutput> 
	</TD>
	</TR>
	
	<cfoutput>
	<cfif Find(Get.Pref_DashBoard,"1:1/1:3:1/1:1:1") eq 0>
		<cfset DashboardPref = "1:1">
	<cfelse>
		<cfset DashboardPref = "#Get.Pref_DashBoard#">
	</cfif>	
	</cfoutput>		
			
	<!--- Field: Ref_SMS--->
    <TR>
    <TD>Dashboard Frames: &nbsp;</TD>
    <TD>
		<table width="100%" border="0" cellspacing="0" cellpadding="0">
		<tr>
		<td align="left"><input type="radio" name="Pref_Dashboard" <cfif DashboardPref eq "1:1">checked</cfif> value="1:1">&nbsp;</td>
    	<td>
		<table border="1" bgcolor="f4f4f4" cellspacing="0" cellpadding="0" bordercolor="silver" class="formpadding">
		<tr><td height="23" width="75"></td></tr>
		<tr><td height="23" width="75"></td></tr>
		</table>
		</td>
		<td align="left"><input type="radio" name="Pref_Dashboard" <cfif DashboardPref eq "1:3:1">checked</cfif> value="1:3:1">&nbsp;</td>
    	<td>
		<table border="1" bgcolor="f4f4f4" cellspacing="0" cellpadding="0" bordercolor="silver" class="formpadding">
		<tr><td height="15" colspan="3"></td></tr>
		<tr><td height="15" width="25"></td><td width="25"></td><td width="25"></td></tr>
		<tr><td height="15" colspan="3"></td></tr>
		</table>
		</td>
		<td align="left"><input type="radio" name="Pref_Dashboard" <cfif DashboardPref eq "1:1:1">checked</cfif> value="1:1:1">&nbsp;</td>
    	<td>
		<table border="1" bgcolor="f4f4f4" cellspacing="0" cellpadding="0" bordercolor="silver" class="formpadding">
		<tr><td height="15" colspan="3"></td></tr>
		<tr><td height="15" width="75" colspan="3"></td></tr>
		<tr><td height="15" colspan="3"></td></tr>
		</table>
		</td>
		</tr>
		</table>
		
	</TD>
	</TR>
	
	<tr><td height="5"></td></tr>
	<tr><td height="1" colspan="2" bgcolor="C0C0C0"></td></tr>
	<tr><td height="5"></td></tr>
	
	<tr><td height="1" colspan="2" align="right">
		
	<input type="submit" class="button10g" name="Save" value="OK">
	
	</td></tr>
	
</table>	

</cfform>