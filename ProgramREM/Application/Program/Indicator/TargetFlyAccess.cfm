<!--
    Copyright © 2025 Promisan

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

<!--- fly access --->

<link rel="stylesheet" type="text/css" href="<cfoutput>#SESSION.root#/#client.style#</cfoutput>"> 

<!--- check prior entry --->

<cfquery name="Target" 
 datasource="AppsProgram" 
 username="#SESSION.login#" 
 password="#SESSION.dbpw#">
 SELECT   PI.IndicatorCode, Pe.OrgUnit, Org.Mission
 FROM     ProgramIndicator PI INNER JOIN
          ProgramPeriod Pe ON PI.ProgramCode = Pe.ProgramCode AND PI.Period = Pe.Period INNER JOIN
          Organization.dbo.Organization Org ON Pe.OrgUnit = Org.OrgUnit
 WHERE    TargetId = '#URL.TargetId#'		   
</cfquery>			 

<cfquery name="Fly" 
  datasource="AppsOrganization" 
  username="#SESSION.login#" 
  password="#SESSION.dbpw#">
   SELECT *
   FROM  OrganizationAuthorization
   WHERE (OrgUnit        = '#Target.OrgUnit#' or (OrgUnit is NULL AND Mission = '#Target.Mission#'))
   AND   Role           = 'ProgramAuditor'
   AND   ClassParameter = '#Target.IndicatorCode#'
   AND   UserAccount    = '#URL.acc#'
 </cfquery>
 
 <cfif Fly.recordcount eq "1">
 
   <cf_message message = "The selected user has been authorised already. Operation aborted."
  return = "back">

  <cfabort>
 
 </cfif>
 
 <cfquery name="Insert" 
  datasource="AppsOrganization" 
  username="#SESSION.login#" 
  password="#SESSION.dbpw#">
   INSERT INTO OrganizationAuthorization
   	   (Mission, 
	    OrgUnit, 
		UserAccount, 
		Role, 
		AccessLevel,
		ClassParameter, 
		OfficerUserId, 
		OfficerLastName, 
		OfficerFirstName, 
		Created)
   VALUES
	   ('#Target.Mission#',
	    '#Target.OrgUnit#',
		'#URL.ACC#', 
		'ProgramAuditor',
		'2',
		'#Target.IndicatorCode#',
		'#SESSION.acc#', 
		'#SESSION.last#', 
		'#SESSION.first#', 
		getDate())
 </cfquery>

<cfoutput>
<script language="JavaScript">
    parent.access('#url.TargetId#','#url.i#')
    // refresh 
    parent.ColdFusion.Window.destroy('userdialog',true)
	
	
</script>
</cfoutput> 