
<table><tr><td class="labelmedium">


<cftry>

	<cfset name = MonthAsString(url.mth)>
	<cfoutput>	
		#name# 1st
	</cfoutput>
	
<cfcatch>

<cfif url.mth eq "0">
<font color="FF0000">Contract anniversary</font>
<cfelse>
<font color="FF0000">Invalid !</font>
</cfif>

</cfcatch>

</cftry>
</td></tr></table>	