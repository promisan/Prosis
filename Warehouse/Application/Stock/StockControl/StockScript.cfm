

<!--- ------------------------------------------- --->
<cf_dialogMaterial>
<cf_dialogAsset>
<cf_dialogProcurement>
<cf_menuscript>  <!--- the top banner menu --->
<cf_calendarscript>
<cf_calendarviewscript>
<cf_textareascript>

<!---
<cf_presentationscript>
--->

<cf_AuthorizationScript>
<cf_AnnotationScript>
<cf_dialogSettlement>
<cf_dialogstaffing>

<!--- used for process transaction and receipts --->
<cf_listingscript     mode="limited">
<cf_FileLibraryScript mode="limited">

<cf_ActionListingScript>
<cf_KeyPadScript>


<!--- ------------------------------------------- --->

<style>
	.active_color {
		background-color:#3C5AAB !important;
		color:#FFFAF0 !important;
		font-weight:bold !important;
	}
	
	.over_color {
		background-color:#f1f1f1 !important;
		color:#000000 !important;
	}
	
	.clear_color {
		background-color:#ffffff !important;
		color:#000000 !important;
		font-weight:normal !important;
	}
</style>

<cfoutput>

<cf_tl id="Under development" var="1">
<cfset tDev="#lt_text#">

<cf_tl id="Do you want to post this transaction batch" var="1" class="Message">
<cfset tConfirm="#lt_text#">

<cf_tl id="You must identify a requesting unit." var="1">
<cfset tRequesting="#lt_text#">

<cf_tl id="No lines were selected" var="1">
<cfset tNoLines="#lt_text#">

<cf_tl id="Your Procurement Request has been submitted" var="1" Class="Message">
<cfset tRequest="#lt_text#">

<cf_tl id="Do you want to upload the PDF submitted logsheet" var="1">
<cfset vPDF = "#lt_text#">

<cf_tl id="click to hide price definition" var="1">
<cfset vHidePrice = "#lt_text#">

<cf_tl id="click to show price definition" var="1">
<cfset vShowPrice = "#lt_text#">

<cf_tl id="Do you want to submit these values and make the transfer" var="1">
<cfset vQuestionSubmitTransfer = "#lt_text#">

<cf_tl id="This action will create a price for the whole entity with these definitions" var="1">
<cfset warningApplyEntity1="#lt_text#">

<cf_tl id="Do you want to continue ?" var="1">
<cfset warningApplyEntity2="#lt_text#">

<cf_tl id="Opening and closing meter readings must be entered." var="1">
<cfset meterReadingErrorMessage1="#lt_text#">

<cf_tl id="Closing meter reading must be greater or equal to the opening meter reading." var="1">
<cfset meterReadingErrorMessage2="#lt_text#">

<cf_tl id="Closing meter date must be greater or equal to the opening meter date." var="1">
<cfset meterReadingErrorMessage3="#lt_text#">

<cf_tl id="Role actor must be defined." var="1">
<cfset meterReadingErrorMessage4="#lt_text#">

<cf_tl id="Do you want to submit the transaction ?" var="1">
<cfset meterReadingConfirm="#lt_text#">

<cf_tl id="Full view" var="1">
<cfset vFullView = "#lt_text#">

<cf_tl id="Menu view" var="1">
<cfset vMenuView = "#lt_text#">

<cf_tl id="Not a valid value!" var="vforceSelectMessage1">
<cf_tl id="Please select/create a valid value for this field." var="vforceSelectMessage2">
<cf_tl id="Please select a valid customer" var="vValidCustomerMessage"> 

<cfajaxproxy cfc="service.process.materials.WarehouseTime" jsclassname="LocationTime">

<cf_PrinterScript>

<script>

// added to show it in a full view 

function setCursor(){
	// $('input[name=TransactionQuantity_1]').focus();	
	$('input[name=ItemSelect]').focus();	
}

function printSale(cus,whs,bat,ter) {	
    ProsisUI.createWindow('wreprint', 'Re-Print', '',{x:100,y:100,width:870,height:620,resizable:false,modal:true,center:true})		
	ptoken.navigate('#SESSION.root#/Warehouse/Application/Salesorder/POS/Settlement/SaleInvoiceRePrint.cfm?warehouse='+whs+'&terminal='+ter+'&customerid='+cus+'&batchid='+bat,'wreprint');	
}

function stockfullview() {
	if ($('##theHeader').is(':visible')) {
		parent.enableBorderSection("mybox", "left", false);
		parent.enableBorderSection("mybox", "header", false);
	}else {
		parent.enableBorderSection("mybox", "left", true);
		parent.enableBorderSection("mybox", "header", true);
		parent.collapseArea("mybox", "leftmenu");
	}
}
		
function validate() {
	document.formperson.onsubmit() 
	if( _CF_error_messages.length == 0 ) {			
       	ptoken.navigate('#SESSION.root#/warehouse/application/stock/Transaction/setPersonSubmit.cfm','personresult','','','POST','formperson')
    }   
}	

function time_refresh(whs) {
 
	if (document.getElementById('arefresh').checked) {	
		var t = new LocationTime()
	 	t.setCallbackHandler(setTimeHandler); 
	    t.setErrorHandler(errorHandler); 	
		if (whs == '')
			whs = $("##warehouse").val();
		var Time = t.getLocationTime(whs);	
		$("##TransactionDate").val($("##itoday").val());			
	} 	
}

function setTimeHandler(resp) {
	var aresponse = resp.split(",");
	$("##Transaction_hour").val(aresponse[0]);
	$("##Transaction_minute").val(aresponse[1]);
	$('##dhour').html(aresponse[0]+'&nbsp;');
	$('##dminute').html(aresponse[1]+'&nbsp;&nbsp;&nbsp;');
}

function errorHandler(statusCode,statusMsg) {
	 alert(statusCode+': '+statusMsg)
}

function datetimemode(whs) {

	if ($("##arefresh").prop('checked')) {
		$("##Transaction_hour").hide();
		$("##Transaction_minute").hide();
		$("##dhour").show();
		$("##dminute").show();		
		$("##dTransactionDate").hide();
		$("##dtoday").show();		
		time_refresh(whs)  // only time not the date is refreshed
				
	} else {
	
		$("##Transaction_hour").show();
		$("##Transaction_minute").show();
		$("##dTransactionDate").show();
		$("##dtoday").hide();
		$("##dhour").hide();
		$("##dminute").hide();				
	}	
}

	
function importpdf(file) {

  if (confirm("#vPDF#?")) {      
	  var vwarehouse = $("##warehouse").val();	    	  
	  var vlocation  = $("##location").val();	    	  
	  var vmode      = $("##mode").val();	    	  	  
      ptoken.navigate('../Transaction/TransactionLogSheetPDFSubmit.cfm?pdfform='+file+'&warehouse='+vwarehouse+'&location='+vlocation+'&mode='+vmode,'detail','','','POST','transactionform')  
  }
}

function locationitem(id) {
	ptoken.open("#SESSION.root#/Warehouse/Maintenance/WarehouseLocation/LocationItemUoM/ItemUoMEdit.cfm?drillid="+id, "_blank");			

}
function transactiontoggle(entry) {

   if (entry == "manual") {         
	      document.getElementById('boxpdf').className='hide';
		  document.getElementById('boxdevice').className='hide';
		  document.getElementById('boxmanual').className='regular'		  
   } else {
   
       if (entry == "device") {
	   
		   document.getElementById('boxdevice').className='regular';
		   document.getElementById('boxpdf').className='hide';
		   document.getElementById('boxmanual').className='hide'   
		   
	   } else {
	   
	  	   document.getElementById('boxpdf').className='regular';
		   document.getElementById('boxmanual').className='hide' 
		   document.getElementById('boxdevice').className='hide';
		   
	   }
   }
}

function refreshwarehouse() {	
     eval(document.getElementById("optionselect").value)	
}
	

function facttable1(control,format,box,qry) {
		w = #CLIENT.widthfull# - 80;
	    h = #CLIENT.height# - 110;		
		ptoken.open("#SESSION.root#/component/analysis/CrossTabLaunch.cfm?"+qry+"&box="+box+"&data=1&controlid="+control+"&format="+format+"&header=1", "rolapstock");		
	}		
	
<!--- --- Extended search for inquiry ---- --->
	
function listfiltermain(mis,whs,id) {
	url = "../Inquiry/Transaction/ControlListData.cfm?"+
				"&height="+document.body.offsetHeight+
	            "&warehouse="+whs+
				"&mission="+mis+
				"&systemfunctionid="+id
	ptoken.navigate(url,'mainlisting','','','POST','filterform')			
}

function onhandfiltermain(mis,whs,id) {
	url = "../Inquiry/Onhand/ListingDataGet.cfm?"+
				"&height="+document.body.offsetHeight+
	            "&warehouse="+whs+
				"&mission="+mis+
				"&systemfunctionid="+id
	ptoken.navigate(url,'mainlisting','','','POST','filterform')			
}

function pricefiltermain(mis,whs,id) {
    Prosis.busy('yes')
	url = "../../SalesOrder/Pricing/Pricing.cfm?"+
				"&height="+document.body.offsetHeight+
	            "&warehouse="+whs+
				"&mission="+mis+
				"&systemfunctionid="+id
	ptoken.navigate(url,'mainlisting','','','POST','filterform')			
}

function togglePriceDetail(id) {
	if ($('##'+id).is(':hidden')) {
		$('##'+id).slideDown(250,changeBtnHideAllPriceDetail);
	}else{
		$('##'+id).slideUp(250,changeBtnHideAllPriceDetail);
	}
}

function togglePriceMenu(id) {
	if ($('##'+id).is(':hidden')) {
		$('##'+id).show(250);
	}else{
		$('##'+id).hide(250);
	}
}

function enablePriceEdit(p) {
	if ($('##en_'+p).is(':checked')) {
		$('##SalesPrice_'+p).removeAttr('disabled');
		$('##TaxCode_'+p).removeAttr('disabled');
		$('##SalesPrice_'+p).select();
    } else {
        $('##SalesPrice_'+p).attr('disabled', true);
		$('##TaxCode_'+p).attr('disabled', true);
		$('##SalesPrice_'+p).val($('##value_'+p).val());
		$('##TaxCode_'+p).val($('##taxValue_'+p).val());
    }
}

function toggleAllPriceDetail() {
	if ($('.divReceiptPriceDetail:hidden').length == $('.divReceiptPriceDetail').length) {
		$('.divReceiptPriceDetail').show(200);
		$('##textAllPriceDetail').text('Hide All Details');
		$('##twistieAllPriceDetail').attr('src','#SESSION.root#/images/collapse.png');
	}else{
		$('.divReceiptPriceDetail').hide(200);
		$('##textAllPriceDetail').text('Show All Details');
		$('##twistieAllPriceDetail').attr('src','#SESSION.root#/images/expand.png');
	}
}

function changeBtnHideAllPriceDetail() {
	if ($('.divReceiptPriceDetail:hidden').length == $('.divReceiptPriceDetail').length) {
		$('##textAllPriceDetail').text('Show All Details');
		$('##twistieAllPriceDetail').attr('src','#SESSION.root#/images/expand.png');
	}else{
		$('##textAllPriceDetail').text('Hide All Details');
		$('##twistieAllPriceDetail').attr('src','#SESSION.root#/images/collapse.png');
	}
}


<!--- ----------------------------------------------------------------- --->
<!--- toggle the main menu screen to prevent using cfarea --->

function toggleMenu(){
	t = document.getElementById('menuMaximized');
	if (t.className == 'show'){
		t.className = 'hide';
		t2 = document.getElementById('menuMinimized');
		t2.className = 'show';
	}else{
		t.className = 'show';
		t2 = document.getElementById('menuMinimized');
		t2.className = 'hide';
	}
}

<!--- -------------- UNCLEAR ---- --->

<!--- refresh the detail bottom box --->		
			 
function maximize(itm) {
	
 	 se   = document.getElementsByName(itm)
	 icM  = document.getElementById(itm+"Min")
	 icE  = document.getElementById(itm+"Exp")
	 count = 0
	 
	 if (se[0].className == "regular") {
		   while (se[count]) { 
		      se[count].className = "hide"; 
  		      count++
		   }		   
	 	   icM.className = "hide";
		   icE.className = "regular";
		 } else {
		    while (se[count]) {
		    se[count].className = "regular"; 
		    count++
		 }	
		 icM.className = "regular";
		 icE.className = "hide";			
	   }
 }  	

	
<!--- ----TRANSACTIONS---- --->
<!--- -------------------- --->
<!--- -------receipt------ --->
<!--- -------------------- --->

function stockshipping(s,modid) {
    
	 document.getElementById("optionselect").value = "stockshipping('s','"+modid+"')"
	 whs  = document.getElementById("warehouse").value	
	 mis  = document.getElementById("mission").value	
     url = "../Shipping/ShippingView.cfm?"+
			"&height="+document.body.offsetHeight+
            "&warehouse="+whs+
			"&mission="+mis+
			"&systemfunctionid="+modid				
	ptoken.navigate(url,'main')		   
}
	
function stockreceipt(s,modid) {
	
	document.getElementById("optionselect").value = "stockreceipt('','"+modid+"')"

	if (s == "") { pge = 1; 
	               grp = "";
				   fnd = ""
				   loc = "";}
	else {		
		pge  = document.getElementById("page").value
		grp  = document.getElementById("group").value	
		fnd  = document.getElementById("find").value	
		loc  = document.getElementById("location").value
	}
	
	whs  = document.getElementById("warehouse").value	
	mis  = document.getElementById("mission").value	
	
	url = "../Transfer/TransferView.cfm?"+
				"&height="+document.body.offsetHeight+
				"&systemfunctionid="+modid+
	            "&warehouse="+whs+
				"&mission="+mis+
				"&page="+pge+
				"&group="+grp+
				"&loc=0"+
				"&fnd="+fnd;								
	ptoken.navigate(url,'main')					 
	}		
	
function stockreceiptissue(s,modid) {

	document.getElementById("optionselect").value = "stockreceiptissue('','"+modid+"')"

	if (s == "") { pge = 1; 
	               grp = "";
				   fnd = ""
				   loc = "";}
	else {		
		pge  = document.getElementById("page").value
		grp  = document.getElementById("group").value	
		fnd  = document.getElementById("find").value	
		loc  = document.getElementById("location").value
	}
	
	whs  = document.getElementById("warehouse").value	
	mis  = document.getElementById("mission").value	
	
	url = "../Receipt/StockReceiptView.cfm?"+
				"&height="+document.body.offsetHeight+
				"&systemfunctionid="+modid+
	            "&warehouse="+whs+
				"&mission="+mis+
				"&page="+pge+
				"&group="+grp+
				"&loc=0"+
				"&fnd="+fnd;	
							
	ptoken.navigate(url,'main')		
			 
	}			

<!--- -------------------- SALES TASK ------------------------ --->
<!--- -------------------------------------------------------- --->
<!--- ---basic function to record issuances by unit/person --- --->
<!--- -------------------------------------------------------- --->

	
function stocksale(s,modid) {		

	document.getElementById("optionselect").value = "stocksale('','"+modid+"')"	
	whs  = document.getElementById("warehouse").value	
	mis  = document.getElementById("mission").value	
	ptoken.navigate('../Transaction/TransactionInit.cfm?systemfunctionid='+modid+'&mode=sale&height='+document.body.offsetHeight+'&warehouse='+whs+'&mission='+mis,'main')		
	
	}		

function stockexternalsale(s,modid) {		

	document.getElementById("optionselect").value = "stockexternalsale('','"+modid+"')"	
	whs  = document.getElementById("warehouse").value	
	mis  = document.getElementById("mission").value	
	ptoken.navigate('../Transaction/TransactionInit.cfm?systemfunctionid='+modid+'&mode=externalsale&height='+document.body.offsetHeight+'&warehouse='+whs+'&mission='+mis,'main')		
	}			
	
function stockdisposal(s,modid) {		

	document.getElementById("optionselect").value = "stockdisposal('','"+modid+"')"
	
	whs  = document.getElementById("warehouse").value	
	mis  = document.getElementById("mission").value	
	ptoken.navigate('../Transaction/TransactionInit.cfm?systemfunctionid='+modid+'&mode=disposal&height='+document.body.offsetHeight+'&warehouse='+whs+'&mission='+mis,'main')	
	
	}			
	
<!--------- SALES TASK---- --->
<!--- -------------------- --->
<!--- ---- --POS---------- --->
<!--- -------------------- --->			

function stockquote(s,modid) {		

	document.getElementById("optionselect").value = "stockquote('','"+modid+"')"
		
	if (s == "") { pge = 1; 
	               grp = "";
				   fnd = ""
				   loc = "";}
	else {		
		pge  = document.getElementById("page").value
		grp  = document.getElementById("group").value	
		fnd  = document.getElementById("find").value	
		loc  = document.getElementById("location").value
	}
	
	whs  = document.getElementById("warehouse").value	
	mis  = document.getElementById("mission").value	
	
	url = "../../SalesOrder/Quote/ControlListData.cfm?"+
				"&height="+document.body.offsetHeight+
				"&systemfunctionid="+modid+
	            "&warehouse="+whs+
				"&mission="+mis+
				"&page="+pge+
				"&group="+grp+
				"&loc=0"+
				"&fnd="+fnd;	
							
	ptoken.navigate(url,'main')					 
}	

function stockquotedialog(id) {		
      ProsisUI.createWindow('salerequest', 'Request for Sale', '',{x:100,y:100,width:document.body.offsetWidth-130,height:document.body.offsetHeight-130,resizable:false,modal:true,center:true})			  	  	
	  ptoken.navigate('../../salesorder/Quote/QuoteDialog.cfm?requestNo='+id,'salerequest');
 }

function printquote(t,p2,p3) {
	req   = document.getElementById("RequestNo").value
	window.open("#session.root#/Tools/Mail/MailPrepareOpen.cfm?id="+req+"&ID1="+req+"&ID0="+t+"&ID2="+p2+"&ID3="+p3,"_blank", "left=30, top=30, width=800, height=600, toolbar=no, menubar=no, status=yes, scrollbars=no, resizable=no")
}

 function composequote(t) {
	req   = document.getElementById("RequestNo").value
	ProsisUI.createWindow('QuoteDetails', 'Quote details', '',{x:100,y:100,width:300,height:300,resizable:false,modal:true,center:true})
	ptoken.navigate("#session.root#/"+t+"?id="+req,'QuoteDetails');
}

function saledispatch(s,modid) {		

	document.getElementById("optionselect").value = "saledispatch('','"+modid+"')"
		
	if (s == "") { pge = 1; 
	               grp = "";
				   fnd = ""
				   loc = "";}
	else {		
		pge  = document.getElementById("page").value
		grp  = document.getElementById("group").value	
		fnd  = document.getElementById("find").value	
		loc  = document.getElementById("location").value
	}
	
	whs  = document.getElementById("warehouse").value	
	mis  = document.getElementById("mission").value	
	
	url = "../../SalesOrder/IssueSale/ControlListData.cfm?"+
				"&height="+document.body.offsetHeight+
				"&systemfunctionid="+modid+
	            "&warehouse="+whs+
				"&mission="+mis+
				"&page="+pge+
				"&group="+grp+
				"&loc=0"+
				"&fnd="+fnd;	
							
	ptoken.navigate(url,'main')					 
}		

	
function stockpos(s,modid) {

	document.getElementById("optionselect").value = "stockpos('','"+modid+"')"
		
	if (s == "") { pge = 1; 
	               grp = "";
				   fnd = ""
				   loc = "";}
	else {		
		pge  = document.getElementById("page").value
		grp  = document.getElementById("group").value	
		fnd  = document.getElementById("find").value	
		loc  = document.getElementById("location").value
	}
	
	whs  = document.getElementById("warehouse").value	
	mis  = document.getElementById("mission").value	
	
	url = "../../SalesOrder/POS/Sale/SaleInit.cfm?"+
				"&height="+document.body.offsetHeight+
				"&systemfunctionid="+modid+
	            "&warehouse="+whs+
				"&mission="+mis+
				"&page="+pge+
				"&group="+grp+
				"&loc=0"+
				"&fnd="+fnd;	
							
	ptoken.navigate(url,'main')					 
	}		
	
function itemprice(s,modid) {		
	document.getElementById("optionselect").value = "itemprice('','"+modid+"')"	
	whs  = document.getElementById("warehouse").value	
	mis  = document.getElementById("mission").value	
	ptoken.navigate('../../SalesOrder/Pricing/PricingView.cfm?systemfunctionid='+modid+'&height='+document.body.offsetHeight+'&warehouse='+whs+'&mission='+mis,'main')		
	}		
	
function setsaletime(dte,hr,mn,id,whs) {
   ptoken.navigate('#client.virtualdir#/warehouse/Application/SalesOrder/POS/Sale/setLine.cfm?action=time&warehouse='+whs+'&id='+id+'&date='+dte+'&hour='+hr+'&minute='+mn,'processline') 
}		

function stockcol(s,modid) {		
	document.getElementById("optionselect").value = "stockcol('','"+modid+"')"	
	whs  = document.getElementById("warehouse").value	
	mis  = document.getElementById("mission").value	
	ptoken.navigate('../../SalesOrder/Picking/PickingView.cfm?systemfunctionid='+modid+'&height='+document.body.offsetHeight+'&warehouse='+whs+'&mission='+mis,'main')		
	}

function customerview(s,modid) {		
	document.getElementById("optionselect").value = "customerview('','"+modid+"')"	
	whs  = document.getElementById("warehouse").value	
	mis  = document.getElementById("mission").value	
	ptoken.navigate('../../SalesOrder/Picking/Monitor/Customer.cfm?systemfunctionid='+modid+'&height='+document.body.offsetHeight+'&warehouse='+whs+'&mission='+mis,'main')		
}
	
function pickingThreshold(s,modid,el,ord,days) {		
	document.getElementById("optionselect").value = "stockcol('','"+modid+"')"	
	whs  = document.getElementById("warehouse").value	
	mis  = document.getElementById("mission").value	
	if (el.checked)	{
		threshold = 1;
	} else {
	   	threshold = 0;
	}
	ptoken.navigate('../../SalesOrder/Picking/PickingView.cfm?systemfunctionid='+modid+'&height='+document.body.offsetHeight+'&warehouse='+whs+'&mission='+mis+'&threshold='+threshold+'&ordering='+ord+'&showDays='+days,'main')		
 }


function posreceivable(s,modid) {		

    scp   = document.getElementById("scope").value
	whs   = document.getElementById("warehouse").value	
	mis   = document.getElementById("mission").value		
	req   = document.getElementById("RequestNo").value
	cus   = document.getElementById("customeridselect").value
	inv   = document.getElementById("customerinvoiceidselect").value
	ter   = document.getElementById("terminal").value
	bat   = document.getElementById("batchid").value	
	tr_d  = document.getElementById("transaction_date").value
	tr_h  = document.getElementById("Transaction_hour").value	
	tr_m  = document.getElementById("Transaction_minute").value
		
	if (document.getElementById("addressidselect")) {
		addr = document.getElementById("addressidselect").value;
	} else {
		addr = '00000000-0000-0000-0000-000000000000';
	}
	
    if (cus != '00000000-0000-0000-0000-000000000000' && inv != '00000000-0000-0000-0000-000000000000' && $.trim(cus) != '' && $.trim(inv) != '') {

	   try { ProsisUI.closeWindow('wsettle',true)} catch(e){};
	   ProsisUI.createWindow('wsettle', 'Receivable', '',{x:100,y:100,width:document.body.offsetWidth-85,height:document.body.offsetHeight-85,resizable:false,modal:true,center:true})			  	  	
	   ptoken.navigate("#SESSION.root#/Warehouse/Application/Salesorder/POS/Receivable/Posting.cfm?scope="+scp+"&RequestNo="+req+"&width="+document.body.offsetWidth+"&height="+document.body.offsetHeight+"&warehouse="+whs+"&terminal="+ter+"&customerid="+cus+"&customeridinvoice="+inv+"&batchid="+bat+"&td="+tr_d+"&th="+tr_h+"&tm="+tr_m+"&addressid="+addr,'wsettle');
	 	  
	} else {  Ext.MessageBox.alert('Information', '#vValidCustomerMessage#'); }
	 
  }		
	
function possettlement(s,modid) {		

	whs   = document.getElementById("warehouse").value	
	mis   = document.getElementById("mission").value	
	req   = document.getElementById("RequestNo").value
	cus   = document.getElementById("customeridselect").value
	bat   = document.getElementById("batchid").value		
	ter   = document.getElementById("terminal").value
	tr_d  = document.getElementById("transaction_date").value	
	tr_h  = document.getElementById("Transaction_hour").value	
	tr_m  = document.getElementById("Transaction_minute").value	
	addr  = document.getElementById("addressidselect").value					
	
    if (cus != '00000000-0000-0000-0000-000000000000' && $.trim(cus) != '') {
		    
	    try { ProsisUI.closeWindow('wsettle',true)} catch(e){};
	    ProsisUI.createWindow('wsettle', 'Settlement', '',{x:100,y:100,width:1080,height:670,resizable:false,modal:true,center:true})		
		ptoken.navigate("#SESSION.root#/Warehouse/Application/SalesOrder/POS/Settlement/SettleView.cfm?RequestNo="+req+"&warehouse="+whs+"&terminal="+ter+"&customerid="+cus+"&batchid="+bat+"&td="+tr_d+"&th="+tr_h+"&tm="+tr_m+"&addressid="+addr,'wsettle');
		
	} else {  Ext.MessageBox.alert('Information', '#vValidCustomerMessage#'); }
	 
  }	
  
<cfinclude template="SettlementScript.cfm">

<!--- ----TRANSACTIONS---- --->
<!--- -------------------- --->
<!--- -------transfer ---- --->
<!--- -------------------- --->	
	
function stocktransfer(s,modid) {
 
	document.getElementById("optionselect").value = "stocktransfer('','"+modid+"')"
	
	whs  = document.getElementById("warehouse").value	
	mis  = document.getElementById("mission").value	
	
	_cf_loadingtexthtml="";					
	
	
				
	if (s == "") { pge = 1; 
	               grp = "";
				   fnd = "";
				   mde = "";
				   loc = "";
				   whsto = ""
				 				   
				   url = "#SESSION.root#/warehouse/application/stock/transfer/transferView.cfm?"+
			"&height="+document.body.offsetHeight+
			"&systemfunctionid="+modid+
	        "&warehouse="+whs+
			"&mission="+mis+
			"&page="+pge+				
			"&group="+grp+
			"&mde="+mde+
			"&loc="+loc+
			"&fnd="+fnd+
			"&warehouseto="+whsto
			Prosis.busy('yes')
						
			ptoken.navigate(url,'main')				
				   
				   }
	else {		
		
		pge  = document.getElementById("page").value
		grp  = document.getElementById("group").value	
		fnd  = document.getElementById("find").value			
		mde  = document.getElementById("selmode").value
		whsto  = document.getElementById("warehouseto").value		
												
		url = "#SESSION.root#/warehouse/application/stock/transfer/TransferViewContent.cfm?"+
			"&height="+document.body.offsetHeight+
			"&systemfunctionid="+modid+
	        "&warehouse="+whs+
			"&mission="+mis+
			"&page="+pge+				
			"&group="+grp+
			"&mde="+mde+			
			"&fnd="+fnd+
			"&warehouseto="+whsto					
			ptoken.navigate(url,'content','','','POST','transferform')							
	}								
			
	_cf_loadingtexthtml="<div><img src='<cfoutput>#SESSION.root#</cfoutput>/images/busy11.gif'/>";		
			
	 
	}		
			
// stock transaction batch

function go() {

	 se = document.getElementById("find")
		 
	 if (window.event.keyCode == "13")	 
		{	document.getElementById("locate").click() }		
			
    }
	
	function stockbatchgo(s,modid) {
	 	if (window.event.keyCode == "13") {	
		 	stockbatch('x',modid) }						
     }
	 
	function stockbatchprint(id, template) {
		window.open("#SESSION.root#/Tools/Mail/MailPrepareOpen.cfm?ts="+new Date().getTime()+"&id="+id+"&ID1="+id+"&ID0=/"+template,"_blank", "left=60, top=60, width=800, height=600, toolbar=no, menubar=no, status=yes, scrollbars=no, resizable=no")
	}
	
	function issuelineprint(id,table,template,title) {
		window.open("#SESSION.root#/Tools/CFReport/OpenReport.cfm?ts=#GetTickCount()#&template="+template+"&ID1="+table+"&ID2="+id+"&ID3="+title, "_blank", "left=60, top=60, width=800, height=600, toolbar=no, menubar=no, status=yes, scrollbars=no, resizable=yes")
	}
	
	function editdetailline(mode,id,warehouse,wlocation,ctype){
	    
		document.getElementById('tratpe').value = ctype;		
		ptoken.navigate('../Transaction/setTransactionType.cfm?warehouse='+warehouse+'&location='+wlocation+'&transactiontype='+ctype,'transactionbox');		
		ptoken.navigate('../Transaction/getLineEdit.cfm?mode='+mode+'&id='+id+'&warehouse='+warehouse,'transactionbox');

	}
	
function stockbatch(s,modid,mde,whs) {		
	
	document.getElementById("optionselect").value = "stockbatch('','"+modid+"')"	
	mis  = document.getElementById("mission").value	
			
	// selection from the menu	
	if (whs) {} else {		
		whs  = document.getElementById("warehouse").value		
	}
					
	if (s == "") { 
		   		
		if (mde) {
		
			sta  = document.getElementById("status").value;						
			_cf_loadingtexthtml='';		
		    ptoken.navigate('../Batch/StockBatch'+mde+'.cfm?height='+document.body.offsetHeight+'&width='+document.body.offsetWidth+'&systemfunctionid='+modid+'&warehouse='+whs+'&mission='+mis+'&status='+sta,'batchmain');
					 
		} else {
									
			_cf_loadingtexthtml='';	
		    ptoken.navigate('../Batch/StockBatch.cfm?height='+document.body.offsetHeight+'&width='+document.body.offsetWidth+'&systemfunctionid='+modid+'&warehouse='+whs+'&mission='+mis,'main');
			
		}
				
	} else {	
				
		mde  = document.getElementById("batchmode").value			
		sta  = document.getElementById("status").value		
			
	    if (mde == "listing") {
			
			pge  = 1		
			grp  = "transactiondate" // document.getElementById("group").value			
			fnd  = ""	
			
		} else {
		
			pge  = 1	
			grp  = "transactiondate"			
			fnd  = ""		
		}
		
		_cf_loadingtexthtml='';	
		ptoken.navigate('../Batch/StockBatch'+mde+'.cfm?systemfunctionid='+modid+'&warehouse='+whs+'&mission='+mis+'&status='+sta,'batchmain')		
		
	}	
	
	}	
	
function stockbatchsummary(modid) {
	_cf_loadingtexthtml="";	
	mis  = document.getElementById("mission").value	
	whs  = document.getElementById("warehouse").value		
	if (document.getElementById('batchsummary')) {  
	ptoken.navigate('../Batch/StockBatchSummary.cfm?ts='+new Date().getTime()+'&width='+document.body.offsetWidth+'&systemfunctionid='+modid+'&mission='+mis+'&warehouse='+whs,'batchsummary')	
	}
	_cf_loadingtexthtml="<div><img src='<cfoutput>#SESSION.root#</cfoutput>/images/busy11.gif'/>";
}	
	

<!--------- TASK---------- --->
<!--- -------------------- --->
<!--- ---- Inspection----- --->
<!--- -------------------- --->

function stockinspection(s,modid) {

	document.getElementById("optionselect").value = "stockinspection('','"+modid+"')"
	
	mis  = document.getElementById("mission").value	
	whs  = document.getElementById("warehouse").value	
					
	url = "../Inspection/Inspection.cfm?ts="+new Date().getTime()+
			"&height="+document.body.offsetHeight+
			"&systemfunctionid="+modid+
	        "&warehouse="+whs+
	    	"&mission="+mis					
			
	ptoken.navigate(url,'main')		 
	
	}		

<!--------- TASK---------- --->
<!--- -------------------- --->
<!--- ---- Pickticket----- --->
<!--- -------------------- --->

function stockpicking(s,modid) {

	document.getElementById("optionselect").value = "stockpicking('','"+modid+"')"
	
	mis  = document.getElementById("mission").value	
	whs  = document.getElementById("warehouse").value	
	
	if (s == "") { 
			
		url = "../Pickticket/PickingListing.cfm?ts="+new Date().getTime()+
				"&height="+document.body.offsetHeight+
				"&systemfunctionid="+modid+
	            "&warehouse="+whs+
				"&mission="+mis
	
	} else {	
	
		pge  = document.getElementById("page").value
		grp  = document.getElementById("group").value	
		fnd  = document.getElementById("find").value	
		url = "../Pickticket/PickingListing.cfm?ts="+new Date().getTime()+
				"&height="+document.body.offsetHeight+
				"&systemfunctionid="+modid+
	            "&warehouse="+whs+
				"&mission="+mis+
				"&page="+pge+
				"&group="+grp+
				"&fnd="+fnd;				
	}			
	ptoken.navigate(url,'main')			 	
}

function stockpickingedit(id,qty) {	
    _cf_loadingtexthtml='';	
	if (parseFloat(qty)) {
	   ptoken.navigate('../Pickticket/setLineQuantity.cfm?id='+id+'&quantity='+qty,'amount_'+id)
	} else {
	   if (qty == "0") {
	   ptoken.navigate('../Pickticket/setLineQuantity.cfm?id='+id+'&quantity='+qty,'amount_'+id)
	   } else {
	   alert("Invalid quantity. Quantity was not applied")
	   }
    }				
}	
	
function forwardrequest(id,whs) {
    ptoken.navigate('../Pickticket/BackOrderForward.cfm?requestid='+id+'&warehouse='+whs,'forward_'+id)	
}	


function reqSelectALL(c,s) {
	if(c.checked) {
		$(s).prop('checked', true);
	}else{
		$(s).prop('checked', false);
	}
}
	
<!--------- TASK---------- --->
<!--- -------------------- --->
<!--- ---- --Backorder---- --->
<!--- -------------------- --->
	
	
function stockbackorder(s,modid) {
	
	document.getElementById("optionselect").value = "stockbackorder('','"+modid+"')"
	
	mis  = document.getElementById("mission").value	
	whs  = document.getElementById("warehouse").value	
	
	if (s == "") { 
			
		url = "../Pickticket/BackOrderListing.cfm?ts="+new Date().getTime()+
				"&height="+document.body.offsetHeight+
				"&systemfunctionid="+modid+
	            "&warehouse="+whs+
				"&mission="+mis
	
	} else {	
	
		pge  = document.getElementById("page").value
		grp  = document.getElementById("group").value	
		fnd  = document.getElementById("find").value	
		url = "../Pickticket/BackOrderListing.cfm?ts="+new Date().getTime()+
				"&height="+document.body.offsetHeight+
				"&systemfunctionid="+modid+
	            "&warehouse="+whs+
				"&mission="+mis+
				"&page="+pge+
				"&group="+grp+
				"&mode="+s+
				"&fnd="+fnd;				
	}		
	
	ptoken.navigate(url,'main')		 
	}
	

<!--- ----- TASK ------- --->
<!--- -----taskorder---- --->
<!--- ------------------ --->
		
function stocktaskorder(s,modid) {
	
    try {	
	document.getElementById("optionselect").value = "stocktaskorder('','"+modid+"')"
	} catch(e) {}
			
	if (s == "") { pge = 1; 
	               grp = "";
				   fnd = ""
				   loc = "";}
	else {	
	
		pge  = document.getElementById("page").value
		grp  = document.getElementById("group").value	
		fnd  = document.getElementById("find").value	
		loc  = document.getElementById("location").value
	}
		
	whs  = document.getElementById("warehouse").value	
	mis  = document.getElementById("mission").value	
	
	url = "../../StockOrder/Task/Process/TaskView.cfm?"+
				"&height="+document.body.offsetHeight+
				"&systemfunctionid="+modid+
	            "&warehouse="+whs+
				"&mission="+mis+
				"&page="+pge+
				"&group="+grp+
				"&loc=0"+
				"&fnd="+fnd;
				
	ptoken.navigate(url,'main')			
	 
	}	
	
function stocktaskorderconfirm(s,modid,mde) {
	
    try {	
	document.getElementById("optionselect").value = "stocktaskorderconfirm('','"+modid+"')"
	} catch(e) {}
			
	if (s == "") { pge = 1; 
	               grp = "";
				   fnd = ""
				   loc = "";}
	else {	
	
		pge  = document.getElementById("page").value
		grp  = document.getElementById("group").value	
		fnd  = document.getElementById("find").value	
		loc  = document.getElementById("location").value
	}
				
	whs  = document.getElementById("warehouse").value	
	mis  = document.getElementById("mission").value	
	
	url = "../../StockOrder/Task/Process/TaskViewConfirmation.cfm?"+
				"&height="+document.body.offsetHeight+
				"&systemfunctionid="+modid+
				"&shiptomode="+mde+
	            "&warehouse="+whs+
				"&mission="+mis+
				"&page="+pge+
				"&group="+grp+
				"&loc=0"+
				"&fnd="+fnd;
				
	ptoken.navigate(url,'main')			
	 
	}		
	
function settaskreceived(id,tn,stockorderid) {		

      	if (confirm("Do you want to close the remaining shipping balance for this task ? This action can not be reverted.")) {			   
		ptoken.navigate('#SESSION.root#/warehouse/application/stockorder/task/shipment/TaskDirect.cfm?id='+id+'&tn='+tn,'d'+id+'_'+tn);
		ptoken.navigate('#SESSION.root#/warehouse/application/stockorder/task/shipment/TaskViewWorkflow.cfm?ajaxid='+stockorderid,stockorderid);
		}
		// try {document.getElementById('tasktreerefresh').click();}  catch(e){};						
}
			
// internal taskorder receipt processing

function processtaskorder(tid,actormode,template,action,id) {		    
	    ht = document.body.offsetHeight-80
		try { ColdFusion.Window.destroy('dialogprocesstask',true)} catch(e){};
		ColdFusion.Window.create('dialogprocesstask', 'Internal Task Order', '',{x:100,y:100,width:890,height:ht,resizable:true,modal:true,center:true})	
		ptoken.navigate('../../StockOrder/Task/Process/TaskForm'+template+'.cfm?taskid='+tid+'&actormode='+actormode+'&action='+action+'&actionid='+id,'dialogprocesstask')			
}

// direct taskorder issuance (variation)	
	function issueshipment(tid,actormode,template,action,id) {		    	   
	    ht = document.body.offsetHeight-60
		wd = document.body.offsetWidth-80
		try { ColdFusion.Window.destroy('dialogprocesstask',true)} catch(e){};
		ColdFusion.Window.create('dialogprocesstask', 'Issuance on task order', '',{x:100,y:100,width:wd,height:ht,resizable:true,modal:true,center:true})			
		ptoken.navigate('#SESSION.root#/Warehouse/Application/StockOrder/Task/Process/TaskForm'+template+'.cfm?taskid='+tid+'&actormode='+actormode+'&action='+action,'dialogprocesstask')		
	}

function processtaskorderreceipt(tid,actormode,template,action,id,batchid) {	

    if (document.getElementById("BatchReference"))
		var batch_reference = document.getElementById("BatchReference").value;
	else
		var batch_reference = 'undefined';	
	
	if (batch_reference != '') {
		if (confirm("Do you want to save the "+template+" record ?")) {			
				
		_cf_loadingtexthtml="";		
		ptoken.navigate('../../StockOrder/Task/Process/TaskForm'+template+'Submit.cfm?taskid='+tid+'&actormode='+actormode+'&action='+action+'&actionid='+id+'&batchid='+batchid,'processtask','','','POST','formtask')	
		_cf_loadingtexthtml="<div><img src='<cfoutput>#SESSION.root#</cfoutput>/images/busy11.gif'/>";					
	 	}
	} else {
		alert('Please enter a Receipt/Voucher No.');		
		}			
} 	

function showtaskpending(mis,tasktype) {
	    ptoken.navigate('#SESSION.root#/warehouse/application/stockorder/Task/Shipment/TaskAssignment.cfm?mission='+mis+'&tasktype='+tasktype+'&warehouse='+document.getElementById('warehouse').value,'main')
	}
	
function showtask(mid,mis,tasktype,cls,st,cde) {
	    ptoken.navigate('#SESSION.root#/warehouse/application/stockorder/Task/Shipment/TaskListing.cfm?systemfunctionid='+mid+'&mission='+mis+'&warehouse='+document.getElementById('warehouse').value+'&tasktype='+tasktype+'&type='+cls+'&sta='+st+'&code='+cde,'main')
	}	
	
<!--- added to allow for splitting a requesttask line after it was effectively tasked by the planner already --->
	
function settasksplit(tid) {			
		ht = 200; <!--- document.body.offsetHeight-80 --->
		try { ColdFusion.Window.destroy('dialogprocesstask',true)} catch(e){};
		ColdFusion.Window.create('dialogprocesstask', 'Split Tasked Line', '',{x:100,y:100,width:300,height:ht,resizable:true,modal:true,center:true})	
		ptoken.navigate('../../StockOrder/Task/Shipment/TaskSplit.cfm?taskid='+tid,'dialogprocesstask')			
	}		
	
	function showreceipt(mis,mode,sta) {
	    ptoken.navigate('#SESSION.root#/warehouse/application/stockorder/Task/Receipt/ReceiptOpen.cfm?actionstatus='+sta+'&mission='+mis+'&warehouse='+document.getElementById('warehouse').value+'&id1='+mode,'main')
	}	
	
	function showreceipttransfer(mis,mode,sta) {
	    ptoken.navigate('#SESSION.root#/warehouse/application/stockorder/Task/Receipt/ReceiptListing.cfm?actionstatus='+sta+'&mission='+mis+'&warehouse='+document.getElementById('warehouse').value+'&id1='+mode,'main')
	}	
	
function submittask(mis,whs,tasktype,cls) {	
	   ht = document.body.offsetHeight-100
	   wd = document.body.offsetWidth-160
	   try { ColdFusion.Window.destroy('dialogprocesstask',true)} catch(e){};
	   ColdFusion.Window.create('dialogprocesstask', 'Submit Task Order', '',{x:100,y:100,width:wd,height:ht,resizable:true,modal:true,center:true})
	   ptoken.navigate('#SESSION.root#/warehouse/application/stockorder/Task/Shipment/TaskForm.cfm?mission='+mis+'&warehouse='+whs+'&tasktype='+tasktype,'dialogprocesstask','','','POST','taskplanning')		   
	}
		
	function submittaskorder(mis,whs,tasktype) {	
		if (confirm("Do you want to submit this task order ?")) {	
			 ptoken.navigate('#SESSION.root#/warehouse/application/stockorder/Task/Shipment/TaskAssignmentSubmit.cfm?mission='+mis+'&warehouse='+whs+'&tasktype='+tasktype,'dialogprocesstask','','','POST','formtask')		
		 }
	}
	
	function cancelstockorder(id,scope) {
	    ptoken.navigate('#SESSION.root#/warehouse/application/stockorder/Task/Shipment/TaskAssignmentCancel.cfm?scope='+scope+'&id='+id,'processtask')				
	}
			
	function direct_receive(id,tn) {
		ptoken.navigate('#SESSION.root#/warehouse/application/stockorder/Task/Shipment/TaskDirect.cfm?id='+id+'&tn='+tn,'d'+id+'_'+tn);	
	}
		
<!--------- TASK---------- --->
<!--- -------------------- --->
<!--- ---Production stock- --->
<!--- -------------------- --->
	
function stockproduction(s,modid) {
		
	document.getElementById("optionselect").value = "stockproduction('','"+modid+"')"
				
	whs  = document.getElementById("warehouse").value	
	mis  = document.getElementById("mission").value	
	ptoken.navigate('../Production/ProductionInit.cfm?systemfunctionid='+modid+'&mode=production&height='+document.body.offsetHeight+'&warehouse='+whs+'&id=0&mission='+mis,'main')	
	}	
	
	
<!--------- TASK---------- --->
<!--- -------------------- --->
<!--- ---Initial stock---- --->
<!--- -------------------- --->
	
function stockinitial(s,modid) {
		
	document.getElementById("optionselect").value = "stockinitial('','"+modid+"')"
				
	whs  = document.getElementById("warehouse").value	
	mis  = document.getElementById("mission").value	
	ptoken.navigate('../Transaction/TransactionInit.cfm?systemfunctionid='+modid+'&mode=initial&height='+document.body.offsetHeight+'&warehouse='+whs+'&id=9&mission='+mis,'main')	
	}	

<!--------- POS Customer Details ---------- --->

function customertoggle(target,cid,action,w,adr) {
	
	_cf_loadingtexthtml='';	
	
	if (cid == '00000000-0000-0000-0000-000000000000') {
	
		    document.getElementById(target+'_main').className = "hide"			
			document.getElementById(target+'_box').className = "hide"; 			
			document.getElementById(target+'_exp').className = "show"; 
			document.getElementById(target+'_col').className = "hide"; 	
	
	} else {	
		if (document.getElementById(target+'_box').className == "hide" || action == "open")	{	
								
			ptoken.navigate('#SESSION.root#/Warehouse/Application/Customer/View/CustomerData.cfm?customerid='+cid+'&warehouse='+w+'&addressid='+adr,target+'_content');				
			document.getElementById(target+'_main').className = "highlight4";			
			document.getElementById(target+'_box').className = "regular"; 		
			document.getElementById(target+'_exp').className = "hide"; 				
			document.getElementById(target+'_col').className = "show"; 		
			
		} else {	
				
		    document.getElementById(target+'_main').className = "regular"
			document.getElementById(target+'_box').className = "hide"; 
			document.getElementById(target+'_exp').className = "show"; 
			document.getElementById(target+'_col').className = "hide"; 				
		}	
	}
}

function applyCustomerData(cid,fld,val,input) {	
	_cf_loadingtexthtml='';		
   	ptoken.navigate('#SESSION.root#/Warehouse/Application/Customer/View/setCustomerData.cfm?mode=ajax&scope=customer&scopeid='+cid+'&field='+fld+'&input='+input+'&value='+val,'inputvalidation');
}

function applyBeneficiaryData(w,b,c,id,act,v,r) {
	_cf_loadingtexthtml='';
	ptoken.navigate('#SESSION.root#/warehouse/Application/SalesOrder/POS/Sale/setBeneficiary.cfm?warehouse='+w+'&beneficiaryId='+b+'&CustomerId='+c+'&id='+id+'&action='+act+'&value='+v+'&crow='+r,'processline')	
}		


function doHideSelectBox() {	
	$('##switchselectbox').addClass('hide');
	$('##customerselectbox').addClass('hide');
	$('##customerinvoiceselectbox').addClass('hide');
}

<!--------- TASK---------- --->
<!--- -------------------- --->
<!--- ---- --ISSUE-------- --->
<!--- -------------------- --->


<!--- key based search --->

function searchcombo(mis,whs,cat,mde,val,mode,itm,valfield) {

   if ($.trim(val) != '' && $.trim(valfield) != '') {
	   $(valfield).val(val);
   }
    
   if  (val.length < #param.AssetSearchChars#) {     	   	
		document.getElementById(mde+'selectbox').className = "hide"		
				   
   } else {  
          	   	 
       document.getElementById(mde+'selectbox').className = "regular"   
	   if(window.event) {   
		  keynum = window.event.keyCode;	  
	   } else {   
		  keynum = window.event.which;	  
	   }
	  	 		  
	   if (mode == "down") {
	   
	       switch(keynum) {
		   case 13: 		  			
		    // we need to review if this can be made more generic like we do for the search div 
	     	document.getElementById(mde+'selectbox').className = "hide"		
			 			 		  	 			
			if (mde == 'customer') {					
				if (document.getElementById('addressidselect'))	{
					addressId = document.getElementById('addressidselect').value;
				} else {
					addressId = "00000000-0000-0000-0000-000000000000";
				}								
				ptoken.navigate('#SESSION.root#/warehouse/application/salesorder/POS/sale/applyCustomer.cfm?mission='+mis+'&warehouse='+whs+'&category='+cat+'&itemno='+itm+'&search='+val+'&customerid='+document.getElementById('customeridselect').value+'&addressid='+addressId,mde+'box')	
				
			} else {											
				if (mde == 'customerinvoice') {						       					 				
				  ptoken.navigate('#SESSION.root#/warehouse/application/salesorder/POS/sale/applySaleHeader.cfm?field=billing&mission='+mis+'&warehouse='+whs+'&category='+cat+'&itemno='+itm+'&search='+val+'&customerid='+document.getElementById('customeridselect').value+'&customeridinvoice='+document.getElementById('customerinvoiceidselect').value+'&requestno='+document.getElementById('RequestNo').value,'salelines')					 					  
			    } else {								
				  ptoken.navigate('#SESSION.root#/warehouse/application/stock/Transaction/get'+mde+'.cfm?mission='+mis+'&warehouse='+whs+'&category='+cat+'&itemno='+itm+'&search='+val+'&assetid='+document.getElementById('assetidselect').value,mde+'box')									
				}				
			}
			 break;
			} 
	   
	   } else {
	         		   		   	 
		   switch(keynum) {	   
				
		   case 13:    		
			   document.getElementById(mde+'selectbox').className = "hide"	;
			   break;
			
		   case 38:	   	   
			 
		     line = document.getElementById(mde+'selectrow').value
			 line--
			 
			 if (document.getElementById(mde+'line'+line)) {
			     // set new value for row
				 document.getElementById(mde+'selectrow').value = line
				 // get info from the row 
				 document.getElementById(mde+'select').value    = document.getElementById('r_'+line+'_'+mde+'meta').value
				 document.getElementById(mde+'idselect').value  = document.getElementById('r_'+line+'_'+mde+'id').value		
				 clearlines(mde+'line',line) 		
			     }	 	 
			 break;
			 
		   case 40:
		   		     
		     line = document.getElementById(mde+'selectrow').value
			 line++		
			
			 if (document.getElementById(mde+'line'+line)) {
			     // set new value for row
				 document.getElementById(mde+'selectrow').value = line
				 
				 // get info from the row 
				 document.getElementById(mde+'select').value    = document.getElementById('r_'+line+'_'+mde+'meta').value
				 document.getElementById(mde+'idselect').value  = document.getElementById('r_'+line+'_'+mde+'id').value		
				 clearlines(mde+'line',line) 		
			     }	 	 
			 break;
			 
		   default:  	
		   		// search more  
		   		if (mde == 'switch') {
		   			template = 'customer';
		   		} else {
		   			template = mde;
		   		}						
						
			  	ptoken.navigate('#SESSION.root#/Warehouse/Application/Tools/divSearch/get'+template+'Search.cfm?mission='+mis+'&warehouse='+whs+'&category='+cat+'&itemno='+itm+'&search='+val+'&context='+mde+'selectbox',mde+'find')
		   }	
	    }	 
    }    
}

function clearlines(name,no) {   
   cnt = 1
   while (document.getElementById(name+cnt)) {
      document.getElementById(name+cnt).className = "regular"
	  cnt++
   }   
   document.getElementById(name+no).className = "highlight3"   
}

function forceSelect(c,id) { 
	var vHiddenVal = $.trim($('##'+id).val());
	if ($.trim($(c).val()) != '') {
		if (vHiddenVal == '' || vHiddenVal == '00000000-0000-0000-0000-000000000000' || vHiddenVal == 'insert') {	   
			Prosis.notification.show('#vforceSelectMessage1#','#vforceSelectMessage2#','error',3500);
			$(c).val('');
		}
	}
}

<!--- -------------------- --->
	
function stockissue(s,modid) {		

	document.getElementById("optionselect").value = "stockissue('','"+modid+"')"	
	whs  = document.getElementById("warehouse").value	
	mis  = document.getElementById("mission").value	
	ptoken.navigate('../Transaction/TransactionInit.cfm?systemfunctionid='+modid+'&mode=issue&height='+document.body.offsetHeight+'&warehouse='+whs+'&mission='+mis,'main')	

}	

function transactionreload(details) {	

	whs  = document.getElementById("warehouse").value	
	mis  = document.getElementById("mission").value		
    tpe  = document.getElementById('tratpe').value	
	mde  = document.getElementById('mode').value	
	loc  = document.getElementById('location').value
	uom  = document.getElementById('uom').value
	itm  = document.getElementById('itemno').value			
	if (details == true) {
	    det = 1
	} else {
	    det = 0
	}
	ptoken.navigate('../Transaction/TransactionDetailLines.cfm?systemfunctionid='+document.getElementById('systemfunctionid').value+'&tratpe='+tpe+'&mode='+mde+'&warehouse='+whs+'&location='+loc+'&itemNo='+itm+'&UoM='+uom+'&details='+det,'detail')			
}	

function validatemetric(actionid,metric,value,box,field) { 
    ptoken.navigate('../Transaction/ValidateMetric.cfm?field='+field+'&assetactionid='+actionid+'&metric='+metric+'&value='+value+'&box='+box,box)		
}
			

<!--------- TASK---------- --->
<!--- -------------------- --->
<!--- ---- Inventory------ --->
<!--- -------------------- --->

function stockinventory(s,modid) {
	
	_cf_loadingtexthtml='';				
	Prosis.busy("yes")
	document.getElementById("optionselect").value = "stockinventory('','"+modid+"')"
			
	whs  = document.getElementById("warehouse").value	
	mis  = document.getElementById("mission").value	
	url = "../Inventory/InventoryInit.cfm?height="+document.body.offsetHeight+
				"&systemfunctionid="+modid+
	            "&warehouse="+whs+
				"&id=5"+
				"&mission="+mis
	ptoken.navigate(url,'main')				
 
	}	
	
function stockinventoryload(s,modid) {	

	_cf_loadingtexthtml='';				
	Prosis.busy("yes")
	document.getElementById("optionselect").value = "stockinventory('','"+modid+"')"
			
	whs  = document.getElementById("warehouse").value	
	mis  = document.getElementById("mission").value	
													
	url = "#SESSION.root#/warehouse/application/stock/inventory/InventoryViewContent.cfm?"+
			"&height="+document.body.offsetHeight+
			"&systemfunctionid="+modid+
	        "&warehouse="+whs+
			"&mission="+mis			
		ptoken.navigate(url,'content','','','POST','inventoryform')		
			
	}		
	
function stockinventorydate(modid,dte,hr,mi) {	
	
	_cf_loadingtexthtml='';	
	Prosis.busy("yes")			
	whs  = document.getElementById("warehouse").value	
	mis  = document.getElementById("mission").value	
	url = "../Inventory/InventoryViewContent.cfm?height="+document.body.offsetHeight+
				"&systemfunctionid="+modid+
	            "&warehouse="+whs+
				"&id=5"+
				"&mission="+mis+
				"&transaction_date="+dte+
				"&transaction_hour="+hr+
				"&transaction_minute="+mi
	ptoken.navigate(url,'content','','','POST','inventoryform')			
 
	}			
	
<!--------- TASK---------- --->
<!--- -------------------- --->
<!--- ---- resupply ------ --->
<!--- -------------------- --->
	
function stockresupply(s,modid) {

	document.getElementById("optionselect").value = "stockresupply('','"+modid+"')"
			
	whs  = document.getElementById("warehouse").value	
	mis  = document.getElementById("mission").value	
	url = "../Resupply/Resupply.cfm?ts="+new Date().getTime()+
				"&height="+document.body.offsetHeight+
				"&systemfunctionid="+modid+
	            "&warehouse="+whs+
				"&id=1"+
				"&mission="+mis
				
	ptoken.navigate(url,'main')				 
	}			

<!--- ----TRANSACTIONS---- --->
<!--- -------------------- --->
<!--- ----BILLING --- ---- --->
<!--- -------------------- --->		

function initpayable(mis,whs,orgunit,id) {
   ptoken.navigate('#SESSION.root#/Warehouse/Application/Stock/Shipping/Payables/Create/PrepareInvoice.cfm?systemfunctionid='+id+'&mission='+mis+'&warehouse='+whs+'&orgunit='+orgunit,'contentbox1','','','POST','transactionform')
}

function payablerefresh(mis,whs,orgunit) { 
   if (document.getElementById('contentbox1')) {	
    ptoken.navigate('#SESSION.root#/Warehouse/Application/Stock/Shipping/PendingTransaction/Pending.cfm?mission='+mis+'&warehouse='+whs+'&orgunit='+orgunit,'contentbox1')
	}
}

function payablecreate(mis,whs,org,pur,id,cur) { 
    try { ColdFusion.Window.destroy('recordpayable',true) } catch(e) {}; 	
	ColdFusion.Window.create('recordpayable', 'Register Payable', '',{x:10,y:10,height:document.body.clientHeight-40,width:1000,resizable:true,draggable:false,modal:true,center:true});		
	ptoken.navigate('#SESSION.root#/Warehouse/Application/Stock/Shipping/Payables/Create/RecordInvoice.cfm?salesid='+id+'&mode=warehouse&mission='+mis+'&Warehouse='+whs+'&period=&orgunit='+org+'&personno=&PurchaseNo='+pur+'&currency='+cur,'recordpayable','','','POST','transactionform')	
 }

		
<!--------- INQUIRY------- --->
<!--- -------------------- --->
<!--- ------ onhand ------ --->
<!--- -------------------- --->
		
function stockonhand(s,modid) {
				
	document.getElementById("optionselect").value = "stockonhand('','"+modid+"')"	
	whs  = document.getElementById("warehouse").value	
	mis  = document.getElementById("mission").value	
	
	url = "../Inquiry/Onhand/ListingData.cfm?"+
				"&height="+document.body.offsetHeight+
				"&systemfunctionid="+modid+
	            "&warehouse="+whs+
				"&mission="+mis+
				"&SystemFunctionid"+modid
								
	ptoken.navigate(url,'main')			
	 
}

function stockdiversity(s,modid) {
				
	document.getElementById("optionselect").value = "stockonhand('','"+modid+"')"	
	whs  = document.getElementById("warehouse").value	
	mis  = document.getElementById("mission").value	
		
	url = "../Inquiry/Diversity/ListingData.cfm?"+
				"&height="+document.body.offsetHeight+
				"&systemfunctionid="+modid+
	            "&warehouse="+whs+
				"&mission="+mis+
				"&SystemFunctionid"+modid
								
	ptoken.navigate(url,'main')			
	 
}

function stockOnHandItem(fld, fsys, fmis) {
	item(fld,fsys,fmis);
}
	
<!--------- INQUIRY------- --->
<!--- -------------------- --->
<!--- - onhand transaction --->
<!--- -------------------- --->
		
function stockonhandtransaction(s,modid) {
				
	document.getElementById("optionselect").value = "stockonhand('','"+modid+"')"	
	whs  = document.getElementById("warehouse").value	
	mis  = document.getElementById("mission").value	
	
	url = "../Inquiry/OnhandTransaction/ListingData.cfm?"+
				"&height="+document.body.offsetHeight+
				"&systemfunctionid="+modid+
	            "&warehouse="+whs+
				"&mission="+mis+
				"&SystemFunctionid"+modid
								
	ptoken.navigate(url,'main')			
	 
	}	
	
<!--------- INQUIRY------- --->
<!--- -------------------- --->
<!--- ---- locations ----- --->
<!--- -------------------- --->	

function stocklocation(s,modid) {

	document.getElementById("optionselect").value = "stocklocation('s','"+modid+"')"
    whs  = document.getElementById("warehouse").value	
	mis  = document.getElementById("mission").value	
	url = "../../../Maintenance/WarehouseLocation/RecordListing.cfm?"+
				"&height="+document.body.offsetHeight+
				"&systemfunctionid="+modid+
	            "&warehouse="+whs+
				"&mission="+mis
	ptoken.navigate(url,'main')			   
}	
	

<!--------- INQUIRY------- --->
<!--- -------------------- --->
<!--- --- issues/sales---- --->
<!--- -------------------- --->	

function stockdistribution(s,modid) {

	document.getElementById("optionselect").value = "stockdistribution('','"+modid+"')"
    whs  = document.getElementById("warehouse").value	
	mis  = document.getElementById("mission").value	
	url = "../Inquiry/Transaction/ControlList.cfm?"+
				"&height="+document.body.offsetHeight+
				"&systemfunctionid="+modid+
	            "&warehouse="+whs+
				"&mission="+mis
	ptoken.navigate(url,'main')			
}		


function stockorder(s,modid) {

	document.getElementById("optionselect").value = "stockdistribution('','"+modid+"')"
    whs  = document.getElementById("warehouse").value	
	mis  = document.getElementById("mission").value	
	url = "../../StockOrder/Inquiry/TaskOrder/ControlList.cfm?"+
				"&height="+document.body.offsetHeight+
				"&systemfunctionid="+modid+
	            "&warehouse="+whs+
				"&mission="+mis
	ptoken.navigate(url,'main')			
}		

function stockextreceipt(s,modid) {

	document.getElementById("optionselect").value = "stockextreceipt('','"+modid+"')"
    whs  = document.getElementById("warehouse").value	
	mis  = document.getElementById("mission").value	
	url = "../Inquiry/Receipt/ControlList.cfm?"+
				"&height="+document.body.offsetHeight+
				"&systemfunctionid="+modid+
	            "&warehouse="+whs+
				"&mission="+mis
	ptoken.navigate(url,'main')			
}		


function stockreturn(s,modid) {

	document.getElementById("optionselect").value = "stockreturn('','"+modid+"')"
    whs  = document.getElementById("warehouse").value	
	mis  = document.getElementById("mission").value	
	url = "../Return/Return.cfm?"+
				"&height="+document.body.offsetHeight+
				"&systemfunctionid="+modid+
	            "&warehouse="+whs+
				"&mission="+mis
	ptoken.navigate(url,'main')			
}		


function saletransaction(s,modid) {

	document.getElementById("optionselect").value = "saletransaction('','"+modid+"')"
    whs  = document.getElementById("warehouse").value	
	mis  = document.getElementById("mission").value	
	url = "../../SalesOrder/Transaction/SaleListing.cfm?"+
				"&height="+document.body.offsetHeight+
				"&systemfunctionid="+modid+
	            "&warehouse="+whs+
				"&mission="+mis
	ptoken.navigate(url,'main')			
}		


<!--------- INQUIRY------- --->
<!--- -------------------- --->
<!--- requested / purchase --->
<!--- -------------------- --->

function stockonorder(s,modid) {

	// item under request/purchase
		
	mis  = document.getElementById("mission").value			    
	whs  = document.getElementById("warehouse").value	
	
	document.getElementById("optionselect").value = "stockonorder('s','"+modid+"')"	
	
	if (s == "") { 
	
		url = "#SESSION.root#/Procurement/Application/Requisition/RequisitionView/RequisitionViewView.cfm?ts="+new Date().getTime()+
				"&height="+document.body.offsetHeight+
	            "&id=WHS&mission="+mis+"&warehouse="+whs
				
	} else {	
	
		pge  = document.getElementById("page").value
		grp  = document.getElementById("sort").value	
		
		url = "#SESSION.root#/Procurement/Application/Requisition/RequisitionView/RequisitionViewView.cfm?"+
				"&height="+document.body.offsetHeight+
				"&systemfunctionid="+modid+
	            "&id=WHS&mission="+mis+"&warehouse="+whs+"&sort="+grp+"&page="+pge
	}			
	
	ptoken.navigate(url,'main')		

}

// show receipts in requisition detail 
	
function more(box,req,act,mode) {
							
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


	
// PROCESSES 

// SAVE TRANSACTION INITIAL STOCK
	
	function submitline() {
	
	if (confirm("#tConfirm# ?")) {
	
		whs  = document.getElementById("warehouse").value	
		tpe  = document.getElementById("tratpe").value
		des  = document.getElementById("description").value
		
		url = "../Transaction/TransactionSubmit.cfm?ts="+new Date().getTime()+
		            "&height="+document.body.offsetHeight+ 
		            "&whs="+whs+
					"&tpe="+tpe+
					"&des="+des;
					
		ptoken.navigate(url,'main')					 
		}		
	
	}		

// PREPARE PICKTICKET 
	
function stockpickingprocess(sid) {

	  count = 0
	  id = ''
	  se = document.getElementsByName("selected")
	  while (se[count]) {
		  if (se[count].checked == true) {
		  
		  	if (id == '') 
			     { id = se[count].value}
			  else
			     { id = id+","+se[count].value}
		 } 		 
		 count++ 
	     }
	
	  if (id == '') {
	       alert("#tNoLines#") 
		   }
		   
	  else {   
	
  	    mis  = document.getElementById("mission").value	
	  	whs  = document.getElementById("warehouse").value	
		url = "../Pickticket/PickingTicketProcess.cfm?ts="+new Date().getTime()+
				    "&height="+document.body.offsetHeight+		            
					"&systemfunctionid="+sid+
					"&warehouse="+whs+
					"&mission="+mis		
		}	
		
		ptoken.navigate(url,'main','','','POST','pickingform')				
}

function printpickticket(template,req) {
		ptoken.open("#SESSION.root#/Tools/CFReport/OpenReport.cfm?template="+template+"&ID1="+req, "_blank", "left=60, top=60, width=800, height=600, toolbar=no, menubar=no, status=yes, scrollbars=no, resizable=yes");
	}
		  
// Transfer dialog 
	 
function trfsave(id,whsto,locto,meter,ini,fnl,qty,mem,itemuomid,dte,hr,mi) {        	
		whs  = document.getElementById("warehouse").value	 		
		mis  = document.getElementById("mission").value			
		_cf_loadingtexthtml='';									
		url = "../Transfer/StockTransferSave.cfm?whs="+whs+"&id="+id+"&warehouse="+whsto+"&location="+locto+"&quantity="+qty+"&meter="+meter+"&initial="+ini+"&final="+fnl+"&memo="+mem+"&itemuomid="+itemuomid+"&date="+dte+"&hour="+hr+"&minute="+mi		
		ptoken.navigate(url,'f'+id)									
	 }			  
	 
function trfsubmit(mis,modid,stid,loc) {		
        Prosis.busy('yes')
	  	whs  = document.getElementById("warehouse").value					
		url  = "../Transfer/StockTransferSubmit.cfm?loc="+loc+"&systemfunctionid="+modid+"&tpe=8&mis="+mis+"&whs="+whs  	
		ptoken.navigate(url,'main')				
	}			
	 	 	
//		
// INVENTORY
//

function locarcshow(whs,loc,itm,uom,lot,box,action) {			

		icM  = document.getElementById(box+"min");
		icE  = document.getElementById(box+"exp");
		se   = document.getElementById(box);	
		rw   = document.getElementById(box+"_box");	
								
		if (icM != null && icE != null && se != null) {
			if (se.className == "hide" || action == "enforce") {

			   	 icM.className = "regular";
			     icE.className = "hide";
				 se.className  = "regular";		
				 rw.className = "regular";	 		 			 
				 url = "../Inventory/InventoryArchiveList.cfm?warehouse="+whs+"&location="+loc+"&itemno="+itm+"&uom="+uom+"&transactionlot="+lot;
				 _cf_loadingtexthtml='';	
				 ptoken.navigate(url,box);					

			 } else {

			   	 icM.className = "hide";
			     icE.className = "regular";
		    	 se.className  = "hide"
				 rw.className  = "hide";	 	
			 }
		}
  }

function toggleLocations() {
	var vState = '';

	//reset dom filter
	$('##filtersearchsearch').val('').trigger('keyup');

	if ($('.clsLocToggler').hasClass('fa-folder')) {
		$('.clsLocToggler').addClass('fa-folder-open').removeClass('fa-folder');
		vState = 'open';
	} else {
		$('.clsLocToggler').addClass('fa-folder').removeClass('fa-folder-open');
		vState = 'closed';
	}

	$('.clsCategoryLine').each(function() {
		var vBox = 'box' + $(this).attr("data-value");
		if ($('##'+vBox).is(':visible') && vState != 'open') {
			$(this).trigger('click');
		}
		if (!$('##'+vBox).is(':visible') && vState != 'closed') {
			$(this).trigger('click');
		}
	});
}	 

function locshow(loc,cat,catitm,box,sysid,enf,find,zero,pi,ear,ref) {
		 		
		mis  = document.getElementById("mission").value	
	  	whs  = document.getElementById("warehouse").value				
		icM  = document.getElementById(box+"Min");
		icE  = document.getElementById(box+"Exp");
		se   = document.getElementById(box);
		dte  = document.getElementById("transaction_date").value
		hour = document.getElementById("transaction_hour").value
		minu = document.getElementById("transaction_minute").value
						 		 
		if (se.className == "hide" || enf == "1") {
		
		     Prosis.busy('yes');
		   	 icM.className = "regular";
		     icE.className = "hide";
			 se.className  = "regular";
			 _cf_loadingtexthtml='';				 
			 url = "../Inventory/InventoryViewList.cfm?box="+box+"&warehouse="+whs+"&location="+loc+"&category="+cat+"&categoryitem="+catitm+"&systemfunctionid=" + sysid + "&find=" + find + "&zero=" + zero + "&transaction_date=" + dte + "&transaction_hour=" + hour	+ "&transaction_minute=" + minu + "&parentItemNo=" + pi + "&earmark=" + ear	 + "&refresh=" + ref
			 /*
			 window['fnLocShowCB'] = function(){
				 if ($('##filtersearchsearch').length == 1) {
					 $('##filtersearchsearch').trigger('keyup'); }
			 }
			 ptoken.navigate(url, 'c'+box, 'fnLocShowCB')	
			 */
			 ptoken.navigate(url, 'c'+box);
			 				
		 } else {
		     Prosis.busy('no')
		   	 icM.className = "hide";
		     icE.className = "regular";
	    	 se.className  = "hide"
		 }
	  }	 
	  
<!--- stores info in temp screen --->
	 
function invsave(id,qty,mode,sysid,box) {	
		
		mis  = document.getElementById("mission").value	
	  	whs  = document.getElementById("warehouse").value						 
		url = "../Inventory/InventorySave.cfm?box="+box+"&id="+id+"&warehouse=" + whs+"&quantity=" + qty + "&mode=" + mode + "&systemfunctionid=" + sysid	
		if (mode == 'metric') {
		ptoken.navigate(url,'process')		 
		} else {
		ptoken.navigate(url,'f'+id)		
		}
			 				
	 }		
	 
 function zerotoggle(act) {
				  
		 if (act) {
		   $('.zero').hide();
		 } else {
		   $('.zero').show();
		 }
		 
		} 
			  	 

<!--- archives measurement on a -daily- basis --->	 
function invarchive(loc,itm,uom,lot,sysid,row,box) {       
		whs  = document.getElementById("warehouse").value	
		_cf_loadingtexthtml='';						
		url = "../Inventory/InventoryArchiveSave.cfm?box=" + box + "&whs=" + whs + "&loc=" + loc  + "&itemno=" + itm + "&uom=" + uom + "&transactionlot=" + lot + "&systemfunctionid=" + sysid + "&currentrow=" + row			
		ptoken.navigate(url,'process','','','POST','forminventory_'+box)					
	 }				 	 

 <!--- submits for stock on hand amendment --->	
function invsubmit(loc,cat,catitm,sysid,box,pi) {		 		
		mis  = document.getElementById("mission").value	
	  	whs  = document.getElementById("warehouse").value					
		url = "../Inventory/InventorySubmit.cfm?box=" + box + "&tpe=5&mis=" + mis + "&whs=" + whs + "&loc=" + loc + "&category=" + cat + "&categoryitem=" + catitm + "&systemfunctionid=" + sysid + "&parentItemNo=" + pi			
		ptoken.navigate(url,box+'_'+loc,'','','POST','forminventory_'+box)					
	 }			

function resupplyupdate(line,qty,st,sec,srt) {				

		if (st == true) { sta = 1 } else { sta = 0 }		
		whs  = document.getElementById("warehouse").value						
		url = "../Resupply/setResupplyLine.cfm?warehouse="+whs+"&lineno="+line+"&quantity="+qty+"&status="+sta+"&section="+sec+"&sort="+srt					
		ptoken.navigate(url,'c'+line)		 
	}

function resupply(s,modid,res,mde) {			   
		document.getElementById("optionselect").value = "resupply('s','"+modid+"')"			
		whs  = document.getElementById("warehouse").value;			
		mis  = document.getElementById("mission").value;	
		try { srt  = document.getElementById("sort").value;	} catch(e) { srt = 'category' }
		
		if (res != "") {
				    
			Prosis.busy('yes')				
			url = "../Resupply/ResupplyPrepare.cfm?height="+document.body.offsetHeight+
						"&systemfunctionid="+modid+
			            "&warehouse="+whs+
						"&sort="+srt+
						"&restocking="+res+
						"&mode="+mde+
						"&mission="+mis				
			_cf_loadingtexthtml='';				
			ptoken.navigate(url,'subbox','','','POST','criteria')			
		
		}
	}	
	
function resupplysort(s,modid,res) {		

		document.getElementById("optionselect").value = "resupply('s','"+modid+"')"	
		
		whs   = document.getElementById("warehouse").value;	
		mis   = document.getElementById("mission").value;	
		srt   = document.getElementById("sort").value
		off   = document.getElementById("offer").value
		if (res != "") {
		Prosis.busy('yes')				
		url = "../Resupply/ResupplyListing.cfm?systemfunctionid="+modid+
		            "&warehouse="+whs+					
					"&restocking="+res+
					"&sort="+srt+	
					"&offer="+off+				
					"&mission="+mis				
		_cf_loadingtexthtml='';				
		ptoken.navigate(url,'subbox','','','POST','criteria')			
		
		}
	}						

function funding(clr,fundingid,act,fd,obj,pg,perc,pgper) {	
					
		reqno  = document.getElementById("requisitionno").value
		mis    = document.getElementById("mission").value			
		per    = document.getElementById("period").value		
						
		ptoken.navigate('#SESSION.root#/Procurement/Application/Requisition/Requisition/RequisitionEntryFunding.cfm?enforcefund=1&archive=0&clear='+clr+'&mission='+mis+'&access=edit&per='+per+'&id='+reqno+'&object='+obj+'&fundingid='+fundingid+'&action='+act+'&fund='+fd+'&objectcode='+obj+'&programcode='+pg+'&percentage='+perc+'&period='+pgper+'&itemmaster=','fundbox')
		document.getElementById("fundingentered").value = 1;	
		try { tagging() } catch(e) {}							
	
}


function fd() {

	   w     = #CLIENT.width# - 100;
	   h     = #CLIENT.height# - 150;
	   reqno = document.getElementById("requisitionno").value
	   unit  = document.getElementById("orgunit1").value;	 
	   mis   = document.getElementById("mission").value;	 
	   per   = document.getElementById("period").value;	     
	   obj   = ""
	   
	   if (unit != "") {
	   	   
	    <cfif Parameter.EnforceProgramBudget eq "1">
		
		 	ptoken.open("#SESSION.root#/Procurement/Application/Requisition/Funding/RequisitionEntryFundingSelect.cfm?Mission="+mis+"&ID="+reqno+"&Object="+obj+"&Period=" + per + "&Org=" + unit + "&itemmaster=", "_blank", "left=20, top=20, width=" + w + ", height= " + h + ", status=yes, toolbar=no, scrollbars=no, resizable=no");	
	
		<cfelse>
		
			ptoken.open("#SESSION.root#/Procurement/Application/Requisition/Funding/RequisitionEntryFundingSelect.cfm?Mission="+mis+"&ID="+reqno+"&Object="+obj+"&Period=" + per + "&Org=" + unit + "&itemmaster=", "_blank", "left=20, top=20, width=" + w + ", height= " + h + ", status=yes, toolbar=no, scrollbars=no, resizable=no");	
		
		</cfif>
			
	   }  else  { alert("#tRequesting#") }	  
}	
	
function resupplysubmit(id,menuid,status) {
	
	mis  = document.getElementById("mission").value		
	whs  = document.getElementById("warehouse").value			
	res  = document.getElementById("restocking").value		
		
	url = "../Resupply/ResupplyListingSubmit.cfm?mission="+mis+"&reqno="+id+"&warehouse="+whs+"&restocking="+res+"&systemfunctionid="+menuid+"&status="+status	
	ptoken.navigate(url,'submitted','','','POST','criteria')	
	 
}

// added

function save_manual_transaction(w,m,p,menuid,details) {

	var temps        = '';	
	var verror       = false;
	var reference    = $("##transactionreference").val();
	var person       = $("##personno").val();
	var mode         = $("##transactionreferencemode").val();
	var item_no      = $("##itemno").val();
	var asset_id     = $("##assetid").val();
	var transaction_type = $("##tratpe").val();
	var transaction_qty = $("##transactionquantity").val();

	if (!item_no || item_no == '') {
		$("##itemno").css({'background-color' : '##F79898'});
		$("##itemno").focus();
		alert('You must select a supply item')
		verror = true;
		return false;
	}		
	
	if (transaction_type == '2' && asset_id == '') {
		$("##assetbox").css({'background-color' : '##F79898'});
		$("##assetid").focus();
		alert('You need to select an equipment item')
		verror = true;
		return false;
	}		
	
	if (transaction_type == '2' && mode == '1' && reference == '') {	
		$("##transactionreference").css({'background-color' : '##F79898'});	
		$("##transactionreference").focus();
		alert('You must enter an issuance reference')
		verror = true;
		return false;
	}		
	
	if (transaction_type == '2' && mode == '1' && person == '') {		
		$("##personselect").css({'background-color' : '##F79898'});	
		$("##personselect").focus();
		alert('You must select a recipient')
		verror = true;
		return false;
	}		

	if (asset_id) {
		//it is an item, thus we need to check other things for metrics
		$(".value").each(function()
		{	
			  value = $(this).val().replace(',','');
			  if (value != ''){
				  $(this).css({'background-color' : '##FFFFFF'});
				  
				  if (isNaN(value)){
					  $(this).css({'background-color' : '##F79898'});
					  if (!verror)
					  {
						alert('Please submit only numeric values');
						$(this).focus();
					  }	
					 verror = true;						
				  }
				  else
					  if (temps == '')   
					    temps = $(this).attr('name')+'_'+value;
				     else  
					    temps = temps+","+$(this).attr('name')+'_'+value;
				  
			  }	  
			  else {
				if (!verror){
					alert('You should enter a numeric value');
					$(this).focus();
					verror = true;
				}
				$(this).css({'background-color' : '##F79898'});
			  }
		});
		
		//Now we check for the asset details
		var temps_details = '';
		$(".detailvalue").each(function()
		{	
		  value = $(this).val();
		  if (temps_details == '')   
		    temps_details = $(this).attr('name')+'_'+value;
	     else  
		    temps_details = temps_details+","+$(this).attr('name')+'_'+value;
		
		});

		
	}	

	if (transaction_qty =='' || isNaN(transaction_qty.split(",").join("")))	{
		$("##transactionquantity").css({'background-color' : '##F79898'});
		if (!verror) {
			alert('You must enter a numeric quantity')
			$("##transactionquantity").focus();						
		} else	
		  verror = true;
		 return false;
	}
	
	$("##transactionquantity").css({'background-color' : '##FFFFFF'}); 
	$("##personselect").css({'background-color' : '##FFFFFF'}); 
	$("##transactionreference").css({'background-color' : '##FFFFFF'}); 
		
	if (verror)
		return false;
	else {
		$("##metrics").val(temps);	
		$("##assetdetails").val(temps_details);	
						
		if (details == true) {
	 		det = 1
		} else {
			det = 0
		}
		
		_cf_loadingtexthtml="";		
		ptoken.navigate('../Transaction/TransactionLogSheetSubmit.cfm?details='+det+'&systemfunctionid='+menuid+'&mode='+m+'&warehouse='+w+'&portal='+p,'detail','','','POST','transactionform')
		_cf_loadingtexthtml="<div><img src='<cfoutput>#SESSION.root#</cfoutput>/images/busy11.gif'/>";						 
			
	}
		
}

function processStockIssue(mode,warehouse,transtype,wlocation,itemno,uom,batchid,menuid) { 

	var vOpen      = '';
	var vClose     = '';
	var vOpenDate  = '';
	var vCloseDate = '';
	var vOpenTime  = '';
	var vCloseTime = '';
	var vErrorMessage = '';
	var vTest      = '';
	var vDay       = '';
	var vMonth     = '';
	var vYear      = '';
	var vHour      = '';
	var vMinute    = '';
	var vDate1 = new Date(1990,0,1);
	var vDate2 = new Date(1990,0,1);
	var vValidateRoleActor = '';
	var vActorList = '';
	
	try {
	  descript = document.getElementById('description').value }
	  catch(e) {
	  descript = ""
	  }
	
	//if is not an issue
	
	if (mode.toLowerCase() != 'issue') {
	
		if (confirm('#meterReadingConfirm#')) {						   
			ptoken.navigate('../Transaction/Submission/TransactionSubmit.cfm?systemfunctionid='+menuid+'&batchid='+batchid+'&mode='+mode+'&warehouse='+warehouse+'&tratpe='+transtype+'&des='+descript,'detail');
		}
		
	} else {
	
		//if it is an issue
		
		//if transaction meter is enabled
		if ($('##transactionOpening').length > 0) {
			
			vOpen = $('##transactionOpening').val().replace(/ /g,'');
			vClose = $('##transactionClosing').val().replace(/ /g,'');
			
			//if the cfwindow is open
			
			if ($('##openReadingDate_date').length > 0) {
			
				vOpenDate = $('##openReadingDate_date').val();
				vOpenTime = $('##openReadingDate_hour').val() + ':' + $('##openReadingDate_minute').val() + ':00';
				vCloseDate = $('##closeReadingDate_date').val();
				vCloseTime = $('##closeReadingDate_hour').val() + ':' + $('##closeReadingDate_minute').val() + ':00';
			
				//validate date 1
				vTest = $('##openReadingDate_date').val();
				
				if ('#APPLICATION.DateFormat#' == 'EU') {
					vDay   = vTest.substring(0,2);
					vMonth = vTest.substring(3,5);
					vYear  = vTest.substring(6,10);
				} else {
					vMonth = vTest.substring(0,2);
					vDay   = vTest.substring(3,5);
					vYear  = vTest.substring(6,10);
				}
				vHour = $('##openReadingDate_hour').val();
				vMinute = $('##openReadingDate_minute').val();
		
				vDate1 = new Date(parseInt(vYear), parseInt(vMonth)-1, parseInt(vDay), parseInt(vHour), parseInt(vMinute), 0, 0);
				
				//validate date 2
				vTest = $('##closeReadingDate_date').val();
				if ('#APPLICATION.DateFormat#' == 'EU') {
					vDay = vTest.substring(0,2);
					vMonth = vTest.substring(3,5);
					vYear = vTest.substring(6,10);
				} else {				
					vMonth = vTest.substring(0,2);
					vDay = vTest.substring(3,5);
					vYear = vTest.substring(6,10);
				}
				
				vHour   = $('##closeReadingDate_hour').val();
				vMinute = $('##closeReadingDate_minute').val();				
				vDate2  = new Date(parseInt(vYear), parseInt(vMonth)-1, parseInt(vDay), parseInt(vHour), parseInt(vMinute), 0, 0);
			}
			
			//validate that open and close are not empty, open <= close (reading and date)
			
			vValidateRoleActor = validateTransactionActors();
			if (vOpen != '' && vClose != '' && parseFloat(vOpen) <= parseFloat(vClose) && vDate1 <= vDate2 && vValidateRoleActor == '') {
			
				if (confirm('#meterReadingConfirm#')) {
				
					//get actors list
					vActorList = '';
					var searchElements = $('.roleRole');
					for (var k = 0; k < searchElements.length; ++k) {	
						vRole = searchElements[k].value;
						vActorList = vActorList + '&role_' + vRole + '=' + vRole;
						vActorList = vActorList + '&personNo_' + vRole + '=' + $('##personno_'+vRole).val();
						vActorList = vActorList + '&reference_' + vRole + '=' + $('##reference_'+vRole).val();
						vActorList = vActorList + '&firstname_' + vRole + '=' + $('##firstname_'+vRole).val();
						vActorList = vActorList + '&lastname_' + vRole + '=' + $('##lastname_'+vRole).val();
					}				    
					ptoken.navigate('../Transaction/Submission/TransactionSubmit.cfm?systemfunctionid='+menuid+'&batchid='+batchid+'&mode='+mode+'&warehouse='+warehouse+'&tratpe='+transtype+'&location='+wlocation+'&itemno='+itemno+'&uom='+uom+'&tsOpenDate='+vOpenDate+'&tsOpenTime='+vOpenTime+'&tsCloseDate='+vCloseDate+'&tsCloseTime='+vCloseTime+vActorList,'detail');
					
				}
				
			}else{
			
				if (vOpen == '' || vClose == '') { 
					vErrorMessage = '#meterReadingErrorMessage1#'; 
				}
				if (parseFloat(vOpen) > parseFloat(vClose) && vOpen != '' && vClose != '') { 
					vErrorMessage = '#meterReadingErrorMessage2#'; 
				}
				if (vDate1 > vDate2) { 
					vErrorMessage = '#meterReadingErrorMessage3#'; 
				}
				if (vValidateRoleActor != '') {
					vErrorMessage = '#meterReadingErrorMessage4#'; 
				} 
				 
				try { ColdFusion.Window.destroy('dialogMeterReadings',true)} catch(e){};
		   		ColdFusion.Window.create('dialogMeterReadings', 'Meter Readings', '',{x:100,y:100,width:650,height:350,resizable:true,modal:true,center:true});
		   		ptoken.navigate('../Transaction/Submission/TransactionMeterReading.cfm?systemfunctionid='+menuid+'&mode='+mode+'&warehouse='+warehouse+'&tratpe='+transtype+'&location='+wlocation+'&itemno='+itemno+'&uom='+uom+'&message='+vErrorMessage,'dialogMeterReadings');
				
			}	
		
		} else {
			
			//if transaction meter is NOT enabled
			
			if (confirm('#meterReadingConfirm#')) {
				ptoken.navigate('../Transaction/Submission/TransactionSubmit.cfm?systemfunctionid='+menuid+'&batchid='+batchid+'&mode='+mode+'&warehouse='+warehouse+'&tratpe='+transtype+'&location='+wlocation+'&itemno='+itemno+'&uom='+uom,'detail');
			}
		}
	}
}

function validateTransactionActors() {
	
	var vRet = '';
	var vRole = '';
	
	var searchElements = $('.roleObligatory');
	for (var k = 0; k < searchElements.length; ++k) {	
		if (searchElements[k].value == 1) {
			vRole = searchElements[k].id.substring(11,searchElements[k].id.length);
			if ($('##firstname_'+vRole).val().replace(/ /g,'') == '' || $('##lastname_'+vRole).val().replace(/ /g,'') == '') {
				vRet = vRole;
			}
		}
	}
	
	return vRet;
}

function clearStockIssueEndFocus() {
	 $('.roleReference').first().focus();}

<!--- Distribution Receipts --->

	function submitSelectedItems(mis,whs) {
		document.getElementById('menu1').className = 'regular';
		document.getElementById('menu2').className = 'highlight';
		ptoken.navigate('#SESSION.root#/warehouse/application/stock/receipt/StockReceiptProcessView.cfm?mission='+mis+'&warehouse='+whs,'contentbox1');
	}
	
	function selectItem(mis,whs,i) {	
		
		var id;
		
		ptoken.navigate('#SESSION.root#/warehouse/application/stock/receipt/setSelectItem.cfm?mission='+mis+'&warehouse='+whs+'&list='+i.value+'&value='+i.checked,'processSelectItem');
		
		id = i.id.substring(5,i.id.length);
		if (i.checked) {
			$('##quantity_'+id).show(100);
			$('##quantity_'+id).select();
		}else{
			$('##quantity_'+id).hide(100);
		}				
		updateSelectedCounter();		
	}
	
	function selectAllItems(mis,whs,i) {
	
		var vList = "";
		
		if ($('.clsItem:visible:checked').length == 0) {
			$('##selectAll').prop('checked', true);
			$('.clsItem:visible').prop('checked', true);
			$('.clsCategorySelector').prop('checked', true);
			$('.clsDetail:visible .clsTransferQuantity').css({'display':'block'});
		}else{
			$('##selectAll').prop('checked', false);
			$('.clsItem:visible').prop('checked', false);
			$('.clsCategorySelector').prop('checked', false);
			$('.clsDetail:visible .clsTransferQuantity').css({'display':'none'});
		}
		updateSelectedCounter();
		
		var searchElements = $('.clsItem:visible');
		for (var k = 0; k < searchElements.length; ++k) {	
			vList = vList + "," + searchElements[k].value;
		}
		if (vList != "") { vList = vList.substring(1,vList.length); }
		
		ptoken.navigate('#SESSION.root#/warehouse/application/stock/receipt/setSelectItem.cfm?mission='+mis+'&warehouse='+whs+'&list='+vList+'&value='+i.checked,'processSelectItem');
	}
	
	function selectItemsByCategory(mis,whs,cat,i) {
		var vList = "";
		
		$('.'+ cat +':visible input[class=clsItem]').prop('checked', i.checked);
		if (i.checked) {
			$('.'+ cat +':visible .clsTransferQuantity').css({'display':'block'});
		}else{
			$('.'+ cat +':visible .clsTransferQuantity').css({'display':'none'});
		}
		
		if ($('.clsItem:visible:checked').length == 0) {
			$('##selectAll').prop('checked', false);
		}else{
			$('##selectAll').prop('checked', true);
		}
		
		updateSelectedCounter();
		
		var searchElements = $('.'+ cat +':visible input[class=clsItem]');
		for (var k = 0; k < searchElements.length; ++k) {	
			vList = vList + "," + searchElements[k].value;
		}
		if (vList != "") { vList = vList.substring(1,vList.length); }
		
		ptoken.navigate('#SESSION.root#/warehouse/application/stock/receipt/setSelectItem.cfm?mission='+mis+'&warehouse='+whs+'&list='+vList+'&value='+i.checked,'processSelectItem');
	}
	
	function updateSelectedCounter() {
		$('##selectedCounter').html($('.clsItem:checked').length);
	}
	
	function updateCategoryInfo() {
	
		var searchCategories;
		var testCategory;
		var testAll;
		var testAllVisible;
		var testAllHidden;
		var testCheckedHidden;
		var hiddenText = "";
		var selectedText = "";

		searchCategories = $('.headerCategoryDescription input[class=clsCategorySelector]');
		for (var i = 0; i < searchCategories.length; ++i) {
		
			testCategory = "";
			hiddenText = "";
			selectedText = "";
			
			testCategory = searchCategories[i].id.substring(6,searchCategories[i].id.length);
			testAll = $('.'+ testCategory +' input[class=clsItem]');
			testAllVisible = $('.'+ testCategory +' input[class=clsItem]:visible');
			testCheckedHidden = $('.'+ testCategory +' input[class=clsItem]:hidden:checked');
			
			if ($(testAllVisible).length == $(testAll).length) {
				$('##info_'+testCategory).html('');
			}else{
				testAllHidden = $(testAll).length - $(testAllVisible).length;
				
				hiddenText = testAllHidden + ' hidden';
				if (testCheckedHidden.length > 0) { 
					selectedText = ', ' + $(testCheckedHidden).length + ' selected';
				}
				
				$('##info_'+testCategory).html('('+hiddenText+selectedText+')');
			}
		}		
		$('##imgBusy').css({'display':'none'});
	}
			
	function receiptCopyWarehouse(c) {
		var whs = $('##warehouse_'+c).val();
		var tId = "";
		$('.clsWarehouse').each(function(index) {
    		$(this).val(whs);
			tId = $(this).attr('id');
			tId = tId.substring(10,tId.length);
			ptoken.navigate('#SESSION.root#/warehouse/application/stock/receipt/getLocation.cfm?warehouse='+whs+'&transactionid='+c,'divLocation_'+tId);
		});
	}
	
	function removeReceiptTemp(mis,whs,id) {
		ptoken.navigate('#SESSION.root#/warehouse/application/stock/receipt/ReceiptItemDelete.cfm?mission='+mis+'&warehouse='+whs+'&id='+id,'contentbox1');
	}
	
	function refreshReceiptDetail(mis,whs) {
		var selWarehouse = $('##fwarehouse').val();
		var selLocation  = $('##flocation').val();		
		ptoken.navigate('#SESSION.root#/warehouse/application/stock/receipt/StockReceiptProcessViewDetail.cfm?mission='+mis+'&warehouse='+whs+'&fwarehouse='+selWarehouse+'&flocation='+selLocation,'divReceiptProcessDetail');
	}
	
	function saveChangeTmpReceipt(mis,whs,fld,val,id,validate) {

		ptoken.navigate('#SESSION.root#/warehouse/application/stock/receipt/ReceiptItemAdd.cfm?mission='+mis+'&warehouse='+whs+'&field='+fld+'&value='+val+'&id='+id+'&validate='+validate,'processTempReceipt');
		
		if (fld.toLowerCase() == "transferwarehouse") { $('##flocation').val(""); }
		
		if($('##fwarehouse').val() == "" || $('##flocation').val() == "") {
			$('##btnSubmitTransferItems').hide(250);
			$('.clsTwistiePrices').hide(250);
		}else{
			$('##btnSubmitTransferItems').show(250);
			$('.clsTwistiePrices').hide(250);
		}
	}
	
	
	function warningApplyEntity(control){
		if (control.checked) {
			if (confirm('#warningApplyEntity1#.\n\n#warningApplyEntity2#')) {
				control.checked = true;
			}else{
				control.checked = false;
			}
		}
	}
	
	function toggleReceiptPriceDetail(mis,whs,destWh,id,row,target,type) {
	
		if ($('##priceDetail_'+id).is(':hidden')) {		
			$('##priceDetail_'+id).show(250,function(){ $('.calendar').show(50); });
			$('##twistiePrice_'+id).attr('src','#SESSION.root#/images/toggle_down.png');
			$('##twistiePrice_'+id).attr('title','#vHidePrice#');			
			ptoken.navigate('#SESSION.root#/Warehouse/Application/Stock/Receipt/PriceManagement/itemPrice'+type+'.cfm?mission='+mis+'&warehouse='+whs+'&destinationWarehouse='+destWh+'&id='+id+'&row='+row,target);			
		}else{		
			$('.calendar_'+id).hide(1);
			$('##priceDetail_'+id).hide(400);
			$('##twistiePrice_'+id).attr('src','#SESSION.root#/images/toggle_up.png');
			$('##twistiePrice_'+id).attr('title','#vShowPrice#');			
		}
	}	
	
	function submitReceiptItemPrice(mis,whs,destWH,id,sche,cur) {
		var inherit = 0;
		
		if ($('##inherit_'+id+'_'+sche+'_'+cur).is(':checked')) {
			inherit = 1;
		}
		var dateEffective = $('##dateEffective_'+id+'_'+sche+'_'+cur).val();
		var taxCode = $('##taxCode_'+id+'_'+sche+'_'+cur).val();
		var salesPrice = $('##salesPrice_'+id+'_'+sche+'_'+cur).val();
		salesPrice = salesPrice.replace(/,/g,'');		
		var vId = 'processReceiptItemPrice_'+id+'_'+sche+'_'+cur;		
		ptoken.navigate('#SESSION.root#/warehouse/application/stock/receipt/PriceManagement/ItemPriceSubmit.cfm?mission='+mis+'&warehouse='+whs+'&destinationWarehouse='+destWH+'&id='+id+'&schedule='+sche+'&currency='+cur+'&salesPrice='+salesPrice+'&taxCode='+taxCode+'&inherit='+inherit+'&dateEffective='+dateEffective,vId);		
		setTimeout("$('##"+vId+"').html('');",2000);
	}
	
	function submitTransfer(mis,whs){
		document.frmProcessReceipt.onsubmit(); 
		if( _CF_error_messages.length == 0 ) { 
			if (confirm('#vQuestionSubmitTransfer# ?')) {       
				ptoken.navigate('#SESSION.root#/warehouse/application/stock/receipt/StockReceiptProcessSubmit.cfm?mission='+mis+'&warehouse='+whs,'contentbox1','','','POST','frmProcessReceipt');
			}
		}
	}

	<!--- Inspection scripts ---->
	
	function twistWf(inspectionId, loadWF){
	
		td     = document.getElementById(inspectionId);
		tdMemo = document.getElementById(inspectionId+'_memo');
		
		if (td.className == 'hide'){
			td.className = 'regular';
			tdMemo.className = 'regular';
			
			if (loadWF == 1){
				ptoken.navigate('#SESSION.root#/Warehouse/Application/Stock/Inspection/InspectionWorkflow.cfm?ajaxid='+inspectionId,inspectionId);
			}
			
		}else{
		
			td.className = 'hide';
			tdMemo.className = 'hide';
		}
	}
	
	function addInspectionRecord(warehouse){
		ptoken.navigate('#SESSION.root#/Warehouse/Application/Stock/Inspection/InspectionListing.cfm?mode=new&warehouse='+warehouse,'contentListing');
	}
	
	function submitInspection(warehouse){
		document.inspectionForm.onsubmit(); 
		if( _CF_error_messages.length == 0 ) { 
			ptoken.navigate('#SESSION.root#/Warehouse/Application/Stock/Inspection/InspectionSubmit.cfm?warehouse='+warehouse+'&action=new','contentListing','','','POST','inspectionForm');
		}
	}

	function deleteInspection(warehouse, inspectionId){
		if (confirm("Are you sure you want to delete this record?")){
			ptoken.navigate('#SESSION.root#/Warehouse/Application/Stock/Inspection/InspectionSubmit.cfm?action=delete&warehouse='+warehouse+'&inspectionid='+inspectionId,'contentListing');
		}
	}
	
	 setSelected = function() { 
		$('a.selected').each(function() {
			$(this).click();
		});
	} 
	
</script>

<script language="JavaScript">

	<!------------------------ --->
	<!--- saleorder controller --->
	<!--- -------------------- --->
		
	function salesdaytotal()	{	  
		 
		mis = document.getElementById('mission').value   
		whs = document.getElementById('warehouse').value
		try { ProsisUI.closeWindow('daytotal',true)} catch(e){};
   		ProsisUI.createWindow('daytotal', 'Day totals', '',{x:100,y:100,width:1080,height:650,resizable:true,modal:true,center:true});
   		ptoken.navigate('#SESSION.root#/Warehouse/Application/Salesorder/POS/Inquiry/daytotal.cfm?systemfunctionid=#url.systemfunctionid#&mission='+mis+'&warehouse='+whs,'daytotal');				
		
	}			
	
	function doTransferStock(w)	{
		ptoken.navigate('#SESSION.root#/warehouse/Application/SalesOrder/POS/Transfer/TransferSubmit.cfm?warehouse='+w,'wtransfer','','','POST','fTransfer');
	}

	function salesTransfer(id,w)	{	  
		
		try { ProsisUI.closeWindow('wtransfer',true)} catch(e){};
		ProsisUI.createWindow('wtransfer', 'Transfer', '',{x:100,y:100,width:980,height:650,resizable:true,modal:true,center:true});
		ptoken.navigate('#SESSION.root#/Warehouse/Application/SalesOrder/POS/Transfer/Transfer.cfm?systemfunctionid=#url.systemfunctionid#&warehouse='+w+'&id='+id,'wtransfer');
				
	}			

	function salesOverlap(id,w)	{	 
		
		try { ProsisUI.closeWindow('woverlap',true)} catch(e){};
		ProsisUI.createWindow('woverlap', 'Overlap', '',{x:100,y:100,width:800,height:480,resizable:true,modal:true,center:true});
		ptoken.navigate('#SESSION.root#/Warehouse/Application/SalesOrder/POS/overlap.cfm?systemfunctionid=#url.systemfunctionid#&id='+id+'&warehouse='+w,'woverlap');
				
	}		
	
	function salesfocus() {
		$('##customerselect').focus();  
	}
	
	function voidSale(c,w,id,trm,req) {
		if (confirm('This action will remove the whole sale transaction.\nDo you really want to void this sale ?')) {
			ptoken.navigate('#SESSION.root#/warehouse/application/salesOrder/POS/Sale/SaleVoidPerform.cfm?requestno='+req+'&terminal='+trm+'&customerid='+c+'&warehouse='+w+'&id='+id,'divVoidDocument');
		}
	}
			
    function delete_tmp_transaction(id,whs,mode) {
        ptoken.navigate('#SESSION.root#/warehouse/application/stock/transaction/transactiondetaillinesdelete.cfm?id='+id+'&warehouse='+whs+'&mode='+mode,'line_'+id);                         
    }	
	 
	function splitTask(taskid, quantity){
		q1 = document.getElementById('quantity1').value;
		q2 = document.getElementById('quantity2').value;
		split = parseFloat(q1) + parseFloat(q2);
		if  (split == quantity){
			ptoken.navigate('#SESSION.root#/Warehouse/Application/StockOrder/Task/Shipment/TaskSplitSubmit.cfm?taskid='+taskid+'&q1='+q1+'&q2='+q2,'split_result');			
		}else{
			alert('The values you entered did not make '+quantity);
		}
	 }
	 
	 function unlinkRequestTask(id,scope){
			ptoken.navigate('#SESSION.root#/Warehouse/Application/StockOrder/Task/Shipment/UnlinkTask.cfm?taskid='+id+'&context=cfwindow&scope='+scope,'dialogprocesstask');
	 }

	 function doItemSelect(search,e,whs) {
	     	     
		 if (e == null || e.keyCode == 13) {
		     if (search.value != '') {
			     ptoken.navigate('#SESSION.root#/warehouse/application/salesorder/POS/Sale/getSaleItem.cfm?warehouse='+whs+'&search='+search.value,'finditem','','','POST','saleform');
			     search.value = '';
			 }
		 }
	 }
	 
	 function doItemMatch(whs,uomid) {	    		    
		ptoken.navigate('#SESSION.root#/warehouse/application/salesorder/POS/Sale/getSaleItem.cfm?warehouse='+whs+'&itemuomid='+uomid,'finditem','','','POST','saleform');		
		ProsisUI.closeWindow('itemselectbox')
	 }

</script>

<!--- local stylesheet settings --->

<style>	 
	 	
	.value {
		text-align:right;	
		width:90;
		padding: 0 2px 0 0;	
	}	
	
	.regular_number {
		text-align:right;	
		width:90;
		padding: 0 2px 0 0; }		 
	
	.previous {
		font: 8px Verdana, Arial, Helvetica, sans-serif;}
	
	.small {		
		font: 8px Verdana, Arial, Helvetica, sans-serif;}		
	
	.inputamount {
	    font-family: calibri;
	    font-size: 2em;
	    margin-left: 5px;
	    padding-left: 2px;
	    padding-right: 3px;
		text-align:right;
		background-color: ##FFFFF;
	}
		
	.inputamount_active {
	    font-family: calibri;
	    font-size: 2em;
	    margin-left: 5px;
	    padding-left: 2px;
	    padding-right: 3px;
		text-align:right;
		background-color: ##F79898;		
	}	
	
	.settlement_title td {
	    font-family: calibri;
	    font-size: 1em;
		font-weight:bold;
	}	
	
	.line_details td {
	    font-family: calibri;
	    font-size: 1em;
	}		
	
	.tdmmenu, .tdcmenu {
		font-family: arial, serif;
		font-size:12px;
		color:##000;
		background-color:##ededed;
		text-decoration:none;
		cursor:pointer;
		border:0px solid ##DDD;
		text-align:center;
	}

 </style>		
		
</cfoutput>      

                                                                                                                                    