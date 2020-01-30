
<cfparam name="URL.Page"                 default="1">
<cfparam name="SearchResult.recordCount" default="1000">
<cfparam name="client.pagerecords"       default="40">

<cfif URL.page eq "null">
	<cfset URL.page 	= "1">
</cfif>

<cfset No      = CLIENT.PageRecords>
<cfset TotalNo = SearchResult.recordCount>
<cfset first   = ((URL.Page-1)*No)+1>
<cfset pages   = Ceiling(SearchResult.recordCount/No)>
<cfif pages lt '1'>
   <cfset pages = "1">
</cfif>


