
<!--- get Quoted --->

<table width="100%" height="100%">

<tr><td style="padding:5px">

	<table width="100%" height="100%">
	
		<tr class="labelmedium2">
		  <td style="padding-left:10px;font-size:15px"><cf_tl id="Store"></td>
		  <td id="storebox">
		  		  
		<select id="warehousequote" name="warehousequote" style="width:100%;background-color:f5f5f5" class="regularxxl" 
		   onchange="setquote(document.getElementById('requestno').value,'warehouse')">		
		<cfoutput query="Warehouse">
	     	<option value="#Warehouse#">#WarehouseName#</option>
		</cfoutput>	
		</select>
		  
		  </td>
		</tr>
	
		<tr class="labelmedium2">
		  
		  <td style="height:40px" colspan="2" align="center">
		    <cfoutput>
		    <input type="button" name="Add" value="Add Quotation" style="width:96%" class="button10g" onclick="addquote()">
			<input type="hidden" id="requestno" value="">
			</cfoutput>
		  </td>
		</tr>
		
		<tr class="line"><td colspan="2" id="boxquote"></td></tr>		
				
		<tr><td colspan="2" valign="top" style="padding-left:5px;padding-right:5px;height:100%;background-color:fafafa">
		  <cf_divscroll id="boxlines"></cf_divscroll>			
		</td></tr>		
		<tr><td id="boxprocess"></td></tr>
		
		<tr>
		<td id="boxaction" colspan="2" align="center" style="height:40px;border-top:1px solid silver">
		
			<table class="formspacing">
				<tr>
					<td><input type="button" class="button10g"  style="width:120px" name="Quote"  value="Send Quote"></td>
					<td><input type="button" class="button10g"  style="width:120px" name="Order"  value="Sales Order"></td>
					<td><input type="button" class="button10g"  style="width:120px" name="POS"    value="to POS"></td>
				</tr>
			</table>	
		
		</td>
		</tr>
	
	</table>
	
</td></tr>
</table>	
