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


<cfquery name="Parameter" 
	datasource="AppsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT * 
		FROM   Ref_ParameterMission
		WHERE  Mission = '#URL.Mission#'
</cfquery>

<cfoutput>		
	
	<script language="JavaScript">
	
	function add(item,uom) {
	    
		mis = document.getElementById("mission").value;	
		whs = document.getElementById("warehouse").value;		
		ColdFusion.navigate('Requester/HistoryListLocate.cfm?mission=#url.mission#&webapp=#url.webapp#&view=none','reqtop')
		ColdFusion.navigate('Requester/CartAdd.cfm?mission=#url.mission#&webapp=#url.webapp#&warehouse='+whs+'&itemno=' + item + '&uom=' + uom,'reqmain')
	}
	
	function addtomycart() {	
		
		mis = document.getElementById("mission").value;
		whs = document.getElementById("warehouse").value;		
		itm = document.getElementById("itemno").value;		
		uom = document.getElementById("itemuom").value;		
		qty = document.getElementById("requestquantity").value;	
		mem = document.getElementById("remarks").value;
						
		if (parseFloat(qty)) {		
		
		ColdFusion.navigate('Requester/CartAddSubmit.cfm?mode=request&webapp=#url.webapp#&mission='+mis+'&warehouse='+whs+'&itemNo='+itm+'&uom='+uom+'&quantity='+qty+'&remarks='+mem+'&storageid=','reqmain')	
		}  else { 
	      alert("You entered an incorrect quantity ("+qty+")") }		
	}
	
	function addtocart(mis,itm,uom) {		
	    
		whs = document.getElementById("warehouse").value;		
		mem = document.getElementById("remarks").value;		
		sti = document.getElementById("storageid").value;			
		shp = document.getElementById("shipto").value;	
		
		document.cartform.onsubmit() 
		
		if( _CF_error_messages.length == 0 ) {    	    
		    ColdFusion.navigate('Requester/CartAddSubmit.cfm?mission='+mis+'&mode=dialog&warehouse='+whs+'&itemNo='+itm+'&uom='+uom+'&remarks='+mem+'&shipto='+shp+'&storageid='+sti,'process','','','POST','cartform')	
		 }  			
	}
	
	function addtostock(mis) {		    
		
		whs = document.getElementById("warehouse").value;				
		sti = document.getElementById("storageid").value;			
		shp = document.getElementById("shipto").value;		
		document.cartform.onsubmit() 	
		if( _CF_error_messages.length == 0 ) {  	 		
		    ColdFusion.navigate('Stock/StockRequestSubmit.cfm?mission='+mis+'&mode=dialog&warehouse='+whs+'&shipto='+shp+'&storageid='+sti,'process','','','POST','cartform')	
		 }  			
	}
		
	function reqedit(id,qty) {	
		if (parseFloat(qty)) {
		   ColdFusion.navigate('Requester/RequestEdit.cfm?webapp=#url.webapp#&id='+id+'&quantity='+qty,'amount_'+id)
		} else  {
		  alert("You entered an incorrect quantity ("+qty+")")
		}					
	}
	
	function cartedit(cartid,qty,box) {	
	   if (parseFloat(qty)) {
		    ColdFusion.navigate('Requester/CartEdit.cfm?webapp=#url.webapp#&id='+cartid+'&quantity='+qty,box)
	   } else  {
	   	  alert("You entered an incorrect quantity ("+qty+")")
	   }					
	}
	
	function cartpurge(id,box,lid) {
	    ColdFusion.navigate('Requester/CartPurge.cfm?mission=#url.mission#&webapp=#url.webapp#&id='+id+'&itemlocationid='+lid,box)				
	}
	
	function cancelcart() {
		if (confirm("Do you want to empty your cart ?")) {
		cartpurge('all','reqmain')		
		}
		return false	
	}	
	
	function reqpurge(id,lid) {
		ColdFusion.navigate('Requester/RequestPurge.cfm?webapp=#url.webapp#&id='+id+'&itemLocationId='+lid,'reqmain'+lid)							
	}
	
	function more(id) {
	
		url = "Requester/ItemView.cfm?webapp=#url.webapp#&id="+id
		se  = document.getElementById("b"+id)
		e   = document.getElementById(id+"Exp")
		m   = document.getElementById(id+"Min")
		if (se.className == "regular") {
			   se.className = "hide"
			   e.className = "regular"
			   m.className = "hide"
		} else {
		se.className = "regular"
		e.className  = "hide"
		m.className  = "regular"
		ColdFusion.navigate(url,'i'+id)	
	    }
	
	}
	
	// main inquiry screen for stock on hand
	function history(whs,loc,itm,uom) {
	    try { ColdFusion.Window.destroy('dialoghistory',true) } catch(e) {}; 
		ColdFusion.Window.create('dialoghistory', 'Stock OnHand History', '',{x:100,y:100,height:500,width:760,resizable:true,modal:true,center:true})
		ColdFusion.navigate('#SESSION.root#/Warehouse/Portal/Stock/InquiryWarehouseDetail.cfm?warehouse='+whs+'&location='+loc+'&itemno='+itm+'&uom='+uom,'dialoghistory')
	
	}
	
	function itmrequest(cat,itm,uom,shp,sid) {
		ht = document.body.offsetHeight-70
		wd = document.body.offsetWidth-70
	    try { ColdFusion.Window.destroy('dialogrequest',true) } catch(e) {}; 
		ColdFusion.Window.create('dialogrequest', 'Request', '',{x:100,y:100,height:ht,width:wd,resizable:true,modal:true,center:true});
		ColdFusion.navigate('#SESSION.root#/Warehouse/Portal/Stock/InquiryWarehouseRequest.cfm?mission=#url.mission#&shipto='+shp+'&category='+cat+'&itemno='+itm+'&uom='+uom+'&storageid='+sid,'dialogrequest')
	}
	
	function storageinfo(stloc,whs,locid,cls,itm,uom) {
		var vId = stloc+'_'+whs+'_'+locid+'_'+itm+'_'+uom+'_'+cls;
		vId = vId.replace(/ /g,'_');
	
		se = document.getElementById('storage_'+vId);
		// icM  = document.getElementById('storage_'+stloc+'_'+whs+'_'+locid+'_'+itm+'_'+uom+'_'+cls+'Min');
		// icE  = document.getElementById('storage_'+stloc+'_'+whs+'_'+locid+'_'+itm+'_'+uom+'_'+cls+'Exp');
		
		 if (se.className == "hide") {
			ColdFusion.navigate('Stock/InquiryWarehouseTanks.cfm?storagelocation='+stloc+'&warehouse='+whs+'&locationClass='+cls+'&locationId='+locid+'&itemno='+itm+'&uom='+uom,'storagecontent_'+vId);
			se.className = "regular"
			// icM.className = "regular"
		    // icE.className = "hide"
		 } else {
		   se.className = "hide"
		   // icM.className = "hide"
		   // icE.className = "regular"
		 }			
	}
	
	function selectrow(id,isselected,hlColor,hltrColor,regColor) {
		var obj1 = document.getElementById("td2_"+id);
		var obj2 = document.getElementById("tankTR_"+id);
		
		if (obj1 != null){
			if (isselected == 1) {
				obj1.bgColor = hlColor;
			}else{
				obj1.bgColor = '';
			}
		}
	
		if (obj2 != null){
			if (isselected == 1) {
				obj2.bgColor = hltrColor;
			}else{
				obj2.bgColor = regColor;
			}
		}
	}
	
	<!--- refresh the detail bottom box --->	
				 
	function maximizecss(itm) {
		
		 	 se   = document.getElementsByName(itm)		
			 count = 0
			 
			 if (se[0].className == "regular") {
				   while (se[count]) { 
				      se[count].className = "hide"; 
		  		      count++
				   }		   		 	  
				 } else {
				    while (se[count]) {
				    se[count].className = "regular"; 
				    count++
				 }						
			   }
		 }  	
				 
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
	
	function showcart(lid,mis,whs,loc,itm,uom,req) {
	 
	  se = document.getElementById("content_"+lid)
	
	  if (se.className == "hide") {
	     
		  // open the drill info   
	      se.className = "regular"
		  ColdFusion.navigate('../Stock/InquiryWarehouseDrill.cfm?itemlocationid='+lid+'&mission='+mis+'&mode=cart&onrequest='+req,'content_'+lid)
		  
	  } else {
	   
		  se = document.getElementById("cart_"+lid)
		  icM  = document.getElementById("cart_"+lid+"Min")
		  icE  = document.getElementById("cart_"+lid+"Exp")
		  
		  if (se.className == "hide") {
		     se.className = "regular"
			 ColdFusion.navigate('#SESSION.root#/Warehouse/Portal/Requester/Cart.cfm?itemlocationid='+lid+'&mission='+mis+'&mode=stock&box=cartcontent_'+lid+'&shiptowarehouse='+whs+'&shiptolocation='+loc+'&itemno='+itm+'&uom='+uom,'cartcontent_'+lid)
			 icM.className = "regular"
			 icE.className = "hide"
		  } else {
		    se.className = "hide" 
			icM.className = "hide"
		    icE.className = "regular"
		  }	  
		  
	  }  
	  
	}
	
	function showrequest(lid,mis) {
	
		se = document.getElementById("content_"+lid);
		
		if (se.className == "hide") {
	
			// open the drill info   
			se.className = "regular";
			ColdFusion.navigate('#SESSION.root#/Warehouse/Portal/Stock/InquiryWarehouseDrill.cfm?itemlocationid='+lid+'&mission='+mis+'&mode=line&onrequest=1','content_'+lid);
		
		} else {
		
			se = document.getElementById("box_"+lid);
			icM  = document.getElementById("box_"+lid+"Min");
			icE  = document.getElementById("box_"+lid+"Exp");
			
			if (se.className == "hide") {
				
				se.className = "regular";
				ColdFusion.navigate('#SESSION.root#/Warehouse/Portal/Requester/HistoryList.cfm?mission='+mis+'&itemlocationid='+lid,'boxcontent_'+lid);
				icM.className = "regular";
				icE.className = "hide";
			
			} else {
				
				se.className = "hide";
				icM.className = "hide";
				icE.className = "regular";
			}
		
		} 
	
	}
	
	function stockconfirmation(mission,warehouse,sid) {
		ht = document.body.offsetHeight-60
		wd = document.body.offsetWidth-60
		try { ColdFusion.Window.destroy('dialogconfirmation',true)} catch(e){};
		ColdFusion.Window.create('dialogconfirmation', 'Confirmation', '',{x:100,y:100,width:wd,height:ht,resizable:false,modal:true,center:true});
		ColdFusion.navigate('#SESSION.root#/Warehouse/Portal/Stock/StockConfirmation.cfm?systemfunctionid='+sid+'&mission=' + mission + '&warehouse=' + warehouse,'dialogconfirmation');
	}
	
	// cart screen 
	 
	function cart(webapp,mis) {    
	    ColdFusion.navigate('Requester/HistoryListLocate.cfm?webapp=#url.webapp#&mode=none','reqtop')
		ColdFusion.navigate('Requester/Cart.cfm?mission=#url.mission#&webapp='+webapp,'reqmain')		    
	}
	
	function reqstatus(view) {    
	    ColdFusion.navigate('Requester/HistoryListLocate.cfm?webapp=#url.webapp#&mode='+view,'reqtop')
		ColdFusion.navigate('Requester/HistoryList.cfm?mission=#url.mission#&webapp=#url.webapp#&view='+view,'reqmain')		   
	}
	
	function reqstatusfilter(mode) {    
	   
		document.formfilter.onsubmit() 
		if( _CF_error_messages.length == 0 ) {
	        ColdFusion.navigate('Requester/HistoryList.cfm?mission=#url.mission#&view='+mode,'reqmain','','','POST','formfilter')		
		 }   
	}
	
	function shipstatus(mis) {
		ColdFusion.navigate('Requester/ShippingList.cfm?webapp=#url.webapp#&mission='+mis,'reqmain')		   
	}
	
	function cartshow() {
		ColdFusion.navigate('Requester/CartShow.cfm','cartshow')					
	}
	
	function checkout() {	       
		 whs     = document.getElementById("warehouse").value;		 
		 ColdFusion.navigate('Checkout/CartCheckout.cfm?mode=request&webapp=#url.webapp#&mission=#url.mission#&warehouse='+whs,'menucontent')		
	}
	
	function undocheckout() {    
		 whs = document.getElementById("warehouse").value;		
		 ColdFusion.navigate('Requester/CartRequest.cfm?webapp=#url.webapp#&mission=#url.mission#&warehouse='+whs,'menucontent')	 				
	}
	
	function doit() {
		if (confirm("Do you want to submit this request ?")) {	
		    _cf_loadingtexthtml="";	
		    ColdFusion.navigate('Checkout/CartCheckoutSubmit.cfm?webapp=#url.webapp#&mission=#url.mission#','cartcheckoutprocess','','','POST','cartcheckout')			
			_cf_loadingtexthtml="<div><img src='<cfoutput>#SESSION.root#</cfoutput>/images/busy11.gif'/>";	
		}	return false	
	}
	
	// feature to add lines if needed 
	
	function addrequest(scope,mission,warehouse,refresh) {
		try { ColdFusion.Window.destroy('dialogaddrequest',true)} catch(e){};
		ColdFusion.Window.create('dialogaddrequest', 'Add Line', '',{x:100,y:100,width:520,height:390,resizable:false,modal:true,center:true});
		ColdFusion.navigate('#SESSION.root#/Warehouse/Application/StockOrder/Request/Create/LineTransfer/AddRequest.cfm?scope='+ scope + '&refresh='+refresh+'&mission=' + mission + '&warehouse=' + warehouse,'dialogaddrequest');
	}
	
	function submitaddrequest(mission, warehouse,refresh) {
		try { ColdFusion.Window.destroy('dialogaddrequest',true)} catch(e){};
		if (refresh == "0") {
		ColdFusion.navigate('Checkout/CartCheckOutDetail.cfm?mode=submit&mission='+mission+'&warehouse='+warehouse,'cartdetail');
		} else {
		ColdFusion.navigate('Checkout/CartCheckOutContent.cfm?mode=submit&mission='+mission+'&warehouse='+warehouse,'main');
		}
	}
	
	function canceladdrequest() {
		ColdFusion.Window.hide('dialogaddrequest'); 
	}
	
	// internal taskorder receipt 
	
	function processcart(mis) {		    
	    ht = document.body.offsetHeight-60
		wd = document.body.offsetWidth-80
		try { ColdFusion.Window.destroy('dialogprocessrequest',true)} catch(e){};
		ColdFusion.Window.create('dialogprocessrequest', 'Submit Requests', '',{x:100,y:100,width:wd,height:ht,resizable:true,modal:true,center:true})	
		ColdFusion.navigate('#SESSION.root#/Warehouse/Portal/Checkout/CartCheckout.cfm?mission=#url.mission#&webapp=#url.webapp#','dialogprocessrequest')			
	}
	
	// internal taskorder receipt 
	
	function processtaskorder(tid,actormode,template,action,id) {		    
	    ht = document.body.offsetHeight-60
		try { ColdFusion.Window.destroy('dialogprocesstask',true)} catch(e){};
		ColdFusion.Window.create('dialogprocesstask', 'Internal Task Order', '',{x:100,y:100,width:860,height:ht,resizable:true,modal:true,center:true})	
		ColdFusion.navigate('#SESSION.root#/Warehouse/Application/StockOrder/Task/Process/TaskForm'+template+'.cfm?taskid='+tid+'&actormode='+actormode+'&action='+action+'&actionid='+id,'dialogprocesstask')			
	}
	
	function processtaskorderreceipt(tid,actormode,template,action,id,batchid) {	
		if (confirm("Do you want to save the "+template+" record ?")) {	
			ColdFusion.navigate('#SESSION.root#/Warehouse/Application/StockOrder/Task/Process/TaskForm'+template+'Submit.cfm?taskid='+tid+'&actormode='+actormode+'&action='+action+'&actionid='+id+'&batchid='+batchid,'processtask','','','POST','formtask')	
		 }		
	} 	
	
	function direct_receive(id,tn) {
			ColdFusion.navigate('#SESSION.root#/warehouse/application/stockorder/Task/Shipment/TaskDirect.cfm?id='+id+'&tn='+tn,'d'+id+'_'+tn);
		}
		
	// Prints 
	
	function taskprint(id) {
		    window.open("#SESSION.root#/Tools/Mail/MailPrepareOpen.cfm?id="+id+"&ID1="+id+"&ID0=/warehouse/inquiry/print/TaskView/Task.cfr","_blank", "left=30, top=30, width=800, height=600, toolbar=no, menubar=no, status=yes, scrollbars=no, resizable=no")
		}	
		
	function stockbatchprint(id, template) {
			window.open("#SESSION.root#/Tools/Mail/MailPrepareOpen.cfm?id="+id+"&ID1="+id+"&ID0=/"+template,"_blank", "left=60, top=60, width=800, height=600, toolbar=no, menubar=no, status=yes, scrollbars=no, resizable=no")
		}
		
	
	</script>
	
	<!--- -------------------------------- --->
	<!--- added from portal landing script --->
	<!--- -------------------------------- --->
	
	<script language="JavaScript" type="text/javascript"> 
    
	function reqedit(id,qty) {	

		   if (parseFloat(qty)) {
		   ColdFusion.navigate('../Requester/RequestEdit.cfm?id='+id+'&quantity='+qty,'amount_'+id)
		   } else  {
			  alert("You entered an incorrect quantity ("+qty+")")
		   }				
	}
	
	w = #CLIENT.width# - 70;
	h = #CLIENT.height# - 160;
	
	function mail2(mode,id) {
		  window.open("#SESSION.root#/Tools/Mail/MailPrepareOpen.cfm?id="+mode+"&ID1="+id+"&ID0=#Parameter.RequisitionTemplateMultiple#","_blank", "left=30, top=30, width=800, height=600, toolbar=no, menubar=no, status=yes, scrollbars=no, resizable=no")
		}	
	
	function mail3(mode,id) {
		  window.open("#SESSION.root#/Tools/Mail/MailPrepareOpen.cfm?id="+mode+"&ID1="+id+"&ID0=#Parameter.DeliveryTemplate#","_blank", "left=30, top=30, width=800, height=600, toolbar=no, menubar=no, status=yes, scrollbars=no, resizable=no")
		}	
			
	function hl(c1,c2) {				
			document.getElementById(c1).className = "sel"
			document.getElementById(c2).className = "sel"
		}
			
	function sl(c1,c2) {
			document.getElementById(c1).className = "reg"
			document.getElementById(c2).className = "reg"
		}
	
	function search() {		 
		    if (window.event.keyCode == "13") {	
			document.getElementById("find").click() }			
	    }		
		
	function warehouse(whs) {		
	  	w = #CLIENT.width# - 60;
	  	h = #CLIENT.height# - 130;		
 	  	window.open("#SESSION.root#/Warehouse/Application/Stock/StockControl/StockView.cfm?scope=portal&warehouse=" + whs,  "stc"+whs, "left=10, top=10, width=" + w + ", height= " + h + ", menubar=no, toolbar=no, status=yes, scrollbars=no, resizable=yes");		
		}
			
	function catsel(cat,row) {		
	
		 document.getElementById("category").value = cat	
		 
		 count = 0		 
		 tot   = document.getElementById("searchgroup").value
					 				 	   
		   while (count <= tot) {
			   try { 
				   rw = document.getElementById("1_"+count)
				   rw.className = "regular"
				   rw = document.getElementById("2_"+count)
				   rw.className = "regular"
			   	   } catch(e) {}
				   count++ 
			   }			
			  
			   document.getElementById("1_"+row).className = "highlight"			  
			   document.getElementById("2_"+row).className = "highlight"						    						   
		 	   list('1')	   	   
			
	    }					
	
	function list(pg) {				
		cat = document.getElementById("category").value;		
		fnd = document.getElementById("find").value;
		whs = document.getElementById("warehouse").value;				
		ColdFusion.navigate('Requester/ItemList.cfm?mission=#URL.mission#&warehouse='+whs+'&find='+fnd+'&category='+cat+'&page='+pg,'reqmain')	 
	}
	
	function view(item) {		
		window.open("Requester/ItemView.cfm?ID=" + item, "DialogWindow", "status=yes, scrollbars=no, resizable=yes, left=40, top=40, width=600, height=500");
	}
	
	function mainmenu(menusel,len) {
	
		 menu=1;len++ 	 
		 document.getElementById("errorbox").className = "hide"	
		 
	     while (menu != (len)) {
		 
		  try {
		 	  	 
			  if (menu == menusel) {
			    document.getElementById("smenu"+menu).className = "highlight"
			  } else {
			    document.getElementById("smenu"+menu).className = "regular"
			  }
			    
			  se = document.getElementsByName("box"+menu)	  
			  cell = 0 	  			  
			  while (se[cell]) {	 			  
			     if (menu == menusel) { 
					se[cell].className = "regular"
				 } else {
				    se[cell].className = "hide"
				 }
				 cell++				 
			  }	 	  
			  
			 } catch(e) {}			 
			 menu++			    	 
		 }
	}
	
	function toggleArea(sel,tw,expa,col){
		$(sel).toggle();
		if ($(sel).is(':visible')) {
			$(tw).attr('src',expa);
		}else{
			$(tw).attr('src',col);
		}
	}
	  
	</script>

</cfoutput>

