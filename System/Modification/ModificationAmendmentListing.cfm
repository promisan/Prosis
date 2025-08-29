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
<cfparam name="URL.observationclass"   default="Amendment">
<cfparam name="URL.context"            default="status">
<cfparam name="URL.contextid"          default="">

<cf_screentop html="no" jquery="Yes">
<cf_SystemScript>
<cf_ListingScript>


<cfoutput>
	
	<script>
	
		function addRequest(context,oclass) {		
		    w = #CLIENT.width# - 80;
		    h = #CLIENT.height# - 150;				
			ptoken.open("#SESSION.root#/System/Modification/DocumentEntry.cfm?observationclass=" + oclass + "&context=" + context + "&ts="+new Date().getTime(), "amendment", "left=40, top=40, width=" + w + ", height= " + h + ", status=yes, scrollbars=no, resizable=yes");		
		}
				
	</script>	

</cfoutput>

<cfset currrow = 0>

<cf_wfpending entityCode="SysChange"  
      table="#SESSION.acc#wfSysChange" mailfields="No" includecompleted="No">		

<table width="100%" height="100%">
 <tr>
 <td style="padding-left:13px;padding-right:13px;padding-bottom:1px">  
 <cfinclude template="ModificationAmendmentListingContent.cfm">	
 </td>
 </tr>
</table>	


	