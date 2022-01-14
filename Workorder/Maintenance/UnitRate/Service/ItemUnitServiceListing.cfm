
<cfajaximport tags="cfdiv,cfform">

<cfoutput>

<script>

function cancelservice() {
   ptoken.navigate('Service/ItemUnitServiceListingDetail.cfm?ID1=#URL.ID1#&ID2=#URL.ID2#','listing')
}

function saveService(code) {
	document.fDetail.onsubmit() 
	if( _CF_error_messages.length == 0 ) {
		alert('saved!!')		
	 }   	 
 }
 
function edititemservice(usageid,itm,unt) {    
   
	ProsisUI.createWindow('mysetting', 'Service activity', '',{x:0,y:0,height:400,width:570,modal:true,center:true})    				
	ptoken.navigate('Service/ItemServiceEdit.cfm?ID1=' + usageid + '&ID2='+ itm + '&ID3=' + unt,'mysetting') 		

}

function edititemservicesubmit(id,itm,unt) {
   
    document.serviceaction.onsubmit() 	
	if( _CF_error_messages.length == 0 ) {
      	ptoken.navigate('Service/ItemServiceEditSubmit.cfm?ID=' + id + '&ID1='+ itm + '&ID2=' + unt,'processservice','','','POST','serviceaction')
	}   
}

function showunitServicerefresh(serviceItem, serviceItemUnit) {
	_cf_loadingtexthtml='';	
    ptoken.navigate('Service/itemUnitServiceListingDetail.cfm?ID1='+ serviceItem + '&ID2=' + serviceItemUnit,'listing')	 
}

</script>

</cfoutput>
			
<table width="100%" align="center">

	<tr>	
	    <td width="100%">
			<cfdiv id="servicelisting">
			  	<cfinclude template="itemUnitServiceListingDetail.cfm">
			</cfdiv>
		</td>		
	</tr>		

</table>	

