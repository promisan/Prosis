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
<cfparam name="url.row"  default="1">
<cfparam name="url.col"  default="1">
<cfparam name="url.cols" default="1">
<cfparam name="url.rows" default="1">

<cfoutput>

<script>

<cfif url.row neq "99">

	base = document.getElementById("c#url.row#_1").value	

	<cfloop index="c" from="2" to="#url.cols#">
                 
	   se= document.getElementById("c#url.row#_#c#")	   	  
	   se.value = base
	  
	</cfloop>

<cfelse>

	<cfset url.row = "1">
		
</cfif>

ptoken.navigate('RequestDialogFormMatrixScript.cfm?row=#url.row#&col=#url.col#&rows=#url.rows#&cols=#url.cols#','ctotal')


</script>

</cfoutput>
