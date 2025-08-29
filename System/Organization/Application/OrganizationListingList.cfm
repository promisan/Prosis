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
<cfset client.orgmode = "Listing">

<cfset FileNo = round(Rand()*100)>

<CF_DropTable dbName="AppsQuery" tblName="Base#SESSION.acc#_#fileNo#">	

<cfquery name="Base" 
	datasource="AppsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT   DISTINCT O.*,    (SELECT        COUNT(*) AS Expr1
                               FROM            Organization
                               WHERE        (Mission = O.Mission) AND (MandateNo = O.MandateNo) AND (ParentOrgUnit = O.OrgUnitCode)) AS hasChild

	INTO     userQuery.dbo.Base#SESSION.acc#_#fileNo#
	FROM     #LanPrefix#Organization O							
	WHERE    O.Mission   = '#URL.ID2#'
	AND      O.MandateNo = '#URL.ID3#'
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
	
	<cfquery name="SearchResult" datasource="AppsOrganization"
 
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

	<table align="center"><tr class="labelmedium2"><td><font color="FF0000">There are no items to show in this view.</td></tr></table>
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

	<table class="navigation_table" style="width:98.5%" align="center">

	<TR class="line labelmedium2 fixrow fixlengthlist">
	
		<td><cf_tl id="Hierarchy"></td>
		<td width="10"></td>
		<TD><cf_tl id="Description"></TD>
		<td><cf_tl id="Class"></td>
	    <TD><cf_tl id="Code"></TD>
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
				  Color             = "ffffff"
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
				  	
		   <cfif URL.ID1 neq "NULL" and hasChild gt "0">
	
			   	<cfquery name="Level02"
			    datasource="AppsOrganization"
			    username="#SESSION.login#"
			    password="#SESSION.dbpw#">
				    SELECT   DISTINCT *
				    FROM     userQuery.dbo.Base#SESSION.acc#_#fileNo#
					WHERE    ParentOrgUnit = '#SearchResult.OrgUnitCode#'
					ORDER BY TreeOrder
					
			   </cfquery>
			   			   	
			    <cfloop query="Level02">
				
				       					   
					   
												
						<cf_OrganizationListingDetail
							  Color             = "ffffaf"
							  Action            = "#mode#"
							  Mission           = "#URL.ID2#"
							  MandateNo         = "#SearchResult.MandateNo#"
							  OrgUnit           = "#Level02.OrgUnit#"
							  HierarchyCode     = "#Level02.HierarchyCode#"
							  OrgUnitCode       = "#Level02.OrgUnitCode#"
							  Autonomous        = "#Level02.Autonomous#"
							  OrgUnitPar        = "#SearchResult.OrgUnitCode#"
							  OrgUnitClass      = "#Level02.OrgUnitClass#"
							  OrgUnitName       = "#Level02.OrgUnitName#"
							  OrgUnitNameShort  = "#Level02.OrgUnitNameShort#">
							 
							 							 
							 							 							  
						<cfif level02.hasChild gt "0"> 
								
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
									  Color         = "ffffcf"
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
										  Color         = "fafafa"
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
									  
									   <cfquery name="Level05"
									      datasource="AppsOrganization"
									      username="#SESSION.login#"
									      password="#SESSION.dbpw#">
									       SELECT   DISTINCT *
									       FROM     userQuery.dbo.Base#SESSION.acc#_#fileNo#
										   WHERE    ParentOrgUnit = '#Level04.OrgUnitCode#'
										   ORDER BY TreeOrder
									    </cfquery>
						
									    <cfloop query="Level05">
													
												 <cf_OrganizationListingDetail
												  Color         = "fdfdfd"
												  Action        = "#mode#"
												  Mission       = "#URL.ID2#"
												  MandateNo     = "#SearchResult.MandateNo#"
												  OrgUnit       = "#Level05.OrgUnit#"
												  HierarchyCode = "#Level05.HierarchyCode#"
												  OrgUnitCode   = "#Level05.OrgUnitCode#"
												  Autonomous    = "#Level05.Autonomous#"
												  OrgUnitPar    = "#SearchResult.OrgUnitCode#"
												  OrgUnitClass  = "#Level05.OrgUnitClass#"
												  OrgUnitName   = "#Level05.OrgUnitName#"
												  OrgUnitNameShort  = "#Level05.OrgUnitNameShort#">
							
										</cfloop>
				
								</cfloop>
				
						    </cfloop>
							
						</cfif>	
		
			    </cfloop>
	
			</cfif>
	
			</cfoutput>

	</CFOUTPUT>

	<CF_DropTable dbName="AppsQuery" tblName="Base#SESSION.acc#_#fileNo#">

	</TABLE>


<cfset AjaxOnLoad("doHighlight")>