
<cf_screentop height="100%" close="parent.ColdFusion.Window.destroy('myline',true)" scroll="Yes" jQuery="Yes" label="Purchase Line" html="no" layout="webapp" banner="gray">

<cfparam name="URL.Mode" default="view">
<cfparam name="URL.Id" default="{7D33F6FA-3711-414D-98A8-D849000A49BB}">

<cfinclude template="../Travel/TravelScript.cfm">

<cfoutput>

	<cfajaximport tags="cfwindow,cfform,cfdiv">

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

	
</script>

<cf_menuscript>

<table width="100%" height="100%" cellspacing="0" cellpadding="0">

<tr><td style="padding-top:1px;padding-left:24px">

	<table width="100%" 
	      border="0"
		  height="100%"
		  cellspacing="0" 
		  cellpadding="0" 
		  align="center">	  
	 		
			<tr>		
			
				<cfset wd = "54">
				<cfset ht = "54">			
						
				<cf_menutab item        = "1" 
				            iconsrc     = "Logos/Procurement/Edit.png" 								
							type        = "Vertical"
							iconwidth   = "#wd#"
							iconheight  = "#ht#"
							class       = "highlight"
							name        = "Edit Purchase Line"
							source      = "PurchaseLineEditForm.cfm?mode=#url.mode#&id=#url.id#">			
								
				<cf_menutab item        = "2" 
				            iconsrc     = "Logos/Procurement/Log.png" 								
							type        = "Vertical"
							targetitem  = "1"
							iconwidth   = "#wd#"
							iconheight  = "#ht#"
							name        = "Amendment Log"
							source      = "PurchaseLineEditLog.cfm?requisitionno=#url.id#">
							
			<td width="20%"></td>				
			
		</tr>
			
	</table>
	
	</td>
</tr>		

<tr><td height="100%" style="padding-top:6px">

	<table width="100%" 
	      border="0"
		  height="100%"
		  cellspacing="0" 
		  cellpadding="0" 
		  align="center" 
	      bordercolor="d4d4d4">	  
		
			<cf_menucontainer item="1" class="regular">
				<cfinclude template="PurchaseLineEditForm.cfm">
			</cf_menucontainer>
				
	</table>

	</td>
</tr>

</table>

<cf_screenbottom layout="webapp">