
<cfparam name="URL.owner"                 default="">
<cfparam name="URL.edition"               default="#section.TemplateCondition#">
<cfparam name="URL.announcement"          default="">
<cfparam name="URL.DateRestricted"        default="1">
<cfparam name="URL.Direct"                default="0">
<cfparam name="URL.Verbose"               default="1">
<cfparam name="URL.divResponse"           default="result">
<cfparam name="url.AutomaticSubmission"   default="Yes">
<cfparam name="url.FunctionId"            default="">

<!--- we limit the buckets to show the current level of the person or the next level, so
for a P-3, it shows P-3 and P-4 --->

<cfquery name="LastGrade" 
   datasource="AppsEmployee" 
   username="#SESSION.login#" 
   password="#SESSION.dbpw#">
	   SELECT   TOP 1 *
	   FROM     PersonContract
	   WHERE    PersonNo = '#client.personno#'
	   AND      ActionStatus != '9'
	   ORDER BY Created DESC
 </cfquery> 	
 <cfquery name="Submission" 
	datasource="appsSelection" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT   *
	FROM     ApplicantSubmission
	WHERE    ApplicantNo = '#client.ApplicantNo#' 
</cfquery>

<cfset Grade = "">
 
<cfif Lastgrade.recordcount gte "0">

	 <cfquery name="getGrade" 
	   datasource="AppsSelection" 
	   username="#SESSION.login#" 
	   password="#SESSION.dbpw#">
	     
		   SELECT     R.GradeDeployment, 
		              R.ListingOrder, 
					  R.Description 				 
					  
		   FROM       Ref_GradeDeployment AS R INNER JOIN
		              Employee.dbo.Ref_PostGradeBudget AS PGB ON R.PostGradeBudget = PGB.PostGradeBudget INNER JOIN
		              Employee.dbo.Ref_PostGrade AS PG ON PGB.PostGradeBudget = PG.PostGradeBudget
		   WHERE      GradeDeployment IN
		                  (SELECT     GradeDeployment
		                   FROM       Functionorganization
		                   WHERE      SubmissionEdition = '#url.edition#')
		   AND        PG.PostGrade = '#lastGrade.Contractlevel#'				   
						   
		   ORDER BY   R.Listingorder				   
	  
	</cfquery>

	<cfif getGrade.recordcount gte "1">

		<cfset grade = "'#getGrade.gradeDeployment#'">
		
		<!--- next level --->

		 <cfquery name="NextGrade" 
		   datasource="AppsSelection" 
		   username="#SESSION.login#" 
		   password="#SESSION.dbpw#">
		     
			   SELECT     TOP 1 *
			   FROM       Ref_GradeDeployment
			   WHERE      GradeDeployment IN
			                  (SELECT     GradeDeployment
			                   FROM       Functionorganization
			                   WHERE      SubmissionEdition = '#url.edition#')
			   AND        Listingorder < '#getGrade.ListingOrder#'
			   ORDER BY   Listingorder DESC			   
		  
		</cfquery>
		
		<cfif nextGrade.recordcount gte "1">

			<cfset grade = "#grade#,'#nextGrade.GradeDeployment#'">
		
		</cfif>

	</cfif>	

</cfif>
 

<cfset enrolled = 0>

<cfquery name="Buckets" 
	datasource="AppsSelection" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	
	SELECT *
	FROM 
	
	(
		SELECT     FO.PostSpecific, 
		           F.FunctionDescription, 
				   O.Description AS OccupationalGroup, 
				   C.Description as ClassificationDescription,
				   C.ListingOrder as ClassificationListingOrder,
				   FO.FunctionId, 
				   FO.FunctionNo, 
				   FO.OrganizationCode, 
	               FO.SubmissionEdition, 
				   FO.GradeDeployment, 
				   FO.DocumentNo, 
				   FO.ReferenceNo, 
				   ORG.OrganizationDescription,
				   (SELECT count(*) 
				    FROM   ApplicantFunction 
					WHERE  FunctionId = FO.FunctionId 
					AND    ApplicantNo = '#client.applicantNo#' 
					AND    Status NOT IN ('5','9')
					) as Candidacy <!--- kherrera (2014-11-10):  Added Status = '0' --->
		FROM    FunctionOrganization FO INNER JOIN
	            FunctionTitle F ON FO.FunctionNo = F.FunctionNo INNER JOIN
				Ref_FunctionClassification C ON C.Code = F.FunctionClassification LEFT OUTER JOIN
	            OccGroup O ON F.OccupationalGroup = O.OccupationalGroup INNER JOIN
	            Ref_Organization ORG ON FO.OrganizationCode = ORG.OrganizationCode
		WHERE   1=1
			 
		<cfif URL.announcement eq 1>
		AND     FO.Announcement = 1	
		</cfif>
			
		<cfif URL.DateRestricted eq 1>
		AND     (FO.DateExpiration > GETDATE()-400 OR FO.DateExpiration IS NULL)
		</cfif>
		
		<cfif URL.owner neq "">
		
		AND     FO.SubmissionEdition IN (
										SELECT SubmissionEdition
					  					FROM Ref_SubmissionEdition
					  					WHERE Owner = '#URL.owner#'
						  				)
		</cfif>	
				
		<cfif URL.edition neq "">
		AND 	FO.SubmissionEdition = '#URL.edition#' 
		</cfif>	
		
		<cfif URL.Functionid neq "">
		AND 	FO.Functionid = '#url.FunctionId#'
		</cfif>		
		
		<cfif grade neq "">
		AND     FO.GradeDeployment IN (#preservesinglequotes(grade)#)
		</cfif>
		
	) as Derrived	
	
	ORDER BY   PostSpecific, OccupationalGroup, ClassificationListingOrder, FunctionDescription 
		
</cfquery>	

<cfif URL.verbose eq 1>

	<table width="100%" align="center" border="0" cellspacing="0" cellpadding="0" class="navigation_table">
	
		<cfoutput query="Buckets" group="PostSpecific">
					
			<tr><td colspan="7" align="left" class="labellarge" style="font-size:35px;padding-left:10px"><cfif PostSpecific eq "1">Post specific</cfif></b></td></tr>		
		
			<cfoutput group="OccupationalGroup">
			
				<tr><td colspan="7" style="padding-left:20px;font-size:29px" class="labellarge linedotted">#OccupationalGroup#</b></td></tr>	
								
				<cfoutput group="ClassificationDescription">
				
				<tr><td colspan="7" height="5"></td></tr>
				<tr><td colspan="7" style="height:40px;padding-left:20px;font-size:24px" class="labelmedium">#ClassificationDescription#</td></tr>			
				
				<cfoutput>
				
				<cfif Candidacy eq "1">
					<cfset cl = "labellarge">
				<cfelse>
					<cfset cl = "labelit">	
				</cfif>
				
				<tr class="navigation_row labelmedium" style="height:15px">
				
					<td width="10" class="navigation_pointer"></td>	
				
				  	<cfif Candidacy eq "1">
						<cfset cl = "labellarge">
						<td></td>
						<td style="height:30px" class="#cl#" width="50%"><font color="gray">#FunctionDescription#</TD>
					<cfelse>
						<cfset cl = "labelmedium">
						<td align="right" style="padding-top:4px;padding-right:10px" width="50"><!--- <cf_img onclick="show('#functionid#','#functionid#')" icon="select"> ---></td>
						<td style="height:15px;font-size:15px" class="#cl# clsTogglerTitle#functionid#" width="50%">#FunctionDescription#</TD>
					</cfif>
				   		
				   <td style="height:15px;font-size:15px" class="#cl#">#GradeDeployment#</td>
				   <!--- <td style="height:15px;font-size:15px" class="#cl#"><cfif OrganizationDescription neq "[ALL]">#OrganizationDescription#</cfif></td> --->
				   <!--- <td style="height:15px;font-size:15px" class="#cl#"><cfif ReferenceNo neq "Direct">#Reference#</cfif></td> --->
				   <cfif Submission.actionStatus eq 0>
					   <cf_tl id="Add to my career path" var="1">
					   <td 
					   	class="shortApplyContainer_#functionid#" 
						title="#lt_text#" 
						<cfif Candidacy neq "0">style="display:none;"</cfif>
						onclick="shortBucketApply('#functionid#');">
						   <table>
						   		<tr>
									<td>
										<img 
										src="#session.root#/images/plus_green.png" 
										style="height:17px; cursor:pointer;"> 
									</td>
									<td class="labelmedium" style="padding-left:5px;">
										#lt_text#
									</td>
								</tr>
						   </table>
					   </td>
				   </cfif>
				   
				</tr>
				
				<cfif Candidacy eq "0">
				<tr><td colspan="7" class="linedotted"></td></tr>
				</cfif>
					
				<tr>
				   <td></td><td></td><td colspan="5" id="c#functionid#">
					   <cfif candidacy gte "1">
					        <cfset url.functionid = functionid>
					        <cfinclude template="getCandidacy.cfm">					 
					   </cfif>		   
				   </td>
				</tr>	
		
		    	<tr class="hide clsToggler#functionid#" id="v#functionid#"><td></td><td></td>
				    <td colspan="5" id="vcontent#functionid#"></td>
				</tr>
			    <tr class="hide clsToggler#functionid#" id="a#functionid#"><td></td><td></td><td colspan="5" height="200" id="acontent#functionid#"></td></tr>
		
				</cfoutput>
				
				</cfoutput>
				
			</cfoutput>
	
		</cfoutput>	
		
	</table>

<cfelse>

	<cfoutput query="Buckets" group="PostSpecific">
		<cfif candidacy eq "0">
			<div id="a#functionid#" name="a#functionid#"></div>
			<cfif url.AutomaticSubmission eq "Yes">
		 		
				<script>
		 		   ptoken.navigate("#SESSION.root#/Roster/PHP/Apply/ApplySubmit.cfm?id=#FunctionId#&verbose=#url.verbose#",'#url.divResponse#')
		 		</script>
				
			<cfelse>
				<cfquery name="isCancelled" 
					datasource="AppsSelection" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
						SELECT *
						FROM   ApplicantFunction 
						WHERE  FunctionId = '#FunctionId#'
						and    ApplicantNo = '#client.applicantNo#' 
						AND    Status = '8'
				</cfquery>
				<cfif isCancelled.recordCount neq 0>
					<cfset enrolled=1>
				</cfif>
		 	</cfif>	
		 <cfelse>
			<cfset enrolled=1>
		 </cfif>
	</cfoutput>
</cfif>


<cfset AjaxOnLoad("doHighlight")>