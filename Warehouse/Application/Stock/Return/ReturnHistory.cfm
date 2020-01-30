
<!--- return History --->

<cfquery name="Return" 
		datasource="AppsMaterials" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT  *
		FROM    ItemTransaction
		WHERE   Mission = '#url.mission#'
		AND     ReceiptId = '#ReceiptId#' and transactionType = '3'
</cfquery>

<table width="100%" cellspacing="0" cellpadding="0">
	
	<cfoutput query="Return">
		<tr bgcolor="ffffcf" class="labelit">
		  <td style="padding-left:4px">#dateFormat(TransactionDate,client.dateformatshow)#</td>
		  <td>#Warehouse#</td>
		  <td>#Location#</td>
		  <td>#OfficerLastName#</td>
		  <td align="right" style="padding-right:3px">#TransactionQuantity*-1#</td>	  
		  <td style="padding-top:2px" align="center">
		  
		  <cf_img icon="delete" 
		      onclick="_cf_loadingtexthtml='';ColdFusion.navigate('#session.root#/Warehouse/Application/Stock/Return/ReturnCancel.cfm?id=#url.transactionid#&returnid=#transactionid#','history_#url.transactionid#')">
			  
		  </td>
	    </tr>
	</cfoutput>

</table>
