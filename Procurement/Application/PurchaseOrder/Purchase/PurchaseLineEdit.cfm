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

<cf_screentop height="100%" scroll="Yes" jQuery="Yes" label="Purchase Line" html="no" layout="webapp" banner="gray">

<cfparam name="URL.Mode" default="view">
<cfparam name="URL.Id" default="{7D33F6FA-3711-414D-98A8-D849000A49BB}">

<cfinclude template="../Travel/TravelScript.cfm">

<cfoutput>

	<cfajaximport tags="cfform,cfdiv">

</cfoutput>

<cf_calendarScript>

<script>
	
	function val(s,field) {
	
	z = document.getElementById(field)
	
	var i = s.indexOf('.')
	
	   if (i < 0) {
	     z.value = s + ".00" ;
	   } else {
	    var t = s.substring(0, i + 1) + s.substring(i + 1, i + 3);
	    if (i + 2 == s.length) 
		   t += "0";
	       z.value = t;
		  }
	}
	
	function calc(x,y,et,z,t,i,e,exm) {
	
	var tax = t - 0
	
	if (e==0) e= 1;
	
	se = document.getElementById('entrysetting').checked 
	
	if (se == false) {
		
		<!--- extended price --->
		var s = " " + Math.round((x*y) * 100) / 100
		  val(s,'extprice')
		  
		<!--- extended discounted price --->
		var s = " " + Math.round((x*y*(100-z))) / 100
		var base = (x*y*(100-z))
		val(s,'discextprice')
		
		  
	} else {
	
		<!--- order price  --->
		var s = " " + Math.round((et/x) * 100) / 100
		val(s,'orderprice')
		  
		<!--- extended discounted price --->
		var s = " " + Math.round((et*(100-z))) / 100	
		var base = (et*(100-z))
		val(s,'discextprice')
		
	}	  
	  
	<!--- cost price --->
	if (i == 1) 
	     { var c = " " + Math.round(base*(100/(100+tax))) / 100
		 }
	else { var c = " " + Math.round(base) / 100}
	val(c,'costprice')  
	  
	<!--- tax price --->
	if (i == 1) 
	     { var t = " " + Math.round(base*(tax/(100+tax))) / 100}
	else { var t = " " + Math.round(base*tax/100) / 100}
	val(t,'taxprice')    
	    	 
	<!--- cost priceB --->
	if (i == 1) 
	     { var cb = " " + Math.round((base*(100/(100+tax))/e)) / 100}
	else { var cb = " " + Math.round(base/e) / 100}  
	val(cb,'costpriceb')  
	
	  
	<!--- tax priceB --->
	if (i == 1) 
	     { var tb = " " + Math.round((base*(tax/(100+tax)))/e) / 100 }
	else { var tb = " " + Math.round((base*tax/100)/e) / 100 }
	  val(tb,'taxpriceb')    
	
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
		
		z = document.getElementById("orderprice")	
		if (chk) { 
		    calc('0','0','0','0','1','1','1','0');
		    val('0','orderprice') 	  
			z.disabled = true
			} else { 
			z.disabled = false 
		}	
				
	}
	
	function nofree() {
	    z = document.getElementById("orderzero")
	    z.checked = false
	}
	
	function extendedprice(val) {
	
		if (val == true) {
		   
			document.getElementById('extprice').readOnly       = false
			document.getElementById('extprice').className      = "regularxl"
			document.getElementById('orderprice').readOnly     = true	
			document.getElementById('orderprice').className    = "regularxl"
		
		} else {
		
			document.getElementById('extprice').readOnly       = true
			document.getElementById('extprice').className      = "regularxl"		
			document.getElementById('orderprice').readOnly     = false
			document.getElementById('orderprice').className    = "regularxl"
		
		}
	}
	
	function exch(cur,cost,tax) {
			
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
		
	function tax(t) {
			
		itm = document.getElementById("taxincl");
		itm.value = t;
		}	
		
	
	function whs(mul,qty,prc) {		
	    try {
		document.getElementById("orderwarehouse").value = mul*qty;
		document.getElementById("unitprice").value = prc/mul;
		
		} catch(e) {}
		}	
		
	function formvalidate(id,act) {
	    Prosis.busy('yes')
	    _cf_loadingtexthtml='';	
		document.entry.onsubmit() 
		if( _CF_error_messages.length == 0 ) {             	        
			ptoken.navigate('PurchaseLineEditSubmit.cfm?action='+act+'&ID='+id,'result','','','POST','entry')
		 }   
	}			
		
</script>

<cf_menuscript>

<cfquery name="Line" 
datasource="AppsPurchase" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT L.*, P.Mission, P.PersonNo, P.OrgUnit, P.OrderClass
    FROM   PurchaseLine L, Purchase P
	WHERE  L.RequisitionNo = '#URL.ID#'
	AND    L.PurchaseNo = P.PurchaseNo
</cfquery>

<table width="100%" height="100%">

<tr><td style="padding-top:1px;padding-left:24px">

	<table style="width:100%" align="center">	  
	 		
			<tr>		
						  			
				<cfset wd = "34">
				<cfset ht = "34">			
						
				<cf_menutab item        = "1" 
				            iconsrc     = "Logos/Procurement/Edit.png" 								
							type        = "Vertical"
							iconwidth   = "#wd#"
							iconheight  = "#ht#"
							class       = "highlight"
							name        = "Edit Purchase Line"
							source      = "PurchaseLineEditForm.cfm?mode=#url.mode#&id={selectline}">			
								
				<cf_menutab item        = "2" 
				            iconsrc     = "Logos/Procurement/Log.png" 								
							type        = "Vertical"
							targetitem  = "1"
							iconwidth   = "#wd#"
							iconheight  = "#ht#"
							name        = "Amendment Log"
							source      = "PurchaseLineEditLog.cfm?requisitionno={selectline}">
							
				<cf_menutab item        = "3" 
				            iconsrc     = "Logos/Procurement/Travel.png" 								
							type        = "Vertical"
							targetitem  = "1"
							iconwidth   = "#wd#"
							iconheight  = "#ht#"
							name        = "Transit Log"
							source      = "PurchaseLineEditTransit.cfm?requisitionno={selectline}">			
							
					
			
		</tr>
		
				
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
		
		<tr>	
			<td style="padding-left:5px;padding-top:3px" class="labelmedium2">
			
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
			
			<cfoutput>
			<select name="selectline" id="selectline" class="regularXXL" 
			    onchange="_cf_loadingtexthtml='';ptoken.navigate('PurchaseLineEditForm.cfm?mode=#url.mode#&id='+this.value,'contentbox1')">
				<cfloop query="Lines">
				<option value="#RequisitionNo#" <cfif requisitionno eq url.id>selected</cfif>>#currentrow# #OrderitemNo#</option>
				</cfloop>	
			</select>
			</cfoutput>
				
			</td>
			
			</tr>
			
			<cfif receipts.recordcount gte "1">	
			<tr>
			<td class="labelmedium2" style="padding-right:30px" align="right">
			    <font color="FF0000">
					<b>Attention:</b> This line has been (partially) received.
				</font>
			</td>
			</tr>
			</cfif>
			
			</tr>
			
			<tr class="hide"><td id="result"></td></tr>			
			
	</table>
	
	</td>
</tr>		

<tr><td height="100%" style="padding-left:20px;padding-top:3px">

	<table width="100%" 
		  height="100%"		
		  align="center">	  
		
			<cf_menucontainer item="1" class="regular">
				<cfinclude template="PurchaseLineEditForm.cfm">
			</cf_menucontainer>
				
	</table>

	</td>
</tr>

</table>

<cf_screenbottom layout="webapp">