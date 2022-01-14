
<!--- scripts needed for provisioing and asset / supplies entry --->

<cf_listingscript>
<cf_dialogworkorder>
<cf_dialogAsset>

<cfoutput>

<script language="JavaScript">

	function newreceipt(mis) {		    
	    ptoken.open("#SESSION.root#/Warehouse/Application/Asset/AssetEntry/AssetEntry.cfm?mode=workorder&mission="+mis, "newasset", "left=40, top=40, width=950, height=760, menubar=no, location=0, status=yes, toolbar=no, scrollbars=no, resizable=yes");								
	}	
	
	function receiptrefresh(aid) {
	    _cf_loadingtexthtml='';	
	    ptoken.navigate('../../workorder/application/workorder/Assets/getAsset.cfm?assetid='+aid,'assetselectbox')	
	}
	
	function linebillingdetail(wid,lid,bid) {       
			
	   ColdFusion.Window.create('myprovision', 'Provisioning', '',{x:100,y:100,height:document.body.clientHeight-80,width:1130,modal:true,center:true,resizable:true})    
	   ColdFusion.Window.show('myprovision') 					
	   ptoken.navigate('#session.root#/workorder/application/workorder/ServiceDetails/Billing/DetailBillingDialog.cfm?mode=workorder&workorderid='+wid+'&workorderline='+lid+'&billingid='+bid,'myprovision') 		 
	}


	
	function linebillingrefresh(wid,lid) {
	    _cf_loadingtexthtml='';	
		ptoken.navigate('#session.root#/workorder/application/workorder/ServiceDetails/Billing/DetailBillingList.cfm?workorderid='+wid+'&workorderline='+lid+'&operational=1','billingdata')	
	}
		
	function linebillingdelete(wid,lid,bid) {     
	   _cf_loadingtexthtml='';		
	   ptoken.navigate('#session.root#/workorder/application/workorder/ServiceDetails/Billing/DetailBillingList.cfm?action=delete&billingid='+bid+'&workorderid='+wid+'&workorderline='+lid ,'billingdata')
	}  
	
	function addsupply(mis,wid,lid) {  	   
	   ptoken.open("#SESSION.root#/Warehouse/Application/Stock/Transaction/TransactionInit.cfm?mode=workorder&mission="+mis+"&workorderid="+wid+"&workorderline="+lid,"workorder","left=20, top=20, width=990,height=800,status=yes, toolbar=no, scrollbars=yes, resizable=yes")	 	
	}


		
</script>

</cfoutput>