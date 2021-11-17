
<!--- set month --->

 <cfquery name="Month"
	datasource="AppsLedger" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT   DISTINCT MONTH(T.TransactionDate) AS Month
		FROM     TransactionHeader T
		WHERE    T.Journal       = '#URL.Journal#' 
		AND      T.AccountPeriod = '#URL.Period#'
		ORDER BY MONTH(T.TransactionDate)
</cfquery>

<cfparam name="url.month" default="">

<cfif Month.recordcount gte "1">
			
	<select name="monthselect" id="monthselect" class="regularxl" 
	style="background-color:f1f1f1;font-size:16px;height:35px;border:0px" onchange="reloadForm(page.value,document.getElementById('idstatus').value)">
	<option value=""><cf_tl id="All months"></option>
	<cfoutput query="Month">
		<option value="#Month#" <cfif url.month eq month>selected</cfif>>#MonthAsString(month)#</option>
	</cfoutput>
	</select>

<cfelse>

	<input type="hidden" name="monthselect" id="monthselect" value="">

</cfif>