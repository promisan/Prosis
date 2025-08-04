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
<!--- Create Criteria string for query from data entered thru search form --->


<cf_screentop height="100%" scroll="Yes" html="No" jquery="yes" systemmodule="Accounting" functionclass="Maintain" functionname="Journal" menuclass="Dialog">

<cf_listingscript>

<cfparam name="URL.ID" default="Hide">

<script>
	
	function recordadd(mis) {
	     ptoken.open("RecordAdd.cfm?mission="+mis, "Add", "left=80, top=80, width=880, height=700, toolbar=no, status=yes, scrollbars=no, resizable=no");
	}

</script>

<table width="98%" align="center" height="100%">	

	<tr style="height:20px" class="line clsNoPrint">
		<td class="labellarge" style="font-size:43px;font-weight:200;padding-top:9px;padding-left:7px;height:43px"><cfoutput>#url.Mission#</cfoutput></td>	
	</tr>	

	<tr>
	<td colspan="2" valign="top">
	   <cfinclude template="RecordListingContent.cfm">
	</td>
	</tr>
			
</table>
		

