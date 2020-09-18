
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
	