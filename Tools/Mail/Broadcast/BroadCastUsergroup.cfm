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
