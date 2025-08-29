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
<cfif qAssetAction.ActionDate neq "">
	<cfset Days = DateDiff("d",qAssetAction.ActionDate,now())>
	<cfif Days gt qCategory.EditDays>
		<cfset disabled = "disabled='disabled'">
	<cfelse>
		<cfset disabled = "">
	</cfif>
<cfelse>
	<cfset disabled = "">
</cfif>


<cfif qAssetAction.ActionCategoryList eq "">
	<cfset list_selected = qAssetActionPrevious.ActionCategoryList>
<cfelse>	
	<cfset list_selected = qAssetAction.ActionCategoryList>
</cfif>