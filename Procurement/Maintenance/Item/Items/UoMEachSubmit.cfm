
<cfquery name="update" 
	datasource="AppsPurchase" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		UPDATE 	ItemMaster
		SET 	IsUoMEach = #url.value#
		WHERE 	Code = '#url.item#'
</cfquery>

<table>
	<tr>
		<td style="color:#4F86EC; font-weight:bold;"><cf_tl id="Saved"></td>
	</tr>
</table>