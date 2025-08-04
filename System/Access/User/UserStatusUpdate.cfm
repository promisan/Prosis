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

<cfif URL.act eq "1">
   <cfset st = "0">
<cfelse>
   <cfset st = "1">
</cfif>

<cfoutput>
	
	<cfif URL.act eq "1">
	
		<cfquery name="UpdateUser" 
		datasource="AppsSystem" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		
			UPDATE   UserNames 
			SET      Disabled           = '0', 
			         DisabledSource     = 'Manual', 
					 PasswordResetForce = '1',
					 Password           = '12345',
					 DisabledModified   = '#DateFormat(Now(),CLIENT.DateSQL)#' 
			WHERE    Account            = '#URL.ID4#'
			
		</cfquery>
		
		<cfquery name="Log" 
			datasource="AppsSystem" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			
			INSERT INTO UserNamesLog
					
				  (Account,
				   ActionField,
				   FieldValueFrom,
				   FieldValueTo,
				   OfficerUserId,
				   OfficerLastName,
				   OfficerFirstName)
			   
			VALUES (
				 '#URL.ID4#',
				 'Disabled',
				 '1',
				 '0',				
				 '#SESSION.acc#',
				 '#SESSION.last#',
				 '#SESSION.first#' )
				 
			</cfquery>		
		
		<!--- ----------------------- --->
		<!--- send email notification --->		
			<cf_MailUserAccountEnable 
			     account="#URL.ID4#">		
		<!--- ----------------------- --->
		 
		<img align="absmiddle" height="16" width="16"
		    src="#SESSION.root#/Images/light_green1.gif" 
			alt="Click to Deactivate" 
			border="0" onClick="javascript:setstatus('#URL.ID4#','0')">
				
	<cfelse>
	
		<cfquery name="UpdateUser" 
		datasource="AppsSystem" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		UPDATE   UserNames 
		SET      Disabled          = '1', 
				 DisabledSource    = 'Manual',
		         DisabledModified  = '#DateFormat(Now(),CLIENT.DateSQL)#' 
		WHERE    Account = '#URL.ID4#'
		</cfquery>
				
		<img align="absmiddle" height="16" width="16"
		     src="#SESSION.root#/Images/light_red1.gif" 
			 alt="Click to Activate user" onClick="javascript:setstatus('#URL.ID4#','1')"
			 border="0">

	</cfif>	

</cfoutput>
