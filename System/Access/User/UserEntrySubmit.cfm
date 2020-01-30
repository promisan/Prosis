
<link rel="stylesheet" type="text/css" href="<cfoutput>#SESSION.root#/#client.style#</cfoutput>">

<cf_systemscript>

<cfparam name="form.gender" default="">

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
<cfif Form.AccountType eq "Individual">
	<cfset _match = REMatch("[a-zA-Z][a-zA-Z0-9]*", account)>	
<cfelse>
	<cfset _match = REMatch("[a-zA-Z][a-zA-Z0-9_/]*", account)>		
</cfif> 


<cftry>
	<cfset account_check ="#_match[1]#">
<cfcatch>
	<cfset account_check ="">
</cfcatch>
</cftry>



<cfparam name="Form.AllowMultipleLogon"   default="0">
<cfparam name="Form.DisableTimeOut"       default="0">
<cfparam name="Form.PasswordExpiration"   default="0">
<cfparam name="Form.DisableIPRouting"     default="0">
<cfparam name="Form.DisableFriendlyError" default="0">
<cfparam name="Form.DisableNotification"  default="0">
<cfparam name="Form.MailServerAccount"    default="">
<cfparam name="Form.MailServerDomain"     default="0">

<!--- verify if somehow matching account already exists --->

<cfquery name="Verify" 
datasource="AppsSystem" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT Account 
	FROM   UserNames
	WHERE  1=1
	AND  (
	      (LastName   = '#Form.LastName#' AND FirstName = '#Form.FirstName#')
	        OR Account   = '#account#'
			<cfif Form.AccountType eq "Individual" and Form.IndexNo neq "">
            OR IndexNo   = '#Form.IndexNo#'  
		    </cfif>
	     )
	AND  Disabled = 0

</cfquery>

<!--- verify if PK already exists --->

<cfquery name="Parameter" datasource="AppsSystem">
	SELECT TOP 1 LogonAccountSize
	FROM Parameter
</cfquery>

<cfquery name="CheckPK" 
datasource="AppsSystem" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT Account 
	FROM   UserNames
	WHERE  Account   = '#account#'
</cfquery>

<cf_dialogStaffing>   

<cfif Verify.recordCount gt 0> 
	
	<cfoutput>
	
	 <script>
		
		alert("An account with name #Form.FirstName# #Form.LastName# was already registered.");
		window.close();    
	    var account = "#Verify.account#";		  
			
	     w = 90
	     h = 90
	     if (screen)  {
	     w = screen.width - 60
	     h = screen.height - 130
	     }
	 	 ptoken.open("UserDetail.cfm?ID=" + account + "&ID1=" + h + "&ID2=" + w, "EmployeeDialog", "left=20, top=20, width=" + w + ", height= " + h + ", status=yes, toolbar=no, scrollbars=no, resizable=yes");
		
	</script>	  
	
	</cfoutput>	
	
<cfelseif CheckPK.recordcount gt 0>

	<cfoutput>
	
		 <script language = "JavaScript">
			
			alert("An account code #account# was already registered.");
			window.close();    
		    var account = "#CheckPK.account#";		  
				
		     w = 90
		     h = 90
		     if (screen)  {
		     w = screen.width - 60
		     h = screen.height - 130
		     }
		 	 ptoken.open("UserDetail.cfm?ID=" + account + "&ID1=" + h + "&ID2=" + w, "EmployeeDialog", "left=20, top=20, width=" + w + ", height= " + h + ", status=yes, toolbar=no, scrollbars=no, resizable=yes");
			
		 </script>	  
	
	</cfoutput>	

<cfelseif Len(account) lt Parameter.LogonAccountSize>
		<cfoutput>
		 <script language = "JavaScript">
			alert("The mininum length for accounts is #Parameter.LogonAccountSize#");
		 </script>	  
		</cfoutput>
<cfelseif account neq account_check>	
		<cfoutput>
		 <script language = "JavaScript">
			alert("The account: #account# does not comply with proper user account format");
		 </script>	  
		</cfoutput>	
<cfelse>	

<cfinvoke component = "Service.Authorization.PasswordCheck"  
		  method    = "generateRandomPassword"
	 returnvariable = "newPassword">	

	<cfquery name="InsertUser" 
	datasource="AppsSystem" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	INSERT INTO UserNames
	         (Account,
			 AccountType, 
			 <cfif Form.AccountType eq "Individual">
				 PersonNo, 
				 IndexNo,
				 FirstName,
				 Gender,
				 Password,
				 DisableFriendlyError,
				 PasswordExpiration,
				 AllowMultipleLogon,
				 DisableIPRouting,
				 DisableNotification,
				 DisableTimeOut,
				 MailServerAccount,
				 MailServerDomain,
			 <cfelse>			
				 AccountOwner,
				 Gender,
			 </cfif>
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
			 Disabled)
	  VALUES ('#account#', 
	          '#Form.AccountType#',
			  <cfif Form.AccountType eq "Individual">
		          '#Form.PersonNo#',
				  '#Form.IndexNo#',
				  '#Form.FirstName#',
				  '#Form.Gender#',
				  '#newPassword#',
				  '#Form.DisableFriendlyError#',
                  '#Form.PasswordExpiration#',
                  '#Form.AllowMultipleLogon#',
                  '#Form.DisableIPRouting#',
                  '#Form.DisableNotification#',
                  '#Form.DisableTimeOut#',
				  '#Form.MailServerAccount#',
				  '#Form.MailServerDomain#',
			   <cfelse>
				  '#Form.AccountOwner#',
				  'N/A',
	  		   </cfif>	  
			  '#Form.AccountMission#',
			  '#Form.LastName#',
			  '#Form.AccountGroup#',
			  '#SESSION.acc#',
	    	  '#SESSION.last#',		  
		  	  '#SESSION.first#',
			  '#Remarks#',
			  'Manual',
		      '#Form.eMailAddress#',
			  '#Form.eMailAddressExternal#',
			  '0')</cfquery>
		  
   <cfoutput>
   
<!--- insert group membership --->

<cfif Form.AccountType eq "Individual">

	<cfset URL.acc = "#Account#">
	<cfset URL.mode = "new">
	<cfinclude template="../Membership/UserMemberSubmit.cfm">   

</cfif>
   
   <!--- ----------------------- --->
   <!--- send email notification --->
   
   <cfif Form.eMailAddress neq "" and Form.DisableNotification eq "0">

	<cf_MailUserAccountCreation 
	     account="#account#" password="#newPassword#">
		 
   </cfif>		 

   <!--- ----------------------- --->
    
   <cfset root = "#SESSION.root#">

    <script>
	    
		<!--- try { opener.location.reload(); } catch(e) { } --->
		try {parent.opener.todays()} catch(e) {parent.opener.history.go()}		
		parent.window.close();
	
	</script>	 	
	
    </cfoutput>	  
	
</cfif>	
