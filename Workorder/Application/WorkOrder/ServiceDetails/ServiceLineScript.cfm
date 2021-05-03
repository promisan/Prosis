
<cfajaximport tags="cfwindow,cfform,cfdiv">
<cf_dialogStaffing>
<cf_dialogPosition>
<cf_dialogWorkorder>
<cf_dialogAsset>

<cf_textareascript>
<cf_actionlistingScript>
<cf_dialogMaterial>
<cf_dialogLedger>
<cf_dialogProcurement>
<cf_filelibraryscript>
<cf_menuscript>
<cf_calendarscript>
<cf_presentationscript>

<cfparam name="url.systemfunctionid" default="">

<cf_tl id="The action and the shift must be different from the source of the copy" var="vMessCopyWorkSchedule">
<cf_tl id="Do you want to remove this product ?" var="msgRemoveFinalProduct">
<cf_tl id="Post production to storage warehouse. This will remove all previous entries." var="msgPostProduct">
<cf_tl id="Please, select a valid person." var="vPersonMessage">

		
<script language="JavaScript">

    function requisitionadd(mis,wid,lid,iid,refer) {	
	   ptoken.open('<cfoutput>#session.root#</cfoutput>/Procurement/Application/Requisition/Requisition/RequisitionEntry.cfm?mission='+mis+'&header=1&mode=workorder&id=new&workorderid='+wid+'&workorderline='+lid+'&requirementid='+iid+'&refer='+iid, '_blank', 'left=20, top=20, width=<cfoutput>#client.width-140#</cfoutput>,height=900,status=yes, toolbar=no, scrollbars=yes, resizable=yes');		
	}	
	
	function addtransaction(mis,wid,lid) {  		   
		try { ColdFusion.Window.destroy('mydialog',true) } catch(e) {}
		ColdFusion.Window.create('mydialog', 'Transaction', '',{x:100,y:100,height:570,width:570,modal:true,resizable:false,center:true})    
		ptoken.navigate('<cfoutput>#session.root#</cfoutput>/workorder/application/workorder/ServiceDetails/Transaction/Document.cfm?scope=entry&mission='+mis+'&workorderid='+wid+'&workorderline='+lid,'mydialog') 			
	}
	
	function newreceipt(mis) {		    
	    ptoken.open("<cfoutput>#SESSION.root#</cfoutput>/Warehouse/Application/Asset/AssetEntry/AssetEntry.cfm?mode=workorder&mission="+mis, "newasset", "left=40, top=40, width=950, height=760, menubar=no, location=0, status=yes, toolbar=no, scrollbars=no, resizable=yes");								
	}	
	
	function receiptrefresh(aid) {
	    _cf_loadingtexthtml='';	
	    ptoken.navigate('../Assets/getAsset.cfm?assetid='+aid,'assetselectbox')	
	}
	
	function addsupply(mis,wid,lid) {  	   
	    ptoken.open("<cfoutput>#SESSION.root#</cfoutput>/Warehouse/Application/Stock/Transaction/TransactionInit.cfm?mode=workorder&mission="+mis+"&workorderid="+wid+"&workorderline="+lid,"workorder","left=20, top=20, width=960,height=800,status=yes, toolbar=no, scrollbars=yes, resizable=yes")	 	
	}
	
	function chargedetail(wid,lid,yr,mt,mode,tot) {
	    var cnt;
	    if ((mode == 'unplanned')&&(tot==0))
	  	  {cnt = 'Nonbillable';}
	    else
	  	  {cnt = '';}	  	
	    ptoken.open("charges/chargesusagedetail.cfm?workorderid="+wid+"&workorderline="+lid+"&year="+yr+"&month="+mt+"&mode="+mode+"&content="+cnt,"_blank","left=20, top=20, width=<cfoutput>#client.width-140#</cfoutput>,height=800,status=yes, toolbar=no, scrollbars=yes, resizable=yes")		
	}
	
	function workflowaction(key,box) {	
		  
		    se = document.getElementById(box)
			ex = document.getElementById("exp"+key)
			co = document.getElementById("col"+key)
				
			if (se.className == "hide") {		
			   se.className = "regular" 		   
			   co.className = "regular"
			   ex.className = "hide"				   
			   ptoken.navigate('action/WorkActionWorkflow.cfm?ajaxid='+key,key)		   
			   
			   
			} else {se.className = "hide"
			        ex.className = "regular"				
			   	    co.className = "hide" 
		    } 		
		}		
		
	function editSchedule(wid,lid,id,mode) {
		
		ColdFusion.Window.create('mydialog', 'Schedule', '',{x:100,y:100,height:document.body.clientHeight-40,width:document.body.clientWidth-40,modal:true,center:true})    
		ColdFusion.Window.show('mydialog') 					
		ColdFusion.navigate('<cfoutput>#session.root#</cfoutput>/WorkOrder/Application/WorkOrder/ServiceDetails/Schedule/ScheduleView.cfm?workorderid='+wid+'&workorderline='+lid+'&scheduleId='+id+'&mode='+mode,'mydialog') 
	 
	}
	
	function editScheduleRefresh(wid,lid) {
		ptoken.navigate('Schedule/ScheduleListing.cfm?workorderid='+wid+'&workorderline='+lid,'contentbox1');
	}
	
	function purgeSchedule(wid,lid,id) {
		if (confirm('Do you want to remove this complete schedule?')) {
			ptoken.navigate('Schedule/SchedulePurge.cfm?workorderid='+wid+'&workorderline='+lid+'&scheduleId='+id,'contentbox1');
		}
	}
	
	function copyWorkSchedule(wid,lid,action,ws) {
		var vlink = '<cfoutput>#session.root#</cfoutput>/workorder/application/workorder/serviceDetails/schedule/WorkScheduleCopy.cfm?workorderid='+wid+'&workorderline='+lid+'&actionclass='+action+'&workSchedule='+ws;
		try {
			ColdFusion.Window.destroy('windowCopyWorkSchedule');
		}catch(e){}		
		ColdFusion.Window.create('windowCopyWorkSchedule', 'Copy Shift', vlink, {height:500,width:850,modal:false,closable:true,center:true,minheight:200,minwidth:200 });
	}
	
	function assignResponsibleWorkSchedule(wid,lid,action,ws) {
		var vlink = '<cfoutput>#session.root#</cfoutput>/workorder/application/workorder/serviceDetails/schedule/WorkScheduleAssignResponsible.cfm?workorderid='+wid+'&workorderline='+lid+'&actionclass='+action+'&workSchedule='+ws;
		try {
			ColdFusion.Window.destroy('windowAssignResponsibleWorkSchedule');
		}catch(e){}		
		ColdFusion.Window.create('windowAssignResponsibleWorkSchedule', 'Assign Responsible', vlink, {height:350,width:600,modal:false,closable:true,center:true,minheight:200,minwidth:200 });
	}
	
	function validateCopyWorkSchedule(c) {
		if ( $('#factionclass').val() == $('#factionclassold').val() && $('#fworkschedule').val() == $('#fworkscheduleold').val() ) {
			$(c).val('');
			alert('<cfoutput>#vMessCopyWorkSchedule#.</cfoutput>');
		}
	}
	
	function getDataByDate(control) {
		ptoken.navigate('Schedule/GetPerson.cfm?workorderId='+$('#fAssignResponsibleworkorderId').val()+'&workorderline='+$('#fAssignResponsibleworkorderline').val()+'&ActionClass='+$('#fAssignResponsibleActionClass').val()+'&WorkSchedule='+$('#fAssignResponsibleWorkSchedule').val()+'&selectedDate='+$('#'+control).val()+'&boxName=divEmployeeResponsible','divAssignResponsiblePerson');
	}
	
	function addHalfProduct(woid,woline,itemno,uom) {				
		ptoken.open("<cfoutput>#session.root#</cfoutput>/workorder/application/Assembly/Items/HalfProduct/HalfProductAdd.cfm?workorderid="+woid+"&workorderline="+woline+"&itemNo="+itemno+"&uom="+uom,"add half");		
	}
	
		
	function addFinalProduct(woid,woline,itemno,uom) {						
		ptoken.open("<cfoutput>#session.root#</cfoutput>/workorder/application/Assembly/Items/FinalProduct/FinalProductAdd.cfm?workorderid="+woid+"&workorderline="+woline+"&itemNo="+itemno+"&uom="+uom,"add item");		
	}	
	
	
	function editHalfProduct(woid,woline,woitmid) {	
		ProsisUI.createWindow('mydialog', 'Finished Product', '',{x:100,y:100,height:600,width:660,modal:true,center:true})    						
		ptoken.navigate('<cfoutput>#session.root#</cfoutput>/workorder/application/Assembly/Items/HalfProduct/HalfProductView.cfm?accessmode=edit&workorderid='+woid+'&workorderline='+woline+'&workorderitemid='+woitmid,'mydialog') 					
	}
	
	function editFinalProduct(woid,woline,woitmid) {	
		ProsisUI.createWindow('mydialog', 'Finished Product', '',{x:100,y:100,height:600,width:660,modal:true,center:true})    		 				
		ptoken.navigate('<cfoutput>#session.root#</cfoutput>/workorder/application/Assembly/Items/FinalProduct/FinalProductView.cfm?accessmode=edit&workorderid='+woid+'&workorderline='+woline+'&workorderitemid='+woitmid,'mydialog') 					
	}
	
		
	// perspective of workorder line 
	
	function editResourceService(woid,woline,resid) {
				
		ProsisUI.createWindow('myservice', 'Service', '',{x:100,y:100,height:document.body.clientHeight-80,width:document.body.clientWidth-80,modal:true,resizable:false,center:true})    					
		ptoken.navigate('<cfoutput>#session.root#</cfoutput>/workorder/application/Assembly/Items/BOM/ResourceEdit.cfm?scope=service&WorkOrderId='+woid+'&WorkOrderLine='+woline+'&ResourceId='+resid,'myservice') 			
	}	
	
	function consumeearmarked(woid,woline,mde,cat,sid) {
		_cf_loadingtexthtml='';				
		Prosis.busy('yes')
		ptoken.navigate('<cfoutput>#session.root#</cfoutput>/workorder/application/Assembly/Items/BOM/consumeBOMEarmarked.cfm?Category='+cat+'&SystemFunctionid='+sid+'&Mode='+mde+'&WorkOrderId='+woid+'&WorkOrderLine='+woline,'process') 			
	}	
	
	
	
	// perspective of the workorder line FP item 
	
	function editResourceSupply(wid,wol,woid,widres,itemno,uom) {				
		ProsisUI.createWindow('mysupply', 'Supply', '',{x:100,y:100,height:document.body.clientHeight-80,width:document.body.clientWidth-80,modal:true,resizable:false,center:true})    							    
		ptoken.navigate('<cfoutput>#session.root#</cfoutput>/workorder/application/Assembly/Items/BOM/ResourceEdit.cfm?scope=supply&WorkOrderItemId='+woid+'&workorderitemidresource='+widres+'&itemNo='+itemno+'&uom='+uom,'mysupply') 							
	}		
	
	function editResourceRefresh(mde,woid,wid,wol) {
	 if (mde == "3") {
		ptoken.navigate('<cfoutput>#session.root#</cfoutput>/workorder/application/Assembly/Items/FinalProduct/FinalProductBOM.cfm?WorkOrderItemId='+woid,'resource_'+woid);				
	 } else {
		ptoken.navigate('<cfoutput>#session.root#</cfoutput>/workorder/application/Assembly/Items/FinalProduct/ItemView.cfm?workorderid='+wid+'&workorderline='+wol,'topSection') 		  	 
	 } 	
		
	}		
	
	
	function deleteResourceSupply(woid,widres,itemno,uom) {	     
	     var conf = confirm("Are you sure to remove this material?");
	     if (conf == true) {
		    _cf_loadingtexthtml='';		
		 	ptoken.navigate("<cfoutput>#session.root#</cfoutput>/workorder/application/Assembly/Items/FinalProduct/setResourceDelete.cfm?WorkOrderItemId=" + woid + "&workorderitemidresource=" + widres + "&itemNo=" + itemno + "&uom=" + uom + "&ts=" + new Date().getTime(), 'resource_' + woid);
		 }
	}	

	function setEnableQty(id) {
		
		if ($('#d_'+id).is(":visible"))	{
			$('#d_' + id).hide();
			$('#t_' + id).show();
		} else {
			$('#d_' + id).show();
			$('#t_' + id).hide();			
		}	
			
	}
		

	function createBatchRequisitions(fileNo,sid) {	    
		ptoken.navigate('<cfoutput>#session.root#</cfoutput>/workorder/application/Assembly/Items/BOM/CreateRequisitions.cfm?fileNo='+fileNo+'&systemfunctionid='+sid,'process','','','POST','fGeneration')		
	}
	
	function collectBOM(woid,woline,cat,mode) {			   
	    ptoken.navigate('<cfoutput>#session.root#</cfoutput>/workorder/application/Assembly/Items/Earmark/BOMView.cfm?mode='+mode+'&WorkOrderId='+woid+'&workorderLine='+woline+'&category='+cat, 'process');		
	}	
	
	function removeHalfProduct(woid,woline,itemno,uom) {
		if (confirm('<cfoutput>#msgRemoveFinalProduct#</cfoutput>')) {
		     _cf_loadingtexthtml="";
			ptoken.navigate('<cfoutput>#session.root#</cfoutput>/workorder/application/Assembly/Items/HalfProduct/HalfProductPurge.cfm?workorderid='+woid+'&workorderline='+woline+'&itemno='+itemno+'&uom='+uom,'topSection');
		}
	}
		
	function removeFinalProduct(woid,woline,itemno,uom,tpe) {
		if (confirm('<cfoutput>#msgRemoveFinalProduct#</cfoutput>')) {
		     _cf_loadingtexthtml="";
			ptoken.navigate('<cfoutput>#session.root#</cfoutput>/workorder/application/Assembly/Items/FinalProduct/FinalProductPurge.cfm?workorderid='+woid+'&workorderline='+woline+'&itemno='+itemno+'&uom='+uom+'&saletype='+tpe,'topSection');
		}
	}
	
	function getBOM(woid,woline,mode){
		if (confirm('Are you sure to refresh BOM information ? \n\nThis will reset all previously modified BOM for items.')) {
			ptoken.navigate('<cfoutput>#session.root#</cfoutput>/workorder/application/Assembly/Items/BOM/generateBOM.cfm?mode='+mode+'&refresh=yes&workorderid=' + woid + '&workorderline=' + woline, 'topSection');
			}			
	}
	
	<!--- <cfoutput>#msgPostProduct#</cfoutput> --->			
	function issueStock(woid,woline,mode) {
			if (confirm('<cfoutput></cfoutput>')) {
			Prosis.busy('yes');
			ptoken.navigate('<cfoutput>#session.root#</cfoutput>/workorder/application/Assembly/Items/BOM/generateStock.cfm?mode='+mode+'&refresh=yes&workorderid=' + woid + '&workorderline=' + woline,'topSection');	
		}	
	}	
	
				
	function doInitRequest() {
		$(".material:first").focus();
		doHighlight();
	}				
	
	function validatePersonField(name) {
		if ($('#'+name).length > 0) {
			if ($('#'+name).val() != "") {
				return true;
			}else{
				alert('<cfoutput>#vPersonMessage#</cfoutput>');
				return false;
			}	
		}else{
			alert('<cfoutput>#vPersonMessage#</cfoutput>');
			return false;
		}
		
	}
	
	function doUpdateResource(id) {
		ptoken.navigate('<cfoutput>#session.root#</cfoutput>/workorder/application/Assembly/Items/BOM/ResourceUpdateSubmit.cfm?ResourceId=' + id, 'resulths','','','POST','fResource');			
	}
	
	
	function doDeleteResource(id) {
		ptoken.navigate('<cfoutput>#session.root#</cfoutput>/workorder/application/Assembly/Items/BOM/ResourceDelete.cfm?ResourceId=' + id, 'resulths');			
	}
	
	function printBOM(woid,woline,category,template){
		<cfoutput>
		ptoken.open("#SESSION.root#/Tools/CFReport/OpenReport.cfm?ts=#GetTickCount()#&template="+template+"&ID1="+woid+"&ID2="+woline+"&ID3="+category, "_blank", "left=60, top=60, width=800, height=600, toolbar=no, menubar=no, status=yes, scrollbars=no, resizable=yes");
		</cfoutput>
	}	

	function doCalculate() {
		var quantity = $("#quantity").data("kendoNumericTextBox").value();
		var price    = $("#price").data("kendoNumericTextBox").value();		
		$("#total").data("kendoNumericTextBox").value(quantity*price);		
	}	

	function initializeAmounts() {	
		$("#quantity").kendoNumericTextBox( {
			change: doCalculate,
			spinners: false	}
		);
		
		$("#price").kendoNumericTextBox({
	                   format: "c",
	                  decimals: 3,
			 	  	  change: doCalculate,
	        		  spinners: false			
	     });
		 
	 	 $("#total").kendoNumericTextBox( {
			spinners: false
		 }
		 );	
	}	 
	
		
</script>

