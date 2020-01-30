<!--- aaving the action --->

<cfparam name="form.status_#url.line#"      default="1">
<cfparam name="form.memo_#url.line#"        default="1">
<cfparam name="form.date_#url.line#_date"   default="">
<cfparam name="form.date_#url.line#_hour"   default="12">
<cfparam name="form.date_#url.line#_minute" default="0">

<cfset status = evaluate("form.status_#url.line#")>
<cfset memo   = evaluate("form.memo_#url.line#")>
<cfset date   = evaluate("form.date_#url.line#_date")>
<cfset hour   = evaluate("form.date_#url.line#_hour")>
<cfset minu   = evaluate("form.date_#url.line#_minute")>

<cfset dateValue = "">
<CF_DateConvert Value="#date#">
<cfset DTE = dateValue>
		
<cfset dte = DateAdd("h","#hour#", dte)>
<cfset dte = DateAdd("n","#minu#", dte)>

<cfquery name="setAction" 
	datasource="appsWorkOrder" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#"> 	
	   UPDATE WorkOrderLineAction	   
	   
	   SET    ActionStatus            = '#status#',
	          ActionMemo              = '#memo#',   
			  DateTimeActual          =  #dte#,
			  ActionOfficerUserId     = '#SESSION.acc#',
			  ActionOfficerLastName   = '#SESSION.last#',
			  ActionOfficerFirstName  = '#SESSION.first#'
			  
	   WHERE  WorkActionId = '#url.workactionid#'			
</cfquery>	

<cfoutput>
	<font color="gray">saved&nbsp;#timeformat(now(),"HH:MM:SS")#</font>
</cfoutput>	