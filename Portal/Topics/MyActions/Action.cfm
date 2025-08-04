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

<table height="495px" width="100%">
	<tr>
		<td valign="top">		
			<cfoutput>
				<iframe src="#SESSION.root#/Portal/Topics/MyActions/ActionListing.cfm?systemfunctionid=#url.systemfunctionid#" 
					width="100%" 
					height="99%" 
					marginwidth="0" marginheight="0" scrolling="hidden" frameborder="0">
				</iframe>
			</cfoutput>
		</td>
	</tr>
</table>
