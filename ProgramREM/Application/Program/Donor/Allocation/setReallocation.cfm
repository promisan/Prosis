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

<cfparam name="Form.Transaction_#left(url.contributionLineId,8)#" default="">

<cfset selected = evaluate("Form.Transaction_#left(url.contributionLineId,8)#")>

<cfif selected neq "">

<cfoutput>

		<input type="button"
		       name="action"
		       value="Process"     
			   onclick="contributionreallocate('Transaction_#left(url.contributionlineid,8)#','#url.contributionlineid#','#URL.systemfunctionid#','#URL.contributionid#')"
		       style="height:21;font-size:11px;border:1px solid gray;width: 45; background-color: red; color: white;">
			   
</cfoutput>	   

<cfelse>

</cfif>