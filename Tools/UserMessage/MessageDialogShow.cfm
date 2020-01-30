
<cf_screentop label="Problem" user="no" line="no" layout="webapp" close="ColdFusion.Window.destroy('alertbox',true)" banner="red" height="100%">

<cfoutput>
<table width="90%" align="center" class="formpadding">
<tr><td height="40"></td></tr>
<tr><td height="95%" valign="top" class="labellarge">
<cfif IsDefined("client.message")>#client.message#</cfif>
</td></tr>

</table>

</cfoutput>

<cf_screenbottom layout="webapp">

