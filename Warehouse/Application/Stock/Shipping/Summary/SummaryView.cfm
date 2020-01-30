
<!--- validation --->

<cfquery name="getPending" 
	  datasource="AppsMaterials" 
	  username="#SESSION.login#" 
	  password="#SESSION.dbpw#">	  
		SELECT    *
		FROM      ItemTransaction AS T
		WHERE     TransactionId NOT IN
		                          (SELECT  TransactionId
		                           FROM    ItemTransactionShipping
								   WHERE   TransactionId = T.TransactionId) 
		AND       BillingMode     = 'External' 
		AND       TransactionType IN ('2','8')
		AND       OrgUnit IS NOT NULL 
		AND       Mission = '#URL.Mission#'
		ORDER BY  TransactionDate
</cfquery>

<cfloop query="getPending">

	<cfquery name="Insert" 
	   datasource="AppsMaterials" 
	   username="#SESSION.login#" 
	   password="#SESSION.dbpw#">
	   INSERT INTO Materials.dbo.ItemTransactionShipping 
			(TransactionId, 
			 SalesCurrency,
			 TaxCode,
			 TaxPercentage,
			 TaxExemption,
			 TaxIncluded, 			
			 OfficerUserid,
			 OfficerLastName,
			 OfficerFirstName)
	VALUES 
			('#TransactionId#', 		
			 '#APPLICATION.BaseCurrency#',
			 '00',			 
			 '0',
			 '0',
			 '0', 			
			 '#SESSION.acc#', 
			 '#SESSION.last#',
			 '#SESSION.first#')
	</cfquery>	

</cfloop>


<cfoutput>

<table width="100%" align="center">

<tr><td class="linedotted" colspan="8"></td></tr>
<tr class="labelit">	 
	  <td height="20" width="35"></td>   
	  <td></td>
	  <td width="20"></td>
	  <td class="labelit">Equipment</td>
	  <td align="center">Lines</td>
	  <td class="labelit">Product</td>
	  <td class="labelit">UoM</td>	  
	  <td class="labelit" align="right">Total</td>  
</tr>
<tr><td colspan="8" class="linedotted"></td></tr>	

<cfloop index="status" from="0" to="3">
	
	<tr><td colspan="8" class="labellarge" style="height:30" style="padding-bottom:1px;padding-top:10;">
	<cfif status eq "0">	
		Transaction Pending Confirmation
	<cfelseif status eq "1">		
		Ready for Billing	
	<cfelseif status eq "2">		
		In Process	
	<cfelseif status eq "3">		
		Billed in #year(now())#
	</cfif>
	</td></tr>	
	
	<tr><td colspan="8" class="linedotted"></td></tr>
	
	<cfset url.actionStatus = status>
	
	<cfinclude template="SummaryDetail.cfm">
	
	<tr><td height="5"></td></tr>
		
</cfloop>

</table>

</cfoutput>

	  
