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
<cfcomponent output="no">

    <cfset Instance = structNew() />
	<cfset Instance.countPolicy            = 0 />
	<cfset Instance.isPasswordValid        = FALSE />
	<cfset Instance.firstName              = "" />
	<cfset Instance.lastName               = "" />
	<cfset Instance.password               = "" />
	<cfset Instance.passwordLength         = 0 />
	<cfset Instance.passwordStrength       = "" />
	<cfset Instance.userName               = "" />
	
	<cfset instance.errorMessages          = ""/>
	
	<cfset Instance.MIN_PASSWORD_LENGTH    = 0 />
	<cfset Instance.MIN_ATLEASTPOLICY      = 0 />
	<cfset Instance.PASSWORDHISTORY			= 0 />
	
	<cffunction name="compare" access="remote" returntype="any" returnformat="JSON"  secureJSON = "yes" verifyClient = "yes">
 	 	<cfargument name="password1"   	required="true" type="string" default = "">
		<cfargument name="password2" 	required="true" type="string" default = "">

		<cfset vReturn = 	structNew()>
		
		<cfif arguments.password1 neq arguments.password2>
			<cfset vReturn.isPasswordValid   = FALSE>
			<cfset vReturn.passwordStrength  = "WEAK">			
			<cfset vReturn.errorMessages     = "<li>Please make sure confirmation password is the same.</li>">
			<cfset vReturn.status            = "<img height='23' src='#session.root#/images/error.gif'>">
		<cfelse>
			<cfset vReturn.isPasswordValid   = TRUE>
			<cfset vReturn.passwordStrength  = "STRONG">			
			<cfset vReturn.errorMessages     = "">
			<cfset vReturn.status            = "<img height='23' src='#session.root#/images/check_mark.gif'>">
		</cfif>	 

		<cfreturn serializeJSON(vReturn)>
		
	</cffunction>	
	
	<cffunction name="testPassword" access="remote" returntype="any" returnformat="JSON"  secureJSON = "yes" verifyClient = "yes">
	
 	 	<cfargument name="password"   	required="true" type="string" default = "">
		<cfargument name="userName" 	required="true" type="string" default = "">

		<cfquery name="GetUser" 
		datasource="AppsSystem">
			SELECT * FROM UserNames
			WHERE account = '#ARGUMENTS.userName#'
		</cfquery>		
		
		<cfquery name="Get" 
		datasource="AppsSystem">
			SELECT PasswordBasicPattern
			      ,PasswordTip
			      ,PasswordExpiration
			      ,PasswordOverwrite
			      ,PasswordSupport
			      ,PasswordLength
			      ,PasswordMode
			      ,PasswordHistory
			FROM   Parameter 
		</cfquery>

		<cfset Instance.PASSWORDHISTORY = Get.PasswordHistory>

		<cfswitch expression="#Get.PasswordMode#" >
			<cfcase value="Basic">
				<cfset Instance.MIN_PASSWORD_LENGTH    = 0 />		
			</cfcase>	 
			<cfcase value="Intermediate">
				<cfset Instance.MIN_PASSWORD_LENGTH    = Get.PasswordLength />
				<cfset Instance.MIN_ATLEASTPOLICY      = 3 />
			</cfcase>	 
			<cfcase value="Strong">
				<cfset Instance.MIN_PASSWORD_LENGTH    = Get.PasswordLength />
				<cfset Instance.MIN_ATLEASTPOLICY      = 4 />
			</cfcase>	 
		</cfswitch>	 		
		
		<cfset local   = 	structNew()>
		<cfset vReturn = 	structNew()>
		
		<cfset local.password       = trim(arguments.password)>
		<cfset local.userName       = trim(arguments.userName)>
		<cfset local.firstName      = trim(GetUser.firstName)>
		<cfset local.lastName       = trim(GetUser.lastName)>

		<cfset local.passwordLength = len(local.password)>

		<cfset local.countLowerCaseLetters = 0>	
		<cfset local.countPolicy = 0>
		 
		<cfset local.letterIndex = reFind("[a-z]", local.password, 1)>
		<cfif local.letterIndex gt 0> 
				<cfset local.countPolicy = local.countPolicy+1>
		</cfif>
		
		<cfset local.letterIndex = reFind("[A-Z]", local.password, 1)>
		<cfif local.letterIndex gt 0> 
				<cfset local.countPolicy = local.countPolicy+1>
		</cfif>

	    <cfset local.letterIndex = reFind("[0-9]", local.password, 1)>
		<cfif local.letterIndex gt 0> 
			<cfset local.countPolicy = local.countPolicy+1>
		</cfif>

	    <cfset local.letterIndex = reFind("[\W]", local.password, 1)>
		<cfif local.letterIndex gt 0> 
			<cfset local.countPolicy = local.countPolicy+1>
		</cfif>
		
		<cfset Instance.countPolicy             = local.countPolicy>
		<cfset Instance.firstName               = local.firstName>
		<cfset Instance.lastName                = local.lastName>
		<cfset Instance.password                = local.password>
		<cfset Instance.passwordLength          = local.passwordLength>
		<cfset Instance.userName                = local.userName>
					
		<cfset doTest()>

		<cfset vReturn.isPasswordValid          = instance.isPasswordValid>
		<cfset vReturn.passwordStrength         = instance.passwordStrength>
		<cfset vReturn.errorMessages            = instance.errorMessages>
		<cfset vReturn.status                   = instance.status>

		<cfreturn serializeJSON(vReturn)>
		
	</cffunction>		
	
	<cffunction name="doTest" access="private">

		<cfset vReturn = 	structNew()>
											
		<cfif Instance.passwordLength gte instance.MIN_PASSWORD_LENGTH AND Instance.countPolicy gte Instance.MIN_ATLEASTPOLICY>
			
				<cfset instance.passwordStrength = "STRONG">
				<cfset instance.isPasswordValid = TRUE>
				
				<cfset instance.status = "<img height='23' src='#session.root#/images/check_mark.gif'>">
								
		<cfelse>
				<cfset instance.passwordStrength = "WEAK">
				<cfset instance.isPasswordValid = FALSE>
				
				<cfset instance.status = "<img height='23' src='#session.root#/images/error.gif'>">
				
				<cfif instance.passwordLength lt instance.MIN_PASSWORD_LENGTH>
					<cfset instance.errorMessages = instance.errorMessages & "
						<li>
							Please check that the password is at least 
							#instance.MIN_PASSWORD_LENGTH# characters in length.
						</li>">					
					
				</cfif>		

				<cfif Instance.countPolicy lt Instance.MIN_ATLEASTPOLICY>
					<cfset instance.errorMessages = instance.errorMessages & "
						<li>
							Please check that the password has at least #Instance.MIN_ATLEASTPOLICY# of the following:  
							1 digit, 
							1 lower case letter, 
							1 upper case letter,
							1 special character.
						</li>">					
					
				</cfif>		
		</cfif>
		
		<!--- No Spaces --->
		<cfif (find(" ", instance.password))> 
			
			<cfset instance.isPasswordValid  = FALSE>
			<cfset instance.passwordStrength = "WEAK">
			
			<cfset instance.errorMessages = instance.errorMessages & "
				<li>
					The password cannot contain a space.
				</li>
			">;
		</cfif>
		
		<!--- No single quotes --->
		
		<cfif (find("'", instance.password))>
			
			<cfset instance.isPasswordValid  = false>
			<cfset instance.passwordStrength = "WEAK">
			
			<cfset instance.errorMessages = instance.errorMessages & "
				<li>
					The password cannot contain a single-quote character 
					[ <em>'</em> ].
				</li>">
		</cfif>
				
		<cfset firstNonLetterCharIndex = reFind("[0-9\W]", instance.password)>
		<cfset lastNonLetterCharIndex  = reFind("[0-9\W]", reverse(instance.password))>
		<cfset charIndex               = reFind("[A-Za-z]",instance.password)>		
		
		<!--- If the password is the same as the user name  ---->
		<cfif(
			(
			 len(trim(instance.userName)) gt 0
			 and
			 findNoCase(instance.userName,  instance.password)
			)
			or
			(
			 len(trim(instance.firstName)) gt 0
			 and
			 findNoCase(instance.firstName, instance.password)
			)
			or
			(
			 len(trim(instance.lastName)) gt 0
			 and
			 findNoCase(instance.lastName,  instance.password)
			)
		   )>
			
			<cfset instance.isPasswordValid  = false>
			<cfset instance.passwordStrength = "WEAK">
			<cfset instance.status = "<img height='23' src='#session.root#/images/error.gif'>">
			<cfset instance.errorMessages = instance.errorMessages & "
				<li>
					The password cannot contain any personally 
					identifying information already associated with 
					your account.
				</li>
			">
		</cfif>				
				
		<!--- If the password is the same as any of the previous one ---->
		<cfif Instance.PASSWORDHISTORY eq "1">
		
			<cf_encrypt text = "#Instance.password#">
			<cfset pass      = "#EncryptedText#">
			
			<cfquery name="GetCheckPwd" datasource="AppsSystem">
				SELECT account FROM UserPasswordLog
				WHERE account = '#Instance.userName#'
				AND (Password = '#pass#' OR Password = '#Instance.password#')
				AND PasswordExpiration >= DATEADD(MONTH, -2, GETDATE())
				UNION
				SELECT account 
				FROM UserNames
				WHERE account = '#Instance.userName#'
				AND (Password = '#pass#' OR Password = '#Instance.password#')
				AND PasswordModified >= DATEADD(MONTH, -2, GETDATE())
			</cfquery>
			
			
			<cfif GetCheckPwd.recordcount neq 0>
				<cfset instance.isPasswordValid  = false>
				<cfset instance.passwordStrength = "WEAK">
				<cfset instance.status = "<img height='23' src='#session.root#/images/error.gif'>">
				<cfset instance.errorMessages = instance.errorMessages & "
					<li>
						The password cannot be any of the previous ones you have used.
					</li>
				">
			</cfif>				
		
		</cfif>	
				
		
	</cffunction>	
	
	<cffunction name="generateRandomPassword" access="public" returntype="string">
 	 	
		<cfquery name="Parameter" 
		datasource="AppsSystem">
			SELECT   TOP 1 *
			FROM     Parameter
		</cfquery>
		
		<cfif Parameter.PasswordLength lt 1 >
			<cfset passwordLength = 8>
		<cfelse>
			<cfset passwordLength = Parameter.PasswordLength>
		</cfif>
		
		<cfset symbols = "!@$+/">
		<cfset newPassword = "">
		
		<!---- Reference:
			digit: #Chr(RandRange(48,57))#<br>
			lower: #Chr(RandRange(97,122))#<br>
			upper: #Chr(RandRange(65,90))#<br>
			symbols: #Mid(specialSymbols,RandRange(1,len(symbols)),1)#
		--->
		
		<cfif Parameter.PasswordMode eq "Strong" or Parameter.PasswordMode eq "Intermediate">
		
			<!--- Enforce password to comply with Medium passwords: 3 out of 4: upper, lower, digit --->
			<cfset newPassword = Chr(RandRange(65,90)) & Chr(RandRange(97,122)) & Chr(RandRange(48,57))>
			
			<!--- If it is Strong mode, add a symbol to enforce 4 out of 4 criteria --->
			<cfif Parameter.PasswordMode eq "Strong">
				<cfset newPassword = newPassword & Mid(symbols,RandRange(1,len(symbols)),1)>
			</cfif>
			
			<cfset from = len(newPassword)+1>
			
			<cfloop index="i" from="#from#" to="#passwordLength#" step="1">
				<!--- build a random word that has the for chars (upper, lower, digit, symbol) --->
				<cfset randomWord =  Chr(RandRange(65,90)) & Chr(RandRange(97,122)) & Chr(RandRange(65,90)) & Mid(symbols,RandRange(1,len(symbols)),1)>
				<!--- take one random char of the random word --->
				<cfset randomChar = Mid(randomWord,RandRange(1,len(randomWord)),1)>
				<cfset newPassword = newPassword & randomChar>	
			</cfloop>
			
			<!--- final shuffle --->
			<cfset newPasswordArr = listToArray(newPassword,"")>
			<cfset CreateObject("java", "java.util.Collections").Shuffle(newPasswordArr) />
			<cfset newPassword = ArrayToList(newPasswordArr,"")>
		
		<cfelse> <!--- Basic --->
		
			<!--- Basic mode requires numbers only --->
			<cfloop index="i" from="1" to="#passwordLength#" step="1">
				<cfset newPassword = newPassword & Chr(RandRange(48,57))>
			</cfloop>
		
		</cfif>
		
		<cfreturn newPassword>

	</cffunction>
	
</cfcomponent>