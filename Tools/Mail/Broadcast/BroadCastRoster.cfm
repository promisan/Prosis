<link rel="stylesheet" type="text/css" href="<cfoutput>#SESSION.root#/#client.style#</cfoutput>">

<cfparam name="URL.SearchId" default="0">

<cf_assignid>

<!--- insert header --->

<cfquery name="Search" 
   datasource="AppsSelection" 
   username="#SESSION.login#" 
   password="#SESSION.dbpw#">
	    SELECT  *
		FROM    RosterSearch
		WHERE searchId = '#url.searchid#'		
</cfquery>

<cfquery name="Broadcast" 
   datasource="AppsSystem" 
   username="#SESSION.login#" 
   password="#SESSION.dbpw#">
	  INSERT INTO Broadcast
		  (BroadcastId,
		   BroadcastClass,
		   BroadcastReference, 
		   BroadCastReferenceNo,
		   BroadCastRecipient,
		   BroadcastFrom,
		   BroadcastReplyTo,
		   BroadcastPriority,
		   BroadcastFailTo,
		   BroadCastMailerId,
		   OfficerUserId,
		   OfficerLastName,
		   OfficerFirstName)
	  VALUES ('#rowguid#',
		  'Mail', 
		  '#Search.Description#',
		  '#url.SearchId#',
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
			RecipientLastName,
			RecipientFirstName)
   SELECT  DISTINCT '#rowguid#',
           A.PersonNo,
		   A.eMailAddress,
           A.FirstName + ' ' + A.LastName,
		   A.LastName,
		   A.FirstName 
   FROM    RosterSearchResult AF INNER JOIN
           Applicant A ON A.PersonNo = AF.PersonNo
   WHERE   A.eMailAddress <> ''
   AND     AF.SearchId = '#URL.SearchId#'
   AND     AF.Status = '1'
</cfquery>

<cfset oSecurity = CreateObject("component","Service.Process.System.UserController")/>
<cfset mid = oSecurity.gethash()/>   
<cflocation addtoken="No" url="BroadCastView.cfm?id=#rowguid#&mid=#mid#">
