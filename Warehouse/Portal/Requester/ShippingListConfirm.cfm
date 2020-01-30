
<cfquery name="Requisition" 
datasource="AppsMaterials" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT R.* 
	FROM ItemTransaction I, Request R
	WHERE I.TransactionId       = '#URL.ID#'
	AND I.RequestId = R.RequestId
	
</cfquery>

<cfquery name="Confirm" 
datasource="AppsMaterials" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	UPDATE ItemTransactionShipping
	SET    ActionStatus          = '#url.status#', 
	       ConfirmationDate      = getDate(), 
		   ConfirmationUserId    = '#SESSION.acc#',
		   ConfirmationLastName  = '#SESSION.last#',
		   ConfirmationFirstName = '#SESSION.first#'
	WHERE  TransactionId       = '#URL.ID#'
</cfquery>

<cfoutput>

<cfif url.status eq "2">

	<table cellspacing="0" cellpadding="0">
	<tr><td>
	
		 <img src="#SESSION.root#/images/print_small5.gif" 
				    align="absmiddle" 
					style="cursor: pointer;"
					alt="Print Requisition" 
					border="0" 
					onclick="mail3('print','#Requisition.Reference#')">	
		</td>
		<td>&nbsp;</td>
		<td>
	
		<a href="javascript:ColdFusion.navigate('Requester/ShippingListConfirm.cfm?status=0&id=#url.id#','box#url.Id#')">
		 <font color="6688aa">
				 <cf_tl id="Reset"> #Dateformat(now(),CLIENT.DateFormatShow)#
		 </font>
		</a>
	
	</td> 
	
	</tr></table>

<cfelse>	

	<a href="javascript:ColdFusion.navigate('ShippingListConfirm.cfm?status=2&id=#url.id#','box#url.id#')">
	 <font color="6688aa">
		 <cf_tl id="Confirm">
	 </font>
	 </a>

</cfif>

</cfoutput>