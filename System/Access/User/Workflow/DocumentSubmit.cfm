
<cfparam name="form.gender" default="M">

<cfif Len(Form.Remarks) gt 100>
   <cfset remarks = Left(Form.Remarks, 100)>
<cfelse>
   <cfset remarks = Form.Remarks> 
</cfif>

<cfset account = Form.Account>
<cfset account = Replace(account, " ", "", 'ALL')>
<cfset account = Replace(account, "'", "", 'ALL')>
<cfset account = Replace(account, "&", "", 'ALL')>
<cfset account = Replace(account, "*", "", 'ALL')>
<cfset account = Replace(account, "$", "", 'ALL')>
<cfset account = Replace(account, "%", "", 'ALL')>
<cfset account = Replace(account, "~", "", 'ALL')>
<cfset account = Replace(account, "-", "", 'ALL')>
<!---
<cfset account = Replace(account, "#", "", 'ALL')>
--->
<cfset account = Replace(account, "@", "", 'ALL')>
<cfset account = Replace(account, "!", "", 'ALL')>
<!---
<cfset account = Replace(account, "_", "", 'ALL')>
--->
<cfset account = Replace(account, "(", "", 'ALL')>
<cfset account = Replace(account, ")", "", 'ALL')>
<cfset account = Replace(account, "+", "", 'ALL')>
<cfset account = Replace(account, "=", "", 'ALL')>
<cfset account = Replace(account, "|", "", 'ALL')>
<cfset account = Replace(account, "{", "", 'ALL')>
<cfset account = Replace(account, "}", "", 'ALL')>
<cfset account = Replace(account, ";", "", 'ALL')>
<cfset account = Replace(account, "?", "", 'ALL')>
<cfset account = Replace(account, "<", "", 'ALL')>
<cfset account = Replace(account, ">", "", 'ALL')>

<!--- following lines added by JM ---->

<cfset account = Replace(account, "�", "", 'ALL')>
<cfset account = Replace(account, "�", "", 'ALL')>
<cfset account = Replace(account, "�", "", 'ALL')>
<cfset account = Replace(account, "�", "", 'ALL')>
<cfset account = Replace(account, "�", "", 'ALL')>
<cfset account = Replace(account, "�", "", 'ALL')>
<cfset account = Replace(account, "�", "", 'ALL')>

<!--- Accepting only proper account match--->
<cfset _match = REMatch("[a-zA-Z][a-zA-Z0-9]*", account)>
<cftry>
	<cfset account_check ="#_match[1]#">
<cfcatch>
	<cfset account_check ="">
</cfcatch>
</cftry>

<!--- verify if PK already exists --->

<cfquery name="Check" 
datasource="AppsSystem" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT Account 
	FROM   UserNames
	WHERE  Account   = '#account#'
</cfquery>

<cfquery name="Parameter" datasource="AppsSystem">
	SELECT TOP 1 LogonAccountSize
	FROM   Parameter
</cfquery>

<cfif Check.recordcount gt 0 and account neq form.detected> 
	
	<!---
	<cfoutput>
	
	 <script>
		
		alert("User account #account# has been already registered.");
					  		
	</script>	  
	<cfabort>
	
	</cfoutput>	
	
	--->
	
<cfelseif account eq form.detected>
	
	<cfquery name="UpdateUser" 
	datasource="AppsSystem" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		UPDATE   UserNames 
		SET      LastName               = '#Form.LastName#',  		 
				 FirstName              = '#Form.FirstName#',
				 IndexNo                = '#Form.IndexNo#',
				 PersonNo               = '#Form.PersonNo#',
				 Gender                 = '#Form.Gender#',		
				 ApplicantNo            = '#Form.ApplicantNo#',
				 AccountMission         = '#Form.AccountMission#',		
				 AccountGroup           = '#Form.AccountGroup#',
				 eMailAddress           = '#Form.eMailAddress#',
				 eMailAddressExternal   = '#Form.eMailAddressExternal#',		
		         Remarks                = '#Form.Remarks#' 
		WHERE    Account = '#account#'
	</cfquery>
	
	<cfquery name="Portals" 
	datasource="AppsSystem" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	INSERT INTO UserModule
	    (Account,SystemFunctionId)	
		SELECT '#account#',SystemFunctionId
		FROM 	Ref_ModuleControl M
	    WHERE 	M.SystemModule  = 'Selfservice'
		AND 	M.FunctionClass = 'Selfservice'
		AND		M.MenuClass in ('Mission','Main')
		AND		M.Operational     = 1	
		AND     M.EnableAnonymous = '1'	
		AND     SystemFunctionId NOT IN (SELECT SystemFunctionId 
		                                 FROM   UserModule 
										 WHERE  Account = '#account#')
	</cfquery>
		
<cfelseif Len(account) lt Parameter.LogonAccountSize>
		<cfoutput>
		 <script language = "JavaScript">
			alert("The mininum length for accounts is #Parameter.LogonAccountSize#");
		 </script>	  
		 <cfabort>
		</cfoutput>
<cfelseif account neq account_check>	
		<cfoutput>
		 <script language = "JavaScript">
			alert("The account: #account# does not comply with proper user account format");
		 </script>	
		 <cfabort>  
		</cfoutput>	
<cfelse>	
	
	<cfquery name="InsertUser" 
		datasource="AppsSystem" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			INSERT INTO UserNames
			         (Account,
					 AccountType, 
					 PersonNo, 
					 IndexNo,
					 ApplicantNo,
					 FirstName,
					 Gender,			
					 AccountMission, 
					 LastName,
					 AccountGroup,
					 OfficerUserId,
					 OfficerLastName,
					 OfficerFirstName,	
					 Remarks,	
					 Source,
					 eMailAddress,
					 eMailAddressExternal,			
					 Disabled,
					 PasswordResetForce)
			  VALUES ('#account#', 
			          '#Form.AccountType#',
					  '#Form.PersonNo#',
					  '#Form.IndexNo#',
					  '#Form.ApplicantNo#',
					  '#Form.FirstName#',
					  '#Form.Gender#',			
					  '#Form.AccountMission#',
					  '#Form.LastName#',
					  '#Form.AccountGroup#',
					  '#SESSION.acc#',
			    	  '#SESSION.last#',		  
				  	  '#SESSION.first#',
					  '#Remarks#',
					  'PHP',
				      '#Form.eMailAddress#',
					  '#Form.eMailAddressExternal#',
				  	  '0',
					  '1')
	</cfquery>
	
	<cfquery name="Portals" 
	datasource="AppsSystem" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	INSERT INTO UserModule
	    (Account,SystemFunctionId)	
		SELECT '#account#',SystemFunctionId
		FROM 	Ref_ModuleControl M
	    WHERE 	M.SystemModule  = 'Selfservice'
		AND 	M.FunctionClass = 'Selfservice'
		AND		M.MenuClass in ('Mission','Main')
		AND		M.Operational     = 1	
		AND     M.EnableAnonymous = '1'	
		AND     SystemFunctionId NOT IN (SELECT SystemFunctionId 
		                                 FROM   UserModule 
										 WHERE  Account = '#account#')
	</cfquery>
			   
	<!--- insert group membership --->
	
	<cfset URL.acc  =  Account>
	<cfset URL.mode = "new">
	<cfinclude template="../../Membership/UserMemberSubmit.cfm">   
				

</cfif>
   
<!--- 
   <!--- send email notification --->
   
   <cfif Form.eMailAddress neq "">

	<cf_MailUserAccountCreation 
	     account="#account#">
		 
   </cfif>		 
  
   <!--- ----------------------- --->
   
---> 

