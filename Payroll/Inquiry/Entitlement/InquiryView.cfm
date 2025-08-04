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

<cf_screentop
     layout="webapp" html="no" scroll="No" jquery="Yes">

<cf_dialogStaffing>
<cf_Listingscript>
 
<cfoutput>
	<script>
		function detail(id,id1,id2,itm) {	 
		     Prosis.busy('yes')
			_cf_loadingtexthtml='';	        
			ptoken.navigate('RecapItem.cfm?ID='+id+'&ID1='+id1+'&ID2='+id2+'&ID3='+itm+'&systemfunctionid=#url.systemfunctionid#','mainContainer')	
		}

		function listing(id,id1,id2,id3,itm) {	
		    Prosis.busy('yes')
			_cf_loadingtexthtml='';	   
			ptoken.navigate('RecapListingContent.cfm?ID='+id+'&ID1='+id1+'&ID2='+id2+'&ID3='+id3+'&ID4='+itm+'&systemfunctionid=#url.systemfunctionid#','listingcontent')	
		}
	</script>	
</cfoutput>
			
<table style="height:100%" width="99%" align="center">
<tr><td id="content" valign="top">
    <cfif url.id3 neq "">
	   <cfinclude template="RecapListing.cfm">		
	<cfelseif url.id eq "Year">   
	    <cfinclude template="RecapYear.cfm">
	<cfelse>	
	   <cfinclude template="RecapNode.cfm">
	</cfif>   
</td></tr>
</table>
				
	