
<cfparam name="url.action" default="">

<cfif url.action eq "delete">
	
	<cfquery name="delete"
	    datasource="AppsLedger" 
	    username="#SESSION.login#" 
	    password="#SESSION.dbpw#">
	    DELETE FROM  CurrencyExchange
	 	WHERE    Currency = '#URL.id#'
		AND      EffectiveDate = '#url.effective#'    
	</cfquery>
	
	<cfquery name="Last"
	    datasource="AppsLedger" 
	    username="#SESSION.login#" 
	    password="#SESSION.dbpw#">		   		   
		   SELECT  TOP 1 CE.*
		   FROM    Currency C INNER JOIN CurrencyExchange CE ON C.Currency = CE.Currency
		   WHERE   C.Currency = '#url.id#'
		   ORDER BY EffectiveDate DESC		    
    </cfquery>		
		
	<cfif last.recordcount eq "1">
	
		<cfquery name="Set" 
			datasource="AppsLedger" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			   UPDATE Currency
			   SET    ExchangeRate   = '#last.ExchangeRate#'
			   WHERE  Currency = '#url.id#' 
		</cfquery>
		
	</cfif>

</cfif>


	
<cfquery name="History"
    datasource="AppsLedger" 
    username="#SESSION.login#" 
    password="#SESSION.dbpw#">
    SELECT   TOP 20 *
	FROM     CurrencyExchange
 	WHERE    Currency = '#URL.id#'
    ORDER BY EffectiveDate DESC
</cfquery>

<table width="100%" cellspacing="0" cellpadding="0" class="navigation_table">
					
<cfoutput query="History">   
	<tr class="line labelit navigation_row" bgcolor="ffffef" style="height:16px">	
	<!--- <td width="80" align="left" style="padding-left:3px;padding-right:5px">(#Dateformat(Created, "#CLIENT.DateFormatShow#")#)</td> --->
	<td width="80" style="padding-left:4px">#Dateformat(History.EffectiveDate, "#CLIENT.DateFormatShow#")#</td>
	<td style="padding-top:4px;width:20px">	
	<cf_img icon="delete" onclick="_cf_loadingtexthtml='';ptoken.navigate('RecordListingDetail.cfm?action=delete&id=#url.id#&effective=#dateformat(EffectiveDate,client.dateSQL)#','detail#url.id#')"></td>	
	<td width="100" style="padding-right:3px" align="right">#NumberFormat(History.ExchangeRate,'____,___.____')#</td>	
	</tr>	
</cfoutput>

</table>

<cfset ajaxonload("doHighlight")>
