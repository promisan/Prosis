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

<cfif url.transactiontype eq "8" or url.TransactionType eq "6">

	<script language="JavaScript">	
	
	 ColdFusion.navigate('../Transaction/getTransferSelect.cfm?warehouse=#url.warehouse#&location=#url.location#','locationtransferbox')		
	
	 se = document.getElementsByName("box2")	 
	 cnt = 0		 
	 while (se[cnt]) {
	    se[cnt].className = "hide"
		cnt++
	 }
			 		 
	 se = document.getElementsByName("box8")
	 cnt = 0
	 while (se[cnt]) {
	    se[cnt].className = "regular"
		cnt++
	 }
	 
		 
 	</script>			


<cfelse>
			
	<script language="JavaScript">			
		
	 se = document.getElementsByName("box8")
	 cnt = 0
	 while (se[cnt]) {
	    se[cnt].className = "hide"
		cnt++
	 }
	 		 
	 se = document.getElementsByName("box2")
	 cnt = 0
	 while (se[cnt]) {
	    se[cnt].className = "regular"
		cnt++
	 }
		 
 	</script>			
	
</cfif>	
	
</cfoutput>	

