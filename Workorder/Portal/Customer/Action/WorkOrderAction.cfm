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

<cfparam name="session.selectworkorderid" default="">
<cfparam name="session.selectactiondate"  default="">

<cfset url.entryMode   = 'Batch'>

<cfif session.selectworkorderid neq "" and session.selectactiondate neq "">

	<cfset url.workorderid = session.selectworkorderid>
	<cfset url.date        = session.selectactiondate>

	<cfinclude template="WorkOrderActionListing.cfm">

<cfelse>

	<cfinclude template="WorkOrderActionSelect.cfm">

</cfif>

