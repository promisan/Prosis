
<!--- log of line --->

<cfquery name="get"
	datasource="AppsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT   *
		FROM     ItemTransaction 
		WHERE    TransactionId = '#url.id#'								
	</cfquery>
	
<cfoutput>

<table width="97%" align="center">
<tr class="labelmedium2 line"><td style="font-size:20px" colspan="5"><cf_tl id="This line amended from"></td></tr>

<tr class="labelmedium line fixlengthlist">
	   <td><cf_tl id="Officer"></td>
	   <td><cf_tl id="Date"></td>
	   <td><cf_tl id="Item"></td>
	   <td align="right"><cf_tl id="Quantity"></td>
	   <td align="right"><cf_tl id="COGS"></td>
    </tr>

   <cfquery name="ThisLine"
	datasource="AppsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT   *
		FROM     ItemTransactionDeny 
		WHERE    ParentTransactionId = '#url.id#'								
	</cfquery>
	
	<tr class="labelmedium line fixlengthlist">
	   <td>#ThisLine.OfficerLastName#</td>
	   <td>#dateformat(ThisLine.Created,client.dateformatshow)# #timeformat(ThisLine.Created,"HH:MM")#</td>
	   <td>#ThisLine.ItemDescription#</td>
	   <td align="right">#ThisLine.TransactionQuantity*-1#</td>
	   <td align="right">#ThisLine.TransactionValue*-1#</td>
    </tr>

<!--- all changes or this order --->

	<cfquery name="All"
	datasource="AppsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT   *
		FROM     ItemTransactionDeny 
		WHERE    TransactionBatchNo = '#get.TransactionBatchNo#'	and TransactionId <> '#thisLine.Transactionid#'							
	</cfquery>
	
	<cfif all.recordcount gte "1">

		<tr><td style="height:40px"></td></tr>
		<tr class="labelmedium2 line"><td style="font-size:20px" colspan="5"><cf_tl id="All amendments"></td></tr>
		
		<cfloop query="All">
		
		<tr class="labelmedium line fixlengthlist">
		   <td>#OfficerLastName#</td>
		   <td>#dateformat(Created,client.dateformatshow)# #timeformat(Created,"HH:MM")#</td>
		   <td>#ItemDescription#</td>
		   <td align="right">#TransactionQuantity*-1#</td>
		   <td align="right">#TransactionValue*-1#</td>
	    </tr>
		
		</cfloop>
	
	</cfif>


</table>

</cfoutput>	
