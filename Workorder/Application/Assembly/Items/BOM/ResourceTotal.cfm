
<cftry>

<cfoutput>
	<cfset vTotal = URL.Qty*URL.Price>
	#NumberFormat(vTotal,"___,___.__")#
</cfoutput>

<cfcatch></cfcatch>

</cftry>