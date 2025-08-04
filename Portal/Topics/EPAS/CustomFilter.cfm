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

<cfset mission = "">

<cfloop index="itm" list="#url.mission#" delimiters="__">

	<cfif mission eq "">
		<cfset mission = "'#itm#'">
	<cfelse>
		<cfset mission = "#mission#,'#itm#'">
	</cfif>	
	
</cfloop>

<cfif url.orgunit neq "">

	<cfquery name="get" 
	     datasource="AppsOrganization" 
	     username="#SESSION.login#" 
	     password="#SESSION.dbpw#">	
		 SELECT * 
		 FROM   Organization 
		 WHERE  OrgUnit = '#url.orgunit#' 
	</cfquery>
	
</cfif>

<cfquery name="getCategory" 
     datasource="AppsEmployee" 
     username="#SESSION.login#" 
     password="#SESSION.dbpw#">	 
		SELECT    *
		FROM      Ref_PostGradeParent
		WHERE     Code IN (SELECT PostGradeParent 
		                   FROM   Ref_PostGradeParentMission 
						   WHERE  Mission = '#url.mission#')					   
		ORDER BY ViewOrder				   		
</cfquery>	

<cfif getCategory.recordcount eq "0">

	<cfquery name="getCategory" 
	     datasource="AppsEmployee" 
	     username="#SESSION.login#" 
	     password="#SESSION.dbpw#">	 
			SELECT    *
			FROM      Ref_PostGradeParent		
						   
			ORDER BY ViewOrder				   		
	</cfquery>	

</cfif>

<cfquery name="getClass" 
     datasource="AppsEmployee" 
     username="#SESSION.login#" 
     password="#SESSION.dbpw#">	 
		SELECT    DISTINCT R.PostClass, R.Description
	    FROM      Position AS P, Ref_PostClass R
		WHERE     P.PostClass = R.PostClass 		  
	    AND       P.Mission = '#url.mission#' 
		AND       P.DateEffective <= GETDATE() AND P.DateExpiration > GETDATE()	   
		<cfif url.orgunit neq "">
		AND       P.OrgUnitOperational IN (SELECT OrgUnit 
		                                 FROM   Organization.dbo.Organization
										 WHERE  Mission   = '#url.mission#'
										 AND    MandateNo = '#get.MandateNo#'
										 AND    HierarchyCode LIKE ('#get.HierarchyCode#%')
										)  
		</cfif>	    
</cfquery>	


<cfquery name="getContractClass" 
     datasource="AppsEmployee" 
     username="#SESSION.login#" 
     password="#SESSION.dbpw#">	 
		SELECT    *
		FROM      ePas.dbo.Ref_ContractClass
		ORDER BY ListingOrder
		<!--- WHERE     Code IN (SELECT ContractClass 
		                   FROM   ePas.dbo.Contract 
						   WHERE  Mission = '#url.mission#')					   				   		
						   --->
</cfquery>	


<cfset link = "#session.root#/Portal/Topics/ePas/ePas.cfm?mission=#url.mission#&orgunit=#url.orgunit#&period=#url.period#">

<cfoutput>

	<table width="100%">	
	
		<cfset mis = replace(URL.mission, "-", "", "ALL")>
		<cfset box = "pane_#targetbox#_EPas_#mis#">
			    
	    <tr><td style="padding-left:10px">
		
			    <table>
			    <tr class="labelit" style="font-size:12px">				
								
				<td style="padding-left:10px" ><cf_tl id="Staff"></td>
											
					<td class="label" style="color:gray;padding-left:4px">	
					  <select class="regularxl" id="fldfund_#url.mission#" 
					       onchange="doChangePAS('#link#','#box#',this,document.getElementById('fldpostclass_#url.mission#'),getElementById('fldcategory_#url.mission#'),getElementById('fldauthorised_#url.mission#'))">					 		
					       <option value="">ANY</option>
						  <cfloop query="getCategory">				  
						  	<option value="#Code#">#Code# #Description#</option>					  
						  </cfloop>
					  </select>	
				</td>						
								
				<td style="padding-left:10px"><cf_tl id="Post"></td>
				
				<td class="label" style="color:gray;padding-left:4px">	
					  <select class="regularxl" id="fldpostclass_#url.mission#" 
					       onchange="doChangePAS('#link#','#box#',document.getElementById('fldfund_#url.mission#'),this,getElementById('fldcategory_#url.mission#'),getElementById('fldauthorised_#url.mission#'))">					 		
					       <option value="">ANY</option>
						  <cfloop query="getClass">				  
						  	<option value="#PostClass#">#Description#</option>					  
						  </cfloop>
					  </select>	
				</td>		
				
				<td style="padding-left:10px"><cf_tl id="Appraisal"></td>
				
				<td class="label" style="color:gray;padding-left:4px">	
				
					 <select class="regularxl" id="fldcategory_#url.mission#" 
					       onchange="doChangePAS('#link#','#box#',document.getElementById('fldfund_#url.mission#'),getElementById('fldpostclass_#url.mission#'),this,getElementById('fldauthorised_#url.mission#'))">					 		
					       <option value="">ANY</option>
						  <cfloop query="getContractClass">				  
						  	<option value="#Code#">#Description#</option>					  
						  </cfloop>
					  </select>	
					 
				</td>		
				
				<td style="padding-left:10px"><cf_tl id="Authorised"></td>
				
				<td class="label" style="color:gray;padding-left:4px">	
				       
					  <select class="regularxl" id="fldauthorised_#url.mission#" 
					       onchange="doChangePAS('#link#','#box#',document.getElementById('fldfund_#url.mission#'),getElementById('fldpostclass_#url.mission#'),getElementById('fldcategory_#url.mission#'),this)">					 		
					       <option value="">All</option>
						   <option value="1">Authorised</option>						 
						   <option value="0">Non-authorised</option>	
					  </select>	
				</td>														
					
				</tr>
				</table>
				
			</td>
		</tr>
	</table>
	
</cfoutput>