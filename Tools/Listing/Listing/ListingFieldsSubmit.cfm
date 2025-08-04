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

<!--- process field selection to be shown in the listing on-the-fly --->

<cfparam name="form.selfields" default="">

<cfset list = replace(form.selfields,",","|","ALL")>
<cfoutput>

<script>
    try {
	document.getElementById('selectedfields').value = '#list#'		
	applyfilter('','','content') } catch(e) {}
</script>

</cfoutput>