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
<cfquery name="Mandate" 
   datasource="AppsOrganization"  
   username="#SESSION.login#" 
   password="#SESSION.dbpw#">
		SELECT TOP 1  *
		FROM       Ref_Mandate
		WHERE      Mission = '#Mission#'
		ORDER BY   MandateDefault DESC, MandateNo DESC
</cfquery>
	      
<cfset MandateNo = Mandate.MandateNo>
    
  <!--- /tools/process/tree --->
  
<cf_treeunitList mission="#mission#" role="'AssetHolder','AssetUser'">
	  
<!--- only relevant units and tree parents
	 to be shown for which access is defined also in prior periods --->	  
	  
 <cfsavecontent variable="showunit">
    
	<cfoutput>
  
          AND CONVERT(varchar(38), MissionOrgUnitId) + '_' + MandateNo IN
		  (	
		  SELECT    CONVERT(varchar(38), MissionOrgUnitId) + '_' + MAX(MandateNo)
		  FROM      Organization
		  WHERE     Mission = '#Mission#'	
		  <cfif accesslist neq "" and accesslist neq "full">
			  AND OrgUnit IN (#preserveSingleQuotes(accesslist)#)			 	  
		  <cfelseif accesslist neq "full">
		  	  AND 1 = 0
		  </cfif>
		  GROUP BY MissionOrgUnitId	
		  )
		  
	</cfoutput>	  
 
 </cfsavecontent>	

	<cfswitch expression="#Level#">
	
	<cfcase value="1">
	
			  <cfquery name="Level01" 
			    datasource="AppsOrganization" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				SELECT O.TreeOrder, O.OrgUnitNameShort as OrgUnitName, O.OrgUnit, O.OrgUnitCode, 
						(  SELECT Count(*)
						   FROM   Organization O2 INNER JOIN Userquery.dbo.#SESSION.acc##Mission#AssetTree A2	ON O2.OrgUnit = A2.OrgUnit
						   WHERE  O2.HierarchyCode like O.HierarchyCode+'%'
						   AND    O2.Mission     = '#Mission#'
				  		   AND    O2.MandateNo   = '#MandateNo#' ) as Counted
			    FROM   #Client.LanPrefix#Organization O LEFT OUTER JOIN Userquery.dbo.#SESSION.acc##Mission#AssetTree A	ON O.OrgUnit = A.OrgUnit
			   	WHERE  (O.ParentOrgUnit is NULL OR O.ParentOrgUnit = '')
				<cfif accesslist neq "full">	
					 #preservesinglequotes(showunit)#	
				</cfif>				
				AND    O.Mission = '#Mission#'
				AND    O.MandateNo = '#MandateNo#'
				GROUP BY O.TreeOrder, O.OrgUnitNameShort, O.OrgUnit, O.OrgUnitCode, O.HierarchyCode 		  	
				ORDER BY TreeOrder, OrgUnitName
				
				</cfquery>
					  	  
				<cfloop query="level01">	
						
					 <cfset s = StructNew()> 		
				 	 <cfset s.value="#orgunitcode#">
				     <cfset s.display="<span class='labelit'>#Level01.OrgUnitName#<font color='53A9FF'>(#counted#)</span>">
					 <cfset s.parent="organization">
					 <cfset s.expand="No">
					 <cfset s.href="javascript:listshow('ORG','#Level01.OrgUnit#','#mission#')">	
					 <cfset arrayAppend(result,s)/>									 
					 
				      <cfquery name="Children" 
				      datasource="AppsOrganization" 
				      username="#SESSION.login#" 
				      password="#SESSION.dbpw#">
					      SELECT Count(1) as Total
					      FROM     #Client.LanPrefix#Organization O 
						           INNER JOIN Userquery.dbo.#SESSION.acc##Mission#AssetTree A ON A.HierarchyCode LIKE O.HierarchyCode+'%'
					 	  WHERE    O.ParentOrgUnit = '#orgunitcode#'
						  AND      O.Mission       = '#Mission#'
						  AND      O.MandateNo   = '#MandateNo#'
						  <cfif accesslist neq "full">	
						          #preservesinglequotes(showunit)#	
					 	  </cfif>		
					  </cfquery>
					  				
					  <cfif Children.total eq 0>
						     <cfset s.leafnode=true/>
					  </cfif>						 
						  
				</cfloop>
	
	</cfcase>			
	
	<cfcase value="2,3,4,5,6">

	      <cfquery name="SubLevel" 
	      datasource="AppsOrganization" 
	      username="#SESSION.login#" 
	      password="#SESSION.dbpw#">
	      SELECT O.TreeOrder, O.OrgUnitNameShort as OrgUnitName, O.OrgUnit, O.OrgUnitCode , Count(*) as counted
	      FROM     #Client.LanPrefix#Organization O 
		           INNER JOIN Userquery.dbo.#SESSION.acc##Mission#AssetTree A ON A.HierarchyCode LIKE O.HierarchyCode+'%'
	 	  WHERE    O.ParentOrgUnit = '#vmid#'
		  AND      O.Mission       = '#Mission#'
		  AND      O.MandateNo   = '#MandateNo#'
		  <cfif accesslist neq "full">	
		    #preservesinglequotes(showunit)#	
	 	  </cfif>		
		  GROUP BY  O.TreeOrder, O.OrgUnitNameShort, O.OrgUnit, O.OrgUnitCode
		  ORDER BY O.TreeOrder, O.OrgUnitNameShort
		  </cfquery>		
		
     		<cfloop query="SubLevel">
		
			<cfset s = StructNew()> 	
			<cfset s.value="#orgunitcode#">
       		<cfset s.display="<span class='labelit'>#SubLevel.OrgUnitName#<font color='53A9FF'>(#counted#)</font></span>">
			<cfset s.parent="#vmid#">
			<cfset s.expand="No">
			<cfset s.href="javascript:listshow('ORG','#SubLevel.OrgUnit#','#mission#')">						

		      <cfquery name="Children" 
		      datasource="AppsOrganization" 
		      username="#SESSION.login#" 
		      password="#SESSION.dbpw#">
			      SELECT   Count(1) as total
			      FROM     #Client.LanPrefix#Organization O 
				           INNER JOIN Userquery.dbo.#SESSION.acc##Mission#AssetTree A ON A.HierarchyCode LIKE O.HierarchyCode+'%'
			 	  WHERE    O.ParentOrgUnit = '#OrgUnitCode#'
				  AND      O.Mission       = '#Mission#'
				  AND      O.MandateNo     = '#MandateNo#'
				  <cfif accesslist neq "full">	
				    #preservesinglequotes(showunit)#	
			 	  </cfif>		
			  </cfquery>							

			<cfif Level eq 6 or children.total eq 0>
				<cfset s.leafnode=true/>
			</cfif>
			<cfset arrayAppend(result,s)/>		
		</cfloop>					
		
	</cfcase>
	
	</cfswitch>

	<cfif level eq 1>
		<cf_tl id = "Pending unit association" var = "vOrphaned">
		<cfset s = StructNew()> 	
		<cfset s.value="Orphaned">
		<cfset s.display="<span class='labelit'>#vOrphaned#</span>">
		<cfset s.parent="organization">
		<cfset s.expand="No">
		<cfset s.href="javascript:listshow('ORPH','#MandateNo#','#mission#')">				
		<cfset s.leafnode=true/>
		<cfset arrayAppend(result,s)/>	
	</cfif>