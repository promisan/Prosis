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


<cfparam name="url.acc" default="">


<cfquery name="Check" 
	     datasource="AppsSystem" 
		 username="#SESSION.login#" 
		 password="#SESSION.dbpw#">
		 
		 SELECT *
		 FROM   UserNames
		 WHERE  Account = '#url.acc#'
		 
</cfquery>

<cfoutput>

	<cfif Check.recordcount gt 0>
		<font color="red">
			Account is in use
			<input type="hidden" value="0" name="result" id="result">
		</font>
	<cfelse>
		<img src="#SESSION.root#/Images/check_mark.gif" alt="" border="0" align="absmiddle">
		<input type="hidden" value="1" name="result" id="result">
	</cfif>

</cfoutput>

