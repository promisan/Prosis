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

<cfparam name="session.broadcastcontractid" default="">

<cfquery name="list" 
   datasource="AppsSystem" 
   username="#SESSION.login#" 
   password="#SESSION.dbpw#">
	SELECT    C.Mission, C.Period, C.OrgUnitName, P.IndexNo, P.LastName, P.FirstName, P.EMailAddress
	FROM      ePas.dbo.Contract AS C INNER JOIN Employee.dbo.Person AS P ON C.PersonNo = P.PersonNo
    WHERE     P.EMailAddress IS NOT NULL 
	AND       P.EMailAddress > ''
	<cfif session.broadcastcontractid neq "">
    AND       ContractId IN (#preservesingleQuotes(session.broadcastcontractid)#)
	<cfelse>
	AND  1=0
	</cfif>
</cfquery>

<cfif list.recordcount eq "0">

	<table><tr><td class="labelmedium"><cf_tl id="No record found"></td></tr></table>

<cfelse>
	
	<cf_assignid>
	
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
			  '#list.mission#-#list.period#',
			  'EPas',
			  '#client.eMail#',
			  '#client.eMail#',
			  '3',
			  '#client.eMail#',
			  '#SESSION.acc#',
			  '#SESSION.acc#',
			  '#SESSION.last#',
			  '#SESSION.first#')
	</cfquery>
	
	<cfloop query="list">
	
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
				   
			VALUES ('#rowguid#', 
			        '#PersonNo#', 					
					'#eMailAddress#', 
					'#FirstName# #LastName#', 
					'#LastName#', 
					'#FirstName#')	   
		</cfquery>
	
	</cfloop>

	<cfset oSecurity = CreateObject("component","Service.Process.System.UserController")/>
	<cfset mid = oSecurity.gethash()/>   
	<cflocation addtoken="No" url="BroadCastView.cfm?id=#rowguid#&mid=#mid#">

</cfif>


