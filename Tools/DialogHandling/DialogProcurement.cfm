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

<cfoutput>

	<cfset root = SESSION.root>

	<script>
	
	<!--- added for processing issues --->
	
	function removevendor(unit,wf,per,id1,sort) {
	
	if (confirm("Do you want to remove this vendor ?"))	{	
		ptoken.navigate('#SESSION.root#/procurement/application/quote/quotationview/VendorDeleteSubmit.cfm?workflow='+wf+'&OrgUnit=' + unit + '&Period='+per+'&ID1='+id1+'&Sort='+sort,'dialog')
		}
	}	
			
	function markvendor(unit,tree,wf,per,id1,sort) {
		if (confirm("Do you want to mark all lines of this vendor ?")) {
			ptoken.navigate('#SESSION.root#/procurement/application/quote/quotationview/VendorSelectSubmit.cfm?workflow='+wf+'&mission='+tree+'&OrgUnit=' + unit + '&Period='+per+'&ID1='+id1+'&Sort='+sort,'dialog')	
		}
	}
	
	function reloadvendorform(mode,wf,per,id1,sort) {
	    _cf_loadingtexthtml="";	
		ptoken.navigate('#SESSION.root#/procurement/application/quote/quotationview/JobViewVendor.cfm?workflow='+wf+'&Period='+per+'&ID1='+id1+'&Sort='+sort,'dialog')	
		_cf_loadingtexthtml="<div><img src='<cfoutput>#SESSION.root#</cfoutput>/images/busy11.gif'/>";	
	}
	
	function delline(id,wf,per,id1,sort) {
	    if (confirm("Do you want to delete this line ?"))	   
	    navigate('#SESSION.root#/procurement/application/quote/quotationview/JobViewProcess.cfm?line='+id+'&workflow='+wf+'&Period='+per+'&ID1='+id1+'&Sort='+sort,'dialog')		
	}	
	
	function showvendor() {
		se = document.getElementById("dialogbox")	
		if (se.className == "hide") {
		  se.className = "regular"
		  document.getElementById("vendorhide").className = "regular"
		  document.getElementById("vendorshow").className = "hide"
		  } else {
		  se.className = "hide"
		  document.getElementById("vendorhide").className = "hide"
		  document.getElementById("vendorshow").className = "regular"
		}
	 }  	
	
	function requisitionlog(box,id) {
			
		se = document.getElementById("blog"+box)	
		if (se.className == "regular") {
			se.className = "hide"	
			} else {
			se.className = "regular"		
			ptoken.navigate('#SESSION.root#/procurement/application/requisition/requisition/RequisitionActionLog.cfm?id='+id,'log'+box)
		}
	}	
	
	function showreqdetail(box,id,mis,mas,type,itm,mode) {
	     
		se = document.getElementById("bdet"+box)
		
		if (se.className == "regular") {
			se.className = "hide"		
		} else {		   
			se.className = "regular"		
			if (type != "Warehouse") {						
				  ptoken.navigate('#SESSION.root#/Procurement/Application/Requisition/Requisition/RequisitionEntryWarehouse.cfm?mode='+mode+'&option=mas&itemmaster='+mas+'&reqid='+id+'&mis='+mis+'&id=itm&access=view&des=&item=','det'+box)
			    } else {
			 	  ptoken.navigate('#SESSION.root#/Procurement/Application/Requisition/Requisition/RequisitionEntryWarehouse.cfm?mode='+mode+'&option=itm&itemmaster='+mas+'&reqid='+id+'&mis='+mis+'&id=itm&access=view&des=&item='+itm,'det'+box)
			    }
		}
		
	}
	
	function setitem(context,id,box,itm,uom) {
	   ProsisUI.createWindow('setitem', 'Amend warehouse item', '',{x:100,y:100,height:250,width:600,modal:true,center:true})>			   
	   ptoken.navigate('#SESSION.root#/Warehouse/Maintenance/Item/Description/Item.cfm?context='+context+'&id='+id+'&box='+box+'&itemno='+itm+'&uom='+uom,'setitem')
	}
	
	function showarchive(actionid,req) {
	   ProsisUI.createWindow('reqarchive', 'Requisition Action', '',{x:100,y:100,height:550,width:740,modal:false,center:true})>			   
	   ptoken.navigate('#SESSION.root#/procurement/application/requisition/requisition/RequisitionArchive.cfm?actionid='+actionid,'reqarchive')
	}
	
	var root = "#root#";	
	function job(id) {
	    w = #CLIENT.width# - 120;
	    h = #CLIENT.height# - 160;
		ptoken.open(root + "/Procurement/Application/Quote/QuotationView/JobViewGeneral.cfm?id1=" + id + "&mode=view", "RequestLine", "left=40, top=40, width=" + w + ", height= " + h + ", status=yes, scrollbars=no, resizable=yes");
	}
	
	function equipmententry(rcptid) {   
	    w = #CLIENT.width# - 120;
	    h = #CLIENT.height# - 160;
		ptoken.open(root + "/Warehouse/Application/Asset/AssetEntry/ReceiptParent.cfm?id="+rcptid, "receipt", "left=40, top=40, width=" + w + ", height= " + h + ", status=yes, scrollbars=no, resizable=yes");	
	}
	
	function addRequest(mis,per) {							
		ptoken.open("#SESSION.root#/Procurement/Application/PurchaseOrder/ExecutionRequest/RequestEntry.cfm?header=0&mission="+mis+"&period="+per,"right");	
	} 
	 
	function editRequest(requestid) {	  
	   w = #CLIENT.width# - 60;
	   h = #CLIENT.height# - 120;
	   ptoken.open("#SESSION.root#/Procurement/Application/PurchaseOrder/ExecutionRequest/RequestView.cfm?id="+requestid+"&tc="+new Date().getTime(), "_blank", "left=40, top=40, width=" + w + ", height= " + h + ", status=yes, scrollbars=no, resizable=yes");  
	}
	
	function editRequestRefresh(requestid) {   	  
		ptoken.navigate('#SESSION.root#/Procurement/Application/PurchaseOrder/ExecutionRequest/ViewListingRefresh.cfm?requestid='+requestid+'&col=des','des_'+requestid)
		ptoken.navigate('#SESSION.root#/Procurement/Application/PurchaseOrder/ExecutionRequest/ViewListingRefresh.cfm?requestid='+requestid+'&col=ref','ref_'+requestid)
		ptoken.navigate('#SESSION.root#/Procurement/Application/PurchaseOrder/ExecutionRequest/ViewListingRefresh.cfm?requestid='+requestid+'&col=amt','amt_'+requestid)										
	}		
	
	function potrack(po) {
	    ProsisUI.createWindow('deliverdialog', 'Delivery Tracking', '',{x:100,y:100,height:document.body.clientHeight-90,width:document.body.clientWidth-90,modal:true,center:true})    	   			
	    ptoken.navigate(root + '/Procurement/Application/Delivery/DeliveryView.cfm?purchaseno='+po,'deliverdialog') 			 
	}
	
	function ProcRcptEntry(rcptid,reqno,mode,action,box,taskid) {      
	    w = screen.width - 60;	
	    h = screen.height- 120;		
		ptoken.open(root + "/Procurement/Application/Receipt/ReceiptEntry/ReceiptEntry.cfm?box=" + box +"&mode=" + mode + "&rctid="+rcptid+"&reqno=" + reqno + "&action=" + action + "&taskid=" + taskid + "&ts="+new Date().getTime(), "_blank", "left=20, top=30, width=" + w + ", height= " + h + ", status=yes, scrollbars=no, resizable=yes");	
	}
	
	function ProcRcptLineEdit(rcptid,reqno,mode,action,box,taskid,dte) {
	   ProsisUI.createWindow('receiptdialog', 'Receipt', '',{x:100,y:100,height:document.body.clientHeight-40,width:document.body.clientWidth-40,modal:true,resizable:false,center:true})    	   			
	   ptoken.navigate(root + '/Procurement/Application/Receipt/ReceiptEntry/ReceiptLineView.cfm?date='+dte+'&mode=' + mode + '&rctid='+rcptid+'&reqno=' + reqno + '&action=' + action + '&taskid=' + taskid,'receiptdialog') 			   
	}     	
	
	function ProcRcptLineDelete(rcptid,reqno,mode,action,box) {    
		ptoken.navigate(root + '/Procurement/Application/Receipt/ReceiptEntry/ReceiptDetail.cfm?action='+action+'&rctid='+rcptid+'&box='+box+'&reqno='+reqno+'&mode='+mode,box)	
	}
	
	function ProcLineEdit(recno,mode) {  
		try { ProsisUI.cloiseWindow('myline',true) } catch(e) {}
		ProsisUI.createWindow('myline', 'Purchase Line', '',{x:100,y:100,height:document.body.clientHeight-100,width:document.body.clientWidth-100,modal:true,resizable:false,center:true})    					
		ptoken.navigate(root + '/Procurement/Application/PurchaseOrder/Purchase/PurchaseLineView.cfm?ID=' + recno + '&Mode=' + mode,'myline') 		  
	}
	
	function ProcReqAdd(job) {	
		ProsisUI.createWindow('myshipping', 'Shipping and Handling', '',{x:100,y:100,height:document.body.clientHeight-80,width:800,modal:true,center:true})    				
		ptoken.navigate(root + '/Procurement/Application/Quote/Create/AddView.cfm?ID=' + job,'myshipping') 		
	}
	
	function ProcReqSplit(recno) {
	
		ht = document.body.clientHeight-80
		if (ht > 650) {
		   ht = 650
		}   
		ProsisUI.createWindow('mysplit', 'Split Line', '',{x:100,y:100,height:ht,width:700,modal:true,center:true})    						
		ptoken.navigate(root + '/Procurement/Application/Quote/SplitRequest/SplitView.cfm?ID=' + recno,'mysplit') 		
	}
	
	function ProcQuoteEdit(recno,mode) {
		w = 1000
	    h = #CLIENT.height# - 145;
	    ptoken.open(root + "/Procurement/Application/Quote/Quotation/QuotationEditView.cfm?ID=" + recno + "&Mode=" + mode,"quote"); 
	}
	 
	function ProcReqEdit(reqno,mode,refer) {    
	    w = 1200
	    h = #CLIENT.height# - 145;	
		ptoken.open(root + "/Procurement/Application/Requisition/Requisition/RequisitionEdit.cfm?header=1&ID=" + reqno + "&mode=" + mode+ "&refer=" + refer, "req"+reqno);
	}
	
	function ProcReqNew(mis,context,id,per,refer) {    	  
	    w = 1200
	    h = #CLIENT.height# - 145;	
		ptoken.open(root + "/Procurement/Application/Requisition/Requisition/RequisitionEntry.cfm?header=1&mission=" + mis + "&id=new&context=" + context + "&contextid=" + id + "&period=" + per+ "&refer=" + refer, "_blank", "left=60, top=30, width=" + w + ", height= " + h + ", status=yes, scrollbars=no, resizable=yes");
	}	
	
	function StockOrderEdit(id) {
	    w = 935
	    h = #CLIENT.height# - 145;
		ptoken.open(root + "/Warehouse/Application/StockOrder/Task/Shipment/TaskView.cfm?actionstatus=1&scope=regular&stockorderid="+id,"_blank", "left=60, top=30, width=" + w + ", height= " + h + ", status=yes, scrollbars=no, resizable=yes");
	}
	
	function receipt(id,dialog) {  
	    w = #CLIENT.width# - 120;
	    h = #CLIENT.height# - 140;	
		ptoken.open(root + "/Procurement/Application/Receipt/ReceiptEntry/ReceiptEdit.cfm?id=" + id + "&mode=" + dialog, id);
	}
	
	function ProcPOEdit(po,sid,dialog) {
				   
	    w = #CLIENT.width# - 120;
	    h = #CLIENT.height# - 160;
		if (dialog == "tab") {
		ptoken.open(root + "/Procurement/Application/PurchaseOrder/Purchase/POView.cfm?ID1=" + po + "&mode=" + dialog, "Purchase"+po);		 
		} else {
		ptoken.open(root + "/Procurement/Application/PurchaseOrder/Purchase/POView.cfm?ID1=" + po + "&mode=" + dialog, "Purchase", "left=40, top=40, width=" + w + ", height= " + h + ", status=yes, scrollbars=no, resizable=yes");
		}
	}
	
	function ProcQuote(recno,dialog) {
	    w = #CLIENT.width# - 120;
	    h = #CLIENT.height# - 160;
		ptoken.open(root + "/Procurement/Application/Quote/QuotationView/JobViewGeneral.cfm?ID1=" + recno + "&mode=" + dialog, "Purchase", "left=40, top=40, width=" + w + ", height= " + h + ", status=yes, scrollbars=no, resizable=yes");
	}
	
	function ProcReqPrint(recno,dialog) {
	    w = #CLIENT.width# - 80;
	    h = #CLIENT.height# - 160;
		ptoken.open(root + "/Procurement/Application/Requisition/RequisitionView/RequisitionPrint.cfm?ID=" + recno + "&mode=" + dialog, "RequestLine", "left=40, top=40, width=" + w + ", height= " + h + ", status=yes, scrollbars=yes, resizable=no");
	}
	
	function ProcReqEntry(mis,per) {
	    w = #CLIENT.width# - 80;
	    h = #CLIENT.height# - 120;
		ptoken.open(root + "/Procurement/Application/Requisition/Portal/RequisitionView.cfm?id=&mission="+mis+"&period="+per+ "&ts="+new Date().getTime(), "right", "left=40, top=40, width=" + w + ", height= " + h + ", status=yes, scrollbars=no, resizable=yes");
	}
	
	<!--- added by hanno 28/11/2014 --->
	
	function programobject(id,prg,mis,planperiod,period,cls,hrg,edt,fund,org,box) {		
	 					
		icM  = document.getElementById(box+"Min")
		icE  = document.getElementById(box+"Exp")
		se   = document.getElementById(box);		
			
		if (se.className == "hide") {
		
		    se.className  = "regular"
			icM.className = "regular"
			icE.className = "hide"		
			ptoken.navigate(root + '/Procurement/Application/Requisition/Funding/RequisitionEntryFundingSelectObject.cfm?mode=list&cellwidth=19&id='+id+'&programcode='+prg+'&programclass='+cls+'&mission='+mis+'&programhierarchy=&planperiod='+planperiod+'&period='+period+'&edition='+edt+'&fund='+fund+'&unithierarchy='+org+'&scope=embed',box+'_content')	
			
		} else {
		
		    se.className  = "hide"
			icE.className = "regular"
			icM.className = "hide"	
			
		}					
		 		 		
	  }
	  
	<!--- added by hanno 28/11/2014 --->
	
	function amore(tpc,box,ed,fund,reqno,period,prg,obj,act,mode,mis,hier,org,resource,status) {
		    se   = document.getElementById(tpc+box);	
	        if (se.className == "regular") {
			    se.className = "hide"
			} else {
			  se.className = "regular";
		      ptoken.navigate('#SESSION.root#/ProgramREM/Application/Budget/Allotment/AllotmentInquiryDetail.cfm?status='+status+'&isParent=1&ProgramCode='+prg+'&Period='+period+'&Edition='+ed+'&Fund='+fund+'&Object='+obj+'&mode='+mode+'&programhierarchy='+hier+'&unithierarchy='+org+'&resource='+resource,'a'+tpc+box)
			}
		}	      
	
	function ProcReqCreate(mis,per) {
	    w = #CLIENT.width# - 80;
	    h = #CLIENT.height# - 120;
		ptoken.open(root + "/Procurement/Application/Requisition/Process/RequisitionCreate.cfm?mission="+mis+"&period="+per, "ProcReqEntry", "left=40, top=40, width=" + w + ", height= " + h + ", status=yes, scrollbars=no, resizable=yes");
	}
	
	function ProcBuyerJob(mis,per) {
	    w = #CLIENT.width# - 80;
	    h = #CLIENT.height# - 120;
		ptoken.open(root + "/Procurement/Application/Quote/Create/JobCreateView.cfm?mission="+mis+"&period="+per, "ProcReqEntry");
	}
	
	function ProcOrder(tree) {	   
	   	ProsisUI.createWindow('mydialog','Record Obligation','',{x:100,y:100,height:document.body.clientHeight-80,width:document.body.clientWidth-80,modal:true,resizable:false,center:true})
		ptoken.navigate(root + '/Procurement/Application/PurchaseOrder/Create/PurchaseCreateView.cfm?mission='+tree, 'mydialog');
	}
	
	function ProcReqClear(mis,per,role,systemfunctionid) {
	    w = #CLIENT.width# - 80;
	    h = #CLIENT.height# - 120;
		ptoken.open(root + "/Procurement/Application/Requisition/Process/RequisitionClear.cfm?systemfunctionid="+systemfunctionid+"&role="+role+"&mission="+mis+"&period="+per+"&ts="+new Date().getTime(), "right", "left=40, top=40, width=" + w + ", height= " + h + ", status=yes, scrollbars=no, resizable=yes");
	}
	
	function ProcReqObject(mis,per,systemfunctionid) {
	    w = #CLIENT.width# - 80;
	    h = #CLIENT.height# - 120;
		ptoken.open(root + "/Procurement/Application/Requisition/Process/RequisitionFunding.cfm?systemfunctionid="+systemfunctionid+"&mission="+mis+"&period="+per+ "&ts="+new Date().getTime(), "right", "left=40, top=40, width=" + w + ", height= " + h + ", status=yes, scrollbars=no, resizable=yes");
	}
	
	function ProcReqCertify(mis,per,systemfunctionid) {
	    w = #CLIENT.width# - 80;
	    h = #CLIENT.height# - 120;
		ptoken.open(root + "/Procurement/Application/Requisition/Process/RequisitionCertify.cfm?systemfunctionid="+systemfunctionid+"&mission="+mis+"&period="+per+ "&ts="+new Date().getTime(), "right", "left=40, top=40, width=" + w + ", height= " + h + ", status=yes, scrollbars=no, resizable=yes");
	}
	
	function ProcManager(mis,per,systemfunctionid) {
	    w = #CLIENT.width# - 80;
	    h = #CLIENT.height# - 120;
		ptoken.open(root + "/Procurement/Application/Requisition/Process/RequisitionBuyer.cfm?systemfunctionid="+systemfunctionid+"&mission="+mis+"&period="+per, "ProcManager");
	}
	
	function RequisitionView(mis,period,requisitionref) {
	    w = #CLIENT.width# - 80;
	    h = #CLIENT.height# - 120;
		ptoken.open(root + "/Procurement/Application/Requisition/Process/RequisitionView.cfm?Mission="+mis+"&Period="+period+"&RequisitionRef="+requisitionref, requisitionref);
	}
	
	function ViewProgram(Code, Period, Layout) {
	    w = #CLIENT.width# - 60;
	    h = #CLIENT.height# - 120;
		ptoken.open(root + "/ProgramREM/Application/Program/ProgramView.cfm?ProgramCode=" + Code + "&Period=" + Period + "&ProgramLayout=" + Layout, "ProgramView", "left=20, top=20, width=" + w + ", height= " + h + ", status=yes, toolbar=no, scrollbars=no, resizable=yes");
	}
	
	function invoiceedit(id)  {
	    w = #CLIENT.width# - 30;
	    h = #CLIENT.height# - 120;
	    ptoken.open(root + "/Procurement/Application/Invoice/Matching/InvoiceMatch.cfm?Id="+id, id);	
	}	
	
	function selectitem(itm,box) {
								
		ret = window.showModalDialog(root + "/Warehouse/Inquiry/Item/ItemSelect.cfm?ts="+new Date().getTime(), window, "unadorned:yes; edge:raised; status:yes; dialogHeight:660px; dialogWidth:680px; help:no; scroll:no; center:yes; resizable:no");
		if (ret) {		
			val = ret.split(";");
			document.getElementById(itm).value = val[0];											
			url = root + "/Warehouse/Inquiry/Item/ItemSelectDisplay.cfm?ts="+new Date().getTime()+"&itemno="+val[0]+"&uom="+val[2]
			ptoken.navigate(url,box)					 
		}					
	}
	
	function refreshtree(mis,per,role) {
		var div = document.getElementById('drefresh');
		if (div) {
			ptoken.navigate('#SESSION.root#/Procurement/Application/Requisition/RequisitionView/RequisitionViewTreeRefresh.cfm?mission='+mis+'&period='+per+'&role='+role,'drefresh');					
		}	
	}
	
	// not sure where the below is used use, is old tree 
	
	function reload(oTree, nme) {
	
	    var oTree     = ColdFusion.Tree.getTreeObject('tmaterials');			
		reload(oTree,'Class');
		reload(oTree,'Organization');
		reload(oTree,'Location');		
		var do_expand = false; 
		var node      = oTree.getNodeByProperty('id',nme);
		if (node.expanded)
			do_expand = true; 		
		ColdFusion.Tree.loadNodes([],{'treeid':'tmaterials','parent':node});	   			
		if (do_expand)	
			node.expand();
	}
	
	</script>

</cfoutput>