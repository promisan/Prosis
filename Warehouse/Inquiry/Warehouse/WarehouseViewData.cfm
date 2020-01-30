
<table width="100%" height="100%" border="0" cellspacing="0" cellpadding="0">

<tr><td valign="top">

	<!---- Some table preparations --->
	
	<cf_droptable dbname="AppsQuery" tblname="#SESSION.acc#_Monthly"> 
	<cfquery name="Section" 
	datasource="AppsQuery" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">  
		SELECT ItemNo, Year(TransactionDate) as Y, Month(TransactionDate) as M, SUM(-1*TransactionQuantity) as Monthly
		INTO #SESSION.acc#_Monthly
		FROM Materials.dbo.ItemTransaction			
		WHERE Mission = '#URL.Mission#'
		AND TransactionType = '2'
		AND ItemNo IN
		(
			SELECT ItemNo
			FROM Materials.dbo.Item
			WHERE Category = 'FUEL'
		)
		GROUP BY ItemNo,Month(TransactionDate), Year(TransactionDate)
	</cfquery>

	<cf_informationContent 
	    systemfunctionid="#url.idmenu#"
	    mission="#url.mission#">
   
    </td>
</tr>

</table>
