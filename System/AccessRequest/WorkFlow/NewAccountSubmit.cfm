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

<cfquery name="Check" 
	datasource="AppsSystem" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT   *
	FROM     UserRequestNames
	WHERE    RequestId = '#url.requestId#'
</cfquery>

<cfif Check.recordcount gt 0>

	<font size="2">
		<font color="red">
			<cf_tl id="You have alreay created an account for this request. Operation not allowed. Press continue." class="message">
		</font>
	</font>

<cfelse>

	<cfquery name="Check2" 
		datasource="AppsSystem" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT   *
		FROM     UserNames
		WHERE    Account = '#url.acc#'
	</cfquery>
	
	<cfoutput>
	
	<cfif Check2.recordcount gt 0>
		<table width="90%">
			<tr> <td height="30"></td> </tr>
			<tr>
				<td align="center">
					<font size="3">
					<font color="red">
						Account <b>#url.acc#</b> is already in use.
					</font>
					</font>
				</td>
			</tr>
		</table>
		
	<cfelse>
	
		<cfquery name="NewAccount" 
		datasource="AppsSystem" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">		
			SELECT *
			FROM   UserRequestNewAccount
			WHERE  RequestId = '#url.RequestId#'			
		</cfquery>
	
		<cfquery name="CreateAccount"
		datasource="AppsSystem" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			
			INSERT INTO UserNames
					(Account,
					<cfif Form.IndexNo neq "">
					IndexNo,
					</cfif>
					<cfif Form.PersonNo neq "">
					PersonNo,
					</cfif>
					FirstName,
					LastName,
					Gender,
					AccountOwner,
					AccountMission,
					eMailAddress,
					OfficerUserId,
					OfficerLastName,
					OfficerFirstName)
			VALUES (
			    '#url.acc#',
				<cfif Form.IndexNo neq "">
				'#Form.IndexNo#',
				</cfif>
				<cfif Form.PersonNo neq "">
				'#Form.PersonNo#',
				</cfif>
				'#Form.FirstName#',
				'#Form.Lastname#',
				'#NewAccount.Gender#',
				'#NewAccount.AccountOwner#',
				'#NewAccount.AccountMission#',
				'#NewAccount.eMailAddress#',
				'#SESSION.acc#',
				'#SESSION.last#',
				'#SESSION.first#'
				)
			
		</cfquery>
		
		<cfquery name="UpdateRequest"
		datasource="AppsSystem" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		
			INSERT INTO
			UserRequestNames (RequestId,Account)
			VALUES           ('#url.requestid#','#url.acc#');
		
		</cfquery>
		
		<table width="90%">
			<tr> <td height="30"></td> </tr>
			<tr>
				<td align="center">
					<font size="3">
					<font color="blue">
						Account <b>#url.acc#</b> has been successfully created. <br><br>Press continue.
					</font>
					</font>		
				</td>
			</tr>
		</table>
		
	</cfif>
	
	</cfoutput>

</cfif>