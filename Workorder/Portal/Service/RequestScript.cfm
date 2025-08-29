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
<cfoutput>

<cfset link = "#session.root#/WorkOrder/Portal/">

<script>
	
function catsel(cat,row) {		
		
	 document.getElementById("class").value = cat		 	 	
	 count = 0	
	 tot   = document.getElementById("searchgroup").value
	  					 				 	   
	   while (count <= tot) {
		   try { 
			   rw = document.getElementById("1_"+count)
			   rw.className = "labelmedium"
			   rw = document.getElementById("2_"+count)
			   rw.className = "labelmedium"
		   	   } catch(e) {}
			   count++ 
		   }
		   
		   document.getElementById("1_"+row).className = "highlight labelmedium"
		   document.getElementById("2_"+row).className = "highlight labelmedium"					    			
	 list('1')				
    }			
	
function list(pg,mis) {		    
	cat = document.getElementById("class").value;		
	mis = document.getElementById("mission").value;		
	fnd = document.getElementById("find").value;			
	ColdFusion.navigate('#link#/Service/ItemList.cfm?mission='+mis+'&find='+fnd+'&category='+cat+'&page='+pg,'reqmain')	 
}

function add(item,unit) {      
	mis = document.getElementById("mission").value;			
	ColdFusion.navigate('#link#/Service/HistoryListLocate.cfm?mode=none','reqtop')
	ColdFusion.navigate('#link#/Service/CartAdd.cfm?mission='+mis+'&serviceitem=' + item + '&unit=' + unit,'reqmain')
}

function addtocart() {		
	mem = document.getElementById("memo").value;
	ColdFusion.navigate('#link#/Service/CartAddSubmit.cfm?remarks='+mem,'reqmain')		
}

function reqedit(id,qty) {	
	   if (parseFloat(qty)) {
	   ColdFusion.navigate('RequestEdit.cfm?id='+id+'&quantity='+qty,'amount_'+id)
	   } else  {
		  alert("You entered an incorrect quantity ("+qty+")")
	   }					
}

function cartedit(id,qty) {
	
	   if (parseFloat(qty)) {
	    ColdFusion.navigate('#link#/Service/CartEdit.cfm?id='+id+'&quantity='+qty,'reqmain')
	   } else  {
	   	  alert("You entered an incorrect quantity ("+qty+")")
	   }					
}

function cancelcart() {
	if (confirm("Do you want to empty your cart ?")) {
	cartpurge('all')		
	}
	return false
	
}	

function cartpurge(id) {
    ColdFusion.navigate('#link#/Service/CartPurge.cfm?id='+id,'reqmain')				
}

function reqpurge(id,line) {
	ColdFusion.navigate('#link#/Service/RequestPurge.cfm?ajaxid='+id+'&line='+line,'i'+id)							
}

function more(id) {
/*
	url = "#link#/Service/ServiceView.cfm?ajaxid="+id
	se = document.getElementById("b"+id)
	e = document.getElementById(id+"Exp")
	m = document.getElementById(id+"Min")
	if (se.className == "regular") {
		   se.className = "hide"
		   e.className = "regular"
		   m.className = "hide"
	} else {
		se.className = "regular"
		e.className = "hide"
		m.className = "regular"
		ColdFusion.navigate(url,'i'+id)	
    }
	*/
}

function cart() {    
    ColdFusion.navigate('#link#/Service/HistoryListLocate.cfm?mode=none','reqtop')
	ColdFusion.navigate('#link#/Service/Cart.cfm?id='+id,'reqmain')		    
}

function reqstatus(mode) {
    ColdFusion.navigate('#link#/Service/HistoryListLocate.cfm?mode='+mode,'reqtop')
	ColdFusion.navigate('#link#/Service/HistoryList.cfm?mode='+mode,'reqmain')		   
}

function reqstatusfilter(mode) {
	document.formfilter.onsubmit() 
	if( _CF_error_messages.length == 0 ) {
        ColdFusion.navigate('#link#/Service/HistoryList.cfm?mode='+mode,'reqmain','','','POST','formfilter')		
	 }   
}

function cartshow() {
	ColdFusion.navigate('CartShow.cfm','cartshow')					
}

function checkout() {	
    mis = document.getElementById("mission").value;	
	ColdFusion.navigate('#link#/Service/CartCheckout.cfm?mission='+mis+'&mode=checkout','reqmain')					
}

function doit(txt) {
	if (confirm(txt)) { 
    	ColdFusion.navigate('#link#/Service/CartCheckoutSubmit.cfm','submitcart','','','POST','cartcheckout')
	}			
}	

function undocheckout() {
	 mis = document.getElementById("mission").value;		
	 ColdFusion.navigate('#link#/Service/Main.cfm?mission='+mis,'detailcontent')								
}

</script>

</cfoutput>
