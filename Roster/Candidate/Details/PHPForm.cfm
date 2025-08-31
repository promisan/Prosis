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
<cf_screentop html="no">

<cfparam name="ID1" default = "">

	<cfquery name="Owner" 
	datasource="AppsSelection" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT  TOP 1 *
		FROM   Ref_ParameterOwner
		WHERE PathHistoryProfile > ''  
	</cfquery>

<cfif #Owner.recordcount# eq "0">

	<cf_tl id = "No report format has been defined." var="1" class="message">
	<cfset msg1 = lt_text>
	<cf_tl id = "Please contact your administrator" var="1" class="message">
	<cfset msg2 = lt_text>

	<cf_message message="#msg1# #msg2#" return="Back">

<cfelse>

	<cfoutput>
	<script language="JavaScript1.2">
		window.location = "#SESSION.root#/Custom/#Owner.PathHistoryProfile#?PHP_Roster_List=#ID1#"
	</script>
	</cfoutput>

</cfif>	
