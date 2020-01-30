
<cfset client.orgmode = "Listing">

<cfset FileNo = round(Rand()*100)>

<CF_DropTable dbName="AppsQuery" tblName="Base#SESSION.acc#_#fileNo#">	

<cfquery name="Base" 
	datasource="AppsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT distinct O.*
	INTO userQuery.dbo.Base#SESSION.acc#_#fileNo#
	FROM #LanPrefix#Organization O							
	WHERE O.Mission = '#URL.ID2#'
	AND O.MandateNo = '#URL.ID3#'
	ORDER BY O.Mission, TreeOrder
</cfquery>
  
<!--- Query returning search results --->

<cfif URL.ID1 eq "NULL">
  <cfset cond = "AND HierarchyCode is NULL">
<cfelseif URL.ID1 eq "all">
   <cfset cond = "AND (ParentOrgUnit IS NULL or ParentOrgUnit = '')">
<cfelse>
   <cfset cond = "AND OrgUnit = '#URL.ID1#'">
</cfif>

<cfif URL.ID1 neq "NULL">
	
	<cfquery name="SearchResult"
         datasource="AppsOrganization"         
         username="#SESSION.login#"
         password="#SESSION.dbpw#">
		SELECT distinct *
	    FROM   userQuery.dbo.Base#SESSION.acc#_#fileNo#							
		WHERE  1=1
		#preserveSingleQuotes(cond)# 
		ORDER BY TreeOrder
	</cfquery>

<cfelse>
	
	<cfquery name="SearchResult" 
	datasource="AppsOrganization"
 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT   DISTINCT *
	FROM     userQuery.dbo.Base#SESSION.acc#_#fileNo#	
	WHERE    1=1
	AND      HierarchyCode IS NULL 	
	ORDER BY TreeOrder
	</cfquery>

</cfif>

<cfif searchResult.recordcount eq "0">

	<table align="center"><tr><td><font color="FF0000">There are no items to show in this view.</td></tr></table>
	<cfabort>

</cfif>

<cfif searchResult.recordcount eq "0">
   <cfset man = URL.ID3>
<cfelse>
   <cfset man = SearchResult.MandateNo>
</cfif>   


<cfinvoke component="Service.Access"
  method="org" 
  orgunit="#SearchResult.OrgUnit#" 
  mission="#URL.ID2#"
  returnvariable="myaccess">

	<table class="navigation_table" width="98%" align="center">

	<TR class="line labelmedium">
		<td><cf_tl id="Hierarchy"></td>
		<td width="10"></td>
		<TD><cf_tl id="Description"></TD>
		<td><cf_tl id="Class"></td>
	    <TD width="95"><cf_tl id="Code"></TD>
		<td></td>
	</TR>


	<cfoutput query="SearchResult" group="TreeOrder">

	<cfoutput>

	   	 <CFIF myAccess EQ "ALL" or myAccess EQ "EDIT" or url.id4 eq "Limited">
		     <cfset mode = "Edit">
		 <cfelse>
		     <cfset mode = "View">
		 </cfif>

		 <cf_OrganizationListingDetail
		  Color             = "yellow"
		  Action            = "#mode#"
		  Mission           = "#URL.ID2#"
		  MandateNo         = "#SearchResult.MandateNo#"
		  OrgUnit           = "#SearchResult.OrgUnit#"
		  HierarchyCode     = "#SearchResult.HierarchyCode#"
		  OrgUnitCode       = "#SearchResult.OrgUnitCode#"
		  Autonomous        = "#SearchResult.Autonomous#"
		  OrgUnitPar        = "#SearchResult.OrgUnitCode#"
		  OrgUnitClass      = "#SearchResult.OrgUnitClass#"
		  OrgUnitName       = "#SearchResult.OrgUnitName#"
		  OrgUnitNameShort  = "#SearchResult.OrgUnitNameShort#">

	   <cfif URL.ID1 neq "NULL">

		   	<cfquery name="Level02"
		    datasource="AppsOrganization"
		    username="#SESSION.login#"
		    password="#SESSION.dbpw#">
		    SELECT DISTINCT *
		    FROM   userQuery.dbo.Base#SESSION.acc#_#fileNo#
			WHERE  ParentOrgUnit = '#SearchResult.OrgUnitCode#'
			ORDER BY TreeOrder
		   </cfquery>

	    <cfloop query="Level02">

				 <cf_OrganizationListingDetail
			  Color         = "ffffaf"
			  Action        = "#mode#"
			  Mission       = "#URL.ID2#"
			  MandateNo     = "#SearchResult.MandateNo#"
			  OrgUnit       = "#Level02.OrgUnit#"
			  HierarchyCode = "#Level02.HierarchyCode#"
			  OrgUnitCode   = "#Level02.OrgUnitCode#"
			  Autonomous    = "#Level02.Autonomous#"
			  OrgUnitPar    = "#SearchResult.OrgUnitCode#"
			  OrgUnitClass  = "#Level02.OrgUnitClass#"
			  OrgUnitName   = "#Level02.OrgUnitName#"
			  OrgUnitNameShort  = "#Level02.OrgUnitNameShort#">

			  	<cfquery name="Level03"
		      datasource="AppsOrganization"
		      username="#SESSION.login#"
		      password="#SESSION.dbpw#">
		       SELECT   DISTINCT *
		       FROM     userQuery.dbo.Base#SESSION.acc#_#fileNo#
			   WHERE    ParentOrgUnit = '#Level02.OrgUnitCode#'
			   ORDER BY TreeOrder
		    </cfquery>

		    <cfloop query="Level03">

					 <cf_OrganizationListingDetail
				  Color         = "f4f4f4"
				  Action        = "#mode#"
				  Mission       = "#URL.ID2#"
				  MandateNo     = "#SearchResult.MandateNo#"
				  OrgUnit       = "#Level03.OrgUnit#"
				  HierarchyCode = "#Level03.HierarchyCode#"
				  OrgUnitCode   = "#Level03.OrgUnitCode#"
				  Autonomous    = "#Level03.Autonomous#"
				  OrgUnitPar    = "#SearchResult.OrgUnitCode#"
				  OrgUnitClass  = "#Level03.OrgUnitClass#"
				  OrgUnitName   = "#Level03.OrgUnitName#"
			      OrgUnitNameShort  = "#Level03.OrgUnitNameShort#">

				 	  <cfquery name="Level04"
			      datasource="AppsOrganization"
			      username="#SESSION.login#"
			      password="#SESSION.dbpw#">
			       SELECT   DISTINCT *
			       FROM     userQuery.dbo.Base#SESSION.acc#_#fileNo#
				   WHERE    ParentOrgUnit = '#Level03.OrgUnitCode#'
				   ORDER BY TreeOrder
			    </cfquery>

			    <cfloop query="Level04">

						 <cf_OrganizationListingDetail
					  Color         = "ffffff"
					  Action        = "#mode#"
					  Mission       = "#URL.ID2#"
					  MandateNo     = "#SearchResult.MandateNo#"
					  OrgUnit       = "#Level04.OrgUnit#"
					  HierarchyCode = "#Level04.HierarchyCode#"
					  OrgUnitCode   = "#Level04.OrgUnitCode#"
					  Autonomous    = "#Level04.Autonomous#"
					  OrgUnitPar    = "#SearchResult.OrgUnitCode#"
					  OrgUnitClass  = "#Level04.OrgUnitClass#"
					  OrgUnitName   = "#Level04.OrgUnitName#"
					  OrgUnitNameShort  = "#Level04.OrgUnitNameShort#">

				</cfloop>

		    </cfloop>

	    </cfloop>

		</cfif>

		</cfoutput>

	</CFOUTPUT>

	<CF_DropTable dbName="AppsQuery" tblName="Base#SESSION.acc#_#fileNo#">

	</TABLE>


<cfset AjaxOnLoad("doHighlight")>