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

<script>
	
	se = document.getElementsByName("transferperson")
	cnt = 0
	while (se[cnt]) {
	  se[cnt].className = "regular"
	  cnt++
	}  
	
	se = document.getElementsByName("transfercustomer")
	cnt = 0
	while (se[cnt]) {
	  se[cnt].className = "regular"
	  cnt++
	}  

</script>

<cfswitch expression="#url.mode#">
	
	<cfcase value="Person">
		
		<script>
		
			se = document.getElementsByName("transfercustomer")
			cnt = 0
			while (se[cnt]) {
			  se[cnt].className = "hide"
			  cnt++
			}  
		
		</script>
	
	</cfcase>

	<cfcase value="Customer">
	
		<script>
		
			se = document.getElementsByName("transferperson")
			cnt = 0
			while (se[cnt]) {
			  se[cnt].className = "hide"
			  cnt++
			}  
		
		</script>
	
	
	</cfcase>

</cfswitch>
