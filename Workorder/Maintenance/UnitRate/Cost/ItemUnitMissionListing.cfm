
<cfajaximport tags="cfdiv,cfform,cfinput-autosuggest">

<cfoutput>

<script>

function cancel() {
   ptoken.navigate('#session.root#/workorder/maintenance/UnitRate/Cost/ItemUnitMissionListingDetail.cfm?ID1=#URL.ID1#&ID2=#URL.ID2#','listing')
}

function saveDetail(code) {
	document.fDetail.onsubmit() 
	if( _CF_error_messages.length == 0 ) {
		alert('saved!!')		
	 }   	 
 }
 
function showunitMission(costId, serviceItem, serviceItemUnit) {     
	ProsisUI.createWindow('myrate', 'Rate', '',{x:0,y:0,height:document.body.clientHeight-30,width:document.body.clientWidth*0.75,modal:true,center:true})    					
	ptoken.navigate('#session.root#/workorder/maintenance/UnitRate/Cost/ItemUnitMissionView.cfm?ID1=' + costId + '&ID2='+ serviceItem + '&ID3=' + serviceItemUnit,'myrate') 		
}

function showunitMissionrefresh(serviceItem, serviceItemUnit) {
	_cf_loadingtexthtml='';	
    ptoken.navigate('#session.root#/workorder/maintenance/UnitRate/Cost/ItemUnitMissionListingDetail.cfm?ID1='+ serviceItem + '&ID2=' + serviceItemUnit,'ratelisting')	 
}

</script>

</cfoutput>
			
<table width="100%" align="center">

	<tr>	
	    <td width="100%">
			<cfdiv id="ratelisting">			
			  	<cfinclude template="ItemUnitMissionListingDetail.cfm">
			</cfdiv>
		</td>		
	</tr>		

</table>	

