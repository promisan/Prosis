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
<cfparam name="url.requestid"  default="">
<cfparam name="url.personNo"   default="">
<cfparam name="url.field"      default="PersonNo">

<cfquery name="Line" 
   datasource="AppsWorkOrder" 
   username="#SESSION.login#" 
   password="#SESSION.dbpw#">
	SELECT  *	
	FROM    Request
	<cfif url.requestid eq "">
	WHERE   1=0
	<cfelse>
	WHERE   Requestid = '#url.requestid#'
	</cfif>		
</cfquery>

<cfif url.personNo neq "">
		
	<cfquery name="Person" 
	datasource="AppsEmployee" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT *
		FROM   Person
		WHERE  PersonNo = '#url.personNo#'	
	</cfquery>
	
<cfelse>
	
	<cfquery name="Person" 
	datasource="AppsEmployee" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT *
		FROM   Person
		WHERE  PersonNo = '#evaluate("Line.#url.field#")#'	
	</cfquery>
	
	<cfif Person.recordcount eq "0" and url.requestid eq "">
	
		<cfquery name="Person" 
		datasource="AppsEmployee" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT *
			FROM   Person
			WHERE  PersonNo = '#client.personNo#'	
		</cfquery>
	
	</cfif>
	
</cfif>

<table cellspacing="0" height="100%" border="0" cellpadding="0">

<tr><td>
	
	<cfoutput query="Person">
		<input type="hidden" name="#field#" id="#field#"  value="#Person.personNo#">
		<input type="hidden" name="Name"  id="Name"    value="#Person.FirstName# #Person.LastName#">						
	</cfoutput>
	
	</td>

	<td class="labelmedium" style="font-size:15px;width:400;padding-left:3px;padding-top:1px;padding-bottom:1px;height:26px;border-left:1px solid silver;border-right: 1px solid Silver;border-top: 1px solid Silver;border-bottom: 1px solid Silver;">
	<cfoutput>#Person.FirstName#&nbsp;#Person.LastName#</cfoutput>
	</td>
	
	<cfif person.recordcount eq "1">
		<td class="labelmedium" style="padding-left:6px;padding-right:6px;padding-top:1px;padding-bottom:0px;height:26px;">
		<cfoutput>
		<cf_img icon="open" onclick="EditPerson('#Person.PersonNo#')">
		</cfoutput>
		</td>
	</cfif>
	
</tr>

</table>
