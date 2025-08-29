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
<table width="100%" border="0" cellspacing="0" cellpadding="0" align="center" class="formpadding">

<TR><TD>

<cfparam name="URL.EntityClass" default="">

<cfloop index="itm" list="#url.ajaxid#" delimiters="_"></cfloop>

<cfif URL.EntityClass neq "">
	
	<cfquery name="Update" 
		datasource="AppsPurchase" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		UPDATE  RequisitionLine
		SET     EntityClass  = '#URL.entityclass#' 
		WHERE   RequisitionNo = '#itm#'
	</cfquery>

</cfif>

<cfquery name="Line" 
datasource="AppsPurchase" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT L.*
    FROM RequisitionLine L
	WHERE RequisitionNo = '#itm#'
</cfquery>


<cfset link = "Procurement/Application/Requisition/Requisition/RequisitionEdit.cfm?id=#Line.RequisitionNo#">
 	
<cfif Line.actionStatus eq "1" or Line.actionStatus eq "0">
   <cfset p = "Yes"> 
<cfelse>
   <cfset p = "No">    
</cfif>

<cfif Line.ActionStatus eq "9">
   <cfset c = "Enforce">
<cfelseif Line.ActionStatus eq "3">
   <cfset c = "Enforce">  
<cfelse>
   <cfset c = "No">
</cfif>
 					
<cf_ActionListing 
	    EntityCode       = "ProcReq"
		EntityClass      = "#Line.EntityClass#"
		EntityClassReset = "1"
		EntityGroup      = ""
		EntityStatus     = ""
		CompleteFirst    = "No"
		OrgUnit          = "#Line.OrgUnit#"
		Mission          = "#Line.Mission#"
		ObjectReference  = "#Line.RequisitionNo#"
		ObjectReference2 = "#Line.RequestDescription#"
		ObjectKey1       = "#Line.RequisitionNo#"
	  	ObjectURL        = "#link#"
		AjaxId           = "#URL.AjaxId#"
		Show             = "Yes" 
		AllowProcess     = "#p#" 
		HideCurrent      = "#c#"
		DocumentStatus   = "0">	
		
		
</td></tr>

</table>		

