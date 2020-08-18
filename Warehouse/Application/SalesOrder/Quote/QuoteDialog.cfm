
<cfquery name="Request"
		datasource="AppsMaterials"
		username="#SESSION.login#"
		password="#SESSION.dbpw#">
		SELECT *
		FROM   CustomerRequest
		WHERE  Requestno = '#URL.Requestno#'
	</cfquery>
	
<cfoutput>
	
<table style="width:300px">

	<tr class="labelmedium">
	      <td><cf_tl id="Source">:</td>
	      <td style="font-size:17px">#Request.Source#</td>
	</tr>
	<tr class="labelmedium">
	      <td><cf_tl id="Recorded">:</td>
	      <td style="font-size:17px">#Request.OfficerLastName#</td>
	</tr>
	<tr class="labelmedium">
		      <td><cf_tl id="Time">:</td>
		      <td style="font-size:17px">#dateformat(Request.Created,client.dateformatshow)# #timeformat(Request.Created,"HH:MM")#</td>
		</tr>

	<tr class="labelmedium">
			<td><cf_tl id="Memo">:</td>
	      <td style="font-size:17px;padding-top:4px">#Request.Remarks#</td>
	</tr>
	
</table>

</cfoutput>