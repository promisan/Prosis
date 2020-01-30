
<!--- passtru template only --->

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


	