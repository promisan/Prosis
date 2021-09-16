
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

<table width="100%" align="center">
					
	<tr class="hide"><td id="process"></td></tr>	
	
	<!--- remove also the table to moved into Control table
	
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
	
	--->
	
	
	
	<!--- form before can be removed and embedded in the control 
	
	<cfinvoke component="Service.Process.Organization.Organization"  
			   method="getUnitScope" 
			   mode="Parent" 
			   OrgUnit="#get.OrgUnit#"
			   returnvariable="orgunits">	
			   
    --->			   
		   
	<!--- obtain the items to show --->
		 	   					   	  
	<cfquery name="MasterArea" 
	datasource="AppsProgram" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		  SELECT Code,
				 Description,
				 AreaCode, 
				 Area,
				 DescriptionMemo,
				 EnableStatusWeight,
				 HierarchyCode,
				 Obligatory,
											 		 
				 ( 	 SELECT TOP 1 S.ProgramCode
				     FROM   ProgramCategory S, 
				            Ref_ProgramCategory Q
				     WHERE  S.ProgramCode = '#URL.ProgramCode#'
				     AND    S.ProgramCategory = Q.Code
				     AND    Q.AreaCode  = R.AreaCode
					 AND    S.Status   != '9'
			     ) as Used		
		
		  <!--- enabled for mission and not used for budget preparation which are root entries by ddefinition but you can tweak this --->		  
		  		 
		  FROM   Ref_ParameterMissionCategory AS MC INNER JOIN
                 Ref_ProgramCategory AS R ON MC.Category = R.Code
				 
		  WHERE  Mission = '#mission#'		 
						  
		  <cfif selectarea eq "">
		  AND    AreaCode > '' and Area != 'Risk' and Area != 'Gender Marker' <!--- hardcoded --->
		  <cfelse>
		  AND    Area = '#selectarea#'  
		  </cfif>		
		  
		  AND    MC.BudgetEarmark = 0
		  AND    MC.Operational = 1 
				  
		  <!--- adjusted for period maybe not needed --->
		  
		  AND    ( Code IN (SELECT Code
		                    FROM   Ref_ProgramCategoryControl 
						    WHERE  Mission        = '#Mission#' 
						    AND    ControlElement = 'Period' 
						    AND    ControlValue   = '#url.period#')
						  
					OR 	  
					
					Code IN ( SELECT AreaCode 
					          FROM   ProgramCategoryPeriod Pe, Ref_ProgramCategory R
							  WHERE  Pe.ProgramCategory = R.Code
							  AND    ProgramCode = '#URL.ProgramCode#'
							  AND    Period      = '#url.period#')		
							  
				)			  	
				
		  
		  <!--- moved to control		  
		  <cfif Category neq "">		
		  AND    Code IN (#preservesingleQuotes(Category)#)
		  </cfif>	
		  --->
		  		  		  	 						  
		  <!--- only if the is defined for this prgram class --->		  
		  AND    (ProgramClass is NULL or ProgramClass = '#ProgramClass#')				  
		 
		  ORDER BY Area, HierarchyCode
		  		  		  
	</cfquery>	
							
	<tr><td style="padding-left:10px">
		   	
    <table style="width:99%" height="100%">
		
	<cfoutput query="MasterArea" group="Area">
	
		<!--- table to define what to collapse and hide --->
					
		<cfinvoke component    =  "Service.Process.Program.Category"  
			   method          =  "ReferenceTableControl" 
			   ControlObject   =  "Ref_ProgramCategory"
			   Mission         =  "#mission#"
			   ProgramCode     =  "#url.ProgramCode#" 
			   Period          =  "#url.period#"
			   AreaCode        =  "#areacode#"
			   returnvariable  =  "control">				   		
					
	    <cfoutput>		
							
        <cfset ar  = Area>
		<cfset arc = AreaCode>
		<cfset ard = Description>
		<cfset mem = DescriptionMemo>
								 							
		<TR class="fixrow">
		
			<td onClick="areaexpand('#arc#')" style="padding-left:10px;padding-bottom:6px;padding-top:6px;cursor: pointer;">
				<table width="100%">
					<tr>
					  <td align="left">
					  			  			
						   <table height="100%" width="100%">
						   						       
							   <tr><td valign="top" width="20" style="padding-left:3px;padding-right:5px;height:34px;padding-top:10px">
												   
							      <img src="#SESSION.root#/Images/portal_max.png" 
							          alt="Expand" id="#arc#Exp" border="0" height="18" width="18"
									  class="<cfif Used neq "">hide<cfelse>regular</cfif>" align="absmiddle">
									  				   
							      <img src="#SESSION.root#/Images/portal_min.png" 
							          id="#arc#Min" alt="Hide" border="0" height="18" width="18"
									  align="absmiddle" class="<cfif Used neq "">regular<cfelse>hide</cfif>">											  
								
								</td>
								
								<cfif mem neq "">
							      <td style="height:30px;padding-left:4px;font-size:25px;font-weight:200" colspan="1" valign="top" class="labelmedium"><font color="0080C0">#ard# <cfif Obligatory eq "1"><font color="FF0000">*)</font></cfif></u></b>:
								      <font size="3" color="808080">#mem#</font></td>
								<cfelse>
								  <td style="height:25px;padding-left:7px;font-size:25px;font-weight:200" colspan="1"  class="labellarge"><font color="0080C0">#ard# <cfif Obligatory eq "1"><font color="FF0000">*)</cfif></td>
								</cfif>
												
								</tr>
								
							</table>
											
						</td>
						
						<cfif EnableStatusWeight eq "1">
						
							<td style="padding:2px;" width="10%">
								<table width="100%">
									<tr>
										<td align="center" style="font-size:60px;font-weight:bold; color:##808080;" class="labelmedium">
											
											<cf_tl id="AVG" var="1">
											<cfset vAVGVal = 0>
											<cfset vAVGLabel = lt_text>
											
											<cfquery name="getAVGWeight" 
												datasource="AppsProgram" 
												username="#SESSION.login#" 
												password="#SESSION.dbpw#">
													SELECT	AVG(ISNULL(S.Weight*1.0,0)) as Average
													FROM	Ref_ProgramCategory C
															LEFT OUTER JOIN	ProgramCategoryStatus CS ON C.Code = CS.ProgramCategory
																AND CS.ProgramCode = '#url.programcode#'
															LEFT OUTER JOIN Ref_ProgramStatus S	ON CS.ProgramStatus = S.Code
													WHERE	Parent = '#arc#'
													AND 	C.Operational = 1
													AND 	C.EnableStatusWeight = 1
											</cfquery>
											
											<cfif getAVGWeight.recordCount gt 0 AND getAVGWeight.Average neq "">
												<cfset vAVGVal = getAVGWeight.Average>
											</cfif>
											
											<!--- kherrera(2020-10-26): new rules applied for GM 4--->
											<cfif vAVGVal eq 3 AND url.mission eq 'DPPA-DPO' AND (url.period eq "F21")>
												<cfset vAVGVal = 4>
												<cfset vAVGLabel = "">
											</cfif>
											
											#numberformat(vAVGVal, ",")#
										</td>
									</tr>
									<tr>
										<td align="center" style="font-size:11px;font-weight:200; color:##808080;" class="labelmedium">
								      		#vAVGLabel# #ard#
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
			<cfif control.deny neq "">
			AND       Code NOT IN (#preservesingleQuotes(control.deny)#)
			</cfif>
			AND       HierarchyCode LIKE '__.%'			
			ORDER BY  F.HierarchyCode			
		</cfquery>
																							
   		<tr><td width="100%" height="100%" style="padding-left:20px; padding-top:10px;">
							
			<cfif Used neq "" or selectarea neq "">			
			    <cfset cl = "regular">			
			<cfelse>			
				<cfset cl = "hide">			
			</cfif>											
									   					
    		<table width="100%" height="100%" align="right" class="#cl#" id="#arc#">
						
			<tr>
    			<td width="30" valign="top"></td>
				<td width="100%" height="100%">
							
				<table width="100%" height="100%" align="left">		
													
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
						
							<td width="98%" valign="top" height="100%">
																												
								<table width="100%" height="100%">
																
									<cfif Selected eq "" and Operational eq "0">
									    <TR id="main#code#" class="zzzzzzzhide">
									<cfelse>  
									    <TR id="main#code#" class="regular <cfif par eq "0" or (par eq "1" and EntryMode is "1")>linexxx</cfif>">
									</cfif>
									
									    <td style="width:100%">
										
											<table width="100%">
											
												<cfif par eq 1>
												
													<cf_tl id="Open" var="1">
													<tr id="clsHeader_#code#" title="#lt_text#" onclick="$('.clsDetail_#code#').toggle();" style="cursor:pointer; background-color:##f4f4f4;">
													
												<cfelse>
													<cfquery name="getSelected" dbtype="query">
														SELECT 	*
														FROM 	GROUPALL
														WHERE 	Parent = '#parent#'
														AND     SELECTED IS NOT NULL
														AND 	SELECTED <> ''
													</cfquery>
													
													<cfset vDisplay = "">
													<cfif FindNoCase(parent, control.coll) neq 0 AND getSelected.recordCount eq 0>
														<cfset vDisplay = "display:none;">
													</cfif>
													
													<tr class="clsElement clsDetail_#parent#" style="#vDisplay#">
												</cfif>
																							
												<cfif par eq "0" or (par eq "1" and EntryMode is "1")>		
																					
												 <td valign="top" align="right" style="width:60px;max-width:60px;min-width:60px;padding-top:4px;padding-right:5px">																													
													<cfif Selected eq "">
													    <input type="checkbox"  style="height:18px;width:18px" name="programcategory"  value="'#Code#'" onClick="hlsave(this.checked,'#url.programcode#','#code#','#mode#','#url.period#')">
													<cfelse>
													    <input type="checkbox"  style="height:18px;width:18px" name="programcategory"  value="'#Code#'" checked onClick="hlsave(this.checked,'#url.programcode#','#code#','#mode#','#url.period#')">
												    </cfif>												
												 </td>											 
												 
												<cfelse>											
												
												   <td style="width:30px;max-width:30px;min-width:30px"></td> 												
												   
												</cfif>
																					   																		
											    <TD style="width:100%;padding-top:2px">
												
													<table width="99%" height="100%">								  
														<tr>
														<td valign="top" style="padding:2px;padding-left:14px;padding-top:4px;height:17px" class="<cfif par eq '1'>labellarge<cfelse>labelmedium</cfif>">													
														<cfif par eq '1'><b></cfif>#Description#</b> <cfif descriptionmemo neq "">: #DescriptionMemo#</cfif>																									
														</td>														
														</tr>
													</table>
													
												</TD>				
												
											    </tr>
											
											<cfif selected eq "">
											
												<tr class="hide" id="textbox#code#"><td style="padding-left:58px;width:100%" colspan="3" id="textboxcontent#code#"></td></tr>
											
											<cfelse>
											
												<cfset vClass = "">
												<cfif par eq 0>
													<cfset vClass = "clsDetail_#parent#">
												</cfif>
											
												<tr class="regular clsElement #vClass#" id="textbox#code#">
												
													<td style="padding-left:58px;width:100%" colspan="3">																																												
													<cfset url.code = code>
													<cfset url.mode = mode>
													<cf_securediv id="textboxcontent#code#" bind="url:#SESSION.root#/ProgramREM/Application/Program/Category/getTextArea.cfm?programcode=#url.programcode#&code=#code#&mode=#mode#&period=#url.period#">																																																			
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
