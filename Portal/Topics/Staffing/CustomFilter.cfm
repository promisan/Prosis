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
<cfset mission = "">

<cfloop index="itm" list="#url.mission#" delimiters="__">

	<cfif mission eq "">
		<cfset mission = "'#itm#'">
	<cfelse>
		<cfset mission = "#mission#,'#itm#'">
	</cfif>	
	
</cfloop>


<cfset org = "">

<cfif url.orgunit neq "" and url.orgunit neq "null">
	
	<cfloop index="itm" list="#url.orgunit#">
         <cfif org eq "">
		 	<cfset org = "'#itm#'">
		 <cfelse>
		   	<cfset org = "#org#,'#itm#'">
		 </cfif>
	</cfloop>

	<cfquery name="get" 
	     datasource="AppsOrganization" 
	     username="#SESSION.login#" 
	     password="#SESSION.dbpw#">	
			 SELECT  * 
			 FROM    Organization 		
	    	 WHERE   OrgUnit IN (#preserveSingleQuotes(org)#) 
	</cfquery>
	
	<cfset conorg = "">
	
	<cfloop query="get">
		
		<cfif conorg eq "">
			<cfset conorg = "HierarchyCode LIKE ('#hierarchyCode#%')">
		<cfelse>
			<cfset conorg = "#conorg# OR HierarchyCode LIKE ('#hierarchyCode#%')">
		</cfif>
	
	</cfloop>
	
</cfif>

<cfquery name="Param" 
	     datasource="AppsEmployee" 
	     username="#SESSION.login#" 
	     password="#SESSION.dbpw#">	
		 SELECT * 
		 FROM   Ref_ParameterMission 
		 WHERE  Mission = '#url.mission#' 		 
</cfquery>

<cfif Param.ShowPositionFund eq "1">
	
	<cfquery name="getFund" 
	     datasource="AppsEmployee" 
	     username="#SESSION.login#" 
	     password="#SESSION.dbpw#">	 
			SELECT    DISTINCT PP.Fund
		    FROM      Position AS P INNER JOIN
		              PositionParent PP ON P.PositionParentId = PP.PositionParentId				  
		    WHERE     P.Mission = '#url.mission#' 
			AND       P.DateEffective <= GETDATE() AND P.DateExpiration > GETDATE()	   
			<cfif url.orgunit neq "">
			AND       P.OrgUnitOperational IN (SELECT OrgUnit 
			                                 FROM   Organization.dbo.Organization
											 WHERE  Mission      = '#url.mission#'
											 AND    MandateNo    = '#get.MandateNo#'
											 AND    (#preservesingleQuotes(conorg)#)
											)  
			</cfif>	    
	</cfquery>	

<cfelse>
	
	<cfquery name="getFund" 
	     datasource="AppsEmployee" 
	     username="#SESSION.login#" 
	     password="#SESSION.dbpw#">	 
			SELECT    DISTINCT PP.Fund
		    FROM      Position AS P INNER JOIN
		              PositionParentFunding PP ON P.PositionParentId = PP.PositionParentId				  
		    WHERE     P.Mission = '#url.mission#' 
			AND       P.DateEffective <= GETDATE() AND P.DateExpiration > GETDATE()	   
			<cfif url.orgunit neq "">
			AND       P.OrgUnitOperational IN (SELECT OrgUnit 
			                                 FROM   Organization.dbo.Organization
											 WHERE  Mission   = '#url.mission#'
											 AND    MandateNo = '#get.MandateNo#'
											 AND    (#preservesingleQuotes(conorg)#)
											)  
			</cfif>	    
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
										   AND    (#preservesingleQuotes(conorg)#)
										  )  
		</cfif>	    
</cfquery>	

<cfset link = "#session.root#/Portal/Topics/Staffing/Staffing.cfm?mission=#url.mission#&orgunit=#url.orgunit#&period=#url.period#">

<cfoutput>

	<table width="100%">	
	
		<cfset mis = replace(URL.mission, "-", "", "ALL")>
		<cfset box = "pane_#targetbox#_Staffing_#mis#">
			    
	    <tr><td style="padding-left:10px">
		
			    <table>
			    <tr class="labelmediun2">				
								
				<td style="padding-left:10px" ><cf_tl id="Fund"></td>
											
					<td style="padding-left:4px">	
					  <select class="regularxxl" style="background-color:f1f1f1;border:0px" id="fldfund_#url.mission#" 
					       onchange="doChangeStaffing('#link#','#box#',this,document.getElementById('fldpostclass_#url.mission#'),getElementById('fldcategory_#url.mission#'),getElementById('fldauthorised_#url.mission#'))">					 		
					       <option value="">ANY</option>
						  <cfloop query="getFund">				  
						  	<option value="#Fund#">#Fund#</option>					  
						  </cfloop>
					  </select>	
				</td>						
								
				<td style="padding-left:10px"><cf_tl id="Class"></td>
				
				<td style="color:gray;padding-left:4px">	
					  <select style="background-color:f1f1f1;border:0px" class="regularxxl" id="fldpostclass_#url.mission#" 
					       onchange="doChangeStaffing('#link#','#box#',document.getElementById('fldfund_#url.mission#'),this,getElementById('fldcategory_#url.mission#'),getElementById('fldauthorised_#url.mission#'))">					 		
					       <option value="">ANY</option>
						  <cfloop query="getClass">				  
						  	<option value="#PostClass#">#Description#</option>					  
						  </cfloop>
					  </select>	
				</td>		
				
				<td style="padding-left:10px"><cf_tl id="Category"></td>
				
				<td style="color:gray;padding-left:4px">	
					  <select style="background-color:f1f1f1;border:0px" class="regularxxl" id="fldcategory_#url.mission#" 
					       onchange="doChangeStaffing('#link#','#box#',document.getElementById('fldfund_#url.mission#'),getElementById('fldpostclass_#url.mission#'),this,getElementById('fldauthorised_#url.mission#'))">					 		
					       <option value="All">All</option>
						   <option value="Total">Total</option>						 
					  </select>	
				</td>		
				
				<td style="padding-left:10px"><cf_tl id="Authorised"></td>
				
				<td style="color:gray;padding-left:4px">	
				       
					  <select style="background-color:f1f1f1;border:0px" class="regularxxl" id="fldauthorised_#url.mission#" 
					       onchange="doChangeStaffing('#link#','#box#',document.getElementById('fldfund_#url.mission#'),getElementById('fldpostclass_#url.mission#'),getElementById('fldcategory_#url.mission#'),this)">					 		
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