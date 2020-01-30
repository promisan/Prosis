
<cfparam name="url.selected" default="">
<cfparam name="url.topicvaluecode" default="">

<cfquery name="Master" 
	datasource="AppsPurchase" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT    *
		FROM      ItemMaster
		WHERE     Code = '#url.itemmaster#'
</cfquery>

<cfif Master.BudgetTopic eq "DSA">
	
	<cfquery name="Amount"
	datasource="AppsTravelClaim" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT   TOP 1 AmountBase as ListAmount
		FROM     Ref_ClaimRates
		WHERE    ServiceLocation = '#url.topicvaluecode#' 
		AND      DateEffective < GETDATE() 
		AND      (DateExpiration IS NULL OR DateExpiration > GETDATE())
		ORDER BY DateEffective DESC, RatePointer
	</cfquery>
	
	<cfset listprice = amount.listamount>

<cfelse>

	<!--- we check if there is a generic amount defined --->
	
	<cfquery name="Amount" 
		datasource="AppsPurchase" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT    *
			FROM      ItemMasterList
			WHERE     ItemMaster     = '#url.itemmaster#'
			AND       topicvaluecode = '#url.topicvaluecode#'
	</cfquery>
	
	<cfset listprice = amount.listamount>
	
	<!--- then we check if there is a specific amount defined for the mission/location --->
	
	<cfquery name="List" 
		datasource="AppsPurchase" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		  SELECT ISNULL(SUM(I.CostAmount),0) as Amount
		  FROM   ItemMasterStandardCost I, (
					SELECT    CostElement, MAX(DateEffective) as DateEffective
					FROM      ItemMasterStandardCost
					WHERE     ItemMaster     = '#url.itemmaster#'
					AND       topicvaluecode = '#url.topicvaluecode#'
					AND       Mission    = '#url.mission#'
					AND       Location   = '#url.location#'
					AND       DateEffective <= getDate()
					AND       CostBudgetMode = '2' <!--- amounts --->
					GROUP BY  CostElement
					) as S
			WHERE I.CostElement      = S.CostElement
			AND   I.DateEffective    = S.DateEffective
			AND   I.Mission          = '#url.mission#'
			AND   I.Location         = '#url.location#'	
			AND   I.ItemMaster       = '#url.itemmaster#'
			AND   I.Topicvaluecode   = '#url.topicvaluecode#'
			AND   I.CostBudgetMode   = '2'						
	</cfquery>
	
	<!--- pending a provision for the other components of the rate --->
				
	<cfif List.Amount gt "0">
	
		<cfset listprice = list.amount>	
	
	</cfif>	

</cfif>

<cfif listprice neq "">
				
	<cfoutput>
		<script language="JavaScript">	 
		
			try {  	
			
			price = document.getElementById('requestprice_#url.line#');
			priceold = document.getElementById('requestpriceold_#url.line#');
			if ('#url.selected#'!='#url.topicvaluecode#' && '#trim(url.selected)#'!='undefined') {				
				price.value = '#numberformat(listprice,'.__')#';				
			} else {
				if (priceold) {
					if (priceold.value=='0.00')
						price.value = '#numberformat(listprice,'.__')#';
					else
						price.value = priceold.value;
				}				
			}						

			<cfif isNumeric(url.quantity)>
				se = document.getElementById("total_display_#url.line#");
				if (se) {
					fprice = Number(price.value.replace(/[^0-9\.]+/g,""));
					total = fprice*'#url.quantity#';
					se.innerHTML = total.formatMoney(2,',','.');
				}
			</cfif>		
			
			} catch(e) {}	
			
		</script>
	</cfoutput>
		
<cfelse>
	
	<cfoutput>
		<script language="JavaScript">
		
		    try {
				   	
			price = document.getElementById('requestprice_#url.line#');
			topic = document.getElementById('topicvaluecode_#url.line#');						
			if (topic) {
				if (topic.value == '#trim(url.selected)#') {
					priceold = document.getElementById('requestpriceold_#url.line#');
					price.value= priceold.value;					
				}
			}
			<cfif isNumeric(url.quantity)>
				se = document.getElementById("total_display_#url.line#");
				if (se) {
					total = price.value*'#url.quantity#';
					se.innerHTML = total.formatMoney(2,',','.');
				}
			</cfif>		
			} catch(e) {}			
			
			
		</script>
	</cfoutput>	
		
</cfif>
