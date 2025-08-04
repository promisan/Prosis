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

<cfset mtr  = url.meter>
<cfset ini  = replace(url.initial,",","","ALL")>
<cfset fin  = replace(url.final,",","","ALL")> 

<cfoutput>
	
	<cftry>
		
		<cfset val = fin-ini>
			
		<script>
		
			document.getElementById('#url.field#').value = '#numberformat('#val#','__,__')#'	
			
			trfsave('#url.TransactionId#',document.getElementById('transferwarehouse#url.TransactionId#').value,document.getElementById('transferlocation#url.TransactionId#').value,'#mtr#','#ini#','#fin#','#val#',document.getElementById('transfermemo#url.TransactionId#').value,document.getElementById('itemuomid#url.TransactionId#').value,this.value,document.getElementById('transfermemo#url.TransactionId#').value,'',document.getElementById('transaction#url.TransactionId#_date').value,document.getElementById('transaction#url.TransactionId#_hour').value,document.getElementById('transaction#url.TransactionId#_minute').value)		
			
		</script>
		
		<cfcatch>
			
			<script>
				 alert('Invalid number')
			</script>
		
		</cfcatch>
	
	</cftry>

</cfoutput>