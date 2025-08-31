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
<table width="100%" height="100%" cellspacing="0" cellpadding="0">

<tr><td height="20" style="padding-left:10px;padding-right:10px">



	<cf_RequirementSummary mode="Quarter" 
	     programcode="#url.programcode#" 
		 period="#url.period#"
		 edition="">
		 
		
	
</td></tr>

<tr><td class="labelmedium" style="padding-left:14px"><font color="0080C0"><b>Attention</b>: this view unlike the Costing Matrix does show disabled requirements but includes PSC (if relevant)</td></tr>

<tr><td style="padding:10px;height:100%">		
	<cfinclude template="AllotmentRequirementListingContent.cfm">
</td></tr>		
</table>		