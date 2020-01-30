
<cf_DialogProcurement>

<cfoutput>

<script>

	function showclass(box,val,id,invid) {
	
	    <cfif Parameter.EnablePurchaseClass eq "1"> 
				
		 document.getElementById(box+"_box").className = "regular"
		 
	     url = "#SESSION.root#/Procurement/Application/Invoice/InvoiceEntry/InvoiceEntryMatchRequisitionClass.cfm?val="+val+
					 "&box="+box+
					 "&requisitionno="+id+
					 "&invoiceid="+invid
					 
		ColdFusion.navigate(url,box+'_class')
			
	   </cfif>
			
	 }
	 
	function drillinvoice(box,req) {
	
		se =  document.getElementById(box+"_box") 
	    if ( se.className == "hide" ) {	
	       se.className = "regular"		 
	    url = "#SESSION.root#/Procurement/Application/Invoice/InvoiceEntry/InvoiceEntryMatchRequisitionDrill.cfm?requisitionno="+req+"&box="+box									 
		ColdFusion.navigate(url,box+'_class')
		} else {
		se.className = "hide"
		}
	
	}

	function showtotal(invid,tot) {

		count = 1	
		val   = ""
		icM   = document.getElementById('icomments');
		
		while (count <= tot) {
			try { 		
			if (document.getElementById("req"+count).value != '0.00')
				val = val+";"+document.getElementById("req"+count).value 
			}
			catch(e) {}			
			count++
		}		
		
		var _requests = document.getElementById('_requests');
		_requests.value = val;		
		
		url = "#SESSION.root#/Procurement/Application/Invoice/InvoiceEntry/InvoiceEntryMatchRequisitionSum.cfm?invoiceid="+invid;
		se = document.getElementById('processaction')
		if (se) {
		ColdFusion.navigate(url,'totalsum','','','POST','processaction')		
		} else {
		ColdFusion.navigate(url,'totalsum','','','POST','forminvoice')		
		}
		ColdFusion.navigate('#SESSION.root#/Procurement/Application/Invoice/Workflow/MarkDown/DocumentMemoSingle.cfm?invoiceId='+invid,'icomments')			 				 
	}	
	
	function calctotal(invid,cnt) {
	
	    count = 0	
		val = ""	
		se = document.getElementsByName("invoicelineid")	
				
		while (count < cnt) {
		 		 
		  if (se[count].checked) {
		  
		  val = val+";"+se[count].value  		  
		  }
		  count++
		}			
								
		url = "#SESSION.root#/Procurement/Application/Invoice/InvoiceEntry/InvoiceEntryMatchRecalculation.cfm?invoiceid="+invid+"&vallist="+val
		ColdFusion.navigate(url,'totalsum')		
	
	}
	

function showExp(act,invid) {

	icM  = document.getElementById('icomments');		

	if (act=="show") {
 	     icM.className = "regular";
		 ColdFusion.navigate('#SESSION.root#/Procurement/Application/Invoice/Workflow/MarkDown/DocumentMemoSingle.cfm?invoiceId='+invid,'icomments')		 		  		 
	} else {
		 icM.className = "hide";	
	}
}

function saveMemo(vinv,vmemo) {

	text=document.getElementById('InvoiceMemo');
	vtext=text.value;
	ColdFusion.navigate('#SESSION.root#/Procurement/Application/Invoice/Workflow/MarkDown/DocumentMemoSingle.cfm?InvoiceId='+vinv+'&memoid='+vmemo+'&InvoiceMemo='+vtext,'icomments');
	
}

function DeleteMemo(vinv,vmemo) {
	ColdFusion.navigate('#SESSION.root#/Procurement/Application/Invoice/Workflow/MarkDown/DocumentMemoSingle.cfm?InvoiceId='+vinv+'&memoid='+vmemo+'&Action=delete','icomments');	
}

</script>

</cfoutput>