
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
	 
	   SELECT    P.Code, 
	             P.Description as CategoryDescription, 
				 P.ViewOrder, 
				 T.ListingOrder, 
				 T.PostType, 
				 T.Description
	   FROM      Ref_PostGradeParent P INNER JOIN Ref_PostType T ON P.PostType = T.PostType		
	   WHERE     Code IN (SELECT PostGradeParent 
		                   FROM   Ref_PostGradeParentMission 
						   WHERE  Mission = '#url.mission#')		
		AND       Code IN (SELECT PostGradeParent FROM Ref_PostGrade)						   
	   ORDER BY  T.ListingOrder, P.ViewOrder				 	  	   		
</cfquery>	

<cfif getCategory.recordcount eq "0">

	<cfquery name="getCategory" 
	     datasource="AppsEmployee" 
	     username="#SESSION.login#" 
	     password="#SESSION.dbpw#">	 
			SELECT    P.Code, P.Description as CategoryDescription, P.ViewOrder, T.ListingOrder, T.PostType, T.Description
			FROM      Ref_PostGradeParent P INNER JOIN Ref_PostType T ON P.PostType = T.PostType						   
			ORDER BY  T.ListingOrder, P.ViewOrder				   		
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

<cfset link = "#session.root#/Portal/Topics/PersonDiversity/Staffing.cfm?mission=#url.mission#&orgunit=#url.orgunit#&period=#url.period#">

	<table width="100%">	
	
		<cfset mis = replace(URL.mission, "-", "", "ALL")>
		<cfset box = "pane_#targetbox#_diversity_#mis#">
			    
	    <tr>
		
		<td style="padding-left:10px;width:100%">
		
			    <table width="100%">
			    <tr class="labelit" style="font-size:12px">				
								
				<td style="padding-top:2px;padding-left:10px;border-bottom:1px solid silver;border-left:1px solid silver" ><cf_tl id="Category">:</td>
											
					<td class="label" style="color:gray;padding-left:4px;border-bottom:1px solid silver;">	
										 
					  <select style="border:0px" class="regularxl" id="<cfoutput>fldfund_#url.mission#</cfoutput>" 
					       onchange="<cfoutput>doChangeFilter('#link#','#box#',this,document.getElementById('fldpostclass_#url.mission#'),getElementById('fldcategorydiv_#url.mission#'),getElementById('fldauthorised_#url.mission#'))</cfoutput>">					 		
					       <option value="">ALL</option>
						  <cfoutput query="getCategory" group="PostType">
						      <option value="TPE_#PostType#"><b>#Description#</option>	 
							  <cfoutput>				  
							  	<option value="#Code#">&nbsp;&nbsp;&nbsp;#CategoryDescription#</option>					  
							  </cfoutput>
						  </cfoutput>
					  </select>	
					 
				</td>		
				
				<cfoutput>				
								
				<td style="padding-top:2px;padding-left:10px;border-bottom:1px solid silver;border-left:1px solid silver"><cf_tl id="Class">:</td>
				
				<td class="label" style="color:gray;padding-left:4px;border-bottom:1px solid silver;">	
					  <select style="border:0px" class="regularxl" id="fldpostclass_#url.mission#" 
					       onchange="doChangeFilter('#link#','#box#',document.getElementById('fldfund_#url.mission#'),this,getElementById('fldcategorydiv_#url.mission#'),getElementById('fldauthorised_#url.mission#'))">					 		
					       <option value="">ANY</option>
						  <cfloop query="getClass">				  
						  	<option value="#PostClass#">#Description#</option>					  
						  </cfloop>
					  </select>	
				</td>		
				
				<td style="padding-top:2px;padding-left:10px;border-left:1px solid silver;border-bottom:1px solid silver;"><cf_tl id="Incumbency">:</td>
				
				<td class="label" style="color:gray;padding-left:4px;border-bottom:1px solid silver;">	
					  <select  style="border:0px;width:60px;" class="regularxl" id="fldcategorydiv_#url.mission#" 
					       onchange="doChangeFilter('#link#','#box#',document.getElementById('fldfund_#url.mission#'),getElementById('fldpostclass_#url.mission#'),this,getElementById('fldauthorised_#url.mission#'))">					 		
					       <option value="100">100</option>
						   <option value="0">0</option>
						   <option value="">Any</option>						   
					  </select>	
				</td>		
				
				<td style="padding-top:2px;padding-left:10px;border-left:1px solid silver;border-bottom:1px solid silver;"><cf_tl id="Authorised">:</td>
				
				<td class="label" style="color:gray;padding-left:4px;border-bottom:1px solid silver;">	
				       
					  <select  style="border:0px;width:60px" class="regularxl" id="fldauthorised_#url.mission#" 
					       onchange="doChangeFilter('#link#','#box#',document.getElementById('fldfund_#url.mission#'),getElementById('fldpostclass_#url.mission#'),getElementById('fldcategorydiv_#url.mission#'),this)">					 		
					       <option value="">All</option>
						   <option value="1">Yes</option>						 
						   <option value="0">No</option>	
					  </select>	
				</td>														
					
				</tr>
				</table>
				
			</td>
		</tr>
	</table>
	
</cfoutput>