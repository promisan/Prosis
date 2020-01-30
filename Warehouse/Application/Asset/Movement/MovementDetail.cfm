
<cfquery name="Items" 
datasource="appsMaterials" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT   L.AssetId
	FROM     AssetMovement M INNER JOIN
	         AssetItemLocation L ON M.MovementId = L.MovementId
	WHERE    M.MovementId = '#URL.MovementId#'
	UNION
	SELECT   L.AssetId
	FROM     AssetMovement M INNER JOIN
	         AssetItemOrganization L ON M.MovementId = L.MovementId
	WHERE M.MovementId = '#URL.MovementId#'
</cfquery>

<table width="93%" cellspacing="0" cellpadding="0" border="0">
		
			<tr class="linedotted labelmedium">
			<td width="14%"><cf_tl id="Description"></td>
			<td width="14%"><cf_tl id="Make"></td>
			<td width="14%"><cf_tl id="Model"></td>
			<td width="14%"><cf_tl id="SerialNo"></td>
			<td width="14%"><cf_tl id="Bar Code"></td>
			<td width="90" ><cf_tl id="Date Receipt"></td>
			<td width="14%" align="right"><cf_tl id="Value"></td>			
			</tr>
			
		<cfoutput query="items">

			<cfquery name="asset" 
			 datasource="appsMaterials" 
			 username="#SESSION.login#" 
			 password="#SESSION.dbpw#">
		     SELECT  *
			 FROM    AssetItem I 
			 WHERE Assetid = '#AssetId#'
			</cfquery> 
											
				<cfloop query="Asset">
					<tr style="height:16px" class="labelmedium">
					<td>#Description#</td>
					<td>#Make#</td>
					<td>#Model#</td>
					<td>#SerialNo#</td>
					<td>#AssetBarcode#</td>
					<td>#dateformat(ReceiptDate,CLIENT.DateFormatShow)#</td>
					<td align="right">#numberformat(AmountValue,",__.__")#</td>					
					</tr>			
				</cfloop>		
			
		</cfoutput>
		
		<tr><td height="4"></td></tr>
	
</table>