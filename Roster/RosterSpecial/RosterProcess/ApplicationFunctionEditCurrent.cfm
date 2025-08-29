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
<cfquery name="Current" 
	datasource="AppsSelection" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT *
		FROM   Ref_StatusCode
		WHERE  Owner  = '#url.Owner#'
		AND    Id     = 'Fun'
		AND    Status = '#url.Status#'
</cfquery>
		
<cfquery name="GetFun" 
datasource="AppsSelection" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT *
	FROM   ApplicantFunction F
	WHERE  ApplicantNo         = '#URL.ID#' 
	   AND FunctionId          = '#URL.ID1#'	 
</cfquery>
						
<cfquery name="History" 
		datasource="AppsSelection" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT TOP 1  
		       R.ActionCode, 
			   R.ActionSubmitted, 
			   R.OfficerUserId, 
		       R.OfficerUserLastName, 
			   R.OfficerUserFirstName, 
			   R.ActionEffective, 
		       R.ActionStatus, 
			   R.ActionRemarks, 
			   R.Created, 
			   R1.Meaning, 
			   R1.EntityClass,
			   M.MailId
		FROM   ApplicantFunctionAction A INNER JOIN
	           RosterAction R ON A.RosterActionNo = R.RosterActionNo INNER JOIN
	           Ref_StatusCode R1 ON R.ActionCode = R1.Id AND A.Status = R1.Status LEFT OUTER JOIN
	           ApplicantMail M ON A.ApplicantNo = M.ApplicantNo AND A.FunctionId = M.FunctionId AND A.RosterActionNo = M.RosterActionNo
		WHERE 
		   <!--- AND A.Status <> '0' --->
		   R1.Owner           =  '#url.Owner#'
		   AND A.ApplicantNo  =  '#URL.ID#'  
		   AND A.FunctionId   =  '#URL.ID1#'	   
		ORDER BY R.ActionSubmitted DESC, A.RosterActionNo DESC
</cfquery>
			 
<cfif getFun.status eq "9">	
	<cfoutput>#current.Meaning#</cfoutput>	
<cfelse>	
	<cfoutput>#current.Meaning#</cfoutput>
</cfif>
<cfif history.officerUserFirstName neq "">
 <cfoutput><font size="2" color="gray">#History.OfficerUserFirstName# #History.OfficerUserLastName#</font></cfoutput>
</cfif>
 
<cfif getFun.statusdate neq "">
 <cfoutput>
 &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Effective: <font size="2" color="gray">#dateformat(getFun.statusdate,CLIENT.DateFormatShow)#</b></font>
 </cfoutput>
</cfif>
