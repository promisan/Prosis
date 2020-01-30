
<cfajaximport tags="cfdiv,cfwindow,cfform,cfinput-autosuggest">

<cfoutput>

<script>

function cancel() {
   ColdFusion.navigate('itemUnitMissionListingDetail.cfm?ID1=#URL.ID1#&ID2=#URL.ID2#','listing')
}

function saveDetail(code) {
	document.fDetail.onsubmit() 
	if( _CF_error_messages.length == 0 ) {
		alert('saved!!')		
	 }   	 
 }
 
function showunitMission(costId, serviceItem, serviceItemUnit) {    
   
	ColdFusion.Window.create('myrate', 'Rate', '',{x:0,y:0,height:document.body.clientHeight-30,width:document.body.clientWidth*0.75,modal:true,center:true})    
	ColdFusion.Window.show('myrate')				
	ColdFusion.navigate('ItemUnitMissionView.cfm?ID1=' + costId + '&ID2='+ serviceItem + '&ID3=' + serviceItemUnit,'myrate') 		

}

function showunitMissionrefresh(serviceItem, serviceItemUnit) {
	_cf_loadingtexthtml='';	
    ColdFusion.navigate('itemUnitMissionListingDetail.cfm?ID1='+ serviceItem + '&ID2=' + serviceItemUnit,'listing')	 
}

</script>

</cfoutput>
			
<table width="100%" border="0" cellspacing="0" cellpadding="1" align="center">

	<tr>	
	    <td width="100%">
			<cfdiv id="listing">
			  	<cfinclude template="itemUnitMissionListingDetail.cfm">
			</cfdiv>
		</td>		
	</tr>		

</table>	

