
<cfparam name="url.idmenu" default="">

<cf_screentop height="100%" 
			  scroll="no" 
			  layout="webapp" 
			  bannerheight="50" 
			  banner="gray" 
			  label="Equipment Category" 
			  JQuery="yes"
			  line="no"
			  menuAccess="Yes" 
			  systemfunctionid="#url.idmenu#">	  


<cfoutput>

<script language="JavaScript">

function ask() {
	if (confirm("Do you want to remove this record ?")) {	
	return true 	
	}	
	return false	
}	

function validateFileFields() {			 			

	if ($('##tabIcon').val() != "") {
		if ($('##validateIcon').val() == 0) { 
			alert('Icon path not validated!');
			return false;
		} else {
			return true;
		}
	} else {
		return true;
	}		
}

function toggleEnableTransactions(control,id) {
	if (control.checked) {
		document.getElementById('div'+id).style.display = 'block';
		document.getElementById('td'+id).style.backgroundColor = 'FFFFCF';
	}
	else{
		document.getElementById('div'+id).style.display = 'none';
		document.getElementById('td'+id).style.backgroundColor = '';
	}
}

function editcategoryitem(cat,itm) {
	var vWidth = 500;
	var vHeight = 300;    
					   
	ProsisUI.createWindow('mydialog', 'Category Item', '',{x:30,y:30,height:vHeight,width:vWidth,modal:true,center:true});    				
	ptoken.navigate("CategoryItem/CategoryItemEdit.cfm?idmenu=#url.idmenu#&category=" + cat + "&item=" + itm + "&ts=" + new Date().getTime(),'mydialog'); 
}

function purgecategoryitem(cat,itm) {
	if (confirm('Do you want to remove this item ?')) {
		ptoken.navigate('CategoryItem/CategoryItemPurge.cfm?idmenu=#url.idmenu#&category=' + cat + '&item=' + itm, 'contentbox1');
	}
}

function editcategoryworkflow(action, cat, code) {
	var vWidth = 475;
	var vHeight = 350;    
	
	ProsisUI.createWindow('mydialog', 'Logging Item', '',{x:30,y:30,height:vHeight,width:vWidth,modal:true,center:true});    				
	ptoken.navigate("Logging/CategoryWorkflowEdit.cfm?idmenu=#url.idmenu#&category=" + cat + "&action=" + action + "&code=" + code + "&ts=" + new Date().getTime(),'mydialog'); 
}

function purgecategoryworkflow(action, cat, code) {
	if (confirm('Do you want to remove this workflow ?')) {
		ptoken.navigate('Logging/CategoryWorkflowPurge.cfm?idmenu=#url.idmenu#&category=' + cat + '&action=' + action + '&code=' + code, 'divObservations_'+action);
	}
}

function applyaccount(val,area) {
	ptoken.navigate('setAccount.cfm?glaccount='+val+'&area='+area,'process')	
}

</script>

</cfoutput>

<cfajaximport tags="cfwindow,cfdiv,cfform">

<cf_dialogLedger>
<cf_menuscript>

<table width="95%"      
	   height="100%">

	<tr>
		<td align="center" valign="top">
		
			<table width="100%" align="center">
				<tr>
				<cfset wd = "64">
				<cfset ht = "64">
				
				<cf_menutab item  = "1" 
			       iconsrc    = "Information.png" 
				   iconwidth  = "#wd#" 
				   iconheight = "#ht#" 
				   class      = "highlight1"
				   name       = "Details"
				   source     = "RecordEdit.cfm?id1=#url.id1#&idMenu=#url.idmenu#">
				   
				 <cf_menutab item  = "2" 
			       iconsrc    = "Accounts.png" 
				   iconwidth  = "#wd#" 
				   iconheight = "#ht#" 
				   targetitem = "1"
				   name       = "Ledger Accounts"
				   source     = "Financials/CategoryFinancials.cfm?id1=#url.id1#&idMenu=#url.idmenu#">
				   
				 <cf_menutab item  = "3" 
			       iconsrc    = "Sub-Categories.png" 
				   iconwidth  = "#wd#" 
				   iconheight = "#ht#" 
				   targetitem = "1"
				   name       = "Sub Categories"
				   source     = "CategoryItem/CategoryItem.cfm?category=#url.id1#&idMenu=#url.idmenu#">
				   
			  	<cf_menutab item  = "4" 
			       iconsrc    = "Log.png" 
				   iconwidth  = "#wd#" 
				   iconheight = "#ht#" 
				   targetitem = "1"
				   name       = "Operations Logging"
				   source     = "Logging/CategoryLogging.cfm?category=#url.id1#&idMenu=#url.idmenu#">
				   
				   <td width="10%"></td>
				 </tr>
			 </table>
		
		<td>
	</tr>
	<tr><td class="line"></td></tr>
	<tr><td height="5" id="process"></td></tr>
	
	<tr>
	
	<td height="100%" valign="top" align="center">
	   <table width="100%" height="100%">
		<cf_menucontainer item="1" class="regular">
			 <cfinclude template="RecordEdit.cfm"> 
	 	<cf_menucontainer>	
	   </table>	
	</td>
	</tr>
	
</table>

<cf_screenbottom layout="webapp" >



