<!--
    Copyright © 2025 Promisan

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

<cf_screentop html="No" Title="Invoice Listing" jquery="Yes">

<cfparam name="URL.Mission" default="">
<cfparam name="URL.Period" default="">
<cfparam name="URL.ReceiptNo" default="">

<link rel="stylesheet" type="text/css" href="<cfoutput>#SESSION.root#/#client.style#</cfoutput>">

<cf_dialogProcurement>

<cfoutput>
<script>

function filter() {
	document.formlocate.onsubmit() 
	if( _CF_error_messages.length == 0 ) {
	     Prosis.busy('yes')
		_cf_loadingtexthtml='';	
		ptoken.navigate('LocatePurchaseDetail.cfm?Period=#URL.Period#&Mission=#URL.Mission#','detail','','','POST','formlocate')
	 }   
}	 

function more(bx,act) {

    icM  = document.getElementById(bx+"Min")
    icE  = document.getElementById(bx+"Exp")
	se   = document.getElementById(bx)
		
	if (act=="show") {
		se.className  = "regular";
		icM.className = "regular";
	    icE.className = "hide";
	} else {
		se.className  = "hide";
	    icM.className = "hide";
	    icE.className = "regular";
	}
	}
	
function receiptentry(purchase) {   
	 w = #CLIENT.width# - 90;
     h = #CLIENT.height# - 160;
	 <cfif url.receiptNo eq "">
	 ptoken.open("ReceiptEntry.cfm?Purchase="+purchase, purchase);	
	 <cfelse>
	 ptoken.open("ReceiptEntry.cfm?ReceiptNo=#url.receiptNo#&Purchase="+purchase, '_self');	
	 </cfif>
  }	

</script>	
</cfoutput>

<table width="100%" height="100%">
    <tr><td height="100" style="padding-left:10px;padding-right:10px;padding-top:5px">
		<cfinclude template="LocatePurchase.cfm">
	</td></tr>
	<tr><td height="90%" valign="top" style="padding:5px">
	<cf_divscroll id="detail"/>
	</td></tr>	

</table>
