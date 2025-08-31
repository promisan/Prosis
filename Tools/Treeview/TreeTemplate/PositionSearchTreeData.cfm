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
<cfset Mission = "#URL.Mission#">

<cfquery name="Verify" 
datasource="AppsOrganization" 
maxrows=1 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
SELECT MandateNo
      FROM Ref_Mandate
   	  WHERE Mission = '#Mission#'
	  ORDER BY MandateDefault DESC, MandateNo DESC</cfquery>
  
<cfset #URL.MandateNo# = #Verify.MandateNo#>
  
<cfoutput>

['&nbsp;#Mission# [#URL.MandateNo#]','PositionListing.cfm?Source=Lookup&ID1=root&ID2=#Mission#&ID3=#URL.MandateNo#&FormName=#URL.FormName#&fldmission=#URL.fldMission#&fldpostnumber=#URL.fldPostNumber#&fldfunctionno=#URL.fldFunctionNo#&fldfunction=#URL.fldFunction#&fldorgunit=#URL.fldOrgUnit#&fldgrade=#URL.fldGrade#&fldposno=#URL.fldPosNo#', 

  <cfquery name="Level01" 
  datasource="AppsOrganization" 
  username="#SESSION.login#" 
  password="#SESSION.dbpw#">
      SELECT DISTINCT TreeOrder, OrgUnitName, OrgUnit, OrgUnitCode 
      FROM #Client.LanPrefix#Organization
   	  WHERE (ParentOrgUnit is NULL OR ParentOrgUnit = '')
	  AND Mission     = '#Mission#'
	  AND MandateNo   = '#URL.MandateNo#'
	  ORDER BY TreeOrder, OrgUnitName 
  </cfquery>

  <cfloop query="level01">['#Level01.OrgUnitName#','PositionListing.cfm?Source=Lookup&ID1=#Level01.OrgUnitCode#&ID2=#Mission#&ID3=#URL.MandateNo#&FormName=#URL.FormName#&fldmission=#URL.fldMission#&fldpostnumber=#URL.fldPostNumber#&fldfunctionno=#URL.fldFunctionNo#&fldfunction=#URL.fldFunction#&fldorgunit=#URL.fldOrgUnit#&fldgrade=#URL.fldGrade#&fldposno=#URL.fldPosNo#',
  
      <cfquery name="Level02" 
      datasource="AppsOrganization" 
      username="#SESSION.login#" 
      password="#SESSION.dbpw#">
      SELECT DISTINCT TreeOrder, OrgUnitName, OrgUnit, OrgUnitCode 
      FROM #Client.LanPrefix#Organization
 	  WHERE ParentOrgUnit = '#Level01.OrgUnitCode#'
	  AND Mission     = '#Mission#'
	  AND MandateNo   = '#URL.MandateNo#'
	  </cfquery>
  
      <cfloop query="level02">['#Level02.OrgUnitName#','PositionListing.cfm?Source=Lookup&ID1=#Level02.OrgUnitCode#&ID2=#Mission#&ID3=#URL.MandateNo#&FormName=#URL.FormName#&fldmission=#URL.fldMission#&fldpostnumber=#URL.fldPostNumber#&fldfunctionno=#URL.fldFunctionNo#&fldfunction=#URL.fldFunction#&fldorgunit=#URL.fldOrgUnit#&fldgrade=#URL.fldGrade#&fldposno=#URL.fldPosNo#',
	  
	                <cfquery name="Level03" 
             datasource="AppsOrganization" 
             username="#SESSION.login#" 
             password="#SESSION.dbpw#">
             SELECT DISTINCT TreeOrder, OrgUnitName, OrgUnit, OrgUnitCode  
             FROM #Client.LanPrefix#Organization
      	     WHERE ParentOrgUnit = '#Level02.OrgUnitCode#'
			 AND Mission     = '#Mission#'
      	     AND MandateNo   = '#URL.MandateNo#'
	         </cfquery>
  
             <cfloop query="level03">['#Level03.OrgUnitName#','PositionListing.cfm?Source=Lookup&ID1=#Level03.OrgUnitCode#&ID2=#Mission#&ID3=#URL.MandateNo#&FormName=#URL.FormName#&fldmission=#URL.fldMission#&fldpostnumber=#URL.fldPostNumber#&fldfunctionno=#URL.fldFunctionNo#&fldfunction=#URL.fldFunction#&fldorgunit=#URL.fldOrgUnit#&fldgrade=#URL.fldGrade#&fldposno=#URL.fldPosNo#',
			 
			        <cfquery name="Level04" 
             datasource="AppsOrganization" 
             username="#SESSION.login#" 
             password="#SESSION.dbpw#">
             SELECT DISTINCT TreeOrder, OrgUnitName, OrgUnit, OrgUnitCode  
             FROM #Client.LanPrefix#Organization
      	     WHERE ParentOrgUnit = '#Level03.OrgUnitCode#'
			 AND Mission     = '#Mission#'
      	     AND MandateNo   = '#URL.MandateNo#'
	         </cfquery>
  
             <cfloop query="level04">['#Level04.OrgUnitName#','PositionListing.cfm?Source=Lookup&ID1=#Level04.OrgUnitCode#&ID2=#Mission#&ID3=#URL.MandateNo#&FormName=#URL.FormName#&fldmission=#URL.fldMission#&fldpostnumber=#URL.fldPostNumber#&fldfunctionno=#URL.fldFunctionNo#&fldfunction=#URL.fldFunction#&fldorgunit=#URL.fldOrgUnit#&fldgrade=#URL.fldGrade#&fldposno=#URL.fldPosNo#'],
	  
       	     </cfloop>],
			 
			 </cfloop>],
	  	  
	  </cfloop>],
  
  </cfloop>]
    
</cfoutput>



