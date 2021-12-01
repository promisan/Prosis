
<cfajaximport tags="cfdiv,cfform,cfinput-autosuggest">

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
 
function showunitService(costId, serviceItem, serviceItemUnit) {    
   
	ProsisUI.createWindow('myrate', 'Rate', '',{x:0,y:0,height:document.body.clientHeight-30,width:document.body.clientWidth*0.75,modal:true,center:true})    				
	ptoken.navigate('Service/ItemUnitServiceView.cfm?ID1=' + costId + '&ID2='+ serviceItem + '&ID3=' + serviceItemUnit,'myrate') 		

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

