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

