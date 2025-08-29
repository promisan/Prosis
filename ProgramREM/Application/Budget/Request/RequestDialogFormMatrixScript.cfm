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
<cfparam name="url.row"  default="1">
<cfparam name="url.rows" default="1">

<cfparam name="url.col"  default="1">
<cfparam name="url.cols" default="1">

<cfoutput>


<script>

<cfif url.col neq "0">

<!--- calculate horizontal --->

var total = 0 

<cfloop index="c" from="1" to="#url.cols#">
       
   try {	
       
	   se = document.getElementById("c#url.row#_#c#")	   	  
	   if (se.value != "") {
		   val = parseInt(se.value*10, 10);     		  
		   total = total+val	  
		  
		   } 
   } catch(e) {}
  
</cfloop>

document.getElementById("requestQuantity_#url.row#").value = total/10

<!--- calculate VERTICAL --->

<cfloop index="c" from="1" to="#url.cols#">

	var total = 0 

	<cfloop index="r" from="1" to="#url.rows#">
       
	   try {	
       
		   se = document.getElementById("c#r#_#c#")	   	  
		   if (se.value != "") {
			   val = parseInt(se.value*10, 10);   
			   total = total+val	
			   } 
	   } catch(e) {}
  
	</cfloop>
	document.getElementById("rtotal_#c#").value = total/10
	
</cfloop>

</cfif>

<!--- calculate oVERALL --->

var total  = 0 
var amount = 0

<cfloop index="r" from="1" to="#url.rows#">
       
   try {	
	   tot  = document.getElementById("requestQuantity_#r#").value
	   rate = document.getElementById("requestPrice_#r#").value
	   rate = rate.replace(/,/g,'');
	    	  
	   if (tot != "") {
	   			
	       val	  = parseInt(tot*10, 10);
		   total  = total+val	
		   rate	  = parseInt(rate*10, 10);
		   amount = amount+(val*rate)
		   
		} 
   } catch(e) {}
  
</cfloop>


ptoken.navigate('setAmount.cfm?total='+total/10+'&amount='+amount/100,'ctotal');

</script>


</cfoutput>
