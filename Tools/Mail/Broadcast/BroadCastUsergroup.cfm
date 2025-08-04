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
<link rel="stylesheet" type="text/css" href="<cfoutput>#SESSION.root#/#client.style#</cfoutput>">

<cfparam name="URL.Group" default="">

<cf_assignid>

<!--- insert header --->
<cfquery name="Group" 
   datasource="AppsSystem" 
   username="#SESSION.login#" 
   password="#SESSION.dbpw#">
	    SELECT  *
		FROM    UserNames
		WHERE   AccountGroup = '#URL.Group#'     
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
	  '#Group.LastName#',
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
               (SELECT     Account
                FROM          UserNamesGroup
				WHERE      AccountGroup = '#URL.Group#'))
    AND (eMailAddress <> '' and LastName <> '' and FirstName <> '')
</cfquery>

<cfset oSecurity = CreateObject("component","Service.Process.System.UserController")/>
<cfset mid = oSecurity.gethash()/>   
<cflocation addtoken="No" url="BroadCastView.cfm?id=#rowguid#&mid=#mid#">
