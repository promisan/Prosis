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

<cfparam name="url.leaveid"           default="">
<cfparam name="url.account"           default="">
<cfparam name="url.field"             default="">
<cfparam name="SESSION.#url.field#"   default="">

<cfquery name="Leave" 
   datasource="AppsEmployee" 
   username="#SESSION.login#" 
   password="#SESSION.dbpw#">
		SELECT  *	
		FROM    PersonLeave
		<cfif url.leaveid eq "">
		WHERE   1=0
		<cfelse>
		WHERE   LeaveId = '#url.leaveid#'
		</cfif>		
</cfquery>

<cfif url.account neq ""> <!--- user made a selection --->
		
	<cfquery name="User" 
	datasource="AppsSystem" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT *
		FROM   UserNames
		WHERE  Account = '#url.account#'	
	</cfquery>
	
	<cfset SESSION[url.field] = url.account>
				
<cfelse>

	<cfif url.leaveId neq "">
	
		<cfquery name="User" 
		datasource="AppsSystem" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT   *
			FROM     UserNames
			WHERE    Account = '#evaluate("Leave.#url.field#")#'	
		</cfquery>
	
	<cfelse>
	
		<!--- check memory --->
		
		<cfquery name="User" 
		datasource="AppsSystem" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT    *
			FROM      UserNames
			WHERE     Account = '#SESSION[url.field]#'	
		</cfquery>
							
		<cfif User.recordcount eq "0">
				
			<cfquery name="getLast" 
			datasource="AppsEmployee" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				SELECT   TOP 1 #url.field# as Account
				FROM     PersonLeave
				WHERE    PersonNo = '#url.personNo#'
				AND      Status != '9'
				ORDER BY Created DESC			
			</cfquery>
			
			<cfquery name="User" 
			datasource="AppsSystem" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				SELECT   *
				FROM     UserNames
				WHERE    Account = '#getLast.Account#'	
			</cfquery>	
			
		</cfif>		
	
	</cfif>
		
</cfif>


<cfset account   = "">
<cfset firstName = "">
<cfset lastName  = "">

<cfif User.recordcount gt 0>
	<cfset account   = User.account>
	<cfset firstName = User.firstName>
	<cfset lastName  = User.LastName>
</cfif>

<cfoutput>		

<table style="width:325">
	
	<tr>
		
		<input type="hidden" name="#field#"     id="#field#"       value="#account#">
		<input type="hidden" name="#field#name" id="#field#name"   value="#firstName# #lastName#">						
		
		<td class="labelmedium2" id="#field#content" style="width:400;padding-left:3px;padding-top:1px;padding-bottom:1px;height:27px;border: 1px solid Silver;<cfif user.recordcount eq "1">border-right:0px</cfif>">				
			<cfif user.recordcount eq "1" and user.personNo neq "">			
			  <a href="javascript:EditPerson('#User.PersonNo#')">#firstName#&nbsp;#lastName#</a>			
			<cfelse>			
			  #firstName#&nbsp;#lastName#			
			</cfif>			
		</td>
		
		<cfif user.recordcount eq "1">		
		<td align="center" onclick="document.getElementById('#field#').value='';document.getElementById('#field#name').value='';document.getElementById('#field#content').innerHTML=''" style="cursor:pointer;width:35;padding-top:1px;padding-bottom:1px;height:25px;border:1px solid Silver;border-left:0px;font-weight:bolder;border-left:0px;">X</td>
		</cfif>
						
	</tr>

</table>

</cfoutput>
