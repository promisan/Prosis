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

<cfparam name="URL.FunctionId" default="00000000-0000-0000-0000-000000000000">
<cfparam name="URL.Status" default="3">

<cf_assignid>

<!--- insert header --->

<cfquery name="Bucket" 
   datasource="AppsSelection" 
   username="#SESSION.login#" 
   password="#SESSION.dbpw#">
	    SELECT  *
		FROM    FunctionOrganization FO INNER JOIN
                FunctionTitle F ON FO.FunctionNo = F.FunctionNo
		WHERE FunctionId = '#url.functionId#'		
</cfquery>

<cfquery name="Broadcast" 
   datasource="AppsSystem" 
   username="#SESSION.login#" 
   password="#SESSION.dbpw#">
	  INSERT INTO Broadcast
	  (BroadcastId,
	   BroadcastClass,
	   BroadcastReference,
	   BroadCastReferenceId, 
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
	  '#Bucket.FunctionDescription#',
	   '#url.FunctionId#', 
	  'Applicant',
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
   datasource="AppsSelection" 
   username="#SESSION.login#" 
   password="#SESSION.dbpw#">
   INSERT INTO System.dbo.BroadcastRecipient
        (BroadcastId, 
		RecipientCode, 
		eMailAddress, 
		RecipientName,
		RecipientFirstName,
		RecipientLastName)
   SELECT  DISTINCT '#rowguid#',
           A.PersonNo,
		   A.eMailAddress,
           A.FirstName + ' ' + A.LastName,
		   A.FirstName,
		   A.LastName
   FROM    ApplicantFunction AF INNER JOIN
           ApplicantSubmission S ON AF.ApplicantNo = S.ApplicantNo INNER JOIN
           Applicant A ON S.PersonNo = A.PersonNo
   WHERE   A.eMailAddress <> ''
   AND     AF.FunctionId = '#URL.FunctionId#'
   AND     AF.Status = '#URL.Status#'
</cfquery>

<cfparam name="url.mid" default="">
<cflocation addtoken="No" url="BroadCastView.cfm?id=#rowguid#&mid=#url.mid#">
