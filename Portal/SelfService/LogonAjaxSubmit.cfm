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
<!--- July 09, 2012:  This is to return a value instead of automatically redirect to pages, or show cf_message tags. --->
<cfparam name="url.returnValue"		default = "0">
<cfparam name="url.printResult"		default = "0">
<cfparam name="url.id"				default = "">
<cfparam name="url.mission"			default = "">
<cfparam name="form.account"		default = "">
<cfparam name="form.password"		default = "">

<cfset prosisLoginResult = 0> 

<!--- 
	this template returns prosisLoginResult with the values:
		0 = not logged by default, 
		1 = valid login,
		100 = password expired, 
		101 = group not allowed, 
		102 = not identified, 
		103 = reseted password
		200 = no anonymous account, 
		201 = invalid account, 
		202 = out of service
		203 = PHP not supported
		204 = Account has not been associated to the employee profile
		205 = You do not have access to this portal function
		206 = Blocked as it has exceed the system parameter of wrong tries
	 --->

<cfoutput>


<cfparam name="url.mode" default="0">
<cfparam name="form.enforcepassword" default="0">
<cfparam name="form.enforcePersonNo" default="0">
<cfparam name="client.veffects"      default="">

<cfset SESSION.acc            = Form.Account>
<!--- Added by dev on 2/25/2015 ---->
<cfset CLIENT.logon           = Form.Account>

<cfset CLIENT.logonCredential = Form.Account>

<cfparam name="client.wrong" default="0">

<cfinclude template="LogonClient.cfm">

<cfquery name="System" 
datasource="AppsSystem">
	SELECT * 
	FROM   Parameter
</cfquery>


<cfif System.LogonMode eq "Prosis">
    <cfset SESSION.acc = Replace(SESSION.acc, " ", "", "ALL")>
<cfelse>
    <cfset SESSION.acc = Rtrim(LTrim(SESSION.acc))>
</cfif>

<cfquery name="Account" 
datasource="AppsSystem">
	SELECT   TOP 1 *
	FROM     UserNames
	WHERE    (MailServerAccount = '#SESSION.acc#'  OR  AccountNo = '#SESSION.acc#')
			 OR
			 (eMailAddress  = '#SESSION.acc#' AND AccountType = 'Individual')
	ORDER BY Disabled
</cfquery>

<cfif Account.recordcount neq "1">
	
	<cfquery name="Account" 
	datasource="AppsSystem">
		SELECT   TOP 1 *
		FROM     UserNames
		WHERE    Account = '#SESSION.acc#'
		AND      AccountType = 'Individual'		  
		ORDER BY Disabled
	</cfquery>

</cfif>

<cfif Account.recordcount neq "1">

     <!--- EXTEND PROSIS CREDENTIALS --->
   
	   <cfquery name="Account" 
	    datasource="AppsSystem">
	     SELECT *
	     FROM   UserNames
	     WHERE (
		 
		 Account = '#SESSION.acc#' 
		 
		 <cfif System.LogonIndexNo eq "1">
		 
		 	   <cfif findNoCase("@",SESSION.acc)>
		 
			   OR eMailAddress = '#SESSION.acc#'
			   
			   <cfelse>
			   
			   OR IndexNo      = '#SESSION.acc#'
			   			   
			   </cfif>
			   		 				 
		 </cfif>
		 
		 ) 
		 
		 <cfif System.UserGroupLogon eq "1">
		 AND  AccountType = 'Individual'
		 </cfif>
		 
	   </cfquery>  

</cfif>


<!--- account found --->

<cfif account.recordcount eq "1">
	
	<!--- check password in prosis mode --->

	<cfif SESSION.LogonMode eq "Prosis">

		<cfset SESSION.acc = Account.account>	    
		<cfinvoke component = "Service.Authorization.Password"  
		   method           = "Prosis" 
		   pwd              = "#form.password#" 	 
		   returnvariable   = "Exist">				
							
	<cfelseif SESSION.LogonMode eq "LDAP">
	
		<cfset SESSION.acc = Account.MailServerAccount>
		<cfinvoke component = "Service.Authorization.Password"  
			   method           = "LDAP" 
			   domain		    = "#Account.MailServerDomain#"
			   pwd              = "#form.password#" 	 
			   returnvariable   = "Exist">	
			   
	<cfelse>
	
	    <!--- ---------- --->
		<!--- mixed mode --->
		<!--- ---------- --->
	
		<cfif Account.enforceLDAP eq "0">
	
			<cfset SESSION.acc = Account.account>	    
			<cfinvoke component = "Service.Authorization.Password"  
			   method           = "Prosis" 
			   pwd              = "#form.password#" 	 
			   returnvariable   = "Exist">		
			
			<cfif Exist.recordcount eq "0">
			
				<cfset SESSION.acc = Account.MailServerAccount>
				<cfinvoke component = "Service.Authorization.Password"  
				   method           = "LDAP" 
				   domain			= "#Account.MailServerDomain#"
				   pwd              = "#form.password#" 	 
				   returnvariable   = "Exist">		
				   
				   <cfif Exist.recordcount eq "0" and Account.AccountNo neq "">
			
						<cfset SESSION.acc = Account.AccountNo>
						<cfinvoke component = "Service.Authorization.Password"  
						   method           = "LDAP" 
						   pwd              = "#form.password#" 	 
						   returnvariable   = "Exist">				   
				   
					</cfif> 		   
			   
			</cfif> 
			
		<cfelse>
		
			  <cfset SESSION.acc = Account.MailServerAccount>
			  <cfinvoke component = "Service.Authorization.Password"  
				  method           = "LDAP" 
				  domain		   = "#Account.MailServerDomain#"
				  pwd              = "#form.password#" 	 
				  returnvariable   = "Exist">	
			 	
				<cfif Exist.recordcount eq "0" and Account.AccountNo neq "">
		
					<cfset SESSION.acc = Account.AccountNo>
					<cfinvoke component = "Service.Authorization.Password"  
					   method           = "LDAP" 
					   pwd              = "#form.password#" 	 
					   returnvariable   = "Exist">				   
			   
				</cfif> 					
		
		</cfif>	
		
	</cfif>


	<cfif Exist.overwrite eq 1>
		<cfset SESSION.Overwrite = 1> 
	<cfelse>
		<cfset SESSION.Overwrite = 0> 
	</cfif>

	<cfset client.acc = Exist.Account>
		   		
	<cftry>
	
		<cfset acc = Exist.Account>
		
 	    <cfset CLIENT.GoogleMAP = Exist.Pref_GoogleMAP>
			
		<cfif Exist.PersonNo eq "" and Exist.IndexNo neq "">
		
			<!--- maintenance updating the personNo  based on the IndexNo --->
		
			<cfquery name="Person" datasource="AppsEmployee">
				SELECT *
				FROM  Person
				WHERE IndexNo = '#Exist.IndexNo#'
			</cfquery>
			
			<cfif Person.recordcount eq "1">
			
		    	<cfquery name="Update" datasource="AppsSystem">
					UPDATE UserNames
					SET    PersonNo = '#Person.PersonNo#' 
					WHERE  Account = '#acc#' 
				</cfquery>
						
			</cfif>
			
		</cfif>
		
		<cfcatch></cfcatch>
	
	</cftry>	
						
	<cfinclude template="LogonInit.cfm">	
			
	<!--- account was authenticated --->	
				
	<cfif Exist.Disabled eq "99999">
	
		<!--- 9/7/2015 disabled the account disabled check here for portal  --->
	
		<cf_tl id="Account disabled"> /
				
	<cfelseif Exist.recordcount gte "1" and (Form.Password neq "9999" or form.enforcePassword eq "1")>	
			 
		<cfset SESSION.authent = "1">
		<cfset client.wrong   = 0>
		
		<cfif url.returnValue eq "1">
			<cfset prosisLoginResult = 1>
		</cfif>

		<cfinclude template="LogonAttempts.cfm">
		
		<cfif SESSION.authent eq "1">

			<cfquery name="LogAction" 
			 datasource="AppsSystem">
			INSERT INTO UserActionLog
			    (Account, NodeIP,ActionClass, ActionMemo) 
			VALUES (
			     '#SESSION.acc#',
				 '#CGI.Remote_Addr#',
				 'Logon',
				 'Logon successfull:#SESSION.acc#'
				 )
			</cfquery> 
			
		   <cfif System.EnforcePassword eq "1" 
		        and Exist.PasswordResetForce eq "1"
		        and SESSION.LogonMode eq "Prosis" 
				and Exist.overwrite eq "0">
		   		

				<cf_tl id="PwdExpired" var="1">
				<cfset PwdExpired=#lt_text#>
				<script>
					parent.window.location= '#SESSION.root#/System/UserPassword.cfm?id=expire&portalid=#url.id#&mission=#url.mission#';
				</script>
				<cfabort>
				
			</cfif>	


				
			<!--- check if user is an administrator --->
	   
		   <cfset SESSION.isAdministrator = "No">
		   
		   <cfif SESSION.acc eq "Administrator">	    
		     
				  <cfset SESSION.isAdministrator = "Yes">	  		  
				  
		   <cfelse>	  
				      
				<cfquery name="Support" 
					datasource="AppsOrganization" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
					SELECT    UserAccount
					FROM      OrganizationAuthorization
					WHERE     Role        = 'Support'
					AND       UserAccount = '#SESSION.acc#'
				</cfquery>	
				
				<cfif Support.recordcount eq "1">
				
					<cfset SESSION.isAdministrator = "Yes">	
				
				</cfif>
				
			</cfif>	
	
	     	<cf_tl id="Self_Associated" var="1" class="Message">
			<cfset tAssociated = "#Lt_text#">
		
			<cfif client.personNo eq "" and form.enforcePersonNo eq "1">
				
				<cfif url.returnValue eq "0">
					<cfsavecontent variable="errPassword">
						<font color="FF0000">#tAssociated#</font>
					</cfsavecontent>
					<cfinclude template="LogonAjax.cfm">	
					<cfabort>
				</cfif>
				
			</cfif>	
		
			<cfif url.id eq "PHP">
				<cfif url.returnValue eq "0">
					<cfinclude template="basic/LogonPHP.cfm">	
				</cfif>
			</cfif>
						
			<cfquery name="SelfService" 
				datasource="AppsSystem" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				SELECT *
				FROM   Ref_ModuleControl
				WHERE  SystemModule   = 'SelfService'
				AND    FunctionClass  = 'SelfService'
				AND    (MenuClass     = 'Main' or MenuClass = 'Mission')
				AND    FunctionName   = '#URL.ID#'
			</cfquery>
			
			<cfset vFunctionId = "00000000-0000-0000-0000-000000000000">
			<cfif SelfService.recordCount gt 0>
				<cfset vFunctionId = selfservice.systemfunctionid>
			</cfif>
			
			<cfquery name="AccessToPortal" 
				datasource="AppsSystem" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				SELECT *
				FROM   UserModule
				WHERE  Account           = '#SESSION.acc#'
				AND    SystemFunctionId  = '#vFunctionId#'			
			</cfquery>				
		
			<cfif url.returnValue eq "0">
			
				<cfif AccessToPortal.Status eq "9">
				
				    <!--- denied access --->
				
					<script language="JavaScript">	
						 <!--- show detail screen like PHP, service select screen --->
						 ColdFusion.navigate('PortalNoAccess.cfm','detailcontent')	
						 ColdFusion.navigate('#SESSION.root#/Portal/Selfservice/Extended/LogonUser.cfm?webapp=#url.id#&id=#url.id#','user')			
					</script>	 
				
				<cfelse>
						
					<cfquery name="Loff" 
						datasource="AppsSystem" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">
						SELECT *
						FROM   Ref_ModuleControl
						WHERE  SystemModule   = 'SelfService'
						AND    FunctionClass  = '#url.id#'
						AND    FunctionName   = 'Logout' 
						AND    MenuClass      = 'Function'
						ORDER BY MenuOrder
					</cfquery>		
					
					<cfquery name="ToggleHeader" 
						datasource="AppsSystem" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">
						SELECT *
						FROM   Ref_ModuleControl
						WHERE  SystemModule   = 'SelfService'
						AND    FunctionClass  = '#url.id#'
						AND    FunctionName   = 'ToggleHeader' 
						AND    (MenuClass     = 'Function')
						ORDER BY MenuOrder
					</cfquery>			
					
					<script language="JavaScript">	
					 				        
					         <!--- refresh header --->		
							 <cfif FileExists ("#SESSION.rootPATH##Loff.FunctionDirectory##Loff.FunctionPath#") and Loff.Operational eq "1" and Loff.recordcount eq "1">
							 	ColdFusion.navigate('#SESSION.root#/#Loff.FunctionDirectory##Loff.FunctionPath#?webapp=#url.id#&id=#url.id#','user');
							 <cfelse>
							 	ColdFusion.navigate('#SESSION.root#/Portal/Selfservice/Extended/LogonUser.cfm?webapp=#url.id#&id=#url.id#','user');
							 </cfif>
						     
							 <cfif ToggleHeader.Operational eq "1" and SESSION.authent  eq "1">
		
								var myWidth = 0, myHeight = 0;
								if( typeof( window.innerWidth ) == 'number' )
								{
								//Non-IE
								myWidth = window.innerWidth;
								myHeight = window.innerHeight;
								}
								else if( document.documentElement && ( document.documentElement.clientWidth || document.documentElement.clientHeight ) )
								{
								//IE 6+ in 'standards compliant mode'
								myWidth = document.documentElement.clientWidth;
								myHeight = document.documentElement.clientHeight;
								}
								else if( document.body && ( document.body.clientWidth || document.body.clientHeight ) )
								{
								//IE 4 compatible
								myWidth = document.body.clientWidth;
								myHeight = document.body.clientHeight;
								}
								
							 	if (myHeight<=850) 
										{ 
												$('##logo').fadeOut(200);
												$('##itemx').fadeOut(200);
												$('##togglelogo').fadeIn(1500);
												$("##maincontentwrapper").animate( {'top':'50px', 'bottom':'0px'}, {duration: 500});
							  
										 }
								else {
										//alert('do nothing'+myHeight);
									  }					
							 	
							 </cfif>						 
							 
							 <!--- refresh banner --->						
							 se = document.getElementById('logon')
							 if (se) {
							 	ColdFusion.navigate('LogonAjax.cfm','logon')	
							 }													
							 <!--- show detail screen like PHP, service select screen --->
							 ColdFusion.navigate('#url.link#','detailcontent')							
							 
					</script>
					
					
				</cfif>	
			
			</cfif>
		</cfif>		 
	<cfelse>	
	
		<cftry>
	
			<cfquery name="LogAction" 
			 datasource="AppsSystem">
				INSERT INTO UserActionLog
					    (Account, 
						 NodeIP,
						 ActionClass, 
						 ActionMemo) 
				VALUES (
				     '#SESSION.acc#',
					 '#CGI.Remote_Addr#',
					 'Logon',
					 'Denied:#SESSION.acc#'
					 )
			</cfquery> 	
			
			<cfcatch></cfcatch>
		
		</cftry>	
				  
		<cfif url.mode eq "forget">
		
		    <cfif Form.Account eq "">
			
				<cfset errPassword = "Invalid Request">	
	
				<script language="JavaScript">					    
					 ColdFusion.navigate('#SESSION.root#/Portal/Selfservice/ShowError.cfm?link=#url.link#&msg=#errpassword#','dError')					
				</script>		
			
			<cfelse>
								
			<cfset client.wrong = client.wrong+1>			
						
			<!--- ----------------------- --->
			<!--- send email notification --->
			<cf_MailPasswordInfo>	
			<!--- ----------------------- --->
			
			<cfset errPassword = "Your password was sent to your email account">	

			<script language="JavaScript">					    
				 ColdFusion.navigate('#SESSION.root#/Portal/Selfservice/Extended/ShowError.cfm?link=#url.link#&msg=#errpassword#','dError')					
			</script>		
			
			</cfif>
						
		<cfelseif Form.Password eq "9999" and form.enforcePassword eq "0">		
							
			<cfset mode = "logonaccount">
			<cfset client.wrong = client.wrong+1>
			
		   	<cf_tl id="Self_InvalidPwd" var="1" class="Message">
			<cfset tInvalidPwd = "#Lt_text#">
			
			<cfset errPassword = "#tInvalidPwd# #Exist.PasswordHint#">
						
		    <cfset hint = "0">			
			
			<cfif url.returnValue eq "1">
				<cfset prosisLoginResult = 0> 
			<cfelse>
				<script language="JavaScript">					     			    
					 ColdFusion.navigate('#SESSION.root#/Portal/Selfservice/Extended/ShowError.cfm?link=#url.link#&msg=#errpassword#','dError')							
				</script>	
			</cfif>		
			
		<cfelse>	
		
			<cfif Account.enforceLDAP eq "0">		
		             
				<cfset mode = "logonaccount">
				<cfset client.wrong = client.wrong+1>
						
				<cf_tl id="Incorrect credentials" var="1" class="Message">
				<cfset tInvalidPwd = "#Lt_text#">
				
				<cfset errPassword = "#tInvalidPwd# #Exist.PasswordHint#">
				
				<cfset hint = "0">	
										
				<cfif url.returnValue eq "1">
					<cfset prosisLoginResult = 0> 
				<cfelse>												
					<script language="JavaScript">					     	    
						 ColdFusion.navigate('#SESSION.root#/Portal/Selfservice/Extended/ShowError.cfm?link=#url.link#&msg=#errpassword#','dError')							
					</script>	
				</cfif>
			
			<cfelse>
						
					<cfset grantedmode = "Prosis">
																						
					<cfinvoke component = "Service.Authorization.Password"  
					   method           = "Prosis" 
					   acc              = "#SESSION.acc#"
					   pwd              = "#form.password#" 	 
					   returnvariable   = "searchresult">		
					   
					<cfif searchresult.recordcount eq "1">   
					
						<cfset mode = "logonaccount">
						<cfset client.wrong = client.wrong+1>
						
						<cf_tl id="You are required to use your mail address and password to log in" var="1" class="Message">
										
						<cfset tInvalidPwd = "#Lt_text#">
						
						<cfset errPassword = "#tInvalidPwd# #Exist.PasswordHint#">
						
						<cfset hint = "0">	
						
						<cfquery name="LDAP" 
							datasource="AppsSystem"
							username="#SESSION.login#" 
							password="#SESSION.dbpw#">
							SELECT     TOP 1 *
							FROM       ParameterLDAP
							WHERE      Operational = 1
							ORDER BY   ListingOrder 
						</cfquery> 
													  									
						<cfif LDAP.FieldLogon eq "eMailAddress">
						  
						    <cfset client.logoncredential = Account.eMailAddress>								  				
						  
						<cfelse>
						
						    <cfset client.logoncredential = Account.MailServerAccount>	
						
						</cfif>  
												
						<cfif url.returnValue eq "1">
							<cfset prosisLoginResult = 0> 
						<cfelse>												
							<script language="JavaScript">					     	    
								 ColdFusion.navigate('#SESSION.root#/Portal/Selfservice/Extended/ShowError.cfm?link=#url.link#&msg=#errpassword#','dError')							
							</script>	
						</cfif>
					
					<cfelse>
					
						<cfset mode = "logonaccount">
						<cfset client.wrong = client.wrong+1>
								
						<cf_tl id="Incorrect credentials" var="1" class="Message">
						<cfset tInvalidPwd = "#Lt_text#">
						
						<cfset errPassword = "#tInvalidPwd# #Exist.PasswordHint#">
						
						<cfset hint = "0">	
												
						<cfif url.returnValue eq "1">
							<cfset prosisLoginResult = 0> 
						<cfelse>												
							<script language="JavaScript">					     	    
								 ColdFusion.navigate('#SESSION.root#/Portal/Selfservice/Extended/ShowError.cfm?link=#url.link#&msg=#errpassword#','dError')							
							</script>	
						</cfif>
					
					
					</cfif>
					
			
			
			</cfif>

			<cfinclude template="LogonAttempts.cfm">
			
														
		</cfif>
		 
	</cfif>
	
<cfelse>

	<cfset mode = "logonaccount">
		
	<cfset client.wrong = client.wrong+1>

   	<cf_tl id="Incorrect credentials" var="1" class="Message">
	<cfset tAccountNExist = "#Lt_text#">	
	
	<cfset errAccount = "#tAccountNExist#">
	
	<cfif url.returnValue eq "1">
		<cfset prosisLoginResult = 0> 
	<cfelse>
		<script language="JavaScript">					    
			 ColdFusion.navigate('Extended/ShowError.cfm?link=#url.link#&msg=#erraccount#','dError')							
		</script>
	</cfif>
		
</cfif>

</cfoutput>

<!--- returns a value --->
<cfif url.returnValue eq 1>
	<cfset caller.prosisLoginResult = prosisLoginResult>
	<cfif url.printResult eq 1>
		<cfif prosisLoginResult eq 1>
			1
		<cfelse>
			<cf_tl id="Incorrect credentials">
		</cfif>
	</cfif>
</cfif>
