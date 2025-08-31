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
<link rel="stylesheet" type="text/css" href="<cfoutput>#SESSION.root#/#client.style#</cfoutput>">

<cfparam name="URL.Role" default="">
<cfparam name="URL.Mission" default="">

<cf_assignid>

<!--- insert header --->
<cfquery name="Role" 
   datasource="AppsOrganization" 
   username="#SESSION.login#" 
   password="#SESSION.dbpw#">
	    SELECT  *
		FROM    Ref_AuthorizationRole
		WHERE   Role = '#URL.Role#'     
</cfquery>

<cfquery name="Broadcast" 
   datasource="AppsSystem" 
   username="#SESSION.login#" 
   password="#SESSION.dbpw#">
	  INSERT INTO Broadcast
	  (BroadcastId,
	   BroadcastClass,
	   BroadCastReference, 	   
	   BroadCastRecipient,
	   BroadcastFrom,
	   BroadcastReplyTo,
	   BroadcastPriority,
	   BroadcastFailTo,
	   BroadCastMailerId,
	   OfficerUserId,
	   OfficerLastName,
	   OfficerFirstName)
	  VALUES (
	  '#rowguid#',
	  'Mail', 
	  '#Role.Description#',
	  'User',
	  '#client.eMail#',
	  '#client.eMail#',
	  '3',
	  '#client.eMail#',
	  '#SESSION.acc#',
	  '#SESSION.acc#',
	  '#SESSION.last#',
	  '#SESSION.first#')
</cfquery>

<cfquery name="Recipient" 
   datasource="AppsSystem" 
   username="#SESSION.login#" 
   password="#SESSION.dbpw#">
   INSERT INTO BroadcastRecipient
        (BroadcastId, 
		RecipientCode, 
		eMailAddress, 
		RecipientName,
		RecipientLastName,
		RecipientFirstName)
   SELECT  DISTINCT '#rowguid#', Account, eMailAddress, FirstName+' '+LastName, LastName, FirstName
   FROM    UserNames
   WHERE   (Account IN
               (SELECT     UserAccount
                FROM          Organization.dbo.OrganizationAuthorization
				WHERE      Role = '#URL.Role#'
				<cfif url.mission neq "">AND Mission = '#URL.Mission#'</cfif>)) 
    AND (eMailAddress <> '')
	AND  FirstName is not NULL
</cfquery>

<cfparam name="url.mid" default="">

<cflocation addtoken="No" url="BroadCastView.cfm?id=#rowguid#&mid=#url.mid#">
