
<cfquery name="Root" 
  datasource="appsOrganization" 
  username="#SESSION.login#" 
  password="#SESSION.dbpw#">
      SELECT OrgUnitCode as OrganizationCode, OrgUnitName as Description 
      FROM Organization
   	  WHERE OrgUnitCode = '#URL.Department#'
	  AND Mission = 'UN'
 </cfquery>

<cfoutput>

['&nbsp;#Root.Description#','OrganizationListing.cfm?ID1=#Root.OrganizationCode#&FormName=#URL.formname#&fldorgcode=#URL.fldorgcode#&fldorgdescription=#URL.fldorgdescription#&fldorghierarchy=#URL.fldorghierarchy#', 

  <cfquery name="Level01" 
  datasource="appsOrganization" 
  username="#SESSION.login#" 
  password="#SESSION.dbpw#">
      SELECT OrgUnitCode as OrganizationCode, OrgUnitName as Description 
      FROM Organization
   	  WHERE ParentOrgUnit = '#Root.OrganizationCode#'
	  ORDER BY TreeOrder
  </cfquery>

  <cfloop query="level01">['#Level01.Description#','OrganizationListing.cfm?ID1=#Level01.OrganizationCode#&FormName=#URL.formname#&fldorgcode=#URL.fldorgcode#&fldorgdescription=#URL.fldorgdescription#&fldorghierarchy=#URL.fldorghierarchy#',
  
      <cfquery name="Level02" 
      datasource="appsOrganization" 
      username="#SESSION.login#" 
      password="#SESSION.dbpw#">
      SELECT OrgUnitCode as OrganizationCode, OrgUnitName as Description 
      FROM Organization
 	  WHERE ParentOrgUnit = '#Level01.OrganizationCode#'
	  ORDER BY TreeOrder
	  </cfquery>
  
      <cfloop query="level02">['#Level02.Description#','OrganizationListing.cfm?ID1=#Level02.OrganizationCode#&FormName=#URL.formname#&fldorgcode=#URL.fldorgcode#&fldorgdescription=#URL.fldorgdescription#&fldorghierarchy=#URL.fldorghierarchy#',
	  
	        <cfquery name="Level03" 
             datasource="appsOrganization" 
             username="#SESSION.login#" 
             password="#SESSION.dbpw#">
             SELECT OrgUnitCode as OrganizationCode, OrgUnitName as Description 
             FROM Organization
      	     WHERE ParentOrgUnit = '#Level02.OrganizationCode#'
			 ORDER BY TreeOrder
	         </cfquery>
  
             <cfloop query="level03">['#Level03.Description#','OrganizationListing.cfm?ID1=#Level03.OrganizationCode#&FormName=#URL.formname#&fldorgcode=#URL.fldorgcode#&fldorgdescription=#URL.fldorgdescription#&fldorghierarchy=#URL.fldorghierarchy#',
			 
			         <cfquery name="Level04" 
             datasource="appsOrganization" 
             username="#SESSION.login#" 
             password="#SESSION.dbpw#">
             SELECT OrgUnitCode as OrganizationCode, OrgUnitName as Description  
             FROM Organization
      	     WHERE ParentOrgUnit = '#Level03.OrganizationCode#'
			 ORDER BY TreeOrder
	         </cfquery>
  
             <cfloop query="level04">['#Level04.Description#','OrganizationListing.cfm?ID1=#Level04.OrganizationCode#&FormName=#URL.formname#&fldorgcode=#URL.fldorgcode#&fldorgdescription=#URL.fldorgdescription#&fldorghierarchy=#URL.fldorghierarchy#'],
	  
       	     </cfloop>],
			 
			 </cfloop>],
	  	  
	  </cfloop>],
  
  </cfloop>]
    
</cfoutput>



