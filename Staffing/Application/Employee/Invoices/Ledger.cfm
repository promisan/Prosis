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

<cf_screentop height="100%" scroll="yes" html="No" jquery="Yes"  menuaccess="context" actionobject="Person"
		actionobjectkeyvalue1="#url.id#">
		
<cf_dialogLedger>	
<cf_dialogPosition>
<cf_dialogOrganization>
<cf_listingScript>

<table width="99%" height="100%" cellspacing="0" cellpadding="0" align="center">

<tr class="linedotted">
	<td height="20" style="padding-left:0px">	
		<cfinclude template="../PersonViewHeaderToggle.cfm">
	</td>
</tr>

<tr><td height="100%" valign="top">
			
	<cfinclude template="LedgerListing.cfm">
	
</td></tr></table>
