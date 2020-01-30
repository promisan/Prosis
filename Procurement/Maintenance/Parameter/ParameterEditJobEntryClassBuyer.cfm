<cfparam name="url.serialno" default="0">
<cfparam name="url.account" default="">
<cfparam name="url.entryclass" default="">
<cfparam name="url.defaultbuyer" default="xx">

<cfif url.serialno eq 0>
	<cfset vDefault = "BuyerDefault">
<cfelse>
	<cfset vDefault = "BuyerDefaultBackup">
</cfif>	

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
		
		<input class="regularxl" type="Text" id="#vDefault#_#url.entryClass#" name="#vDefault#_#url.entryClass#" value="#qUser.FirstName# #qUser.LastName# #url.account#" required="No" size="20" maxlength="20">
		<input type="hidden" name="name#url.serialno#_#url.entryclass#" 		id="name#url.serialno#_#url.entryclass#" value="#url.account#" >
			
	<cfelse>

		<cfquery name="qUser" 
		datasource="AppsSystem" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT *
		FROM UserNames 
		WHERE Account = '#url.defaultbuyer#'
		</cfquery>
	
	
	  	<input class="regularxl" type="Text" id="#vDefault#_#url.entryClass#" name="#vDefault#_#url.entryClass#" value="#qUser.FirstName# #qUser.LastName# #url.defaultbuyer#" required="No" size="20" maxlength="20">
	
		<input type="hidden" name="name#url.serialno#_#url.entryclass#" 		id="name#url.serialno#_#url.entryclass#" value="#url.defaultbuyer#" >

	  
	</cfif>
	<input type="hidden" name="lastname#url.serialno#_#url.entryclass#" 	id="lastname#url.serialno#_#url.entryclass#">
	<input type="hidden" name="firstname#url.serialno#_#url.entryclass#" 	id="firstname#url.serialno#_#url.entryclass#">
	


</cfoutput>