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
<cfparam name="url.serialno" default="0">
<cfparam name="url.account" default="">
<cfparam name="url.entryclass" default="">
<cfparam name="url.defaultbuyer" default="xx">

<cfif url.serialno eq 0>
	<cfset vDefault = "BuyerDefault">
<cfelse>
	<cfset vDefault = "BuyerDefaultBackup">
</cfif>	

<cfoutput>

	<cfif URL.account neq "">
					  
		<cfquery name="qUser" 
		datasource="AppsSystem" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT *
		FROM UserNames 
		WHERE Account = '#url.account#'
		</cfquery>
		
		<input class="regularxl" type="Text" id="#vDefault#_#url.entryClass#" name="#vDefault#_#url.entryClass#" value="#qUser.FirstName# #qUser.LastName# #url.account#" required="No" size="20" maxlength="20">
		<input type="hidden"     name="name#url.serialno#_#url.entryclass#"   id="name#url.serialno#_#url.entryclass#" value="#url.account#">
			
	<cfelse>

		<cfquery name="qUser" 
		datasource="AppsSystem" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT *
		FROM UserNames 
		WHERE Account = '#url.defaultbuyer#'
		</cfquery>
		
	  	<input class="regularxl" type="Text" id="#vDefault#_#url.entryClass#" name="#vDefault#_#url.entryClass#" value="#qUser.FirstName# #qUser.LastName# #url.defaultbuyer#" required="No" size="20" maxlength="20">	
		<input type="hidden" name="name#url.serialno#_#url.entryclass#" 		id="name#url.serialno#_#url.entryclass#" value="#url.defaultbuyer#" >

	  
	</cfif>
	<input type="hidden" name="lastname#url.serialno#_#url.entryclass#" 	id="lastname#url.serialno#_#url.entryclass#">
	<input type="hidden" name="firstname#url.serialno#_#url.entryclass#" 	id="firstname#url.serialno#_#url.entryclass#">	

</cfoutput>