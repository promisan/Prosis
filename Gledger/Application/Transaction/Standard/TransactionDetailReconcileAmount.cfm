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

<cfoutput>

	<cfset url.amount = replace(url.amount,',','',"ALL")>	
	<cfset out = replace(url.outstanding,',','',"ALL")>
	
	<cfif not LSIsNumeric(url.amount)>
	   <font color="FF0000">incorrect</font>
	   <cfabort>
	</cfif>
	
	<cfset val = url.amount*url.exchange>
	
	<cfoutput>

		<script>
			 document.getElementById('val_#url.field#').value = "#NumberFormat(url.amount,'_,____.__')#"
		</script>
		
	</cfoutput>
	
	<cfif val lte out>
	
	     <script>
			 document.getElementById('off_#url.field#').value = "#NumberFormat(val,'_,____.__')#"
		</script>
				 
	<cfelse>
	
		<cfset exc = out/url.amount>
					 
			 <script>	
			     alert("Outstanding amount exceeded, will correct the exchange.")		 
				 ptoken.navigate('TransactionDetailReconcileExchange.cfm?line=#url.line#&field=#url.field#&exchange=#exc#','total')	
			 </script>
	
	</cfif>	 

</cfoutput>

<script>	
	settotal()
</script>
