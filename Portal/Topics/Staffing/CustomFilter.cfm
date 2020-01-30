
<cfset mission = "">

<cfloop index="itm" list="#url.mission#" delimiters="__">

	<cfif mission eq "">
		<cfset mission = "'#itm#'">
	<cfelse>
		<cfset mission = "#mission#,'#itm#'">
	</cfif>	
	
</cfloop>

<cfif url.orgunit eq "null">
	<cfset url.orgunit = "">
</cfif>

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
											 WHERE  Mission   = '#url.mission#'
											 AND    MandateNo = '#get.MandateNo#'
											 AND    HierarchyCode LIKE ('#get.HierarchyCode#%')
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
											 AND    HierarchyCode LIKE ('#get.HierarchyCode#%')
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
										 AND    HierarchyCode LIKE ('#get.HierarchyCode#%')
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
			    <tr class="labelit" style="font-size:12px">				
								
				<td style="padding-left:10px" ><cf_tl id="Fund">:</td>
											
					<td class="label" style="color:gray;padding-left:4px">	
					  <select class="regularxl" id="fldfund_#url.mission#" 
					       onchange="doChangeStaffing('#link#','#box#',this,document.getElementById('fldpostclass_#url.mission#'),getElementById('fldcategory_#url.mission#'),getElementById('fldauthorised_#url.mission#'))">					 		
					       <option value="">ANY</option>
						  <cfloop query="getFund">				  
						  	<option value="#Fund#">#Fund#</option>					  
						  </cfloop>
					  </select>	
				</td>						
								
				<td style="padding-left:10px"><cf_tl id="Post class">:</td>
				
				<td class="label" style="color:gray;padding-left:4px">	
					  <select class="regularxl" id="fldpostclass_#url.mission#" 
					       onchange="doChangeStaffing('#link#','#box#',document.getElementById('fldfund_#url.mission#'),this,getElementById('fldcategory_#url.mission#'),getElementById('fldauthorised_#url.mission#'))">					 		
					       <option value="">ANY</option>
						  <cfloop query="getClass">				  
						  	<option value="#PostClass#">#Description#</option>					  
						  </cfloop>
					  </select>	
				</td>		
				
				<td style="padding-left:10px"><cf_tl id="Category">:</td>
				
				<td class="label" style="color:gray;padding-left:4px">	
					  <select class="regularxl" id="fldcategory_#url.mission#" 
					       onchange="doChangeStaffing('#link#','#box#',document.getElementById('fldfund_#url.mission#'),getElementById('fldpostclass_#url.mission#'),this,getElementById('fldauthorised_#url.mission#'))">					 		
					       <option value="All">All</option>
						   <option value="Total">Total</option>						 
					  </select>	
				</td>		
				
				<td style="padding-left:10px"><cf_tl id="Authorised">:</td>
				
				<td class="label" style="color:gray;padding-left:4px">	
				       
					  <select class="regularxl" id="fldauthorised_#url.mission#" 
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