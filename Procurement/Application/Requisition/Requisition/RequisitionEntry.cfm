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


<cf_screentop height="100%" scroll="No" html="No" jQuery="Yes" label="Requisition">

<cfset add = 1>

<cfif URL.ID eq "new">
	<cfset add = 1>
<!--- creates --->
	<cfinclude template="RequisitionEntryRecord.cfm">

</cfif>


<table width="100%" height="100%">

  <cfoutput>

	<tr><td colspan="2" height="100%" valign="top">

	    <cf_divscroll style="height:100%">

		    <cfset status =  "1">
			<cfinclude template="RequisitionEdit.cfm">

		</cf_divscroll>

		</td>
	</tr>

  </cfoutput>

</table>

