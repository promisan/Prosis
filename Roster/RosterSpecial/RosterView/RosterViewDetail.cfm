
<cfinvoke component="Service.Access"  
    method="roster" 
    returnvariable="AccessRoster"
    role="'AdminRoster'">
		 
<cfparam name="URL.Inquiry" default="No">
 
<cfparam name="URL.Mode"           default="undefined">
<cfparam name="URL.line"           default="0">
<cfparam name="URL.exerciseclass"  default="">
<cfparam name="URL.level"          default="">
<cfparam name="URL.filter"         default="">
<cfparam name="URL.fld"            default="">
<cfparam name="URL.opt"            default="">
<cfparam name="URL.tpe"            default="">
<cfparam name="URL.sort"           default="">
<cfparam name="URL.search"         default="0">
<cfparam name="FileNo"             default="">

<cftry>

<cfsilent>
	
	<CF_DropTable dbName="AppsQuery" tblName="#SESSION.acc#RosterDetailS#FileNo#">
	<CF_DropTable dbName="AppsQuery" tblName="#SESSION.acc#RosterSelect#FileNo#">
	<CF_DropTable dbName="AppsQuery" tblName="#SESSION.acc#RosterDetail#FileNo#">
		
	<cfquery name="Parameter" 
	datasource="AppsSelection" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT   *
		FROM     Ref_ParameterOwner
		WHERE    Owner = '#URL.Owner#'
	</cfquery>
		
	<cfquery name="Function" 
	datasource="AppsSelection" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT  F.FunctionId, 
			F.OccupationGroupDescription,
			F.FunctionNo,
			(CASE WHEN F.AnnouncementTitle is NULL 
			   THEN F.FunctionDescription 
			   ELSE F.AnnouncementTitle END) as FunctionDescription,
						
			<!--- obtain the publishing text --->
			(
			 SELECT   TOP 1  RSEL.FunctionDescription
			 FROM     Ref_SubmissionEditionPosition SEP INNER JOIN
                      Ref_SubmissionEditionPosition_Language RSEL ON SEP.SubmissionEdition = RSEL.SubmissionEdition AND SEP.PositionNo = RSEL.PositionNo
			 WHERE    SEP.SubmissionEdition = F.SubmissionEdition
			 AND      SEP.Reference         = F.ReferenceNo
			 AND      RSEL.LanguageCode = '#CLIENT.LanguageId#'
			 ) as FunctionDescriptionPublish,
			 
			<!--- take alternative from the table AnncountementTitle ---> 
						
			F.HierarchyOrder,
			F.OrganizationCode,
	        F.OrganizationDescription, 
			F.GradeDeployment, 
			F.Mission,
			F.LocationCode,
			F.ListingOrder, 
	        F.SubmissionEdition, 
			F.EditionOrder,
			F.EditionDescription, 
			F.FunctionRoster, 
			F.DocumentNo, 
			F.ReferenceNo,
			F.ReferenceName,
			F.PostSpecific,
			F.Status,		
			<cfif SESSION.isAdministrator eq "Yes" or findNoCase(url.owner,SESSION.isOwnerAdministrator)>
			'1' as Access
			<cfelse>
			MIN(A.AccessLevel) as Access
			</cfif>
			
	INTO    userQuery.dbo.#SESSION.acc#RosterSelect#FileNo# 
	FROM 	vwFunctionOrganization F
	
			<cfif URL.Inquiry eq "No"  and SESSION.isAdministrator eq "No" and not findNoCase(url.owner,SESSION.isOwnerAdministrator)>
			,RosterAccessAuthorization A
			</cfif>
					
		 <cfif URL.Edition eq "All">
		
			WHERE F.SubmissionEdition IN (SELECT SubmissionEdition 
			                              FROM   Ref_SubmissionEdition 
										  WHERE  EnableAsRoster = '1'
										  <cfif URL.Owner neq "">
										  AND Owner='#URL.Owner#'
										  </cfif>
										  <cfif url.exerciseclass neq "">
										  AND  ExerciseClass = '#url.exerciseclass#'
										  </cfif>)
											
				<cfif Parameter.HidePostSpecific eq "1">
				AND	 F.PostSpecific = 0
				</cfif>								
				
		<cfelse>
		
		    <!--- disabled by hanno 		
		    <cfif Parameter.DefaultRosterShow neq "1">
				WHERE	F.SubmissionEdition IN ('#URL.Edition#') 
			<cfelse>		
			    WHERE	F.SubmissionEdition IN ('#URL.Edition#','#Parameter.DefaultRoster#') 
			</cfif>				
			--->
			
			WHERE	F.SubmissionEdition IN ('#URL.Edition#') 
		
		</cfif>		
		
		AND Status != '9'  <!--- cancelled Job openings to be excluded 26/4/2017 --->
	
	<cfif URL.search eq "1">
	
	  <cfif URL.opt eq "1">
		   <cfset sp = "">
	  <cfelse>
		   <cfset sp = " ">
	  </cfif>   
		
	  <cfswitch expression="#URL.tpe#">
	      <cfcase value="occ">
			  AND F.OccupationGroupDescription LIKE '%#sp##URL.fld##sp#%'
		  </cfcase>
	  	  <cfcase value="function">
			  AND (F.FunctionDescription LIKE '%#sp##URL.fld##sp#%' OR F.AnnouncementTitle LIKE '%#sp##URL.fld##sp#%')
		  </cfcase>
		    <cfcase value="vacancy">
			  AND F.FunctionId 
			  		IN (SELECT FunctionId
			  			FROM FunctionOrganization 
						WHERE ReferenceNo LIKE '%#sp##URL.fld##sp#%')
			</cfcase>
	  </cfswitch>
	  
	<cfelse>
	
		<cfif URL.Occ neq "roster">
		       AND F.OccupationalGroup = '#URL.Occ#'
		</cfif>
		<cfif URL.Mode neq "Only">
			<cfif URL.Level eq "Grade">
			   AND   F.PostGradeBudget = '#URL.Filter#'
			<cfelse>
			   AND   F.PostGradeParent = '#URL.Filter#'
			</cfif>
		</cfif>
		
	</cfif>
	
	<cfif URL.Inquiry eq "No" and SESSION.isAdministrator eq "No" and not findNoCase(url.owner,SESSION.isOwnerAdministrator)>
		
		 	AND A.FunctionId      = f.FunctionId
			<!--- show if it has any rights 25/10/05 
			AND A.AccessLevel     = '#URL.Status#'
			--->
			AND A.UserAccount     = '#SESSION.acc#' 
			
	</cfif>
		
	 GROUP BY F.FunctionId, 
			  F.FunctionNo,
			  F.FunctionDescription, 
			  F.AnnouncementTitle,
			  F.HierarchyOrder,
			  F.OccupationGroupDescription,
			  F.OrganizationCode,
	          F.OrganizationDescription, 
			  F.GradeDeployment, 
			  F.EditionOrder,
			  F.PostSpecific,
			  F.ListingOrder, 
	          F.SubmissionEdition, 
			  F.ReferenceName,
			  F.EditionDescription, 	
			  F.Mission,
			  F.LocationCode,	 
			  F.FunctionRoster, 
			  F.DocumentNo, 
			  F.ReferenceNo,
			  F.ReferenceName,
			  F.Status	
			  
	 ORDER BY F.EditionOrder,
	          F.SubmissionEdition,
			  F.ListingOrder,
	          F.GradeDeployment,
			  F.Functiondescription,	
			  F.AnnouncementTitle		 
			 
	</cfquery>
		
	
	<!--- define the roster status to be shown --->
	
	<cfset stp = "">
	
	<cfquery name="Steps" 
		datasource="AppsSelection" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT   *
		FROM     Ref_StatusCode
		WHERE    Owner = '#URL.Owner#'
		AND      Id    = 'FUN'
		AND      ShowRoster = 1			
		ORDER BY Status 
	</cfquery>	
	
	<!--- define the steps to which the user has access besides the overall access in showroster --->
	
	<cfloop query="steps">
				 
			<cfinvoke component="Service.Access.Roster"  
	   	 	 method         = "RosterStep" 
		  	 returnvariable = "Access"
		     Status         = "#Status#"		
			 Process        = "Search"
	   		 Owner          = "#URL.Owner#">	
			 
			<cfif Access eq "1">
									
				 <cfif stp eq "">
				     <cfset stp = "#steps.status#">
				 <cfelse>
				     <cfset stp = "#stp#,#steps.status#">
				 </cfif>  
							
			</cfif>	
			
	</cfloop>		
	
	<cfquery name="Create"
	datasource="AppsQuery" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	CREATE TABLE dbo.#SESSION.acc#RosterDetail#FileNo# (
	    [FunctionId] [uniqueidentifier],
		<cfloop index="status" list="#stp#" delimiters=",">	
		[Status_#status#] [int],
		</cfloop>
		[Total] [int])	
	</cfquery>
	
	<cfsavecontent variable="RosterFunction">
	
	    <cfoutput>
		SELECT   F.FunctionId, 
			     F.Status, 
			     COUNT (DISTINCT PersonNo) as Counted 		
		FROM     Applicant.dbo.ApplicantFunction F, Applicant.dbo.ApplicantSubmission S
		WHERE    F.ApplicantNo = S.ApplicantNo
		AND      F.FunctionId IN   (SELECT FunctionId 
		                            FROM   userQuery.dbo.#SESSION.acc#RosterSelect#FileNo# 
					  			    WHERE  FunctionId = F.FunctionId)
		GROUP BY F.FunctionId, F.Status		
	    </cfoutput>
	
	</cfsavecontent>
				
	<cfloop index="status" list="#stp#" delimiters=",">
		
		<cfquery name="FunctionCleared" 
		datasource="AppsQuery" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			INSERT INTO dbo.#SESSION.acc#RosterDetail#FileNo#
				   (FunctionId,Status_#status#,Total)
			SELECT DISTINCT FunctionId, Counted, Counted
			FROM   (#preserveSingleQuotes(RosterFunction)#) as D 
			WHERE  Status = '#status#'   
		</cfquery>
		
	</cfloop>
	
	<!--- summary --->
	<cfquery name="Summary" 
	datasource="AppsQuery" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT   FunctionId, 
		         <cfloop index="status" list="#stp#" delimiters=",">	
			     SUM(Status_#status#) as Status_#status#,
			     </cfloop>
		         SUM(Total) as Total
		INTO     dbo.#SESSION.acc#RosterDetailS#FileNo#	
		FROM     #SESSION.acc#RosterDetail#FileNo#	 
		GROUP BY FunctionId
	</cfquery>
	
	<cfquery name="FunctionAll" 
	datasource="AppsQuery" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT  DISTINCT R.*, 
		        R.HierarchyOrder,
			    <cfloop index="status" list="#stp#" delimiters=",">
			      D.Status_#status#, 
			    </cfloop>
			    D.Total	
				   
		<cfif Parameter.HideEmptyBucket eq "0">      
		FROM    #SESSION.acc#RosterDetailS#FileNo# D RIGHT OUTER JOIN 
		        #SESSION.acc#RosterSelect#FileNo# R ON D.FunctionId = R.FunctionId 
		<cfelse>
		FROM    #SESSION.acc#RosterDetailS#FileNo# D INNER JOIN
		        #SESSION.acc#RosterSelect#FileNo# R ON D.FunctionId = R.FunctionId 				
		</cfif>	 
		
		ORDER BY R.EditionOrder,
	             R.SubmissionEdition,
				 R.HierarchyOrder,
				 R.OrganizationDescription,
			     R.ListingOrder,
	             R.GradeDeployment,
			     R.Functiondescription		
				 
		
	</cfquery>	
	
</cfsilent>

<cfcatch>

		<cfoutput>
			<table width="100%" cellspacing="0" cellpadding="0" align="center" style="background-color:white">
			<tr><td align="center" class="cellcontent">														
				 A problem has occurred when executing your search request on the server. Please contact your administrator if the issue persist.
				 <br>#CFCatch.Message# - #CFCATCH.Detail#
			</td></tr>
			</table>	
		</cfoutput>		
		
        <cfabort>
		 
</cfcatch>

</cftry>

<CF_DropTable dbName="AppsQuery" tblName="#SESSION.acc#RosterSelect#FileNo#">
<CF_DropTable dbName="AppsQuery" tblName="#SESSION.acc#RosterDetailS#FileNo#">
<CF_DropTable dbName="AppsQuery" tblName="#SESSION.acc#RosterDetail#FileNo#">
	
<cfoutput>	
	
	<cfif FunctionAll.recordcount eq "0">
	
		<table width="90%" border="0" cellspacing="0" cellpadding="0" align="center" style="padding-top:10px" class="formpadding">
			
			<table width="99%" border="0" cellspacing="0" cellpadding="0" align="center" class="formpadding">			
				<tr><td align="center" colspan="1" class="labelmedium"><font color="6688aa">No matching records found</b></td></tr>
			</table>	
				
		</table>
			
		<cfabort>
		
	</cfif>

</cfoutput>

<table width="100%" border="0" cellspacing="0" cellpadding="0" align="center" class="navigation_table formpadding"
    style="background-color:white; padding:5px">
	
<cfset Fun = "new">
<cfset Org = "new">
<cfset row = 0>

<cfset col = 8+steps.recordcount>

<cfinvoke component = "Service.Access"  
	method          = "vacancytree" 		
	returnvariable  = "accessTree">
	
			
		<cfif accessRoster    eq "EDIT" 
		      or accessRoster eq "ALL" 
			  or accessTree   eq "EDIT" 
			  or accessTree   eq "ALL">
			  
			   <cfquery name="Class"
		   datasource="AppsSelection"
		   username="#SESSION.login#"
		   password="#SESSION.dbpw#">
			  	SELECT * 
			   FROM  Ref_ExerciseClass
			   WHERE ExcerciseClass = '#url.exerciseclass#' 
		   </cfquery>	  
		   		   								
			<cfif URL.OCC neq "" 
			     and URL.search eq "0" 
				 and class.operational eq "1">
								
				<cfoutput>
				
				<tr>
				  <td height="20" class="labellarge" colspan="#col#" style="height:30px;padding-top:4px;padding-left:10px">
				  
				   <a href="javascript:recordadd('#url.occ#','show','only','','#URL.level#','','','','#url.edition#')">
					   <cf_tl id="Add"><cf_tl id="Roster Bucket">				  
				   </a>
				  </td>
				</tr>
				
				<!--- snippet to refresh the content upon adding --->
				<tr><td id="refresh#url.occ#" 
				       colspan="#col#" 
					   onclick="listing('#url.occ#','show','only','','','#URL.status#','','#url.exerciseclass#')"></td>
			    </tr>
			
				</cfoutput>
				
			</cfif>
		
		</cfif>
		
		

		<tr class="pleft labelmedium fixrow" style="border-top:1px solid silver">
		    <td height="18"></td>
			<td></td>	
			<td><cfif url.edition eq ""><cf_tl id="Edition"></cfif></td>
			<td><cf_tl id="Grade"></td>	
		    <td><cf_tl id="Function"></td>																
		    <td><cf_tl id="JO"></td>
			<TD><cf_space spaces="30"><cf_tl id="Track"></TD>			
			
			<cfset priorEdition = "">
			
			<cfloop index="status" list="#stp#" delimiters=",">	
			
					<cfquery name="Text" 
					datasource="AppsSelection" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
						SELECT  *
						FROM    Ref_StatusCode
						WHERE   Owner = '#URL.Owner#'
						AND     Id    = 'FUN'
						AND     Status = '#status#'
						AND     ShowRoster = 1
					</cfquery>	
					
					<cfoutput>
					    <TD width="1%" style="background-color:f1f1f1;border:1px solid silver" class="cellcontent" align="center"><a style="cursor: pointer;" title="#text.meaning#">#text.TextHeader#</a>&nbsp;</TD>
					</cfoutput> 
					
			</cfloop>					
			
			<td width="1%" style="background-color:e3e3e3;border:1px solid silver" class="cellcontent" align="center"><cf_tl id="Total"></td>
			
		</TR>	
		
				
		<cfset col = 8+steps.recordcount>
				
		<cfoutput query="FunctionAll" group="SubmissionEdition">		
		
		    <cfif url.edition eq "All">
		    <tr><td colspan="#col#" class="line"></td></tr>
			<tr class="line fixrow2"><td colspan="#col#" class="labelmedium" style="font-weight:250;height:45px;font-size:26px;padding-left:10px">#EditionDescription#</td></tr>			
			</cfif>
								
		<cfoutput group="OrganizationDescription">			
		
			<cfif OrganizationDescription neq "[All]">		
		    <tr><td colspan="#col#" class="line"></td></tr>
			<tr><td></td><td colspan="#col-1#" class="labelmedium" style="height:20px;padding-left:18px"><font size="2"><cf_tl id="Area">:</font>&nbsp;<font color="gray">#OrganizationDescription#</b></td></tr>			
			</cfif>
				
		<cfset prior = "">
			
		<cfoutput group="FunctionDescription">
				
		<cfif URL.search eq "1">
		
			<tr><td height="1" colspan="#col#" class="line"></td></tr>
			<tr>
			  <td width="100%" height="1" colspan="#col#">
			   <table width="100%" border="0" cellspacing="0" cellpadding="0">
			   <tr>
				   <td width="40%" style="padding-left:10px">
					    <a href="javascript:gjp('#FunctionNo#','#GradeDeployment#')" title="Details function #FunctionDescription# [#FunctionNo#]"><font color="6688aa">#FunctionDescription#</a> 
					   </td>
				   <td></td>
				   <td align="right" style="padding-right:4px" class="cellcontent">#OccupationGroupDescription#</td>
			   </tr>
			  </table>		 		  
			  </td>
			</tr>
		
		</cfif>
								
		<CFOUTPUT>
				
		<cfset row = row + 1>
							
			<cfif total eq ""> 		
			   <tr bgcolor="f4f4f4" id="line_#functionId#" class="navigation_row" style="height:25px">
			<cfelseif Status eq "9">  
			   <tr bgcolor="FCFBE0" id="line_#functionId#" class="navigation_row" style="height:25px"> 
			<cfelse> 
			   <TR bgcolor="#IIf(CurrentRow Mod 2, DE('FFFFFF'), DE('FFFFFF'))#" id="line_#functionId#" class="navigation_row" style="height:25px">
			</cfif>
		
		   	<td width="30" class="cellcontent" bgcolor="white" style="padding-left:20px;padding-right:3px">#row#.</td>													  
			<td class="line" style="min-width:100px"> 
						    				 
				  <table><tr>
					
				   <td style="min-width:40px;padding-left:4px">	   				  
				   <cfif Status eq "9">				      
				   	   <img src="#SESSION.root#/Images/na.gif" alt="Vacancy has been cancelled" width="12" height="12" border="0">					   
				   </cfif>
				   </td>	
				   
				    <td style="min-width:40px;padding-left:6px;padding-right:1px;padding-top:1px">					
					  <cf_img icon="edit" navigation="Yes" onClick="details('#functionId#');">														 
				    </td>
																	
					<cfif Total gt 0 and Access eq "1"> 
					
					<td width="20" style="min-width:40px;padding-right:1px;padding-top:2px">					
					    <cf_img icon="log" onClick="initial('#functionId#','Roster');">										 
					 </td>				
					 
					 <cfelseif total gt 0>
					 
					 	 <td width="20" style="min-width:40px;padding-right:1px;padding-top:2px">
					 					 			 
					 	<img src="#SESSION.root#/Images/locate3.gif"
						     alt="Advanced search"
						     name="img0_#url.occ#_#currentrow#"
						     id="img0_#url.occ#_#currentrow#"
						     border="0"
							 height="11"
							 width="11"
							 align="middle"
						     style="cursor: pointer"
						     onClick="initial('#functionId#','Search');"
						     onMouseOver="document.img0_#url.occ#_#currentrow#.src='#SESSION.root#/Images/button.jpg';"
						     onMouseOut="document.img0_#url.occ#_#currentrow#.src='#SESSION.root#/Images/locate3.gif';">
							 
						 </td>			
						 
					<cfelse>
					     <td width="20" style="min-width:40px;padding-right:1px;padding-top:2px"></td>		  					 										 
					</cfif>	
							
				
					<cftry>
					
					    <!--- --------------------------------------------------- --->
					    <!--- 10/1/2012 show this only if there indeed pending						
						 records based on the expiration date                     --->
						<!--- --------------------------------------------------- ---> 
						
						<td id="retire#functionId#" style="min-width:40px;padding-left:3px;padding-right:4px;padding-top:2px">
																											
						<cfif Status_0 gt "0" and Access eq "1">		
						
							<cfquery name="check" 
							datasource="AppsSelection" 
							username="#SESSION.login#" 
							password="#SESSION.dbpw#">								
								SELECT top 1 *
								FROM   ApplicantFunction
								WHERE  FunctionId = '#functionid#'
								AND    Created < getDate() - #Parameter.ProcessDays#
								AND    Status = '0'
							</cfquery>																			
						
							<cfif URL.Inquiry eq "No" and check.recordcount gte "1">		
							
								<cfparam name="status_5" default="5">					
										
							 	<img src="#SESSION.root#/Images/buttonred.jpg"								   
								     name="img2_#currentrow#"
								     id="img2_#currentrow#"
								     width="14"
								     height="14"
								     border="0"
									 alt="Outdate Applications"
								     align="absmiddle"
								     style="cursor: pointer;"
								     onClick="retire('#functionId#','#status_5#','#url.occ#','#url.mode#','#url.filter#','#url.level#','#url.line#');"
								     onMouseOver="document.img2_#currentrow#.src='#SESSION.root#/Images/button.jpg';"
								     onMouseOut="document.img2_#currentrow#.src='#SESSION.root#/Images/buttonred.jpg';">
							 						 
							 
							</cfif> 
												
						</cfif>
						
						</td>
						
						<cfcatch></cfcatch>
					
					</cftry>
									
				    <!---
					<cfif Access eq "0">
					  <img src="#SESSION.root#/Images/readonly.jpg" alt="Read only" border="0">
					</cfif>
					--->
											
				</tr>
				</table>
			
			</td>	
			
			<td width="1%" class="cellcontent line" style="padding-right:6px">
			    <!---
				<cfif url.edition eq "All">
					<cfif SubmissionEdition neq priorEdition>
						#SubmissionEdition#
						<cfset priorEdition = SubmissionEdition>
					<cfelse>
						..
					</cfif>
				</cfif>
				--->
			</td>
			
			<td width="6%" class="cellcontent line" style="min-width:80px"> 
				#left(GradeDeployment,12)#</td>		
			
			<td width="45%" class="cellcontent line" style="min-width:200px">
							
			    <cfif URL.search eq "0">
				    
					<!--- It means that the bucket was published with a custom FT--->
					<cfif FunctionDescriptionPublish neq "">
						  #FunctionDescriptionPublish#
					<cfelse>
					
						<cfif FunctionDescription neq Prior>								
							#FunctionDescription#
						<cfelse>
							&nbsp;&nbsp;<font color="808080">...
						</cfif>
					
					</cfif>
					
				</cfif>
				
			</td>							
			
			<td width="14%" class="line cellcontent" style="padding-right:4px">
			    <cfif ReferenceNo neq "Direct">
			    <A href="javascript:va('#functionId#')">#ReferenceNo#</a>
				<cfelse>
				#ReferenceName#
				</cfif>
			</td>
			
			<td width="16%" class="cellcontent line" style="border-right:1px solid silver;">
			
			<cfif PostSpecific eq "0">			
				<font color="gray">Generic</font>			
			<cfelse>
			
				<cfif DocumentNo neq "">
				
				<A href="javascript:showdocument('#DocumentNo#')">
				
				    #DocumentNo# 

					<cfquery name="Doc" 
						datasource="AppsVacancy" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">
						SELECT *
						FROM   Document
						WHERE  DocumentNo = '#DocumentNo#'
					</cfquery>					
									
					#doc.Mission#
					
				</a>
				
				<cfelse>
				
					 <cfif ReferenceNo neq "Direct">
					     <font color="FF0000">#Mission#</font>					 
					 <cfelse>
					 
					 </cfif>
				
				</cfif>
			
			</cfif>
						
			</td>			
									
			<cfloop index="st" list="#stp#" delimiters=",">	
			    
				<cfquery name="color" dbtype="query">
					SELECT   *
					FROM     steps
					WHERE    Status = '#st#'
				</cfquery>	
				
				<TD class="cellcontent line" align="right" bgcolor="<cfif Access eq '2' and #evaluate('Status_#st#')# gt "0">E9E9D1</cfif>"
				style="background-color:#color.showrostercolor#;padding-right:2;border-right: solid 1px silver;min-width:60px">			
				#evaluate('Status_#st#')#
				</TD>
			</cfloop>
									
			<TD class="cellcontent line" align="right" style="min-width:80px;padding-right:2px;border-right:solid 1px gray;background-color:##e1e1e150">#Total#</TD>
						 
		</TR>		
		
		<cfset prior = FunctionDescription>					
	
	</CFOUTPUT>
	
	</CFOUTPUT>
	
	<tr><td class="line" colspan="18"></td></tr>
	
	</CFOUTPUT>
	
	</CFOUTPUT>
	
</table>

<cfset ajaxOnLoad("doHighlight")>
