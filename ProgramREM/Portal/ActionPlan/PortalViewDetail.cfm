
<cfparam name="client.widthfull" default="#client.width#">

<cf_wait1 flush="yes">

<cf_LoginTop FunctionName = "#URL.ID#" Graphic="No">
	
	<table width="100%" align="center" height="94%" border="0" cellspacing="0" cellpadding="0">
	<tr><td><cfinclude template="PortalViewBanner.cfm"></td></tr>
	<tr><td height="8"></td></tr>
	<tr>
	<td valign="top">    
		<cfinclude template="../../Application/Program/ProgramView/ProgramViewGeneral.cfm">
	</td>
	</tr>
	</table>

<cf_LoginBottom FunctionName = "#URL.ID#">

<cf_waitEnd>

