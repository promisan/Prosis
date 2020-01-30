
<!--- deny access to portal --->

<table width="100%" align="center" height="100%" bgcolor="white">
<tr><td align="center" height="120">
<font face="Verdana" size="3" color="black">
<cfoutput>
	You do not have access to this #SESSION.welcome# Portal function. <br><br> Please contact your administrator.
    <cfset SESSION.authent = "0">
	<cfset vLogOut = StructClear(SESSION)>	
</cfoutput>	
</font>
</td></tr>
<tr><td height="50%"></td></tr>
</table>