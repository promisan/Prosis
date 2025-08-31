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
<cfparam name="url.name"  default="myname">

<cfset SESSION["Count_#url.name#"] = 0>
<cfset SESSION["Base_#url.name#"]  = 1>

<cfoutput>

	<script>
  	
	Prosis.busy('yes')	
	try { clearInterval ( progressrefresh_#url.name# ) } catch(e) {}								
	progressrefresh_#url.name# = setInterval('_cf_loadingtexthtml="";ColdFusion.navigate("#session.root#/tools/ProgressBar/ProgressBar.cfm?name=#url.name#","progressbox")',2500) 												
		
	</script>
	
	
</cfoutput>
