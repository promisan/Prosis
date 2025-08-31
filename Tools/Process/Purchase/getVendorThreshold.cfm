<!--
    Copyright © 2025 Promisan B.V.

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