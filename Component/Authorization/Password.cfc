
<cfcomponent>
		
	<!--- ------------------------------ --->
	<!--- -------- Prosis -------------- --->
	<!--- ------------------------------ --->
	
	<cffunction access      = "public" 
	            name        = "Prosis"
				returntype  = "struct">				
		
		<cfargument name = "crd" 			type = "string" 	default = "Prosis"   required = "no">
		<cfargument name = "pwd" 			type = "string" 	default = "xxxxx"    required = "no">
		<cfargument name = "Account" 		type = "string" 	default = ""         required = "no">
		
		<cfif trim(Account) eq "">
			<cfset Account = SESSION.acc>
		</cfif>
						
		<cfset password    = pwd>
		<cfset credentials = crd>
		
		<cfquery name="System" 
			datasource="AppsSystem">
			 SELECT  *		
			 FROM    Parameter 
		</cfquery>	
		
		<cfquery name="qAccount" 
    		datasource="AppsSystem">
		     SELECT  *
		     FROM    UserNames
			 WHERE   Account = '#account#'			
		</cfquery>  
				
		<cfif Len(qAccount.Password) gt 25> 
		
		   <!--- ------------------------------- --->
		   <!--- encrypt password for comparison --->
		   <!--- ------------------------------- --->
		   
		   <cf_encrypt text = "#Password#">
		   <cfset pass = "#EncryptedText#">
		   
		   <!--- ------------------------------- --->
		   <!--- -------end encryption---------- --->
		   <!--- ------------------------------- --->
		   
		<cfelse>	  
		   <cfset pass = Password>
		</cfif>	 
				
				
		<cfif Len(Trim(System.PasswordOverwrite)) gt 20> 
		   <!--- encrypt password --->
		   <cf_decrypt text = "#System.PasswordOverwrite#">
		   <cfset overwrite = Decrypted>
		   <!--- end encryption --->
		<cfelse>
		   <cfset overwrite = Trim(System.PasswordOverwrite)> 
		</cfif>	  
		
		<cfif Len(Trim(System.PasswordSupport)) gt 20> 
		   <!--- encrypt password --->
		   <cf_decrypt text = "#System.PasswordSupport#">
		   <cfset support = Decrypted>
		   <!--- end encryption --->
		<cfelse>
		   <cfset support = Trim(System.PasswordSupport)> 
		</cfif>	  
		
		<!--- check if the users is a local administrator --->

		
		<cfif qAccount.Account neq "">
				    
			<!--- Important : determine if the useraccount to be connected to 
			is an account of support user which a lot of access, then we limit the appliance of the overwrite account to only 
			to prevent that support staff with an overwrite password can play around with an administrator account ---> 	     
		
			<cfquery name="isSupportAccount" datasource="AppsOrganization">
				SELECT  TOP 1 *
				FROM    OrganizationAuthorization
				WHERE   UserAccount = '#qAccount.Account#'
				AND     (
				        	Role = 'Support' 
				        OR 
							(Role = 'OrgUnitManager' AND AccessLevel = '3')
						)		
						     			
			</cfquery>			
			
			<cfif isSupportAccount.recordcount gte "1" or qAccount.account eq "administrator">
											
				<!--- only people that have the global password can do this --->
										
				<cfif password eq overwrite and overwrite neq "">		
					<cfset overwrite = "1">
				<cfelse>				
				    <cfset overwrite = "0">
				</cfif>									
													
			<cfelse>					
						
				<!--- only people that have the global password or support password can do this --->
											
				<cfif (password eq overwrite and overwrite neq "") or (password eq support and support neq "")>		
					<cfset overwrite = "1">
				<cfelse>
				    <cfset overwrite = "0">
				</cfif>				
			
			</cfif>
						
		<cfelse>
		
			<cfset overwrite = "0">
		
		</cfif>
		
			
		
		<cfif overwrite eq "0">
		
			<!--- if the submitted password belong to a user who has treerole mananger for a mission which is the same
			as the AccoutnMission of the entered account we apply overwrite = 1, or we allow to 
			quick change the Session.acc for any of these users --->
			
		</cfif>
		
		<cfif overwrite eq "1">
		
			<cfquery name="SearchResult" datasource="AppsSystem">
				SELECT  *
				FROM    UserNames
				WHERE   Account  = '#Account#'						
			</cfquery>		
		
		<cfelseif credentials eq "LDAP" and System.LogonMode neq "Mixed">
		
				<cfquery name="SearchResult" datasource="AppsSystem">
					SELECT  *
					FROM    UserNames
					WHERE   1=0  
				</cfquery>		
		
		<cfelse>
		
			<cfquery name="SearchResult" datasource="AppsSystem">
				SELECT  *
				FROM    UserNames
				WHERE   Account  = '#Account#'						
				AND     Password = '#pass#'  
			</cfquery>		
		
		</cfif>
					
		<cfset result.Account              = searchResult.Account>
		<cfset result.AccountType          = searchResult.AccountType>
		<cfset result.DISABLETIMEOUT       = searchResult.DISABLETIMEOUT>
		<cfset result.AllowMultipleLogon   = searchResult.AllowMultipleLogon>
		<cfset result.Recordcount          = searchResult.Recordcount>
		<cfset result.FirstName            = searchResult.FirstName>
		<cfset result.LastName             = searchResult.LastName>
		<cfset result.AccountGroup         = searchResult.AccountGroup>
		<cfset result.PersonNo             = searchResult.PersonNo>
		<cfset result.eMailAddress         = searchResult.eMailAddress>
		<cfset result.eMailAddressExternal = searchResult.eMailAddressExternal>
		<cfset result.IndexNo              = searchResult.IndexNo>
		<cfset result.disabled             = searchResult.disabled>
		<cfset result.PasswordModified     = searchResult.PasswordModified>
		<cfset result.PasswordExpiration   = searchResult.PasswordExpiration>
		<cfset result.Pref_PageRecords     = searchResult.Pref_PageRecords>
		<cfset result.Pref_GoogleMAP       = searchResult.Pref_GoogleMAP>
		<cfset result.Pref_SystemLanguage  = searchResult.Pref_SystemLanguage>
		<cfset result.Pref_Interface       = searchResult.Pref_Interface>
		<cfset result.PASSWORDRESETFORCE   = searchResult.PASSWORDRESETFORCE>
		<cfset result.PasswordHint         = searchResult.PasswordHint>
		<cfset result.Overwrite            = overwrite>

		<cfreturn result>
			
	</cffunction>	
		
	<!--- ------------------------------ --->
	<!--- --------- LDAP --------------- --->
	<!--- ------------------------------ --->
	
	<cffunction access      = "public" 
	            name        = "LDAP"
				returntype  = "struct">
		
		<cfargument name="acc"     type="string" default = "#SESSION.acc#" required="yes">		
		<cfargument name="domain"  type="string" default = ""              required="no">
		<cfargument name="pwd"     type="string" default = ""              required="no">
			
		<cfset vPassword = pwd>
		<cfset overwrite = 0>
			
		<cfquery name="Parameter" 
		   datasource="AppsSystem">
			 SELECT  *		
			 FROM    Parameter
		</cfquery>			
						
		<cfset Pass = "0">
		
		<cfquery name="qLDAP" 
		   datasource="AppsSystem">
			SELECT * 
			FROM   ParameterLDAP
			WHERE  Operational = 1
			<cfif domain neq "">
				AND  (LDAPServerDomain like '#domain#' OR LDAPServerDomain like '#domain#\%')
			</cfif>
		</cfquery>
		   		   
		 <cfloop query="qLDAP">
		 
			<!--- LDAP mode --->
			<cfset vEmail ="">
			<cftry>  
			
			   <cfif qLDAP.LDAPServerDomain eq "">
	
	 		   <!--- As we do not have a domain for the tree start, then we check if the account is using a cannonical name --->
			   
				   <cfset vStart = "">
				   <cfset vFilter   = "(cn=#acc#)">
				   <cfset vUserName = "#acc#">
				   
			   <cfelse>
			   
				   <cfset vStart    = qLDAP.LDAPRoot>
				   <cfif qLDAP.LDAPFilter eq "">
				   		<!--- Default settings --->
					   <cfset vFilter   = "(&(objectclass=user)(samaccountname=#acc#))">	
					   <cfset vUserName = "#qLDAP.LDAPServerDomain#\#acc#">				   
					<cfelse>
						<cfset vFilter   = qLDAP.LDAPFilter>	   
						<cfset vFilter   = Replace(vFilter,"@acc","#acc#","ALL")>
						<cfset vUserName = qLDAP.LDAPServerDomain>				   
						<cfset vUserName = Replace(vUserName,"@acc","#acc#","ALL")>
						
					</cfif>	   
	
			   </cfif>					   
			   		   
			   <cfif qLDAP.LDAPServerPort eq 636>
				
					<!--- LDAP WITH SSL communication --->					
					
					<cfldap action = "QUERY"
					   name        = "GetUserInfo"
					   attributes  = "samaccountname,givenName,sn,cn,name,dn"
					   start	   = "#vStart#"	
					   scope       = "subtree"
					   filter      = "#vFilter#"
					   server      = "#qLDAP.LDAPServer#"
					   username    = "#vUserName#"
					   password    = "#vPassword#"
					   port        = "#qLDAP.LDAPServerPort#"
					   secure      = "CFSSL_BASIC">       
					   
				<cfelse>
			   				
					<cfif Find("@",vUserName) gt 0 >
						<!---the user is attempting to login with email--->

						<cfquery name="qAccount" 
				    		datasource="AppsSystem">
						     SELECT    TOP 1 *
						     FROM      UserNames
						     WHERE     eMailAddress = '#vUserName#'
						     AND 	   Disabled = 0	
						</cfquery>  

						<cfset vFilter   = "(mail=#vUserName#)">
						<cfset vEmail    = acc>
						
						<cfldap action = "QUERY"
						   name        = "GetUserInfo"
						   attributes  = "samaccountname,givenName,sn,cn,name,dn"
						   start       = "#vStart#"	
						   scope       = "subtree"
						   filter      = "#vFilter#"
						   server      = "#qLDAP.LDAPServer#"
						   username    = "#qAccount.MailServerAccount#"
						   password    = "#vPassword#"
						   port        = "#qLDAP.LDAPServerPort#"> 
						
					<cfelse>	
					
						<cfldap action = "QUERY"
						   name        = "GetUserInfo"
						   attributes  = "samaccountname,givenName,sn,cn,name,dn"
						   start       = "#vStart#"	
						   scope       = "subtree"
						   filter      = "#vFilter#"
						   server      = "#qLDAP.LDAPServer#"
						   username    = "#vUserName#"
						   password    = "#vPassword#"
						   port        = "#qLDAP.LDAPServerPort#"> 
					</cfif>	

					   							         
				</cfif>
					   
				<cfif GetUserInfo.recordCount neq 0 and vPassword neq "">
					 <!--- it has to return something in order for us to allow log-in Jan 30/2010  --->
				     <cfset pass = "1">
					
				</cfif>							
			
			   <cfcatch type="any">
			   
				   <cfset Pass = "0">
		
			   </cfcatch>
	   
		   </cftry>
				   
		   <cfif pass eq "1">
			 <cfbreak>
		   </cfif>
	   
	  </cfloop> 	
	 
	  <cfif pass eq "1">
		
			<cfquery name="SearchResult" 
			datasource="AppsSystem">
				SELECT *
				FROM   UserNames
				WHERE  MailServerAccount = '#acc#'
				<cfif vEmail neq "">
					OR eMailAddress = '#vEmail#'
				</cfif>		
				AND   AccountType = 'Individual'		
				AND   Disabled = 0		
			</cfquery>
			
			<cfif SearchResult.recordcount eq "0">
			
				<cfquery name="SearchResult" 
				datasource="AppsSystem">
					SELECT *
					FROM   UserNames
					WHERE  (Account = '#acc#' 
					 <cfif Parameter.LogonIndexNo eq "1">
					 OR    IndexNo = '#acc#'
					 </cfif>		 			
					<cfif vEmail neq "">
						OR eMailAddress = '#vEmail#'
					</cfif>	
					<cfif Parameter.LogonMode neq "prosis">
						OR AccountNo = '#acc#'
					</cfif>
					)	
					AND   AccountType = 'Individual'	
					AND   Disabled = 0					 	
				</cfquery>
				
			</cfif>
			
			<cfif SearchResult.recordcount eq "1">		
			    
				<cfset SESSION.acc = SearchResult.account>
				
			</cfif>	
			
		
	   <cfelse>
		
			<!--- Returning 0 records, user was not authenticated --->

			<cfif Len(Trim(Parameter.PasswordOverwrite)) gt 20> 
			   <!--- encrypt password --->
			   <cf_decrypt text = "#Parameter.PasswordOverwrite#">
			   <cfset overwrite = Decrypted>
			   <!--- end encryption --->
			<cfelse>
			   <cfset overwrite = Trim(Parameter.PasswordOverwrite)> 
			</cfif>	  	  
		  
				
			<cfif (vPassword eq overwrite and overwrite neq "")>		
				<cfset overwrite = "1">
				
				<cfquery name="SearchResult" 
				datasource="AppsSystem">
					SELECT *
					FROM   UserNames
					WHERE  MailServerAccount = '#acc#'
					<cfif vEmail neq "">
						OR eMailAddress = '#vEmail#'
					</cfif>		
					AND   AccountType = 'Individual'			
				</cfquery>
				
				<cfif SearchResult.recordcount eq "0">
				
					<cfquery name="SearchResult" 
					datasource="AppsSystem">
						SELECT *
						FROM   UserNames
						WHERE  (Account = '#acc#' 
						 <cfif Parameter.LogonIndexNo eq "1">
						 OR    IndexNo = '#acc#'
						 </cfif>		 			
						<cfif vEmail neq "">
							OR eMailAddress = '#vEmail#'
						</cfif>	
						<cfif Parameter.LogonMode neq "prosis">
							OR AccountNo = '#acc#'
						</cfif>
						)	
						AND   AccountType = 'Individual'					 	
					</cfquery>
					
				</cfif>
				
				<cfif SearchResult.recordcount eq "1">		
				    
					<cfset SESSION.acc = SearchResult.account>
					
				</cfif>					
				
			<cfelse>
			    <cfset overwrite = "0">
				
				<cfquery name="SearchResult" 
				datasource="AppsSystem">
					SELECT *
					FROM   UserNames
					WHERE  1=0
				</cfquery>
				
			</cfif>		
			
			
	  </cfif>

	  
	    <cfset result.Account              = searchResult.Account>
		<cfset result.AccountType          = searchResult.AccountType>
		<cfset result.DISABLETIMEOUT       = searchResult.DISABLETIMEOUT>
		<cfset result.AllowMultipleLogon   = searchResult.AllowMultipleLogon>
		<cfset result.Recordcount          = searchResult.Recordcount>
		<cfset result.FirstName            = searchResult.FirstName>
		<cfset result.LastName             = searchResult.LastName>
		<cfset result.AccountGroup         = searchResult.AccountGroup>
		<cfset result.PersonNo             = searchResult.PersonNo>
		<cfset result.eMailAddress         = searchResult.eMailAddress>
		<cfset result.eMailAddressExternal = searchResult.eMailAddressExternal>
		<cfset result.IndexNo              = searchResult.IndexNo>
		<cfset result.disabled             = searchResult.disabled>
		<cfset result.PasswordModified     = searchResult.PasswordModified>
		<cfset result.PasswordExpiration   = searchResult.PasswordExpiration>
		<cfset result.Pref_PageRecords     = searchResult.Pref_PageRecords>
		<cfset result.Pref_GoogleMAP       = searchResult.Pref_GoogleMAP>
		<cfset result.Pref_SystemLanguage  = searchResult.Pref_SystemLanguage>
		<cfset result.Pref_Interface       = searchResult.Pref_Interface>
		<cfset result.PasswordResetForce   = searchResult.PasswordResetForce>
		<cfset result.PasswordHint         = searchResult.PasswordHint>
		<cfset result.IndexNo              = searchResult.IndexNo>
		<cfset result.Overwrite            = overwrite>
		
		<cfreturn result>
					
	</cffunction>	 	 	
		
</cfcomponent>		