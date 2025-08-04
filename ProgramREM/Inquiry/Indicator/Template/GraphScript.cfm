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

<cfparam name="client.graph" default= "PostGradeBudget">
<cfparam name="url.item"     default= "#client.graph#">
<cfset client.graph = url.item>

<cfparam name="URL.Print" default="0">
<cfif url.print eq "1">
	<cfset w = 660>
<cfelse>
	<cfset w =  client.width-340>
</cfif>

<cfoutput>
<script>
 function listener(val,series) {
	    parent.document.getElementById("graphitem").value   = '#url.item#'
		parent.document.getElementById("graphselect").value = val
		parent.document.getElementById("graphseries").value = series
		parent.reloadlisting()
	 }
</script>
</cfoutput>