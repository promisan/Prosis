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
<cfsavecontent variable="error">
	
	<cfif form.itemno eq "">
	  <tr><td class="verdana">- <cf_tl id="No Item selected"></td></tr> 
	</cfif>
	
</cfsavecontent>

<cfif error neq "">
    <table width="100%" cellspacing="0" border="0" bordercolor="silver" cellpadding="0" class="formpadding">
	<tr><td bgcolor="red"><font color="FFFFFF"><b><cf_tl id="Attention"> : <cf_tl id="The following error was detected">:</font></td></tr>
	<tr><td height="1" bgcolor="e4e4e4"></td></tr>
      <cfoutput>#error#</cfoutput>
	</table>
	<br>
	<cfinclude template="TransactionDetailLines.cfm">
    <cfabort>
</cfif>
			
<cfquery name="Item"
	datasource="AppsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
    SELECT  *
	FROM    Item
	WHERE   ItemNo = '#form.ItemNo#' 
</cfquery>	
		
<cfquery name="ItemUoM"
	datasource="AppsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
    SELECT  *
	FROM    ItemUoM
	WHERE   ItemNo = '#form.ItemNo#' 
	AND     UoM    = '#form.UoM#'	
</cfquery>	

<cfif ItemUoM.recordcount eq "0">

	<cf_tl id="UoM information is not available.">
	<cfset msg1="#lt_text#">
	
	<cf_tl id="Operation not allowed.">
	<cfset msg2="#lt_text#">

	<cf_message essage = "#msg1# #msg2#"
		return = "no">
		<cfabort>
		  
</cfif>		
  
<cfquery name="ItemUoMMission"
	datasource="AppsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
    SELECT  *
	FROM    ItemUoMMission
	WHERE   ItemNo  = '#form.ItemNo#' 
	AND     UoM     = '#form.UoM#'	
	AND     Mission = '#Form.Mission#'
</cfquery>	

<cfquery name="Type"
	datasource="AppsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT *
		FROM   Ref_TransactionType
		WHERE  TransactionType = '#form.tratpe#'
</cfquery>	

<cf_verifyOperational 
     module="Accounting" 
	 Warning="No">
		 
<cfif operational eq "1">
	
	    <!--- link with ledger --->
	
	 	<cfquery name="AccountStock"
				datasource="AppsMaterials" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
			    SELECT  GLAccount
				FROM    Ref_CategoryGLedger
				WHERE   Category = '#Item.Category#' 
				AND     Area     = 'Stock'
				AND     GLAccount IN (SELECT GLAccount FROM Accounting.dbo.Ref_Account)
		</cfquery>	
					
		<cfquery name="AccountTask"
				datasource="AppsMaterials" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
			    SELECT  GLAccount
				FROM    Ref_CategoryGLedger
				WHERE   Category = '#Item.Category#' 
				AND     Area     = '#Type.Area#'
				AND     GLAccount IN (SELECT GLAccount FROM Accounting.dbo.Ref_Account)
		</cfquery>	
			
		<cfif AccountStock.recordcount eq "0" or 
		      AccountTask.Recordcount eq "0">
	
			<cf_tl id="Financials GL Account information has not been set for this item." var="1">
			<cfset msg1="#lt_text#">
	
			<cf_tl id="Operation not allowed." var="1">
			<cfset msg2="#lt_text#">
											
			<cf_message message = "#msg1#<br>#msg2#" return = "no">
			<cfabort>
			
		</cfif>	
		
		<cfif AccountStock.glaccount eq AccountTask.glAccount>
		
		    <cf_tl id="Stock account may not be the same for usage account (#AccountStock.glaccount#)." var="1">
			<cfset msg1="#lt_text#">
	
			<cf_tl id="Operation not allowed." var="1">
			<cfset msg2="#lt_text#">
											
			<cf_message message = "#msg1#<br>#msg2#" return = "no">
			<cfabort>
				
		</cfif>
							
</cfif>		

<cfparam name="Form.Assetid"         default="">
<cfparam name="Form.OrgUnit"         default="0">
<cfparam name="Form.TransactionLot"  default="0">

<cfset tableName = "StockTransaction#URL.Warehouse#_#url.mode#"> 
<cf_getPreparationTable warehouse="#url.warehouse#" mode="#url.mode#"> <!--- adjusts #tableName# i.e. preparation can be per user or per warehouse --->
	 
		 
<cfloop index="itm" from="1" to="#form.rows#">

	<cf_assignId>
	
	<cfparam name="Form.location#itm#"           default="">
	<cfparam name="Form.location#itm#_quantity"  default="">
	<cfparam name="Form.location#itm#_reference" default="">
	<cfparam name="Form.location#itm#_lot"       default="0">	
	<cfparam name="Form.location#itm#_tax"       default="0">
	<cfparam name="Form.location#itm#_cur"       default="#Application.basecurrency#">
	<cfparam name="Form.location#itm#_prc"       default="0">
	
	<cfset loc = evaluate("Form.location#itm#")>
	<cfset qty = evaluate("Form.location#itm#_quantity")>
	<cfset ref = evaluate("Form.location#itm#_reference")>
	<cfset lot = evaluate("Form.location#itm#_lot")>
	<cfset prc = evaluate("Form.location#itm#_prc")>
	
	<cfif lot eq "0">
		<cfset lot = form.TransactionLot>
	</cfif>
	
	<cfif qty eq "">
		<cfset qty = 0>
	</cfif>
	
	<!--- remove digits --->
	<cfset qty  = replace("#qty#",",","")>
	<cfset prc  = replace("#prc#",",","")>
	
	<cfif isNumeric(qty) and isNumeric(prc)>
	
	<cfif form.tratpe eq "2">
	   <cfset qty = -qty>
	</cfif>

	<cfif qty gte 0>
		
	    <cfset debit   = "#AccountStock.GLAccount#">
		<cfset credit  = "#AccountTask.GLAccount#">
			
	<cfelse>
		
		<cfset credit  = "#AccountStock.GLAccount#">
		<cfset debit   = "#AccountTask.GLAccount#">
		
	</cfif>		
		
	<cfquery name="Org" 
		datasource="AppsOrganization" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT   *
		FROM     Organization
		WHERE    OrgUnit = '#form.orgunit#'		
	</cfquery>
			
	<cfset dateValue = "">
	<CF_DateConvert Value="#form.transactiondate#">
	<cfset DTE = dateValue>
	
	<cfparam name="Form.BillingMode" default="Internal">
	
	<cfset dte = DateAdd("h","#form.transaction_hour#", dte)>
	<cfset dte = DateAdd("n","#form.transaction_minute#", dte)>
	
		<cfif qty neq "0" and isNumeric(qty) and isNumeric(prc)>
		
			<cf_verifyOperational module="WorkOrder" Warning="No">
		
			<cfif url.mode eq "externalsale" and operational eq "1">
			
				<cfquery name="check" 
				datasource="AppsMaterials" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
					SELECT   *
					FROM     Customer
					WHERE    CustomerId = '#Form.CustomerId#'	
				</cfquery>				
								
				<cfif check.recordcount eq "0">
				
					<cfquery name="check" 
					datasource="AppsWorkOrder" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
						SELECT   *
						FROM     Customer
						WHERE    CustomerId = '#Form.CustomerId#'	
					</cfquery>
					
					<cfif check.recordcount eq "1">
					
						<cfinvoke component = "Service.Process.Materials.Customer"  
						   method           = "addCustomer" 			   
						   customerid       = "#form.CustomerId#">	   										
					
					</cfif>
				
				
				</cfif>
				
			</cfif>
			
			<cf_verifyOperational module="Accounting" Warning="No">
			
			<cfquery name="Insert" 
			datasource="AppsTransaction" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			
			INSERT INTO dbo.#tableName#
				   ( TransactionId,
				     TransactionType, 
				     TransactionDate, 
					 ItemNo, 
					 ItemDescription, 
					 ItemCategory, 
					 Mission, 
					 Warehouse, 					
					 TransactionLot,					
					 BillingMode,
					 TransactionUoM, 
					 Location, 
					 TransactionQuantity, 
					 TransactionUoMMultiplier,
				     TransactionCostPrice, 
					 TransactionReference,
					 Remarks, 		
					 		 
					 <cfif url.mode eq "workorder">
					 
						 WorkorderId,
						 WorkOrderLine,
						 BillingUnit,
						 SalesPrice,
						 OrgUnit,
						 OrgUnitCode,
						 OrgUnitName,
						 
					 <cfelseif url.mode eq "sale" or url.mode eq "disposal">	
					 
						 AssetId,
						 OrgUnit,
						 OrgUnitCode,
						 OrgUnitName,
						 PersonNo,
						 SalesPrice,
					 
					 <cfelseif url.mode eq "externalsale">
					 
						 CustomerId,
						 SalesCurrency,
						 TaxCode,
						 Salesprice,
					 
					 </cfif>
					 <cfif operational eq 1>
					 	GLAccountDebit, 
					 	GLAccountCredit, 
					 </cfif>
					 OfficerUserid,
					 Created)
					 
			VALUES (
				   
				   '#rowguid#',
				   '#form.tratpe#',
				   #dte#,
				   '#form.ItemNo#',
				   '#Item.ItemDescription#',
				   '#Item.Category#',
				   '#form.Mission#',
				   '#form.Warehouse#', 				  
				   '#Lot#',  
				   '#form.BillingMode#',  
				   '#form.UOM#',
				   		'#loc#',
				        '#qty#',
				   '#ItemUoM.UoMMultiplier#',
				   
				   <cfif url.mode eq "initial">
				   
					   <cfif prc gt "0">				   
					   		'#prc#',
					   <cfelseif ItemUoMMission.standardCost neq "">
						   '#ItemUomMission.StandardCost#',
					   <cfelse>
						   '#ItemUom.StandardCost#',
					   </cfif>
				   
				   <cfelse>
				   
					   <cfif ItemUoMMission.standardCost neq "">
						   '#ItemUomMission.StandardCost#',
					   <cfelse>
						   '#ItemUom.StandardCost#',
					   </cfif>
				   				   
				   </cfif>				   
				   
				   <cfif ref neq "">
				   '#ref#',
				   <cfelse>
				   '#Form.TransactionReference#',
				   </cfif>
				   				   
				   '#form.Remarks#',
				   
				   <cfif url.mode eq "workorder">
				   
					   '#Form.WorkOrderId#',
					   '#form.WorkOrderLine#',
					   '#form.BillingUnit#',
					   '#prc#',
					   
					   <cfif org.recordcount eq "1">
						   '#Org.OrgUnit#',
						   '#Org.OrgUnitCode#',
						   '#Org.OrgUnitName#',
					   <cfelse>
						   NULL,
						   NULL,
						   NULL,					   
					   </cfif>
					   
				   <cfelseif url.mode eq "sale" or url.mode eq "disposal">	
				   
				       <cfif form.assetid neq "">				      
				       '#form.assetid#',
					   <cfelse>
					   NULL,
					   </cfif>
					   <cfif form.orgunit eq "">
						   NULL,
						   NULL,
						   NULL,
					   <cfelse>
						   '#form.orgunit#',
						   '#org.orgunitcode#',
						   '#org.orgunitname#',
					   </cfif>
					   '#form.personno#',
					   '#prc#',
					   
				   <cfelseif url.mode eq "externalsale">
				   
				   		 '#Form.CustomerId#',
						 '#Application.BaseCurrency#',
						 '00',
						 '#prc#',
				   	   					   
				   </cfif>
				   <cfif operational eq 1>
				   	   '#debit#',
					   '#credit#',
				   </cfif>
				   '#SESSION.acc#',			  
				   getDate()
				   ) 
			  
			</cfquery>
		
		</cfif>
	
	</cfif>
	
</cfloop>

<cfset url.tratpe = form.tratpe>

<cfinclude template="TransactionDetailLines.cfm">

