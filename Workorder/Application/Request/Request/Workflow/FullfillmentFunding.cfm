
<cfquery name="get" 
datasource="AppsWorkOrder" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
    FROM   Request
	WHERE  RequestId = '#Object.ObjectkeyValue4#'	
</cfquery>

<table cellspacing="6" cellpadding="6" width="96%" align="center" class="formpadding">

    <tr class="labelit"><td></td>
	    <td></td>
	    <td>Funding Budget Account Code</td>
		<td>Current Balance</td>
	</tr>	
	<tr><td colspan="4" class="line"></td></tr>	
	
	<tr class="labelit">
		
	<cfset link = "#SESSION.root#/Workorder/Application/Request/Request/Workflow/FullfillmentFundingGet.cfm?ts=1">	
				
	<td width="200">Select Funding for request:</td>	
	<td width="20">
	
	   <cf_selectlookup
	    box        = "funding"
		link       = "#link#"
		button     = "Yes"
		icon       = "contract.gif"
		close      = "Yes"
		class      = "funding"
		des1       = "FundingId">
		
	</td>						
	<td width="160" valign="top">
		<cfdiv id="funding">
		    <cfset url.fundingId = get.fundingid>
			<cfinclude template="FullfillmentFundingGet.cfm">
		</cfdiv>
	</td>	
	</tr>

    <input type="hidden" name="savecustom" id="savecustom" value="WorkOrder/Application/Request/Request/Workflow/FullfillmentFundingSubmit.cfm">
	
</table>	