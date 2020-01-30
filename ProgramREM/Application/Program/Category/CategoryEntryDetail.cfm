
<cfparam name="URL.ParentCode"   default="">
<cfparam name="URL.ProgramCode" default="">
<cfparam name="selectarea"      default="">
<cfparam name="mode"            default="">
<cfparam name="programclass"    default="">

<cfquery name="get" 
	datasource="AppsProgram" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT * 
		FROM   ProgramPeriod
		WHERE  ProgramCode = '#url.ProgramCode#'
		AND    Period      = '#url.period#'		
</cfquery>	

<cfif mode eq "" or mode eq "limited">

	<cfif url.programcode neq "" and selectarea eq "">  
	    <cfset mode = "fly">
	<cfelse>
	    <cfset mode = "submit">  
	</cfif>
	
</cfif>	

<table width="100%" border="0" cellspacing="0" cellpadding="0" align="center">
					
	<tr class="hide"><td id="process"></td></tr>	
	
	<cfif url.parentcode eq "">
	
		<cfset Category = "">
		
	<cfelse>
	
		<cfquery name="GroupFilter" 
		datasource="AppsProgram" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT * 
		FROM   Ref_ProgramGroupCategory
		WHERE  Code IN (SELECT ProgramGroup
		               FROM   ProgramGroup 
					   WHERE  ProgramCode = '#url.parentcode#')
		</cfquery>	
				
		<cfif groupFilter.recordcount eq "0">		
			<cfset Category = "">		
		<cfelse>			
			<cfset Category = quotedValueList(GroupFilter.Category)>			
		</cfif>
		
	</cfif>		
	
	<cfinvoke component="Service.Process.Organization.Organization"  
			   method="getUnitScope" 
			   mode="Parent" 
			   OrgUnit="#get.OrgUnit#"
			   returnvariable="orgunits">	
		   
	<!--- obtain the items to show --->
		 	   					   	  
	<cfquery name="MasterArea" 
	datasource="AppsProgram" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		  SELECT DISTINCT 
		         Code,
				 Description,
				 AreaCode, 
				 Area,
				 DescriptionMemo,
				 EnableStatusWeight,
				 HierarchyCode,
				 
				 (   SELECT TOP 1 Obligatory 
	                 FROM   Ref_ParameterMissionCategory 
				     WHERE  Mission = '#mission#' 					 
					 AND    Category = V.Code
					  <cfif orgunits neq "">
						  AND    (OrgUnit = '0'  or OrgUnit IN (#preserveSingleQuotes(orgunits)#))
						  <cfelse>
						  AND    (OrgUnit = '0') 
						  </cfif>
				 ) as Obligatory,		
				 		 
				 ( 	 SELECT TOP 1 S.ProgramCode
				     FROM   ProgramCategory S, 
				            Ref_ProgramCategory Q
				     WHERE  S.ProgramCode = '#URL.ProgramCode#'
				     AND    S.ProgramCategory = Q.Code
				     AND    Q.AreaCode  = V.AreaCode
					 AND    S.Status   != '9'
			     ) as Used		
		
		  <!--- enabled for mission and not used for budget preparation which are root entries by ddefinition but you can tweak this --->		  
		  		 
		  FROM   Ref_ProgramCategory V 
		  
		  <cfif selectarea eq "">
		  WHERE  AreaCode > '' and Area != 'Risk' and Area != 'Gender Marker' <!--- hardcoded --->
		  <cfelse>
		  WHERE  Area = '#selectarea#'  
		  </cfif>		 
				  
		  <!--- adjusted --->
		  
		  AND   (
		  
		  			Code IN (
		                  SELECT Category 
		                  FROM   Ref_ParameterMissionCategory 
						  WHERE  Mission = '#mission#' 
						  <!--- global access or units are enabled --->
						  <cfif orgunits neq "">
						  AND    (OrgUnit = '0'  or OrgUnit IN (#preserveSingleQuotes(orgunits)#))
						  <cfelse>
						  AND    (OrgUnit = '0') 
						  </cfif>
						  AND    (Period is NULL or Period = '#url.Period#')						  
						  AND    BudgetEarmark = 0
						  AND    Operational = 1
						  )	  
						  
					OR 		
					
					(
					<!--- has been valid in this period --->			
					Code IN ( 
					
							  SELECT Parent 
					          FROM   ProgramCategoryPeriod Pe, Ref_ProgramCategory R
							  WHERE  Pe.ProgramCategory = R.Code
							  AND    ProgramCode = '#URL.ProgramCode#'
							  AND    Period      = '#url.period#')										
										
					)
										
				)	
		  		  
		  <cfif Category neq "">		
		  AND    Code IN (#preservesingleQuotes(Category)#)
		  </cfif>	
		  		  		  	 						  
		  <!--- only if the is defined for this prgram class --->		  
		  AND    (ProgramClass is NULL or ProgramClass = '#ProgramClass#')				  
		 
		  ORDER BY Area, HierarchyCode
		  
	</cfquery>	
	
		
			
	<tr><td style="padding-left:10px">
		   	
    <table width="100%" height="100%" border="0" cellspacing="0" cellpadding="0">
		
	<cfoutput query="MasterArea" group="Area">
		
	    <!--- Hanno hiding this line 26/2/2016 as no longer needed and takes unneeded space i think
		
		<cfif Area neq "Risk">	
		    <tr><td style="height:50;font-size:27px" class="labellarge">#Area#</td></tr>		
		</cfif>
		
		--->
			
	    <cfoutput>
					
        <cfset ar  = Area>
		<cfset arc = AreaCode>
		<cfset ard = Description>
		<cfset mem = DescriptionMemo>
		 							
		<TR>
			<td onClick="areaexpand('#arc#')" style="padding-top:1px;cursor: pointer;">
				<table width="100%">
					<tr>
					  <td align="left">
					  			  			
						   <table height="100%" width="100%" border="0" cellspacing="0" cellpadding="0">
						   
						       <tr><td height="10"></td></tr>
							   <tr><td valign="top" width="20" style="padding-left:3px;padding-right:5px;height:34px;padding-top:10px">
												   
							      <img src="#SESSION.root#/Images/portal_max.png" 
							          alt="Expand" id="#arc#Exp" border="0" height="18" width="18"
									  class="<cfif Used neq "">hide<cfelse>regular</cfif>" align="absmiddle">
									  				   
							      <img src="#SESSION.root#/Images/portal_min.png" 
							          id="#arc#Min" alt="Hide" border="0" height="18" width="18"
									  align="absmiddle" class="<cfif Used neq "">regular<cfelse>hide</cfif>">						  
								
								</td>
								
								<cfif mem neq "">
							      <td style="height:40px;padding-left:4px;font-size:25px;font-weight:200" colspan="1" valign="top" class="labelmedium"><font color="0080C0"><u>#ard# <cfif Obligatory eq "1"><font color="FF0000">*)</font></cfif></u></b>:
								      <font size="3" color="808080">#mem#</font></td>
								<cfelse>
								  <td style="height:25px;padding-left:7px;font-size:25px;font-weight:200" colspan="1"  class="labellarge"><font color="0080C0"><u>#ard#</u> <cfif Obligatory eq "1"><font color="FF0000">*)</cfif></td>
								</cfif>
												
								</tr>
								
							</table>
											
						</td>
						
						<cfif EnableStatusWeight eq "1">
							<td style="padding:5px;" width="10%">
								<table width="100%">
									<tr>
										<td align="center" style="font-size:60px;font-weight:bold; color:##808080;" class="labelmedium">
											<cfquery name="getAVGWeight" 
												datasource="AppsProgram" 
												username="#SESSION.login#" 
												password="#SESSION.dbpw#">
													SELECT	AVG(ISNULL(S.Weight*1.0,0)) as Average
													FROM	Ref_ProgramCategory C
															LEFT OUTER JOIN	ProgramCategoryStatus CS
																ON C.Code = CS.ProgramCategory
																AND CS.ProgramCode = '#url.programcode#'
															LEFT OUTER JOIN Ref_ProgramStatus S
																ON CS.ProgramStatus = S.Code
													WHERE	Parent = '#arc#'
													AND 	C.Operational = 1
													AND 	C.EnableStatusWeight = 1
											</cfquery>
											
											<cfif getAVGWeight.recordCount gt 0 AND getAVGWeight.Average neq "">
												#numberformat(getAVGWeight.Average, ",")#
											<cfelse>
												-
											</cfif>
											
										</td>
									</tr>
									<tr>
										<td align="center" style="font-size:11px;font-weight:200; color:##808080;" class="labelmedium">
								      		<cf_tl id="AVG"> #ard#
									  	</td>
									</tr>
								</table>
							</td>
						</cfif>
					</tr>
				</table>
			</td>
		</tr>						
				
		<cfquery name="GroupAll" 
		datasource="AppsProgram" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT    F.*, 							  
			          (SELECT ProgramCode 
					   FROM   ProgramCategory 
					   WHERE  ProgramCategory = F.Code 
					   AND    ProgramCode     = '#URL.ProgramCode#'
					   AND    Status != '9') as Selected
			FROM      Ref_ProgramCategory F  		  	   
			WHERE     F.AreaCode = '#Arc#' 
			AND       HierarchyCode LIKE '__.%'			
			ORDER BY  F.HierarchyCode			
		</cfquery>
		
													
   		<tr><td width="100%" height="100%" style="padding-left:20px; padding-top:20px;">
								
			<cfif Used neq "" or selectarea neq "">			
			    <cfset cl = "regular">			
			<cfelse>			
				<cfset cl = "hide">			
			</cfif>					
									   					
    		<table width="100%" height="100%" border="0" cellspacing="0" cellpadding="0" align="right" class="#cl#" id="#arc#">
						
			<tr>
    			<td width="30" valign="top"></td>
				<td width="100%" height="100%" style="border:0px solid silver">
				
				<table width="100%" 
				    height="100%" 
					border="0" 
					cellspacing="0" 					
					cellpadding="0" 					
					align="left">		
					
					<cfset row = 0>
																						
					<cfloop query="GroupAll">									
																										
						<cfquery name="CheckParent" 
						    datasource="AppsProgram" 
				   		    username="#SESSION.login#" 
						    password="#SESSION.dbpw#">
					    		SELECT TOP 1 *
							    FROM   Ref_ProgramCategory F
							    WHERE  Parent = '#Code#'			  
					    </cfquery>		
												
						<cfif CheckParent.recordcount gte "1">
						  <cfset par = 1>
						<cfelse>
						  <cfset par = 0>  
						</cfif>		
																		
						<cfset row = row+1>
						
						<cfif CheckParent.recordcount eq "1" and currentrow neq "1">
						   <tr><td height="1"></td></tr>
						</cfif>
																	
						<TR>
						
							<td width="100%" valign="top" height="100%">
																					
							<table width="100%" height="100%" cellspacing="0" cellpadding="0">
							
								<cfif Selected eq "" and Operational eq "0">
								    <TR id="main#code#" class="hide">
								<cfelse>  
								    <TR id="main#code#" class="regular line">
								</cfif>
								
								    <td style="width:100%;border-top:0px solid b0b0b0;">
									
										<table width="100%" cellspacing="0" cellpadding="0" border="0">
										
											<tr>											
											<cfif par eq "0" or (par eq "1" and EntryMode is "1")>											
											 <td width="40" align="right" style="padding-left:19px;padding-top:3px;padding-right:5px">		
																										
												<cfif Selected eq "">
												    <input type="checkbox"  style="height:17px;width:17px" name="programcategory"  value="'#Code#'" onClick="hlsave(this.checked,'#url.programcode#','#code#','#mode#','#url.period#')">
												<cfelse>
												    <input type="checkbox"  style="height:17px;width:17px" name="programcategory"  value="'#Code#'" checked onClick="hlsave(this.checked,'#url.programcode#','#code#','#mode#','#url.period#')">
											    </cfif>												
											 </td>											 
											<cfelse>											
											   <td></td> 												
											</cfif>
																				   																		
										    <TD width="99%" style="padding-top:3px">
											
												<table width="99%" cellspacing="0" cellpadding="0" height="100%">								  
													<tr>
													<td valign="top" style="padding:3px;padding-left:14px;padding-top:4px;height:17px">
													<table width="99%">
													<tr>
													<td width="20%" class="<cfif par eq '1'>labellarge<cfelse>labelmedium</cfif>">
													<cfif par eq '1'><b></cfif><u>#Description#</u></b> <cfif descriptionmemo neq "">: #DescriptionMemo#</cfif>
													</td>													
													</tr></table>													
													</td>														
													</tr>
												</table>
												
											</TD>				
											
										    </tr>
										
										<cfif selected eq "">
										
											<tr class="hide" id="textbox#code#"><td colspan="3" id="textboxcontent#code#"></td></tr>
										
										<cfelse>
										
											<tr class="regular" id="textbox#code#">
												<td style="padding-left:28px;border:0px solid gray;width:100%" colspan="3">		
																																											
												<cfset url.code = code>
												<cfset url.mode = mode>
												<cfdiv id="textboxcontent#code#" bind="url:#SESSION.root#/ProgramREM/Application/Program/Category/getTextArea.cfm?programcode=#url.programcode#&code=#code#&mode=#mode#&period=#url.period#">
																																																		
												</td>
											</tr>
										 
										</cfif>
										
										<cfif EnableTarget eq "1">
											
											<cfif selected eq "">
												<cfset cl = "hide">
											<cfelse>
											    <cfset cl = "regular">
											</cfif>																
											<tr class="#cl#" id="targetbox#code#">											
																					
											<td colspan="3" style="padding-left:40px;padding-top:2px" id="targetdetail_#code#">
											
												<cfset url.category = code>																
												<cfinclude template="../Target/TargetListing.cfm">
																	
											</td>
											
											</tr>
											
										
										</cfif>
										
										</table>
									
								   </td>
								</tr>
								
								<!--- make this an option to be enabled for a category, like we have text boxes to be added --->
																					
							</table>
							</td>
																					
						</tr>
																	
					</cfloop>
												
			    </table>
				
				</td></tr>
				
				</table>
									
			</td></tr>	
			
		</cfoutput>	
					
	</cfoutput>	
	
	</table>
		
    </td></tr>
		
</table>	
