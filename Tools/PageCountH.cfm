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


<cfparam name="URL.Page" default="1">
<cfparam name="Attributes.recordCount" default="1">
<cfparam name="Attributes.records" default="#CLIENT.PageRecords#">

<cfset firstrow   = ((#URL.Page#-1)*#Attributes.records#)+1>
<cfset first      = ((#URL.Page#-1)*#Attributes.records#)+1>
<cfset pages     = Ceiling(#Attributes.recordCount#/#Attributes.records#)>
<cfif pages lt '1'>
   <cfset pages = '1'>
</cfif>

<cfset caller.pages = #pages#>
<cfset caller.no = #Attributes.records#>
<cfset caller.firstrow = #firstrow#>
<cfset caller.first    = #firstrow#>


