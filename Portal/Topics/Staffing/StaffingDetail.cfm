
<!--- filter by owner of the position --->

<cfparam name="url.mission"           default="">
<cfparam name="url.orgunit"           default="">
<cfparam name="url.fund"              default="">
<cfparam name="url.postclass"         default="">
<cfparam name="url.postgradebudget"   default="">
<cfparam name="url.authorised"        default="">

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


<cftransaction isolation="READ_UNCOMMITTED">

<cfif url.period eq "today">
	<cfset dt = dateformat(now(),"YYYY/MM/DD")>
<cfelse>
	<cfset dt = url.period>	
</cfif>

<cfquery name="detail" 
     datasource="AppsEmployee" 
     username="#SESSION.login#" 
     password="#SESSION.dbpw#">	 
		SELECT    P.PositionNo,
		          P.SourcePostNumber,
				  P.PositionParentId,
				  P.PostGrade,
		          G.PostGradeBudget, 
				  P.PostClass,
				  P.PostType,
				  P.LocationCode,
				  (SELECT LocationNameShort
				  FROM Location
				  WHERE LocationCode = P.LocationCode) as LocationName,
		          PA.PersonNo,					
				  R.Description, 
				  R.ViewOrder,
				  R.Code,
				  G.PostOrderBudget,
				  P.VacancyActionClass,
				  T.ShowVacancy
	    FROM      Position AS P INNER JOIN
	              Ref_PostGrade AS G ON P.PostGrade = G.PostGrade INNER JOIN
	              Ref_PostGradeParent AS R ON G.PostGradeParent = R.Code  INNER JOIN
				  Ref_VacancyActionClass AS T ON P.VacancyActionClass = T.Code LEFT OUTER JOIN
				  PersonAssignment AS PA ON PA.PositionNo = P.PositionNo 
				                        AND PA.AssignmentStatus IN ('0','1')	
										
										AND    (Incumbency > 0 					      
					
										<!--- only to show if that person has 0 and no 100 incumbecny in the same entity --->
										
										OR ( Incumbency = 0 AND NOT exists (SELECT 'X'
										                                    FROM   PersonAssignment 
																            WHERE  PersonNo      = PA.PersonNo	
																			AND    AssignmentStatus IN ('0','1')																
																			AND    OrgUnit IN (SELECT OrgUnit 
																			                   FROM   Organization.dbo.Organization 
																							   WHERE  Mission = '#url.mission#')														    
																		    AND    Incumbency > 0
																		    AND    DateEffective <= '#dt#' 
																		    AND    DateExpiration >= '#dt#') )
																			 
											)								 
										
										AND PA.DateEffective <= '#dt#' 
										AND PA.DateExpiration >= '#dt#'
				  				  
				  
	    WHERE     P.Mission = '#url.mission#' 
		AND       P.DateEffective <= '#dt#' AND P.DateExpiration >= '#dt#'
		
		<cfif trim(url.postgradebudget) neq "">
			AND       G.PostGradeBudget = '#url.postgradebudget#'
		</cfif>

		<cfif trim(url.postgradeparent) neq "">
			AND       G.postgradeparent = '#url.postgradeparent#'
		</cfif>
	   	
		<cfif Param.ShowPositionFund eq "1">
		
			<cfif url.fund neq "">
			AND       EXISTS (SELECT 'X' 
			                  FROM   PositionParent 
						      WHERE  PositionParentId = P.PositionParentId 
						      AND    Fund = '#url.fund#')
			</cfif>
			
		<cfelse>
		
			<cfif url.fund neq "">			
			AND       EXISTS (SELECT 'X' 
			                  FROM   PositionParentFunding 
						      WHERE  PositionParentId = P.PositionParentId 
							  AND    FundingId IN (SELECT   TOP 1 FundingId
							                       FROM     PositionParentFunding 
												   WHERE    PositionParentId = P.PositionParentId 
												   AND      DateEffective <= '#dt#'
												   ORDER BY DateEffective DESC )							
						      AND    Fund = '#url.fund#')
			</cfif>	
					
		</cfif>
		
		<cfif url.postclass neq "">		
		AND        P.PostClass  = '#url.postclass#'
		</cfif>
		<cfif url.authorised neq "">		
		AND        P.PostAuthorised  = '#url.authorised#'
		</cfif>
		<cfif url.orgunit neq "">
		AND        OrgUnitOperational IN (SELECT OrgUnit 
		                                 FROM   Organization.dbo.Organization
										 WHERE  Mission   = '#url.mission#'
										 AND    MandateNo = '#get.MandateNo#'
										 AND    HierarchyCode LIKE ('#get.HierarchyCode#%')
										)  
		</cfif>	

		<cfif url.tpe eq "I">
			AND 	PA.PersonNo IS NOT NULL
		</cfif>   

		<cfif url.tpe eq "V">
			AND 	PA.PersonNo IS NULL
		</cfif>   
		
		<!--- remove vacant posts to be shown --->
		
		AND    (CASE T.ShowVacancy WHEN 0 THEN P.PositionNo ELSE 1 END ) IN
				 
			   (CASE T.ShowVacancy WHEN 0 THEN 
				 
				   (SELECT PositionNo
				    FROM   PersonAssignment 
					WHERE  PositionNo = P.PositionNo
					AND    AssignmentStatus IN ('0','1')
					AND    Incumbency > 0
					AND    DateEffective <= '#dt#' 
					AND    DateExpiration >= '#dt#') 
					
		           ELSE (1) END )   
		
	     ORDER BY   R.ViewOrder,G.PostOrderBudget, G.PostOrder
				
</cfquery>	

</cftransaction>

<cfif detail.recordcount eq "0">

	<table width="100%">
	   <tr><td align="center" class="labelmedium"><cf_tl id="No records to show in this view"></td></tr>
	</table>

<cfelse>
  	
	<table width="100%">
	
	   <tr style="border-top:1px solid silver" class="labelmedium line navigation_table fixrow">
	   	   <td></td>
	       <td><cf_tl id="Position"></td>
		   <td><cf_tl id="Grade"></td>	 
		   <td><cf_tl id="Location"></td>	
		   <td><cf_tl id="Class"></td>
	       <td><cf_tl id="IndexNo"></td>
	       <td><cf_tl id="Name"><cf_space spaces="50"></td>		
		   <td><cf_tl id="Nationality"><cf_space spaces="50"></td>		 
	   </tr>   	  
	 	   
	   <cfoutput query="detail">
	   				   		
			<cfquery name="Person" 
				     datasource="AppsEmployee" 
				     username="#SESSION.login#" 
				     password="#SESSION.dbpw#">	
					 SELECT * 
					 FROM   Person 
					 WHERE  PersonNo = '#PersonNo#' 		 
			</cfquery>
			
			<cfquery name="Nation" 
				     datasource="AppsSystem" 
				     username="#SESSION.login#" 
				     password="#SESSION.dbpw#">	
					 SELECT * 
					 FROM   Ref_Nation 
					 WHERE  Code = '#Person.Nationality#' 		 
			</cfquery>
	   	  	   
		   <tr class="labelmedium navigation_row line" style="height:20px;border-top:1px solid silver">
		   	   <td style="padding-left:4px">#currentrow#.</td>
		       <td style="padding-left:4px">
			   <a href="javascript:EditPosition('','','#PositionNo#')">
			   <cfif sourcePostNumber neq "">#SourcePostNumber#<cfelse>#PositionParentId#</cfif>
			   </a>
			   </td>
			   <td>#PostGrade#</td>
			   <td>#LocationName#</td>
			   <td>#PostClass#</td>
			   <cfif Person.PersonNo neq "">
			   <td style="padding-right:7px">
				   <table>
				   <tr class="labelmedium" style="height:20px">
				        <td><img src="#session.root#/images/logos/staffing/iconperson.png" alt="" border="0"></td>
				        <td style="padding-left:4px" ><a href="javascript:EditPerson('#personno#')"><font color="0080C0">#Person.IndexNo#</a></td>
				   </tr>
				   </table>
			   </td>
		       <td style="padding-right:5px">#Person.FirstName# #Person.LastName#</td>	
			   <td>#Nation.Name#</td>		  
			   <cfelse>
			   <td colspan="3" bgcolor="E6E6E6" style="padding-left:5px"><cf_tl id="Vacant"></td>
			   </cfif>
		   </tr>
		  	
	   </cfoutput>
	   
	  </table>
	    
</cfif>  
    
<cfset AjaxOnLoad("doHighlight")>