
<cfquery name="get" 
	datasource="AppsPurchase" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT      RequisitionNo,
	            Reference, 
	            (SELECT PurchaseNo
				 FROM   PurchaseLine
				 WHERE  Requisitionno = L.RequisitionNo) as PurchaseNo,
	            ItemMaster,
				RequestDescription, 
				RequestType, 
				RequestCurrency, 
				RequestCurrencyPrice, 
				RequestQuantity, 
				RequestAmountBase, 
				ActionStatus
	FROM        RequisitionLine L
	WHERE       RequirementId = '#Object.ObjectKeyValue4#' 
	AND         ActionStatus NOT IN ('0','9')
</cfquery>

<table style="width:100%">
<tr><td style="padding:3px">
	
	<table style="width:100%">
	
	<tr class="line">
	<td><cf_tl id="Pre-encumberance"></td>	
	<td><cf_tl id="Description"></td>
	<td><cf_tl id="Status"></td>
	<td><cf_tl id="Obligation"></td>
	<td><cf_tl id="Quantity"></td>
	<td><cf_tl id="Currency"></td>
	<td align="right"><cf_tl id="Amount"></td>
	</tr>
	
	<cfoutput query="get">
		<tr class="labelmedium line">
			<td>#Reference#</td>			
			<td>#RequestDescription#</td>
			<td><cfif actionstatus lt "3"><cf_tl id="In Process"><cfelseif actionstatus eq "3"><font color="008040"><cf_tl id="Issued"></cfif></td>
			<td>#PurchaseNo#</td>
			<td>#RequestQuantity#</td>
			<td>#RequestCurrency#</td>
			<td align="right" style="padding-right:4px">#numberformat(RequestCurrencyPrice,",.__")#</td>
		</tr>
	</cfoutput>	
	
	</table>

</td></tr>

<tr><td style="padding:3px">

    <cfquery name="Itin" 
	datasource="AppsPurchase" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT *
	    FROM  RequisitionLineItinerary I, 
		      TravelClaim.dbo.Ref_CountryCity C, 
			  System.dbo.Ref_Nation R
		WHERE I.CountryCityId = C.CountryCityId
		AND   I.RequisitionNo = '#get.RequisitionNo#'
		AND   R.Code = C.LocationCountry
	</cfquery>
	
	<table style="width:100%">
		
	<tr bgcolor="white" class="line">
		   <td width="10%"><cf_tl id="Country"></td>	
		   <td width="120"><cf_tl id="City"></td>	
		   <td width="200"><cf_tl id="Memo"></td>	
		   <td width="80"><cf_tl id="Departure"></td>
		   <td width="80"><cf_tl id="Return"></td>	   		  		  		  
		   <td width="1%" align="center"></td>	  
	</TR>	
								
	<cfoutput query="Itin">	
			    				
		<TR class="line navigation_row labelmedium" style="height:20px">
		    <td>#Name#</td>
		    <td>#LocationCity#</td>				
			<td>#Memo#</td>		
		    <td>#dateformat(dateDeparture,CLIENT.DateFormatShow)#</td>				
			<td>#dateformat(dateArrival,CLIENT.DateFormatShow)#</td>			    	    				
		    <td align="center"></td>			   
	    </TR>	
		
	</cfoutput>
	
	</table>

</td></tr>

</table>