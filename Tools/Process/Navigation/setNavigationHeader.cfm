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
<cfparam name="client.topicheader" default="1">

<cfif client.topicheader eq "1">

	<cfset client.topicheader = "0">
	
	<script>
	  try {
		document.getElementById('headerline').className = "hide" } catch(e) {}
	</script>
	Help
	
<cfelse>

	<cfset client.topicheader = "1">
	
	<script>
	   try {
		document.getElementById('headerline').className = "regular" } catch(e) {}
	</script>
	Hide

</cfif>	