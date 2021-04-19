<cfparam name="url.idmenu"   default="">
<cfparam name="url.mid"      default="">
<cfparam name="url.mode"     default="view">
<cfparam name="url.fmission" default="">

<cfif url.mode eq "Embed">
	<cfset html = "No">
<cfelse>
	<cfset html = "Yes">
</cfif>		

<cfif url.idmenu eq "">

	<cfset menuAccess = "context">

<cfelse>

	<cfset menuAccess = "yes">

</cfif>

<cfif url.id neq "">
	
	<cfquery name="Item" 
	datasource="appsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT *
		FROM   Item
		WHERE  ItemNo = '#URL.ID#'
	</cfquery>
	
	<cfif url.fmission eq "">
		<cfset url.fmission = Item.Mission>
	</cfif>	

	<cf_screentop height="100%" 
	   scroll="Yes" 
	   html="#html#" 
	   label="#Item.ItemDescription# [#Item.ItemNo#]" 
	   layout="webapp" 
	   banner="gray" 
	   menuAccess="#menuaccess#" 
	   jQuery="Yes"	   
	   systemfunctionid="#url.idmenu#">

<cfelse>

	<cf_screentop height="100%" 
	   scroll="Yes" 
	   html="#html#" 
	   option="Add Master Catalog Item" 
	   label="Asset and/or Supplies Master Item" 
	   layout="webapp" 
	   banner="gray"	   
	   menuAccess="#menuaccess#" 
	   jQuery="Yes"
	   systemfunctionid="#url.idmenu#">
	
</cfif>

<cfajaximport tags="cfdiv,cfform,cfprogressbar">

<cf_ColorScript>
<cf_DialogProcurement>
<cf_textareascript>
<cf_menuscript>
<cf_calendarscript>
<cf_dialogOrganization>
<cf_PresenterScript>
<cf_filelibraryscript>
	
<cfoutput>

<cfparam name="url.mode" default="edit">

<script language="JavaScript">

   function syncItemCode(ob) {
   	 
	   if ($('##ItemNoExternal').val()=='') {
	   	 	$('##ItemNoExternal').val(ob.value); }
	   	 
	 //  if ($('##ItemBarcode').val()=='') {
	 //  	 	$('##ItemBarcode').val(ob.value); }   	
   }
   
   function suggest(ob,mis)  {
   
	   mis = $('##mission').val();
	   if (ob.value!='') {
	   		ptoken.navigate('getSuggestion.cfm?code='+ob.value+'&mission='+mis,'suggestion');
	   }
   	
   }
   
   function classificationvalidate() {
   
       _cf_loadingtexthtml='';	
	   document.frmTopics.onsubmit() 
	   if( _CF_error_messages.length == 0 ) {	       
           ptoken.navigate('Classification/ItemClassificationSubmit.cfm?id=#url.id#&mode=#url.mode#&idmenu=#url.idmenu#','contentbox2','','','POST','frmTopics')
	   }   
   
   } 
      
   function colorInit() {
		$('##color').spectrum();   	
   }   
   
   function validate() {      
		document.itemform.onsubmit();
		if( _CF_error_messages.length == 0 ) {        
			ptoken.navigate('RecordSubmit.cfm?mode=#url.mode#&id=#url.id#&idmenu=#url.idmenu#&fmission=#url.fmission#','contentbox1','','','POST','itemform');
		 }   
	}	

	var lastSelectedRow = -1;
	
	function selectmas(flditemmaster,mis,per,reqno) {        
		
		ProsisUI.createWindow('mymaster', 'Procurement Master', '',{x:100,y:100,height:document.body.clientHeight-90,width:document.body.clientWidth-90,modal:false,resizable:false,center:true})    							
		ptoken.navigate('#SESSION.root#/Procurement/Application/Requisition/Item/ItemSearchView.cfm?mission='+mis+'&flditemmaster= ' + flditemmaster, 'mymaster');	       			
		
   }
   
   function refreshByCategory() {
   		cat = document.getElementById('CategoryItem');
   		refreshItemMaster(cat);	
   }
   
   
   function refreshItemMaster(obj) {
   		itm    = document.getElementById('ItemMasterOld');
   		miss   = document.getElementById('mission');   		
		_cf_loadingtexthtml='';	
   		ptoken.navigate('getItemMaster.cfm?itemmaster='+itm.value+'&mission='+miss.value+'&categoryitem='+obj.value,'bItemMaster')   	
   }
   
   function selectmasapply(val) {       
        ptoken.navigate('#SESSION.root#/Warehouse/Maintenance/Item/setItemMaster.cfm?itemmaster='+val,'process')		
   }
  	
	function ask() {	
		  if (confirm("Do you want to remove this item?")) {
	    	  ptoken.navigate('RecordSubmit.cfm?mode=#url.mode#&id=#url.id#&action=delete&idmenu=#url.idmenu#&fmission=#url.fmission#','process')
			  return true  }
		  return false
	}
	
	function selectuomrow(basename,row){
		if (lastSelectedRow != -1) {document.getElementById(basename + lastSelectedRow).style.backgroundColor = '';}
		if (row != -1) {document.getElementById(basename + row).style.backgroundColor = 'E1EDFF';}
		lastSelectedRow = row;
	}
	
	function recorduomedit(itm,uom) {	
	    if (uom == '') {
			wd = 1150
		    ht = 680
	 		ptoken.open("UoM/ItemUoMEditTab.cfm?id="+itm+"&uom="+uom,itm, "left=20, top=20, width="+wd+", height="+ht+",menubar=no, toolbar=no, status=yes, scrollbars=no, resizable=yes");
		} else {
		ptoken.open("UoM/ItemUoMEditTab.cfm?id="+itm+"&uom="+uom,itm);		
		}
	}
	
	function canceledit(){
		selectuomrow('trUoMRow_','-1');
		ptoken.navigate('blank.cfm','uomedit');
	} 
	
	function recorddelete(itm,uom) {
	    ptoken.navigate('UoM/ItemUoMDelete.cfm?id='+itm+'&uom='+uom,'uomedit')
	} 
	
	function supplyedit(itm,supply,uom) {
		var vWidth = 850;
		var vHeight = 650;    				   
		ColdFusion.Window.create('mydialog', 'Supply', '',{x:30,y:30,height:vHeight,width:vWidth,modal:true,center:true});    
		ColdFusion.Window.show('mydialog'); 				
		ptoken.navigate('Consumption/ItemSupplyEdit.cfm?type=Item&id='+itm+'&supply='+supply+'&uom='+uom+'&ts='+new Date().getTime(),'mydialog'); 
	}
	
	function supplydelete(itm,supply,uom) {
	    ptoken.navigate('Consumption/ItemSupplyDelete.cfm?type=Item&id='+itm+'&supply='+supply+'&supplyuom='+uom,'supplyedit')
	}
	
	function hlChecked(s,c) {
		var control = document.getElementById('cb_'+s+'_'+c);
		if (control.checked) {
			document.getElementById('td_'+s+'_'+c).style.backgroundColor = 'FFFFCF';
		} else {
			document.getElementById('td_'+s+'_'+c).style.backgroundColor = '';
		}
	}
	
	function validatePriceSchedule(m,li,total,show,cat,cls) {
		var control = document.getElementById('inherit');
		var control2 = document.getElementById('sync');
		var message = '';
		var action = '';
		
		if (control.checked || control2.checked) {
		
			if (total == 0) {			
				message = 'This action will not affect any more items, since there are not more items associated to ' + m + ' defined as ' + cls + ' in the category ' + cat + '.';
				alert(message);				
			} else {
				
				if (control.checked) action = 'add';
				if (control2.checked) action = 'replace';
				
				message = 'This action will ' + action + ' these price settings to:\n\n' + li + '\nPlus ';
				if (total >= show) message = message + String(total-show) + ' more items and ';
				message = message + 'all possible items that are being created or associated to ' + m + ' defined as ' + cls + ' in the category ' + cat + ' in this moment.';
				message = message + '\n\nDo you want to continue ?';
				
				if (!confirm(message)) {
					return false
				}				
			}			
		}
		
		return true;
	}
	
	function toggleCopyPriceSchedule(c) {
	
		if (document.getElementById(c).checked) document.getElementById(c).checked = false;
		
	}
	
	function selectMetric(controltochange, controltochange2, controltochange3, control){
			if (control.checked){		
				document.getElementById(controltochange).style.backgroundColor = 'E1EDFF';
				document.getElementById(controltochange2).style.display = 'inline';
			} else {
				document.getElementById(controltochange).style.backgroundColor =  '';
				document.getElementById(controltochange2).style.display = 'none';
				document.getElementById(controltochange3).value = 0;
			}
		}
	
	function selectMetric(controltochange, controltochange2, controltochange3, controltochange4, controltochange5, control){
		if (control.checked){		
			document.getElementById(controltochange).style.backgroundColor = 'E1EDFF';
			document.getElementById(controltochange2).style.display = 'inline';
			document.getElementById(controltochange4).style.display = 'inline';
			if (document.getElementById(controltochange5)) {
				document.getElementById(controltochange5).style.display = 'inline';
			}
		}
		else{
			document.getElementById(controltochange).style.backgroundColor =  '';
			document.getElementById(controltochange2).style.display = 'none';
			document.getElementById(controltochange4).style.display = 'none';
			if (document.getElementById(controltochange5)) {
				document.getElementById(controltochange5).style.display = 'none';
			}
			document.getElementById(controltochange3).value = 0;
		}
	}
	
	function editMetricLocation(itemno,supplyitemno,supplyitemuom,supplyitemuomdescription,mission,location,metric,dateEffective,action,type) {
		var vWidth = 675;
		var vHeight = 375;  				   
		ColdFusion.Window.create('mydialog', 'Metric', '',{x:30,y:30,height:vHeight,width:vWidth,modal:true,center:true});    
		ColdFusion.Window.show('mydialog'); 				
		ptoken.navigate('Consumption/ItemSupplyMetricTargetEdit.cfm?id='+itemno+'&supplyitemno='+supplyitemno+'&supplyitemuom='+supplyitemuom+'&supplyitemuomdescription='+supplyitemuomdescription+'&mission='+mission+'&locationid='+location+'&metric='+metric+'&dateEffective='+dateEffective+'&action='+action+'&type='+type+'&ts='+new Date().getTime(),'mydialog'); 
	}
	
	function supplyeditwarehouse(itemno,supplyitemno,supplyitemuom) {
		var vWidth = 900;
		var vHeight = 600;  				   
		ColdFusion.Window.create('mydialog', 'Metric', '',{x:30,y:30,height:vHeight,width:vWidth,modal:true,center:true});    
		ColdFusion.Window.show('mydialog'); 				
		ptoken.navigate('Consumption/AssetItem/AssetItemSupplyWarehouseEdit.cfm?itemno='+itemno+'&supply='+supplyitemno+'&uom='+supplyitemuom+'&ts='+new Date().getTime(),'mydialog'); 
	}
	
	function selectitemlocal(itm,box) {	
		wd = 700;
	    ht = 500;
	 	ptoken.open("#SESSION.root#/Warehouse/Inquiry/Item/ItemSelect.cfm?itemclass=supply&itmbox="+itm+"&openerbox="+box+"&ts="+new Date().getTime(),null, "left=100, top=100, width="+wd+", height="+ht+",menubar=no, toolbar=no, status=yes, scrollbars=no, resizable=yes");
	}
 
</script>

</cfoutput>

<cfinclude template="../ItemMaster/ItemViewScript.cfm">

<cf_divscroll>

<table width="100%" height="100%">

<cfif url.id eq "">
		
	<tr><td valign="top" id="contentbox1" style="padding:10px"><cfinclude template="ItemForm.cfm"></td></tr>
	
<cfelse>	 

	<tr class="hide"><td height="4" id="process"></td></tr>
	
	<cfquery name="getWarehouse" 
	datasource="appsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT *
		FROM  Warehouse W
		WHERE Mission = '#url.fmission#'
		AND  Warehouse IN (SELECT Warehouse 
		                   FROM   WarehouseJournal 
						   WHERE  Warehouse = W.Warehouse
						   AND    Area = 'SALE')
	</cfquery>
	
	<tr><td height="20">
	
		<table width="100%">
		<tr>
		
			<cfset wd = "74">
			<cfset ht = "74">		
			
			<cfset itm = "1">

			<cf_tl id = "Details" var = "1">
			<cf_menutab item       = "#itm#" 
			            iconsrc    = "Detail.png" 
						iconwidth  = "#wd#" 
						iconheight = "#ht#" 
						targetitem = "1"
						padding    = "0"
						class      = "highlight1"
						name       = "#lt_text#"
						source     = "ItemForm.cfm?id=#url.id#&mode=#url.mode#&loadcolor=1&idmenu=#url.idmenu#&fmission=#url.fmission#">						
			
						
			<cfif Item.ItemClass neq "Asset">
			 
			    <cfset itm = itm+1>
				<cf_tl id = "Classification" var = "1">
				<cf_menutab item       = "#itm#" 
				            iconsrc    = "Classification.png" 
							iconwidth  = "#wd#" 
							iconheight = "#ht#"
							targetitem = "2" 
							padding    = "0"
							name       = "#lt_text#"
							source     = "Classification/ItemClassification.cfm?id=#url.id#&mode=#url.mode#&idmenu=#url.idmenu#">
			</cfif>
			
			 <cfset itm = itm+1>
				<cf_tl id = "Other document" var = "1">
				<cf_menutab item       = "#itm#" 
				            iconsrc    = "Logos/System/Attachment.png" 
							iconwidth  = "#wd#" 
							iconheight = "#ht#"
							targetitem = "2" 
							padding    = "0"
							name       = "#lt_text#"
							source     = "Attachment/ItemAttachment.cfm?id=#url.id#&mode=#url.mode#&idmenu=#url.idmenu#">
			
			<!---
			<cfset itm = itm+1>
			<cf_tl id = "UoM" var = "uom">
			<cf_tl id = "and" var = "vAnd">
			<cf_tl id = "Entities" var = "usage">
			<cf_menutab item       = "#itm#" 
			            iconsrc    = "UoM.png" 
						iconwidth  = "#wd#" 
						iconheight = "#ht#"
						targetitem = "2" 
						padding    = "0"
						name       = "#uom# #vAnd# #usage#"
						source     = "UoM/ItemUoM.cfm?id=#url.id#&mode=#url.mode#&idmenu=#url.idmenu#">		
						
			--->		
			
			<cfset itm = itm+1>
			<cf_tl id = "Photo" var = "1">
			<cf_menutab item       = "#itm#" 
			            iconsrc    = "Images.png" 
						iconwidth  = "#wd#" 
						targetitem = "2"
						padding    = "0"
						iconheight = "#ht#" 
						name       = "#lt_text#"
						source     = "Picture/ItemPictureBox.cfm?id=#url.id#&mode=#url.mode#&idmenu=#url.idmenu#">		
							
						
			<cfif item.ItemClass neq "Asset" and getWarehouse.recordcount gte "1">			
			
				<cfset itm = itm+1>
				<cf_tl id = "Sales Price Schedule" var = "1">
				<cf_menutab item       = "#itm#" 
				            iconsrc    = "Price.png" 
							iconwidth  = "#wd#" 
							iconheight = "#ht#"
							targetitem = "2" 
							padding    = "0"
							name       = "#lt_text#"
							source     = "PriceSchedule/ItemPriceSchedule.cfm?id=#url.id#&mode=#url.mode#&idmenu=#url.idmenu#">
						
			</cfif>			
		
									
			<!--- disabled here as now we have a combined screen 			
			
			<cfset itm = itm+1>			
			<cf_tl id = "Stock Level" var = "1">
			<cf_menutab item       = "#itm#" 
			            iconsrc    = "Warehouse.png" 
						iconwidth  = "#wd#" 
						iconheight = "#ht#" 
						padding    = "2"
						targetitem = "2"
						name       = "#lt_text#"
						source     = "Stock/ItemStock.cfm?id=#url.id#&mode=#url.mode#&idmenu=#url.idmenu#">
			

			<cfset itm = itm+1>			
			<cf_tl id = "Suppliers" var = "1">
			<cf_menutab item       = "#itm#" 
			            iconsrc    = "Builder.png" 
						iconwidth  = "#wd#" 
						iconheight = "#ht#" 
						padding    = "2"
						targetitem = "2"
						name       = "#lt_text#"
						source     = "../ItemMaster/Vendors/vendorListing.cfm?id=#url.id#&mode=#url.mode#&idmenu=#url.idmenu#&mission=#url.fmission#">

            --->

			<cfif item.ItemClass eq "Asset">
			
				<cfset itm = itm+1>			
				<cf_tl id = "Consumption" var = "1">
				<cf_menutab item       = "#itm#" 
				            iconsrc    = "Logos/Warehouse/Supply.png" 
							iconwidth  = "#wd#" 
							iconheight = "#ht#" 
							padding    = "2"
							targetitem = "0"
							name       = "#lt_text#"
							source     = "Consumption/ItemSupply.cfm?id=#url.id#&mode=#url.mode#&idmenu=#url.idmenu#">
							
			</cfif>					
							
		</tr>						
		</table>	
	</td>
	</tr>	
	
	<tr><td height="1" colspan="2" class="line"></td></tr>	
						
	<tr><td colspan="2" height="100%" valign="top" style="padding:15px">
	
		<cf_divscroll>
			
		<table width="100%" height="100%">
						
			<cf_menucontainer item="1" class="regular">
			    <cfinclude template="ItemForm.cfm">					
			</cf_menucontainer>
				
			<cf_menucontainer item="2" class="hide">
							
		</table>
		
		</cf_divscroll>
		
	</td></tr>	
	
</cfif>

</table>

</cf_divscroll>



