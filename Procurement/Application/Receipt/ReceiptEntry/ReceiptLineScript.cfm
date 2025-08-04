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

<!--- diabled 5/5/2012
<cf_ajaxRequest>
--->

<script>

function res(tpe) {
	
	// itm = document.getElementById("itemno");
	// itm.value = ""
	// itm = document.getElementById("itemdescription");
	// itm.value = ""
	
	se1 = document.getElementById("whs");
	se2 = document.getElementById("whs1");
	se3 = document.getElementById("whs2");
	se4 = document.getElementById("uom1");
	se5 = document.getElementById("whs3");
					
	if (tpe == "regular") {	
		
	  se1.className = "hide";
	  se2.className = "regular";
	  se3.className = "hide";
	  se4.className = "regular";
	  se5.className = "hide";
	  
	} else {
	
	  if (tpe == "generate") {	
	  
		  se1.className = "regular";
		  se2.className = "hide";
		  se3.className = "hide";
		  se4.className = "hide";
		  se5.className = "regular";
	  
	  } else {
	  	  	  
		  se1.className = "regular";
		  se2.className = "hide";
		  se3.className = "regular";
		  se4.className = "hide";	  
		  se5.className = "hide"; 
    	}
	}

}

function setval(s,field) {

	z = document.getElementById(field)

	   var i = s.indexOf('.')
	   if (i < 0) {
    	 z.value = s + ".00" ;
	  } else {
	    var t = s.substring(0, i + 1) + s.substring(i + 1, i + 3);
    	if (i + 2 == s.length) {
		   t += "0";
	   } else {
		if (i + 1 == s.length) {
	   		t += "00";
	   		}
	   }   
    z.value = t; 
	}	
}


function calc(amt,receiptprice,z,t,i,e,exm) {

<cf_tl id="The value" var="vPrice">
<cf_tl id="is not a number" var="vNaN">
<cf_tl id="Operation not allowed" var="vOperation">
<cfoutput>
    if ( isNaN(receiptprice) ) {
        alert('#vPrice# '+receiptprice+' #vNaN#. #vOperation#.');
        return;
    }
</cfoutput>

var regEx = new RegExp(',','g')               		//define regular expression to match comma (',') string



// var price = receiptprice.replace(regEx,'')         	//replace comma with empty string in currency if exists
// setval(price,'receiptprice')
// setval(receiptprice,'receiptprice')

var price = receiptprice
document.getElementById('receiptprice').value = receiptprice

// hide summary

se = document.getElementsByName("pricesum")

if (exm == "1") {
   se[0].className = "hide"
   se[1].className = "hide"
} else {
   se[0].className = "regular"
   se[1].className = "regular"
}

// var x = CurrencyFormat(receiptprice)
// setval(x,'receiptpriceShow')

var tax = t - 0

<!--- extended price --->
var s = " "+Math.round((amt*price)*100) / 100

setval(s,'extprice')
var x = CurrencyFormat(s)
setval(x,'extpriceShow')

<!--- extended discount price --->
var s = " " + Math.round((amt*price*(100-z))) / 100
var base = (amt*price*(100-z))

setval(s,'discextprice')
var x = CurrencyFormat(s)
setval(x,'discextpriceShow')

<!--- cost price --->
if (i == 1) { 
   var c = " " + Math.round(base*(100/(100+tax))) / 100
} else { 
  var c = " " + Math.round(base) / 100
}
setval(c,'costprice')  
      
<!--- tax price --->
if (i == 1) { 
   var t = " " + Math.round(base*(tax/(100+tax))) / 100
} else { 
   var t = " " + Math.round(base*tax/100) / 100
}
setval(t,'taxprice')    
    	 
<!--- cost priceB --->
if (i == 1) 
     { var cb = " " + Math.round((base*(100/(100+tax))/e)) / 100}
else { var cb = " " + Math.round(base/e) / 100}

setval(cb,'costpriceb')  
  
<!--- tax priceB --->
if (i == 1) 
     { var tb = " " + Math.round((base*(tax/(100+tax)))/e) / 100 }
else { var tb = " " + Math.round((base*tax/100)/e) / 100 }

setval(tb,'taxpriceb')    

<!--- payable --->  
if (exm == 1) {
	   setval(c,'pay')
	   setval(cb,'payB')
	} else {
	   if (i == 1) {
		   var a = " " + Math.round(base) / 100	   
		   setval(a,'pay')	  
		   var a = " " + Math.round(base/e) / 100	
		   setval(a,'payB')
	   } else {
	       var a = " " + ((Math.round(base)/100) + (Math.round(base*tax/100) / 100))	   
		   setval(a,'pay')	  
		   var a = " " + ((Math.round((base)/e)/100) + (Math.round((base*tax/100)/e) / 100))
		   setval(a,'payB')
	   }		  
	} 
     	 	 
} 

function CurrencyFormat(amount) {

	// created a comma seperated currency amount
	var objRegExp = new RegExp('(-?\[0-9]+)([0-9]{3})');
	
	while(objRegExp.test(amount)) amount = amount.toString().replace(objRegExp,'$1,$2');
	
	return amount

}
  
function free(chk) {

if (chk) { 
	calc('0','0','0','0','1','1');
	setval('0','receiptprice') 
	z = document.getElementById("receiptprice")
	z.disabled = true
	} 
else { z.disabled = false }	

}

function nofree() {
   z = document.getElementById("receiptzero")
   z.checked = false
}

function exch(cur,cost,tax,pay) {
			
	itm = document.getElementById("exchangerate_"+cur);	
	des = document.getElementById("exchangerate");
	
	des.value = itm.value;
			
	<!--- cost priceB --->
	var s = " " + Math.round(cost*100/des.value) / 100		
	var x = CurrencyFormat(s)		
	setval(x,'costpriceb')		
	<!--- cost priceB --->
	var s = " " + Math.round(tax*100/des.value) / 100	  
	var x = CurrencyFormat(s)
	setval(x,'taxpriceb')
	
	<!--- cost priceB --->
	var s = " " + Math.round(pay*100/des.value) / 100	  
	var x = CurrencyFormat(s)
	
	setval(x,'payB')

}
	
function tax(t) {		
	itm = document.getElementById("taxincl");
	itm.value = t;
}	

</script>