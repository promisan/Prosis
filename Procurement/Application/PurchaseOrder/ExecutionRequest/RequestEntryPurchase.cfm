	<cfquery name="Purchase" 
		datasource="AppsPurchase" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT     *
		FROM      Purchase
		WHERE     (Mission = '#url.mission#') 
		AND       (PurchaseNo IN
                       (SELECT    PurchaseNo
                         FROM     PurchaseExecution
                         GROUP BY PurchaseNo
                         HAVING      COUNT(*) > 0))
		AND		  PurchaseNo IN 
					(
						SELECT DISTINCT P.PurchaseNo
						FROM   Purchase P INNER JOIN
                               PurchaseLine PL ON P.PurchaseNo = PL.PurchaseNo INNER JOIN
                               RequisitionLineFunding F ON PL.RequisitionNo = F.RequisitionNo INNER JOIN
                               Program.dbo.Program Pr ON F.ProgramCode = Pr.ProgramCode
			            WHERE  Pr.ProgramCode = '#URL.ProgramCode#'
					 )						 		
					
		
	</cfquery>
	
	<cfoutput>
	
	<cfparam name="url.PurchaseNo" default="">
	
	 <cfif purchase.recordcount eq "0">
	 
	 	<input type="hidden" name="purchaseno">
	 
	 <cfelse>
	
	 <select name="purchaseno" id="purchaseno" class="regularxl" onchange="ColdFusion.navigate('RequestPurchaseItem.cfm?purchaseno='+this.value,'line')">
	        <option value=""></option>
		    <cfloop query="Purchase">
			   	 <option value="#PurchaseNo#" <cfif url.PurchaseNo eq PurchaseNo>selected</cfif>>#PurchaseNo#</option>
			</cfloop>
      </select>
	  
	  </cfif>
	
	<cfif url.PurchaseNo neq "">

	    <script>
    	    ColdFusion.navigate('RequestPurchaseItem.cfm?executionid=#url.executionid#&access=#url.access#&purchaseno=#url.purchaseNo#','line')
	    </script>              
	</cfif>    
	
	</cfoutput>

<script>
	$('#line').hide();
</script>	  
	  