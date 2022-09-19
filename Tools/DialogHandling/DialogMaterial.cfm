
<cfoutput>

	<script>
	
	var root = "#SESSION.root#";
	
	function itemopen(itm,mid,mis) {	
		 item(itm,mid,mis) 		   
	}
	
	function item(itm,mid,mis) {	
	  
	   var mission = mis	      
	   if (!mid || mid=='undefined'){
	   		mid = ''; }
	  	   	   	   
	   if (mission) {	 
	   } else {	 	 	  	  	   
		   try {
		   	  mission = document.getElementById('mission').value			 
			  } catch(e) {
			  mission = ''			  
			  }				  
		}  		
				
	    w = #CLIENT.width# - 80;
	    h = #CLIENT.height# - 145;
		ptoken.open(root + "/Warehouse/Maintenance/ItemMaster/ItemView.cfm?idmenu="+mid+"&mission="+mission+"&ID=" + itm, "dlg_"+itm);	
		
	}
	
	function itemclassification(itm,mid) {	
	    ptoken.open(root + "/Warehouse/Maintenance/Item/RecordEdit.cfm?idmenu="+mid+"&ID=" + itm, "dlg_"+itm);	
	}
	
	function EditAsset(assetid,template) {
	    w = #CLIENT.width# - 50;
	    h = #CLIENT.height# - 120;
		ptoken.open(root + "/Warehouse/Application/Asset/AssetView.cfm?ID=" + assetid + "&template="+template, "_blank", "left=10, top=10, width=" + w + ", height= " + h + ", status=yes, toolbar=no, scrollbars=no, resizable=yes");
	}
	
	function stockquote(requestno,functionid) {   
	    w = #CLIENT.width# - 80;
	    h = #CLIENT.height# - 165;
		ptoken.open(root + "/Warehouse/Application/SalesOrder/Quote/QuoteView.cfm?systemfunctionid="+functionid+"&RequestNo="+requestno, "quote"+requestno);	
	}
	
	function batch(batch,mis,mode,functionid,trigger) {   
	    w = #CLIENT.width# - 80;
	    h = #CLIENT.height# - 165;
		ptoken.open(root + "/Warehouse/Application/Stock/Batch/BatchView.cfm?trigger="+trigger+"&mode="+mode+"&mission="+mis+"&systemfunctionid="+functionid+"&batchno=" + batch, "batch"+batch);	
	}
	
	function batchtransaction(id,fid,mde) {   
	    w = #CLIENT.width# - 130;
	    h = #CLIENT.height# - 165;
		ptoken.open(root + "/Warehouse/Application/Stock/Inquiry/TransactionView.cfm?accessmode="+mde+"&systemfunctionid="+fid+"&drillid="+id);	
	}
			
	function receipt(id,dialog) {
	    w = #CLIENT.width# - 120;
	    h = #CLIENT.height# - 160;
		ptoken.open(root + "/Procurement/Application/Receipt/ReceiptEntry/ReceiptEdit.cfm?id=" + id + "&mode=" + dialog, id);
	}
	
	function receiptdialog(id,dialog) {	
	    w = #CLIENT.width# - 120;
    	h = #CLIENT.height# - 140;	
		ptoken.open(root + "/Procurement/Application/Receipt/ReceiptEntry/ReceiptEdit.cfm?id=" + id + "&mode=" + dialog, "RequestLine");
	}
	
	function stockinquiry(itm,whs,uom,mde) {
		ProsisUI.createWindow('stockinquiry', 'Inquiry', '',{x:100,y:100,width:800,height:420,resizable:true,modal:true,center:true})
		ptoken.navigate('#SESSION.root#/Warehouse/Maintenance/ItemMaster/Stock/StockView.cfm?warehouse='+whs+'&itemNo='+itm+'&uom='+uom,'stockinquiry')							
	}
		
	function StockOrderEdit(id) {
    	w = 935
	    h = #CLIENT.height# - 145;
		ptoken.open(root + "/Warehouse/Application/StockOrder/Task/Shipment/TaskView.cfm?actionstatus=1&scope=regular&stockorderid="+id,"_blank", "left=60, top=30, width=" + w + ", height= " + h + ", status=yes, scrollbars=no, resizable=yes");
	}
	
	function editCustomer(id){			    								  
       	ptoken.open('#SESSION.root#/Warehouse/Application/Customer/View/CustomerEditTab.cfm?drillid='+id,'editcustomer'+id); 			  		      
	}
	
	function addCustomer(mis,scope){		
		    		
		var vWidth  = 930;
		var vHeight = document.body.clientHeight-90;   			 	
		ProsisUI.createWindow('addcustomer', 'Customer', '',{x:30,y:30,height:vHeight,width:vWidth,modal:true,center:true});    								  
       	ptoken.navigate('#SESSION.root#/Warehouse/Application/Customer/View/Customer.cfm?mission='+mis+'&scope='+scope,'addcustomer'); 			  		      
	}
    
	function selectcustomer(formname,fldcustomerid,fldcustomername,customerid) {       
	    ProsisUI.createWindow('customer', 'Customer', '',{x:100,y:100,height:document.body.clientHeight-90,width:790,modal:true,center:true})
		ptoken.navigate(root + "/Warehouse/Application/Customer/Lookup/LookupSearch.cfm?FormName=" + formname + "&fldcustomerid=" + fldcustomerid + "&fldcustomername=" + fldcustomername+"&customerid="+customerid, "customer");		
	}

	function selectwarehouseitem(mis,cls,mas,applyscript,scope) {	
	    // 15/2/2015 newly added to replace modal dialog 	
		ProsisUI.createWindow('warehouseitemwindow', 'Item', '',{x:100,y:100,height:document.body.clientHeight-80,width:790,modal:true,center:true})    					
		ptoken.navigate(root + '/Warehouse/Inquiry/Item/ItemView.cfm?mission='+mis+'&itemmaster='+mas+'&itemclass='+cls+'&script='+applyscript+'&scope='+scope,'warehouseitemwindow') 				
	}
	
	function selectwarehouseitemnoclose(mis,cls,mas,applyscript,scope) {
		ProsisUI.createWindow('warehouseitemwindow', 'Item', '',{x:100,y:100,height:document.body.clientHeight-80,width:750,modal:true,center:true})    				
		ptoken.navigate(root + '/Warehouse/Inquiry/Item/ItemView.cfm?mission='+mis+'&itemmaster='+mas+'&itemclass='+cls+'&script='+applyscript+'&scope='+scope+'&close=no','warehouseitemwindow') 	
	}
		  
	function AssetDialog(ind) {  
   		w = "#client.widthfull-100#";
	    h = "#client.height-100#";
    	ptoken.open(root + "/Warehouse/Application/Asset/AssetAction/AssetView.cfm?assetid=" + ind, ind);
	}	
	
	function ReqView(recno,dialog) {
	    w = #CLIENT.width# - 80;
	    h = #CLIENT.height# - 160;
		ptoken.open(root + "/Procurement/Application/Requisition/RequisitionView/RequisitionPrint.cfm?ID=" + recno + "&mode=" + dialog, "RequestLine", "left=40, top=40, width=" + w + ", height= " + h + ", status=yes, scrollbars=yes, resizable=no");
	}
	
	function stockrequest(id) {
        w = #CLIENT.width# - 80;
	    h = #CLIENT.height# - 160;
		ptoken.open(root + "/Warehouse/Application/StockOrder/Request/Create/Document.cfm?drillid=" + id, "RequestLine", "left=40, top=40, width=" + w + ", height= " + h + ", status=yes, scrollbars=yes, resizable=no");
	}
	
	function ShowRequest(recno, st) {
	    w = 680;
	    h = 580;
		ptoken.open(root + "/Warehouse/Application/Requisition/RequisitionLineView.cfm?ID=" + recno + "&ID1=" + st,  "RequestLine", "left=20, top=20, width=" + w + ", height= " + h + ", status=yes, scrollbars=yes, resizable=no");
	}
	
	function ShowShipping(recno, st) {
	    w = 680;
	    h = 450;
		ptoken.open(root + "/Warehouse/Application/Shipping/ShippingLineView.cfm?ID=" + recno + "&ID1=" + st,  "ShippingLine", "left=20, top=20, width=" + w + ", height= " + h + ", status=yes, scrollbars=yes, resizable=no");
	}
	
	function ShowVendor(Id, ST) {
	    w = #CLIENT.width# - 50;
	    h = #CLIENT.height# - 100;
		ptoken.open(root +  "/Procurement/Vendor/VendorMenu.cfm?ID=" + Id + "&ID1=" + ST, "VendorDialog", "left=15, top=15, width=" + w + ", height= " + h + ", status=yes, scrollbars=yes, resizable=no");
	}
		
	function selectitm(mission,itemmaster,field,script,scope,access) {				
		ProsisUI.createWindow('mystock', 'Stock Item', '',{x:100,y:100,height:document.body.clientHeight-120,width:document.body.clientWidth-120,modal:true,resizable:false,center:true})    				
		ptoken.navigate(root + '/Procurement/Application/Requisition/Item/ItemSearchView.cfm?access='+access+'&mission=' + mission + '&itemmaster=' + itemmaster + '&field=' + field + '&script=' + script + '&scope=' + scope,'mystock') 				
	  }	
	
	function ShowWorkRequest(REQ) {
		ptoken.open(root + "/Workorder/Request/RequestEdit.cfm?ID=" + REQ, "DialogWindow", "scrollbars=yes, resizable=no, width=500, height=430");
	}
	
	function ShowWorkView(REQ) {
		ptoken.open(root + "/Workorder/Request/RequestView.cfm?ID=" + REQ, "DialogWindow", "status=yes, scrollbars=yes, width=510, height=500");
	}
	
	function workorderline(wlid,idmenu,target) {
		  w = #CLIENT.width# - 120;
		  h = #CLIENT.height# - 160;
		  if (target) {
		  ptoken.open(root + "/WorkOrder/Application/WorkOrder/ServiceDetails/ServiceLineView.cfm?openmode=embed&mode=edit&drillid="+wlid+'&systemfunctionid='+idmenu,target)			
		  } else {
		  ptoken.open(root + "/WorkOrder/Application/WorkOrder/ServiceDetails/ServiceLineView.cfm?openmode=embed&mode=edit&drillid="+wlid+'&systemfunctionid='+idmenu,"_top","left=40, top=40, width=" + w + ", height= " + h + ", status=yes, scrollbars=no, resizable=yes")	
		  }
	} 
	
	function packingslip(shpno,st) {
	    w = #CLIENT.width# - 60;
	    h = #CLIENT.height# - 120;
		ptoken.open(root + "/Warehouse/Flow/Shipping/Packingslip.cfm?ID=" + shpno + "&ID1=" + st, "ShipDialog", "left=20, top=20, width=" + w + ", height= " + h + ", toolbar=yes, status=yes, scrollbars=yes, resizable=no");
	}
	
	function EnterRequisition() {
	    w = #CLIENT.width# - 100;
	    h = #CLIENT.height# - 155;
		ptoken.open(root + "/Procurement/Requisition/Enter/TransactionInit.cfm?h=" + h, "TransactionDialog", "left=40, top=40, width=" + w + ", height= " + h + ", toolbar=yes,status=yes, scrollbars=yes, resizable=yes");
	}
	
	function selectwhslocation(whs,loc,hform, whsf, locf) {
	  	ptoken.open(root + "/Warehouse/Maintenance/Location/LocationSelect.cfm?ID_whs=" + whs + "&ID_loc=" + loc +"&ID=" + hform + "&ID1=" + whsf + "&ID2=" + locf, "AccountSelect", "left=100, top=100, width=500, height=650, toolbar=no, status=yes, scrollbars=yes, resizable=no");
	}
	
	</script>

	<cfinclude template="DialogMail.cfm">

</cfoutput>