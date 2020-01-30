
<cfquery name="getPAS" 
	datasource="AppsEPAS" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT *
		FROM   Contract
		WHERE  ActionStatus NOT IN ('8','9')
		AND    PersonNo = '#url.personNo#'
		AND    Period   = '#url.period#'
</cfquery>

<cfif getPas.recordcount gte "1">
	<table width="100%" class="formpadding">
	<tr class="line"><td colspan="5"></td></tr>
	<cfoutput query="getPAS">
	<tr class="line labelmedium">
	  <td style="padding-left:3px"><a href="javascript:pasdialog('#ContractId#')">#ContractNo#</a></td>
	  <td>#ContractClass#</td>
	  <td>#dateformat(DateEffective,client.dateformatshow)#-#dateformat(DateExpiration,client.dateformatshow)#</td>
	  <td>#FunctionDescription#</td>
	</tr>
	</cfoutput>
	</table>
</cfif>