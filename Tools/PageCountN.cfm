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


