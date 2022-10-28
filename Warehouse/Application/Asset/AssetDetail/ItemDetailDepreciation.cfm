<cfparam name="client.assetid" default="">

<cfif url.assetId eq "">
    <cfset url.assetid = CLIENT.assetid>
<cfelse>
	<cfset CLIENT.assetid = url.assetid>
</cfif>

<cfif url.assetid neq "">

<cfset url.assetid = replace(url.assetid,"'","","all")>

<cfquery name="SearchResult" 
  datasource="AppsLedger" 
  username="#SESSION.login#" 
  password="#SESSION.dbpw#">
  SELECT       R.Description AS AccountName, 
	           L.GLAccount, 
			   L.OrgUnit, 
			   L.AccountPeriod, 
			   H.JournalTransactionNo,
			   H.TransactionDate, 
			   H.Mission,
			   L.TransactionType, 
			   L.Reference, 
			   L.AccountPeriod,
			   L.OfficerUserid,
			   L.AmountBaseDebit, 
	           L.AmountBaseCredit
  FROM       TransactionHeader H INNER JOIN
	           TransactionLine L ON H.Journal = L.Journal AND H.JournalSerialNo = L.JournalSerialNo INNER JOIN
	           Ref_Account R ON L.GLAccount = R.GLAccount
  WHERE     L.ReferenceId = '#URL.Assetid#' 
  ORDER BY H.TransactionDate DESC 
</cfquery>

<!--- determine Account --->

<cfquery name="Total" 
  datasource="AppsLedger" 
  username="#SESSION.login#" 
  password="#SESSION.dbpw#">
  SELECT      Sum(L.AmountBaseDebit-L.AmountBaseCredit) as Value
  FROM       TransactionHeader H INNER JOIN
	           TransactionLine L ON H.Journal = L.Journal AND H.JournalSerialNo = L.JournalSerialNo INNER JOIN
	           Ref_Account R ON L.GLAccount = R.GLAccount
  WHERE     L.ReferenceId = '#URL.Assetid#'
  AND      L.GLAccount IN (SELECT   GL.GLAccount
						 FROM     Materials.dbo.AssetItem A INNER JOIN
				                  Materials.dbo.Item I ON A.ItemNo = I.ItemNo INNER JOIN
                				  Materials.dbo.Ref_CategoryGledger GL ON I.Category = GL.Category
						 WHERE    (A.AssetId = '#URL.Assetid#' )
						   AND    (GL.Area = 'Stock')  
						)
</cfquery>

<cf_divscroll>

	<table width="98%" class="formpadding navigation_table">
	
	<tr><td class="labellarge" colspan="8" style="height:30px"><cf_tl id="Depreciation History"></td></tr>
	
	<tr class="labelmedium line fixlengthlist">
	    <td style="padding-left:10px"><cf_tl id="Entity"></td>
		<td><cf_tl id="Date"></td>
		<td><cf_tl id="Period"></td>	
		<td><cf_tl id="TransactionNo"></td>
		<td><cf_tl id="Reference"></td>
		<td><cf_tl id="Officer"></td>
		<td><cf_tl id="Type"></td>
		<td><cf_tl id="Account"></td>
		<td align="right"><cf_tl id="Amount Debit"></td>
		<td align="right"><cf_tl id="Amount Credit"></td>
	</tr>
	
	<cfoutput query="Searchresult">
		<tr class="line navigation_row labelmedium fixlengthlist">
		<td style="padding-left:10px">#Mission#</td>
		<td>#DateFormat(TransactionDate, CLIENT.DateFormatShow)#</td>
		<td>#AccountPeriod#</td>	
		<td>#JournalTransactionNo#</td>
		<td>#Reference#</td>
		<td>#Officeruserid#</td>
		<td>#TransactionType#</td>
		<td>#GLAccount# #AccountName#</td>
		<td align="right">#numberFormat(AmountBaseDebit,",.__")#</td>
		<td align="right">#numberFormat(AmountBaseCredit,",.__")#</td>
		</tr>
	</cfoutput>
	
	<cfoutput>
	   
		<tr>
			<td height="20" align="right" style="padding-right:10px" class="labelmedium" colspan="8"><font color="0080FF"><cf_tl id="Current Value">:</td>
			<cfif Total.Value gt "0">
	    	<td align="right">#numberFormat(Total.Value,",.__")#</td>
			<td align="right">#numberFormat(0,",.__")#</td>
			<cfelse>
			<td align="right">#numberFormat(0,",.__")#</td>
			<td align="right">#numberFormat(Total.Value,",.__")#</td>
			</cfif>
		</tr>
		
	</cfoutput>
	</table>
	
</cf_divscroll>

</cfif>

<cfset ajaxonload("doHighlight")>