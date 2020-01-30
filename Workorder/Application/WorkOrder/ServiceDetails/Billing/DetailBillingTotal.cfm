
<!--- convert the entered rate amount --->
<cfset rate = replace(url.rate,",","","ALL")>
<cfset rate = replace(rate," ","","ALL")>

<cfset qty = replace(url.quantity,",","","ALL")>
<cfset qty = replace(qty," ","","ALL")>

<cftry>

	<cfset total = qty*rate>
	<cfoutput>#numberformat(total,'__,__.__')#</cfoutput>
	
	<cfcatch><font color="FF0000">Err!</font></cfcatch>

</cftry>	