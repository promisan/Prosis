
<!--- check action --->

<cftry>

<cfparam name="url.scope" default="backoffice">
<cfparam name="url.object" default="">

<cfinvoke component = "Service.PendingAction.Check"
    Method           = "PendingAction"  
   	scope            = "#url.scope#"
   	returnvariable   = "getaction">
	
<cfoutput>

	<cfif url.scope eq "portal">	
		
		<cfif getAction.workflow gte "1">
		    <script>			  
			   document.getElementById('#url.object#').className = "regular"
			</script>
		<cfelse>
		     <script>			   
			   document.getElementById('#url.object#').className = "hide"
			</script> 
		</cfif>		
		
	<cfelse>			
	
		<!--- <span style="line-height: 400px; border-radius: 50%; font-size: 16px; padding:6px; color: ffffff; font-weight:bold; text-align: center; background: 000000"> --->
		#getAction.workflow#
		<!--- </span> --->
		
	</cfif>	
	
</cfoutput>		

<cfcatch></cfcatch>

</cftry>

