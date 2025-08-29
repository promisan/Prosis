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
<cf_SystemScript>
<cf_ListingScript>

<cfoutput>
	
	<script>
				
		function addRequestAccess(context) {					
			window.open("#SESSION.root#/System/AccessRequest/DocumentEntry.cfm?context=" + context + "&ts="+new Date().getTime(), "accessrequest", "left=40, top=40, width=920,height=830, status=yes, scrollbars=no, resizable=yes");		
		}
				
	</script>	

</cfoutput>



<cfset currrow = 0>

<cf_wfpending entityCode="AuthRequest"  
      table="#SESSION.acc#wfAuthorization" mailfields="No" includecompleted="No">		


<table width="100%" height="100%"><tr><td style="padding:10px">  
<cfinclude template="AccessRequestListingContent.cfm">
 </td></tr></table>		

	