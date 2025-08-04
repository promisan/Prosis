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
<div id="divReevaluationWaitText" 
    style="display:none; text-align:center; margin:20%; margin-top:5%; padding:5%; font-size:28px; color:FAFAFA; background-color:rgba(0,0,0,0.7); border-radius:8px;">
	
	<cf_tl id="Please wait, stock re-evaluation in progress">...
	<br><br>
	<cfprogressbar name="pBar" 
	    style="bgcolor:000000; progresscolor:DB996E; textcolor:FAFAFA;"
	    bind="cfc:Service.Excel.Excel.getstatus()" 
		height="20" 
		onComplete="hideprogress"
		interval="800" 
		autoDisplay="false" 
		width="700"/> 
</div>

<cfoutput>
	<script language="JavaScript">
		
		function reload() { 
   			opener.location.reload();
			window.close();
		}
		
		function editvendor(mission,itemno,uom,orgunitvendor) {
		
			var width = 800;
	   		var height = 680;

			try { ProsisUI.closeWindow('mydialog') } catch(e) {}
			ProsisUI.createWindow('mydialog', 'Vendor Item/UoM', '',{x:0,y:0,height:document.body.clientHeight-100,width:790,modal:true,center:true})
			ptoken.navigate("#SESSION.root#/Warehouse/Maintenance/ItemMaster/Vendors/vendorEdit.cfm?itemno="+itemno+"&mission="+mission+"&uom="+uom+"&orgunitvendor="+orgunitvendor+"&ts="+new Date().getTime(),'mydialog'); 
			
		}
		
		function showVendorInfo(orgunit) {
			ptoken.open('#SESSION.root#/System/Organization/Application/UnitView/UnitView.cfm?ID='+orgunit,orgunit);
		}
		
		function purgevendor(mission,itemno,uom,orgunitvendor) {			
			ptoken.navigate('vendorPurge.cfm?mission=' + mission + '&id=' + itemno + '&uom=' + uom + '&orgunitvendor=' + orgunitvendor,'main');
		}
		
		function editvendoroffer(mission,itemno,uom,orgunitvendor,offerid) {
			var width = 700;
	   		var height = 350;

			ColdFusion.Window.create('mydialog', 'Supply', '',{x:30,y:30,height:height,width:width,modal:true,center:true});    
			ColdFusion.Window.show('mydialog'); 				
			ptoken.navigate("#SESSION.root#/Warehouse/Maintenance/ItemMaster/Vendors/vendorOfferEdit.cfm?itemno="+itemno+"&mission="+mission+"&uom="+uom+"&orgunitvendor="+orgunitvendor+"&offerid="+offerid+"&ts="+new Date().getTime(),'mydialog'); 
		}
		
		function editvendorofferperdate(offerid,mission,itemno,uom,orgunitvendor,dateeffective) {
			var width = 700;
	   		var height = 500;
			ProsisUI.createWindow('offerdialog', 'Supply', '',{x:30,y:30,height:height,width:width,modal:true,center:true});    			
			ptoken.navigate("#SESSION.root#/Warehouse/Maintenance/ItemMaster/Vendors/vendorOfferEditPerDate.cfm?offerid="+offerid+"&itemno="+itemno+"&mission="+mission+"&uom="+uom+"&orgunitvendor="+orgunitvendor+"&dateEffective="+dateeffective+"&ts="+new Date().getTime(),'offerdialog'); 
		}	
		
		function cloneOffers(suffix) {
			if (confirm('Copy these values to the rest of locations ?')) {
				
				var pricefix    = document.getElementById('ItemPriceFixed_' + suffix).value;
				var pricevar    = document.getElementById('ItemPriceVariable_' + suffix).value;
				var tax         = document.getElementById('ItemTax_' + suffix).value;
				var taxincluded = document.getElementById('taxIncluded_' + suffix).checked;
								
				for (var i = 0; i < frmeditvendoroffer.elements.length; i++) {
	    			var e = frmeditvendoroffer.elements[i];
					
					//clone price
	    			if ( (e.name.substr(0,15) == 'ItemPriceFixed_') && (e.type=='text') ) { e.value = pricefix; }
					
					//clone price
	    			if ( (e.name.substr(0,18) == 'ItemPriceVariable_') && (e.type=='text') ) { e.value = pricevar; }
					
					//clone tax
	    			if ( (e.name.substr(0,8) == 'ItemTax_') && (e.type=='text') ) { e.value = tax; }
					
					//clone tax included
	    			if ( (e.name.substr(0,12) == 'taxIncluded_') && (e.type=='checkbox') ) { e.checked = taxincluded; }
	    		}
			}
		}	
		
		function getDataByDate(control,trig,offerid,itemno,mission,uom,orgunitvendor) {
			var vDateRaw = document.getElementById(control);
			vDateRaw.value = vDateRaw.value.replace(/ /g,"");
			
			if (validateDate(vDateRaw,'yes',1)) {
				var vDate = vDateRaw.value.substring(6, 10) + "-" + vDateRaw.value.substring(3, 5) + "-" + vDateRaw.value.substring(0, 2);
				ptoken.navigate('#SESSION.root#/Warehouse/Maintenance/ItemMaster/Vendors/vendorOfferEditPerDate_LocationList.cfm?offerid='+offerid+'&itemno='+itemno+'&mission='+mission+'&uom='+uom+'&orgunitvendor='+orgunitvendor+'&dateEffective='+vDate,'divLocationList');
			}
		}

		function doReevaluate(id, mission, mode) {
			var vContainer = '';
			_cf_loadingtexthtml='';
			Prosis.busy('yes', 'divReevaluationWaitText');		
			window['__cbReevaluation'] = function(){ Prosis.busy('no', 'divReevaluationWaitText'); };

			// show progress bar
			ColdFusion.ProgressBar.stop('pBar', true)		
			ColdFusion.ProgressBar.start('pBar'); 

			vContainer = 'contentbox2';
			if($('##'+vContainer).length == 0) {
				vContainer = 'detail';
			}

			ptoken.navigate('#session.root#/Warehouse/Maintenance/Item/Stock/setItemValuation.cfm?mode='+mode+'&mission='+mission+'&id='+id+'&revaluation='+document.getElementById('transferrevaluation').checked,vContainer,'__cbReevaluation');
		}

		function hideprogress() {		 
			ColdFusion.ProgressBar.hide('pBar')
			ColdFusion.ProgressBar.stop('pBar', true)			   			
		}
					
	</script>

</cfoutput>