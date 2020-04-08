

<cfquery name = "HeaderSelect"
   datasource = "AppsQuery" 
   username   = "#SESSION.login#" 
   password   = "#SESSION.dbpw#">
    SELECT *
	FROM   #SESSION.acc#GledgerHeader_#client.sessionNo#
</cfquery>

<cfoutput query="HeaderSelect">
   <cfset traCat = TransactionCategory>
</cfoutput>

<cfoutput>

	<script language = "JavaScript">
	
	ie = document.all?1:0
	ns4 = document.layers?1:0	
	
	function hl(itm,fld,id){
			
	     if (ie){
	          while (itm.tagName!="TR")
	          {itm=itm.parentElement;}
	     }else{
	          while (itm.tagName!="TR")
	          {itm=itm.parentNode;}
	     }
			 	 	 		 	
		 if (fld != false){			 
			 itm.className = "highLight2 labelmedium";
			 try {		
			 document.getElementById("box_"+id+"_1").className = "labelit"
			 document.getElementById("box_"+id+"_2").className = "labelit"
			 document.getElementById("box_"+id+"_3").className = "labelit"
			 } catch(e) {}
			 
		 } else {			    
			 itm.className = "regular labelmedium";		
			 try {
			 document.getElementById("box_"+id+"_1").className = "hide"
			 document.getElementById("box_"+id+"_2").className = "hide"
			 document.getElementById("box_"+id+"_3").className = "hide"
			 } catch(e) {}			 
		 }
	  }  
	  
	function settotal(mode) { 	   
	   _cf_loadingtexthtml='';		 
	   ColdFusion.navigate('setTotal.cfm?mode='+mode,'total','','','POST','transactionheader')
	
	}
		
	function reloadReconciliation(group,page) {
        Prosis.busy('yes');			
		_cf_loadingtexthtml='';	
	    period = document.getElementById("accountperiod").value;		
	  	url = "TransactionDetailReconcile.cfm?ID1=" + group + "&Page=" + page;			
		ptoken.navigate(url,'lineentry')				
	}	
		
	function setline() {	        
		_cf_loadingtexthtml='';	
        contra = document.getElementById("glaccount").value;	
        url = "TransactionDetailReset.cfm?contraglaccount="+contra
		ptoken.navigate(url,'lines')				
	}	
		  
	function deleteline(trano) {			
		_cf_loadingtexthtml='';	
		Prosis.busy('yes')
        contra = document.getElementById("glaccount").value;	
        url = "TransactionDetailDelete.cfm?id="+trano+"&contraglaccount="+contra
		ptoken.navigate(url,'lines')				
	}
		
	function amountcalc(mode) {				
	    document.getElementById('entryadd').disabled = true
        acc    = document.getElementById('entryglaccount').value
        dte    = document.getElementById('transactiondateline').value
		amt    = document.getElementById("entryamount").value;		
		cur    = document.getElementById("entrycurrency").value;
		excj   = document.getElementById("entryexcjrn").value;
		excb   = document.getElementById("entryexcbase").value;					
		_cf_loadingtexthtml='';	
							
		ColdFusion.navigate('TransactionDetailEntryCalc.cfm?journal=#url.journal#&glaccount='+acc+'&date='+dte+'&entryamount='+amt+'&mode='+mode+
				'&entrycurrency='+cur+
				'&entryexcjrn='+excj+
				'&entryexcbase='+excb,'amountdetail')				       			 
	   }
		
	function enable_button() {
			try { document.getElementById('entryadd').disabled  = false } catch(e) {}
			try { document.getElementById('entryedit').disabled = false } catch(e) {}
		}

		var delay = (function(){
		  var timer = 0;
		  return function(callback, ms){
		    clearTimeout (timer);
		    timer = setTimeout(callback, ms);
		  };
		})();
		
		// $( document ).ready(function() {
		//	$("##entryamount").keyup(function( event ) {
		//		delay(function(){
		//		   amountcalc('0');
		//		}, 2 );				
		//	})
		// });		
				
	</script>

</cfoutput>

<cfajaximport tags="cfform">

<cfoutput query="HeaderSelect">

   <cfswitch expression="#TransactionCategory#">
   
     <cfcase value="Payment">
	 
		 <cfset sc = "Payment">	 
		 <cfinclude template="TransactionDetailScript.cfm">
					
				<cfset wd = "68">
				<cfset ht = "68">
			
				<cf_tl id="Manual Transaction Entry" var="1">
				
				<cfset itm = "1">
				
				<tr class="line">
					
				<cf_menutab item       = "#itm#" 
				            iconsrc    = "Manual-Entry.png" 
							iconwidth  = "#wd#" 
							iconheight = "#ht#" 
							class      = "highlight1"
							targetitem = "1"
							name       = "#lt_text#"
							source     = "">		
							
				 </tr>			
							
				 <!--- this option is not enabled the moment we determine that this transaction has been 
				 partially reconciled --->
				 
												
				<!--- ----------------------------------------------------------------- --->
				<!--- also check if the transaction has been somehow reconciled already --->
				<!--- ----------------------------------------------------------------- --->
								
				<cfquery name="CheckReconcile" 
				    datasource="AppsLedger" 
				    username="#SESSION.login#" 
				    password="#SESSION.dbpw#">
						SELECT *
						FROM   TransactionLine
						WHERE  ParentLineId IN (  SELECT TransactionLineId
												  FROM   TransactionLine
												  WHERE  Journal               = '#HeaderSelect.Journal#'
												  AND    JournalSerialNo       = '#HeaderSelect.JournalSerialNo#'									  
												  AND    TransactionSerialNo   = '0' )										
				</cfquery>
				
				<cfif checkReconcile.recordcount eq "0">		
				
					<cfset itm = itm+1>	
								
					<cf_tl id="Select Pending Payable Transactions" var="1">			
					
					<tr class="line">		
									
					<cf_menutab item       = "#itm#" 
					            iconsrc    = "Pending-Payments.png" 
								iconwidth  = "#wd#" 
								iconheight = "#ht#" 
								targetitem = "2"
								name       = "#lt_text#"
								source     = "TransactionDetailPayment.cfm?journal=#url.journal#">
					 </tr>
					 		
				</cfif> 	
				
				<cfset itm = itm+1>	
					
				<tr class="line">			
				<cf_menutab item       = "#itm#" 
				            iconsrc    = "Detail.png" 
							iconwidth  = "#wd#" 
							targetitem = "2"
							iconheight = "#ht#" 
							name       = "Preview Transaction Result"
							source     = "TransactionDetailPreview.cfm?mission=#url.mission#&accountperiod={accountperiod}">	
							
				</tr>			
			  				 
	 </cfcase>
	 
	 <cfcase value="Banking">
	 
		 <cfset sc = "Reconcile">	
		 <cfinclude template="TransactionDetailScript.cfm">
		 
		 <cfset wd = "54">
		 <cfset ht = "54">
			
		 <cf_tl id="Manual Transaction Entry" var="1">
			<tr>		
			<cf_menutab item       = "1" 
	            iconsrc    = "Manual-Entry.png" 
				iconwidth  = "#wd#" 
				iconheight = "#ht#" 
				class      = "highlight1"
				targetitem = "1"
				name       = "#lt_text#"
				source     = "">		
			</tr>		
			<cf_tl id="Pending Payables" var="1">		
			<tr>					
			<cf_menutab item       = "2" 
	            iconsrc    = "Pending-Payments.png" 
				iconwidth  = "#wd#" 
				iconheight = "#ht#" 
				targetitem = "2"
				name       = "#lt_text#"
				source     = "TransactionDetailReconcile.cfm?mode=AP">
			</tr>	
			<cf_tl id="Pending Payment Orders" var="1">		
			<tr>					
			<cf_menutab item       = "3" 
	            iconsrc    = "Payment-Orders.png" 
				iconwidth  = "#wd#" 
				iconheight = "#ht#" 
				targetitem = "2"
				name       = "#lt_text#"
				source     = "TransactionDetailReconcile.cfm?mode=PO">
			</tr>	
			<cf_tl id="Pending Receivables" var="1">		
			<tr>					
			<cf_menutab item       = "4" 
	            iconsrc    = "Receivable-Payments.png" 
				iconwidth  = "#wd#" 
				iconheight = "#ht#" 
				targetitem = "2"
				name       = "#lt_text#"
				source     = "TransactionDetailReconcile.cfm?mode=AR">		
			</tr>				
			<tr>
			<cf_menutab item       = "5" 
		       iconsrc    = "Detail.png" 
			   iconwidth  = "#wd#" 
			   targetitem = "2"
			   iconheight = "#ht#" 
			   name       = "Preview Posting"
			   source     = "TransactionDetailPreview.cfm?mission=#url.mission#&accountperiod={accountperiod}">			
			 </tr>  
			
	 </cfcase>
	 
     <cfdefaultcase>
	 
		 <cfset sc = "">	
		 <cfinclude template="TransactionDetailScript.cfm">		 
				 
		 <cfset wd = "64">
		 <cfset ht = "64">
		 
		 <cf_tl id="Manual Transaction Entry" var="1">
			<tr>		
			<cf_menutab item = "1" 
		            iconsrc    = "Manual-Entry.png" 
					iconwidth  = "#wd#" 
					iconheight = "#ht#" 
					class      = "highlight1"
					targetitem = "1"
					name       = "#lt_text#"
					source     = "">									
			</tr>
			<tr>
			<cf_menutab item = "2" 
		            iconsrc    = "Detail.png" 
					iconwidth  = "#wd#" 
					targetitem = "2"
					iconheight = "#ht#" 
					name       = "Preview Posting"
					source     = "TransactionDetailPreview.cfm?mission=#url.mission#&accountperiod={accountperiod}">			
		  	<tr> 
				 
	  </cfdefaultcase>  
   </cfswitch>
   
</cfoutput>

