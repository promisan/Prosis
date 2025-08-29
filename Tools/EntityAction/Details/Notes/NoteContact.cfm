<!--
    Copyright © 2025 Promisan B.V.

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



