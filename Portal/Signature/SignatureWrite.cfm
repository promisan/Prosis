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
<cfparam name="FORM.SignatureContent" default="">

<cfif FORM.SignatureContent neq "">

		<cfquery datasource="AppsSystem" name="qUpdate">
			UPDATE UserNames
			SET    Signature = '#FORM.SignatureContent#',
				   SignatureModified = getDate()
			WHERE  Account = '#account#'
		</cfquery>
		
<cfelse>

		<cfquery datasource="AppsSystem" name="qUpdate">
			UPDATE UserNames
			SET    Signature = NULL,
				   SignatureModified = getDate()
			WHERE  Account = '#account#'
		</cfquery>
		
</cfif>

<cfoutput>
		
	<cfset oSecurity = CreateObject("component","Service.Process.System.UserController")/>
	<cfset mid = oSecurity.gethash()/>  
	
	<script>
	parent.pref('UserSignature.cfm')
	</script>
	
	
</cfoutput>