<!--
    Copyright Â© 2025 Promisan B.V.

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
<cfparam name="url.objectId" default="">

<cfif url.ObjectId neq "">

<table width="99%" cellspacing="0" cellpadding="0" class="formpadding">
	<tr><td height="10"></td></tr>
	<tr><td><b>   <cf_tl id="Additional information"></b></td></tr>
	<tr><td class="line"></td></tr>
	<tr><td>
	
	<cf_ObjectHeaderFields 
	     entityId   = "#url.objectId#"
		 filter     = ""  <!--- not operational yet, but can be used to limit the fileds here --->
		 mode       = "'header','step'"
		 entityCode = "ClmNoticas"
		 caller     = "#SESSION.root#/CaseFile/Application/Claim/Additional/Additional.cfm?ObjectId=#Url.ObjectId#">
		 
	</td>	 
	</tr>
</table>

</cfif>

</cfoutput>

