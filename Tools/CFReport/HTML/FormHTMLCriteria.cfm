
<cfquery name="Max" 
	 datasource="AppsSystem" 
	 username="#SESSION.login#" 
	 password="#SESSION.dbpw#">
	 SELECT Max(CriteriaWidth) as Width
	 FROM   Ref_ReportControlCriteria C
	 WHERE  ControlId = '#controlid#' 
	 AND    Operational = 1
</cfquery>

<cfif Max.Width lte "140">
   <cfset showwidth = "140">
<cfelse>
   <cfset showwidth = "#Max.Width#">
</cfif>

<cfset bgcolor = "B7DBFF">

<style>

    TD.input { padding:0px }

	INPUT.search {
		font-size : 7pt;
		color : black;
		background : F1F1E4;
		text-align : left;
		font : bolder;
	}
</style>

<cfif reportId  eq "00000000-0000-0000-0000-000000000000">

	<!--- take defaults from the report config --->
	
	<cfquery name="BaseSet" 
	 datasource="AppsSystem" 
	 username="#SESSION.login#" 
	 password="#SESSION.dbpw#">
		 SELECT    *
		 FROM      Ref_ReportControlCriteria
		 WHERE     ControlId     = '#controlid#' 
		 AND       CriteriaClass IN (#preservesingleQuotes(class)#)
		 AND       Operational   = 1
		 ORDER BY  CriteriaClass DESC,CriteriaOrder, CriteriaName  
		 		 
	</cfquery>
	
<cfelse>

	<!--- take defaults from the user saved config --->

	<cfquery name="BaseSet" 
	 datasource="AppsSystem" 
	 username="#SESSION.login#" 
	 password="#SESSION.dbpw#">
	 
		 SELECT     R.CriteriaName, 
		 			R.CriteriaNameParent,
			        U.CriteriaValue as CriteriaDefault, 
			        R.CriteriaDescription, 
					R.CriteriaMemo,
					R.CriteriaError,
					R.CriteriaOrder,
					R.CriteriaWidth, 
					R.CriteriaMask,
					R.CriteriaClass,
					R.CriteriaValidation,
					R.CriteriaPattern,
					R.CriteriaRole,
					R.CriteriaValues,
					R.CriteriaInterface,
					R.CriteriaDateRelative,
					R.CriteriaDatePeriod,
					R.CriteriaCluster,
					R.LookupTable,
					R.LookupUnitTree,
					R.LookupUnitParent,
					R.LookupDataSource, 
					R.LookupFieldValue, 
					R.LookupFieldDisplay,
					R.LookupFieldSorting,
					R.LookupFieldShow,  				
					R.LookupEnableAll,
					R.CriteriaType, 
					R.LookupMultiple, 
					R.CriteriaObligatory
					
		 FROM  		Ref_ReportControlCriteria R LEFT OUTER JOIN userQuery.dbo.#SESSION.acc#Crit U
		   ON       R.CriteriaName = U.CriteriaName
		   
		 WHERE  	R.ControlId = '#ControlId#' 
		 AND        R.CriteriaClass IN (#preservesingleQuotes(class)#)	
		 AND        R.Operational = 1
		 
		 ORDER BY   R.CriteriaClass DESC, R.CriteriaOrder, R.CriteriaName 
		 
	</cfquery>
			
</cfif>	
    
<cfset ele[1] = ""> 
<cfset ord[1] = "0">   

<cfoutput query="BaseSet">
	<cfset ele[currentRow+1] = CriteriaName> 
	<cfset ord[currentRow+1] = CriteriaOrder>   
</cfoutput>

<cfset bxcl = "ffffef">

<table width="100%">
	
	<!--- regular fields --->
	
	<cfquery name="Criteria" 
	   dbtype="query"> 
		SELECT   * 
		FROM     BaseSet			
		ORDER BY CriteriaClass DESC,CriteriaOrder, CriteriaName
	</cfquery>
	
	<tr class="fixrow">
	<td colspan="1" class="labelmedium" style="font-size:25px;height:40px;font-weight:200">
		<cf_tl id="Criteria">
	</td></tr>	
		
	<tr> 
	   <td valign="top" style="padding:5px">
	   	  		          
	   <table width="99%" class="formspacing">
	   
	    <cfoutput query="Criteria" group="CriteriaClass">
		
		<cfif CriteriaClass eq "Layout"><tr class="labelmedium"><td><cf_tl id="Other settings"></td></tr></cfif>
		
		 <cfset row = 0>
	     <cfset cluster = "">
		 	  	  	      						
		<cfoutput group="CriteriaOrder">
		
			<cfoutput group="CriteriaName">	
			
			<cfif CriteriaType eq "Extended" AND CriteriaInterface eq "Combo">			
			
				<!--- special selection --->
				
			<cfelse>	
								  					
				<cfif LEFT(ord[currentRow+1],1) neq LEFT(ord[currentRow],1)
				     or (row gt Report.TemplateBoxes) 
					 or report.functionclass is "System">
										
						<cfif row lt Report.TemplateBoxes and row neq "0"> 
						   <td></td>
						</cfif>
										
						<cfif row+1 lt Report.TemplateBoxes and row neq "0"> 
						   <td></td>
						</cfif>
						
					</tr>
					<cfset row = "1">		
					
				    <tr>
				
				</cfif> 	
															
				<cfif CriteriaCluster neq "" and not Find("#CriteriaCluster#", "#cluster#")>
																							
						<cfset cluster =  "#Cluster#,#CriteriaCluster#">
													
						<td>	
								
								<table>
								
								<cfquery name="Parameter" 
								    dbtype="query"> 
									SELECT *
									FROM   BaseSet
									WHERE  CriteriaCluster = '#CriteriaCluster#' 
									AND    (
									         CriteriaInterface <> 'Combo' and CriteriaType = 'extended'
										     OR
										     CriteriaType <> 'extended'
										  )
									        
									ORDER BY CriteriaOrder 
						        </cfquery>
																
								<cfquery name="Obligatory" 
								    dbtype="query"> 
									SELECT *
									FROM  BaseSet
									WHERE CriteriaCluster = '#CriteriaCluster#' 
									AND   CriteriaObligatory = 1
						        </cfquery>
								
								<cfif Obligatory.recordcount eq "0">
								    <input type="hidden" name="#CriteriaCluster#Obl" id="#CriteriaCluster#Obl" value="0">
								<cfelse>
								    <input type="hidden" name="#CriteriaCluster#Obl" id="#CriteriaCluster#Obl" value="1">    
								</cfif>
													
								<cfquery name="ClusterSelect" 
									 datasource="AppsSystem" 
									 username="#SESSION.login#" 
									 password="#SESSION.dbpw#">
										 SELECT *
										 FROM   UserReportCriteria 
										 WHERE  ReportId     = '#ReportId#' 
										 AND    CriteriaName = '#CriteriaCluster#'												 
								</cfquery>
								
								<cfset v = "0">
																				
								<cfif ClusterSelect.CriteriaValue neq "">
								<input type="hidden" name="#CriteriaCluster#Sel" id="#CriteriaCluster#Sel" value="#ClusterSelect.CriteriaValue#">
								<cfelse>
								<input type="hidden" name="#CriteriaCluster#Sel" id="#CriteriaCluster#Sel" value="#Parameter.CriteriaName#">
								</cfif>
																								
								<cfloop query="Parameter">
								
								<tr>
								  
								  <td height="100%" valign="top" style="padding-left:2px;cursor:pointer;min-width:250px">										  					  								  
								 								  									 			  								 				   
										   <table height="100%" class="formspacing">
										   					  					  					   
										   <tr><td width="23" align="center" style="height:27;padding:3px">

										 	<cfquery name="validateLayoutFilter" 
											 datasource="AppsSystem" 
											 username="#SESSION.login#" 
											 password="#SESSION.dbpw#">
											 	SELECT 	*
											 	FROM 	Ref_ReportControlLayoutCluster C
											 			INNER JOIN Ref_ReportControlLayout L
											 				ON C.LayoutId = L.LayoutId
											 	WHERE 	L.ControlId = '#ControlId#'
											 	AND     C.CriteriaName = '#CriteriaName#'
										    </cfquery>

										    <cfset vOnClickClusterRefreshLayout = "1">

										    <cfif validateLayoutFilter.recordCount eq 0>
											   <cfset vOnClickClusterRefreshLayout = "0">
										    </cfif>
																							 																																	
											<cfif ClusterSelect.recordcount eq "1">
																																					
												<input type="radio" 
												    style   =  "width:18;height:18" 
													name    =  "#CriteriaCluster#" 
													id      =  "#CriteriaName#_radio"
													value   =  "#CriteriaName#" <cfif ClusterSelect.CriteriaValue eq CriteriaName>checked</cfif> 
													onClick =  "selcluster('#CriteriaCluster#','#currentRow#','#v#','#CriteriaName#','#vOnClickClusterRefreshLayout#')">
													
												</td>		
												
												<cfset layoutfilter = CriteriaName>
												
												<cfif ClusterSelect.CriteriaValue eq CriteriaName>
													<cfset layoutfilter = CriteriaName>
												</cfif>					
															
												<td valign="top" bgcolor="E6F2FF" style="cursor:pointer;border:1px solid silver;width:145px" 
												  onClick="document.getElementById('#CriteriaName#_radio').click()" title="Option:#Parameter.CriteriaMemo#">
																																			
														<table>													
															<tr><td class="labelit" style="padding:2px;font-size:15px">											
															<cf_tl id="#CriteriaDescription#"> 
															<cfif Obligatory.recordcount neq "0"><font color="FF0000">*</font></cfif>	
															</td></tr>
														</table>
																									
												</td>
																				
											<cfelse>										
																						
												<cfif CurrentRow eq "1">
													<cfset layoutfilter = CriteriaName>
												</cfif>		
												
											    <input type = "radio" 
												    style   = "width:18;height:18"
													name    = "#CriteriaCluster#" 							
													id      = "#CriteriaName#_radio"
													value   = "#CriteriaName#" <cfif CurrentRow eq "1">checked</cfif> 
													onClick = "selcluster('#CriteriaCluster#','#currentRow#','#v#','#CriteriaName#','#vOnClickClusterRefreshLayout#')">
													
												</td>																		
												
												<cfoutput>
												
												<cf_tl id="Cluster option" var="1">
												
												<td bgcolor="f1f1f1" style="cursor:pointer;padding-left:3px;height:30px;border:1px solid silver;width:235px" 
												onclick="document.getElementById('#CriteriaName#_radio').click()" title="#lt_text# :#Parameter.CriteriaMemo#">
																			
													<table cellspacing="0" cellpadding="0">																					
													<tr><td class="labelit" style="padding:2px;font-size:15px">
														<cf_tl id="#CriteriaDescription#"> 
														<cfif Obligatory.recordcount neq "0"><font color="FF0000">*</font></cfif>	
													</td></tr>	
													</table>	
																																				
												</td>												
												
												</cfoutput>		
															
											</cfif>																
																													
											</tr>									
											
											</table>
									
									</td>
																		
									<td style="padding-left:20px;padding-top:3px;width:100%;padding-right:4px">
									
									   <cfif ClusterSelect.recordcount eq "1">
										
											<cfif ClusterSelect.CriteriaValue eq "#CriteriaName#">
												<cfset cl = "regular">
												<cfset fldid = "#CriteriaCluster##CurrentRow#">
											<cfelse>
												<cfset cl = "hide">
												<cfset fldid = "#CriteriaCluster##CurrentRow#">
											</cfif>
															
										<cfelse>
										
											<cfif CurrentRow eq "1">
												<cfset cl = "regular">
												<cfset fldid = "#CriteriaCluster##CurrentRow#">
											<cfelse>
												<cfset cl = "hide">
												<cfset fldid = "#CriteriaCluster##CurrentRow#">
											</cfif>
																	
										</cfif>		
										
									    <cfset parent = "">
											
										<cfif criterianameparent neq "">
											
												<cfquery name="CheckParent" 
												 datasource="AppsSystem" 
												 username="#SESSION.login#" 
												 password="#SESSION.dbpw#">
													 SELECT *
													 FROM   Ref_ReportControlCriteria 
													 WHERE  ControlId = '#controlid#' 
													 AND    CriteriaName = '#CriteriaNameParent#'											
												</cfquery>
												
												<cfif CheckParent.recordcount eq "1">
												
													<cfset parent = "#CriteriaNameParent#">
												
												</cfif>
											
										</cfif>												
																														
										<cfif parent eq "" or (criteriatype neq "Lookup" and criteriatype neq "Unit")>
																																											   
											<cfinclude template="../SelectFormParameter.cfm"> 				
														
										<cfelse>
															
											<cf_securediv bind="url:SelectFormContainer.cfm?controlid=#controlid#&criterianame=#criterianame#&reportid=#url.reportid#&fldid=#fldid#&cl=#cl#&val={#parent#}" id="d#fldid#">
																										
										</cfif>			
																												
									</td>
							  	</tr>
																
								<cfset v = v + 1>
								
								<cfif Parameter.CriteriaInterface eq "Combo">
								
								   <tr class="hide">
									<td align="center" height="10">
									   <input type="text" name="#CriteriaName#search" id="#CriteriaName#search" size="10" maxlength="30" readonly style="width: 160;" class="search">
									</td>
								   </tr>
								   
								</cfif>
																													
							</cfloop>
																				
							</table>	
						 </td>			
			
				<cfelseif  CriteriaCluster neq "" and Find("#CriteriaCluster#", "#cluster#")>
				  
					  <!--- do nothing --->			
								
				<cfelse>	
				
				<!---------------------------------------------not clustered criteria------------------------------->
				
					<cfquery name="Parameter" 
					   dbtype="query"> 
						SELECT  * 
						FROM    BaseSet
						WHERE   CriteriaName = '#CriteriaName#' 				
					</cfquery>
																							
					<cfquery name="Span" datasource="appsSystem">
					    SELECT * 
						FROM   Ref_ReportControlCriteria
						WHERE  ControlId = '#Report.ControlId#'
						AND    CriteriaOrder LIKE '#Left(criteriaOrder,1)#%'
					</cfquery>
											
					<cfif Span.recordcount eq "1" and Report.TemplateBoxes gte "2">
					  <cfset span="2">
					<cfelse>
					  <cfset span="1">  
					</cfif>						
																								
					<td valign="top" colspan="#span#" style="padding-left:4px;padding-right:3px;border:0px solid silver">			
													
							<table align="center" width="100%" height="100%">
							
									<cfif Parameter.CriteriaMemo eq "">
										     <cfset tt = Parameter.CriteriaDescription>
										<cfelse>
										     <cfset tt = Parameter.CriteriaMemo>
										</cfif>
							
									<tr>																																																		 
										<td valign="top" style="min-width:240px;height:100%;height:30px;padding-top:6px;padding-left:4px;cursor:pointer;background-color:<cfif CriteriaClass eq 'Layout'>C1E0FF<cfelse>e1e1e1</cfif>;border:0px solid silver">										  
																															 																											
										    <table style="width:100%">
											
												<tr class="fixlengthlist">
												
													<td valign="top" title="#tt#">																						 
																																																																		
															<cfif findNoCase("?",Parameter.CriteriaDescription)>
															 <cfset sign = "">
															<cfelse>
															 <cfset sign = ":">	  													 
															</cfif>		
															<cf_tl id="#Parameter.CriteriaDescription#" var="1">
															<cfif Parameter.CriteriaObligatory eq "1">
																<cfset lbl = "#lt_text# #sign#&nbsp;<font color='800000'>*</font>">
															<cfelse>
															    <cfset lbl = "#lt_text# #sign#">
															</cfif>
															#lbl#														
																																								
													</td>
													
												</tr>
												
												<cfif Parameter.CriteriaInterface eq "Combo">
													<tr class="hide">
														<td align="center" height="10">
															<input type="text" name="#CriteriaName#search" id="#CriteriaName#search" size="10" maxlength="30" readonly style="width: 140;" class="search">
														</td>
													</tr>
												</cfif>
											
											</table>																				
																				
									   </td>								  
									
									<td style="padding-left:4px"></td>							
																													
									<td width="100%">
									
											<table style="width:100%">
											<tr>		
											
											<!--- check criterianame parent --->
											
											<cfset parent = "">
											
											<cfif criterianameparent neq "">
											
												<cfquery name="CheckParent" 
												 datasource="AppsSystem" 
												 username="#SESSION.login#" 
												 password="#SESSION.dbpw#">
													 SELECT *
													 FROM Ref_ReportControlCriteria 
													 WHERE  ControlId = '#controlid#' 
													 AND    CriteriaName = '#CriteriaNameParent#'											
												</cfquery>
												
												<cfif CheckParent.recordcount eq "1">
												
													<cfset parent = "#CriteriaNameParent#">
												
												</cfif>
											
											<!--- check if exists --->
											
											</cfif>
																																																	
											<cfif Parameter.CriteriaMemo neq "">
											
												<cf_UIToolTip tooltip="<table><tr><td>#Parameter.CriteriaMemo#</td></tr></table>">
												
													<td style="cursor:pointer">
																																							
														<cfif parent eq "" or (criteriatype neq "Lookup" and criteriatype neq "Unit")>
																										   
															<cfset cl           = "regular">
															<cfset fldid        = "box#CriteriaName#">
															<cfinclude template = "../SelectFormParameter.cfm"> 				
															
														<cfelse>
																													
															<cfdiv bind="url:SelectFormContainer.cfm?controlid=#controlid#&criterianame=#criterianame#&reportid=#url.reportid#&fldid=box#CriteriaName#&cl=regular&val={#parent#}">
																											
														</cfif>	
													
													</td>	
													
												</cf_UIToolTip>
												
											<cfelse>	
											
												<td>	
																													
																								
													<cfif parent eq "" or (criteriatype neq "Lookup" and criteriatype neq "Unit")>
																																						
														<cfset flash  = "No">
														<cfset cl     = "regular">
														<cfset fldid  = "box#CriteriaName#">
														<cfinclude template="../SelectFormParameter.cfm"> 	
													
													<cfelse>
																										
											    		<cfdiv bind="url:SelectFormContainer.cfm?controlid=#controlid#&criterianame=#criterianame#&reportid=#url.reportid#&fldid=box#CriteriaName#&cl=regular&val={#parent#}">
														
													</cfif>			
													
												</td>
												
											</cfif>	
																											
											</tr>										
											</table>				
										 </td>		
																
									</tr>
																					
							</table>
							
					 </td>	
												 
						 <!---
						 <cfcatch></cfcatch>						 
					</cftry>						
					---> 				
					
					<cfset row = row + 1>	
					 
				</cfif> 
				
			</cfif>	
					  
			</cfoutput>		
	
		</cfoutput>	
		
		</cfoutput>
		
	   </table>
	  	   	
	   </td>
	   
	</tr>
	
	<!--- extended select button --->
		
	<tr> 
	
	   <td valign="top" colspan="4" style="padding:2px">
	   
	   <table border="0" width="100%" cellspacing="0">
	 	         						
		<cfoutput query="Criteria" group="CriteriaOrder">
		
		<cfoutput group="CriteriaName">	
				
		<cfif CriteriaType eq "Extended" and CriteriaInterface eq "Combo">
					
			<tr id="#currentrow#">
			
			<td width="10"></td>
											
			<td width="154">
						
					<table style="width:100%">
					<tr>					
					
					<cfif CriteriaMemo neq "">
					
						<cf_UIToolTip  tooltip="#CriteriaMemo#">
							<td height="22" class="labelit">
						</cf_UIToolTip>
					
					<cfelse>					
						<td height="22" class="labelit">
					</cfif>
					
						<cf_tl id="#CriteriaDescription#">
					    <cfif CriteriaObligatory eq "1"><font color="800000">*</font></cfif>					
							
						</td>
					</tr>					
																			
					</table>	
				 </td>	
						 
				<td colspan="3" height="20" align="left" id="i#CriteriaName#">
				
				<cfquery name="Width" 
				  datasource="AppsSystem" 
				  username="#SESSION.login#" 
				  password="#SESSION.dbpw#">
					  SELECT SUM(FieldWidth) as FieldWidth
					  FROM   Ref_ReportControlCriteriaField 
					  WHERE  ControlId = '#ControlId#'
					  AND    CriteriaName = '#CriteriaName#'
					  AND    Operational = '1' 
				</cfquery>
				 
				<cfdiv id="i#currentrow#"						    	    
				    bind="url:HTML/FormHTMLExtList.cfm?row=#currentrow#&width=#width.FieldWidth#&mult=#LookupMultiple#&init=1&controlid=#controlid#&reportid=#reportid#&CriteriaName=#criterianame#">
													
				</td>
				<td></td>
			</tr> 		
				
			</cfif>
			
			</cfoutput>		
			</cfoutput>
						
			</table>
			
	</td> </tr>

</table>		

<cfset ajaxonload("doCalendar")>

