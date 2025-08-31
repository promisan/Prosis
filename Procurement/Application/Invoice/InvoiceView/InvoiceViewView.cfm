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
<cf_screentop height="100%" jquery="Yes" scroll="no" layout="innerbox" html="No">

<cfparam name="URL.Mission" default="">
<cfparam name="URL.Period"  default="">
<cfparam name="URL.ID"      default="">
<cfparam name="URL.ID1"     default="">

<cf_dialogProcurement>

<cfoutput>
	
	<script>
	
	function filter() {
		document.formlocate.onsubmit() 
		if( _CF_error_messages.length == 0 ) {
		    parent.Prosis.busy('yes');
			_cf_loadingtexthtml='';
			ptoken.navigate('InvoiceViewListing.cfm?Period=#URL.Period#&ID=#URL.ID#&ID1=locate&Mission=#URL.Mission#','detail','','','POST','formlocate')
		 }   
	}	 
	
	</script>	

</cfoutput>

<cf_ListingScript>


<table width="100%" height="100%" cellspacing="0" cellpadding="0" class="formpadding">

    <cfif url.id1 eq "Locate">

	<tr><td height="100" valign="top">
		<cfinclude template="InvoiceViewLocate.cfm">
	</td></tr>
	<tr><td height="85%" valign="top">	
	    <cf_divscroll>   
			<cfdiv id="detail" style="height:100%">
		</cf_divscroll>
	</td></tr>
	<cfelse>
	
	<tr><td width="100%" height="100%" valign="top" id="detail" style="padding:3px">	   

		  <cfinclude template="InvoiceViewListing.cfm">
		
		</td>
	</tr>	
	</cfif>
</table>