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
<cfoutput>
	<iframe 
		src="#session.root#/system/portal/support/summary/statistics/drillListing.cfm?val=#url.val#&series=#url.series#&item=#url.item#&init=#url.init#&end=#url.end#&by=#url.by#&id=#url.id#" 
		height="100%" 
		width="100%" 
		frameborder="0" 
		scrolling="Auto" 
		name="i_detail">
	</iframe>
</cfoutput>