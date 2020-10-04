	
<cfquery name="get" 
	datasource="AppsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT   *
	FROM     OrganizationObjectActionMail
	WHERE    ThreadId = '#url.Threadid#'	
	AND      SerialNo = '#url.serialNo#'									
</cfquery>

<cfoutput>
	
	<table width="95%" align="center">
	<tr class="labelmedium line">
	    <td style="width:200px;font:17px"><cf_tl id="Sent by"></td>
		<td style="font:17px">#get.OfficerFirstName# #get.OfficerLastName# #dateformat(get.created,client.dateformatshow)# #timeformat(get.created,"HH:MM")#</td>
	</tr>
	<tr class="labelmedium line">
	    <td style="font:17px"><cf_tl id="Addressee"></td>
		<td style="font:17px">#get.MailTo# <cfif get.Priority eq "1">[<cf_tl id="High">]</cfif></td>
	</tr>
	<tr class="labelmedium line">
	    <td style="font:17px"><cf_tl id="Subject"></td>
		<td style="font:17px">#get.MailSubject#</td>
	</tr>
	<tr class="labelmedium line"><td colspan="2" style="padding:15px;background-color:f1f1f1">
	#get.MailBody#
	</td></tr>
	<tr class="labelmedium line">
	    <td><cf_tl id="Status"></td>
		<td><cfif get.ActionStatus eq "0">Delivered</cfif></td>
	</tr>
	<tr class="labelmedium line">
	    <td><cf_tl id="Mail content authenticationId"></td>
		<td>#get.ThreadId#</td>
	</tr>
	</table>

</cfoutput>
