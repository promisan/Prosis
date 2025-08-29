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
<cfparam name="url.measurement" default="0">
<cfparam name="url.strappingRelation" default="1">

<cfif url.strappingRelation gt 0>

	<cfset validM = 0>
	
	<cfif IsNumeric("#url.measurement#") and trim("#url.measurement#") neq "">
		<cfset validM = 1>
	</cfif>
	
	<cfif validM eq 1>
	
		<cf_getStrappingValue
				id = "#url.id#"
				lookupValue = "#url.measurement#"
				getType = "quantity"> 
		
		<cfoutput>
			<cfif resultStrappingValue neq -1>	
				<font face="calibri" size="2" color="gray">#lsNumberFormat(resultStrappingValue,",._")# &nbsp;#url.uomDescription# aprox.</b>
			<cfelse>
				<cf_tl id="No strapping reference">.
			</cfif>
		
		</cfoutput>
	
	<cfelse>
		
		<cfoutput>
			<font color="ff0000"><cf_tl id="Please, enter a numeric measurement (units)">.</font>
		</cfoutput>
	
	</cfif>

<cfelse>

	<cfoutput>
		<font color="ff0000"><cf_tl id="Not valid scale">!</font>
	</cfoutput>

</cfif>

