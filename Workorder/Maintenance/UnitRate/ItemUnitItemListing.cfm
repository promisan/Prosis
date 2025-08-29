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
<cfajaximport tags="cfdiv,cfform,cfinput-autosuggest">

<cf_screentop htmp="No" jquery="Yes" html="No">

<cfoutput>

<script>

function cancel() {
   ptoken.navigate('itemUnitItemListingDetail.cfm?ID1=#URL.ID1#&ID2=#URL.ID2#','listingItem')
}

function saveDetail(code) {
	document.fDetail.onsubmit() 
	if( _CF_error_messages.length == 0 ) {
		alert('saved!!')
		//ColdFusion.navigate('itemUnitMissionListingDetail.cfm?ID1=#URL.ID1#&ID2=#URL.ID2#','listing')
	 }   	 
 }
 
function showItemUnitItem(itemNo, serviceItem, serviceItemUnit) {
     var wd = 500;
     var ht = 225;     
     
	
	ProsisUI.createWindow('mydialog', 'Unit', '',{x:100,y:100,height:ht,width:wd,modal:true,resizable:false,center:true})    					
	ptoken.navigate('itemUnitItem.cfm?ID1=' + itemNo + '&ID2='+ serviceItem + '&ID3=' + serviceItemUnit,'mydialog') 
}

function showItemUnitRefresh(itm,unit) {
    ptoken.navigate('itemUnitItemListingDetail.cfm?ID1='+ itm + '&ID2=' + unit,'listingItem');
}  

</script>

</cfoutput>
			
<table width="100%" align="center" frame="hsides">

	<tr>	
	    <td width="100%">
			<cfdiv id="listingItem">
			  	<cfinclude template="itemUnitItemListingDetail.cfm">
			</cfdiv>
		</td>		
	</tr>		

</table>	
