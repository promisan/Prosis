
<!--- filter by owner of the position --->

<cfparam name="url.orgunit"     default="0">
<cfparam name="url.fund"        default="">
<cfparam name="url.postclass"   default="">
<cfparam name="url.category"    default="All">
<cfparam name="url.authorised"  default="">


<cfquery name="Param" 
	     datasource="AppsEmployee" 
	     username="#SESSION.login#" 
	     password="#SESSION.dbpw#">	
		 SELECT * 
		 FROM   Ref_ParameterMission 
		 WHERE  Mission = '#url.mission#' 		 
</cfquery>

<cfquery name="Mandate" 
	     datasource="AppsOrganization" 
	     username="#SESSION.login#" 
	     password="#SESSION.dbpw#">	
		 SELECT * 
		 FROM   Ref_Mandate 
		 WHERE  Mission = '#url.mission#' 
		 AND    DateEffective <= getDate()+180
		 ORDER BY DateExpiration DESC
	</cfquery>

<cfif url.orgunit eq "null">
	<cfset url.orgunit = "">
</cfif>

<cfif url.orgunit neq "" >

	<cfquery name="get" 
	     datasource="AppsOrganization" 
	     username="#SESSION.login#" 
	     password="#SESSION.dbpw#">	
		 SELECT * 
		 FROM   Organization 
		 WHERE  OrgUnit = '#url.orgunit#' 
	</cfquery>
	
</cfif>

<cftransaction isolation="READ_UNCOMMITTED">

<cfif url.period eq "today">
	<cfset dt = dateformat(now(),"YYYY/MM/DD")>
<cfelse>
	<cfset dt = url.period>	
</cfif>

<cfquery name="getPosts" 
     datasource="AppsEmployee" 
     username="#SESSION.login#" 
     password="#SESSION.dbpw#">	 
	
		SELECT    P.PostClass,
		          P.PositionNo,
		          G.PostGradeBudget, 
				  C.PostClassGroup,
		          COUNT(*) AS Posts, 
				   (SELECT count(*) 
				    FROM   PersonAssignment PA
					WHERE  PositionNo = P.PositionNo
					AND    AssignmentStatus IN ('0','1')
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
					
					AND    DateEffective <= '#dt#' 
					AND    DateExpiration >= '#dt#') as Incumbency,
				  R.Description, 
				  R.ViewOrder,
				  R.Code,
				  G.PostOrderBudget,
				  P.VacancyActionClass,
				  T.ShowVacancy
				  
				  
	    FROM      Position AS P INNER JOIN
	              Ref_PostGrade AS G ON P.PostGrade = G.PostGrade INNER JOIN
	              Ref_PostGradeParent AS R ON G.PostGradeParent = R.Code INNER JOIN
				  Ref_VacancyActionClass AS T ON P.VacancyActionClass = T.Code INNER JOIN
				  Ref_PostClass AS C ON P.PostClass = C.PostClass
	    WHERE     P.Mission = '#url.mission#' 
		AND       P.DateEffective <= '#dt#' AND P.DateExpiration >= '#dt#'
	    -- AND       ViewTotal = 1
		-- AND     T.ShowVacancy = '1'
		
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
		AND      P.PostClass  = '#url.postclass#'
		</cfif>
		
		<cfif url.authorised neq "">		
		AND      P.PostAuthorised  = '#url.authorised#'
		</cfif>
		
		<cfif url.orgunit neq "">
		AND       OrgUnitOperational IN (SELECT OrgUnit 
		                                 FROM   Organization.dbo.Organization
										 WHERE  Mission   = '#url.mission#'
										 AND    MandateNo = '#get.MandateNo#'
										 AND    HierarchyCode LIKE ('#get.HierarchyCode#%')
										)  
		</cfif>
		
					
	    GROUP BY  P.PostClass,P.PositionNo,C.PostClassGroup, P.PositionNo, P.VacancyActionClass, T.ShowVacancy, G.PostGradeBudget, G.PostOrderBudget, R.Code, R.Description, R.ViewOrder
	    ORDER BY  R.ViewOrder,G.PostOrderBudget
</cfquery>	

</cftransaction>

<!--- summary table --->

<cfif url.category eq "ALL">
	
	<cfquery name="Post" dbtype="query">
	    SELECT     PostGradeBudget, 		          
				   Description, 
				   Code,
				   ViewOrder,
				   SUM(Posts) as Posts,
				   SUM(Incumbency) as incumbency
	    FROM       getPosts	
		WHERE      ShowVacancy = '1' or (ShowVacancy = '0' and Incumbency > 0)  
	    GROUP BY   PostGradeBudget, 
		           PostOrderBudget, 
				   Code, 
				   Description, 
				   ViewOrder
	    ORDER BY   ViewOrder,PostOrderBudget
	</cfquery>	
	
<cfelse>

	<cfquery name="Post" dbtype="query">
	SELECT     PostGradeBudget, 		          
				   Description, 
				   Code,
				   1 as ViewOrder,
				   SUM(Posts) as Posts,
				   SUM(Incumbency) as incumbency
	    FROM       getPosts	  
		WHERE      ShowVacancy = '1' or (ShowVacancy = '0' and Incumbency > 0) 
	    GROUP BY   PostGradeBudget, 
		           PostOrderBudget, 
				   Code, 
				   Description, 
				   ViewOrder
	    ORDER BY   ViewOrder,PostOrderBudget
	</cfquery>	

</cfif>	

<cfquery name="Summary" dbtype="query">
	 SELECT  PostClassGroup,SUM(Posts) as PostTotal
	 FROM    getPosts
	 GROUP BY PostClassGroup			  
 </cfquery>	
			
<table width="99%" height="100%" class="navigation_table" border="0">
	
	<tr style="border-top:1px solid silver" class="line">
			
		<td width="20%" colspan="2" valign="top" style="padding-top:2px">
		
			  <table width="100%">
			  
			  <tr>
			  <cfoutput>	  
			  	 
				 <td style="height:40px;padding-left:10px">
					  
				  	<table width="300">
					    <tr class="labelmedium">
				  		<cfloop query="Summary">			  			
				  			<td style="padding-left:10px;min-width:100px">#PostClassGroup#</td>	
							<td style="padding-left:6px;min-width:100px;border:1px solid silver;padding-right:4px" align="right"><font color="408080">#summary.PostTotal#</td>				  						  		
				  		</cfloop>												  		
						</tr>
				  	</table>		
						
				  </td>		  	
				 
				  <cfif url.orgunit neq "">
				  
				   <td align="center" class="labelmedium clsNoPrint" style="cursor:pointer;padding-right:10px" onclick="ptoken.open('#SESSION.root#/Staffing/Application/Position/MandateView/MandateViewGeneral.cfm?header=1&ID=ORG&ID1=#get.orgunitcode#&ID2=#url.Mission#&ID3=#get.MandateNo#', 'staffing_#url.orgunit#')">
				  	<a><cf_tl id="Open Detail"></a>
				   </td>
				   <td>|</td>
				  </cfif>
				  
				   <td align="right" class="labelmedium clsNoPrint" style="cursor:pointer;padding-right:10px" onclick="loadmodule('#session.root#/Staffing/Reporting/PostView/Staffing/PostViewLoop.cfm','#url.mission#','acc=#session.acc#&Mandate=#Mandate.MandateNo#&tree=Operational&Unit=cum','')">
				  	<a><cf_tl id="Open Matrix"></a>
				  </td>
						  
			  </cfoutput>
			  </tr>
			  
			  </table>
			  
		</td>
	
		</tr>
		  
		  <cfif Post.recordcount eq "0">
		  
			  <tr><td colspan="2"
			     style="padding-top:5px;cursor:pointer;padding-left:10px" 
				 class="labelmedium"><font color="FF0000"><cf_tl id="No data found"></td></tr>
			  
		  <cfelse>
		  
			  <tr>
			  <td style="width:5%;padding-right:2px" valign="top">	 	
			  	  		  	
				 	<cfquery name="Summary" dbtype="query">
					  	SELECT    SUM(Posts) as PostTotal, 
					              Code,
								  Description,
								  ViewOrder
					 	 FROM     Post
					  	GROUP BY  Code, Description, ViewOrder
				  	</cfquery>	
							
				  	<cf_getChartStyle chartLocation="#GetCurrentTemplatePath()#">
					
					<cfchart style = "#chartStyleFile#" 
						format="png"
						
						scalefrom="0"
						scaleto="50" 
						showxgridlines="yes" 
						showygridlines="yes"
						gridlines="6" 
						showborder="no" 
						fontsize="11" 
						fontbold="no" 
						font="arial"
						fontitalic="no" 
						show3d="no" 
						showlegend="no"
						xaxistitle="" 				 
						yaxistitle="Tracks" 
						rotated="no" 
						sortxaxis="no" 				 
						tipbgcolor="##000000" 
						showmarkers="yes" 
						markersize="30" 
						backgroundcolor="##ffffff"					
				       	chartheight="240" 
					   	chartwidth="540">	
											
						   <cfchartseries type="pie"
					             query="Summary"
				    	         itemcolumn="Description"
				        	     valuecolumn="PostTotal"
								 datalabelstyle="columnlabel"								 
					             serieslabel=""
							     colorlist="##2574A9,##E8875D,##E8BC5D,##CCCA6A,##339AFA,##66AC6A,##999A9A,##FFFA9A,##996AFA"
				        	     markerstyle="circle"></cfchartseries>	
								 
					</cfchart>
					
					<!---			 
					<cfset vImagePath = "#session.rootpath#\CFRStage\user\#session.acc#\_executiveSummaryWidgetGraph">
					<cfset vImageURL = "#session.root#/CFRStage/user/#session.acc#/_executiveSummaryWidgetGraph">
					
					<cffile action="WRITE" file="#vImagePath#1.png" output="#myChart1#" nameconflict="OVERWRITE">
						 
					<cfoutput><img src="#vImageURL#1.png"></cfoutput>
					
					--->
					
				
			</td>
								
			<td style="height:100%;width:100%;padding-top:3px">
												
				<cf_divscroll overflowx="auto">										
																										
					<table width="100%">
					<tr>
								
					<cfquery name="getCols" dbtype="query">
				        SELECT     DISTINCT ViewOrder
					    FROM       Post	   	  
					</cfquery>	
				
					<cfoutput query="Post" group="ViewOrder">
					
						<cfset pos = 0>
						<cfset vac = 0>
						<cfset inc = 0>
					
						<td width="#48/getCols.recordcount#%" valign="top" style="border:1px solid silver;height:99%;padding:2px">
						
							<table width="100%" height="100%">	
							  
							<cfif url.category eq "ALL">			
								<tr class="line"><td align="center" style="border-bottom:1px solid silver;height:26;font-size:14px;padding-left:8px" class="labelmedium" colspan="5">#Description#</td></tr>						
							<cfelse>	
								<tr><td colspan="5" height="4"></td></tr>
							</cfif>
							<tr class="line labelmedium">
								<td width="100%" style="min-width:40px;padding-left:6px"><cf_tl id="Grade"></td>				
								<td align="center" style="min-width:25px;padding-right:2px!important;border-left:1px solid silver">P</td>
												
								<td align="center" style="min-width:25px;padding-right:2px!important;border-left:1px solid silver">I</td>
								<td align="center" style="min-width:25px;padding-right:2px!important;border-left:1px solid silver">V</td>
								<td align="center" style="min-width:25px;padding-right:6px;border-left:1px solid silver">V%</td>
							</tr>	
																
							<cfoutput>				
							
								<cfset pos = pos + posts>
								<cfset inc = inc + incumbency>
								<cfset vac = vac + (posts - incumbency)>
								<cfset per = (posts - incumbency)*100 / posts>
								
								<tr class="navigation_row labelmedium line" style="height:22px">
								  <td style="padding-left:6px;border-left:0px solid silver"><a href="javascript:doStaffing('#url.mission#','#url.orgunit#','#url.period#','#url.fund#','#url.postclass#','#url.authorised#','#code#','#postGradebudget#', '')">#PostGradeBudget#</a></td>
								  <td align="right" style="padding-right:2px!important;border-left:1px solid silver"><a href="javascript:doStaffing('#url.mission#','#url.orgunit#','#url.period#','#url.fund#','#url.postclass#','#url.authorised#','#code#','#postGradebudget#', '')"><font color="008000">#Posts#</a></td>
								  <td align="right" style="padding-right:2px!important;border-left:1px solid silver"><a href="javascript:doStaffing('#url.mission#','#url.orgunit#','#url.period#','#url.fund#','#url.postclass#','#url.authorised#','#code#','#postGradebudget#', 'I')">#Incumbency#</a></td>
	  							  <td align="right" style="padding-right:2px!important;border-left:1px solid silver"><cfif posts-incumbency neq "0"><a href="javascript:doStaffing('#url.mission#','#url.orgunit#','#url.period#','#url.fund#','#url.postclass#','#url.authorised#','#code#','#postGradebudget#', 'V')"><font color="FF0000">#Posts-Incumbency#</a></font></cfif></td>				  	
								  <td align="right" style="padding-right:3px!important;border-right:0px solid silver;border-left:1px solid silver">
								  <cfif per eq "0">--<cfelseif per eq "100">#numberformat(per,',')#<cfelse>#numberformat(per,'._')#</cfif></td>
								</tr>		
										
							</cfoutput>					
										
							<cfset per = (pos - inc)*100 / pos>
										
							<tr class="labelmedium line" style="background-color:eaeaea;border-top:1px solid silver" style="height:12px">
								  <td style="padding-left:6px;border-left:0px solid silver"></td>				  
								  <td align="right" style="padding-right:2px!important;border-left:1px solid silver"><a href="javascript:doStaffing('#url.mission#','#url.orgunit#','#url.period#','#url.fund#','#url.postclass#','#url.authorised#','#code#','', '')"><font color="008000">#pos#</a></td>
								  <td align="right" style="padding-right:2px!important;border-left:1px solid silver"><a href="javascript:doStaffing('#url.mission#','#url.orgunit#','#url.period#','#url.fund#','#url.postclass#','#url.authorised#','#code#','', 'I')">#inc#</a></td>
	  							  <td align="right" style="padding-right:2px!important;border-left:1px solid silver"><a href="javascript:doStaffing('#url.mission#','#url.orgunit#','#url.period#','#url.fund#','#url.postclass#','#url.authorised#','#code#','', 'V')"><font color="FF0000">#vac#</a></td>				  	
								  <td style="padding-right:4px;border-right:0px solid silver;border-left:1px solid silver" align="right"><cfif per eq "0">--<cfelseif per eq "100">#numberformat(per,',')#<cfelse>#numberformat(per,'._')#</cfif></td>
							</tr>			
									
							</table>
						
						</td>
					
					</cfoutput>
					
					</tr>
					</table>
										
				</cf_divscroll>	
										
		  </td>
		  
		  </tr>
		  
		  </cfif>	
		  
		  <cfoutput>
			<tr><td colspan="2" id="StaffingDetail_#url.mission#"></td></tr>
		</cfoutput>
	

</table>


<cfset ajaxOnLoad("doHighlight")>
