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

<table cellpadding="0" cellspacing="0" border="0" align="center" width="100%" height="100%">

	<tr>
		<td width="100%" height="100%" style="padding-left:8px;padding-right:8px;padding-bottom:5px;padding-top:5px">	
								
		<!--- open the app in its own iframe --->
		
		<cfoutput>
		
		<iframe src="#SESSION.root#/WorkOrder/Portal/Organization/ServiceArchive/ServiceListing.cfm?mission=#url.mission#&systemfunctionid=#url.systemfunctionid#"
        	width="100%"
	        height="100%"
    	    scrolling="no"
        	frameborder="0"/>		
			
		</cfoutput>	
							
		</td>
	</tr>
	
</table>