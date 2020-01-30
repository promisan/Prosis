
 <cfquery name="System" 
	 datasource="AppsSystem"
	 username="#SESSION.login#" 
	 password="#SESSION.dbpw#">
	 SELECT   *
	 FROM     Parameter	
 </cfquery>  

<cfquery name="User" 
	 datasource="AppsSystem"
	 username="#SESSION.login#" 
	 password="#SESSION.dbpw#">
	 SELECT   *
	 FROM     UserNames
	 WHERE    Account = '#SESSION.acc#'
</cfquery>			 

<cfif System.ExchangeServer neq "" and User.MailServerAccount neq "">	 

	<cfexchangeconnection action="OPEN"
	          connection  = "ConExch"
	          server      = "#System.ExchangeServer#"
	          username    = "#User.Account#"
		      mailboxname = "#User.MailServerAccount#"
	          password    = "#User.MailServerPassword#"
	          protocol    = "http">

		<cfexchangecontact action="get"
	          connection  = "ConExch"
			  name        = "Contact">
			  
			  <table width="100%" cellspacing="0" cellpadding="0" class="formpadding"><tr><td>
			 			  
			<cfoutput query="contact">
			
			<cfif LastName neq "">
			
				<cfset mail = replaceNoCase(eMail1,'"','','ALL')>
				<tr>
					<td width="30" align="center"><img src="#SESSION.root#/Images/mailing_personal.gif"
				     alt="contact"
				     border="0"
					 style="cursor: pointer;"
				     onClick="noteentry('#url.objectid#','','','mail','#mail#','regular','notecontainerdetail')">
					</td>
					
					<td>
					 <a href="javascript:noteentry('#url.objectid#','','','mail','#mail#','regular','notecontainerdetail')">#displayas#</a>
				     </td>
					
				</tr>
			
			</cfif>
			
			</cfoutput>
			</table>	
			
		<cfexchangeconnection action="close" connection="ConExch">	

<cfelse>
	 
		<cfquery name="Contact" 
			datasource="AppsOrganization"
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			SELECT distinct MailTo as ContactName
			FROM    OrganizationObjectActionMail
			WHERE   ObjectId = '#URL.ObjectId#'
			AND  MailTo > ''
			UNION
			SELECT distinct MailCc as ContactName
			FROM    OrganizationObjectActionMail
			WHERE   ObjectId = '#URL.ObjectId#'
			AND  MailCC > ''
			ORDER BY ContactName
		</cfquery>	
		
		<table width="100%" cellspacing="0" cellpadding="0" class="formpadding"><tr><td>
		<cfoutput query="contact">
		
		<cfset nme = replace(contactname,"'","","ALL")>
				
		<tr>
			<td width="30" align="center">
			  <img src="#SESSION.root#/Images/mailing_personal.gif"
		    	 alt="contact"
			     border="0"
				 style="cursor:pionter"
			     onClick="noteentry('#url.objectid#','','','mail','#nme#','regular','notecontainerdetail')">
			 
			</td>			
			<td>
			 <a href="javascript:noteentry('#url.objectid#','','','mail','#nme#','regular','notecontainerdetail')">#nme#</a>
		     </td>
			
		</tr>
		
		</cfoutput>
		</table>	

</cfif>



