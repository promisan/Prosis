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

<cfoutput>

<cfparam name="Form.AllowMultipleLogon"     default="0">
<cfparam name="Form.DisableTimeOut"         default="0">
<cfparam name="Form.PasswordExpiration"     default="0">
<cfparam name="Form.DisableIPRouting"       default="0">
<cfparam name="Form.DisableFriendlyError"   default="0">
<cfparam name="Form.DisableNotification"    default="0">
<cfparam name="Form.EnablePreproduction"    default="0">
<cfparam name="Form.EnforceLDAP"            default="0">
<cfparam name="Form.eMailAddressExternal"   default="0">
<cfparam name="Form.Remarks"                default="0">

<cfif Len(Form.Remarks) gt 200>
	 <cf_alert message = "Your entered a remarks that exceeded the allowed length of 100 characters."
	  return = "back">
	  <cfabort>
</cfif>

<cfquery name="getUser" 
datasource="AppsSystem" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT * 
	FROM   UserNames
	WHERE  Account = '#Form.Account#'
</cfquery>

<cfif getUser.AccountType eq "Individual">
	
	<cfset list = "LastName,FirstName,IndexNo,Gender,AccountMission,AccountOwner,AccountGroup,eMailAddress,MailServerDomain,MailServerAccount">
	
	<cfloop index="field" list="#list#">
	
		<cfif evaluate("getUser.#field#") neq evaluate("Form.#field#")>		
					
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
			   
			VALUES
			
				(
				 '#Form.Account#',
				 '#field#',
				 <cfqueryparam
          value="#evaluate('getUser.#field#')#"
          cfsqltype="CF_SQL_CHAR">,
				<cfqueryparam
          value="#evaluate('Form.#field#')#"
          cfsqltype="CF_SQL_CHAR">,
				 '#SESSION.acc#',
				 '#SESSION.last#',
				 '#SESSION.first#'
				 )
				 
			</cfquery>	 
	
		</cfif>
	
	</cfloop>

</cfif>

<cfquery name="Save" 
		datasource="AppsSystem" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		UPDATE   UserNames 
		SET      LastName               = '#Form.LastName#',  
				 <cfif Form.AccountType eq "Individual">
				 FirstName              = '#Form.FirstName#',
				 IndexNo                = '#Form.IndexNo#',
				 PersonNo               = '#Form.EmployeeNo#',
				 Gender                 = '#Form.Gender#',
				 eMailAddressExternal   = '#Form.eMailAddressExternal#',
				 </cfif>
				 AccountMission         = '#Form.AccountMission#',
				 AccountOwner           = '#Form.AccountOwner#',
				 AccountGroup           = '#Form.AccountGroup#',
				 eMailAddress           = '#Form.eMailAddress#',
				 AccountNo              = '#Form.AccountNo#',
				 MailServerDomain       = '#Form.MailServerDomain#',
				 MailServerAccount      = '#Form.MailServerAccount#',
				 enablePreproduction    = '#Form.enablePreproduction#',				
				 DisableFriendlyError   = '#Form.DisableFriendlyError#',
				 PasswordExpiration     = '#Form.PasswordExpiration#',
				 AllowMultipleLogon     = '#Form.AllowMultipleLogon#',
				 DisableIPRouting       = '#Form.DisableIPRouting#',
				 DisableNotification    = '#Form.DisableNotification#',
				 DisableTimeOut         = '#Form.DisableTimeOut#',
				 EnforceLDAP            = '#Form.EnforceLDAP#',
		         Remarks                = '#Form.Remarks#' 
		WHERE    Account = '#Form.Account#'
</cfquery>

<cfif Form.AccountType neq "Individual">

	<cfparam name="form.FunctionSelect" default="">
	
	<cfquery name="clean" 
	datasource="AppsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		DELETE
		FROM   MissionProfileGroup
		WHERE  ProfileId IN (SELECT ProfileId FROM MissionProfile WHERE Mission = '#Form.AccountMission#')
		AND    AccountGroup = '#Form.Account#'
	</cfquery>
	
	<cfif form.functionselect neq "">
	
		<cfloop index="itm" list="#Form.FunctionSelect#">
		
			<cfquery name="Insert" 
				datasource="AppsOrganization" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				INSERT INTO MissionProfileGroup
				       (ProfileId, AccountGroup, Operational, OfficerUserId, OfficerLastName, OfficerFirstName)	
				VALUES ( '#itm#','#form.account#','1','#session.acc#','#session.last#','#session.first#')
			</cfquery>
			
		</cfloop>
	
	</cfif>


</cfif>

<script LANGUAGE = "JavaScript">
  	
	<cfif url.script neq "">
	try {	 		
	   parent.parent.#url.script#('#form.account#')
	    } catch(e) { }	 
	</cfif> 
	   
	try {
	    parent.parent.ProsisUI.closeWindow('mydialog',true) }	
	  catch(e) {parent.window.close() }	 
	
</script>

  
</cfoutput>	
