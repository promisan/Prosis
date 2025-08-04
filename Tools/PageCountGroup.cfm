<!--
    Copyright © 2025 Promisan

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

        http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
-->
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


