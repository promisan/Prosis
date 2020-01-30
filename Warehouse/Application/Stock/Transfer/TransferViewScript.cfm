
<cf_ajaxNavigate>

<cfoutput>

<!--- scripts is also in stockscript, we better move this centrally --->

<script>

function stocktransfer(s,modid,stockorderid,mission,whs) {

	pge = 1; 
				
	url = "#SESSION.root#/warehouse/application/stock/transfer/transferView.cfm?"+
				"&height="+document.body.offsetHeight+
				"&systemfunctionid="+modid+
	            "&warehouse="+whs+
				"&mission="+mis+
				"&page="+pge+				
				"&stockorderid="+stockorderid					
		
	 ptoken.navigate(url,'dialog')	
	}		
	 
	 
function trfsave(id,whsto,locto,meter,ini,fnl,qty,mem,itemuomid,dte,hr,mi) {
		whs  = document.getElementById("warehouse").value	 		
		mis  = document.getElementById("mission").value	
		url = "#SESSION.root#/warehouse/application/stock/Transfer/StockTransferSave.cfm?whs="+whs+"&id="+id+"&warehouse=" + whsto+"&location="+locto+"&quantity="+qty+"&meter="+meter+"&initial="+ini+"&final="+fnl+"&memo="+mem+"&itemuomid="+itemuomid+"&date="+dte+"&hour="+hr+"&minute="+mi		
		ptoken.navigate(url,'f'+id)			 				
	 }			  
	 
function trfsubmit(mis,modid,stockorderid) {		
	  	whs  = document.getElementById("warehouse").value	
		mis  = document.getElementById("mission").value					
		url  = "#SESSION.root#/warehouse/application/stock/Transfer/StockTransferSubmit.cfm?StockOrderid="+stockorderid+"&SystemFunctionId="+modid+"&tpe=8&mis="+mis+"&whs="+whs  	
		ptoken.navigate(url,'dialog','','','POST','transferform')				
	}	
		
</script>

</cfoutput>