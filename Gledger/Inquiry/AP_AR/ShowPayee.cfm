<cfparam name="CLIENT.payables" default="">

   <cfif url.mode eq "AP">   
	<cfset journalfilter = "'Payables'">
   <cfelse>
    <cfset journalfilter = "'Receivables'">
   </cfif>	
			
   <cfquery name="Payee"
	datasource="AppsQuery" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT   DISTINCT TOP 10 ReferenceName, 
		         Currency, 
				 SUM(Amount) as Amount, 
				 SUM(CASE WHEN Amount > 0 THEN AmountOutstanding ELSE AmountOutstanding*-1 END) as Outstanding
		FROM     Inquiry_#url.mode#_#session.acc# P
											 
				  <cfif client.payables eq "">
				   WHERE 1=1
				   <cfelse>
		         #PreserveSingleQuotes(Client.Payables)#	
				 </cfif>
				 
		GROUP BY ReferenceName, Currency
		ORDER BY SUM(CASE WHEN Amount > 0 THEN AmountOutstanding ELSE AmountOutstanding*-1 END) DESC
	</cfquery>	
	
    <!---	
	<cfoutput>#cfquery.executiontime#</cfoutput>
	--->
	
	<table width="97%" cellspacing="0" cellpadding="0" align="center" class="navigation_table">
		
	<cfif findNoCase("ReferenceName","#CLIENT.Payables#")> 

	<tr><td colspan="4" class="labelmedium"><cf_tl id="Summary"></td></tr>

	<cfelse>
	
	<tr><td colspan="4" height="20" class="labelmedium"><cf_tl id="Top 10"></td></tr>	
	
	</cfif>
	
	<cfif url.mode eq "AP">
		<cf_tl id="Payee" var="vLabel">		
	<cfelse>
		<cf_tl id="Debitor" var="vLabel">		
	</cfif>
	
	<tr class="labelmedium">
		<td style="border:1px solid silver;padding-left:4px"><cf_tl id="#vLabel#"></td>
		
		<td style="border:1px solid silver" align="center"><cf_tl id="Curr"></td>
		<td style="border:1px solid silver;padding-right:3px" align="right"><cf_tl id="Amount"></td>
		<td style="border:1px solid silver;padding-right:3px" align="right"><cf_tl id="Outstanding"></td>
	</tr>
	
	<cfoutput query="Payee">
	<tr class="navigation_row line labelmedium" onclick="javascript:Prosis.busy('yes');_cf_loadingtexthtml='';ptoken.navigate('InquiryListing.cfm?mode=#url.mode#&mission=#url.mission#&systemfunctionid=#url.systemfunctionid#&filter=customer&value=#referencename#','listbox')">
	    <td style="height:19px;padding-left:4px">#ReferenceName#</td>		
		<td style="min-width:40px;padding-right:3px" align="center">#Currency#</td>
		<td style="min-width:70px;padding-right:3px" align="right">#numberformat(amount,',__')#</td>
		<td style="min-width:70px;padding-right:3px" align="right">#numberformat(outstanding,',__')#</td>
	</tr>
	</cfoutput>
	
	</table>
	
	<cfset ajaxonload("doHighlight")>
	
	
<script>
	Prosis.busy('no')
</script>



