
<!--- filter by owner of the position --->

<cfparam name="url.orgunit"        default="">
<cfparam name="url.cstf"           default="">
<cfparam name="url.postclass"      default="">
<cfparam name="url.contractclass"  default="standard">
<cfparam name="url.category"       default="All">
<cfparam name="url.authorised"     default="">

<cf_tl id="View Person" var="lblViewPerson">

<cfinclude template="EPASPreparation.cfm">	

<cfquery name="getBase" 
	datasource="AppsEPas" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">			
	
	SELECT     B.ContractId,
	
	           B.PersonNo,
	           B.ContractOrgUnit,
	           B.ContractOrgUnitName,
			   O.HierarchyCode as ContractOrgUnitHierarchy,
			   
			   B.AssignmentOrgUnit,
			   B.AssignmentOrgUnitName,
			   B.AssignmentOrgUnitHierarchy,
			   			   
			   (SELECT    count(*)
				FROM      Employee.dbo.vwAssignment
                WHERE     PersonNo     = B.PersonNo
				AND       Mission      = '#url.mission#' 
			    AND       AssignmentStatus IN ('0','1') 
			    AND       AssignmentType = 'Actual' 			    
			    AND       DateEffective <= getDate()
			    AND       DateExpiration >= getDate()			   
			   -- AND       Incumbency     > 0 
			   ) as OnBoard,	  
			   
			   
			   P.OrgUnit       as PresentationOrgUnit,
			   P.OrgUnitName   as PresentationOrgUnitName,
			   P.HierarchyCode as PresentationHierarchyCode,
			   
			   1                        AS Contracts,
			   ISNULL(Initiated,0)      AS Initiated, 
			   ISNULL(WithActivities,0) AS WithActivities, 
	           ISNULL(Submit,0)         AS Submit, 
			   ISNULL(Cleared,0)        AS Cleared, 
			   ISNULL(Midterm,0)        AS Midterm, 
			   ISNULL(Final,0)          AS Final,
			   ISNULL(complete,0)       AS complete
	
	FROM       (#preserveSingleQuotes(BaseQuery)#) as B   
	          <!--- link from contract orgunit --->
	          INNER JOIN Organization.dbo.Organization O ON B.ContractOrgUnit = O.OrgUnit					  
			  <!--- parent unit --->
			  INNER JOIN Organization.dbo.Organization P ON P.OrgUnitCode = O.HierarchyRootUnit AND P.Mission = O.Mission AND P.MandateNo = O.MandateNo
						
	ORDER BY  P.HierarchyCode ASC			
	
 </cfquery>	
 
 <cfif getBase.recordcount eq "0">
 
	 <table align="center" class="labelmedium"><tr><td align="center" class="labelmedium" style="font-weight:200"><cf_tl id="No data"></td></tr></table>
	 <cfabort>
 
 </cfif> 
			
<table width="98%" class="navigation_table" align="center">

<tr style="padding-top:5px">

<td align="center" style="width:50%;border:0px solid silver;height:120px;padding:0px">

	<table width="100%" height="100%">
	
		<tr><td width="50%" style="padding:5px; border-right:1px dotted #C0C0C0;">
		
		<!--- add organizational context to the selected ePas --->
					
		 <cfquery name="getStatus" dbtype="query">
			  	SELECT  SUM(Contracts)      AS Issued, 
					  	SUM(Initiated)      AS Initiated, 
					  	SUM(WithActivities) AS Workplan, 
		                SUM(Submit)         AS Submit, 
					    SUM(Cleared)        AS Cleared, 
					    SUM(Midterm)        AS Midterm, 
					    SUM(Final)          AS Final,
						SUM(complete)       AS Complete
			 	FROM    GetBase		
				WHERE   AssignmentOrgUnit is not NULL				
		 </cfquery>	
		 	
		 
		 <cfif getStatus.Issued eq "">
		 	<cfset ht = "20">
		 <cfelse>
		 	<cfset ht = getStatus.Issued+20>	
		 </cfif>

		 <table>
		 	<tr class="line">
		 		<cfoutput>
					<td class="labelmedium" align="center"><cf_tl id="Progress until Stage" var="1">#ucase(lt_text)#</td>
					<!---
					<td class="labelmedium" align="center"><cf_tl id="Reached Stage" var="1">#ucase(lt_text)#</td>
					--->
				</cfoutput>
			</tr>
			
			<cfset statuslist = "Issued,Initiated,Workplan,Submit,Cleared,Midterm,Final,complete">

		 	<tr>
		 		<td style="padding-top:10px;">
				
 				    <cf_getChartStyle chartLocation="#GetCurrentTemplatePath()#">
		 			<cfchart style = "#chartStyleFile#" 
						format="png"										
						scalefrom="0"
						scaleto="#ht#" 
						showxgridlines="yes" 
						showygridlines="yes"
						gridlines="6" 
						showborder="no" 
						fontsize="13" 
						fontbold="no" 
						font="calibri"
						fontitalic="no" 
						xaxistitle="" 				 
						yaxistitle="" 
						show3d="no"	
						rotated="no" 
						sortxaxis="no" 				 
						tipbgcolor="##000000" 
						showmarkers="yes" 
						markersize="5" 
						backgroundcolor="##ffffff"	
				       	chartheight="360" 
					   	chartwidth="714"
					   	url="javascript:ptoken.navigate('#session.root#/portal/topics/epas/EPASDetail.cfm?mission=#url.mission#&period=#url.period#&cstf=#url.cstf#&authorised=#url.authorised#&postclass=#url.postclass#&category=#url.category#&orgunit=#orgunit#&type=$ITEMLABEL$','EPASDetailContainer_#url.mission#');">	
											
						   <cfchartseries
				             type="area"
				             datalabelstyle="value"
				             markerstyle="circle"
				             colorlist="##2574A9,##E8875D,##E8BC5D,##CCCA6A,##339AFA,##66AC6A,##999A9A,##FFFA9A,##996AFA">
							 
							 	<cfloop index="itm" list="#statuslist#">
									
								 <cfset val = evaluate("getStatus.#itm#")>		
								 <cfif val eq ""> 
								   <cfset val = 0>
							     </cfif>				 
								 <cfchartdata item="#itm#"  value="#val#">
														 
							   </cfloop>	 
								 						 
						   </cfchartseries>	

					</cfchart>	
					
									
		 		</td>
				
				
		 	</tr>
		 </table>		 
						
		</td>
		
		<td width="50%" style="padding:5px;" valign="top">
			<cfoutput>
				<table width="100%" height="100%">
					<tr class="line">
						<td class="labelmedium" align="center"><cf_tl id="Summary" var="1">#ucase(lt_text)#</td>
					</tr>
					<tr>
						<td valign="top">
						    <cfinclude template="EPASUnit.cfm">
						</td>
					</tr>	
					
					<tr class="line">
					<td class="labelmedium" align="center"><cf_tl id="Reached Stage" var="1">#ucase(lt_text)#</td>
					</tr>
					
					<tr>
						
						 <cfquery name="getStage" dbtype="query">
						  	SELECT  SUM(Contracts-Initiated)      AS Issued, 
								  	SUM(Initiated-WithActivities) AS Initiated, 
								  	SUM(WithActivities-Submit)    AS Workplan, 
					                SUM(Submit-Cleared)           AS Submit, 
								    SUM(Cleared-Midterm)          AS Cleared, 
								    SUM(Midterm-Final)            AS Midterm, 
								    SUM(Final-complete)          AS Final,
									SUM(complete)                AS complete
						 	FROM    GetBase		
							WHERE   AssignmentOrgUnit is not NULL				
						 </cfquery>	
				
							<td valign="bottom">
											
							<cfchart style = "#chartStyleFile#" 
									format="png"				
									scalefrom="0"
									scaleto="#ht#" 
									showxgridlines="yes" 
									showygridlines="yes"
									gridlines="6" 
									showborder="no" 
									fontsize="13" 
									fontbold="no" 
									font="calibri"
									fontitalic="no" 
									xaxistitle="" 				 
									yaxistitle="PAR" 
									rotated="no" 									
									sortxaxis="no" 
									show3d="no"				 
									tipbgcolor="##000000" 
									showmarkers="yes" 
									markersize="5" 
									backgroundcolor="##ffffff"	
							       	chartheight="160" 
								   	chartwidth="440">
									<!---
									url="javascript:ptoken.navigate('#session.root#/portal/topics/epas/EPASDetail.cfm?mission=#url.mission#&period=#url.period#&cstf=#url.cstf#&authorised=#url.authorised#&postclass=#url.postclass#&category=#url.category#&orgunit=#orgunit#&type=$ITEMLABEL$','EPASDetailContainer_#url.mission#');">
									--->
															 						 
									    <cfchartseries
							             type="bar"
							             datalabelstyle="value"
							             markerstyle="rectangle"
							             colorlist="##2574A9,##E8875D,##E8BC5D,##CCCA6A,##339AFA,##66AC6A,##999A9A,##FFFA9A,##996AFA">
										 
										 	<cfloop index="itm" list="#statuslist#">								
											 
											 <cfset val = evaluate("getStage.#itm#")>		
											 <cfif val gt "0">											 
											 <cfchartdata item="#itm#"  value="#val#">
											 </cfif>
																	 
										   </cfloop>	 
											 						 
									   </cfchartseries>	
									   					  
			
								</cfchart>	
							
							</td>
												
					</tr>
				</table>
			</cfoutput>
		</td>
			
	</tr>
	</table>		

</td>
</tr>

<cfoutput>	

	<tr style="padding:2px;">		
		<td align="center" style="width:100%;border:0px solid silver;padding:2px" id="EPASDetailContainer_#url.mission#"></td>
	</tr>
	
	<tr style="border-top:1px solid silver; padding:5px">	
		<td height="100%" valign="top">
			<table width="100%" height="<cfif url.orgunit eq "">220<cfelse>120</cfif>">
				<tr class="line">
					<td width="33%" style="height:100%;padding:5px; border-right:1px dotted ##C0C0C0;" valign="top">
					
						<table width="100%" height="100%">
							<tr class="line" style="height:10">
								<td class="labelmedium" style="height:10px;font-weight:normal" align="left"><font color="FF0000"><cf_tl id="Issued PAR but no assignment for period" var="1">#ucase(lt_text)#</td>
							</tr>
							<tr style="height:100%">
								<td valign="top" align="center" class="labelmedium">
																
									<cfquery name="getMissing" dbtype="query">
									  	SELECT  *
									 	FROM    GetBase			  	
										WHERE   AssignmentOrgUnit is NULL
									</cfquery>										
									
									<cfif getMissing.recordcount eq "0">
									
										<br><cf_tl id="No exceptions">
									
									<cfelse>
									
									<cfset exception = quotedValueList(getMissing.PersonNo)>
									
									<cfquery name="getPerson" 
										datasource="AppsEmployee" 
										username="#SESSION.login#" 
										password="#SESSION.dbpw#">	
										SELECT *
										FROM   Person
										WHERE  PersonNo IN (#preservesingleQuotes(exception)#)
										
									</cfquery>
																		
									<cf_divScroll width="100%" height="100%">
										<table class="navigation_table formpadding">									 
											 <cfloop query="getPerson">									 
											 <tr class="labelmedium navigation_row line" style="height:20px">
											     <td style="padding-left:2px">#currentrow#</td>
												 <td style="padding-left:5px" width="5%" class="navigation_action"><a href="javascript:EditPerson('#PersonNo#','','position')">#IndexNo#</a></td>
												 <td style="padding-left:8px">#LastName#, #FirstName#</td>												
											 </tr>								 
											 </cfloop>									 
										 </table>
									</cf_divscroll> 	
									
									</cfif>							
									 
								</td>
							</tr>
						</table>
					</td>
					
					<td width="33%" style="padding-left:10px;border-left:1px solid silver;padding-top:5px;padding-right:10px" valign="top">
						<table width="100%" height="100%">
						
							<cfquery name="getPerson" 
										datasource="AppsEPAS" 
										username="#SESSION.login#" 
										password="#SESSION.dbpw#">	
										
										SELECT *
										FROM  Employee.dbo.Person
										WHERE PersonNo IN (SELECT    PersonNo
								                           FROM      Employee.dbo.vwAssignment
								                           WHERE     Mission        = '#url.mission#' 
														   AND       AssignmentStatus IN ('0','1') 
														   AND       AssignmentType = 'Actual' 
														   <!--- today --->
														   AND       DateEffective <= getDate()
														   AND       DateExpiration >= getDate()
														   
														   -- AND       Incumbency     > 0 
														   <cfif url.orgunit neq "">
			
															AND      OrgUnit IN (SELECT OrgUnit 
															                     FROM   Organization.dbo.Organization
																			     WHERE  Mission   = '#url.mission#'
																				 AND    MandateNo = '#Mandate.MandateNo#'
																				 AND    HierarchyCode LIKE ('#get.HierarchyCode#%')
																				 )  
																				  
															</cfif>	
														   <!--- on only assignments valid for the ePas period itself. --->
														   AND       DateEffective  <= '#Period.PasPeriodEnd#' 
														   AND       DateExpiration >= '#Period.PasPeriodStart#' 	
														   
														   AND       PostType IN (SELECT PostType 
														                          FROM   Employee.dbo.Ref_PostType
																				  WHERE  EnablePas = '1')						     
								                           GROUP BY  PersonNo) 
														   
										AND    PersonNo NOT IN (SELECT PersonNo
										                        FROM   Contract
																WHERE  Mission  = '#url.mission#' 
																AND    Period   = '#url.period#'
																AND    ContractClass = '#url.contractclass#')
																
													
								</cfquery>				
								
							<tr class="line">
								<td class="labelmedium" style="height:10px;font-weight:normal" align="left"><cf_tl id="Staff onboard without Issued PAR" var="1">#ucase(lt_text)#:#getPerson.recordcount#</td>
							</tr>
							<tr>
								<td align="center" height="100%" valign="top">
								
										<cf_divScroll width="100%" height="100%">
											<table class="navigation_table">									 
												 <cfloop query="getPerson">		
												 							 
												 <tr class="labelmedium navigation_row" style="height:17px">
												     <td style="padding-left:2px">#currentrow#</td>
													 <td style="padding-left:3px" width="5%"><a class="navigation_action" href="javascript:EditPerson('#PersonNo#','','position')">#IndexNo#</a></td>
													 <td style="padding-left:8px">#LastName#, #FirstName#</td>														 
												 </tr>		
												 
												   <cfquery name="getUnit" 
													datasource="AppsEPAS" 
													username="#SESSION.login#" 
													password="#SESSION.dbpw#">	
													  	   SELECT    TOP 1 *
								                           FROM      Employee.dbo.vwAssignment
								                           WHERE     Mission        = '#url.mission#' 
														   AND       PersonNo       = '#PersonNo#'
														   AND       AssignmentStatus IN ('0','1') 
														   AND       AssignmentType = 'Actual' 
														   AND       Incumbency     > 0 
														   AND       DateEffective  <= '#Period.PasPeriodEnd#' 
														   AND       DateExpiration >= '#Period.PasPeriodStart#' 	
														   ORDER BY  DateEffective DESC
												 </cfquery>	
												 	
												 <tr style="height:12px" class="labelit line"><td></td><td colspan="2" style="padding-left:3px">#getUnit.OrgUnitName#</td></tr>						 
																 
												 </cfloop>									 
											 </table>
										</cf_divscroll> 	
								
								</td>
							</tr>
						</table>
					</td>
					
					<td width="34%" style="padding-left:10px;border-left:1px solid silver;padding-top:3px;padding-right:10px;" valign="top">
						<table width="100%" height="100%">
						
							<tr class="line">
								<td class="labelmedium" style="font-weight:normal" align="left"><cf_tl id="Staff incumbency differs from ePar unit" var="1">#ucase(lt_text)#</td>
							</tr>
							
							<tr style="height:100%">
								<td align="center" height="100%" valign="top" align="center" class="labelmedium">
									
									 <cfquery name="getMove" dbtype="query">
									  	SELECT  *
									 	FROM    GetBase			  	
										WHERE   ContractOrgUnit <> AssignmentOrgUnit 
										AND     AssignmentOrgUnitHierarchy NOT LIKE ContractOrgUnitHierarchy+'%' <!--- deeper unit is accepted --->
										AND     AssignmentOrgUnit is not NULL	
										AND     OnBoard > 0									
									 </cfquery>	
									 
									 <cfif getMove.recordcount eq "0">
									 
										<br><cf_tl id="No exceptions">
									
									<cfelse>
									 
									     <cfset exception = quotedValueList(getMove.PersonNo)>
									
										<cfquery name="getPerson" 
											datasource="AppsEmployee" 
											username="#SESSION.login#" 
											password="#SESSION.dbpw#">	
											SELECT *
											FROM   Person
											WHERE  PersonNo IN (#preservesingleQuotes(exception)#)											
										</cfquery>
																			
										<cf_divScroll width="100%" height="100%">
										
											<table class="navigation_table">									 
												 <cfloop query="getPerson">									 
												 <tr class="labelmedium navigation_row" style="height:17px">
												     <td style="padding-left:2px">#currentrow#.</td>
													 <td style="padding-left:5px" width="5%"><a class="navigation_action" href="javascript:EditPerson('#PersonNo#','','position')">#IndexNo#</a></td>
													 <td style="padding-left:8px">#LastName#, #FirstName#</td>														
												 </tr>	
												 
												  <cfquery name="getUnit" dbtype="query">
													  	SELECT  *
													 	FROM    GetBase			  	
														WHERE   PersonNo = '#PersonNo#' 
														AND     AssignmentOrgUnit is not NULL
												 </cfquery>	
												 	
												 <tr style="height:12px" class="labelit line"><td></td><td colspan="2">#getUnit.AssignmentOrgUnitName# (<b>was:</b> #getUnit.ContractOrgUnitName#)</td></tr>						 
												 </cfloop>									 
											 </table>
										</cf_divscroll> 	
									
									</cfif>		
									 
								</td>
							</tr>
						</table>
					</td>
				</tr>
			</table>
		</td>		
	</tr>	
	
</cfoutput>

</table>

<cfset ajaxOnLoad("doHighlight")>
