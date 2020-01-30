
<cfparam name="attributes.price"         default="0">
<cfparam name="attributes.quantity"      default="0">
<cfparam name="attributes.taxcode"       default="00">
<cfparam name="attributes.taxexemption"  default="0">

<!--- Query returning search results --->
<cfquery name="get"
	datasource="AppsLedger" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT *
		FROM   Ref_Tax
		WHERE  TaxCode = '#attributes.taxcode#'
</cfquery>	

<cfswitch expression="#attributes.element#">
	
	<cfcase value="extended">
			
			<cftry>
				<cfset total = attributes.price*attributes.quantity>
				<cfcatch><cfset total = "n/a"></cfcatch>
			</cftry>
		
	</cfcase>
	
	<cfcase value="tax">
							
			<cfset perc = get.Percentage*100>
			
			<cfif get.TaxCalculation eq "Exclusive">
			
					<cftry>
						<cfset total = (attributes.price*attributes.quantity)*get.Percentage>
						<cfcatch><cfset total = "n/a"></cfcatch>
					</cftry>
									
			<cfelse>			
				
					<cftry>
						<cfset total = (attributes.price*attributes.quantity)>												
						<cfset total = ((total/(total+total*get.Percentage))*(total*get.Percentage))>
						<cfcatch><cfset total = "n/a"></cfcatch>
					</cftry>
							
			</cfif>			
				
	</cfcase>
	
	<cfcase value="netsale">
			
			<cfset perc = get.Percentage*100>
			
			<cfif get.TaxCalculation eq "Exclusive">			
				
					<cftry>
						<cfset total = attributes.price*attributes.quantity>
						<cfcatch><cfset total = "n/a"></cfcatch>						
					</cftry>
								
			<cfelse>			
				
					<cftry>
						<cfset total = (attributes.price*attributes.quantity)>												
						<cfset total = total - (((total/(total+total*get.Percentage))*(total*get.Percentage)))>						
						<cfcatch><cfset total = "n/a"></cfcatch>
					</cftry>
							
			</cfif>
		
	</cfcase>
	
	<cfcase value="nettax">
				
			<cfif attributes.taxexemption eq "true">		
						
				<cfset total = 0>	
			
			<cfelse>
								
				<cfset perc = get.Percentage*100>
			
				<cfif get.TaxCalculation eq "Exclusive">
				
						<cftry>
							<cfset total = (attributes.price*attributes.quantity)*get.Percentage>
							<cfcatch><cfset total = "n/a"></cfcatch>
						</cftry>
										
				<cfelse>			
					
						<cftry>
							<cfset total = (attributes.price*attributes.quantity)>												
							<cfset total = ((total/(total+total*get.Percentage))*(total*get.Percentage))>
							<cfcatch><cfset total = "n/a"></cfcatch>
						</cftry>
								
				</cfif>			
			
			</cfif>
					
	</cfcase>
	
	<cfcase value="payable">
				
			<cfif attributes.taxexemption eq "true">
		
						
				<cfif get.TaxCalculation eq "Exclusive">				
					
						<cftry>
							<cfset total = attributes.price*attributes.quantity>							
							<cfcatch><cfset total = "n/a"></cfcatch>
						</cftry>
											
				<cfelse>				
					
						<cftry>						
							<cfset total = (attributes.price*attributes.quantity)>	
							<cfset total = (total/(total+total*get.Percentage))*total>																			
							<cfcatch><cfset total = "n/a"></cfcatch>
						</cftry>
				
				</cfif>								
			
			<cfelse>
								
				<cfif get.TaxCalculation eq "Exclusive">				
					
						<cftry>
							<cfset total = attributes.price*attributes.quantity*(1+get.Percentage)>							
							<cfcatch><cfset total = "n/a"></cfcatch>
						</cftry>
											
				<cfelse>				
					
						<cftry>
							<cfset total = (attributes.price*attributes.quantity)>																			
							<cfcatch><cfset total = "n/a"></cfcatch>
						</cftry>
								
				</cfif>		
			
			</cfif>
					
	</cfcase>

</cfswitch>

<cfset caller.amount = total>
