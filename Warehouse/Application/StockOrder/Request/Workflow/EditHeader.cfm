<cfquery name="Header" 
    datasource="AppsMaterials" 
    username="#SESSION.login#" 
    password="#SESSION.dbpw#">	
	SELECT RequestHeaderId, Mission, DateDue, RequestShipToMode, Category, Remarks
	FROM   RequestHeader 
	WHERE  RequestHeaderId = '#object.ObjectkeyValue4#'
</cfquery>

<cfoutput>


	<table align="left" width="100%">
	
		<cfform name="editHeaderForm">
	
		<tr>
		<td height="22px" style="padding-left:6px" class="label"><cf_tl id="Delivery Date">:</td>
		<td style="padding-left:10px"> 
			<cf_intelliCalendarDate9 FieldName="DateDue" Manual="True" Default="#dateformat(Header.DateDue,CLIENT.DateFormatShow)#" AllowBlank="False"> 
		</td>
		</tr>
	
		<tr>
		<td height="22px" style="padding-left:6px" class="label"><cf_tl id="Shipping Mode">:</td>
		<td style="padding-left:10px">
		
		<cfinput type="hidden" value="#Header.RequestHeaderId#" id="headerId" name="headerId">
		
		<cfquery name="ShippingMode" 
				datasource="AppsMaterials" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
					SELECT   * 
					FROM     Ref_ShipToMode 	
					ORDER BY ListingOrder				
										
		</cfquery>
		
		<cfselect name="shiptomode" id="shiptomode" style="font:10px;width:190">
			   
				<cfloop query="ShippingMode">
					<option value="#Code#" <cfif Header.RequestShipToMode eq Code>selected</cfif>>#Description#</option>
				</cfloop>					 
				
		</cfselect>	
			   
		</td>
		</tr>
		<tr>
			<td height="22px" style="padding-left:6px" class="label"><cf_tl id="Usage">:</td>					
			<td style="padding-left:10px"> 	
			
			<!--- check categories that have supplies defined --->
			
			<cfquery name="Category" 
				datasource="AppsMaterials" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				SELECT *
				FROM   Ref_Category
				WHERE  Category IN ( 
								      SELECT DISTINCT I.Category 
	                                  FROM   AssetItem AI, Item I
									  WHERE  AI.ItemNo = I.ItemNo
									  AND    AI.Mission = '#Header.Mission#'
									  AND    AI.AssetId IN (SELECT DISTINCT AssetId 
										                    FROM   AssetItemSupply P																			   
															WHERE  AI.Assetid = P.Assetid)
									)					
			</cfquery>	
										
			<cfselect name="category" id="category" style="font:10px;width:280">
			   
				<cfloop query="Category">
					<option value="#Category#" <cfif Header.Category eq Category >selected</cfif>>#Description#</option>
				</cfloop>
				 <option value="">--- any of the above ---</option>
			</cfselect>	
			
			</td>
		</tr>			
				
		<tr>
				<td height="22px" style="padding-left:6px" class="label"><cf_tl id="Remarks">:</td>
				<td style="padding-left:10px" >
				
				   <textarea type="text" name="Remarks" id="Remarks" onkeyup="return ismaxlength(this)"	
			    style="padding-left:4px;color:6688aa;width:98%;height:36" class="regular" totlength="200">#Header.Remarks#</textarea>
		
				</td>
		</tr>
		
		</cfform>
		
		<tr>
			<td align="center" colspan="2" style="padding-top:15px">
				<cf_button  type="button" 
						    name="update" 
							id="update" 
							value="Update" 
							onClick="ColdFusion.navigate('#SESSION.root#/Warehouse/Application/StockOrder/Request/Workflow/EditHeaderSubmit.cfm','div_submit','','','POST','editHeaderForm')"
							class="button10s">
			</td>
		</tr>
				
		<tr>
			<td align="center" colspan="2" style="padding-top:15px">
				<div id="div_submit"></div>
			</td>
		</tr>
				
	</table>


</cfoutput>

<cfset AjaxOnLoad('doCalendar')>