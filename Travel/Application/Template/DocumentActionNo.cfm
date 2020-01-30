<!--- roster action header --->

<cfquery name="AssignNo" 
datasource="#CLIENT.Datasource#" 
username=#SESSION.login# 
password=#SESSION.dbpw#>
    UPDATE Parameter SET UserActionNo = UserActionNo+1
</cfquery>

<cfquery name="SessionNo" 
datasource="#CLIENT.Datasource#" 
username=#SESSION.login# 
password=#SESSION.dbpw#>
   SELECT UserActionNo
   FROM   Parameter
</cfquery>

<cfquery name="RosterAction" 
datasource="#CLIENT.Datasource#" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
INSERT INTO UserAction 
   (UserActionNo, 
   ActionCode, 
   ActionSubmitted, 
   OfficerUserId, 
   OfficerUserLastName, 
   OfficerUserFirstName, 
   ActionEffective, 
   ActionStatus, 
   ActionRemarks,
   Created)
VALUES 
   (#SessionNo.UserActionNo#,
   '#Attributes.ActionCode#', 
   #now()#, 
   '#SESSION.acc#', 
   '#SESSION.last#', 
   '#SESSION.first#', 
   #now()#, 
   '1', 
   '#Attributes.ActionRemarks#',
   #now()#)
</cfquery>

<CFSET Caller.UserActionNo = #SessionNo.UserActionNo#>