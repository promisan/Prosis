
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
			   
			VALUES
			
				(
				 '#URL.ID4#',
				 'Disabled',
				 '1',
				 '0',				
				 '#SESSION.acc#',
				 '#SESSION.last#',
				 '#SESSION.first#'
				 )
				 
			</cfquery>		
		
		<!--- ----------------------- --->
		<!--- send email notification --->		
			<cf_MailUserAccountEnable 
			     account="#URL.ID4#">		
		<!--- ----------------------- --->
		
		 <button class="button3" type="button"
		        onClick="javascript:setstatus('#URL.ID4#','0')"> 
		    <img align="absmiddle" height="13" width="13"
			    src="#SESSION.root#/Images/light_green1.gif" 
				alt="Click to Deactivate" 
				border="0">
		</button>
		
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
		
		<button class="button3" type="button"
		        onClick="javascript:setstatus('#URL.ID4#','1')">
			   <img align="absmiddle" height="13" width="13"
			      src="#SESSION.root#/Images/light_red1.gif" 
				  alt="Click to Activate user" 
				  border="0">
		</button>
	
	</cfif>	

</cfoutput>
