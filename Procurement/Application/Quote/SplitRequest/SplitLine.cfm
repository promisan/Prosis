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
<cfsilent>
	<proUsr>dev</proUsr>
	<proOwn>dev dev</proOwn>
	<proDes>Translated</proDes>
	<proCom></proCom>
</cfsilent>
<!--- End Prosis template framework --->

<script>

function base(ln) {
 
    x = document.getElementById('requestquantity_'+ln)
	y = document.getElementById('requestcostprice_'+ln)
	
	var s = " " + Math.round((x.value*y.value) * 100) / 100
	val(s,'requestamountbase_'+ln)	
}

function val(s,field) {

	z = document.getElementById(field)
	var i = s.indexOf('.')
	   if (i < 0) {
    	 z.value = s + ".00" ;
		  }
	else {
	    var t = s.substring(0, i + 1) + s.substring(i + 1, i + 3);
    	if (i + 2 == s.length) 
		   t += "0";
    	   z.value = t; 
	}

}

</script>

<cf_screentop height="100%" scroll="yes" user="No" label="Split Line #URL.ID#" layout="self" banner="silver" textColorLabel="black">

<!--- show master --->

<cfparam name="URL.ID" default="10273">

<cfquery name="Line" 
datasource="AppsPurchase" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
    FROM RequisitionLine
	WHERE RequisitionNo = '#URL.ID#'
</cfquery>

<cfquery name="UoM" 
datasource="AppsPurchase" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
    FROM Ref_UoM
</cfquery>

<table width="100%" height="100%" class="formpadding">

<tr><td valign="top" style="padding-top:10px;padding-left:26px;padding-right:26px">

<cfform action="SplitLineSubmit.cfm?ID=#URL.ID#" method="POST" target="result">

<table width="100%" class="formpadding">

<tr class="hide"><td><iframe name="result" id="result"></iframe></td></tr>

<cfoutput query="Line">

<tr class="labelmedium2 line">
   <td width="20" height="20"></td>
   <td><cf_tl id="Description"></td>
   <td><cf_tl id="Qty"></td>
   <td><cf_tl id="Uom"></td>
   <td align="right"><cf_tl id="Price"></td>
   <td align="right"><cf_tl id="Total"></td>
</tr>

<tr  class="labelmedium2 line">
   <td></td>
   <td>#RequestDescription#</td>
   <td>#RequestQuantity#</td>
   <td>#QuantityUoM#</td>
   <td align="right">#NumberFormat(RequestCostPrice,",.__")#</td>
   <td align="right">#NumberFormat(RequestAmountBase,",.__")#</td>   
</tr>

</cfoutput>

	<cfoutput>
	
		<input type="hidden" name="row" id="row" value="14">
		<cfloop index="ln" from="1" to="14">
		
		<tr class="labelit">
		   <td align="center">#ln#</td>
		   <td>
		   	<input type="text" class="regularxl" name="requestdescription_#ln#" id="requestdescription_#ln#" style="width:99%" maxlength="200">
		   </td>
		   <td>
		     <cfinput type="Text" class="regularxl" name="requestquantity_#ln#" value="" message="Enter a valid quantity" validate="float" required="No" size="4" style="text-align: right;" onChange="javascript:base('#ln#')">
		   </td>
		   <td>
		   <select name="requestuom_#ln#" id="requestuom_#ln#" size="1" class="regularxl">
		    <cfloop query="UoM">
				<option value="#Code#">#Description#</option>
			</cfloop>
		    </select>
		   </td>
		   <td>
		     <cfinput type="Text" 
			        name="requestcostprice_#ln#" 
					value=""
					class="regularxl"
					message="Enter a Valid Price" 
					validate="float"
					required="No" size="10" style="text-align: right;" onChange="javascript:base('#ln#')">
		   </td>
		    <td>
		      <input type="text" class="regularxl" name="requestamountbase_#ln#" id="requestamountbase_#ln#" size="10" maxlength="12" readonly style="text-align: right;">
		   </td>
		   
		</tr>	
		
		</cfloop>	
	
		<cf_tl id="Reset" var="1">
		<cfset vReset=#lt_text#>
		
		<cf_tl id="Save"  var="1">
		<cfset vSubmit=#lt_text#>
	
		<cf_tl id="Close" var="1">
		<cfset vClose=#lt_text#>
					
		<tr><td height="1" colspan="6" align="center" style="padding-top:10px">
			
			<input	
				value  = " #vSubmit#" 
				type   = "submit"				
				id     = "submit"					
				class  = "button10g" 
				style  = "width:190px;height:27px">   
			
		</td></tr>
		
	</cfoutput>	
	

</table>

</cfform>

</td></tr>

</table>

<cf_screenbottom layout="webapp">

