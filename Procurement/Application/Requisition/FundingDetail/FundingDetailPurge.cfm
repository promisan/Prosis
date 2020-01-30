
<cfquery name="Delete" 
	     datasource="AppsPurchase" 
	     username="#SESSION.login#" 
	     password="#SESSION.dbpw#">
	     DELETE FROM RequisitionLineFundingDetail 
		 WHERE RequisitionNo = '#URL.ID#'
		 AND FundingId = '#URL.fundingid#'
		 AND DetailNo = '#url.id2#'
</cfquery>

<cfoutput>

     <cfset url.id2 = ""> 	
	 <cfinclude template="FundingDetail.cfm">	

</cfoutput>