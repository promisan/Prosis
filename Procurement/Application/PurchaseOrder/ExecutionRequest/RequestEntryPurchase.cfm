<!--
    Copyright © 2025 Promisan

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

        http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
-->
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
	  