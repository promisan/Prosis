<!--
    Copyright © 2025 Promisan B.V.

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