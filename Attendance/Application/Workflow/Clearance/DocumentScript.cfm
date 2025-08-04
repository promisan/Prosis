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

<cf_systemscript>

<cfoutput>
	
	<script>
	
	function memoshow(memo,act,id,per) {
	    icM  = document.getElementById(memo+"Min")
	    icE  = document.getElementById(memo+"Exp")
		se   = document.getElementById(memo)
		
		if (act == "show") {
		
			se.className  = "regular";
			icM.className = "regular";
		    icE.className = "hide";
			ColdFusion.navigate('#session.root#/Attendance/Application/Workflow/Clearance/DocumentMemo.cfm?id='+id+'&personno='+per,memo+'_content')
			
		} else {
		
			se.className  = "hide";
		    icM.className = "hide";
		    icE.className = "regular";
		}
	}
	
	</script>

</cfoutput>