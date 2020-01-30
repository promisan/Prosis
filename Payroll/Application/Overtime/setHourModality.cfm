
<!--- setmodality --->

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
				
				<!--- log the change --->
			
			</cfcase>
								
		</cfswitch>
		
</cfif>	
	