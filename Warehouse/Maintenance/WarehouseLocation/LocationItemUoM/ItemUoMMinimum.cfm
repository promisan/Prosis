
<cftry>

	<cfset calc = url.quantity*url.days>
	<cfoutput><b>#numberformat(calc,"__,__._")#
	
	</cfoutput>	
	
<cfcatch>n/a</cfcatch>	

</cftry>
