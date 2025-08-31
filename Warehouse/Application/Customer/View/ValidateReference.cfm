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
<cfparam name="url.reference"  default="">
<cfparam name="url.customerid" default="">
<cfparam name="url.mission"    default="">

<cfif len(url.reference) gt 0>

	<cfquery name="Validate" 
			 datasource="AppsMaterials" 
			 username="#SESSION.login#" 
			 password="#SESSION.dbpw#">
			 
			 SELECT * 
			 FROM   Customer
			 WHERE  Reference   = '#URL.Reference#'
			 <cfif url.customerid neq "">
			 AND    CustomerId != '#URL.CustomerId#'
			 </cfif>
			 AND    Reference  != ( SELECT CustomerDefaultReference FROM Ref_ParameterMission WHERE Mission = '#url.mission#' )
	
	</cfquery>
	
	<cfif Validate.recordcount gt 0>
		<font color="red">
			<cf_tl id="Taxcode already exists">.
		</font>
		<input type="hidden" value="0" name="validateReference" id="validateReference">
	<cfelse>
		<font color="0080C0">
			<cf_tl id="Taxcode not in use">.
		</font>
		<input type="hidden" value="1" name="validateReference" id="validateReference">
	</cfif>
	
	<!---
	<script>
	 document.getElementById('ReferenceDefault').checked = false
	</script>
	--->

<cfelse>

	<input type="hidden" value="0" name="validateReference" id="validateReference">
	
	 <!---	
	 <script>
     	 document.getElementById('ReferenceDefault').checked = true
	 </script>
	 --->
	 
</cfif>

