
<cfoutput>

<cf_listingScriptNavigation>
<cf_listingscript>


<script>

    function itmloc() {
	  document.getElementById("filter").className = "hide";
	  ColdFusion.navigate('Location/Location.cfm?mission=#url.mission#&itemno=#url.id#','detail')	
	}
	
	 function itmvendor() {
	 	document.getElementById("filter").className = "hide";
		url = "Vendors/vendorListing.cfm?id=#URL.ID#&mission=#URL.Mission#";
		ColdFusion.navigate(url,'detail');
	}		
	
	 function itmedit(v,mid) {		  
	   url = "ItemViewEdit.cfm?idmenu="+mid+"&ID=#URL.ID#&mode=embed";
	   ColdFusion.navigate(url,'detail');  
	 }
	
	 function itmprice() {
	    document.getElementById("filter").className = "hide"	
		url = "Pricing/Pricing.cfm?id=#URL.ID#&mission=#URL.Mission#"
		ColdFusion.navigate(url,'detail')		 
	}
	
	 function itmaccount() {
	 ColdFusion.navigate('Ledger/Ledger.cfm?mission=#url.mission#&itemno=#url.id#','detail')	 
	}	
	// warehouse item settings //
	
	function itmlevel() {
	    document.getElementById("filter").className = "hide"	
		url = "StockLevel/StockMinMax.cfm?id=#URL.ID#&mission=#URL.Mission#"
		ColdFusion.navigate(url,'detail')	
	}
	
	function itmlevelsubmit() {
	   url = "StockLevel/StockMinMaxSubmit.cfm?id=#URL.ID#&mission=#URL.Mission#"	  
	   ColdFusion.navigate(url,'detail','','','POST','inputform')
	
	}
		
	// item receipts : to be reworked for a listing
			
	function stockonorder(s) {
		
    document.getElementById("filter").className   = "regular"	
	document.getElementById("optionselect").value = "itmonorder('r')"
	uom  = document.getElementById("unitofmeasure").value
	whs  = document.getElementById("warehouse").value	
	str  = document.getElementById("datestart").value	
	end  = document.getElementById("dateend").value	
	
	if (s == "") { 
	
		url = "#SESSION.root#/Procurement/Application/Requisition/RequisitionView/RequisitionViewView.cfm?ts="+new Date().getTime()+
				"&height="+document.body.offsetHeight+
	            "&id=WHS"+
				"&mission=#URL.mission#"+
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
				"&mission=#URL.mission#"+
				"&warehouse="+whs+
				"&itemno=#URL.ID#"+
				"&uom="+uom+
				"&str="+str+
				"&end="+end+
				"&page="+pge+
				"&sort="+grp;
	}		
	
	ColdFusion.navigate(url,'detail')		
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
			 ColdFusion.navigate('#SESSION.root#/Procurement/Application/Receipt/ReceiptEntry/ReceiptDetail.cfm?box=i'+box+'&reqno='+req+'&mode='+mode,'i'+box)	    
		 } else {	    
	     	 icM.className = "hide";
		     icE.className = "regular";
	     	 se.className  = "hide"	 
		 }
		 		
    }
		
	// stock level
			
	function stocklevel(s) {	
	    document.getElementById("filter").className = "hide"; 
		ColdFusion.navigate('#SESSION.root#/Warehouse/Maintenance/Item/Stock/ItemStock.cfm?mission=#url.mission#&mode=embed&id=#url.id#','detail')		
	}
				
	// item receipts
			
	function itmreceipt(s) {	
	    document.getElementById("filter").className = "hide"; 
		ColdFusion.navigate('Receipt/ReceiptListing.cfm?mission=#url.mission#&itemno=#url.id#','detail')		
	}
	
	// item transactions 
	
	function itmtransaction(s,sid) {	
	    document.getElementById("filter").className = "hide";	
		ColdFusion.navigate('Transaction/TransactionListing.cfm?mission=#url.mission#&systemfunctionid='+sid+'&itemno=#url.id#','detail')	 
	}	
	
	// item workorder earmark 
	
	function itmworkorder(s,sid) {	
	    document.getElementById("filter").className = "hide";	
		ColdFusion.navigate('WorkOrder/WorkOrderListing.cfm?mission=#url.mission#&systemfunctionid='+sid+'&itemno=#url.id#','detail')	 
	}	
	
	// item statistics for this mission 							
	
	function itmstatistic() {
	  ColdFusion.navigate('Statistics/Statistics.cfm?mission=#url.mission#&itemno=#url.id#','detail')	 
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
		
			
</script>
		
</cfoutput>