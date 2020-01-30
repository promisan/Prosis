<!--- roster action header --->

<cfquery name="AssignNo" 
datasource="#CLIENT.Datasource#" 
username=#SESSION.login# 
password=#SESSION.dbpw#>
    UPDATE Parameter 
	SET    UserActionNo = UserActionNo+1
</cfquery>

<cfquery name="SessionNo" 
datasource="#CLIENT.Datasource#" 
username=#SESSION.login# 
password=#SESSION.dbpw#>
   SELECT UserActionNo
   FROM   Parameter
</cfquery>

<CFSET Caller.UserActionNo = #SessionNo.UserActionNo#>