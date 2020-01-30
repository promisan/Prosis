
<cfquery name="get" 
		datasource="AppsWorkOrder" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT * 
		FROM   WorkOrderFunding
		WHERE  FundingDetailId = '#URL.ID2#'
	</cfquery>

	<cfquery name="Delete" 
		datasource="AppsWorkOrder" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		UPDATE WorkOrderFunding
		SET    Operational = 0
		WHERE  FundingDetailId = '#URL.ID2#'			
	</cfquery>
	
<cfif url.billingdetailid neq "">
	 <cfset url.id2 = "">
</cfif>

<cfif get.workorderline eq "">
	
		<cfinclude template="FundingLine.cfm">
	
<cfelse>

	<cfoutput>
		 <script>
	    	 ColdFusion.navigate('../ServiceDetails/Billing/DetailBillingList.cfm?workorderid=#URL.workorderid#&workorderline=#get.workorderline#','billingdata')
		 </script>
		</cfoutput> 	 
		
</cfif>



