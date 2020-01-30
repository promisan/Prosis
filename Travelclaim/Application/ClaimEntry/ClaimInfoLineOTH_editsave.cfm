
<cfsilent>
<cfquery name="Parent" 
 	datasource="appsTravelClaim" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT     *
	FROM       ClaimEventIndicatorCost 
	WHERE     TransactionNo = '#URL.TransactionNo#' 
</cfquery>	

<cfparam name="url.amount" default="">

<cfquery name="cnt" 
 	datasource="appsTravelClaim" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT    *
	FROM      ClaimEventIndicatorCost
	WHERE     ClaimEventId     = '#Parent.ClaimEventid#'
	AND       IndicatorCode    = '#Parent.IndicatorCode#'
	AND       CostLineNo       = '#Parent.CostLineNo#'		
</cfquery>

<cfquery name="lines" 
 	datasource="appsTravelClaim" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT    max(MatchingNo) as Last
	FROM      ClaimEventIndicatorCostLine
	WHERE     ClaimEventId     = '#Parent.ClaimEventid#'
	AND       IndicatorCode    = '#Parent.IndicatorCode#'
	AND       CostLineNo       = '#Parent.CostLineNo#'		
</cfquery>

<cfif lines.last eq "">
	<cfset llast = 0>
<cfelse>
	<cfset llast = lines.last>
</cfif>

<cfset amount = replace(url.amount, ',','',"ALL")>  

<cfif amount neq "" and LSIsNumeric(amount)>

	<cfif amount lte cnt.InvoiceAmount>
	
		<!--- disallow entered amount to exceed the invoice amount --->
	
		<cfquery name="Check" 
	 	datasource="appsTravelClaim" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT     *
		FROM       ClaimEventIndicatorCostLine
		WHERE      ClaimEventId     = '#Parent.ClaimEventid#'
			AND    IndicatorCode    = '#Parent.IndicatorCode#'
			AND    CostLineNo       = '#Parent.CostLineNo#'
			AND    ClaimRequestid   = '#url.ClaimRequestid#'
			AND    ClaimRequestLine = '#url.ClaimRequestLineNo#'		
		</cfquery>	
	
		<cfif Check.recordcount gte "1">
		
			<cfquery name="Update" 
		 	datasource="appsTravelClaim" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			UPDATE  ClaimEventIndicatorCostLine
			SET 	MatchingAction        = 1,
			    	MatchingInvoiceAmount = '#amount#',
					ClaimObligated        = 1,
					ClaimAutoMatching     = 0,
					Created               = getDate()
			WHERE   ClaimEventId     = '#Parent.ClaimEventid#'
				AND IndicatorCode    = '#Parent.IndicatorCode#'
				AND CostLineNo       = '#Parent.CostLineNo#'
				AND ClaimRequestid   = '#url.ClaimRequestid#'
				AND ClaimRequestLine = '#url.ClaimRequestLineNo#'		
			</cfquery>	
		
		<cfelse>
		
			<cfquery name="Insert" 
			  datasource="appsTravelClaim" 
			  username="#SESSION.login#" 
			  password="#SESSION.dbpw#">
				INSERT INTO ClaimEventIndicatorCostLine
				 (ClaimEventId, 
				  IndicatorCode, 
				  CostLineNo, 
				  MatchingNo, 
				  MatchingAction,
				  MatchingInvoiceAmount, 
				  ClaimObligated,
				  ClaimAutoMatching, 
				  ClaimRequestId, 
				  ClaimRequestLine)
				VALUES
				('#Parent.ClaimEventid#',
				 '#Parent.IndicatorCode#',
				 '#Parent.CostLineNo#',
				 '#llast+1#',
				 '1',
				 '#amount#',
				 '1',
				 '0',
				 '#url.ClaimRequestid#',
				 '#url.ClaimRequestLineNo#')			
		    </cfquery>			
					
		</cfif>
	
	</cfif>
	
</cfif>	

<!--- the purpose below is to ensure amounts are not doubled --->
	
<cfquery name="Check" 
	 	datasource="appsTravelClaim" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT    sum(MatchingInvoiceAmount) as Total
		FROM      ClaimEventIndicatorCostLine
		WHERE     ClaimEventId     = '#Parent.ClaimEventid#'
		AND       IndicatorCode    = '#Parent.IndicatorCode#'
		AND       CostLineNo       = '#Parent.CostLineNo#'
</cfquery>

<cfif check.total neq cnt.InvoiceAmount>

	<cfset diff = cnt.InvoiceAmount-check.total>
	
	<cfquery name="priorline" 
 	datasource="appsTravelClaim" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT *
	FROM   ClaimEventIndicatorCostLine
	WHERE   ClaimEventId     = '#Parent.ClaimEventid#' 
		AND IndicatorCode    = '#Parent.IndicatorCode#'
		AND CostLineNo       = '#Parent.CostLineNo#' 
	ORDER BY Created			
	</cfquery>	
	
	<cfquery name="Update" 
 	datasource="appsTravelClaim" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	UPDATE  ClaimEventIndicatorCostLine
	SET 	MatchingInvoiceAmount = MatchingInvoiceAmount+#diff#
	WHERE   ClaimEventId     = '#Parent.ClaimEventid#'
		AND IndicatorCode    = '#Parent.IndicatorCode#' 
		AND CostLineNo       = '#Parent.CostLineNo#'
		AND MatchingNo       = '#priorLine.MatchingNo#'
	</cfquery>		

</cfif>

<cfquery name="FundingLines" 
	 	datasource="appsTravelClaim" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT   L.ClaimRequestId, 
		         L.ClaimRequestLineNo, 
				 L.ClaimCategory, 
				 L.PersonNo, 
				 L.Currency, 
				 L.RequestAmount, 
				 L.Remarks
		FROM     ClaimRequestLine L INNER JOIN
                 ClaimRequest ON L.ClaimRequestId = dbo.ClaimRequest.ClaimRequestId
        WHERE    (L.ClaimCategory = '#url.ClaimCategory#') 
		AND      ClaimRequest.ClaimRequestId = '#url.ClaimRequestid#'
		</cfquery>

</cfsilent>

<table cellspacing="0" cellpadding="1">
	
	<cfoutput query="FundingLines">
			
			<tr>
						
			<cfquery name="Details" 
				 	datasource="appsTravelClaim" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
					SELECT    MatchingAction,MatchingInvoiceAmount
					FROM      ClaimEventIndicatorCostLine
					WHERE     ClaimEventId     = '#Parent.ClaimEventid#'
					AND       IndicatorCode    = '#Parent.IndicatorCode#'
					AND       CostLineNo       = '#Parent.CostLineNo#'
					AND       ClaimRequestid   = '#ClaimRequestid#'
					AND       ClaimRequestLine = '#ClaimRequestLineNo#'		
			</cfquery>
			
			<td>Charge to Line #ClaimRequestLineNo# :</td>
			<td>&nbsp;</td>
			<!---
			<td width="30"><img src="#SESSION.root#/images/group3.gif" alt="Associated to" border="0" align="absmiddle">
			--->
		 	<td>#cnt.InvoiceCurrency#&nbsp;</td>
			<td>
				<input type="text"
		       name     = "MatchingInvoiceAmount"
		       value    = "#numberFormat(Details.MatchingInvoiceAmount,",_.__")#"
		       size     = "8"
		       maxlength= "20"
		       class    = "amount"
		       onChange = "refresh('#transactionno#','#ClaimRequestLineNo#',this.value,'#url.claimcategory#')">
	  	   </td>		  		   
		   <td></td>
		   </tr>	   
		  			
	</cfoutput>
		
</table>		
