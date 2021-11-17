
<!--- show profile and loss per period --->

<!--- loop through the period and for each period show the cost and income and profit/lost --->

<!---  url  = "javascript:listener('$ITEMLABEL$')" --->

<cfquery name="getData"
	datasource="AppsLedger" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT	P.TransactionPeriod,
				(
					SELECT	ISNULL(SUM(Debit-Credit)/1000,0) as Total
					FROM	UserQuery.dbo.#SESSION.acc#PL#FileNo#
					WHERE	TransactionPeriod = P.TransactionPeriod
					AND		Panel = 'Debit'
				) as Debit,
				(
					SELECT	ISNULL(SUM(Credit-Debit)/1000,0) as Total
					FROM	UserQuery.dbo.#SESSION.acc#PL#FileNo#
					WHERE	TransactionPeriod = P.TransactionPeriod
					AND		Panel = 'Credit'
				) as Credit
		FROM
			(
				SELECT	DISTINCT TransactionPeriod
				FROM	TransactionHeader
				WHERE	Mission       = '#url.mission#' 
				AND		AccountPeriod = '#url.period#'	
				AND		TransactionPeriod IN (#preservesinglequotes(transactionperiod)#) 
			) P
		ORDER BY  P.TransactionPeriod
</cfquery>

<table width="96%" align="center">

<tr><td id="alertme" colspan="2"></td></tr>

<tr><td height="20"></td></tr>
<tr><td height="30" class="labellarge" style="font-size:29px" align="center"><b><cf_tl id="Profit and Loss pattern"> (000s)</td></tr>
<tr><td style="height:40px;padding-left:30px">

	<cfoutput>
		<table class="formspacing">

		  <tr>
			<cf_MobileGraphPalette 
				color="green" 
				transparency="0.9">
			<td style="background-color:#colors[1]#; height:20;width:20;border;1px solid gray"></td><td class="labellarge" style="padding-left:5px;padding-right:20px"><cf_tl id="Profit"></td>
			<cf_MobileGraphPalette 
				color="red" 
				transparency="0.6">
			<td style="background-color:#colors[1]#; height:20;width:20;border;1px solid gray"></td><td class="labellarge" style="padding-left:5px;padding-right:20px"><cf_tl id="Loss"></td>
		  </tr>
	  
		</table>
	</cfoutput>

</td></tr>

<tr><td style="padding-top:25px;">

	<cfset vSeriesArray = ArrayNew(1)>

	<cfset vSeries = StructNew()>
	<cfset vSeries.name = "Income">
	<cfset vSeries.query = "#getData#">
	<cfset vSeries.label = "TransactionPeriod">
	<cfset vSeries.value = "Credit">
	<cfset vSeries.color = "green">
	<cfset vSeries.transparency = "0.9">
	<cfset vSeriesArray[1] = vSeries>

	<cfset vSeries = StructNew()>
	<cfset vSeries.name = "Costs">
	<cfset vSeries.query = "#getData#">
	<cfset vSeries.label = "TransactionPeriod">
	<cfset vSeries.value = "Debit">
	<cfset vSeries.color = "red">
	<cfset vSeries.transparency = "0.6">
	<cfset vSeriesArray[2] = vSeries>

	<cfquery name="maxData" dbtype="query">
		SELECT  MAX(Debit) as Debit, MAX(Credit) as Credit
		FROM    getData
	</cfquery>

	<cfset vMaxScale = 10>
	<cfif maxData.recordCount eq 1>
		<cfset vMaxScale = maxData.Debit * 1.1>
		<cfif maxData.Credit gt maxData.Debit>
			<cfset vMaxScale = maxData.Credit * 1.1>
		</cfif>
	</cfif>

	<cfquery name="minData" dbtype="query">
		SELECT  MIN(Debit) as Debit, MIN(Credit) as Credit
		FROM    getData
	</cfquery>

	<cfset vMinScale = 0>
	<cfif minData.recordCount eq 1>
		<cfset vMinScale = minData.Debit * 1.1>
		<cfif minData.Credit gt minData.Debit>
			<cfset vMinScale = minData.Credit * 1.1>
		</cfif>
	</cfif>
	
	<cf_mobileGraph
		id           = "plGraph"
		type         = "area"
		height       = "500px"
		series       = "#vSeriesArray#"
		minScale     = "#vMinScale#"
		maxScale     = "#vMaxScale#"
		responsive   = "yes"
		scaleLabel   = "<%= numberAddCommas(roundNumber(value, 2)) %>"
		tooltipLabel = "<%if (label){%><%=label%>: <%}%> <%= numberAddCommas(roundNumber(value, 2)) %>"
		multitooltiplabel = "<%= datasetLabel %>: <%= numberAddCommas(roundNumber(value, 2)) %>"
		onclick      = "function(e) { console.log(e[0].label + ' - ' + e[0].value); }">
	</cf_mobileGraph>	
	
	
</td></tr>
</table>	

<cfset ajaxOnLoad("function() { #doChart_plGraph# }")>
