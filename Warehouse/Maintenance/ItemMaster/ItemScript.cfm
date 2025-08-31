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
<cf_listingscript>

<script>

	 function itmedit(s,sid) {		  	    
	    url = "ItemViewEdit.cfm?idmenu="+sid+"&ID=#URL.ID#&mode=embed";
		document.getElementById('optionselect').value = ""		
	    ptoken.navigate(url,'detail');  
	 }
	 
	 function itmuom(s,sid) {		  	    
	    url = "../Item/UoM/ItemUoM.cfm?id=#url.id#&mode=embed&idmenu="+sid;		
		document.getElementById('optionselect').value = ""
	    ptoken.navigate(url,'detail');  
	 }
	 
	 function applymenu() {	   
	 	fun = document.getElementById('optionselect').value		
		if (fun != "") {		 
		   document.getElementById('opt_'+fun).click()		   
		}  
	 }
	 
	 <!--- mission senstive --->
	 
	 function itmloc(s,sid) {
	    mis = document.getElementById('mission').value				
	    document.getElementById("filter").className = "hide";
		document.getElementById('optionselect').value = sid		
		_cf_loadingtexthtml='';	
	    ptoken.navigate('Location/Location.cfm?mission='+mis+'&itemno=#url.id#','detail')	
	}
	
	 function itmvendor(s,sid) {	    
	    mis = document.getElementById('mission').value		
	 	document.getElementById("filter").className = "hide";
		document.getElementById('optionselect').value = sid		
		url = "Vendors/vendorListing.cfm?id=#URL.ID#&mission="+mis+"&systemfunctionid="+sid
		_cf_loadingtexthtml='';	
		ptoken.navigate(url,'detail');
	}		
	
	function itmacquisition(s,sid) {
	    
		mis = document.getElementById('mission').value		
	 	document.getElementById("filter").className = "hide";
		document.getElementById('optionselect').value = sid		
		url = "StockLevel/ItemUoM.cfm?id=#URL.ID#&mission="+mis+"&systemfunctionid="+sid
		_cf_loadingtexthtml='';	
		ptoken.navigate(url,'detail');
	
	}
	
	 function itmonorder(s,sid) {	    
	 
	    mis = document.getElementById('mission').value		
	 	document.getElementById("filter").className = "hide";
		document.getElementById('optionselect').value = sid		
		url = "Requisition/RequisitionListing.cfm?itemno=#URL.ID#&mission="+mis+"&systemfunctionid="+sid
		_cf_loadingtexthtml='';	
		ptoken.navigate(url,'detail');
	}		
	 
	 function recorduomedit(itm,uom) {	
	    if (uom == '') {
			wd = 1150
		    ht = 680
	 		ptoken.open("#session.root#/Warehouse/Maintenance/Item/UoM/ItemUoMEditTab.cfm?id="+itm+"&uom="+uom,itm, "left=20, top=20, width="+wd+", height="+ht+",menubar=no, toolbar=no, status=yes, scrollbars=no, resizable=yes");
		} else {
		ptoken.open("#session.root#/Warehouse/Maintenance/Item/UoM/ItemUoMEditTab.cfm?id="+itm+"&uom="+uom,itm);		
		}
	}
	
	 function itmprice(s,sid) {
	    document.getElementById("filter").className = "hide"	
		mis = document.getElementById('mission').value		
		document.getElementById('optionselect').value = sid		
		url = "Pricing/Pricing.cfm?id=#URL.ID#&mission="+mis+"&systemfunctionid="+sid;
		_cf_loadingtexthtml='';	
		ptoken.navigate(url,'detail')		 
	}
	
	 function itmaccount(s,sid) {
	    ptoken.navigate('Ledger/Ledger.cfm?mission='+mis+'&itemno=#url.id#','detail')	 
	}	
	// warehouse item settings //
	
	function itmlevel(s,sid) {
	    document.getElementById("filter").className = "hide"	
		mis = document.getElementById('mission').value	
		document.getElementById('optionselect').value = sid
		_cf_loadingtexthtml='';	
		url = "StockLevel/StockMinMax.cfm?id=#URL.ID#&mission="+mis
		ptoken.navigate(url,'detail')	
	}
	
	//stock level, JQUERY needed
	
	function toggleStockLevelWarehouse(w) {
		if ($('##trDetail_'+w).is(':hidden')) {
			$('##trDetail_'+w).css({'display':'block'});
			$('##twistie_'+w).attr('src', '#SESSION.root#/Images/arrowdown.gif');
		}else{
			$('##trDetail_'+w).css({'display':'none'});
			$('##twistie_'+w).attr('src', '#SESSION.root#/Images/arrow.gif');
		}
	}
	
	function toggleAllStockLevelWarehouse() {
		if ($('.trDetail').is(':hidden')) {
			$('.trDetail').css({'display':'block'});
			$('.twistie').attr('src', '#SESSION.root#/Images/arrowdown.gif');
			$('##twistie').attr('src', '#SESSION.root#/Images/collapse1.gif');
		}else{
			$('.trDetail').css({'display':'none'});
			$('.twistie').attr('src', '#SESSION.root#/Images/arrow.gif');
			$('##twistie').attr('src', '#SESSION.root#/Images/expand1.gif');
		}
	}		
	
	function itmlevelsubmit() {
	   mis = document.getElementById('mission').value
	   url = "StockLevel/StockMinMaxSubmit.cfm?id=#URL.ID#&mission="+mis	  
	   ptoken.navigate(url,'detail','','','POST','inputform')
	
	}
	
	function itmtopicsubmit() {
	   mis = document.getElementById('mission').value
	   url = "StockLevel/ItemUoMTopicSubmit.cfm?id=#URL.ID#&mission="+mis	  
	   ptoken.navigate(url,'detail','','','POST','uomform')
	
	}
		
	// item receipts : to be reworked for a listing
			
	function stockonorder(s,sid) {
		
	    document.getElementById("filter").className   = "regular"	
		document.getElementById('optionselect').value = sid
		
		uom  = document.getElementById("unitofmeasure").value
		whs  = document.getElementById("warehouse").value	
		str  = document.getElementById("datestart").value	
		end  = document.getElementById("dateend").value	
		mis  = document.getElementById('mission').value
					
		if (s == "") { 
		
			url = "#SESSION.root#/Procurement/Application/Requisition/RequisitionView/RequisitionViewView.cfm?ts="+new Date().getTime()+
					"&height="+document.body.offsetHeight+
		            "&id=WHS"+
					"&mission="+mis+
					"&warehouse="+whs+
					"&itemno=#URL.ID#"+
					"&uom="+uom+
					"&str="+str+
					"&end="+end
		} else {	
		
			pge  = document.getElementById("page").value
			grp  = document.getElementById("sort").value	
			
			url = "#SESSION.root#/Procurement/Application/Requisition/RequisitionView/RequisitionViewView.cfm?"+
					"&height="+document.body.offsetHeight+
		            "&id=WHS"+
					"&mission="+mis+
					"&warehouse="+whs+
					"&itemno=#URL.ID#"+
					"&uom="+uom+
					"&str="+str+
					"&end="+end+
					"&page="+pge+
					"&sort="+grp;
		}		
		
		ptoken.navigate(url,'detail')		
	}
	
	// show receipts in requisition detail 
	
	function more(box,req,act,mode) {
		
		document.getElementById("filter").className = "hide";					
		icM  = document.getElementById(box+"Min")
		icE  = document.getElementById(box+"Exp")
		se   = document.getElementById(box);
			 		 
		if (act=="show") {	 
	     	 icM.className = "regular";
		     icE.className = "hide";
			 se.className  = "regular";
			 ptoken.navigate('#SESSION.root#/Procurement/Application/Receipt/ReceiptEntry/ReceiptDetail.cfm?box=i'+box+'&reqno='+req+'&mode='+mode,'i'+box)	    
		 } else {	    
	     	 icM.className = "hide";
		     icE.className = "regular";
	     	 se.className  = "hide"	 
		 }
		 		
    }
		
	// stock level
			
	function stocklevel(s,sid) {	
	    document.getElementById("filter").className = "hide"; 
		mis = document.getElementById('mission').value			
		document.getElementById('optionselect').value = sid
		ptoken.navigate('#SESSION.root#/Warehouse/Maintenance/Item/Stock/ItemStock.cfm?mission='+mis+'&mode=embed&id=#url.id#','detail')		
	}
				
	// item receipts
			
	function itmreceipt(s,sid) {	
	    document.getElementById("filter").className = "hide"; 		
		mis = document.getElementById('mission').value		
		document.getElementById('optionselect').value = sid
		ptoken.navigate('Receipt/ReceiptListing.cfm?mission='+mis+'&itemno=#url.id#&systemfunctionid='+sid,'detail')		
	}
	
	// item transactions 
	
	function itmtransaction(s,sid) {	
		// alert(sid)
	    document.getElementById("filter").className = "hide";	
		mis = document.getElementById('mission').value		
		document.getElementById('optionselect').value = sid
		ptoken.navigate('Transaction/TransactionListing.cfm?mission='+mis+'&systemfunctionid='+sid+'&itemno=#url.id#','detail')	 
	}	
	
	// item workorder earmark 
	
	function itmworkorder(s,sid) {	
	    document.getElementById("filter").className = "hide";	
		mis = document.getElementById('mission').value	
		document.getElementById('optionselect').value = sid
		ptoken.navigate('WorkOrder/WorkOrderListing.cfm?mission='+mis+'&systemfunctionid='+sid+'&itemno=#url.id#','detail')	 
	}	
	
	// item statistics for this mission 							
	
	function itmstatistic(s,sid) {
	   mis = document.getElementById('mission').value	   
	   document.getElementById('optionselect').value = sid
	   ptoken.navigate('Statistics/Statistics.cfm?mission='+mis+'&itemno=#url.id#','detail')	 
	}
			
</script>
		
</cfoutput>