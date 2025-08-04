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


<!--- position listing --->

<table width="100%" height="100%" cellspacing="1" cellpadding="1">

<cfoutput>
	<tr><td height="10"></td></tr>	
	<tr><td style="height:20" class="labellarge">Positions in units assigned for this workorder with a valid workschedule per #dateformat(now(),client.dateformatshow)#</td></tr>
	<tr><td class="line"></td></tr>
</cfoutput>	
	
	<tr><td></td></tr>	
	<tr><td height="100%" id="listingbox">
		<cfinclude template="PositionListingContent.cfm">
	</td></tr>
	
</table>	