<!--- Prosis template framework --->
<cfsilent>
	<proUsr>jmazariegos</proUsr>
	<proOwn>Jorge Mazariegos</proOwn>
	<proDes>Translated</proDes>
	<proCom></proCom>
</cfsilent>
<!--- End Prosis template framework --->

<cf_screentop label="Quotation Edit form" html="no" height="100%" jquery="Yes">

<cfparam name="URL.Mode" default="view">

<cfparam name="URL.Id" default="{7D33F6FA-3711-414D-98A8-D849000A49BB}">

<script>

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

function calc(x,y,z,t,i,e,exm) {
	
	var tax = t - 0
		
	<!--- extended price --->
	var s = " " + Math.round((x*y) * 100) / 100
	  val(s,'ExtPrice')
	  
	<!--- extended price --->
	var s = " " + Math.round((x*y*(100-z))) / 100
	var base = (x*y*(100-z))
	  val(s,'DiscExtPrice')
		  
	<!--- cost price --->
	if (i == 1) { 
	    var c = " " + Math.round(base*(100/(100+tax))) / 100
	} else { 
	    var c = " " + Math.round(base) / 100
	}
	val(c,'costprice')  
	  
	<!--- tax price --->
	if (i == 1) { 
		var t = " " + Math.round(base*(tax/(100+tax))) / 100
	} else { 
		var t = " " + Math.round(base*tax/100) / 100
	}
	val(t,'taxprice')    
	    	 
	<!--- cost priceB --->
	if (i == 1) { 
	    var cb = " " + Math.round((base*(100/(100+tax))/e)) / 100
	} else { 
	    var cb = " " + Math.round(base/e) / 100
	}
	val(cb,'costpriceB')  
	  
	<!--- tax priceB --->
	if (i == 1) { 
	   var tb = " " + Math.round((base*(tax/(100+tax)))/e) / 100 
	} else { 
	   var tb = " " + Math.round((base*tax/100)/e) / 100
	}
	val(tb,'taxpriceB')   
	  
	
    <!--- payable --->  
	if (exm == 1) {
	   val(c,'pay')
	   val(cb,'payB')
	} else {
	   if (i == 1) {
		   var a = " " + Math.round(base) / 100	   
		   val(a,'pay')	  
		   var a = " " + Math.round(base/e) / 100	
		   val(a,'payB')
	   } else {
	       var a = " " + ((Math.round(base)/100) + (Math.round(base*tax/100) / 100))	   
		   val(a,'pay')	  
		   var a = " " + ((Math.round((base)/e)/100) + (Math.round((base*tax/100)/e) / 100))
		   val(a,'payB')
	   }		  
	} 
 
} 

 
function free(chk) {

if (chk) 
    { calc('0','0','0','0','1','1');
	  val('0','quoteprice') 
	  z = document.getElementById("quoteprice")
	  z.disabled = true
	} 
else { 
	 z = document.getElementById("quoteprice")
	 z.disabled = false }	
}

function nofree() {
   z = document.getElementById("quotezero")
   z.checked = false
}

function exch(cur,cost,tax)	{
		
	itm = document.getElementById("exchangerate_"+cur);
	des = document.getElementById("exchangerate");
	des.value = itm.value;
	
	<!--- cost priceB --->
	var s = " " + Math.round(cost*100/des.value) / 100
	val(s,'costpriceB')  
	
	<!--- cost priceB --->
	var s = " " + Math.round(tax*100/des.value) / 100
	val(s,'taxpriceB')   
	}
	
function tax(t)	{		
	itm = document.getElementById("taxincl");
	itm.value = t;
	}	
	
function whs(mul,qty) {		
    try {
	itm = document.getElementById("quotationwarehouse");
	itm.value = mul*qty;
	} catch(e) {}
	}		

</script>

<cfquery name="Line" 
datasource="AppsPurchase" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
    FROM   RequisitionLineQuote
	WHERE  QuotationId = '#URL.ID#'
</cfquery>

<cfquery name="Job" 
datasource="AppsPurchase" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
    FROM   Job
	WHERE  JobNo = '#Line.JobNo#'
</cfquery>

<cfquery name="Workflow" 
datasource="AppsOrganization" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
    FROM   OrganizationObject
	WHERE  ObjectKeyValue1 = '#Line.JobNo#'
	AND    EntityCode = 'ProcJob'
</cfquery>

<cfquery name="Request" 
datasource="AppsPurchase" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
    FROM   RequisitionLine
	WHERE  RequisitionNo = '#Line.RequisitionNo#'
</cfquery>

<cfif Request.recordcount eq "0">

<table width="100%"><tr><td style="padding-top:50px" align="center" class="labelmedium">Line no longer exists</td></tr></table>
<cfabort>

</cfif>

<cfquery name="Parameter1" 
	datasource="AppsPurchase" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
    SELECT *
    FROM   Ref_ParameterMission
	WHERE  Mission = '#Request.Mission#' 
</cfquery>

<cfquery name="CurrencyList" 
datasource="AppsLedger" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
    FROM   Currency
	WHERE  EnableProcurement = 1
</cfquery>

<cfquery name="Statement" 
datasource="AppsPurchase" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
    FROM Ref_Award
</cfquery>

<cfquery name="UoM" 
datasource="AppsPurchase" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
    FROM Ref_UoM
</cfquery>
		
<!--- check if lines may be awarded, disable if line is already under PO --->
	
<cfquery name="Req" 
	datasource="AppsPurchase" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
   		SELECT *
	    FROM RequisitionLine
		WHERE RequisitionNo = '#Line.RequisitionNo#'
</cfquery>

<cfparam name="Status" default="1">

<cf_divscroll>

<cfform action="QuotationEditSubmit.cfm?ID=#URL.ID#&mode=#url.mode#" method="POST" name="entry">

    <!--- precalc --->
	
	<cfif Line.recordcount eq "0">
	
	 <cfset qty   = 1>
	 <cfset prc   = 0>
	 <cfset dis   = 0>
	 <cfset txu   = "#Parameter1.TaxDefault*100#">
	 
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
	
	 <cfset qty  = Line.QuotationQuantity>
	 <cfset prc  = Line.QuotePrice>
	 <cfset dis  = Line.QuoteDiscount*100>
	 
	 <cfset txu  = Line.QuoteTax*100>
	 <cfset txi  = Line.TaxIncluded>
	 
	 <cfset exch = Line.ExchangeRate>
	 <cfset curr = Line.Currency>
	 
	 <cfset exm  = Line.TaxExemption>
	
	 <cfset amt  = Line.QuotePrice*Line.QuotationQuantity>
	 <cfset damt = Line.QuotePrice*Line.QuotationQuantity*((100-dis)/100)>
	 <cfif Line.TaxIncluded eq "1">
	 	<cfset cost = damt*(100/(100+txu))>
		<cfset tax  = damt*(txu/(100+txu))>
	 <cfelse>
	  	<cfset cost = damt>
		<cfset tax  = damt*(Line.QuoteTax)>
	 </cfif>
	 <cfset costB = cost/exch>
	 <cfset taxb  = tax/exch>
	 
	 <cfif Line.TaxExemption eq "1" or tax eq "">
		 <cfset pay   = cost>
		 <cfset payB  = costB>		
	 <cfelse>
	 	 <cfset pay   = cost+tax>
		 <cfset payB  = costB+taxB>			
	 </cfif>	
	
	</cfif>
		
	<table width="97%" border="0" align="center" class="formpadding">
	
	<tr><td height="9"></td></tr>	
	
	 <cfif (Req.Actionstatus lte "2k" or Req.Actionstatus lte "2q") and url.mode neq "View">
	 
	 <cfelse>
	 
		 <cfif Req.Actionstatus gte "3">
			 <tr><td colspan="2" height="100" class="labelmedium" align="center"><font color="FF0000">Line may no longer be modified as a purchase has been raised</td></tr>
		 <cfelse>
		 	 <tr><td colspan="2" height="100" class="labelmedium" align="center"><font color="FF0000">Line may not be modified from this context</td></tr>
		 </cfif>
	 
	 </cfif>
		
	<TR>
    <TD style="width:30%" class="labelmedium"><cf_tl id="Reference3">:</TD>
    <TD class="labelmedium">
	
	  <cfif (Req.Actionstatus lte "2k" or Req.Actionstatus lte "2q") and url.mode neq "View">
		
	  <input type="Text" class="regularxl enterastab" name="DocumentNo" id="DocumentNo" value="<cfoutput>#Line.DocumentNo#</cfoutput>" size="20" maxlength="20">
	  
	  <cfelse>
	  
	  <cfoutput>#Line.DocumentNo#</cfoutput>
	  
	  </cfif>
			
	</TD>
	</TR>
			
	<TR>
    <TD class="labelmedium"><cf_tl id="ItemNo">:</TD>
    <TD class="labelmedium">
	
	  <cfif (Req.Actionstatus lte "2k" or Req.Actionstatus lte "2q") and url.mode neq "View">	
		
	  <input type="Text" class="regularxl enterastab" name="VendorItemNo" id="VendorItemNo" value="<cfoutput>#Line.VendorItemNo#</cfoutput>" size="20" maxlength="20">
	  
	  <cfelse>
	  
	  <cfoutput>#Line.VendorItemNo#</cfoutput>
	  
	  </cfif>
			
	</TD>
	</TR>
	
	<TR>
	<td class="labelmedium"><cf_tl id="Description">:</td>
    <TD class="labelmedium">
	
	   <cfif (Req.Actionstatus lte "2k" or Req.Actionstatus lte "2q") and url.mode neq "View">	
	   
	       <textarea name="VendorItemDescription" class="regular enterastab" style="font-size:14px; width:99%; height:40px;padding:3px"><cfoutput>#Line.VendorItemDescription#</cfoutput></textarea> 
	   
	   <cfelse>
	  
	     <cfoutput>#Line.VendorItemDescription#</cfoutput>
	  
	   </cfif>
	   
    </TD>
	</TR>
	
	<TR>
    <TD class="labelmedium"><cf_tl id="Quantity Offered">:</TD>
    <TD class="labelmedium">
	
	  <table width="97%">
	  <tr><td class="labelmedium">
	  
	   <cfif (Req.Actionstatus lte "2k" or Req.Actionstatus lte "2q") and url.mode neq "View">	
	  
		   	  <cfinput type="Text" class="regularxl enterastab" id="quotationquantity" name="quotationquantity" value="#qty#" message="Enter a valid quantity" 
			  validate="float" required="Yes" size="4" style="text-align: right;" 
			  onChange="calc(this.value,quoteprice.value,quotediscount.value,quotetax.value,taxincl.value,exchangerate.value); whs(quotationmultiplier.value,this.value)">
			
			   </td>
			   <td>
			   	<select name="quotationuom" id="quotationuom" size="1" class="regularxl enterastab">
				    <cfoutput query="UoM">
						<option value="#Code#" <cfif Code eq Line.QuotationUoM>selected</cfif>>
				    		#Description#
						</option>
					</cfoutput>
			    </select>
				
		<cfelse>
	  
		     <cfoutput>#qty# #Line.QuotationUoM#</cfoutput>
	  
	    </cfif>		
				
		</td>
				
		<cfif Request.RequestType eq "Warehouse">
		
			<td class="labelmedium">Multi:</td> 
			<td class="labelmedium">
			 
			  <cfif (Req.Actionstatus lte "2k" or Req.Actionstatus lte "2q") and url.mode neq "View">	
			 
			 	 <cfinput type="Text" id="quotationmultiplier" name="quotationmultiplier" value="#Line.QuotationMultiplier#" message="Enter a valid quantity" 
			  		validate="float" class="regularxl enterastab" required="Yes" size="3" style="text-align: right;" 
					onChange="javascript:whs(this.value,quotationquantity.value)">
					
			  <cfelse>
	  
				     <cfoutput>#Line.QuotationMultiplier#</cfoutput>
	  
		      </cfif>										
					
		    </td>
			<td class="labelmedium"><cf_tl id="Restock">:</td>
			<td class="labelmedium">  
			
			  <cfif (Req.Actionstatus lte "2k" or Req.Actionstatus lte "2q") and url.mode neq "View">	
			
				  <cfoutput>
			      		<input type="text" size="5" class="regularxl enterastab" id="quotationwarehouse" name="quotationwarehouse" value="#Line.quotationmultiplier*Line.quotationquantity#" size="14" readonly style="text-align: right;">
				  </cfoutput>
			  
			  <cfelse>
	  
		           <cfoutput>#Line.quotationmultiplier*Line.quotationquantity#</cfoutput>
	  
	   		  </cfif>	
			  
		    </td>
			<td class="labelmedium">
			  <cf_tl id="Request">:<b> <cfoutput>#Request.requestquantity# #Request.QuantityUoM#</cfoutput>			
			</td>
		<cfelse>
		  <input type="hidden" class="regularxl enterastab" name="quotationmultiplier" id="quotationmultiplier" value="<cfoutput>#Line.QuotationMultiplier#</cfoutput>" size="20" maxlength="20">
		</cfif>
		
		</tr>
		</table>
		
	</TD>
	</TR>
	
	<tr><td class="labelmedium"><cf_tl id="Offered for free">:</td>
	     <td class="labelmedium" style="height:25px">
		
		<cfif (Req.Actionstatus lte "2k" or Req.Actionstatus lte "2q") and url.mode neq "View">	 
		
			<cfif Line.QuoteZero eq "1">
		     <input type="checkbox" class="radiol" name="quotezero" id="quotezero" value="1" checked onClick="javascript:free(this.checked)">
			<cfelse>
			 <input type="checkbox" class="radiol" name="quotezero" id="quotezero" value="1" onClick="javascript:free(this.checked)">
			</cfif> 
			
		<cfelse>
	  
		    <cfif Line.QuoteZero eq "1">Yes<cfelse>No</cfif>
	  
	   	</cfif>		
				
		</td>
	</tr>
	
	<TR>
    <TD class="labelmedium"><cf_tl id="Price">:</TD>
    <TD class="labelmedium">
	
		<cfif (Req.Actionstatus lte "2k" or Req.Actionstatus lte "2q") and url.mode neq "View">	
	   	  
		   	<select name="currency" id="currency" class="regularxl enterastab" size="1" onChange="javascript:exch(this.value,costprice.value,taxprice.value)">
		    <cfoutput query="currencylist">
				<option value="#Currency#" <cfif Currency eq curr>selected</cfif>>
	    		#Currency#
			</option>
			</cfoutput>
		    </select>
			
		<cfelse>
	  
	  		<cfoutput>#curr#</cfoutput>
		   	  
	   	</cfif>			
								
		<cfif Line.QuoteZero eq "1">
		
			 <cfif (Req.Actionstatus lte "2k" or Req.Actionstatus lte "2q") and url.mode neq "View">	
			
				<cfinput type="Text" 
				 id="quoteprice" name="quoteprice" class="regularxl enterastab" 
				 value="#numberFormat(prc,".__")#" message="Enter a valid price" 
				validate="float" required="Yes" size="10" maxlength="12" style="text-align: right;" 
				onChange="javascript:calc(quotationquantity.value,this.value,quotediscount.value,quotetax.value,taxincl.value,exchangerate.value,taxexemption.value);nofree()" disabled>
				
			  <cfelse>
			  
				  <cfoutput>#numberFormat(prc,".__")#</cfoutput>
				  
			  </cfif>	
						
		<cfelse>		
		
			 <cfif (Req.Actionstatus lte "2k" or Req.Actionstatus lte "2q") and url.mode neq "View">	
			 
				<cfinput type="Text" id="quoteprice" name="quoteprice" class="regularxl enterastab" value="#numberFormat(prc,"__.__")#" message="Enter a valid price" 
				validate="float" required="Yes" size="10" maxlength="12" style="text-align: right;" 
				onChange="javascript:calc(quotationquantity.value,this.value,quotediscount.value,quotetax.value,taxincl.value,exchangerate.value,taxexemption.value);nofree()">
				
			 <cfelse>
			  
				  <cfoutput>#numberFormat(prc,".__")#</cfoutput>
				  
			 </cfif>			 
		 	 			
		</cfif>
		
		<cfoutput query="currencylist">
		<input type="hidden" id="exchangerate_#Currency#" value="#ExchangeRate#">
		</cfoutput>
		
		<cfoutput>
		<input type="hidden" name="exchangerate" id="exchangerate" value="#exch#">
		</cfoutput>
			
		
	</TD>
	</TR>
	 	 
	<TR>
    <TD class="labelmedium"><cf_tl id="Extended price">:</TD>
    <TD class="labelmedium">
	<cfoutput>
	
		<cfif (Req.Actionstatus lte "2k" or Req.Actionstatus lte "2q") and url.mode neq "View">	
	
	    <input type="text" class="regularxl enterastab" name="ExtPrice" id="ExtPrice" value="#numberFormat(amt,"__.__")#" size="14" disabled readonly style="text-align: right;">
		
		<cfelse>
		  
			  <cfoutput>#numberFormat(amt,".__")#</cfoutput>
			  
		</cfif>	
		
	</cfoutput>
	</TD>
	</TR>
	
	<TR>
    <TD class="labelmedium"><cf_tl id="Discount">:</TD>
    <TD class="labelmedium">
	
	   <cfif (Req.Actionstatus lte "2k" or Req.Actionstatus lte "2q") and url.mode neq "View">	
	
		   <cfinput type="Text" id="quotediscount" name="quotediscount" class="regularxl enterastab" value="#dis#" message="Enter a valid percentage" validate="float" required="Yes" size="3" style="text-align: right;" 
			onChange="javascript:calc(quotationquantity.value,quoteprice.value,this.value,quotetax.value,taxincl.value,exchangerate.value,taxexemption.value)"> %
			
		<cfelse>
		
			<cfoutput>#dis#</cfoutput>%
		
		</cfif>
				
					
	</TD>
	</TR>
	
	<TR>
	    <TD class="labelmedium"><cf_tl id="Disc. ext. price">:</TD>
	    <TD class="labelmedium">
		
		<cfif (Req.Actionstatus lte "2k" or Req.Actionstatus lte "2q") and url.mode neq "View">	
		
			<cfoutput>
			  <input type="text" class="regularxl enterastab" name="DiscExtPrice" id="DiscExtPrice" value="#numberFormat(damt,"__.__")#" size="14" disabled readonly style="text-align: right;">
			</cfoutput>
			
		
		<cfelse>
		  
			  <cfoutput>#numberFormat(damt,"__.__")#</cfoutput>
			  
		</cfif>		
		
		</TD>
	</TR>
	
	<TR>
    <TD class="labelmedium"><cf_tl id="Item tax">:</TD>
    <TD class="labelmedium">		
	
		<cfif (Req.Actionstatus lte "2k" or Req.Actionstatus lte "2q") and url.mode neq "View">	
		   		
			<cfinput type="Text" id="quotetax" class="regularxl enterastab" name="quotetax" value="#txu#" message="Enter a valid percentage" validate="float" required="Yes" size="4" style="text-align: right;" 
			onChange="javascript:calc(quotationquantity.value,quoteprice.value,quotediscount.value,this.value,taxincl.value,exchangerate.value,taxexemption.value)"> %
			
		<cfelse>
		
			<cfoutput>#txu#%</cfoutput>
		
		</cfif>	
					
			
		</td>
	</tr>
	
	<tr>	
		<td class="labelmedium"><cf_tl id="Tax included in price">:</td>
		<TD class="labelmedium">
	    <cfoutput>
		
		<cfif (Req.Actionstatus lte "2k" or Req.Actionstatus lte "2q") and url.mode neq "View">	
		
			<input type="radio" class="radiol" name="taxincluded" id="taxincluded" value="1" <cfif txi eq "1">checked</cfif>
			onclick="javascript:tax('1'); calc(quotationquantity.value,quoteprice.value,quotediscount.value,quotetax.value,'1',exchangerate.value,taxexemption.value)">Yes
			<input type="radio" class="radiol" name="taxincluded" id="taxincluded" value="0" <cfif txi eq "0">checked</cfif>
			onclick="javascript:tax('0'); calc(quotationquantity.value,quoteprice.value,quotediscount.value,quotetax.value,'0',exchangerate.value,taxexemption.value)">No
			
			<input type="hidden" name="taxincl" id="taxincl" value="#txi#">
				
		
		 <cfelse>
		 
		 	<cfif txi eq "1">Yes</cfif>
		 		 
		 </cfif>
			
		</cfoutput>
									
	</TD>
	</TR>
	
	
	<tr>	
		<td class="labelmedium"><cf_tl id="Tax exemption">:</td>
		<TD class="labelmedium">
	    <cfoutput>
		
		<cfif (Req.Actionstatus lte "2k" or Req.Actionstatus lte "2q") and url.mode neq "View">	
		
		<input type="radio" class="radiol" name="exem" id="exem" value="1" <cfif exm eq "1">checked</cfif>
		onclick="document.getElementById('taxexemption').value='1'; calc(quotationquantity.value,quoteprice.value,quotediscount.value,quotetax.value,taxincl.value,exchangerate.value,taxexemption.value)">Yes
		
		<input type="radio" class="radiol" name="exem" id="exem" value="0" <cfif exm eq "0">checked</cfif>
		onclick="document.getElementById('taxexemption').value='0'; calc(quotationquantity.value,quoteprice.value,quotediscount.value,quotetax.value,taxincl.value,exchangerate.value,taxexemption.value)">No
		
		<input type="hidden" name="taxexemption" id="taxexemption" value="#exm#">
		
		<cfelse>
		
			<cfif exm eq "1">Yes</cfif>
		
		</cfif>
			
		</cfoutput>
									
	</TD>
	</TR>
	
	<TR>
  		
    <TD class="labelmedium" colspan="2" align="center" style="padding:5px">
	
		<table style="border-top:1px solid gray;border-bottom:1px solid gray;padding:4px" cellspacing="0" cellpadding="0" class="formspacing">
		
			<tr>
			<TD class="labelmedium" style="padding-left:10px"><cf_tl id="Cost price">:&nbsp;</td>
			<td style="padding-left:10px">
			<cfoutput>
			        <input type="text" name="costprice" id="costprice" value="#numberFormat(cost,"__.__")#"  class="regularxl" readonly style="border:0px;width:110PX;text-align: right;">
			</cfoutput>
			</td>
			
			<TD class="labelmedium" style="padding-left:10px"><cf_tl id="Cost price"><cfoutput><font size="2">#APPLICATION.BaseCurrency#</cfoutput>:</TD>
		    <TD class="labelmedium" style="padding-left:10px">
			<cfoutput>
			   <input type="text" name="costpriceB" id="costpriceB" value="#numberFormat(costB,"__.__")#"  class="regularxl" readonly style="border:0px;width:110PX;text-align: right;">
			</cfoutput>
			</TD>			
			</tr>
			
			<tr>
			<TD class="labelmedium" style="padding-left:10px"><cf_tl id="Tax">:&nbsp;</td>
			<td class="labelmedium" style="padding-left:10px">
			<cfoutput>
			   <input type="text" name="taxprice" id="taxprice" value="#numberFormat(tax,"__.__")#"  class="regularxl" readonly style="border:0px;width:110PX;text-align: right;">
			</cfoutput>
			</td>
			
			<TD class="labelmedium" style="padding-left:10px"><cf_tl id="Tax"><cfoutput><font size="2">#APPLICATION.BaseCurrency#</cfoutput>:</TD>
		    <TD class="labelmedium" style="padding-left:10px">
			<cfoutput>
			   <input type="text" name="taxpriceB" id="taxpriceB" value="#numberFormat(taxb,"__.__")#"  class="regularxl" readonly style="border:0px;width:110PX;text-align: right;">
			</cfoutput>
			</TD>
			</tr>
			
			<tr>
			<TD class="labelmedium" style="padding-left:10px"><cf_tl id="Payable">:&nbsp;</td>
			<td class="labelmedium" style="padding-left:10px">
			<cfoutput>
			   <input type="text" name="pay" id="pay" value="#numberFormat(pay,"__.__")#" class="regularxl" readonly style="border:0px;width:110PX;text-align: right;">
			</cfoutput>
			</td>			
			<TD class="labelmedium" style="padding-left:10px"><cf_tl id="Payable"><cfoutput><font size="2">#APPLICATION.BaseCurrency#</cfoutput>:</TD>
		    <TD class="labelmedium" style="padding-left:10px">
			<cfoutput>
			   <input type="text" name="payB" id="payB" value="#numberFormat(payb,"__.__")#"  class="regularxl" readonly style="border:0px;width:110PX;text-align: right;">
			</cfoutput>
			</TD>
			</tr>	
		
		</table>
		
	</td>	
	</TR>
	
	<cfif job.actionStatus eq "1" or (job.actionStatus eq "0" and workflow.recordcount eq "0")>
		
		<tr>
		<TD width="124" class="labelmedium"><cf_tl id="Award Reason">:</td>
		<td class="labelmedium">
		
		<cfif Req.Actionstatus eq "3">
		  
		    <cfoutput>
			<input type="hidden" name="Award" id="Award" value="#Line.Award#">
			<cfif Line.Award eq "">Not entered<cfelse>#Line.Award#</cfif>
			</cfoutput>
		
		<cfelse>
					
		
			<cfif (Req.Actionstatus lte "2k" or Req.Actionstatus lte "2q") and url.mode neq "View">	
			
			<cfquery name="check" 
			datasource="AppsPurchase" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">			   
					SELECT Award
					FROM   Ref_awardMission
					WHERE  Mission = '#Request.Mission#'				 
			</cfquery>
			
			<cfif check.recordcount gte "1">
									
				<cfquery name="Statement" 
				datasource="AppsPurchase" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				    SELECT *
				    FROM Ref_Award
					WHERE Code IN (
						SELECT Award
						FROM   Ref_awardMission
						WHERE  Mission = '#Request.Mission#')				 
				</cfquery>
			
			<cfelse>
			
				<cfquery name="Statement" 
				datasource="AppsPurchase" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				    SELECT *
				    FROM Ref_Award				 
				</cfquery>			
			
			</cfif>
		
			<select name="award" id="award" size="1" class="regularxl enterastab">
				<option value=""></option>
				<cfoutput query="statement">
					<option value="#Code#" <cfif Line.Award eq Code>selected</cfif>>
			    	#Description#
					</option>
				</cfoutput>
			</select>
			
			<cfelse>
									
				<cfquery name="Statement" 
				datasource="AppsPurchase" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				    SELECT *
				    FROM Ref_Award
					WHERE Code = '#Line.Award#'
				</cfquery>
						
				<cfoutput>#Statement.description#</cfoutput>
							
			</cfif>
					
		</cfif>
		
		</td>
			   
		<TR>
	    <td  valign="top" style="padding-top:4px" class="labelmedium"><cf_tl id="Award remarks">:</td>
	    <TD class="labelmedium">
		
		<cfif Req.Actionstatus eq "3" or URL.Mode eq "view">
		  
		    <cfoutput>
			   <input type="hidden" name="AwardRemarks" id="AwardRemarks" value="#Line.AwardRemarks#">
			   <cfif Line.AwardRemarks eq "">Not entered<cfelse>#Line.AwardRemarks#</cfif>
			</cfoutput>
		
		<cfelse>
		
			<cfif (Req.Actionstatus lte "2k" or Req.Actionstatus lte "2q") and url.mode neq "View">	
		
			 	<textarea style="width:97%;font-size:14px;padding:3px;" rows="2" id="AwardRemarks" name="AwardRemarks" class="regular"><cfoutput>#Line.AwardRemarks#</cfoutput></textarea> 
				
			<cfelse>
			
				<cfoutput>#Line.AwardRemarks#</cfoutput>
			
			</cfif>	
			
		</cfif>
			
		</TD>
			
		</TR>
	
	</cfif>
	
	<TR>
        <TD  valign="top" style="padding-top:4px" class="labelmedium"><cf_tl id="Remarks">:</td>
        <TD>
		
		<cfif (Req.Actionstatus lte "2k" or Req.Actionstatus lte "2q") and url.mode neq "View">	
		
			<textarea style="width:97%;font-size:14px;padding:3px" rows="4" id="Remarks" name="Remarks" class="regular"><cfoutput>#Line.Remarks#</cfoutput></textarea> 
		
		<cfelse>
		
			<cfoutput>#Line.Remarks#</cfoutput>
		
		</cfif>
		
		
		</TD>
	</TR>
		
	<tr><td height="5" colspan="2"></td></tr>
	<tr><td height="1" class="linedotted" colspan="2"></td></tr>
	
	<cf_tl id="Reset" var="1">
	<cfset vReset=lt_text>	
	
	<cf_tl id="Save Line" var="1">
	<cfset vSave=lt_text>	
	
	<cf_tl id="Save & Close" var="1">
	<cfset vSaveClose=lt_text>	
	
	<cf_tl id="Undo quote" var="1">
	<cfset vClear=lt_text>	
	
	<cf_tl id="Remove" var="1">
	<cfset vRemove=lt_text>	
	
	<cf_tl id="Remove this quote?" var="1" class="message">
	<cfset vConfirmClear = lt_text>
	
	<cf_tl id="Are you sure you want to remove this requisition line from the job?" var="1" class="message">
	<cfset vConfirmMessage = lt_text>
	
	<cfoutput>
	
	<tr>
	   <td colspan="2" align="center">
	   		
	   <cfif (Req.Actionstatus lte "2k" or Req.Actionstatus lte "2q") and url.mode neq "View">
	   
		<table cellspacing="0" cellpadding="0" class="formspacing">
	   
	   		<tr>
				
				<td>				
		 			<input width="100" class="button10g" style="height:26px;font-size:13px" 
						   type    = "submit" 
						   name    = "delete" 
						   id      = "delete" 
						   onclick = "if (confirm('#vConfirmMessage#') != 1) { return false; }"
						   value="#vRemove#">
				</td>
				<td>				
		 			<input width="100" class="button10g" style="height:26px;font-size:13px" 
						   type    = "submit" 
						   name    = "clear" 
						   id      = "clear" 
						   onclick = "if (confirm('#vConfirmClear#') != 1) { return false; }"
						   value="#vClear#">
				</td>
				<td><input width="100" type="submit" class="button10g" style="height:26px;font-size:13px" onclick="Prosis.busy('yes')" name="save" id="save"  value="#vSave#"></td>
				
				<td><input width="100" class="button10g" style="height:26px;font-size:13px" type="submit" name="saveclose" id="saveclose" value="#vSaveClose#"></td>	
				
			</tr>
		 
		 </table>
		 
	   </cfif>
	   </td>
    </tr>
	
	</cfoutput>
	
	</table>
		
</CFFORM>

</cf_divscroll>
