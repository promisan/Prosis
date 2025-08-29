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
<cfset Mission   = "#Attributes.Mission#">
<cfset Mandate   = "#Attributes.Mandate#">
<cfset Effective = "#Attributes.Effective#">
<cfset Process   = "#Attributes.Process#">

<cfif Mandate eq "" and Effective eq "">

	<cfquery name="Verify" 
	  datasource="AppsOrganization" 
	  username="#SESSION.login#" 
	  password="#SESSION.dbpw#">
	      SELECT *
	      FROM   Ref_Mandate
	   	  WHERE  Mission = '#Mission#'  
	 </cfquery>
	  
<cfelseif Mandate neq "">

	<cfquery name="Verify" 
	  datasource="AppsOrganization" 
	  username="#SESSION.login#" 
	  password="#SESSION.dbpw#">
	      SELECT *
	      FROM   Ref_Mandate
	   	  WHERE  Mission = '#Mission#' 
		  AND    MandateNo = '#Mandate#' 
	 </cfquery>
		 
<cfelse>

	<cfquery name="Verify" 
		  datasource="AppsOrganization" 
		  username="#SESSION.login#" 
		  password="#SESSION.dbpw#">
		      SELECT *
		      FROM   Ref_Mandate
		   	  WHERE  Mission = '#Mission#' 
			  AND    DateEffective  <= '#DateFormat(effective,client.dateSQL)#'
			  AND    DateExpiration >= '#DateFormat(effective,client.dateSQL)#' 
			  AND    Operational = 1
	 </cfquery> 
		  
</cfif>  
  
<cfif Verify.RecordCount gt 1>  

<cfoutput>

['#Verify.Mission#',null, 

<cfquery name="Mandate" 
  datasource="AppsOrganization" 
  username="#SESSION.login#" 
  password="#SESSION.dbpw#">
      SELECT DISTINCT MandateNo, Description, DateEffective, DateExpiration 
      FROM Ref_Mandate
   	  WHERE Mission = '#Verify.Mission#' 
	  ORDER BY DateEffective DESC
  </cfquery>

  <cfloop query="Mandate">
    
  ['<font color="800000"><u>#Mandate.Description#</u></font>','',
 
  <cfset MandateNo = "#Mandate.MandateNo#">
  
  <cfquery name="Level01" 
  datasource="AppsOrganization" 
  username="#SESSION.login#" 
  password="#SESSION.dbpw#">
      SELECT DISTINCT TreeOrder, OrgUnitName, OrgUnit, OrgUnitCode 
      FROM   #Client.LanPrefix#Organization
   	  WHERE (ParentOrgUnit is NULL OR ParentOrgUnit = '')
	  AND   Mission     = '#Verify.Mission#'
	  AND   MandateNo   = '#MandateNo#'
	  ORDER BY TreeOrder, OrgUnitName 
  </cfquery>

  <cfloop query="level01">['#Level01.OrgUnitName#','OrganizationListing.cfm?ID1=#Level01.OrgUnitCode#&Mission=#Verify.Mission#&Mandate=#MandateNo#&#Process#',
  
      <cfquery name="Level02" 
      datasource="AppsOrganization" 
      username="#SESSION.login#" 
      password="#SESSION.dbpw#">
      SELECT DISTINCT TreeOrder, OrgUnitName, OrgUnit, OrgUnitCode 
      FROM #Client.LanPrefix#Organization
 	  WHERE ParentOrgUnit = '#Level01.OrgUnitCode#'
	  AND Mission     = '#Verify.Mission#'
	  AND MandateNo   = '#MandateNo#'
	  ORDER BY TreeOrder, OrgUnitName 
	  </cfquery>
  
      <cfloop query="level02">['#Level02.OrgUnitName#','OrganizationListing.cfm?ID1=#Level02.OrgUnitCode#&Mission=#Verify.Mission#&Mandate=#MandateNo#&#Process#',
	  
	        <cfquery name="Level03" 
             datasource="AppsOrganization" 
             username="#SESSION.login#" 
             password="#SESSION.dbpw#">
             SELECT DISTINCT TreeOrder, OrgUnitName, OrgUnit, OrgUnitCode  
             FROM #Client.LanPrefix#Organization
      	     WHERE ParentOrgUnit = '#Level02.OrgUnitCode#'
			 AND Mission     = '#Verify.Mission#'
      	     AND MandateNo   = '#MandateNo#'
			 ORDER BY TreeOrder, OrgUnitName 
	         </cfquery>
  
             <cfloop query="level03">['#Level03.OrgUnitName#','OrganizationListing.cfm?ID1=#Level03.OrgUnitCode#&Mission=#Verify.Mission#&Mandate=#MandateNo#&#Process#',
			 
			     <cfquery name="Level04" 
                 datasource="AppsOrganization" 
                 username="#SESSION.login#" 
                 password="#SESSION.dbpw#">
                 SELECT DISTINCT TreeOrder, OrgUnitName, OrgUnit, OrgUnitCode  
                 FROM #Client.LanPrefix#Organization
         	     WHERE ParentOrgUnit = '#Level03.OrgUnitCode#'
		    	 AND Mission     = '#Verify.Mission#'
         	     AND MandateNo   = '#MandateNo#'
	    		 ORDER BY TreeOrder, OrgUnitName 
	         </cfquery>
  
             <cfloop query="level04">['#Level04.OrgUnitName#','OrganizationListing.cfm?ID1=#Level04.OrgUnitCode#&Mission=#Verify.Mission#&Mandate=#MandateNo#&#Process#'],
	  
       	     </cfloop>],
			 
			 </cfloop>],
	  	  
	  </cfloop>],
  
  </cfloop>],
  
 </cfloop>]
 
</cfoutput>

<cfelseif Verify.recordcount eq "1">

<cfoutput>

['#Mission# : #DateFormat(Verify.DateEffective,CLIENT.DateFormatShow)# - #DateFormat(Verify.DateExpiration,CLIENT.DateFormatShow)#','OrganizationListing.cfm?ID1=root&Mission=#Verify.Mission#&Mandate=#Verify.MandateNo#&#Process#', 

  <cfquery name="Level01" 
  datasource="AppsOrganization" 
  username="#SESSION.login#" 
  password="#SESSION.dbpw#">
      SELECT DISTINCT TreeOrder, OrgUnitName, OrgUnit, OrgUnitCode 
      FROM #Client.LanPrefix#Organization
   	  WHERE (ParentOrgUnit is NULL OR ParentOrgUnit = '')
	  AND Mission     = '#Verify.Mission#'
	  AND MandateNo   = '#Verify.MandateNo#'
	  ORDER BY TreeOrder, OrgUnitName 
  </cfquery>

  <cfloop query="level01">['#Level01.OrgUnitName#','OrganizationListing.cfm?ID1=#Level01.OrgUnitCode#&Mission=#Verify.Mission#&Mandate=#Verify.MandateNo#&#Process#',
  
      <cfquery name="Level02" 
      datasource="AppsOrganization" 
      username="#SESSION.login#" 
      password="#SESSION.dbpw#">
      SELECT DISTINCT TreeOrder, OrgUnitName, OrgUnit, OrgUnitCode 
      FROM #Client.LanPrefix#Organization
 	  WHERE ParentOrgUnit = '#Level01.OrgUnitCode#'
	  AND Mission     = '#Verify.Mission#'
	  AND MandateNo   = '#Verify.MandateNo#'
	  </cfquery>
  
      <cfloop query="level02">['#Level02.OrgUnitName#','OrganizationListing.cfm?ID1=#Level02.OrgUnitCode#&Mission=#Verify.Mission#&Mandate=#Verify.MandateNo#&#Process#',
	  
	        <cfquery name="Level03" 
             datasource="AppsOrganization" 
             username="#SESSION.login#" 
             password="#SESSION.dbpw#">
             SELECT DISTINCT TreeOrder, OrgUnitName, OrgUnit, OrgUnitCode  
             FROM #Client.LanPrefix#Organization
      	     WHERE ParentOrgUnit = '#Level02.OrgUnitCode#'
			 AND Mission     = '#Verify.Mission#'
      	     AND MandateNo   = '#Verify.MandateNo#'
	         </cfquery>
  
             <cfloop query="level03">['#Level03.OrgUnitName#','OrganizationListing.cfm?ID1=#Level03.OrgUnitCode#&Mission=#Verify.Mission#&Mandate=#Verify.MandateNo#&#Process#',
			 
			         <cfquery name="Level04" 
             datasource="AppsOrganization" 
             username="#SESSION.login#" 
             password="#SESSION.dbpw#">
             SELECT DISTINCT TreeOrder, OrgUnitName, OrgUnit, OrgUnitCode  
             FROM #Client.LanPrefix#Organization
      	     WHERE ParentOrgUnit = '#Level03.OrgUnitCode#'
			 AND Mission     = '#Verify.Mission#'
      	     AND MandateNo   = '#Verify.MandateNo#'
	         </cfquery>
  
             <cfloop query="level04">['#Level04.OrgUnitName#','OrganizationListing.cfm?ID1=#Level04.OrgUnitCode#&Mission=#Verify.Mission#&Mandate=#Verify.MandateNo#&#Process#',
	         	   			 
				          <cfquery name="Level05" 
	             datasource="AppsOrganization" 
	             username="#SESSION.login#" 
	             password="#SESSION.dbpw#">
	             SELECT DISTINCT TreeOrder, OrgUnitName, OrgUnit, OrgUnitCode  
	             FROM #Client.LanPrefix#Organization
	      	     WHERE ParentOrgUnit = '#Level04.OrgUnitCode#'
				 AND Mission     = '#Verify.Mission#'
	      	     AND MandateNo   = '#Verify.MandateNo#'
		         </cfquery>
	  
	             <cfloop query="level05">['#Level05.OrgUnitName#','OrganizationListing.cfm?ID1=#Level05.OrgUnitCode#&Mission=#Verify.Mission#&Mandate=#Verify.MandateNo#&#Process#'],
		  
	       	     </cfloop>],
			 
			 </cfloop>],
			 
			 </cfloop>],
	  	  
	  </cfloop>],
  
  </cfloop>]
    
</cfoutput>

<cfelse>

<cfoutput>
['&nbsp;#Verify.Mission# <b>no mandate found for : #Effective#',null] 
</cfoutput>

</cfif>














<!-------------------------------- --->


<!--- query of query 


<cfset Mission   = "#Attributes.Mission#">
<cfset Mandate   = "#Attributes.Mandate#">
<cfset Effective = "#Attributes.Effective#">
<cfset Process   = "#Attributes.Process#">

<cfif #Mandate# eq "" and Effective eq "">

	<cfquery name="Verify" 
	  datasource="AppsOrganization" 
	  username="#SESSION.login#" 
	  password="#SESSION.dbpw#">
	      SELECT *
	      FROM Ref_Mandate
	   	  WHERE Mission = '#Mission#' 
	 </cfquery>
	  
<cfelseif #Mandate# neq "">

	<cfquery name="Verify" 
	  datasource="AppsOrganization" 
	  username="#SESSION.login#" 
	  password="#SESSION.dbpw#">
	      SELECT *
	      FROM Ref_Mandate
	   	  WHERE Mission = '#Mission#' 
		  AND  MandateNo = '#Mandate#' 
	 </cfquery>
		 
<cfelse>

		<cfquery name="Verify" 
			  datasource="AppsOrganization" 
			  username="#SESSION.login#" 
			  password="#SESSION.dbpw#">
			      SELECT *
			      FROM   Ref_Mandate
			   	  WHERE  Mission = '#Mission#' 
				  AND    DateEffective  <= '#DateFormat(effective,client.dateSQL)#'
				  AND    DateExpiration >= '#DateFormat(effective,client.dateSQL)#' 
				  AND    Operational = 1
		 </cfquery> 
		  
</cfif>  
  
<cfif Verify.RecordCount gt 1>  

<cfoutput>

['#Verify.Mission#',null, 

<cfquery name="Mandate" 
  datasource="AppsOrganization" 
  username="#SESSION.login#" 
  password="#SESSION.dbpw#">
      SELECT DISTINCT MandateNo, Description, DateEffective, DateExpiration 
      FROM Ref_Mandate
   	  WHERE Mission = '#Verify.Mission#' 
	  ORDER BY DateEffective DESC
  </cfquery>
  
   <cfquery name="BaseSet" 
    datasource="AppsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT TreeOrder, 
	      OrgUnitName, 
		  OrgUnitNameShort, 
		  OrgUnit, 
		  OrgUnitCode,
		  Mission,
		  ParentOrgUnit
    FROM #Client.LanPrefix#Organization
   	WHERE Mission     = '#Verify.Mission#'
	 AND  MandateNo   = '#MandateNo#'
	ORDER BY HierarchyCode, TreeOrder, OrgUnitName
	</cfquery>

  <cfloop query="Mandate">
    
  ['<font color="800000"><u>#Mandate.Description#</u></font>','',
 
  <cfset MandateNo = "#Mandate.MandateNo#">
  
	  <cfquery name="Level01" 
	  datasource="AppsOrganization" 
	  username="#SESSION.login#" 
	  password="#SESSION.dbpw#">
    	   	SELECT TreeOrder, OrgUnitName, OrgUnit, OrgUnitCode 
		    FROM BaseSet
	   		WHERE (ParentOrgUnit is NULL OR ParentOrgUnit = '')
			ORDER BY TreeOrder, OrgUnitName
	  </cfquery>	
  
  <cfloop query="level01">['#Level01.OrgUnitName#','OrganizationListing.cfm?ID1=#Level01.OrgUnitCode#&Mission=#Verify.Mission#&Mandate=#MandateNo#&#Process#',
  
      <cfquery name="Level02" dbtype="query" >
		      SELECT  * 
		      FROM   BaseSet
	 		  WHERE  ParentOrgUnit = '#Level01.OrgUnitCode#' 
		   	  ORDER BY TreeOrder, OrgUnitName
	  	</cfquery>
  
      <cfloop query="level02">['#Level02.OrgUnitName#','OrganizationListing.cfm?ID1=#Level02.OrgUnitCode#&Mission=#Verify.Mission#&Mandate=#MandateNo#&#Process#',
	  
	        <cfquery name="Level03" dbtype="query" >
			      SELECT  * 
	    		  FROM   BaseSet
			 	  WHERE  ParentOrgUnit = '#Level02.OrgUnitCode#' 
				  ORDER BY TreeOrder, OrgUnitName
	  		</cfquery>
  
             <cfloop query="level03">['#Level03.OrgUnitName#','OrganizationListing.cfm?ID1=#Level03.OrgUnitCode#&Mission=#Verify.Mission#&Mandate=#MandateNo#&#Process#',
			 
			   <cfquery name="Level04" dbtype="query" >
			      SELECT  * 
	    		  FROM   BaseSet
			 	  WHERE  ParentOrgUnit = '#Level03.OrgUnitCode#' 
				  ORDER BY TreeOrder, OrgUnitName
	  		   </cfquery>	
  
             <cfloop query="level04">['#Level04.OrgUnitName#','OrganizationListing.cfm?ID1=#Level04.OrgUnitCode#&Mission=#Verify.Mission#&Mandate=#MandateNo#&#Process#'],
	  
       	     </cfloop>],
			 
			 </cfloop>],
	  	  
	  </cfloop>],
  
  </cfloop>],
  
 </cfloop>]
 
</cfoutput>

<cfelseif Verify.recordcount eq "1">

	 <cfquery name="BaseSet" 
    	datasource="AppsOrganization" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT TreeOrder, 
	 	       OrgUnitName, 
			   OrgUnitNameShort, 
			   OrgUnit, 
			   OrgUnitCode,
			   Mission,
			   ParentOrgUnit
    	FROM   #Client.LanPrefix#Organization
	   	WHERE  Mission     = '#Verify.Mission#'
		 AND   MandateNo   = '#MandateNo#'
		ORDER BY HierarchyCode, TreeOrder, OrgUnitName
	 </cfquery>

<cfoutput>

['#Mission# : #DateFormat(Verify.DateEffective,CLIENT.DateFormatShow)# - #DateFormat(Verify.DateExpiration,CLIENT.DateFormatShow)#','OrganizationListing.cfm?ID1=root&Mission=#Verify.Mission#&Mandate=#Verify.MandateNo#&#Process#', 

 	 <cfquery name="Level01" dbtype="query">
    	   	SELECT TreeOrder, OrgUnitName, OrgUnit, OrgUnitCode 
		    FROM BaseSet
	   		WHERE (ParentOrgUnit is NULL OR ParentOrgUnit = '')
			ORDER BY TreeOrder, OrgUnitName
	  </cfquery>	

  <cfloop query="level01">['#Level01.OrgUnitName#','OrganizationListing.cfm?ID1=#Level01.OrgUnitCode#&Mission=#Verify.Mission#&Mandate=#Verify.MandateNo#&#Process#',
  
        <cfquery name="Level02" dbtype="query">
		      SELECT  * 
		      FROM   BaseSet
	 		  WHERE  ParentOrgUnit = '#Level01.OrgUnitCode#' 
		   	  ORDER BY TreeOrder, OrgUnitName
	  	</cfquery>
  
      <cfloop query="level02">['#Level02.OrgUnitName#','OrganizationListing.cfm?ID1=#Level02.OrgUnitCode#&Mission=#Verify.Mission#&Mandate=#Verify.MandateNo#&#Process#',
	  
	        <cfquery name="Level03" dbtype="query">
			      SELECT  * 
	    		  FROM   BaseSet
			 	  WHERE  ParentOrgUnit = '#Level02.OrgUnitCode#' 
				  ORDER BY TreeOrder, OrgUnitName
	  		</cfquery>
  
             <cfloop query="level03">['#Level03.OrgUnitName#','OrganizationListing.cfm?ID1=#Level03.OrgUnitCode#&Mission=#Verify.Mission#&Mandate=#Verify.MandateNo#&#Process#',
			 
			   <cfquery name="Level04" dbtype="query">
			      SELECT  * 
	    		  FROM   BaseSet
			 	  WHERE  ParentOrgUnit = '#Level03.OrgUnitCode#' 
				  ORDER BY TreeOrder, OrgUnitName
	  		   </cfquery>	
  
             <cfloop query="level04">['#Level04.OrgUnitName#','OrganizationListing.cfm?ID1=#Level04.OrgUnitCode#&Mission=#Verify.Mission#&Mandate=#Verify.MandateNo#&#Process#',
			 
			   <cfquery name="Level05" dbtype="query">
			      SELECT  * 
	    		  FROM   BaseSet
			 	  WHERE  ParentOrgUnit = '#Level04.OrgUnitCode#' 
				  ORDER BY TreeOrder, OrgUnitName
	  		   </cfquery>	
  
             <cfloop query="level05">['#Level05.OrgUnitName#','OrganizationListing.cfm?ID1=#Level05.OrgUnitCode#&Mission=#Verify.Mission#&Mandate=#Verify.MandateNo#&#Process#'],
	  
       	     </cfloop>],
	  
       	     </cfloop>],
			 
			 </cfloop>],
	  	  
	  </cfloop>],
  
  </cfloop>]
    
</cfoutput>

<cfelse>

<cfoutput>
['&nbsp;#Verify.Mission# <b>no mandate found for : #Effective#',null] 
</cfoutput>

</cfif>

--->



