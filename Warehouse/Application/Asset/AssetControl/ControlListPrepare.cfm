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
<cfparam name="URL.ID2" default="">

<!--- -------------------------------------------- --->
<!--- -----------------get assets data------------ --->
<!--- -------------------------------------------- --->

<cfif url.id eq "Per">

	<cfinvoke component = "Service.Process.Materials.Asset"  
			   method           = "AssetList" 
			   mission          = "#url.id2#"		  
			   table            = "#SESSION.acc#Asset">		
		   
<cfelse>

	<cfinvoke component = "Service.Process.Materials.Asset"  
			   method           = "AssetList" 
			   mission          = "#url.id2#"		
			   AssetEnabled     = "Any"
			   role             = "'AssetHolder','AssetUser'"  
			   table            = "#SESSION.acc#Asset">		

</cfif>		   
		   
<!--- set the filter --->		   

<cfswitch expression="#URL.ID#">

	<cfcase value="Per">	
	    <cfset condition = "AND Mission = '#URL.Mission#' AND AssetClass IN (SELECT Category FROM Materials.dbo.Ref_Category WHERE SensitivityLevel = 0) AND PersonNo = '#URL.ID1#'">		
	</cfcase>	

    <cfcase value="Tod">
	    <cfset condition = "AND InspectionDate = '#DateFormat(now(),CLIENT.DateSQL)#'">
	</cfcase>	
	
	<cfcase value="Rec">
	    <cfset condition = "AND Created >= '#DateFormat(now()-1,CLIENT.DateSQL)#'">
	</cfcase>	
	
	<cfcase value="Loc">
	    <cfset condition = "">
	</cfcase>
	
	<cfcase value="Phy">
	    <cfset condition = "AND Location = '#URL.ID1#'">
	</cfcase>
	
	<cfcase value="Mas">
	    <cfset condition = "AND AssetClass IN (SELECT Category FROM Materials.dbo.Ref_Category WHERE ItemMaster = '#URL.ID1#')">
	</cfcase>
	
	<cfcase value="Cls">
	    <cfset condition = "AND AssetClass = '#URL.ID1#'">
	</cfcase>
	
	<cfcase value="Itm">
	    <cfset condition = "AND ItemNo IN (SELECT ItemNo FROM Materials.dbo.Item I, Materials.dbo.Ref_CategoryItem R WHERE I.Category = R.Category AND I.CategoryItem = R.CategoryItem AND CategoryItemId = '#URL.ID1#')">		
	</cfcase>
	
	<cfcase value="IMK">
	    <cfset condition = "AND AssetId IN (SELECT A.AssetId FROM Materials.dbo.Item I, Materials.dbo.Ref_CategoryItem R, Materials.dbo.AssetItem A WHERE I.Category = R.Category AND I.CategoryItem = R.CategoryItem AND CategoryItemId = '#URL.ID1#' AND A.ItemNo=I.ItemNo AND A.Make = '#URL.ID3#')">		
	</cfcase>

	<cfcase value="Org">
	
		<CF_DropTable dbName="AppsQuery"  tblName="#SESSION.acc#Asset2">	
		
		<cfquery name="Org1" 
		datasource="AppsOrganization" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT     *
			FROM       Organization
			WHERE      OrgUnit = '#URL.ID1#'
		</cfquery>
						
		<!--- retrieve org units equal or under including prior mandates --->
		<cfquery name="Org2" 
		datasource="AppsOrganization" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT    OrgUnit
			INTO      userQuery.dbo.#SESSION.acc#Asset2
		    FROM      Organization
		    WHERE     MissionOrgUnitId IN (						 
							   SELECT    MissionOrgUnitId
			                    FROM     Organization
			                   WHERE     Mission   = '#Org1.Mission#' 
							     AND     MandateNo = '#Org1.MandateNo#' 
								 AND     HierarchyCode LIKE '#Org1.HierarchyCode#%'
						  )				  
		</cfquery>		
	
		<cfset condition = "AND OrgUnit IN (SELECT OrgUnit FROM userQuery.dbo.#SESSION.acc#Asset2)">				

	</cfcase>

	<cfcase value = "orph">

		<cfquery name="Org2" 
		datasource="AppsOrganization" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT    OrgUnit
		INTO      userQuery.dbo.#SESSION.acc#Asset2
	    FROM      Organization
	    WHERE     MissionOrgUnitId IN (						 
						   SELECT    MissionOrgUnitId
		                    FROM     Organization
		                   WHERE     Mission   = '#URL.ID2#' 
						     AND     MandateNo = '#URL.ID1#' 
						  )				  
		</cfquery>		
	
		<cfset condition = "AND OrgUnit NOT IN (SELECT OrgUnit FROM userQuery.dbo.#SESSION.acc#Asset2)">				
	
	</cfcase>

</cfswitch>

<!--- filter based on the asset holder access rights --->
	
<CF_DropTable dbName="AppsQuery"  tblName="#SESSION.acc#AssetBase#url.id#">	

<cfquery name="Base" 
  datasource="appsQuery" 
  username="#SESSION.login#" 
  password="#SESSION.dbpw#">
  SELECT   * 
  INTO     dbo.#SESSION.acc#AssetBase#url.id#	
  FROM     #SESSION.acc#Asset I
  WHERE    <cfif url.id eq "loc"> 1=1 <cfelse> I.Operational = '1' </cfif>	
           #preserveSingleQuotes(condition)#			
  ORDER BY Description 	
</cfquery>


<CF_DropTable dbName="AppsQuery"  tblName="#SESSION.acc#Asset2">	

