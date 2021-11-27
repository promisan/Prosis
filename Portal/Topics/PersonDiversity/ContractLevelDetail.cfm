
<cfinclude template="StaffingPreparation.cfm">

<cfquery name="FundingDetail" dbtype="query">
  	SELECT    LocationCode,				  			  
			  PostClassDescription,
			  PostClassColor,
			  AppointmentType,
			  AppointmentTypeDescription,
			  AppointmentColor,
			  ContractLevelParent,
	          ContractLevelBudget,
	          ContractLevelBudgetOrder, 				  							  
	          COUNT(DISTINCT PersonNo) as Total
 	FROM     GetStaff
  	GROUP BY  LocationCode,				  
			  ContractLevelBudget,
	          ContractLevelBudgetOrder, 			  
			  PostClassDescription,
			  PostClassColor,
			  AppointmentType,
			  AppointmentTypeDescription,
			  AppointmentColor,
			  ContractLevelParent
	ORDER BY  LocationCode, 
	          PostClass,
			  AppointmentType,
			  ContractLevelBudgetOrder					
</cfquery>

<cfquery name="FundingDetailPrior" dbtype="query">
  	SELECT    LocationCode,				  			  
			  PostClassDescription,
			  PostClassColor,
			  AppointmentType,
			  AppointmentTypeDescription,
			  AppointmentColor,
			  ContractLevelParent,
	          ContractLevelBudget,
	          ContractLevelBudgetOrder, 				  							  
	          COUNT(DISTINCT PersonNo) as Total
 	FROM      getPriorMonth
  	GROUP BY  LocationCode,				  
			  ContractLevelBudget,
	          ContractLevelBudgetOrder, 			 
			  PostClassDescription,
			  PostClassColor,
			  AppointmentType,
			  AppointmentTypeDescription,
			  AppointmentColor,
			  ContractLevelParent
	ORDER BY  LocationCode, 
	          PostClass,
			  AppointmentType,
			  ContractLevelBudgetOrder					
</cfquery>

<cfquery name="getLevelAll" dbtype="query">
	SELECT DISTINCT ContractLevelParent, ContractLevelBudget, ContractLevelBudgetOrder
	FROM 	FundingDetail
	UNION
	SELECT DISTINCT ContractLevelParent, ContractLevelBudget, ContractLevelBudgetOrder
	FROM 	FundingDetailPrior
</cfquery>

<cfquery name="getLevel" dbtype="query">
	SELECT 	ContractLevelParent, ContractLevelBudget, MAX(ContractLevelBudgetOrder) AS ContractLevelBudgetOrder
	FROM 	getLevelAll
	GROUP BY ContractLevelParent, ContractLevelBudget
	ORDER BY ContractLevelBudgetOrder
</cfquery>

<cfquery name="getClass" dbtype="query">
	SELECT DISTINCT PostClassDescription, MAX(PostClassColor) as PostClassColor
	FROM 	FundingDetail
	GROUP BY PostClassDescription 
	UNION
	SELECT DISTINCT PostClassDescription, MAX(PostClassColor) as PostClassColor
	FROM 	FundingDetailPrior
	GROUP BY PostClassDescription 
</cfquery>	

<cfquery name="getType" dbtype="query">
	SELECT DISTINCT AppointmentType, AppointmentTypeDescription, AppointmentColor
	FROM 	FundingDetail
	UNION
	SELECT DISTINCT AppointmentType, AppointmentTypeDescription, AppointmentColor
	FROM 	FundingDetailPrior
</cfquery>	

<table width="100%" align="center" class="formpadding">
	<tr class="fixlengthlist">
		<cfoutput>
		<td width="95%" style="font-size:15px;padding-left:4px"><cf_tl id="Distribution by Contract Level, Post Funding and Appointment Type"></td>
		<td align="right" class="labelit">
			<span id="printTitle" style="display:none;">#url.mission# - <cf_tl id="Distribution by Contract Level, Post Funding and Appointment Type"></span>
			<cf_tl id="Print" var="1">
			<cf_button2 
				mode		= "icon"
				type		= "Print"
				title       = "#lt_text#" 
				id          = "Print"					
				height		= "30px"
				width		= "35px"
				printTitle	= "##printTitle"
				printContent = ".clsContractLevelDetail">
		</td>
		<td align="right" style="padding-right:5px;" class="labelit" width="60px">
			<a onclick="$('##detailArea').html('');" style="cursor:pointer;">[<cf_tl id="Close">]</a>
		</td>
		</cfoutput>
	</tr>
	<tr>
		<td colspan="3" class="clsContractLevelDetail">
			<table width="100%" align="center" class="formpadding navigation_table">
				<tr class="labelmedium">
					<td style="font-weight:400; border:1px solid #C0C0C0; padding-left:4px; font-size:90%" width="auto">
						<cf_tl id="Position Class">
					</td>		
					<cfoutput query="getClass">
						<td 
							colspan="#2*getType.recordcount#" 
							style="border-left:1px solid silver;font-weight:450; border-right:1px solid ##C0C0C0; border-top:1px solid ##C0C0C0; border-bottom:1px solid ##C0C0C0; background-color:#PostClassColor#;" 
							align="center">
								#UCASE(PostClassDescription)#
						</td>
					</cfoutput>
					<td colspan="2" style="font-weight:450; border:1px solid #C0C0C0; background-color:#E6E6E6;" align="center" width="10%"><cf_tl id="Staff" var="1"><cfoutput>#ucase(lt_text)#</cfoutput></td>
				</tr>
				
				<tr class="line labelmedium">
					<td style="font-weight:300; border:1px solid #C0C0C0; padding-left:4px; font-size:85%" width="auto">
						<cf_tl id="Appointment">
					</td>
					
					<cfoutput query="getClass">
						<cfloop query="getType">
							<td style="font-weight:430; border-right:1px solid ##C0C0C0; background-color:#AppointmentColor#;" align="center" width="8%"><cf_tl id="#AppointmentTypeDescription#"></td>
							<td style="border-right:1px solid ##C0C0C0; background-color:#AppointmentColor#; font-size:70%;" align="center" width="2%">+/-</td>
						</cfloop>
					</cfoutput>

					<td style="border-right:1px solid #C0C0C0; background-color:#E6E6E6;" width="8%" align="center"><cf_tl id="Count"></td>
					<td style="border-right:1px solid #C0C0C0; background-color:#E6E6E6;" width="2%" align="center">+/-</td>
				</tr>
				
				<cfoutput query="getLevel" group="ContractLevelParent">
					<tr class="line navigation_row labelmedium" style="height:15px">
						
						<td style="min-width:100px;border-right:1px solid ##C0C0C0; border-left:1px solid ##C0C0C0; padding-left:5px; cursor:pointer;" onclick="$('.clsParent_#ContractLevelParent#').toggle();">
							<a>#ContractLevelParent#</a>
						</td>
						
						<cfloop query="getClass">

							<cfloop query="getType">

								<cfquery name="get" dbtype="query">
									SELECT 	SUM(Total) as Total
									FROM 	FundingDetail
									WHERE	ContractLevelParent  = '#getLevel.ContractLevelParent#'
									AND 	PostClassDescription = '#getClass.PostClassDescription#'
									AND 	AppointmentType      = '#AppointmentType#'
								</cfquery>
								
								<td style="border-right:1px solid ##C0C0C0; <cfif get.recordcount neq 0 AND get.Total neq "">background-color:#AppointmentColor#;</cfif>" align="center">
									<cfset vCurrentTotal = 0>
									<cfif get.Total neq "">
										#numberFormat(get.Total,',')#
										<cfset vCurrentTotal = get.Total>
									</cfif>
								</td>

								<cfquery name="getPrior" dbtype="query">
									SELECT 	SUM(Total) as Total
									FROM 	FundingDetailPrior
									WHERE	ContractLevelParent = '#getLevel.ContractLevelParent#'
									AND 	PostClassDescription = '#getClass.PostClassDescription#'
									AND 	AppointmentType     = '#AppointmentType#'
								</cfquery>
								
								<cfset vPriorTotal = 0>
								<cfif getPrior.Total neq "">							
									<cfset vPriorTotal = getPrior.Total>
								</cfif>					

								<cfset diff = vCurrentTotal - vPriorTotal>
								
								<td style="min-width:35px;border-right:1px solid ##C0C0C0; <cfif get.recordcount neq 0 AND get.Total neq "" AND diff neq 0>background-color:#AppointmentColor#;</cfif> font-size:80%;" align="center">
								
									<cfif vCurrentTotal neq "0" or vPriorTotal neq "0">
										<cfif diff eq "0">								 						
										    <!--- nada --->
										<cfelseif diff gt 0>
										    <font color="008000">+#diff#</font>
										<cfelse>
											<font color="FF0000">-#abs(diff)#</font>
										</cfif>						
									</cfif>
								</td>
							
							</cfloop>

						</cfloop>
						
						<cfquery name="get" dbtype="query">
							SELECT 	SUM(Total) as Total
							FROM 	FundingDetail
							WHERE	ContractLevelParent = '#ContractLevelParent#'
						</cfquery>

						<td style="min-width:80px;border-right:1px solid ##C0C0C0; background-color:##E6E6E6;" align="center">
							<cfset vCurrentTotal = 0>
							<cfif get.recordcount neq 0 AND get.Total neq "">
								#numberFormat(get.Total,',')#
								<cfset vCurrentTotal = get.Total>
							<cfelse>
								-
							</cfif>
						</td>

						<cfquery name="getPrior" dbtype="query">
							SELECT 	SUM(Total) as Total
							FROM 	FundingDetailPrior
							WHERE	ContractLevelParent = '#ContractLevelParent#'
						</cfquery>
						
						<cfset vPriorTotal = 0>
						<cfif getPrior.Total neq "">							
							<cfset vPriorTotal = getPrior.Total>
						</cfif>					

						<cfset diff = vCurrentTotal - vPriorTotal>
						
						<td style="min-width:80px;border-right:1px solid ##C0C0C0; <cfif get.recordcount neq 0 AND get.Total neq "" AND diff neq 0>background-color:##E6E6E6;</cfif> font-size:80%;" align="center">
						
							<cfif vCurrentTotal neq "0" or vPriorTotal neq "0">
								<cfif diff eq "0">								 						
								    <!--- nada --->
								<cfelseif diff gt 0>
								    <font color="008000">+#diff#</font>
								<cfelse>
									<font color="FF0000">-#abs(diff)#</font>
								</cfif>						
							</cfif>
						</td>
					</tr>

					<cfoutput>
						<tr class="line navigation_row labelmedium clsParent clsParent_#ContractLevelParent#" style="height:15px;">
						
							<td style="font-weight:430; min-width:100px;border-right:1px solid ##C0C0C0; border-left:1px solid ##C0C0C0; padding-left:15px;">
							#ContractLevelBudget#</td>
							
							<cfloop query="getClass">

								<cfloop query="getType">

									<cfquery name="get" dbtype="query">
										SELECT 	SUM(Total) as Total
										FROM 	FundingDetail
										WHERE	ContractLevelParent  = '#getLevel.ContractLevelParent#'
										AND 	ContractLevelBudget  = '#getLevel.ContractLevelBudget#'
										AND     PostClassDescription = '#getClass.PostClassDescription#'
										AND 	AppointmentType      = '#AppointmentType#'
									</cfquery>
									
									<td style="font-weight:400; border-right:1px solid ##C0C0C0; <cfif get.recordcount neq 0 AND get.Total neq "">background-color:#AppointmentColor#;</cfif>" align="center">
										<cfset vCurrentTotal = 0>
										<cfif get.Total neq "">
											#numberFormat(get.Total,',')#
											<cfset vCurrentTotal = get.Total>
										</cfif>
									</td>

									<cfquery name="getPrior" dbtype="query">
										SELECT 	SUM(Total) as Total
										FROM 	FundingDetailPrior
										WHERE	ContractLevelParent  = '#getLevel.ContractLevelParent#'
										AND 	ContractLevelBudget  = '#getLevel.ContractLevelBudget#'
										AND     PostClassDescription = '#getClass.PostClassDescription#'
										AND 	AppointmentType      = '#AppointmentType#'
									</cfquery>
									
									<cfset vPriorTotal = 0>
									<cfif getPrior.Total neq "">							
										<cfset vPriorTotal = getPrior.Total>
									</cfif>					

									<cfset diff = vCurrentTotal - vPriorTotal>
									
									<td style="font-weight:400; min-width:35px;border-right:1px solid ##C0C0C0; <cfif get.recordcount neq 0 AND get.Total neq "" AND diff neq 0>background-color:#AppointmentColor#;</cfif> font-size:80%;" align="center">
									
										<cfif vCurrentTotal neq "0" or vPriorTotal neq "0">
											<cfif diff eq "0">								 						
											    <!--- nada --->
											<cfelseif diff gt 0>
											    <font color="008000">+#diff#</font>
											<cfelse>
												<font color="FF0000">-#abs(diff)#</font>
											</cfif>						
										</cfif>
									</td>
								
								</cfloop>

							</cfloop>
							
							<cfquery name="get" dbtype="query">
								SELECT 	SUM(Total) as Total
								FROM 	FundingDetail
								WHERE	ContractLevelParent = '#ContractLevelParent#'
								AND 	ContractLevelBudget = '#ContractLevelBudget#'
							</cfquery>

							<td style="font-weight:400; border-right:1px solid ##C0C0C0; background-color:##E6E6E6;" align="center">
								<cfset vCurrentTotal = 0>
								<cfif get.recordcount neq 0 AND get.Total neq "">
									#numberFormat(get.Total,',')#
									<cfset vCurrentTotal = get.Total>
								<cfelse>
									-
								</cfif>
							</td>

							<cfquery name="getPrior" dbtype="query">
								SELECT 	SUM(Total) as Total
								FROM 	FundingDetailPrior
								WHERE	ContractLevelParent = '#ContractLevelParent#'
								AND 	ContractLevelBudget = '#ContractLevelBudget#'
							</cfquery>
							
							<cfset vPriorTotal = 0>
							<cfif getPrior.Total neq "">							
								<cfset vPriorTotal = getPrior.Total>
							</cfif>					

							<cfset diff = vCurrentTotal - vPriorTotal>
							
							<td style="font-weight:400; min-width:35px;border-right:1px solid ##C0C0C0; <cfif get.recordcount neq 0 AND get.Total neq "" AND diff neq 0>background-color:##E6E6E6;</cfif> font-size:80%;" align="center">
							
								<cfif vCurrentTotal neq "0" or vPriorTotal neq "0">
									<cfif diff eq "0">								 						
									    <!--- nada --->
									<cfelseif diff gt 0>
									    <font color="008000">+#diff#</font>
									<cfelse>
										<font color="FF0000">-#abs(diff)#</font>
									</cfif>						
								</cfif>
							</td>
						</tr>
					</cfoutput>
					
				</cfoutput>
				
				<cfoutput>
				
					<tr class="line labelmedium" style="height:25px">
						<td style="border-right:1px solid ##C0C0C0; border-left:1px solid ##C0C0C0; background-color:##E6E6E6; padding-left:5px;"><cf_tl id="Total" var="1">#ucase(lt_text)#</td>
						
						<cfloop query="getClass">

							<cfloop query="getType">

								<cfquery name="get" dbtype="query">
									SELECT 	SUM(Total) as Total
									FROM 	FundingDetail
									WHERE	PostClassDescription = '#getClass.PostClassDescription#'
									AND 	AppointmentType = '#AppointmentType#'
								</cfquery>

								<td style="border-right:1px solid ##C0C0C0; background-color:##E6E6E6;" align="center">
									<cfset vCurrentTotal = 0>
									<cfif get.recordcount neq 0 AND get.Total neq "">
										#numberFormat(get.Total,',')#
										<cfset vCurrentTotal = get.Total>
									<cfelse>
										0
									</cfif>
								</td>
								
								<cfquery name="getPrior" dbtype="query">
									SELECT 	SUM(Total) as Total
									FROM 	FundingDetailPrior
									WHERE	PostClassDescription = '#getClass.PostClassDescription#'
									AND 	AppointmentType      = '#AppointmentType#'
								</cfquery>

								<td style="border-right:1px solid ##C0C0C0; background-color:##E6E6E6; font-size:80%; color:##FF4D4D;" align="center">
									<cfset vPriorTotal = 0>
									<cfif getPrior.Total neq "">							
										<cfset vPriorTotal = getPrior.Total>
									</cfif>						
									
									<cfif vCurrentTotal neq "0" or vPriorTotal neq "0">
									    <cfset diff = vCurrentTotal - vPriorTotal>
										<cfif diff eq "0">								 						
										    <!--- nada --->
										<cfelseif diff gt 0>
										    <font color="008000">+#diff#</font>
										<cfelse>
											<font color="FF0000">-#abs(diff)#</font>
										</cfif>						
									</cfif>
								</td>

							</cfloop>
							
						</cfloop>
						
						<cfquery name="get" dbtype="query">
							SELECT 	SUM(Total) as Total
							FROM 	FundingDetail
						</cfquery>

						<td style="font-weight:bold; border-right:1px solid ##C0C0C0; background-color:##E6E6E6;" align="center">
							<cfset vCurrentTotal = 0>
							<cfif get.recordcount neq 0 AND get.Total neq "">
								#numberFormat(get.Total,',')#
								<cfset vCurrentTotal = get.Total>
							<cfelse>
								0
							</cfif>
						</td>

						<cfquery name="getPrior" dbtype="query">
							SELECT 	SUM(Total) as Total
							FROM 	FundingDetailPrior
						</cfquery>

						<td style="font-weight:bold; border-right:1px solid ##C0C0C0; background-color:##E6E6E6; font-size:80%; color:##FF4D4D;" align="center">
							<cfset vPriorTotal = 0>
							<cfif getPrior.Total neq "">							
								<cfset vPriorTotal = getPrior.Total>
							</cfif>						
							
							<cfif vCurrentTotal neq "0" or vPriorTotal neq "0">
							    <cfset diff = vCurrentTotal - vPriorTotal>
								<cfif diff eq "0">								 						
								    <!--- nada --->
								<cfelseif diff gt 0>
								    <font color="008000">+#diff#</font>
								<cfelse>
									<font color="FF0000">-#abs(diff)#</font>
								</cfif>						
							</cfif>
						</td>

					</tr>
					
				</cfoutput>

			</table>	
		</td>
	</tr>
	<tr><td height="15"></td></tr>
</table>

<cfset ajaxOnLoad("doHighlight")>