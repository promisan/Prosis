
<cfoutput>

<cfset root = "#SESSION.root#">

<script>
	
	var root = "#root#";
		
	function linebillingdetail(wid,lid,bid) {       
	
	   try { ProsisUI.closeWindow('myprovision',true) } catch(e) {}		
	   ProsisUI.createWindow('myprovision', 'Provisioning', '',{x:100,y:100,height:document.body.clientHeight-80,width:1150,modal:true,center:true,resizable:true})    	   					
	   ptoken.navigate('#session.root#/workorder/application/workorder/ServiceDetails/Billing/DetailBillingDialog.cfm?mode=workorder&workorderid='+wid+'&workorderline='+lid+'&billingid='+bid,'myprovision') 		 
	}

	function resetlinebillingdetail(wid,lid,bid) {       
		
	   ptoken.navigate('#session.root#/workorder/application/workorder/ServiceDetails/Billing/resetBilling.cfm?workorderid='+wid+'&workorderline='+lid,'resetlinebill');
	   window.location.reload();		 
	}
	
	function linebillingrefresh(wid,lid) {
	    _cf_loadingtexthtml='';
		ptoken.navigate('#session.root#/workorder/application/workorder/ServiceDetails/Billing/DetailBillingList.cfm?workorderid='+wid+'&workorderline='+lid+'&operational=1','billingdata')	
	}
	
	<!--- triggers select time to be checked in the schedule --->
	function workplanverify(dte,hr,mn,k1) {		
        document.getElementById(k1).click()			  	   				
	}
					
	function linebillingdelete(wid,lid,bid) {  
	   _cf_loadingtexthtml='';   
	   ptoken.navigate('#session.root#/workorder/application/workorder/ServiceDetails/Billing/DetailBillingList.cfm?action=delete&billingid='+bid+'&workorderid='+wid+'&workorderline='+lid ,'billingdata')
	}  
	
	function workplan(wla,mode) {
	
	   if (mode == "dialog") {
	   
	       w = 1450
		   h = screen.height-200
	       ptoken.open('#session.root#/workorder/application/workorder/WorkPlan/ScheduleView.cfm?mode=dialog&workactionid='+wla,'Workplan', 'left=40, top=40, width=' + w + ', height=' + h + ',toolbar=no,menubar=no,status=yes,scrollbars=no,resizable=yes');		
		
	   } else {
	   	
	       try { ProsisUI.closeWindow('myworkplan',true) } catch(e) {}
		   ProsisUI.createWindow('myworkplan', 'Workplan', '',{x:100,y:100,height:document.body.clientHeight-60,width:document.body.clientWidth-60,modal:true,center:true,resizable:true})    	  				
		   ptoken.navigate('#session.root#/WorkOrder/Application/WorkOrder/WorkPlan/Schedule.cfm?workactionid='+wla,'myworkplan') 		 	
		   
		}   
	}
	
	function openaction(wli) {		  
	    h = "#client.height-100#";	 
		// ptoken.open('#session.root#/Workorder/Application/Medical/ServiceDetails/WorkOrderline/WorkOrderLineView.cfm?drillid='+wli,'w'+wli,'left=20, top=20, width=1440,height='+h+',menubar=no, status=yes, toolbar=no, scrollbars=no, resizable=yes')
		ptoken.open('#session.root#/Workorder/Application/Medical/ServiceDetails/WorkOrderline/WorkOrderLineView.cfm?drillid='+wli,'w'+wli)	
	}
	
	function workplanaction(wla) {
	    if (document.getElementById('plan'+wla)) {
	    ptoken.navigate('#session.root#/WorkOrder/Application/WorkOrder/ServiceDetails/Action/setWorkPlan.cfm?workactionid='+wla,'plan'+wla)	
		}
	}
		
	function workorderview(id,scope) {
	    w = #CLIENT.width# - 100;
	    h = #CLIENT.height# - 150;
		if (scope == 'medical') {
		ptoken.open(root +  "/WorkOrder/Application/Medical/ServiceDetails/WorkOrderLine/WorkOrderLineView.cfm?drillid=" + id, "WorkOrder");		
		} else {
		ptoken.open(root +  "/WorkOrder/Application/WorkOrder/WorkOrderView/WorkOrderView.cfm?workorderid=" + id, "WorkOrder");
		}
	}
	
	function editworkorderline(id) { 
	    w = #CLIENT.width# - 100;
	    h = #CLIENT.height# - 150;   
	     if (id.value != "") {
	         ptoken.open(root + "/WorkOrder/Application/WorkOrder/ServiceDetails/ServiceLineDetail.cfm?drillid="+id,"_blank","left=40, top=40, width=" + w + ", height= " + h + ",toolbar=no,menubar=no,status=yes,scrollbars=no,resizable=yes");			
	     }
	}
	  
	function workorderlineopen(wlid,idmenu,target) {
		  w = #CLIENT.width# - 20;
		  h = #CLIENT.height# - 100;
		  if (target != 'embed') {
		  ptoken.open(root + "/WorkOrder/Application/WorkOrder/ServiceDetails/ServiceLineView.cfm?openmode=embed&mode=edit&drillid="+wlid+'&systemfunctionid='+idmenu,target,"left=40, top=40, width=" + w + ", height= " + h + ", status=yes, scrollbars=no, resizable=yes")			
		  } else {
		  ptoken.open(root + "/WorkOrder/Application/WorkOrder/ServiceDetails/ServiceLineView.cfm?openmode=embed&mode=edit&drillid="+wlid+'&systemfunctionid='+idmenu,"_top","left=40, top=40, width=" + w + ", height= " + h + ", status=yes, scrollbars=no, resizable=yes")	
		  }
	} 
	  
	function workorderlineopendialog(wlid,idmenu) {
		  w = #CLIENT.width# - 120;
		  h = #CLIENT.height# - 160;
		  ptoken.open(root + "/WorkOrder/Application/WorkOrder/ServiceDetails/ServiceLineView.cfm?openmode=embed&mode=edit&drillid="+wlid+'&systemfunctionid='+idmenu,"_blank","left=40, top=40, width=" + w + ", height= " + h + ", status=yes, scrollbars=no, resizable=yes")	
	}
	  
	function addworkorderrequest(mission,domain,status,wid,wol) {	
	      w = #CLIENT.width# - 130;  
		  h = #CLIENT.height# - 140;
		  ptoken.open(root +  "/WorkOrder/Application/Request/Request/Create/Document.cfm?mission="+mission+"&domain="+domain+"&status="+status+"&workorderid="+wid+"&workorderline="+wol, "_blank", "left=40, top=40, width=" + w + ", height= " + h + ",toolbar=no,menubar=no,status=yes,scrollbars=no,resizable=yes");
	}	
		
	function addworkorder(mission,customerid,workorderid,workorderline,context) {			
		try { ProsisUI.closeWindow('myorder',true) } catch(e) {}
		ProsisUI.createWindow('myorder', 'Add Order', '',{x:100,y:100,height:document.body.clientHeight-90,width:document.body.clientWidth-90,modal:true,resizable:true,center:true})    					
		ptoken.navigate(root + '/WorkOrder/Application/WorkOrder/Create/WorkOrder.cfm?mission=' + mission + '&customerid=' + customerid + '&workorderid=' + workorderid + '&workorderline=' + workorderline+ '&context=' + context,'myorder') 	
	}	
	
	function toggleLog(id) {
		if ($('##log_'+id).is(':visible')) {
			$('##log_'+id).hide();
			$('##logContent_'+id).html('');
		} else {
			window['__logDetailShowFunction'] = function(){	$('##log_'+id).show(); };
			ptoken.navigate('#session.root#/workorder/application/medical/ServiceDetails/WorkPlan/Agenda/LogDetail.cfm?workactionid='+id, 'logContent_'+id, '__logDetailShowFunction');
		}
	}

</script>
	
</cfoutput>