<!--
    Copyright © 2025 Promisan B.V.

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
<cfif client.googleMAP eq "1">
	<cfajaximport tags="cfwindow,cfdiv,cfform,cfmap,cfinput-datefield" params="#{googlemapkey='#client.googlemapid#'}#">
<cfelse>
	<cfajaximport tags="cfwindow,cfdiv,cfform,cfinput-datefield">
</cfif>

<cf_menuscript>

<cfparam name="url.drillid" default="">

<cfif url.drillid neq "">
	
	<cfquery name="getItem" 
	     datasource="AppsMaterials" 
	     username="#SESSION.login#" 
	     password="#SESSION.dbpw#">		 
		 SELECT    *
		 FROM      ItemWarehouseLocation 
		 <cfif url.drillid eq "">
		 WHERE     1 = 0
		 <cfelse>
		 WHERE     ItemLocationId = '#url.drillid#'
		 </cfif>
	</cfquery>
	
	<cfif url.drillid neq "">
		<cfset url.warehouse = getItem.Warehouse>
		<cfset url.location  = getItem.Location>
	</cfif>	
		
	<cfquery name="Warehouse" 
		     datasource="AppsMaterials" 
		     username="#SESSION.login#" 
		     password="#SESSION.dbpw#">		 
			 SELECT    *
			 FROM      Warehouse
			 WHERE Warehouse = '#url.Warehouse#'		 
	</cfquery>
	
	<cfquery name="Location" 
		     datasource="AppsMaterials" 
		     username="#SESSION.login#" 
		     password="#SESSION.dbpw#">		 
			 SELECT    *
			 FROM      WarehouseLocation
			 WHERE     Warehouse = '#url.Warehouse#'		 
			 AND       Location  = '#url.location#'
	</cfquery>
	
	<cf_screentop height="100%" 
	   label="#Warehouse.WarehouseName# / #Location.Description# Detail"
	   scroll="no" layout="webapp" line="no" banner="gray" jQuery="Yes">
	
<cfelse>

    <cf_tl id = "Add Stock Location detail" var = "vLabel"> 
	<cf_screentop height="100%" line="no" label="#vLabel#" scroll="No" layout="webapp" banner="gray" jQuery="Yes">
	
</cfif>

<cf_calendarscript>
<cf_dialogasset>
<cfajaximport tags="cfform">

<cfoutput>

	<!---	<script type="text/javascript" src="#SESSION.root#/Scripts/jQuery/jquery.js"></script> Now we pass jQuery="Yes" in cf_screentop--->
	<script type="text/javascript" src="#SESSION.root#/Scripts/jQuery/jqueryeffects.js"></script>
	
	<script language="JavaScript">
	
	var lastRow = null;
	var lastStrapRow = null;
	
	function validate(id) {
		var refresh = 0;
		var isOk = 1;
		
		document.itemuomform.onsubmit();
		
		if( _CF_error_messages.length == 0 ) { 
			if (document.getElementById('drillid').value == '') {
				ColdFusion.navigate('ItemUoMEditSubmit.cfm?refreshstrap=0&warehouse=#url.warehouse#&location=#url.location#&drillid='+id,'saveform','','','POST','itemuomform');
			}else{
				if 	(
						document.getElementById('HighestStock').value != document.getElementById('HighestStockOld').value
						||
						document.getElementById('MaximumStock').value != document.getElementById('MaximumStockOld').value
						||
						document.getElementById('MinimumStock').value != document.getElementById('MinimumStockOld').value
						||
						document.getElementById('SafetyStock').value != document.getElementById('SafetyStockOld').value
					)
				{
					refresh = 1;
					if (confirm('You have changed the capacity settings.\nThis action will reinitialize the strapping table.\n\nWould you like to continue ?')) {       
						document.getElementById('HighestStockOld').value = document.getElementById('HighestStock').value;
						document.getElementById('MaximumStockOld').value = document.getElementById('MaximumStock').value;
						document.getElementById('MinimumStockOld').value = document.getElementById('MinimumStock').value;
						document.getElementById('SafetyStockOld').value = document.getElementById('SafetyStock').value;
					}else{
						isOk = 0;
					}
				}else{
					refresh = 0;
				}
				
				if (isOk == 1) {
					ColdFusion.navigate('ItemUoMEditSubmit.cfm?refreshstrap='+refresh+'&warehouse=#url.warehouse#&location=#url.location#&drillid='+id,'saveform','','','POST','itemuomform');
					alert("Information has been saved.")
				}
			}
		 }   
	}
	
	function itempurge(id) {	
		ColdFusion.navigate('ItemUoMEditPurge.cfm?drillid='+id,'process')		
		}   
		
	function selectLoss(control){
		if (lastRow == null) {lastRow = document.getElementById('lossRow1');}
		if (lastRow != null) {lastRow.style.backgroundColor = '';}
		if (control != null) {control.style.backgroundColor = 'E1EDFF';}
		lastRow = control;
	}
	
	function selectStrap(control){
		if (lastStrapRow == null) {lastStrapRow = document.getElementById('strapRow1');}
		if (lastStrapRow != null) {lastStrapRow.style.backgroundColor = '';}
		if (control != null) {control.style.backgroundColor = 'E1EDFF';}
		lastStrapRow = control;
	}
	
	function toggleStrappingList() {
		var vHeight = 100;
		
		if ($('##divStrappingListContainer').is(':visible')) {
			$('##divStrappingListContainer').hide('slide', { direction: 'down' }, 100, function() { $('##tdStrappingListContainer').animate({height:0},300); } );
			$('##imgStrappingTwistie').attr('src','#SESSION.root#/images/expand.png');
			$('##tdStrappingTwistie').attr('title','show');
		}else{
			$('##tdStrappingListContainer').animate({height:(vHeight)}, 100, function() { $('##divStrappingListContainer').show('slide', { direction: 'up' }, 300); } ); 
			$('##imgStrappingTwistie').attr('src','#SESSION.root#/images/collapse.png');
			$('##tdStrappingTwistie').attr('title','hide');
		}
	}
	
	function validateStrapping() {
		var numberOfStrappingItems = 0;
		var maximumStrappingItemsAllowed = 250;
		
		//detect changes
		if 	(
				document.getElementById('StrappingIncrementMode').value != document.getElementById('StrappingIncrementModeOld').value
				||
				document.getElementById('StrappingScale').value != document.getElementById('StrappingScaleOld').value
				||
				document.getElementById('StrappingIncrement').value != document.getElementById('StrappingIncrementOld').value
			)
		{
			//if something changes
			if (document.getElementById('StrappingIncrementMode').value == 'Strapping'){
				numberOfStrappingItems = parseInt(document.getElementById('StrappingScale').value / document.getElementById('StrappingIncrement').value);
			} 
			if (document.getElementById('StrappingIncrementMode').value == 'Capacity'){
				numberOfStrappingItems = parseInt(document.getElementById('HighestStock').value / document.getElementById('StrappingIncrement').value);
			}
	
			if (numberOfStrappingItems > 1 && numberOfStrappingItems <= maximumStrappingItemsAllowed) {
				if (confirm('This action will reinitialize the strapping table.\n\nWould you like to continue ?')) {
					return true;
				}else{
					return false;
				}		
			}else{
				alert('These settings would create ' + parseInt(numberOfStrappingItems).toString() + ' strapping items.\n\nOperation not allowed, please narrow your settings.\n\nMinimum allowed: 2 strapping items.\n\nMaximum allowed: '+maximumStrappingItemsAllowed+' strapping items.');
				return false;
			}
		}else{
			//no changes
			alert("No changes were made")
			return false;
		}
	}
	
	function strappingModeChange(control,highest,scale){
		if (control.value == 'Strapping') {
			$('##trStrappingScale').show();
			$('##StrappingScale').val(scale);
		}
		if (control.value == 'Capacity') {
			$('##trStrappingScale').hide();
			$('##StrappingScale').val(parseInt(highest/$('##StrappingIncrement').val()));
		}
	}
	
	function updateScale(highest){
		if ($('##StrappingIncrementMode').val() == 'Capacity') {
			$('##StrappingScale').val(parseInt(highest/$('##StrappingIncrement').val()));
		}
	}
	
	function editLoss(wh,loc,item,uom,efdate,cls){
		var width = 500;
   		var height = 325;   
		
		try { ColdFusion.Window.destroy('mydialog'); } catch(er){ }
		ColdFusion.Window.create('mydialog', 'Loss', '',{x:30,y:30,height:height,width:width,modal:true,center:true});    
		ColdFusion.Window.show('mydialog'); 				
		ColdFusion.navigate("../LocationItemLosses/AcceptableLossesEdit.cfm?warehouse="+wh+"&location="+loc+"&itemNo="+item+"&UoM="+uom+"&effectivedate="+efdate+"&class="+cls+"&ts="+new Date().getTime(),'mydialog');
	}
	
	function editLossByDate(wh,loc,item,uom,efdate,cls){
		var width = 700;
   		var height = 350;   
		
		try { ColdFusion.Window.destroy('mydialog'); } catch(er){ }
		ColdFusion.Window.create('mydialog', 'Loss By Date', '',{x:30,y:30,height:height,width:width,modal:true,center:true});    
		ColdFusion.Window.show('mydialog'); 				
		ColdFusion.navigate("../LocationItemLosses/AcceptableLossesEditByDate.cfm?warehouse="+wh+"&location="+loc+"&itemNo="+item+"&UoM="+uom+"&effectivedate="+efdate+"&ts="+new Date().getTime(),'mydialog');
	}
	
	function viewLossDefinition(wh,loc,item,uom,locclass){
		var width = 700;
   		var height = 350;   
		
		try { ColdFusion.Window.destroy('mydialog'); } catch(er){ }
		ColdFusion.Window.create('mydialog', 'Loss Definition', '',{x:30,y:30,height:height,width:width,modal:true,center:true});    
		ColdFusion.Window.show('mydialog'); 				
		ColdFusion.navigate("../LocationItemLosses/AcceptableLossesViewDefinition.cfm?warehouse="+wh+"&location="+loc+"&itemNo="+item+"&UoM="+uom+"&locationclass="+locclass+"&ts="+new Date().getTime(),'mydialog');
	}
	
	function editMovementUoM(wh,loc,item,uom,movement){
		var width = 400;
   		var height = 250;   

		try { ColdFusion.Window.destroy('mydialog'); } catch(er){ }
		ColdFusion.Window.create('mydialog', 'Movement', '',{x:30,y:30,height:height,width:width,modal:true,center:true});    
		ColdFusion.Window.show('mydialog'); 				
		ColdFusion.navigate("../LocationUoM/LocationUoMEdit.cfm?warehouse="+wh+"&location="+loc+"&itemNo="+item+"&UoM="+uom+"&movement="+movement+"&ts="+new Date().getTime(),'mydialog');
	}
	
	function purgeMovementUoM(wh,loc,item,uom,movement){
		ColdFusion.navigate('../LocationUoM/LocationUoMDelete.cfm?warehouse='+wh+'&location='+loc+'&itemNo='+item+'&UoM='+uom+'&movement='+movement,'contentbox2');
	}
	
	function editRequestUoM(wh,loc,item,uom,effective){
		var width = 500;
   		var height = 500;   
		
		try { ColdFusion.Window.destroy('mydialog'); } catch(er){ }
		ColdFusion.Window.create('mydialog', 'Request', '',{x:30,y:30,height:height,width:width,modal:true,center:true});    
		ColdFusion.Window.show('mydialog'); 				
		ColdFusion.navigate("../LocationItemRequest/RequestEdit.cfm?warehouse="+wh+"&location="+loc+"&itemNo="+item+"&UoM="+uom+"&scheduleEffective="+effective+"&ts="+new Date().getTime(),'mydialog');
	}
	
	function purgeRequestUoM(wh,loc,item,uom,effective){
		ColdFusion.navigate('../LocationItemRequest/RequestDelete.cfm?warehouse='+wh+'&location='+loc+'&itemNo='+item+'&UoM='+uom+'&scheduleEffective='+effective,'contentbox2');
	}
	
	function showmap(id) {
	     ht = document.body.clientHeight - 490
		 wt = document.body.clientWidth  - 70
	     ColdFusion.navigate('../LocationMAPView.cfm?locationid='+id+'&height='+ht+'&width='+wt,'contentbox2')
	}
	
	function viewLossDetail(id) {
		var width = 400;
   		var height = 300;
		
		try { ColdFusion.Window.destroy('mydialog'); } catch(er){ }
		ColdFusion.Window.create('mydialog', 'Loss Detail', '',{x:30,y:30,height:height,width:width,modal:true,center:true});    					
		ColdFusion.navigate("../LocationItemLosses/ViewLossDetail.cfm?id="+id+"&ts="+new Date().getTime(),'mydialog');
	}
	
	function changeWorkflow(control, code) {
		if(control.value == '3' || code == '2'){
			document.getElementById('EntityClass_'+code).style.display = 'block';
		} else {
			document.getElementById('EntityClass_'+code).style.display = 'none';
		}
	}
	
	function viewStrappingTable(wh,loc,item,uom,hei){
		var width = 850;
   		var height = 700;
		
		try { ColdFusion.Window.destroy('mydialog'); } catch(er){ }
		ColdFusion.Window.create('mydialog', 'Strapping Table', '',{x:30,y:30,height:height,width:width,modal:true,center:true});    
		ColdFusion.Window.show('mydialog'); 				
		ColdFusion.navigate("../LocationItemStrapping/StrappingListEdit.cfm?isReadonly=1&warehouse="+wh+"&location="+loc+"&itemno="+item+"&uom="+uom+"&height="+hei+"&ts="+new Date().getTime(),'mydialog');
	}
	
	function togglebox(box,action) {
	  se = document.getElementsByName(box)	 
	  cnt = 0
	  while (se[cnt]) {
	    if (action == true) {
		    se[cnt].className = "regular labelmedium"
		} else {
		    se[cnt].className = "hide"
		}	
		cnt++
	  }	     
	
	}
	
	function changeCalculation(control, code) {
		if(control.value == "Month"){
			document.getElementById('transactionClass_'+code).style.display = 'none';
			document.getElementById('percentage_'+code).style.display = 'none';
			document.getElementById('lossQuantity_'+code).style.width = '80px';
		}
		
		if(control.value == "Transaction"){
			document.getElementById('transactionClass_'+code).style.display = 'block';
			document.getElementById('percentage_'+code).style.display = 'block';
			document.getElementById('lossQuantity_'+code).style.width = '69px';	}
		
	}
	
	function getDataByDate(control, trigger, wh, loc, item, uom) {
		var vDateRaw = document.getElementById(control).value;
		var vDate = vDateRaw.substring(6, 10) + "-" + vDateRaw.substring(3, 5) + "-" + vDateRaw.substring(0, 2);
		ColdFusion.navigate('../LocationItemLosses/AcceptableLossesEditByDateDetail.cfm?warehouse='+wh+'&location='+loc+'&itemNo='+item+'&uoM='+uom+'&effDate='+vDate,'divDetailList');
	}

	function changeCalculationNormal(control, displayvalue) {
		if(control.value == "Month"){			
			document.getElementById('trTransactionClass').style.display = 'none';
		}		
		if(control.value == "Transaction"){
			document.getElementById('transactionClass').value = displayvalue;
			document.getElementById('trTransactionClass').style.display = 'block';
		}
	}
	
	function toggleModeDetail(control) {
		if (control.value == 'Interval'){
			document.getElementById('trIntervalDetail').style.display = 'block';
			document.getElementById('trMonthDetail').style.display = 'none';
			document.getElementById('ScheduleDayMonth').value = '1';
		}
		if (control.value == 'Month'){
			document.getElementById('trMonthDetail').style.display = 'block';
			document.getElementById('trIntervalDetail').style.display = 'none';
			document.getElementById('ScheduleInterval').value = '7';
		}
	}
	
	</script>

</cfoutput>

<cf_divscroll>

	<table width="94%" height="100%" cellspacing="0" cellpadding="0" align="center">
	
	<cfoutput>	
	<tr><td id="item" width="100%" align="center">
		<cfinclude template="ItemUoMEditForm.cfm">	
	</td></tr>
	
	</cfoutput>			
	
	<tr><td id="details" height="100%" width="100%">
	
		<cfif url.drillid neq "">
	
			<cfset url.itemNo = getItem.ItemNo>
			<cfset url.UoM    = getItem.UoM>
			<cfinclude template="ItemUoMMenu.cfm">
			
		</cfif>
		
		</td>
	</tr>
	
	</table>

</cf_divscroll>

<cf_screenbottom layout="webapp">