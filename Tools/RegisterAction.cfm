
<!--- deprecated

<cfparam name="Attributes.SystemFunctionId" default="0001">
<cfparam name="Attributes.ActionClass" default="undefined">
<cfparam name="Attributes.ActionType" default="undefined">
<cfparam name="Attributes.ActionReference" default="">
<cfparam name="Attributes.ActionScript" default="">

<cfquery name="Update" 
datasource="AppsSystem"
username="#SESSION.login#" 
password="#SESSION.dbpw#">
INSERT INTO UserAction 
    (SessionNo, ActionTimeStamp, UserAccount,
	 UserFirstName, UserLastName, UserGroup, 
     UserIndexNo, SystemFunctionId, ActionClass, ActionType,
	 ActionReference, ActionScript) 
VALUES (
    '#CLIENT.SessionNo#',
    #Now()#,
	'#SESSION.acc#', 
	'#SESSION.first#', 
    '#SESSION.last#', 
	'#CLIENT.section#', 
	'#CLIENT.indexNo#',	
	'#Attributes.SystemFunctionId#', 
    '#Attributes.actionClass#', 
	'#Attributes.actionType#', 
	'#Attributes.actionReference#',
	'#Attributes.actionScript#')
</cfquery> 

--->