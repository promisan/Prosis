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
<cfparam name="url.id" default="">

<cfif url.id neq "">
		
		<cfswitch expression="#url.field#">		
			<cfcase value="BillingMode">
												
				<cfoutput>
				
				<cfif url.value eq "contract" or url.value eq "">				
					<script>
						document.getElementById('BillingPayment#url.id#').className = "hide"
					</script>				
				<cfelse>				
					<script>
						document.getElementById('BillingPayment#url.id#').className = "regularxl"
					</script>								
				</cfif>	
				
				</cfoutput>
							
			</cfcase>	
			
			<cfcase value="BillingPayment">	
			
				<!---							
			
				<cfif url.value eq "1">
				<script>
					alert('This record will need to be reviewed again')
				</script>
				</cfif>
				
				--->
			
			</cfcase>	
			
		</cfswitch>
		
		<script>
		try {
		document.getElementById("submissionline").className = "regular"
		} catch(e) {}
		</script>
		
</cfif>	
	