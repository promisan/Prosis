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
<cf_screentop html="no" jquery="Yes">

<!--- prevent caching --->
<script language="JavaScript">
	javascript:window.history.forward(1);
</script> 

<cfajaximport tags="cfform"> 

<cf_dialogProcurement>
<cf_dialogMaterial>
<cf_systemscript>

<cfparam name="url.period" default="">
<cfparam name="URL.warehouse"  default="">

<cfoutput>
		
	<script language="JavaScript">
	
		function more(box,id,act,mode) {
				
			icM  = document.getElementById(box+"Min")
		    icE  = document.getElementById(box+"Exp")
			se   = document.getElementById(box);
					 		 
			if (act=="show") {	 
		     	 icM.className = "regular";
			     icE.className = "hide";
		    	 se.className  = "regular";
				 ptoken.navigate('../ReceiptEntry/ReceiptDetail.cfm?box=i'+id+'&Rctid='+id+'&mode='+mode+'&id1=#URL.ID1#','i'+id)
			 } else {
			   	 icM.className = "hide";
			     icE.className = "regular";
		     	 se.className  = "hide"
			 }
				 		
		  }
		  
		function reloadForm(page) { 
		   Prosis.busy('yes')
		   _cf_loadingtexthtml='';	
		   ptoken.navigate("ReceiptViewListing.cfm?systemfunctionid=#url.systemfunctionid#&mission=#URL.Mission#&warehouse=#url.warehouse#&period=#url.period#&id=#url.id#&id1=#url.id1#",'detail');	
		}  
				
				
		function filter() {
			document.formlocate.onsubmit() 
			if( _CF_error_messages.length == 0 ) {
			    Prosis.busy('yes')
				_cf_loadingtexthtml='';	
				ptoken.navigate('ReceiptViewListingPrepare.cfm?systemfunctionid=#url.systemfunctionid#&Period=#URL.Period#&ID=#URL.ID#&ID1=#URL.ID1#&Mission=#URL.Mission#','detail','','','POST','formlocate')
			 }   
		}	 
	
	</script>
	
	</cfoutput>
	
<cf_listingscript>	

<table width="100%" align="center" height="100%">
    <cfif url.id1 eq "Locate">
		<tr>
		<td style="height:10px"><cfinclude template="ReceiptViewLocate.cfm"></td>
		</tr>
		<tr>
		<td height="100%" valign="top" style="padding:3px">
		<cfdiv id="detail" style="height:100%"></td>
		</tr>
	<cfelse>
	<tr><td height="100%" align="center" valign="top">		
	   <cfinclude template="ReceiptViewListing.cfm">	
	 	</td>
	</tr>	
	</cfif>
</table>
