
<cfparam name="URL.Assetid" default="">
<cfparam name="URL.List" default="">

<cfquery name="Asset" 
datasource="AppsMaterials" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
    FROM   AssetItem A, Item I
	WHERE  AssetId = '#URL.Assetid#'	
	AND    A.ItemNo = I.ItemNo
</cfquery>

<cfif Asset.recordcount eq "0">
	
	<table align="center">
		<tr><td height="60" class="labelit"><cf_tl id="Item no longer exists in database"></td></tr>
	</table>
	
	<cfabort>

</cfif>

<cf_screentop height="100%"    
	 scroll="No" 
	 layout="webapp"
	 line="no"
	 banner="gradient"
	 jquery="Yes"
	 label="#Asset.Category# - #Asset.ItemDescription#&nbsp;"
	 html="yes">

<cfajaximport tags="cfwindow,cfdiv,cfform,cfinput-datefield,cfchart">
<cf_menuscript>
<cf_dialogProcurement>
<cf_dialogAsset>
<cf_dialogLedger>
<cf_dialogStaffing>
<cf_filelibraryScript>
<cf_ListingScript>
<cf_picturescript>

<cfoutput>

	<script>

	function supplyeditwarehouse(itemno,supplyitemno,supplyitemuom) {
		var vWidth = 900;
		var vHeight = 600;    
				   
		ColdFusion.Window.create('mydialog', 'Metric', '',{x:30,y:30,height:vHeight,width:vWidth,modal:true,center:true});    
		ColdFusion.Window.show('mydialog'); 				
		ColdFusion.navigate('#SESSION.root#/Warehouse/Maintenance/Item/Consumption/AssetItem/AssetItemSupplyWarehouseEdit.cfm?itemno='+itemno+'&supply='+supplyitemno+'&uom='+supplyitemuom+'&ts='+new Date().getTime(),'mydialog'); 
	}

	function selectitemlocal(itm,box) {	
		wd = 700;
	    ht = 500;
	 	ptoken.open("#SESSION.root#/Warehouse/Inquiry/Item/ItemSelect.cfm?itemclass=supply&itmbox="+itm+"&openerbox="+box+"&ts="+new Date().getTime(),null, "left=100, top=100, width="+wd+", height="+ht+",menubar=no, toolbar=no, status=yes, scrollbars=no, resizable=yes");
	}
	
	function applyprogram(prg,scope) {
	   ptoken.navigate('setProgram.cfm?programcode='+prg+'&scope='+scope,'processmanual')
	}  
	
	function navigate(assetid) {
	   ColdFusion.navigate('AssetViewMenu.cfm?assetid='+assetid+'&list=#url.list#&assetactionid=new','asset')
	}
	
	function addObservation(context,oclass,assetid) {			
		w = #CLIENT.width# - 120;
		h = #CLIENT.height# - 160;				
		window.open("#SESSION.root#/Warehouse/Application/Asset/Observation/DocumentEntry.cfm?assetid="+assetid+"&observationclass=" + oclass + "&context=" + context + "&ts="+new Date().getTime(), "amendment", "left=40, top=40, width=" + w + ", height= " + h + ", status=yes, scrollbars=no, resizable=yes");		
	}
		
	function save(assetid,code,id) {
	
	   document.getElementById('action'+code).onsubmit() 
		if( _CF_error_messages.length == 0 ) {
	       ColdFusion.navigate('AssetActionContentSubmit.cfm?assetid='+assetid+'&code='+code+'&assetactionid='+id,'contentboxaction1','','','POST','action'+code)
		 }   
	 }
	 
	 function getchart(assetid,mode,scale,month,max,si) {
		ColdFusion.navigate('Consumption/AssetSupplyConsumptionViewPresentationGraph.cfm?width='+document.body.clientWidth+'&height='+document.body.clientHeight+'&assetId='+assetid+'&mode='+mode+'&scale='+scale+'&year='+$('##year').val()+'&month='+month+'&supplyItemNo='+si,'dGraph_'+si,'','','POST','fConsumption');
			
		$('##month').val(month);
		
		for (i=0;i<=max;i++)
		{
			$('##'+si+'_month_'+i).removeClass('highlight');
			$('##'+si+'_month_'+i).addClass('blue');
			$('.m_'+si+'_'+i).removeClass('highlight1');
			$('.m_'+si+'_'+i).removeClass('hide');
			if (month!=0)
				$('.m_'+si+'_'+i).addClass('hide');
						
		}

			$('##'+si+'_month_'+month).removeClass('blue');
			$('##'+si+'_month_'+month).addClass('highlight');
			$('##'+si+'_month_'+month).addClass('highlight');
	 
	    if (month!=0)
		{
			$('.m_'+si+'_'+month).removeClass('hide');
			$('.m_'+si+'_'+month).addClass('highlight1');
		}
	 }
	 
 	 function getcategory(ind,aid,cat,met,act,maxi,parent) {	 
	 	
		for (j=0;j<=parent;j++)
		{
			for (i=0;i<=maxi;i++) {
					$('##c_'+j+'_'+i).removeClass('highlight');
			}
		}	

		$('##c_'+ind).addClass('highlight');			 
		ColdFusion.navigate('Consumption/AssetSupplyConsumptionCategory.cfm?height='+document.body.clientHeight+'&width='+document.body.clientWidth+'&assetid='+aid+'&category='+cat+'&metric='+met+'&mode='+$('##viewmodeselect').val()+'&scale='+$('##scale').val()+'&year='+$('##year').val()+'&action='+act,'ditems');
	 
	 }

	 
	function supplyedit(itm,supply,uom) {
	 	var rt = '#SESSION.root#/Warehouse/Maintenance/Item/Consumption/';
		
		var vWidth = 900;
		var vHeight = 650;    
				   
		ProsisUI.createWindow('mydialog', 'Metric', '',{x:30,y:30,height:vHeight,width:vWidth,modal:true,center:true});    					
		ptoken.navigate(rt + 'ItemSupplyEdit.cfm?type=AssetItem&id='+itm+'&supply='+supply+'&uom='+uom,'mydialog'); 
	}
	
	function supplydelete(itm,supply,uom) {
	  var rt = '#SESSION.root#/Warehouse/Maintenance/Item/Consumption/';
	  ptoken.navigate(rt + 'ItemSupplyDelete.cfm?type=AssetItem&id='+itm+'&supply='+supply+'&supplyuom='+uom,'supplyedit')
	}
	
	function getsupplydefinition(itm) {
		var rt = '#SESSION.root#/Warehouse/Maintenance/Item/Consumption/AssetItem/';
		if (confirm('This action will add to your data the supply definition of the item master defined for this asset.\n\nDo you want to continue ?')) {
	    	ptoken.navigate(rt + 'GetSupplyDefinition.cfm?type=AssetItem&id=' + itm,'supplylist');
		}
	}
	
	function gotoConsumption() {
		var rt = '#SESSION.root#/Warehouse/Maintenance/Item/Consumption/';
		var itm = document.getElementById('consumptionViewMenuItem').value;
		var cmu = document.getElementById('consumptionMenuItem').value;		
		document.getElementById('menu'+itm).className = 'regular';
		document.getElementById('menu'+cmu).className = 'highlight1';
		ptoken.navigate(rt + 'ItemSupply.cfm?id=#URL.assetid#&type=AssetItem','contentbox1');
	}
	
	function selectaction(code,control) {
		if (control.checked) {
			document.getElementById('tdAction_'+code).style.backgroundColor = 'E0E7FE';
			document.getElementById('lblAction_'+code).className = 'regular';
		}else{
			document.getElementById('tdAction_'+code).style.backgroundColor = '';
			document.getElementById('lblAction_'+code).className = 'hide';
		}
	}
			 
	</script> 

</cfoutput>

<style>

.blue{ 
	display:block;
	border:1px outset #069;
	text-decoration:none;	
	line-height:1.5em;
	padding:0 .5em;
	color:6688aa;
}

.blue a:hover {
	border-color:09c;
}

.blue_selected {
	display:block;
	background: #069;
	border:1px outset #069;
	text-decoration:none;
	font-weight:bold;
	line-height:1.5em;
	padding:0 .5em;
	color:blue;
}

</style>

<!--- asset entry container --->

<cfparam name="url.mode" default="regular">

<cfif url.mode eq "regular">
	
	<table width="100%" cellspacing="0" cellpadding="0" height="100%">
		<tr><td height="3"></td></tr>
		<tr>
		<td height="100%" id="asset">
		  <cfinclude template="AssetViewMenu.cfm">
		</td>
		</tr>
		
	</table>

<cfelseif url.mode eq "consumption">
	
	<table width="100%" cellspacing="0" cellpadding="0" height="100%">
		<tr><td height="3"></td></tr>
		<tr>
		<td height="100%" id="asset">
		  <cfinclude template="Consumption/AssetSupplyConsumptionView.cfm">
		</td>
		</tr>
		
	</table>

</cfif>

<cf_screenbottom layout="webapp">