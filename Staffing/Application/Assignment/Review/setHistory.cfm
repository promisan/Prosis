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
<cfoutput>
	
	<cfif url.action eq "hide">
	
		<script>
		document.getElementById('logheader').className = "hide"
		document.getElementById('log').className = "hide"	
		</script>
		
		<a href="javascript:ptoken.navigate('#session.root#/staffing/application/Assignment/Review/setHistory.cfm?action=show','logset')">Show history</a>
	
	<cfelse>
	
		<script>
		document.getElementById('logheader').className = "regular"
		document.getElementById('log').className = "regular"
		</script>
		
		<a href="javascript:ptoken.navigate('#session.root#/staffing/application/Assignment/Review/setHistory.cfm?action=hide','logset')">Hide history</a>
	
	</cfif>

</cfoutput>