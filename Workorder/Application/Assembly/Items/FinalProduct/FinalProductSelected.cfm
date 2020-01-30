
<!--- selected items --->

<cfquery name="selecteditems" 
	datasource="AppsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT *
		FROM   userTransaction.dbo.FinalProduct_#session.acc# S, Materials.dbo.Item I
		WHERE  WorkOrderId    = '#url.workorderId#'	
		AND    WorkOrderLine  = '#url.workorderLine#'		
		AND    I.ItemNo = S.ItemNo
		AND    Quantity > 0 and Quantity is not NULL
		AND    Price > 0 
		AND    Price IS NOT NULL
</cfquery>

<table width="100%">

	<tr><td height="4"></td></tr>
	<tr><td bgcolor="eeeeee" class="labelmedium" style="border:0px solid gray;height:30px;padding-left:14px;color:black"><cf_tl id="Selected Items"></td></tr>
	<tr><td bgcolor="white" style="border:0px solid silver;padding:5px">
		
	<cfif selecteditems.recordcount gte "0">
	
	<cf_divscroll height="150">
	
		<table width="98%" class="navigation_table">				
		
		<cfoutput query="SelectedItems">
			<tr class="labelmedium navigation_row line" style="height:20px">
			  <td style="width:10px"></td>
			  <td style="width:20px" style="padding-top:1px"><cf_img icon="delete" onclick="deleteSelected('#WorkorderItemId#')"></td>
			  <td>#ItemDescription#</td>
			  <td>#Class1ListValue#</td>
			  <td>#Class2ListValue#</td>
			  <td>#Class3ListValue#</td>
			  <td>#Class4ListValue#</td>
			  <td>#Class5ListValue#</td>
			  <td>#Class6ListValue#</td>
			  <td>#Memo#</td>
			  <td align="right">#Quantity#</td>
			  <td>#Currency#</td>
			  <td align="right" style="padding-right:5px">#numberformat(Price,",__.__")#</td>  
			</tr>
		</cfoutput>
		<cfif selecteditems.recordcount lte 7>
		<cfloop index="itm" from="1" to="#7-selecteditems.recordcount#">
		<tr class="labelit navigation_row line"><td colspan="13"></td></tr>
		</cfloop>
		</cfif>
			
		</table>
		
		</cf_divscroll>
		
		</td>
		</tr>
			
		<cfif selecteditems.recordcount gte "1">
			
			<tr><td class="line"></td></tr>
			<tr><td align="center" style="height:40px;padding-top:4px">
				<cfoutput>
				    <cf_tl id="Apply Finished Product" var="label">
					<input type="button" name="Submit" value="#label#" style="border-radius:3px;width:220;height:28px" class="button10g" 
					onclick="submitTransactions('#url.workorderId#','#url.workorderLine#')">
				</cfoutput>	
			
			</td></tr>
		
		</cfif>
	
	</cfif>

	</td></tr>

</table>

<cfset AjaxOnLoad("doHighlight")>