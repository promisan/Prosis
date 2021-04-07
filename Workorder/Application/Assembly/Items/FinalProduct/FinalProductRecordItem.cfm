
<!--- final production lines --->

<cfquery name="WorkOrder" 
	datasource="AppsWorkOrder" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT  *
		FROM    WorkOrder
		WHERE   WorkorderId = '#url.WorkOrderId#'		
</cfquery>	 

<cfquery name="getItem" 
	datasource="AppsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT  *
		FROM    Item
		WHERE   ItemNo = '#url.ItemNo#'		
</cfquery>	 	

<cfquery name="getTopics" 
	      datasource="AppsMaterials"
		  username="#SESSION.login#" 
		  password="#SESSION.dbpw#">
		  SELECT   *
		  FROM     Ref_Topic T, Ref_TopicEntryClass C
		  WHERE    T.Code = C.Code
		  AND      EntryClass IN (SELECT EntryClass 
		                          FROM   Purchase.dbo.ItemMaster 
								  WHERE  Code = '#getItem.ItemMaster#')
		  AND      T.Operational = 1
		  AND      ValueClass IN ('List','Lookup')
		  ORDER BY ListingOrder
</cfquery>

<cfset select = "">
<cfset body   = "">	
<cfset order  = "">
		
<cfoutput query="getTopics">
	
	<cfparam name="Form.Topic_#Code#" default="''">
	
	<cfset val = evaluate("Form.Topic_#Code#")>
	
	<cfif valueClass eq "List">
	
	<cfif select eq "">
	    <cfset select = "#Code#.Class as #Code#, #Code#.ListCode as #Code#ListCode, #Code#.ListValue as #Code#ListValue,#Code#.ListOrder as #Code#ListOrder">
		<cfset body   = "(SELECT '#code#' AS Class, ListCode, ListValue, ListOrder FROM Ref_TopicList WHERE Code = '#code#' AND ListCode IN (#preservesingleQuotes(val)#)) AS #code#">
		<cfset order  = "#Code#ListOrder">
			
	<cfelse>
		<cfset select = "#select#, #Code#.Class as #Code#, #Code#.ListCode as #Code#ListCode, #Code#.ListValue as #Code#ListValue , #Code#.ListOrder as #Code#ListOrder">
		<cfset body   = "#body# CROSS JOIN (SELECT '#code#' AS Class, ListCode, ListValue, ListOrder FROM Ref_TopicList WHERE Code = '#code#' AND ListCode IN (#preservesingleQuotes(val)#)) AS #code#">	
		<cfset order  = "#order#,#Code#ListOrder">
	</cfif>	
	
	<cfelseif valueClass eq "Lookup">
	
		 <CF_DropTable dbName="AppsQuery" tblName="#session.acc#_TopicList_#code#">	
		
		 <cfquery name="GetList" 
		  datasource="#ListDataSource#" 
		  username="#SESSION.login#" 
		  password="#SESSION.dbpw#">
	
			 SELECT   DISTINCT 
			          #ListPK# as ListCode, 
			          #ListDisplay# as ListValue,
					  #ListOrder# as ListOrder
			 INTO     UserQuery.dbo.#session.acc#_TopicList_#code#		   
			 FROM     #ListTable# T		  		  
			 WHERE    #PreserveSingleQuotes(ListCondition)#		
			 ORDER BY #ListOrder# 
	
		</cfquery>
			
		<cfif select eq "">
		    <cfset select = "#Code#.Class as #Code#, #Code#.ListCode as #Code#ListCode, #Code#.ListValue as #Code#ListValue, #Code#.ListOrder as #Code#ListOrder">
			<cfset body   = "(SELECT '#code#' AS Class, ListCode, ListValue, ListOrder FROM UserQuery.dbo.#session.acc#_TopicList_#code# WHERE ListCode IN (#preservesingleQuotes(val)#)) AS #code#">
			<cfset order  = "#Code#ListOrder">
				
		<cfelse>
			<cfset select = "#select#, #Code#.Class as #Code#, #Code#.ListCode as #Code#ListCode, #Code#.ListValue as #Code#ListValue, #Code#.ListOrder as #Code#ListOrder">
			<cfset body   = "#body# CROSS JOIN (SELECT '#code#' AS Class, ListCode, ListValue, ListOrder FROM UserQuery.dbo.#session.acc#_TopicList_#code# WHERE ListCode IN (#preservesingleQuotes(val)#)) AS #code#">	
			<cfset order  = "#order#,#Code#ListOrder">
		</cfif>	
		
	</cfif>

</cfoutput>	

<!--- retrieve which topics is reflecting the UoM --->
<cfquery name="getTopicsUoM" dbtype="query">
	  SELECT *
	  FROM   getTopics
	  WHERE  ItemPointer = 'UoM'
</cfquery>

<!--- populate the items in the temp table as a basis --->

<cftry>

<cfquery name="Items" 
	datasource="AppsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT   newid() as WorkOrderItemId, 
		         #preservesingleQuotes(select)#
		FROM     #preservesingleQuotes(body)#	
		ORDER BY #preservesingleQuotes(order)#				
</cfquery>

<cfoutput query="Items">

	<cfset topicuom = evaluate("Items.#getTopicsUoM.Code#ListCode")>
	
	<!--- we need to check if this is a valid UoM for this Item --->
		
	<cfquery name="getUoM" 
	datasource="AppsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT  *
		FROM    ItemUoM
		WHERE   ItemNo  = '#url.ItemNo#'		
		AND     UoMCode = '#topicuom#'
	</cfquery>	 	
	
	<cfif getUoM.recordcount eq "1">
		<cfset setUOM = getUoM.UoM>
	<cfelse>
	    <cfset setUOM = url.uom>
	</cfif>
			
	<cfquery name="check" 
		datasource="AppsMaterials" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT  * 
			FROM   userTransaction.dbo.FinalProduct_#session.acc#
			WHERE  WorkOrderId   = '#url.workorderid#'
			AND    WorkOrderLine = '#url.workorderline#'
			AND    ItemNo        = '#url.ItemNo#'
			AND    UoM           = '#setUoM#'
			<cfloop query="getTopics">
			AND    Class#currentrow# = '#code#'		
			<cfset val = evaluate("Items.#Code#ListCode")>		
			AND    Class#currentrow#ListCode = '#val#'
			</cfloop>
	</cfquery>	
	
			
	<cfif check.recordcount eq "0">
	
		<cfquery name="add" 
			datasource="AppsMaterials" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			    INSERT INTO userTransaction.dbo.FinalProduct_#session.acc#
				(WorkOrderId, WorkOrderLine,Category,ItemNo,UoM,		
				<cfloop query="getTopics">
					Class#currentrow#,Class#currentrow#ListCode,Class#currentrow#ListValue, 					
				</cfloop>
				WorkOrderItemId)
				
				VALUES
				
				('#url.workorderid#',
				 '#url.workorderline#',		
				 '#GetItem.Category#',
				 '#GetItem.ItemNo#',	
				 '#setUoM#',				
				 <cfloop query="getTopics">
				  '#code#',		
				  <cfset val = evaluate("Items.#Code#ListCode")>		
				  '#val#',
				  <cfset val = evaluate("Items.#Code#ListValue")>		
				  '#val#',
				</cfloop>
				'#workorderitemid#')
		</cfquery>
			
	<cfelse>
	
		<cfquery name="update" 
		datasource="AppsMaterials" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			UPDATE userTransaction.dbo.FinalProduct_#session.acc#
			SET    WorkOrderItemId = '#workorderitemid#'
			WHERE  WorkOrderId     = '#url.workorderid#'
			AND    WorkOrderLine   = '#url.workorderline#'
			AND    ItemNo          = '#GetItem.ItemNo#'
			AND    UoM             = '#setUoM#'			
			<cfloop query="getTopics">
			AND    Class#currentrow# = '#code#'		
			<cfset val = evaluate("Items.#Code#ListCode")>		
			AND    Class#currentrow#ListCode = '#val#'
			</cfloop>
	</cfquery>	
	
	</cfif>

</cfoutput>

<cfcatch>

<cfabort>

</cfcatch>

</cftry>

<cfquery name="GetCurrency" 
	datasource="AppsLedger" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT  *
	FROM    Currency
	WHERE	EnableProcurement = 1
	AND		Operational = 1
</cfquery>

<cfset cols = getTopics.recordcount+7>

<cfform name="frmFinalProduct" method="post" 
	  target="processFinalProduct" 
	  action="FinalProductEditSubmit.cfm?workorderid=#url.workOrderId#&workorderline=#url.workorderline#">
		
<table width="100%" class="formspacing">

	<tr><td height="6"></td></tr>

	<tr>
	  
	   <cfoutput query="getTopics">
	   <td class="labelit line">#TopicLabel#</td>
	   </cfoutput>
	   <td align="right" class="labelit line"><cf_tl id="On Hand"><cf_space spaces="23"></td>
	   <td align="right" class="labelit line"><cf_tl id="Type"></td>	   
	   <td align="right" class="labelit line"><cf_tl id="Quantity"></td>  
	   <td align="right" class="labelit line"><cf_tl id="Price"><cfoutput>#workorder.Currency#</cfoutput></td>		  
	    <td></td>
	   <td></td>	   
	</tr>
	
	<tr><td class="line" colspan="<cfoutput>#cols#</cfoutput>"></td></tr>
	
	<cfoutput query="items">
	
		<!--- define the current values --->
		
		<cfquery name="getValues" 
		datasource="AppsMaterials" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT * 
			FROM   userTransaction.dbo.FinalProduct_#session.acc#
			WHERE  WorkOrderItemId = '#workorderitemid#'			
		</cfquery>	
		
		<!--- determine if the item has an occurence already in the database of items 
		hereto we get the classifiers and we get the UoM 
		--->
		
		<cfset matcheditems = "(SELECT ItemNo FROM Item WHERE ParentItemNo = '#getValues.ItemNo#')">
		
		<cfloop query="getTopics">
		
			    <cfif ItemPointer neq "UoM">				

					<cfif matcheditems neq "">
						<cfquery name="checkClassifier" 
						datasource="AppsMaterials" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">		
							SELECT  ItemNo		
							FROM    ItemClassification
							WHERE   
							ItemNo IN (#preservesingleQuotes(matcheditems)#)		
							AND
							Topic    = '#Code#'
							AND     ListCode = '#evaluate("Items.#Code#ListCode")#'																	
						</cfquery>	
						
						<cfif checkClassifier.recordcount neq 0>
							<cfset matcheditems = quotedvalueList(checkClassifier.ItemNo)>
						<cfelse>
							<cfset matcheditems = "">		
						</cfif>	
					</cfif>
					
				</cfif>
				
		</cfloop>	
		
		<cfquery name="potentialItems" 
			datasource="AppsMaterials" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">		
			SELECT  *
			FROM    Item
			<cfif matcheditems eq "">	
			WHERE   1=0
			<cfelse>
			WHERE   ItemNo IN (#preservesingleQuotes(matcheditems)#)																	
			</cfif>
		</cfquery>			
				
		<cfset found = "No">	
										
		<cfloop query="potentialItems">
				
				<cfquery name="getUoM" 
				datasource="AppsMaterials" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
					SELECT   *
					FROM      ItemUoM
					WHERE     ItemNo = '#ItemNo#'
					<cfloop query="getTopics">
					    <cfif ItemPointer eq "UoM">
						AND UoMCode = '#evaluate("Items.#Code#ListCode")#'
						</cfif>
					</cfloop>								
				</cfquery>		
												
				<cfif getUoM.recordcount gte "1">
				
						<cfset found = "yes">
						
						<cfquery name="update" 
							datasource="AppsMaterials" 
							username="#SESSION.login#" 
							password="#SESSION.dbpw#">
							UPDATE userTransaction.dbo.FinalProduct_#session.acc#
							SET    ItemUoMIdFinalProduct = '#getUoM.ItemUoMId#'
							WHERE  WorkOrderId    = '#url.workorderid#'
							AND    WorkOrderLine  = '#url.workorderline#'
							AND    ItemNo         = '#ItemNo#'
							AND    UoM            = '#UoM#'
							<cfloop query="getTopics">
							AND    Class#currentrow# = '#code#'		
							<cfset val = evaluate("Items.#Code#ListCode")>		
							AND    Class#currentrow#ListCode = '#val#'
							</cfloop>
						</cfquery>	
									
				</cfif>	
			
		</cfloop>				
				
		<cfif getValues.Price neq "">
		
			<!--- we take the entered value --->
		
			<cfset price = getValues.Price>
								
		<cfelse>
		
		    <!--- --------------------------------------- --->
			<!--- determining the price for this customer --->
						
			<cfquery name="getSchedule" 
			datasource="AppsWorkOrder" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				SELECT   TOP 1 *
				FROM     CustomerSchedule
				WHERE    CustomerId = '#workorder.customerid#' 
				AND      Category   = '#getItem.Category#' 
				AND      DateEffective <= GETDATE()
				ORDER BY DateEffective DESC				
			</cfquery>	
						
			<cfif getSchedule.recordcount eq "0">
			
				<cfquery name="getSchedule" 
				datasource="AppsWorkOrder" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
					SELECT   TOP 1 *
					FROM     CustomerSchedule
					WHERE    CustomerId = '#workorder.customerid#' 				
					AND      DateEffective <= GETDATE()
					ORDER BY DateEffective DESC 
				</cfquery>	
							
			</cfif>
														
			<cfif getSchedule.recordcount eq "0" or found eq "No">			
						
				<cfset price = "0">
			
			<cfelse>
							
				<cfquery name="getItemUoM" 
				datasource="AppsWorkOrder" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
					SELECT * 
					FROM   Materials.dbo.ItemUoM
					WHERE  ItemUoMId = '#getUoM.ItemUoMId#'
				</cfquery>
									
				<cfif getSchedule.PriceMode eq "L">

					<!--- get the last price for this item which is found --->
					
					<cfquery name="getLastPrice" 
						datasource="AppsWorkOrder" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">
												
						SELECT  W.*
						FROM    WorkOrderLineItem W, Materials.dbo.ItemUoM U
						WHERE   W.ItemNo = U.ItemNo
						AND     W.UoM    = U.UoM
						AND     U.ItemUoMId = '#getUoM.ItemUoMId#'					
						AND     WorkOrderId IN (SELECT  WorkOrderId
					                            FROM    WorkOrder
	                			                WHERE   CustomerId = '#workorder.customerid#'
												AND     Currency   = '#workorder.currency#')
						<!--- not the current workorder --->						
						AND     WorkOrderId != 	'#workorder.workorderid#'
						ORDER BY W.Created DESC
					</cfquery>	
					
					<cfif getLastPrice.recordcount eq "0">
					
							<cfset price = "0.00">
							
					<cfelse>
					
							<cfset price = getLastPrice.SalePrice>
					
					</cfif>				
			
				<cfelse>												
										
					<cfinvoke component = "Service.Process.Materials.POS"  
					   method           = "getPrice" 
					   mission          = "#workorder.mission#" 
					   customerid       = "#workorder.customerid#"
					   currency         = "#workorder.currency#"
					   ItemNo           = "#getItemUoM.itemno#"
					   UoM              = "#getItemUoM.uom#"
					   quantity         = "1"
					   returnvariable   = "sale">					   				
				
					<cfset price = sale.price>
					
					<!--- get the price from the price schedule --->				
				
				</cfif>		
				
	

				<cfquery name="setPrice" 
				datasource="AppsMaterials" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
					UPDATE userTransaction.dbo.FinalProduct_#session.acc#
					SET    Price = '#price#'
					WHERE  WorkOrderItemId = '#workorderitemid#'			
				</cfquery>		
			
			</cfif>				
		
		</cfif>		
	
		<tr>
		
		<cfloop index="cde" list="#valueList(getTopics.code)#">
			<td class="labelit">#evaluate("#Cde#ListValue")#</td>
		</cfloop>		
		
		<td align="right" class="labelmedium" style="padding-right:4px">
		
		<cfif found eq "Yes">
		
			<cfif getUoM.ItemUoMId neq "">
			
				<cfquery name="onHand" 
					datasource="AppsMaterials" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
					SELECT   ISNULL(SUM(T.TransactionQuantity), 0) AS Quantity
					FROM     ItemTransaction T INNER JOIN
	                		 ItemUoM U ON T.ItemNo = U.ItemNo AND T.TransactionUoM = U.UoM
					WHERE    T.Mission     = '#WorkOrder.Mission#' 
					AND      U.ItemUoMId   = '#getUoM.ItemUoMId#'
				</cfquery>		
			
				<cfif OnHand.recordcount neq 0>
					#OnHand.Quantity#
				</cfif>	
				
			</cfif>	
			
		<cfelse>
		
			n/a	
		
		</cfif>
		
		</td>
		
		<td align="right">
						
		<cf_tl id="Standard"  var="vStandard">
		<cf_tl id="Promotion" var="vPromotion">
		<cf_tl id="Discount" var="vDiscount">
		
		<select id="Memo_#workorderitemid#" name="Memo_#workorderitemid#" class="regularxl enterastab"  onchange="_cf_loadingtexthtml='';ptoken.navigate('setItemValue.cfm?workorderid=#url.workorderid#&workorderline=#url.workorderline#&workorderitemid=#workorderitemid#&field=memo&value='+this.value,'process')">
		  <option value="Standard" selected>#vStandard#></option>
		  <option value="Promotion">#vPromotion#></option>
		  <option value="Discount">#vDiscount#</option>
		</select>		
		
		</td>
				
		<td width="90" align="right">
		
		  <cf_tl id="Please, enter a valid numeric quantity greater than 0." var="1">
		  
		  <cfinput type="text" class="regularxl enterastab" 
		           name="quantity" 
				   id="quantity_#workorderitemid#" 
				   onchange="_cf_loadingtexthtml='';ptoken.navigate('setItemValue.cfm?workorderid=#url.workorderid#&workorderline=#url.workorderline#&workorderitemid=#workorderitemid#&field=quantity&value='+this.value,'process')" 
				   value="#getValues.Quantity#" 
				   required="true" 
				   message="#lt_text#" 				   
				   validate="float" 
				   range="0.00000000001," 
				   style="width:100%; text-align:right; padding-right:2px;">				
				   
		</td>		
				
		<td width="100" align="right">
		
			  <table cellspacing="0" cellpadding="0">
				  <tr>				  
				  <td>
					<cf_tl id="Please, enter a valid numeric price greater than 0." var="1">
					
					<cfinput type  = "text" 
						onchange   = "_cf_loadingtexthtml='';ptoken.navigate('setItemValue.cfm?workorderid=#url.workorderid#&workorderline=#url.workorderline#&workorderitemid=#workorderitemid#&field=price&value='+this.value,'process')" 				 
						class      = "regularxl enterastab" 
						name       = "price" 
						id         = "price_#workorderitemid#" 
						value      = "#numberformat(price,",.__")#" 
						required   = "true" 
						message    = "#lt_text#" 
						validate   = "float" 
						range      = "0.0000001," 
						style      = "width:100%; text-align:right; padding-right:2px;">	
								
				  </td>				 				  
				  </tr>			  
			  </table>

		</td>
		
		<td style="padding-left:3px;padding-top:0px;padding-right:4px">
		<input type="radio" class="radioL" name="selected" 
		   value="#workorderitemid#" 
		   onchange= "_cf_loadingtexthtml='';ptoken.navigate('setItemValue.cfm?workorderid=#url.workorderid#&workorderline=#url.workorderline#&workorderitemid=#workorderitemid#&field=asDefault&value='+this.value,'process')">		
		</td>
		
		<td style="padding-top:1px;padding-right:1px" id="copy_#workorderitemid#">		
		<img src="#session.root#/images/copy.png" title="Inherit from selected line"
			onclick="ptoken.navigate('setItemValue.cfm?workorderid=#url.workorderid#&workorderline=#url.workorderline#&workorderitemid=#workorderitemid#&field=copy&value=#workorderitemid#','process');" style="cursor:pointer" alt="Copy" border="0">		
		</td>
			
		</tr>
		
	</cfoutput>
	
</table>

</cfform>

<script>
	Prosis.busy('no');
</script>