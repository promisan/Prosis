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

	<cfparam name="url.mid" default="">
		
	<iframe src="../Requisition/RequisitionEntry.cfm?ID=new&Mission=#URL.Mission#&Period=#URL.Period#&context=#url.Context#&requirementid=#url.Requirementid#&PersonNo=#url.PersonNo#&orgunit=#url.orgunit#&itemmaster=#url.itemmaster#&mid=#url.mid#" 
	width          = "100%" 
	height         = "100%" 
	marginwidth    = "0" 
	marginheight   = "0" 
	scrolling      = "no" 
	frameborder    = "0" 
	style          = "overflow: hidden;"/>
			
</cfoutput>
