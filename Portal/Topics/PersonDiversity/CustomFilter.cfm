
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
	
<cfelse>

	<cfparam name="get.OrgUnitName" default="#url.mission#">		
	
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
		AND       P.OrgUnitOperational IN (SELECT  OrgUnit 
		                                   FROM    Organization.dbo.Organization
										   WHERE   Mission   = '#url.mission#'
										   AND     MandateNo = '#get.MandateNo#'
										   AND    (#preservesingleQuotes(conorg)#)
										  )  
		</cfif>	    
</cfquery>	

<cfset link = "#session.root#/Portal/Topics/PersonDiversity/Staffing.cfm?mission=#url.mission#&orgunit=#url.orgunit#&period=#url.period#">

	<table>	
	
		<cfset mis = replace(URL.mission, "-", "", "ALL")>
		<cfset box = "pane_#targetbox#_diversity_#mis#">
			    
	    <tr>
		
		<td style="padding-left:10px;width:100%">
		
			    <table width="100%">
			    <tr class="labelmedium2" style="font-size:12px">				
								
				<td style="padding-top:2px;padding-left:10px" ><cf_tl id="Category"></td>
											
					<td class="label" style="color:gray;padding-left:4px">	
										 
					  <select class="regularxb" id="<cfoutput>fldfund_#url.mission#</cfoutput>" 
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
								
				<td style="padding-top:2px;padding-left:10px"><cf_tl id="Class"></td>
				
				<td class="label" style="color:gray;padding-left:4px">	
					  <select class="regularxb" id="fldpostclass_#url.mission#" 
					       onchange="doChangeFilter('#link#','#box#',document.getElementById('fldfund_#url.mission#'),this,getElementById('fldcategorydiv_#url.mission#'),getElementById('fldauthorised_#url.mission#'))">					 		
					       <option value="">ANY</option>
						  <cfloop query="getClass">				  
						  	<option value="#PostClass#">#Description#</option>					  
						  </cfloop>
					  </select>	
				</td>		
				
				<td style="padding-top:2px;padding-left:10px"><cf_tl id="Incumbency"></td>
				
				<td class="label" style="color:gray;padding-left:4px">	
					  <select  class="regularxb" id="fldcategorydiv_#url.mission#" 
					       onchange="doChangeFilter('#link#','#box#',document.getElementById('fldfund_#url.mission#'),getElementById('fldpostclass_#url.mission#'),this,getElementById('fldauthorised_#url.mission#'))">					 		
					       <option value="100">> 0</option>
						   <option value="0">0</option>
						   <option value="">Any</option>						   
					  </select>	
				</td>		
				
				<td style="padding-top:2px;padding-left:10px"><cf_tl id="Authorised"></td>
				
				<td class="label" style="color:gray;padding-left:4px">	
				       
					  <select class="regularxb" id="fldauthorised_#url.mission#" 
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