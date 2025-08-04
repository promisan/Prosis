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

<!--- apply --->

<cfif url.action eq "add">

	<cfset select = "#Form.multivalue##url.value#,"> 

<cfelseif url.action eq "delete">


	<cfset select = replaceNoCase(Form.multivalue,"#url.value#,",'')> 
	
<cfelseif url.action eq "deleteall">	

	<cfset select = ""> 
	
<cfelse>	

	<cfset select = "#Form.allv#"> 	

</cfif>


<cfoutput>

<script>
	_cf_loadingtexthtml='';		
    document.getElementById('multivalue').value = '#select#'
	multiselected('#url.fld#','#url.fly#','1')	
	multisearch('#url.fld#','#url.fly#','1')	
</script>

</cfoutput>