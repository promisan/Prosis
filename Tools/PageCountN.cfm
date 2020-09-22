
<cfparam name="CLIENT.PageRecords" default="100">  
<cfparam name="attributes.show"    default="#CLIENT.PageRecords#">  
<cfparam name="attributes.count"   default="1">

<cfif attributes.show lte "0">
	 <cfset Caller.No = "40">
<cfelse>
	 <cfset Caller.No = attributes.show>
</cfif>

<cfset TotalNo    = attributes.Count>

<cfif attributes.count eq 0>
	<cfset caller.first   = 1>
<cfelse>
	<cfset caller.first   = ((URL.Page-1)*Caller.No)+1>
</cfif>

<cfset caller.last    = ((URL.Page)*Caller.No)>
<cfset caller.pages   = Ceiling(attributes.Count/Caller.No)>

<cfif  caller.pages lt "1">
     <cfset caller.pages = "1">
</cfif>


