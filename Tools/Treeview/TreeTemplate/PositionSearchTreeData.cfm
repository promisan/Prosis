
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



