
<cfparam name="url.field"      default="ApprovalPostGrade">
<cfparam name="url.functionno" default="">
<cfparam name="url.mission"    default="">
<cfparam name="url.posttype"   default="">
<cfparam name="url.presel"     default="">

<cfquery name="Param" 
datasource="AppsEmployee" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
    FROM Ref_ParameterMission
	WHERE Mission = '#URL.Mission#'
</cfquery>

<!--- check if functionNo has limits --->

<cfquery name="getFunctionGrade" 
	datasource="AppsSelection" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT  DISTINCT DEP.PostGradeBudget
	FROM    FunctionTitleGrade FG INNER JOIN
            Ref_GradeDeployment DEP ON FG.GradeDeployment = DEP.GradeDeployment
	WHERE   FG.FunctionNo = '#url.functionNo#'
	AND     FG.Operational = 1
</cfquery>


<!--- check limits of posttype to be used for a mission --->

<cfquery name="getPostTypeGrade" 
	datasource="AppsEmployee" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
     SELECT *
     FROM   Ref_PostTypeGrade 
	 WHERE  PostType = '#url.PostType#'
</cfquery>	 
	
<cfquery name="PostgradeList" 
	datasource="AppsEmployee" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	
		SELECT   DISTINCT G.PostGrade, G.PostOrder, Description, ViewOrder
		FROM     Ref_PostGrade G INNER JOIN Ref_PostGradeParent A ON G.PostGradeParent = A.Code 				   
		WHERE    PostGrade = '#URL.presel#'
		
				 OR 
		
			 	 (		   
					
					<!--- limit to posttype to which the user has access : overkill as this is controlled already  --->
									
					<!--- valid grade for posts --->	
					PostGradePosition = 1		   
					
					<cfif param.EnforceGrade eq "1">
					
						<cfif getFunctionGrade.recordcount gte "1">
						
						<!--- enabled for function --->	
						AND        G.PostGradeBudget IN (
										SELECT DISTINCT DEP.PostGradeBudget
										FROM      Applicant.dbo.FunctionTitleGrade FG INNER JOIN
								                  Applicant.dbo.Ref_GradeDeployment DEP ON FG.GradeDeployment = DEP.GradeDeployment
										WHERE     FG.FunctionNo = '#url.functionNo#' AND  FG.Operational = 1
									)
						</cfif>				
					
					</cfif>
					
					<cfif getPostTypeGrade.recordcount gte "1">		
					
					<!--- has one or more  so we use this to filter  --->	
					AND   	   G.PostGrade IN (SELECT PostGrade
					            		       FROM   Ref_PostTypeGrade  
											   WHERE  1 = 1	
											   
											   <cfif url.posttype neq "">
											   
												AND        PostType = '#url.posttype#'	
															
											   <cfelseif getAdministrator(url.mission) eq "0">				
													
												AND        PostType IN ( SELECT A.ClassParameter			
												                           FROM   Organization.dbo.OrganizationAuthorization A 
																		   WHERE  A.Role IN ('HRPosition','HROfficer','HRLoaner') 
																		   AND    A.AccessLevel IN ('1','2')
																		   AND    A.Mission     = '#URL.Mission#'
																		   AND    A.UserAccount = '#SESSION.acc#' )										   
												</cfif>		
						
						                      )	
											  								   						   
					</cfif>		
					
				  )	
			   
		ORDER BY ViewOrder,PostOrder		
		   
</cfquery>


<select name="<cfoutput>#url.field#</cfoutput>" id="<cfoutput>#url.field#</cfoutput>" size="1" class="regularxl" style="width:130px">
	<cfoutput query="PostGradeList">
		<option value="#PostGrade#" <cfif PostGrade eq URL.presel>selected</cfif>>#PostGrade#</option>
	</cfoutput>
</select>
