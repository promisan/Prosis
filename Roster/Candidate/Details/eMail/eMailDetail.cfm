
<cfquery name="Detail" 
		datasource="appsSelection" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#"> 
		SELECT * 
		FROM   ApplicantMail
		WHERE  MailId = '#url.drillid#'		
</cfquery>		

<cfoutput query="detail">

<table width="100%" cellspacing="0" cellpadding="0" class="formpadding">
<tr><td style="padding:5px">
	<table width="96%" style="border: 1px dotted Silver;" cellspacing="0" cellpadding="0" align="center" class="formpadding">
	<tr><td width="80" class="labelit">From:</td><td class="labelmedium">#Detail.MailAddressFrom#</td></tr>
	<tr><td height="1" colspan="2" class="linedotted"></td></tr>
	<tr>
		<td colspan="2" class="labelit" style="padding:5px">#Detail.Mailbody#</td>
	</tr>
	</table>
</td></tr>
</table>

</cfoutput>

