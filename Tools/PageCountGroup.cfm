<!--- initial (incomplete) attempt to create a group page counting function
page count works on individual records on SearchResult
Wanting to show records based on group must calculate records per group field and then
calculate page numbers.  Also, variable No must be modified to show this
(ie. varies depending records per group, not just CLIENT.PageRecords) krw
--->

<cfparam name="URL.Page" default="1">
<cfparam name="PageGroup.RecordCount" Default="0">

<cfset No      = #CLIENT.PageRecords#>
<cfset TotalNo = #PageGroup.RecordCount#>
<cfset first   = ((#URL.Page#-1)*#No#)+1>
<cfset pages   = Ceiling(#PageGroup.RecordCount#/#No#)>
<cfset originalPages = Ceiling(#SelectResult.RecordCount#/#No#)>
<cfif pages lt '1'><cfset pages = '1'></cfif>


