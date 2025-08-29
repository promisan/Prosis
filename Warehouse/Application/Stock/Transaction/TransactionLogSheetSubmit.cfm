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
<cfparam name="form.transactionreference"   default="">
<cfparam name="form.itemno"                 default="">
<cfparam name="form.personno"               default="">
<cfparam name="form.tratpe"       			default="2">
<cfparam name="form.location"               default="">
<cfparam name="form.uom"                    default="">
<cfparam name="form.programcode"            default="">
<cfparam name="form.orgunit"                default="">
<cfparam name="form.assetid"                default="">

<cfset tableName = "StockTransaction#URL.Warehouse#_#url.mode#"> 
<cf_getPreparationTable warehouse="#url.warehouse#" mode="#url.mode#"> 

<cfsavecontent variable="error">
	
	<cfset itm = 0>
	
	<cfoutput>	
	
	<cfif form.itemno eq "" or form.uom eq "" or form.tratpe eq "" or form.location eq "">
	  <cfset itm = itm+1>
	  <tr><td class="label">#itm#. <cf_tl id="No Item selected"></td></tr> 
	</cfif>
	
	<cfif Form.tratpe eq "2">
	
		<cfif form.assetid eq "">
		   <cfset itm = itm+1>
		  <tr><td class="labelit">#itm#. <cf_tl id="No Equipment selected."></td></tr> 
		</cfif>
		
		<cfif form.personno eq "">
		  <cfset itm = itm+1>
		  <tr><td class="labelit">#itm#. <cf_tl id="No Receiver selected"></td></tr> 
		</cfif>
		
		<cfif form.orgunit eq "0">
		  <cfset itm = itm+1>
		  <tr><td class="labelit">#itm#. <cf_tl id="No Organization Unit selected"></td></tr> 
		</cfif>
							
		<cfquery name="ItemUoM"
			datasource="AppsMaterials" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
		    SELECT  *
			FROM    ItemWarehouseLocation
			WHERE   Warehouse = '#url.warehouse#'
			AND     Location  = '#form.location#'
			AND     ItemNo    = '#form.ItemNo#' 
			AND     UoM       = '#form.UoM#'
		</cfquery>	
		
		<cfif ItemUoM.recordcount eq "0">
		    <cfset itm = itm+1>
		    <tr><td class="label">#itm#. <cf_tl id="This location does not supply the selected item."></td></tr> 		
		</cfif>
			
	</cfif>
	
	</cfoutput>
		
</cfsavecontent>

<cfif error neq "">

	<table cellspacing="0" width="100%" cellpadding="0"><tr><td style="padding:5px">

	<cf_tableround mode="solidcolor" color="FFC6C6">
    <table width="94%" cellspacing="0" border="0" align="center" bordercolor="silver" cellpadding="0" class="formpadding">
	<tr><td align="center" style="padding:3px" class="label"><b><cf_tl id="Attention"></b> : <cf_tl id="The following error(s) were detected">:</font></td></tr>
	<tr><td height="1" bgcolor="silver"></td></tr>	  
      <cfoutput>#error#</cfoutput>
	</table>
	</cf_tableround>
	
	</td></tr></table>
		
	<cfset url.location = form.location>
	<cfset url.itemno   = form.ItemNo>
	<cfset url.uom      = form.UoM>
	<cfset url.tratpe   = form.tratpe>

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

	<cf_message 
		message = "#msg1# #msg2#"
		return = "no">
	<cfabort>
		  
</cfif>		 

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
				AND     Area = 'Stock'
				AND     GLAccount IN (SELECT GLAccount 
				                      FROM Accounting.dbo.Ref_Account)
		</cfquery>	
		
		<cfif form.tratpe eq "2" and form.assetid neq "">
		
		    <!--- 29/12/2011 : determine the alternate cost account for issues --->
							
			<cfquery name="Asset"
				datasource="AppsMaterials" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				    SELECT I.Category
					FROM   AssetItem A, Item I
					WHERE  AssetId = '#Form.AssetId#'
					AND    A.ItemNo = I.ItemNo		
			</cfquery>	
			
			<cfquery name="AccountTask"
					datasource="AppsMaterials" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
				    SELECT  GLAccount 
					FROM    Ref_CategoryGLedger
					WHERE   Category = '#Asset.Category#' 
					AND     Area     = '#Type.Area#'
					AND     GLAccount IN (SELECT GLAccount 
					                      FROM   Accounting.dbo.Ref_Account)
			</cfquery>	
				
		<cfelse>
					
			<cfquery name="AccountTask"
					datasource="AppsMaterials" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
				    SELECT  GLAccount
					FROM    Ref_CategoryGLedger
					WHERE   Category = '#Item.Category#' 
					AND     Area     = '#Type.Area#'
					AND     GLAccount IN (SELECT GLAccount 
					                      FROM   Accounting.dbo.Ref_Account)
			</cfquery>	
		
		</cfif>
			
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
	 
<cf_assignId>

<cfloop index="itm" from="1" to="1">

	<cf_assignid>
	
	<cfparam name="Form.location"            default="">
	<cfparam name="Form.TransactionId"       default="#rowguid#">
	<cfparam name="Form.ProgramCode"         default="">
	<cfparam name="Form.TransactionQuantity" default="">
	<cfparam name="Form.TransactionPrice"    default="0">
	<cfparam name="Form.metrics"             default="">
	<cfparam name="Form.movementuom"         default="">
	
	<cfset loc = evaluate("Form.location")>
	<cfset qty = evaluate("Form.TransactionQuantity")>
	<cfset prc = evaluate("Form.TransactionPrice")>

    <cfif qty eq "">
		<cfset qty = 0>
	</cfif>
	
	<cfset qty = replace("#qty#",",","")>
	<cfoutput>
		<cf_tl id="You recorded an invalid quantity" var = "1">
		<cfif not LSIsNumeric(qty)>	
			<script>
			alert("#lt_text#")
			</script>
			<cfabort>
		</cfif>	
	</cfoutput>	
		
	<cfif Form.tratpe eq "8">
		<cfset add = qty>
	</cfif>	
	
	<cfset qty = -qty>
		
	<cfif qty gte 0>
		
	    <cfset debit   = "#AccountStock.GLAccount#">
		<cfset credit  = "#AccountTask.GLAccount#">
			
	<cfelse>
		
		<cfset credit  = "#AccountStock.GLAccount#">
		<cfset debit   = "#AccountTask.GLAccount#">
		
	</cfif>			
	
	<cfif form.orgunit neq "">

		<cfquery name="Org" 
			datasource="AppsOrganization" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			SELECT   *
			FROM     Organization
			WHERE    OrgUnit = '#form.orgunit#'		
		</cfquery>
	
	</cfif>
	
	<cfparam name="movementuom"         default="">
	<cfparam name="movementmultiplier"  default="1">
	
	<cfif form.movementuom neq "">
				
		<cfquery name="get" 
			datasource="AppsMaterials" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			SELECT *
		    FROM   ItemWarehouseLocationUoM 
			WHERE  Warehouse   = '#Form.warehouse#'	
		    AND    Location    = '#loc#'	
			AND    ItemNo      = '#form.ItemNo#' 		
			AND    UoM         = '#form.UoM#' 		
			AND    MovementUoM = '#form.Movementuom#'				
		</cfquery>
		
		<cfif get.recordcount eq "1">
		
		    <cfset movementuom        = get.movementuom>
			<cfset movementmultiplier = get.movementmultiplier>
			<cfset movementquantity   = qty>
			<cfset qty = qty * movementmultiplier>
		
		</cfif>	
	
	</cfif>
	
	<cfset dateValue = "">
	<CF_DateConvert Value="#form.transaction_date#">
	<cfset DTE = dateValue>
	
	<cfparam name="Form.BillingMode" default="Internal">
	
	<cfset dte = DateAdd("h","#form.transaction_hour#", dte)>
	<cfset dte = DateAdd("n","#form.transaction_minute#", dte)>
		
	<cfif form.assetid neq "">				      	
		<cfinclude template = "TransactionAssetDetailsSubmit.cfm">					
	</cfif>
	
	<cfif qty neq "0" and isNumeric(qty) and isNumeric(prc)>
	
	    <cfif form.tratpe eq "2">
		
			<cfif form.transactionid neq "">

				<cfquery name="clear" 
				datasource="AppsTransaction" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
					DELETE FROM dbo.#tableName# 
					WHERE  TransactionId = '#form.transactionid#'
				</cfquery>

			</cfif>

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
					 ProgramCode,
					 Warehouse, 
					 BillingMode,
					 TransactionUoM, 
					 Location, 
					 <cfif movementuom neq "">
					   MovementUoM,
					   MovementQuantity,
					   MovementUoMMultiplier,
					 </cfif>
					 TransactionQuantity, 
					 TransactionUoMMultiplier,
				     TransactionCostPrice, 
					 TransactionReference,
					 Remarks, 						 
					 AssetId,
					 AssetMetric1,
					 AssetMetricValue1,
					 AssetMetric2,
 					 AssetMetricValue2,
					 AssetMetric3,
 					 AssetMetricValue3,
					 AssetMetric4,
					 AssetMetricValue4,					 
					 AssetMetric5,
					 AssetMetricValue5,		
					 
					 Event1,			
					 EventDate1,			
					 EventDetails1,
					 Event2,			
					 EventDate2,			
					 EventDetails2,
					 Event3,			
					 EventDate3,			
					 EventDetails3,
					 Event4,			
					 EventDate4,			
					 EventDetails4,
					 Event5,			
					 EventDate5,			
					 EventDetails5,
					 			 
					 OrgUnit,
					 OrgUnitCode,
					 OrgUnitName,
					 PersonNo,
					 SalesPrice,					 
					 <cfif operational eq 1>
					 	GLAccountDebit, 
					 	GLAccountCredit, 
					 </cfif>
					 OfficerUserId,
					 Created)
			VALUES (
				   '#form.Transactionid#',
				   '#form.tratpe#',
				   #dte#,
				   '#form.ItemNo#',
				   '#Item.ItemDescription#',
				   '#Item.Category#',
				   '#form.Mission#',
				   '#form.ProgramCode#', 
				   '#form.Warehouse#',    
				   '#Form.Billingmode#',   
				   '#form.UOM#',
				   '#loc#',
				   <cfif movementuom neq "">
					 '#MovementUoM#',
					 '#MovementQuantity#',
					 '#MovementMultiplier#',
				   </cfif>
				   '#qty#',
				   '#ItemUoM.UoMMultiplier#',
				   '#ItemUoM.StandardCost#',
				   '#Form.TransactionReference#',
				   '#form.Remarks#',
				   
				   <cfif form.assetid neq "">	
				   			      
				       '#form.assetid#',
					   <cfloop list="#form.metrics#" index="element">
							<cfloop list="#element#" index="key" delimiters="_">
								'#Key#',
							</cfloop>
					   </cfloop>
					   <cfloop from="1" to="#5-ListLen(Form.Metrics)#"  index="i">
								NULL,
								NULL,
					   </cfloop>

					   <cfloop from="1" to="#ArrayLen(aEvents)#" index="element">
							<cfloop list="#aEvents[element]#" index="key" delimiters=",">
								#PreserveSingleQuotes(Key)#,
							</cfloop>
					   </cfloop>
					   <cfloop from="1" to="#5-ArrayLen(aEvents)#"  index="i">
								NULL,
								NULL,
								NULL,								
					   </cfloop>			
					   					   					   
				   <cfelse>
				   
					   NULL,
					   <cfloop from = "1" to = "5" index="i">
								NULL,
								NULL,
					   </cfloop>		
					   			   
					   <cfloop from = "1" to = "5" index="i">
								NULL,
								NULL,
								NULL,								
					   </cfloop>					   
					   
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
				   <cfif operational eq 1>
				   	   '#debit#',
					   '#credit#',
				   </cfif>
				   '#SESSION.acc#',
				   getDate()
				   )		  
			</cfquery>
			
		<cfelse>
		
			<cfif form.transactionid neq "">
	
				<cfquery name="clear" 
				datasource="AppsTransaction" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
					DELETE FROM dbo.#tableName# 
					WHERE  TransactionId = '#form.transactionid#'
				</cfquery>
	
			</cfif>
			
			<!--- transfer FROM --->
			
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
						 ProgramCode,
						 Warehouse, 
						 BillingMode,
						 TransactionUoM, 
						 Location, 
						 TransactionQuantity, 
						 TransactionUoMMultiplier,
					     TransactionCostPrice, 
						 TransactionReference,
						 Remarks, 						
						 PersonNo,
						 SalesPrice,					 
						 <cfif operational eq 1>
						 	GLAccountDebit, 
						 	GLAccountCredit, 
						 </cfif>
						 OfficerUserId,
						 Created)
				VALUES (
					   '#form.Transactionid#',
					   '#form.tratpe#',
					   #dte#,
					   '#form.ItemNo#',
					   '#Item.ItemDescription#',
					   '#Item.Category#',
					   '#form.Mission#',
					   '#form.ProgramCode#',
					   '#form.Warehouse#',   
					   '#form.BillingMode#',    
					   '#form.UOM#',
					   		'#loc#',
					        '#qty#',
					   '#ItemUoM.UoMMultiplier#',
					   '#ItemUoM.StandardCost#',
					   '#Form.TransactionReference#',
					   '#form.Remarks#',				   
					   '#form.PersonNo#',
					   '#prc#',			  
					   <cfif operational eq 1>
					   	   '#debit#',
						   '#credit#',
					   </cfif>
					   '#SESSION.acc#',
					   getDate()
					   )		  
				</cfquery>		
			
				<!--- transfer TO --->
				
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
						 ProgramCode,
						 Warehouse, 
						 BillingMode,
						 TransactionUoM, 
						 Location, 
						 LocationTransfer,
						 TransactionQuantity, 
						 TransactionUoMMultiplier,
					     TransactionCostPrice, 
						 TransactionReference,
						 Remarks, 						
						 PersonNo,
						 SalesPrice,					 
						 <cfif operational eq 1>
						 	GLAccountDebit, 
						 	GLAccountCredit, 
						 </cfif>
						 Created)
				VALUES (
					   '#rowguid#',
					   '#form.tratpe#',
					   #dte#,
					   '#form.ItemNo#',
					   '#Item.ItemDescription#',
					   '#Item.Category#',
					   '#form.Mission#',
					   '#form.ProgramCode#',
					   '#form.Warehouse#',    
					   '#form.Billingmode#',   
					   '#form.UOM#',
					   '#Form.ToLocation#',
					   '#loc#',
					   '#add#',
					   '#ItemUoM.UoMMultiplier#',
					   '#ItemUoM.StandardCost#',
					   '#Form.TransactionReference#',
					   '#form.Remarks#',				   
					   '#form.personno#',
					   '#prc#',			  
					   <cfif operational eq 1>
					   	   '#debit#',
						   '#credit#',
					   </cfif>
					   getDate()
					   )		  
				</cfquery>
			
			</cfif>	
	
	</cfif>
	
</cfloop>

<cfset url.location = loc>
<cfset url.itemno   = form.ItemNo>
<cfset url.uom      = form.UoM>
<cfset url.tratpe   = form.tratpe>

<!--- refresh the inout portion for asset, quantity, metric --->

<cf_assignid>

<cf_tl id="Add Line" var="1">	

<script>
    
	$("#assetbox").fadeIn();
	ColdFusion.navigate('../Transaction/getAsset.cfm?mission=<cfoutput>#form.Mission#</cfoutput>','assetbox')
	document.getElementById('assetselect').value             = ''
	$("#personbox").fadeIn();
	ColdFusion.navigate('../Transaction/getPerson.cfm?mission=<cfoutput>#form.Mission#</cfoutput>','personbox')
	document.getElementById('personselect').value            = ''	
		
	document.getElementById('transactionquantity').value     = ''	
	if (document.getElementById('transactionreference')) {
	  document.getElementById('transactionreference').value    = ''
	  document.getElementById('transactionreference').focus() 		
	} else {
	   document.getElementById('assetselect').focus() 		
	}
    document.getElementById('transactionid').value           = '<cfoutput>#rowguid#</cfoutput>'
	document.getElementById('remarks').value                 = ''
    document.getElementById('addbutton').value               = '<cfoutput>#lt_text#</cfoutput>'
</script>   

<!--- show the detail lines --->

<cfset url.transactionid = Transactionid>

<cfinclude template="TransactionDetailLines.cfm">

	