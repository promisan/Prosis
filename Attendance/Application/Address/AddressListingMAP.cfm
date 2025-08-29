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
<cf_screentop html="No" jquery="Yes">

<cfoutput>
	
	<script language="JavaScript">
	
		function editAddress(personNo,addressId){
		  	w = #CLIENT.width# - 60;
		    h = #CLIENT.height# - 120;
			ptoken.open('#SESSION.root#/Staffing/Application/Employee/Address/AddressEdit.cfm?ID=' + personNo + '&ID1='+addressId, '_blank', 'left=20, top=20, width=' + w + ', height= ' + h + ', status=yes, toolbar=no, scrollbars=no, resizable=yes');
		}
						
		function resizemap() {			    
			 if (document.getElementById("mapcontainer")) {			
			     reloadmap()		
			 }	
		}
				
		function reloadmap() { 	    
			_cf_loadingtexthtml='';	
			Prosis.busy('yes');									
			ptoken.navigate('../Address/AddressListingMAPContent.cfm?mission=#url.mission#&zone=#url.zone#&addresstype=#url.addresstype#&filter=#url.filter#&height='+$(window).height()+'&width='+$(window).width(),'mapcontainer');
			Prosis.busy('no')	
		}
				
	</script>

</cfoutput>

<cfajaximport tags="cfmap" params="#{googlemapkey='#client.googlemapid#'}#"> 

<cf_dialogstaffing>

<cfif client.googlemapid eq "">

	<table width="100%" height="100%" id="box">
	  <tr><td id="mapcontainer" align="center" valign="center" class="labelmedium" style="font-size:29px">
	       <cf_tl id="This function which uses Google map features is not configured">
		  </td>
	  </tr>
	</table>

<cfelse>
	
	<table width="100%" height="100%" id="box">
	  <tr><td id="mapcontainer"></td></tr>
	</table>
	
	<cfoutput>
	<script>
	
		 w = document.getElementById('box').clientWidth
		 h = document.getElementById('box').clientHeight		
		 ptoken.navigate('AddressListingMAPContent.cfm?mission=#url.mission#&zone=#url.zone#&addresstype=#url.addresstype#&filter=#url.filter#&height='+h+'&width='+w,'mapcontainer') 
		 
	</script>
	
	</cfoutput>

</cfif>


	