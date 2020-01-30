
<!--- set total billed after you submit a billing --->
				 
<cfquery name="Billed" 
	datasource="AppsLedger" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT    Currency,ISNULL(SUM(Amount), 0) AS Total
	FROM      TransactionHeader
	WHERE     ReferenceId = '#url.workorderid#'
	GROUP BY  Currency	
</cfquery>  

<cfoutput>  

 <table cellspacing="0" cellpadding="0">
	 <cfloop query="billed">
	 <tr><td  class="labelmedium">#Billed.currency# #numberformat(Billed.Total,",__.__")#</td></tr>				 
	 </cfloop>
 </table>

</cfoutput> 