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
<!--- show the total selected --->

<cfset tot = 0>

<cfoutput>

<cfloop index="fld" list="#form.fieldnames#">
   <cfif left(fld,8) eq "Transfer">
      
        <cfset val = evaluate(fld)>
		<cfset val = replaceNoCase(val,",","","ALL")>		
		
        <cfif isnumeric(val)>
		   	<cfset tot = tot + val>
		</cfif>
   </cfif>
</cfloop>


<cfif tot eq "0">

	<script>	
	 document.getElementById('processbox').className = "hide"	 
	</script>
	
<cfelse>

	
	<script>
	 document.getElementById('processbox').className = "regular"	 
	</script>

</cfif>

<b>#tot#</b>

</cfoutput>