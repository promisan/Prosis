
<cfquery name="Item" 
	datasource="appsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT *
	FROM   Item
	WHERE  ItemNo = '#URL.ID#'
</cfquery>

<cfquery name="ItemUoM" 
	datasource="appsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT   *
	FROM     ItemUoM
	WHERE    ItemNo = '#URL.ID#'
	AND      UoM    = '#url.uom#' 
</cfquery>

<cfset nme = replace(Item.ItemDescription,"'","","ALL")>

<cfajaximport tags="cfdiv,cfform">
<cf_menuscript>
<cf_TextareaScript>
<cf_calendarscript>
<cf_filelibraryscript>

<cfif url.uom neq "">

	<cf_screentop height="100%" 
		   scroll="Yes" 
		   html="Yes" 
		   label="#nme# #Item.Classification# #ItemUoM.UoMDescription#"	   
		   layout="webapp" 
		   jQuery="Yes"
		   line="no"
		   banner="blue">

<cfelse>

	<cf_screentop height="100%" 
		   scroll="Yes" 
		   html="Yes" 
		   jQuery="Yes"
		   line="no"
		   banner="blue" 
		   label="#nme# #Item.Classification# #ItemUoM.UoMDescription#" 	     
		   layout="webapp">
	
</cfif>


<cf_PrinterQZTray jquery="No">
<cfoutput>

<script language="JavaScript">

function calculateVolume() {
		
	var l =0;
	var h =0;
	var w =0;
		
	if ($('##ItemUoMHeight').val()!='')	{
		h=$('##ItemUoMHeight').val()		
	}	
	if ($('##ItemUoMLength').val()!='')	{
		l=$('##ItemUoMLength').val()		
	}	
	if ($('##ItemUoMWidth').val()!='') {
		w=$('##ItemUoMWidth').val()		
	}		
	$('##ItemUoMVolume').val(l*h*w);
	
}

function uompriceedit(itm,uom,price,selectedmission) {     
   ProsisUI.createWindow('mydialog', 'Price', '',{x:30,y:30,height:document.body.clientHeight-60,width:document.body.clientWidth-60,modal:true,center:true});       				
   ptoken.navigate('UoMPrice/ItemUoMPrice.cfm?id='+itm+'&uom='+uom+'&price='+price,'mydialog') 		  
}

function uompricerefresh(itm,uom,selectedmission) {
   ptoken.navigate('UoMPrice/ItemUoMPriceView.cfm?id='+itm+'&UoM='+uom+"&selectedmission="+selectedmission,'itemUoMPricelist')	 
}

function uompricedelete(itm,uom,price,selectedmission) {
   if (confirm("Do you want to remove this record ?")) ptoken.navigate('UoMPrice/ItemUoMPriceDelete.cfm?id='+itm+'&uom='+uom+'&price='+price+"&selectedmission="+selectedmission,'itemUoMPriceedit')
}

function uommissionedit(itm,uom,mission) {     
   ProsisUI.createWindow('mydialog', 'Entity', '',{x:30,y:30,height:document.body.clientHeight-60,width:document.body.clientWidth-60,modal:true,center:true});       	
   ptoken.navigate('UoMMission/ItemUoMMission.cfm?id='+itm+'&uom='+uom+'&mission='+mission,'mydialog') 		    
}

function uommissionrefresh(itm,uom) {
	ptoken.navigate('UoMMission/ItemUoMMissionView.cfm?id='+itm+'&UoM='+uom,'itemUoMMissionlist')	 
}

function uommissiondelete(itm,uom,mission) {
   if (confirm("Do you want to remove this record ?")) ptoken.navigate('UoMMission/ItemUoMMissionDelete.cfm?id='+itm+'&uom='+uom+'&mission='+mission,'itemUoMMissionedit')
}

// to be converted into cfwindow

function uomvolumeedit(itm,uom,temperature) {
   var vWidth = 600;
   var vHeight = 250;      
   ProsisUI.createWindow('mydialog', 'Temperature', '',{x:30,y:30,height:vHeight,width:vWidth,modal:true,center:true});       		
   ptoken.navigate("UoMVolume/ItemUoMVolumeEdit.cfm?id="+itm+"&uom="+uom+"&temperature="+temperature,'mydialog');
}

function uomvolumedelete(itm,uom,temperature) {
   if (confirm("Do you want to remove this record ?")) ColdFusion.navigate('UoMVolume/ItemUoMVolumeDelete.cfm?id='+itm+'&uom='+uom+'&temperature='+temperature,'itemUoMVolumeedit')
}

function do_submit(id,uom,act){
    
	document.frmItemUoM.onsubmit() 
				
	if( _CF_error_messages.length == 0 ) {	   
		_cf_loadingtexthtml='';	
		Prosis.busy('yes')
		ptoken.navigate('ItemUoMEditSubmit.cfm?action='+act+'&id='+id+'&uom='+uom,'processItemUoM','','','POST','frmItemUoM');
		
	} else { alert("bbbb") }  
}

function updateButton(itemno,uom,labels,whs){
	lot  = $('##sLot').val();	
	ColdFusion.navigate('UoMBarCode/ButtonPrintEPL.cfm?itemno='+itemno+'&uom='+uom+'&labels='+labels+'&whs='+whs+'&lot='+lot,'buttonPrintEPL');
	ColdFusion.navigate('UoMBarCode/ButtonPrint.cfm?itemno='+itemno+'&uom='+uom+'&labels='+labels+'&whs='+whs+'&lot='+lot,'buttonPrint');
	ptoken.navigate('UoMBarCode/getBarCode.cfm?id='+itemno+'&uom='+uom+'&whs='+document.getElementById('sWarehouse').value+'&lot='+lot,'dBarcode');
}

var boxnumber=0;

function editBOM(itemno,uom,bomid,mission) {
   
	if (bomid == '') {		
		title = 'New instance BOM Item #nme# : '+mission;
	} else {
		title = 'Amend BOM Item #nme# : '+mission;
	}			
    ProsisUI.createWindow('bomform',title,'',{x:100,y:100,width:document.body.offsetWidth-90,height:document.body.offsetHeight-90,resizable:false,modal:true,center:true})			  
	
    ptoken.navigate('#SESSION.root#/Warehouse/Maintenance/Item/UoM/UOMBOM/ItemUoMBOMEdit.cfm?itemno='+itemno+'&uom='+uom+'&bomid='+bomid+'&mission='+mission,'bomform');
}


function doEditBOM() {
	var materials = document.getElementById("_materials_").value.split(',');
	$.each(materials, function( index, value ) {
		if (value!='')
			selectresourceitem('','',value);
	});		
}

function editBOMSubmit(frm,box,target) {   
	document.getElementById(frm).onsubmit()
	if (_CF_error_messages.length == 0) {
		$('##boxnumbers').val(boxnumber);
		ptoken.navigate(target, box,'','','POST',frm); 
	}	  
 } 

function BOMInherit(itemno,uom,mission) {	
    try { ColdFusion.Window.destroy('bomform',true)} catch(e){};
    ProsisUI.createWindow('bomform', 'Inherit BOM Item for #nme#:+mission', '',{x:100,y:100,width:document.body.offsetWidth-90,height:document.body.offsetHeight-90,resizable:false,modal:true,center:true})			  
    ptoken.navigate('#SESSION.root#/Warehouse/Maintenance/Item/UoM/UOMBOM/ItemUoMBOMInherit.cfm?itemno='+itemno+'&uom='+uom+'&mission='+mission,'bomform');	
}

function BOMInheritSubmit(frm,box,target) {
		
	var proceed_material = false;
			
	$("input:checkbox[name=chk_material]:checked").each(function() {
	    proceed_material = true;
	});	

	if (proceed_material) {
		document.getElementById(frm).onsubmit()
		if (_CF_error_messages.length == 0) {
			ptoken.navigate(target, box, '', '', 'POST', frm)
		}
		
	} else {
		alert('You have to select at least one item to inherit and at least one mission'); 		
	}	
 }

function removebox(n) {
	$('##idisplay'+n).val(0);
	$('##tbox'+n).hide();	
}

function deleteBOM(itemno,uom,materialid) {
	_cf_loadingtexthtml="";	
	ptoken.navigate('UoMBOM/ItemUoMBOMRemove.cfm?itemno='+itemno+'&uom='+uom+'&materialid='+materialid,'itemUoMBOM');		
}

function selectresourceitem(itm,prefix,materialid) {
					
	if (prefix != '') 
		ptoken.navigate('#session.root#/Warehouse/Maintenance/Item/UoM/UoMBOM/getItem.cfm?mode=item&itemNo=' + itm + '&prefix=' + prefix, 'itembox' + prefix)
	else {
		$('##itembox').append("<div id='itembox_"+boxnumber+"' name='itembox_"+boxnumber+"'></div>");
		ptoken.navigate('#session.root#/Warehouse/Maintenance/Item/UoM/UoMBOM/getItemMemo.cfm?mode=item&itemNo=' + itm + '&prefix=' + prefix + '&boxnumber='+boxnumber+'&materialid='+materialid, 'itembox_' + boxnumber)
		boxnumber = boxnumber + 1;
	}								
}

function editmemo(togglebox) {			
	if ($('##'+togglebox).is(":visible")) 
	  	$('##'+togglebox).fadeOut(); 
	else 
	  	$('##'+togglebox).fadeIn();	
}
 
function selectall(t) {	 
	 $('[name=chk_material]').each(function(){
	 		$(this).prop('checked', t.checked);
	 });	 		
}

function printEPL(barcode,itemno,uom,desc) {

    var config = qz.configs.create("ProsisPrinter");

	total=$('##labels').val();

	var aStr = desc.split("|");

	//BX,Y,Rotation,CodeType,Narrow,WideBar,Height,PrintHumanReadable (B=Yes,N=No), data.
	//122
	var x = 122;
	var y = 120;
	var str =""; 
		
	for (i = 0; i < aStr.length; i++) {
		str = str+'A'+x+','+y+',0,3,1,1,N,"'+aStr[i]+'"\n';
		y = y + 20;
	}                                                             

	//'B'+x+',10,0,9,3,2,80,B,"'+barcode+'"\n', -- COD93
	//'B'+x+',10,0,E30,3,N,80,B,"'+barcode+'"\n', -- EAN13
	//https://www.servopack.de/support/zebra/EPL2_Manual.pdf

    var data = [
      '\nN\n',
	  'B'+x+',10,0,E30,3,N,80,B,"'+barcode+'"\n',
      str,
      '\nP'+total+',1\n'
    ];
	console.log(data);

	qz.print(config, data).catch(function(e) { console.error(e); });

}

</script>

</cfoutput>

<table width="100%" height="100%" align="center">


	<tr><td height="4" id="process2"></td></tr>	 
	
	<cfif url.uom neq "">
	
	<tr class="line"><td height="40" id="menubox" style="padding:4px">
		<cfinclude template="ItemUoMTabMenu.cfm">			
	</td>
	</tr>	
	
	</cfif>
			
	<tr>
	
		<td colspan="2" height="100%" valign="top">
			
		<table width="100%" height="100%">
						
				<cf_menucontainer item="1" class="regular">
				
					<cf_getMID>
				    <cfdiv id="divmenu1" style="height:100%;" bind="url:ItemUoMEdit.cfm?id=#url.id#&uom=#url.uom#&mid=#mid#">					
					
				</cf_menucontainer>
				
				<cf_menucontainer item="2" class="hide">				
							
		</table>
		</td>
	</tr>	

</table>
