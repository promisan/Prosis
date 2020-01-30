
<!--- show the threshold --->

<cfparam name="Attributes.PurchaseNo" default="">
<cfparam name="Attributes.OrgUnit"    default="0">

<cfquery name="get"
	datasource="AppsPurchase" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">								
	SELECT   * 
	FROM     Purchase 
   	WHERE    PurchaseNo = '#attributes.purchaseno#'										
</cfquery>			

<cfquery name="Threshold"
	datasource="AppsLedger" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">								
		SELECT   TOP 1 AmountThreshold 
	   	FROM     Organization.dbo.OrganizationThreshold
		WHERE    OrgUnit        = '#Attributes.OrgUnit#'
		AND      ThresholdType  = 'Payable'
		AND      Currency       = '#get.currency#'  
		AND      DateEffective  <= getDate()
		ORDER BY DateEffective DESC										
</cfquery>			

<cfif threshold.recordcount gte "1">
				
		<cfquery name="Payable"
			datasource="AppsLedger" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">								
			SELECT   SUM(AmountOutstanding) as Total 
	    	FROM     TransactionHeader
			WHERE    ReferenceOrgUnit  = '#Attributes.OrgUnit#'
			AND      TransactionCategory  = 'Payables'
			AND      Mission        = '#get.mission#'
			AND      Currency       = '#get.currency#'  												
		</cfquery>				
		
		<cfoutput>
		<table>
		<tr class="labelmedium">
		   <td  class="labelit" style="padding-left:20px"><cf_tl id="Accounts payable">:</td>
		   <td  class="labelmedium" style="padding-left:5px">#numberformat(Payable.Total,',.__')#</td>		   
		   <td  class="labelit" style="padding-left:5px"><cf_tl id="Threshold">:</td>	
		   <td  class="labelmedium" style="padding-left:5px"><cfif Payable.total gte threshold.amountThreshold><font color="FF0000"></cfif>#Threshold.amountThreshold#</td>	
	   </tr>		   
	   </table>	
	   </cfoutput>
				
</cfif>		