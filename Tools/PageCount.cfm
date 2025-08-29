<!--
    Copyright © 2025 Promisan B.V.

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


