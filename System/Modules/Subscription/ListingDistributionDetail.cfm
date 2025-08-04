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

<!--- configuration file --->

<cf_screentop html="No" scroll="Yes" jquery="Yes">

<cf_listingscript>

<cfoutput>

<table width="100%" style="height:100%;" align="center"> 
	
	<tr>
		<td id="mainlisting" valign="top" style="padding-left:8px;height:99%">		
			<cf_securediv id="divListing" style="height:100%;" bind="url:#SESSION.root#/System/Modules/Subscription/ListingDistributionDetailContent.cfm?row=#url.row#&id=#url.id#">        	
		</td>
	</tr>
	
</table>				     
			
</cfoutput>	