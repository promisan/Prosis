
<!--- iframe --->

<cfparam name="url.ServiceItem" default="">
<cfparam name="url.mode" default="data">
<cfparam name="url.width" default="">

<cfif url.width eq "" or url.width eq "undefined">
	<cfset url.width = 900>
</cfif>

<cfoutput>

<table width="100%" height="100%" cellspacing="0" cellpadding="0" border="0">

<tr><td height="100%" valign="top">



<cfif url.mode eq "chart">

	<cfinclude template="SummaryChart.cfm">
		
<cfelse>

    <cfinclude template="SummaryData.cfm">

</cfif>	


</td></tr>
</table>

</cfoutput>