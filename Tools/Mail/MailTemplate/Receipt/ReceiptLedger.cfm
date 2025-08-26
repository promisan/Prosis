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

<!--- eMail of sales that is recorded in the ledger module and will get the data 
                                                             from the financials instead of the warehouse batch --->

<cf_screentop html="No" layout="webapp">

<cfparam name="attributes.ActionId" default="BBA46599-AAB2-6219-3BE7-BE282B60E820">

<cfset actionid = attributes.batchid>

<cfquery name="Header" 
	   datasource="AppsLedger" 
	   username="#SESSION.login#" 
	   password="#SESSION.dbpw#">
	   
	   SELECT     TH.Journal, Journal.Description, TH.JournalSerialNo, 
	              TH.Mission, TH.OrgUnitOwner, TH.TransactionDate, TH.TransactionPeriod, 
	              TH.Reference, TH.ReferenceName, TH.ReferenceNo, TH.ReferenceId, 
				  THA.ActionReference1, THA.ActionReference2, THA.ActionReference3, THA.ActionReference4, 
				  THA.EMailAddress, 
				  TH.DocumentCurrency, TH.DocumentAmount
				  
       FROM       TransactionHeader AS TH INNER JOIN
                  TransactionHeaderAction AS THA ON TH.Journal = THA.Journal AND TH.JournalSerialNo = THA.JournalSerialNo INNER JOIN
                  Journal ON TH.Journal = Journal.Journal
				  
	   WHERE      THA.ActionId = '#attributes.actionid#'	
	   		      
</cfquery>

<cfif isValid("email","#Header.eMailAddress#")>

	    <!--- 14/11 standard eMail content for FEL posting --->
	
	
	    <!---
		
		<cfquery name="Lines" 
			   datasource="AppsMaterials" 
			   username="#SESSION.login#" 
			   password="#SESSION.dbpw#">
			   
			   SELECT     WB.Mission, 
			              WB.BatchNo, 
						  WB.TransactionDate, 
						  T.ItemNo, 
						  T.ItemDescription, 
						  T.TransactionUoM, 
						  B.ItemBarCode, 
						  T.TransactionQuantity, 
						  TS.SalesCurrency, 
		                  TS.SalesPrice, 
						  TS.SalesAmount, 
						  TS.SalesTax, 
						  TS.SalesTotal
			   FROM       WarehouseBatch WB INNER JOIN
		                  ItemTransaction T ON WB.BatchNo = T.TransactionBatchNo INNER JOIN
		                  ItemTransactionShipping TS ON T.TransactionId = TS.TransactionId LEFT OUTER JOIN
		                  ItemUoMMissionLot B ON T.ItemNo = B.ItemNo AND T.Mission = B.Mission AND T.TransactionUoM = B.UoM AND T.TransactionLot = B.TransactionLot
			   WHERE      WB.BatchId = '#batchId#'
					
		</cfquery>
		
		<cfquery name="Settle" 
			   datasource="AppsMaterials" 
			   username="#SESSION.login#" 
			   password="#SESSION.dbpw#">
			   SELECT     *
			   FROM       WarehouseBatchSettlement
			   WHERE      BatchNo = '#Header.BatchNo#'
		</cfquery>	   
		
		--->
		
	    <cfset frommail = "dev@email">
	
		<cfquery name="Param" 
			datasource="AppsSystem" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			   SELECT     *
			   FROM       Parameter		   
		</cfquery>	
	
	    <cfset frommail = "#Param.DefaulteMail#">   	
		
		<cfsavecontent variable="#body#">
		
		    <cfoutput query="Header">
			
				<table style="min-width:500px">
					<tr class="labelmedium2"><td colspan="2" style="padding-left:10px;font-size:15px;font-family: Calibri;">Dear Patient</td></tr>		
					<tr class="labelmedium2"><td colspan="2" style="padding-left:10px;font-size:15px;font-family: Calibri;">Below you find the link to your Electronic Invoice issued on 
					#dateformat(Action.ActionDate,client.dateformatshow)# for a total of #Header.DocumentCurrency# #numberformat(Header.DocumentAmount,',.__')#</td></tr>
					<tr class="labelmedium2"><td colspan="2" style="padding-left:10px;font-size:15px;font-family: Calibri;">
					<tr class="labelmedium2">
			            <td width="20%" >UUID</td>
				        <td width="80%" align="right">
						<a href="https://report.feel.com.gt/ingfacereport/ingfacereport_documento?uuid=#vCae#" target="_blank">#ActionReference1#</a>
						</td>
				    </tr>	
					<tr class="labelmedium2"><td colspan="2" style="padding-left:10px;font-size:15px;font-family: Calibri;">Regards</td></tr>
				</table>	
				
			</cfoutput>	
		
   		</cfsavecontent>
		
		<cfmail to      = "#Header.eMailAddress#" 
		        from    = "#frommail#" 
				bcc     = "#frommail#" 
		        subject = "Electronic Invoice" 
				type    = "HTML" 
				spoolEnable = "Yes">
		
			    <cfoutput>#body#</cfoutput>
				
				<br><br>
			    <!--- disclaimer --->
    			<cf_maildisclaimer context="password" id="mailid:#attributes.ActionId#">
										
		</cfmail>
	
</cfif>	
