<cfparam name="url.account" default="">

<cfoutput>
	
	<cfif URL.account neq "">
					  
		<cfquery name="qUser" 
		datasource="AppsSystem" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT *
		FROM UserNames 
		WHERE Account = '#url.account#'
		</cfquery>
		
		<input type="text" class="regularxl" name="lookup" size="40" maxlength="40" value="#qUser.FirstName# #qUser.LastName#">
		
	<cfelse>
	  
	  	<input type="text" class="regularxl" name="lookup" value=""  size="40" maxlength="40" readonly >											  
	  
	</cfif>
	
	
	<input type="hidden" name="lastname" id="lastname">
	<input type="hidden" name="firstname" id="firstname">
	<input type="hidden" name="userid" id="userid" value="#url.account#" >


</cfoutput>