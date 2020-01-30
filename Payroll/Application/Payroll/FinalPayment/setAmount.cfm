
<cfset rte = url.rate>
<cfset rte    = replace(rte,",","")>
<cfset qty = url.qty>

<cfoutput>
#numberformat(rte*qty,",.__")#
</cfoutput>
		