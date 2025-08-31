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
<cfset val = right("#url.source#","4")>


<cfif val eq ".JPG">		

			<cf_tl id="Apply Picture" var="1">
			<cfoutput>
				<input type="submit" 
				  name="Load" id="Load" value="#lt_text#" style="border:1px solid silver;font-size:13px;width:170;height:27" 
				  class="photoupload button10g">
			</cfoutput>

<cfelse>

	<cfoutput>
		<script>
			alert("Unsupported format.")
		</script>
	</cfoutput>

</cfif>
