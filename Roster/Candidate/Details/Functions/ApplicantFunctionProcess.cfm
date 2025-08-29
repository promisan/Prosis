<!--
    Copyright Â© 2025 Promisan B.V.

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
<cf_RosterActionNo ActionRemarks="Quick Process" ActionCode="FUN">  
	
<cfparam name="URL.status" default="2">
	
<cfquery name="UpdateFunctionStatus" 
	datasource="AppsSelection" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	UPDATE    ApplicantFunction 
	SET       Status                = '#url.Status#',
		<!---
		          FunctionJustification = '#Form.Remarks#',
				  --->
			  StatusDate            = '#dateformat(now(),client.dateSQL)#'  
	WHERE     ApplicantNo           = '#url.ApplicantNo#'
	AND       FunctionId            = '#url.FunctionId#'     
</cfquery>
		
<!--- log the action and the decision elements --->		

<cf_assignid>
			
<cfquery name="UpdateFunctionStatusAction" 
	datasource="AppsSelection" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	INSERT INTO  ApplicantFunctionAction (
	   RosterActionId,
	   ApplicantNo,
	   FunctionId, 
	   RosterActionNo, 
	   Status)
	VALUES  (
	   '#rowguid#',
	   '#url.ApplicantNo#',
	   '#url.FunctionId#',
	   #RosterActionNo#,
	   '#url.Status#')
</cfquery>

<cfquery name="Status" 
		datasource="AppsSelection" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT    *
		FROM      Ref_StatusCode
		WHERE     Owner  = '#URL.Owner#'
		AND       Id     = 'FUN'
		AND       Status = '#url.status#'
	</cfquery>   

<cfoutput>
	
	<cfif url.status eq "3">
	
		<a href="javascript:ColdFusion.navigate('../Functions/ApplicantFunctionProcess.cfm?owner=#url.owner#&applicantno=#url.applicantNo#&functionid=#url.functionId#&status=2','#url.functionid#')"><font color="0080FF">#status.Meaning#</a>
					
		<img src="#SESSION.root#/Images/arrow-down.gif" 
			  align="absmiddle" 
			  style="cursor: pointer;"
			  onclick="ColdFusion.navigate('../Functions/ApplicantFunctionProcess.cfm?owner=#url.owner#&applicantno=#url.applicantNo#&functionid=#url.functionId#&status=2','#url.functionid#')"
			  alt="Roster Candidate" 
			  border="0">
		  
	<cfelse>
	
		<a href="javascript:ColdFusion.navigate('../Functions/ApplicantFunctionProcess.cfm?owner=#url.owner#&applicantno=#url.applicantNo#&functionid=#url.functionId#&status=3','#url.functionid#')"><font color="0080FF">#status.Meaning#</a>
			
		<img src="#SESSION.root#/Images/favorite.gif" 
			  align="absmiddle" 
			  style="cursor: pointer;"
			  onclick="ColdFusion.navigate('../Functions/ApplicantFunctionProcess.cfm?owner=#url.owner#&applicantno=#url.applicantNo#&functionid=#url.functionId#&status=3','#url.functionid#')"
			  alt="Roster Candidate" 
			  border="0">
	
	</cfif>	  

</cfoutput> 