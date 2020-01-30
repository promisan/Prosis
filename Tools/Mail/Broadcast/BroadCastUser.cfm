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

<cflocation addtoken="No" url="BroadCastView.cfm?id=#rowguid#">
