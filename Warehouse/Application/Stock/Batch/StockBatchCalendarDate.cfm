	
<!--- shows the information for the date as to how many are pending for that date --->
	
<cftry>
	
	<cfquery name="get"
		datasource="AppsQuery" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT    BatchDescription, count(*) as Counted
		FROM      StockBatch_#SESSION.acc#
		WHERE     TransactionDate = '#dateformat(url.calendardate,client.dateSQL)#'	
		AND       Detail = '0'
		GROUP BY BatchDescription
	</cfquery>
	
	<cfif url.Status eq "0">
		<cfset cl = "yellow">
	<cfelseif url.Status eq "9">	
	    <cfset cl = "red">
	<cfelse>
	    <cfset cl = "lime">	
	</cfif>	
	
	<cfif get.recordcount gte "1">
	
	<table width="98%" align="center">
		
			<cfoutput query="get">
				<tr class="labelmedium" style="height:20px">
				<td style="height:10px;padding-left:2px">#BatchDescription#:</td>			
				<td align="right" style="height:10px;padding-left:2px;padding-right:4px;">#Counted#</td>
				</tr>			
			</cfoutput>
	
	</table>	
	
	<cfelse>
	
		<cf_compression>
	
	</cfif>
	
	<cfcatch>
	
	<table><tr><td><font color="FF0000">problem</font></td></tr></table>
	
	</cfcatch>
	
</cftry>
