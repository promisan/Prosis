<cfset setNext = 1>

<cfif Section.Obligatory eq 1>
	<cftry>
		<cfif Check.Total eq 0>
		   <cfset setNext = 0>
		</cfif>
	<cfcatch>
		   <cfset setNext = 0>	
	</cfcatch>	
	</cftry>	
</cfif>

<cfif Previous.recordcount eq 0>
	<cfset BackEnable = 0>
<cfelse>
	<cfset BackEnable = 1>			
</cfif>

<cfif Subsequent.recordcount eq 0>
	<cfset NextEnable = 0>
<cfelse>
	<cfset NextEnable = 1>
</cfif>