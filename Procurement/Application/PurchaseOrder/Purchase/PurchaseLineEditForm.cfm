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
<cfquery name="Line" 
datasource="AppsPurchase" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT L.*, P.Mission, P.PersonNo, P.OrgUnit, P.OrderClass
    FROM   PurchaseLine L, Purchase P
	WHERE  L.RequisitionNo = '#URL.ID#'
	AND    L.PurchaseNo = P.PurchaseNo
</cfquery>

<cfquery name="Receipts" 
datasource="AppsPurchase" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
    FROM   PurchaseLineReceipt L
	WHERE  L.RequisitionNo = '#URL.ID#'
	AND    ActionStatus != '9'
	AND    ActionStatus >= '1'
</cfquery>

<cfquery name="Parameter1" 
	datasource="AppsPurchase" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
    SELECT *
    FROM   Ref_ParameterMission
	WHERE  Mission = '#Line.Mission#' 
</cfquery>

<cfquery name="Request" 
  datasource="AppsPurchase" 
  username="#SESSION.login#" 
  password="#SESSION.dbpw#">
    SELECT   L.*, R.EntryClass, R.Description as ItemMaster
    FROM     RequisitionLine L, ItemMaster R
	WHERE    L.ItemMaster = R.Code
	AND      RequisitionNo = '#Line.RequisitionNo#' 
</cfquery>		
	
<cfquery name="EntryClass" 
  datasource="AppsPurchase" 
  username="#SESSION.login#" 
  password="#SESSION.dbpw#">
    SELECT *
    FROM   Ref_EntryClass
	WHERE  Code = '#Request.EntryClass#' 
</cfquery>		

<cfquery name="Travel" 
datasource="AppsPurchase" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
    FROM RequisitionLineItinerary
	WHERE RequisitionNo = '#Line.RequisitionNo#'
</cfquery>

<cfquery name="Currency" 
datasource="AppsLedger" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
    FROM   Currency
	WHERE  EnableProcurement = 1
</cfquery>

<cfquery name="UoM" 
datasource="AppsPurchase" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
    FROM Ref_UoM
</cfquery>

<cfparam name="Status" default="1">

<table>
<tr><td>

<cfform action="PurchaseLineEditSubmit.cfm?ID=#URL.ID#" onsubmit="return false" method="POST" name="entry" target="result">

    <!--- precalc --->
	
	<cfif Line.recordcount eq "0">
	
		 <cfset qty   = 1>
		 <cfset prc   = 0>
		 <cfset dis   = 0>
		 <cfset txu   = Parameter1.TaxDefault*100>
		 		 		 
		 <cfif Parameter1.TaxIncluded eq "1">
			 <cfset txi   = "1">		
		 <cfelse>
			 <cfset txi   = "0">		
		 </cfif>
		 
		 <cfif Parameter1.TaxExemption eq "1">
			 <cfset exm   = "1">
		 <cfelse>
			 <cfset exm   = "0">
		 </cfif>		 
		
		 <cfset exch  = "1">
		 <cfset curr  = "#APPLICATION.BaseCurrency#">
		
		 <cfset amt   = 0>
		 <cfset damt  = 0>
		 <cfset cost  = 0>
		 <cfset costB = 0>
		 <cfset tax   = 0>
		 <cfset taxB  = 0>
		 <cfset pay   = 0>
		 <cfset payB  = 0>
		
	<cfelse>
			
	 <cfset qty  = Line.OrderQuantity>
	 <cfset prc  = Line.OrderPrice>
	 <cfset dis  = Line.OrderDiscount*100>
	 <cfset txu  = Line.OrderTax*100>
	 
	
	 <cfset exch = Line.ExchangeRate>
	 <cfset curr = Line.Currency>
	 
	 <cfset exm  = Line.TaxExemption>
	 	
	 <cfset amt  = Line.OrderPrice*Line.OrderQuantity>
	 <cfset damt = Line.OrderPrice*Line.OrderQuantity*((100-dis)/100)>
	 
	 <cfif damt eq Line.OrderAmountCost>
	  	<cfset txi = "0">
	 <cfelse>
	  	<cfset txi = Line.TaxIncluded>	
	 </cfif>
	 	 
	 <cfif txi eq "1">
	 	<cfset cost = damt*(100/(100+txu))>
		<cfset tax  = damt*(txu/(100+txu))>
	 <cfelse>
	  	<cfset cost = damt>
		<cfset tax  = damt*(Line.OrderTax)>
	 </cfif>
	 	 
	 <cfif exch eq 0>
	 	<cfset costB = cost>
	 	<cfset taxb  = tax>
	 <cfelse>
	 	<cfset costB = cost/exch>
	 	<cfset taxb  = tax/exch>
	 </cfif>
	 
	 <cfif Line.TaxExemption eq "1" or tax eq "">
		 <cfset pay   = cost>
		 <cfset payB  = costB>		
	 <cfelse>
	 	 <cfset pay   = cost+tax>
		 <cfset payB  = costB+taxB>			
	 </cfif>		 
		
	</cfif>
		
	<table width="98%" align="center" class="formpadding">
			
	<cfif Travel.recordcount gte "1">
	
		<tr class="hide"><td id="saving"></td></tr>
	
		<TR>
	    <TD class="labelmedium" width="140"><cf_tl id="Item No">:</TD>
	    <TD>
			
		  <input type = "Text" 
			   class      = "regularxl" 
			   name       = "OrderItemNo" 
	           id         = "OrderItemNo"
			   value      = "<cfoutput>#Line.OrderItemNo#</cfoutput>" 
			   onchange   = "ptoken.navigate('PurchaseLineEditTravel.cfm?id=<cfoutput>#url.id#</cfoutput>','saving','','','POST','entry')"
			   size       = "20" 
			   maxlength  = "20">
					
		</TD>
		</TR>
				
		<TR>
	        <td valign="top" class="labelmedium"><cf_tl id="Description">:</td>
	        <TD><textarea cols="60" rows="3" style="padding:3px;font-size:14px" name="OrderItem" class="regular"
			  onchange="ptoken.navigate('PurchaseLineEditTravel.cfm?id=<cfoutput>#url.id#</cfoutput>','saving','','','POST','entry')"><cfoutput>#Line.OrderItem#</cfoutput></textarea> </TD>
		</TR>
			
		<!--- travel provision --->		
		<cfinclude template="../Travel/TravelScript.cfm">
		<tr><td id="iservice" colspan="2">
		<cfinclude template="../Travel/TravelItem.cfm">
		</td></tr>
		
	<cfelse>
	
		<tr><td colspan="2" class="line"></td></tr>
	
		<tr><td class="labelmedium"><cf_tl id="Requested Item">:</td>
		<td height="22" class="labelmedium"><cfoutput>#EntryClass.Description# / #Request.ItemMaster#</cfoutput></td>
		</tr>
		
		<TR>
		    <TD width="140" class="labelmedium"><cf_tl id="Item No">:</TD>
		    <TD>
			<table><tr>
			<td>
			<input type="Text" class="regularxl" name="OrderItemNo" id="OrderItemNo" value="<cfoutput>#Line.OrderItemNo#</cfoutput>" size="20" maxlength="20">
			</TD>
		    <TD style="padding-left:10px" width="140" class="labelmedium"><cf_tl id="Sort">:</TD>
		    <TD><cfinput type="Text" validate="integer" required="Yes" style="text-align:center" class="regularxl" name="ListingOrder" value="#Line.ListingOrder#" size="2" maxlength="20"></TD>				
			</tr>
			</table>
			</td>
			
			
		</TR>
				
		<TR>
	        <td valign="top" style="padding-top:3px" class="labelmedium"><cf_tl id="Description">:</td>
	        <td><textarea rows="2" name="OrderItem" class="regular" style="width:98%;font-size:13px;padding:3px"><cfoutput>#Line.OrderItem#</cfoutput></textarea></td>
		</TR>
		
		<TR>
	    <TD width="140" class="labelmedium"><cf_tl id="LineReference">:</TD>
	    <TD>			
		  <input type="Text" class="regularxl" name="LineReference" id="LineReference" value="<cfoutput>#Line.LineReference#</cfoutput>" size="20" maxlength="20">				
		</TD>
		</TR>
			
		<TR>
	    <TD class="labelmedium"><cf_tl id="Quantity">:</TD>
	    <TD>
		  <table>
		  
		  <tr><td>
		
		   	  <cfinput type="Text" 
			  	name="orderquantity" 
				id="orderquantity" 
				value="#qty#" 
			  	message="Enter a valid quantity" 
			  	validate="float" 
				required="Yes" 
				class="regularxl" 
				size="4" 
				style="text-align: right;" 
			    onChange="calc(this.value,orderprice.value,extprice.value,orderdiscount.value,ordertax.value,taxincl.value,exchangerate.value,taxexemption.value);whs(ordermultiplier.value,this.value)">
			    </td>
				
				<td style="padding-left:3px">
				
				<cfoutput>
				<input type="text" id="orderuom" name="orderuom" value="#Line.OrderUoM#" class="regularxl" size="20">
				</cfoutput>
												
				</td>
												
				<cfloop index="itm" list="height,width,length">
				
					<td style="padding-left:7px"><cf_tl id="#itm#"></td>
					<td style="padding-left:4px">
					<cfoutput>
					<input type="text" onchange="ptoken.navigate('setPurchaseLineVolume.cfm','setvolume','','','POST','entry')" 
					  id="orderuom#itm#" name="orderuom#itm#" value="#evaluate('Line.OrderUoM#itm#')#" style="text-align:right;padding-right:3px" class="regularh" size="5">
					</cfoutput>
					</td>	
					<td style="padding-left:2px"><cf_tl id="cm"></td>		
				
				</cfloop>
				
				</td>
				
				<td class="hide" id="setvolume"></td>
				
				<td class="labelmedium" style="padding-left:17px"><cf_tl id="Volume in m3">:</td>
				
				<td style="padding-left:4px">
					<cfoutput>
					<input type="text" id="orderuomvolume" name="orderuomvolume" value="#Line.OrderUoMVolume#" style="text-align:right;padding-right:3px" class="regularxl" size="5">
					</cfoutput>
				</td>							
 
			 </tr>
			 
			</table>
		 </td>
		 
		 </tr>		 
		
			 <cfif Request.RequestType eq "Warehouse">
			 
			 		<tr>
				
					<td class="labelmedium" style="padding-left:24px;padding-right:4px">
					  <cf_tl id="Multiplier">:
					 </td> 
					 
					 <td>
					 <table><tr>
					 <td>
					  <cfinput type="Text" id="ordermultiplier" name="ordermultiplier" value="#Line.OrderMultiplier#" message="Enter a valid quantity" 
				  		validate="float" class="regularxl" required="Yes" size="8" style="text-align: right;" 
						onChange="javascript:whs(this.value,orderquantity.value,orderprice.value)">
				    </td>
					<td style="padding-left:10px;padding-right:4px" class="labelmedium">
					  <cf_tl id="Equals to">:
					</td>
					<td>  
					  <cfoutput>
				        <input type="text" size="8" class="regularxl" id="orderwarehouse" name="orderwarehouse" value="#round(Line.ordermultiplier*1000*Line.orderquantity)/1000#" size="20" readonly style="text-align: right;">
					  </cfoutput>
				    </td>
					<td style="padding-left:4;padding-right:4px">@</td>
					<td style="padding-left:1px">  
					  <cfoutput>
				        <input type="text" size="8" class="regularxl" id="unitprice" name="unitprice" value="#numberformat(prc/Line.ordermultiplier,'_.___')#" size="10" readonly style="text-align: right;">
					  </cfoutput>
				    </td>
					<td style="padding-left:3px" class="labelmedium"><cfoutput>#Request.QuantityUoM#</cfoutput></td>
					
					<td style="padding-left:10px"  class="labelmedium">
					  [<cf_tl id="Requested">: <cfoutput>#numberformat(Request.requestquantity,'__,__')# #Request.QuantityUoM#</cfoutput>]					
					</td>
					
					</tr>
					</table>
					</td>
					
					</tr>
					
			 <cfelse>
				
				  <input type="hidden" class="regular" name="ordermultiplier" id="ordermultiplier" value="<cfoutput>#Line.OrderMultiplier#</cfoutput>" size="20" maxlength="20">
				  
			 </cfif>
				   
								
		<TR>
	    <TD class="labelmedium"><cf_tl id="Price">:</TD>
	    <TD>
		
			<table class="formspacing">
			<tr><td>
			
			<cfquery name="Lines" 
			 datasource="AppsPurchase" 
			 username="#SESSION.login#" 
			 password="#SESSION.dbpw#">
		     SELECT   SUM(OrderAmountBase) AS amount
			 FROM     PurchaseLine 		
			 WHERE    PurchaseNo     = '#Line.PurchaseNo#'
			 AND      RequisitionNo <> '#URL.ID#' 
			 AND      ActionStatus  <> '9' 	  	
			</cfquery>
			
			<cfif Lines.recordcount gte "1">
			
			    <cfoutput>
			         <input type="text" class="regularxl" readonly name="currency" id="currency" value="#curr#" style="text-align:center;width:35">
				</cfoutput>
				
			<cfelse> 
		   	  
			   	<select name="currency" id="currency" class="regularxl" size="1" onChange="javascript:exch(this.value,costprice.value,taxprice.value)">
				    <cfoutput query="currency">
						<option value="#Currency#" <cfif Currency eq curr>selected</cfif>>#Currency#</option>
					</cfoutput>
			    </select>
			
			</cfif>
			
			</td>
			
			<cfoutput query="currency">
				<input type="hidden" id="exchangerate_#Currency#" value="#ExchangeRate#">
			</cfoutput>
			
			<cfoutput>
				<input type="hidden" name="exchangerate" id="exchangerate" value="#exch#">
			</cfoutput>
			
			<td>
			
			<cfif Line.OrderZero eq "1">
			
				<cfinput type="Text" 
				  name="orderprice" 
				  id="orderprice"
				  value="#numberFormat(prc,"__.__")#" 
				  message="Enter a valid price" 
				  class="regularxl"
				  validate="float" 
				  required="Yes" 
				  size="8" 
				  maxlength="12" 
				  style="text-align: right;" disabled
				  onChange="calc(orderquantity.value,this.value,extprice.value,orderdiscount.value,ordertax.value,taxincl.value,exchangerate.value,taxexemption.value);nofree()">						
			
			<cfelse>
			
				<cfif prc lte "0.01">
					 <cfset pd = numberFormat(prc,'__._____')>
				<cfelse>
					 <cfset pd = numberFormat(prc,'__.__')>	 
				</cfif>
						
				<cfinput type="Text" 
				  name="orderprice" 
				  id="orderprice"
				  value="#prc#" 
				  message="Enter a valid price" 
				  class="regularxl"
				  validate="float" 
				  required="Yes" 
				  size="8" 
				  maxlength="12" 
				  style="text-align: right;padding-right:2px" 
				  onChange="calc(orderquantity.value,this.value,extprice.value,orderdiscount.value,ordertax.value,taxincl.value,exchangerate.value,taxexemption.value);nofree()">
			  			
			</cfif>
			 
						
			</td>
			
			<td class="labelmedium" style="padding-left:4px">
			
			
			<cfif Line.OrderZero eq "1">
		     <input type="checkbox" class="radiol" name="orderzero" id="orderzero" value="1" checked onClick="free(this.checked)">
			<cfelse>
			 <input type="checkbox" class="radiol" name="orderzero" id="orderzero" value="1" onClick="free(this.checked)">
			</cfif>
			</td><td style="padding-left:3px"><cf_tl id="Item offered for free">		
			</td>
			</tr>
			</table>
			
		</TD>
		</TR>
				 	 
		<TR>
	    <TD class="labelmedium"><cf_tl id="Extended price">:</TD>
	    <TD>

   		   <table cellspacing="0" cellpadding="0">
		   
		   <tr>
		   
		   <td>
		   
		   		
			<cfoutput>	
				
			    <input type="text" 
				   class="regularxl" 
				   name="extprice" 
				   id="extprice" 
				   value="#numberFormat(amt,"__.__")#" 
				   size="14"
				   onChange="calc(orderquantity.value,orderprice.value,this.value,orderdiscount.value,ordertax.value,taxincl.value,exchangerate.value,taxexemption.value);nofree()" 				   
				   readonly 
				   style="width:105px;padding-right:2px;text-align: right;">	
				   			
			</cfoutput>
			
			</td>
			<td style="padding-left:5px" class="labelmedium">	
			    <table><tr><td>		
			    <input type="checkbox" class="radiol" name="entrysetting" id="entrysetting" value="1" onClick="extendedprice(this.checked)">
				</td>						
		        
				<td style="padding-left:3px">
				<cf_tl id="allow to edit">				
				</td>		
				</tr>
		
			</table>
			
			</td>		
				</tr>
		
			</table>
		
		</TD>
		</TR>
				
		<TR>
	    <TD class="labelmedium"><cf_tl id="Discount">:</TD>
	    <TD>
		
		   <cfinput type="Text" name="orderdiscount" value="#dis#" message="Enter a valid percentage"  class="regularxl" validate="float" maxlength="4"
		    required="Yes" style="width:105px;padding-right:2px;text-align: right;"
			onChange="javascript:calc(orderquantity.value,orderprice.value,extprice.value,this.value,ordertax.value,taxincl.value,exchangerate.value,taxexemption.value)"> %
					
		</TD>
		</TR>
				
		<TR>
	    <TD class="labelmedium"><cf_tl id="Disc. ext. price">:</TD>
	    <TD>
		<cfoutput>
		  <input type="text" class="regularxl" name="discextprice" id="discextprice" value="#numberFormat(damt,"__.__")#" size="14" readonly style="width:105px;padding-right:2px;text-align: right;">
		</cfoutput>
		</TD>
		</TR>
		
		<TR>
	    <TD class="labelmedium"><cf_tl id="Item tax">:</TD>
	    <TD>			   		
			<cfinput type="Text" name="ordertax" value="#txu#" message="Enter a valid percentage" validate="float"  class="regularxl" required="Yes" size="2" maxlength="2" style="width:105px;padding-right:2px;text-align: right;" 
			onChange="calc(orderquantity.value,orderprice.value,extprice.value,orderdiscount.value,this.value,taxincl.value,exchangerate.value,taxexemption.value)"> %								
		</TD>
		</TR>
				
		<TR>
	    <TD class="labelmedium"><cf_tl id="Tax included in Price">:</TD>
	    <TD class="labelmedium">
		    <cfoutput>
			
			<table cellspacing="0" cellpadding="0"><tr>
			<td>
			
			<input type="radio" class="radiol" name="taxincluded" id="taxincluded" value="1" <cfif txi eq "1">checked</cfif>
			onclick="javascript:tax('1'); calc(orderquantity.value,orderprice.value,extprice.value,orderdiscount.value,ordertax.value,'1',exchangerate.value,taxexemption.value)">
			</td>
			<td style="padding-left:4px" class="labelmedium">Yes</td>
			<td style="padding-left:6px">
			<input type="radio" class="radiol" name="taxincluded" id="taxincluded" value="0" <cfif txi eq "0">checked</cfif>
			onclick="javascript:tax('0'); calc(orderquantity.value,orderprice.value,extprice.value,orderdiscount.value,ordertax.value,'0',exchangerate.value,taxexemption.value)">
			</td>
			<td style="padding-left:4px" class="labelmedium">No</td>
			</tr>
			</table>
			<input type="hidden" name="taxincl" id="taxincl" value="#txi#">
		
			</cfoutput>
		</TD>
		</TR>
		
		<tr>	
		<td class="labelmedium"><cf_tl id="Tax exemption">:</td>
		<TD class="labelmedium">
	    <cfoutput>
		<table cellspacing="0" cellpadding="0"><tr>
			<td>
		<input type="radio" class="radiol" name="exem" id="exem" value="1" <cfif exm eq "1">checked</cfif>
		onclick="document.getElementById('taxexemption').value='1'; calc(orderquantity.value,orderprice.value,extprice.value,orderdiscount.value,ordertax.value,taxincl.value,exchangerate.value,taxexemption.value)">
		<td style="padding-left:4px" class="labelmedium">Yes</td>
		<td style="padding-left:6px">
		<input type="radio" class="radiol" name="exem" id="exem" value="0" <cfif exm eq "0">checked</cfif>
		onclick="document.getElementById('taxexemption').value='0'; calc(orderquantity.value,orderprice.value,extprice.value,orderdiscount.value,ordertax.value,taxincl.value,exchangerate.value,taxexemption.value)">		
		</td>
		<td style="padding-left:4px" class="labelmedium">No</td>
		</tr>
		</table>
		<input type="hidden" name="taxexemption" id="taxexemption" value="#exm#">
	
		</cfoutput>
									
		</TD>
		</TR>
		
		<cfif Parameter1.EnablePurchaseClass eq "1">
		
			<tr><td class="labelmedium"><cf_tl id="Classification">:</td>
						
			<script language="JavaScript">
			
			function settotal() {
					 
				 se = document.getElementsByName("classamount")
				 cnt = 0
				 val = ""
				 while (se[cnt]) {
				   if (val == "") {
				   val = se[cnt].value
				   } else {
				   val = val+';'+se[cnt].value }
				   cnt++
				 }		   		   						  		 		 	 			 
				 url = "POViewClassSave.cfm?mode=edit&id=<cfoutput>#URL.ID#</cfoutput>&amount="+val;					 
				 ptoken.navigate(url,'total')							  		  
				
				}    
		  		
			</script>
					
			<td id="total">
				<cfinclude template="POViewClass.cfm">
		    </td>
			
			</tr>
			
		</cfif>
				
		<TR>
	    <TD valign="top" style="padding-top:3px" class="labelmedium"><cf_tl id="Total">:</TD>
			
	    <TD>
		
			<table border="0" cellspacing="0" cellpadding="0" class="formpadding">
	       
			<tr>
			<td class="labelmedium">Price:&nbsp;</td>
			<td>
			<cfoutput>
			        <input type="text" class="regularxl" name="costprice" id="costprice" value="#numberFormat(cost,"__.__")#" size="14" readonly style="text-align: right;">
			</cfoutput>
			</td>
			<TD style="padding-left:20px"></td>
			
			<TD class="labelmedium"><cfoutput>Price #APPLICATION.BaseCurrency#:</cfoutput></TD>
		   <TD style="padding-left:20px">
			<cfoutput>
			        <input type="text"  class="regularxl" name="costpriceb" id="costpriceb" value="#numberFormat(costB,"__.__")#" size="14" readonly style="text-align: right;">
					<input type="hidden" value="#costB#" name="costpriceb_old" id="costpriceb_old" required="No" visible="No" enabled="Yes">
			</cfoutput>
			</TD>
			
			</tr>
			
			<tr>
			<td class="labelmedium">Tax:&nbsp;</td>
			<td>
			<cfoutput>
			  <input type="text" class="regularxl" name="taxprice" id="taxprice" value="#numberFormat(tax,"__.__")#" size="14" readonly style="text-align: right;">
			</cfoutput>
			</td>
			<TD style="padding-left:20px"></td>
			<TD class="labelmedium"><cfoutput>Tax #APPLICATION.BaseCurrency#:</cfoutput></TD>
		    <TD style="padding-left:20px">
			<cfoutput>
			  <input type="text" class="regularxl" name="taxpriceb" id="taxpriceb" value="#numberFormat(taxb,"__.__")#" size="14" readonly style="text-align: right;">
			</cfoutput>
			</TD>
			</tr>
			
			<tr>
			<TD class="labelmedium"><cf_tl id="Payable">:&nbsp;</td>
			<td>
			<cfoutput>
			  <input type="text" class="regularxl" name="pay" id="pay" value="#numberFormat(pay,"__.__")#" size="14" readonly style="text-align: right;">
			</cfoutput>
			</td>
			<TD style="padding-left:20px"></td>
			<TD class="labelmedium"><cf_tl id="Payable"><cfoutput>#APPLICATION.BaseCurrency#</cfoutput>:</TD>
		    <TD style="padding-left:20px">
			<cfoutput>
			  <input type="text" class="regularxl" name="payB" id="payB" value="#numberFormat(payb,"__.__")#" size="14" readonly style="text-align: right;">
			</cfoutput>
			</TD>
			</tr>
			
			</table>
			
		</td>	
		</TR>
				   
	<TR>
        <td class="labelmedium" valign="top" style="min-width:300px;padding-top:3px"><cf_tl id="Remarks">:</td>
        <TD><textarea style="width:98%;font-size:13px;padding:3px" rows="3" name="Remarks" class="regular"><cfoutput>#Line.Remarks#</cfoutput></textarea> </TD>
	</TR>
	
	</cfif>
				
	<tr><td height="3" colspan="2"></td></tr>
	<tr><td height="1" class="line" colspan="2"></td></tr>
	
	<cf_tl id="close" var="1">
	<cfset vClose=#lt_text#>	
	
	<cf_tl id="Reset" var="1">
	<cfset vReset=#lt_text#>	
	
	<cf_tl id="Next" var="1">
	<cfset vNext=#lt_text#>	

	<cf_tl id="Save and Close" var="1">
	<cfset vSaveLine=#lt_text#>	
	
	<cf_tl id="Save and Next" var="1">
	<cfset vSaveNext=#lt_text#>	

	<tr><td height="30" align="center" colspan="2">
	
		<table align="center" class="formspacing">
		<tr>
    
	   <cfoutput>
	   
	   	    <td>
	 
		   <cfif Line.personNo eq "">
			  <input class="button10g" style="height:27px" type="button"  name="close" id="close" value="#vClose#" onclick="parent.ProsisUI.closeWindow('myline',true)">
		   <cfelse>
		 	  <input class="button10g" style="height:27px" type="button"  name="close" id="close" value="#vClose#" onclick="parent.ProsisUI.closeWindow('myline',true)">	 
		   </cfif>
		   
		   </td>
				   
		   <cfif Travel.recordcount eq "0">		
		      
		       <cfinvoke component="Service.Access"
		          Method         = "procApprover"
		          OrgUnit        = "#Line.OrgUnit#"
		          OrderClass     = "#Line.OrderClass#"
		          ReturnVariable = "ApprovalAccess">    
		   
			   <cfif (Line.Actionstatus eq "0" and url.mode eq "Edit") or 
			            getAdministrator(Line.mission) eq "1" or
						(ApprovalAccess eq "EDIT" or ApprovalAccess eq "ALL")>
			  
			  	 <cfif Line.personNo eq "" or 
				       getAdministrator(Line.mission) eq "1" or 
					   (ApprovalAccess eq "EDIT" or ApprovalAccess eq "ALL")>
					
					<td>   
				  	 <input class="button10g" style="height:27px" type="reset"  name="Reset" id="Reset" value="#vReset#">
					</td>
					<td> 
					 <input class="button10g" style="width:200px;height:27px" type="button" onclick="formvalidate('#url.id#','next')" name="next"  id="next"  value="#vSaveNext#">
					</td> 
										
					<!--- next / prior --->
					
					<cfquery name="Lines" 
					datasource="AppsPurchase" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
					    SELECT L.*
					    FROM   PurchaseLine L
						WHERE  L.ActionStatus != '9'
						AND    L.PurchaseNo = '#Line.PurchaseNo#'
						ORDER BY L.ListingOrder, L.OrderItemNo, L.Created
					</cfquery>
					
					<cfset sel = 0>
					<cfset next = "">
					<cfloop query="Lines">
					   <cfif sel eq "1">
					   	  <cfset next = requisitionNo>
					   </cfif>
					   <cfif requisitionNo eq URL.ID>
					      <cfset sel = 1>
					   <cfelse>
					   	  <cfset sel = 0>	  
					   </cfif>
					</cfloop>
					
					<cfif next neq "">
					
					<td class="hide"> 					
					 <input class="button10g" type="button" style="height:27px" 
					  name="gonext"  id="gonext"  value="#vNext#" onclick="_cf_loadingtexthtml='';ptoken.navigate('PurchaseLineEditForm.cfm?mode=#url.mode#&id=#next#','contentbox1')">
					</td> 
					
					</cfif>
											
					<td> 
					 <input class="button10g" style="width:200px;height:27px" type="button" onclick="formvalidate('#url.id#','close')" name="save"  id="save"  value="#vSaveLine#">
					</td>
										
					 
			   	</cfif>	 
				
			   </cfif>
		   </cfif>
		  
	   </cfoutput>
	   
	   </tr>
				
</CFFORM>
</table>
	   
	   </td>	
	</tr>		