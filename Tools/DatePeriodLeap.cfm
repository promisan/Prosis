<cfparam name="attributes.year" 	default="#year(now())#">
<cfparam name="attributes.period" 	default="y">
<cfparam name="attributes.leap" 	default="1">

<cfset vDate = createDate(attributes.year - 1, 12, 31)>
												
<cfif trim(lcase(attributes.period)) eq "w">
	<cfset vDate = dateAdd("ww", attributes.leap, vDate)>
</cfif>

<cfif trim(lcase(attributes.period)) eq "m">
	<cfset vDate = dateAdd("m", attributes.leap, vDate)>
	<cfset vDate = createDate(year(vDate), month(vDate), daysInMonth(vDate))>
</cfif>

<cfif trim(lcase(attributes.period)) eq "q">
	<cfset vDate = dateAdd("q", attributes.leap, vDate)>
	<cfset vDate = createDate(year(vDate), month(vDate), daysInMonth(vDate))>
</cfif>

<cfif trim(lcase(attributes.period)) eq "s">
	<cfset vDate = dateAdd("q", 2*attributes.leap, vDate)>
	<cfset vDate = createDate(year(vDate), month(vDate), daysInMonth(vDate))>
</cfif>

<cfif trim(lcase(attributes.period)) eq "y">
	<cfset vDate = dateAdd("yyyy", attributes.leap, vDate)>
	<cfset vDate = createDate(year(vDate), month(vDate), daysInMonth(vDate))>
</cfif>

<cfset caller.LeapDate = vDate>