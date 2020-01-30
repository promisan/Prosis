
<!--- verifies if template exists --->

<cfparam name="url.template" default="">

<cfif url.template neq "">
	
	<cfoutput>
		
		<cftry>
	
			<cfif FileExists("#SESSION.root#/#url.template#")>					
				<img src="#SESSION.root#/Images/check_mark.gif" alt="" border="0" align="absmiddle">						
			<cfelse>	
				<img src="#SESSION.root#/Images/alert.gif" alt="" border="0">				
			</cfif>		
		<cfcatch>		
				<img src="#SESSION.root#/Images/alert_stop.gif" alt="" border="0">	
		</cfcatch>
		
		</cftry>
	
	</cfoutput>

<cfelse>

 <cf_compression>

</cfif>
