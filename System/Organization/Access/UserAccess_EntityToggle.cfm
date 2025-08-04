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

<!--- process the request to preselect --->

<cfoutput>

<script language="JavaScript">

    try {
   
	se  = document.getElementsByName('i#url.box#')
	
	cnt = 0		
	while (se[cnt]) {
			
		if (#url.action# == '1') {
		   // se[cnt].className = "regular" : disabled for access for overtime to always show 
		} else {
		   // se[cnt].className = "hide"
		}		
		
		if (#url.action# == '1') {	    
			sc  = document.getElementById('g#url.box#_'+cnt) // field in the checkboxes for access UserAccessSelectAction.cfm
		} else {
			sc  = document.getElementById('n#url.box#_'+cnt) // field in the checkbox for access UserAccessSelectAction.cfm
		}					
		sc.click() 		
		cnt++		
				
	}	
	} catch(e) {}
	
</script>

<cfif URL.action eq "0">
	<a href="javascript:showaccess('1','#url.box#')">Grant all steps</a>
<cfelse>
	<a href="javascript:showaccess('0','#url.box#')">Revoke all steps</a>
</cfif>

</cfoutput>
