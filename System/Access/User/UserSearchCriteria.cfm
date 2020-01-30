
<CFSET Criteria = ''>

<cfparam name="form.MissionAccess" default="">
<cfparam name="form.HostAccess"    default="">
<cfparam name="form.SystemModule"  default="">

<cfif Form.Status eq "">
    <cfset crit = "">
<cfelse>	
	<cfset crit = "Disabled = #Form.Status#">	
</cfif>		

<CF_Search_AppendCriteria
    FieldName="#Form.Crit1_FieldName#"
    FieldType="#Form.Crit1_FieldType#"
    Operator="#Form.Crit1_Operator#"
    Value="#Form.Crit1_Value#">
	
<cfif Form.AccountType neq ""> 
    <cfif crit eq "">
		<cfset crit = "AccountType = '#Form.AccountType#'">	
	<cfelse>  
		<cfset crit = "#crit# AND AccountType = '#Form.AccountType#'">	
	</cfif>
</cfif>		
	
<CF_Search_AppendCriteria
    FieldName="#Form.Crit3_FieldName#"
    FieldType="#Form.Crit3_FieldType#"
    Operator="#Form.Crit3_Operator#"
    Value="#Form.Crit3_Value#">
		
<CF_Search_AppendCriteria
    FieldName="#Form.Crit4_FieldName#"
    FieldType="#Form.Crit4_FieldType#"
    Operator="#Form.Crit4_Operator#"
    Value="#Form.Crit4_Value#">	
		
<CF_Search_AppendCriteria
    FieldName="#Form.Crit5_FieldName#"
    FieldType="#Form.Crit5_FieldType#"
    Operator="#Form.Crit5_Operator#"
    Value="#Form.Crit5_Value#">	

<cfif Criteria eq "">
    <cfset Criteria = "AND #crit#">
<cfelse>
    <cfif Crit neq "">
    	<cfset Criteria = "AND #Criteria# AND #Crit#">
	<cfelse>
		<cfset Criteria = "AND #Criteria#">
	</cfif>
</cfif>	

<cfif Form.Role neq "">

	<cfset Criteria = "#Criteria# AND EXISTS (SELECT 'X' FROM Organization.dbo.OrganizationAuthorization WHERE UserAccount = U.Account and Role = '#Form.Role#') "> 

</cfif>

<!--- ----------------------- --->	
<!--- account used for entity --->
<!--- ----------------------- --->	

<cfset dateValue = "">
<CF_DateConvert Value="#Form.Session_Value#">
<cfset DTE = dateValue>

<cfif form.accountType eq "Individual">
		
	<cfif form.MissionAccess neq "" or form.HostAccess neq "" or form.SystemModule neq "">
	
		<cfset mis = "">
		<cfif form.MissionAccess neq "">
			<cfset mis = " AND Mission = '#form.MissionAccess#' ">
		</cfif>
		
		<cfset hst = "">
		<cfif form.HostAccess neq "">
			<cfset hst = " AND HostName = '#form.HostAccess#' ">
		</cfif>	
		
		<cfset mdu = "">
		<cfif form.SystemModule neq "">
			<cfset mdu = " AND SystemFunctionId IN (SELECT SystemFunctionId FROM Ref_ModuleControl WHERE SystemModule = '#form.SystemModule#') ">
		</cfif>	
	    
		<cfif form.Session_Operator is "before">
			  <cfset Criteria = "#Criteria# AND U.Account IN (SELECT Account FROM UserActionModule WHERE Account = U.Account #mis# #hst# #mdu# AND ActionTimeStamp < #dte#)">
		<cfelse>
			  <cfset Criteria = "#Criteria# AND U.Account IN (SELECT Account FROM UserActionModule WHERE Account = U.Account #mis# #hst# #mdu# AND ActionTimeStamp >= #dte#)">	
		</cfif>	
		
	<cfelse>
	
		<cfif form.session_Value neq "">
		   <cfif form.Session_Operator is "">		   
		   <cfelseif form.Session_Operator is "before">
		      <cfset Criteria = "#Criteria# AND (U.Account IN (SELECT Account FROM skUserLastLogon WHERE Account = U.Account AND LastConnection < #dte#) OR U.Account NOT IN (SELECT Account FROM skUserLastLogon WHERE Account = U.Account))">	 
		   <cfelse>
	   		  <cfset Criteria = "#Criteria# AND U.Account IN (SELECT Account FROM skUserLastLogon WHERE Account = U.Account AND LastConnection >= #dte#)">
		   </cfif>	
		</cfif>
		
	</cfif>	

</cfif>

<cfif form.isEmployee eq "0">

	<cfset Criteria = "#Criteria# AND (U.PersonNo is NULL OR U.PersonNo NOT IN (SELECT PersonNo FROM Employee.dbo.Person WHERE Personno = U.PersonNo))">
	
<cfelseif form.isEmployee eq "1">

	<cfset Criteria = "#Criteria# AND (U.PersonNo IN (SELECT PersonNo FROM Employee.dbo.Person WHERE Personno = U.PersonNo))">
	

</cfif>

<cfset session.userselect[1]  = Form.Crit1_Value>
<cfset session.userselect[2]  = Form.AccountType>
<cfset session.userselect[3]  = Form.Crit3_Value>
<cfset session.userselect[4]  = Form.Crit4_Value>
<cfset session.userselect[5]  = Form.Crit5_Value>
<cfset session.userselect[6]  = Form.MissionAccess>
<cfset session.userselect[7]  = Form.Session_Operator>
<cfset session.userselect[8]  = Form.Session_Value>
<cfset session.userselect[9]  = Form.HostAccess>
<cfset session.userselect[10] = Form.SystemModule>
<cfset session.userselect[11] = Form.Role>
<cfset session.userselect[12] = Form.isEmployee>
	
<!--- Query returning search results --->

<cfset client.userquerystring = criteria>

<cfset oSecurity = CreateObject("component","Service.Process.System.UserController")/>
<cfset url.mid = oSecurity.gethash()/>   

<cfinclude template="UserResult.cfm">

