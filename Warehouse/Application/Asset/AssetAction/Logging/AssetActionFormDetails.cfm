<!--
    Copyright © 2025 Promisan

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

        http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
-->

<cfparam name="URL.adate"     default="">
<cfparam name="URL.category"  default="">
<cfparam name="URL.key"       default="">
<cfparam name="URL.location"  default="">

<cf_tl id="No."         var = "vNo">
<cf_tl id="Description" var = "vDescription">
<cf_tl id="Mode"        var = "vMode">
<cf_tl id="Remarks"     var = "vRemarks">
<cf_tl id="Name"        var = "vName">
<cf_tl id="Make"        var = "vMake">
<cf_tl id="Model"       var = "vModel">										
<cf_tl id="DecalNumber" var = "vDecal">
<cf_tl id="SerialNo"    var = "vSerialNo">		
<cf_tl id="BarCode"     var = "vBarCode">		
<cf_tl id="Facility"    var = "vFacility">	

<cfset CLIENT.ActionCode = URL.Code>
<cfset CLIENT.Location = URL.Location>
<cfset Search_Bar_Printed = FALSE>

<cfif CLIENT.Location eq "[any]">
	<cfset CLIENT.Location = "">
</cfif>

<CF_DateConvert Value="#URL.adate#">
<cfset dte = dateValue>

<cfinclude template="AssetActionFunctions.cfm">

<cfquery name="Lookup" 
datasource="AppsMaterials" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT   *
    FROM     Ref_AssetActionList
	WHERE    Code = '#URL.Code#'
	AND      Operational = 1
	ORDER BY ListDefault DESC,ListOrder
</cfquery>

<cfif URL.scope eq "portal">

	<cfinvoke component  = "Service.Process.Materials.Asset"  
		method           = "AssetListUser" 
		mission          = "#URL.mission#"				
		warehouse        = "#CLIENT.location#"
		actioncategory   = "#URL.code#"
		returnvariable   = "vListAssets"
		category         = "Yes">	
			
<cfelse>

	<cfset pListAssets = "">
	
	<cfloop list="#URLDecode(URL.AssetId)#" index="element">
		<cfif Len(element) gt 10>
			<cfset pListAssets = ListAppend(pListAssets, #element#)>
		</cfif>
	</cfloop>	
	
	<cfinvoke component  = "Service.Process.Materials.Asset"  
		method           = "AssetListUser" 
		mission          = "#URL.mission#"				
		warehouse        = "#CLIENT.location#"
		actioncategory   = "#URL.code#"
		assetId          = "#pListAssets#"	
		returnvariable   = "vListAssets"
		category         = "Yes">		
	
</cfif>

<cfquery name="qCategory" 
datasource="AppsMaterials" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT DISTINCT I.Category, 
	                C.Description, 
					C.tabIcon,
					RC.DetailMode,
					RC.EditDays,
					count(*) as Counted
	FROM   AssetItem A 
	       INNER JOIN Item I ON  A.ItemNo = I.ItemNo 
		   INNER JOIN Ref_Category c ON c.Category = I.Category 
	       INNER JOIN Ref_AssetActionCategory RC ON C.Category = RC.Category 
		   <cfif URL.scope eq "portal"> 
			   AND RC.EnableTransaction != '1' 	
		   </cfif>	   
		   
	WHERE
	
	  <cfif vListAssets eq "">
	    1=0
	  <cfelse>
	    A.AssetId IN (#PreserveSingleQuotes(vListAssets)#)
	  </cfif>
	  
		<cfif URL.Key neq "">
			AND 
			(
				(
					A.Description LIKE '%#URL.Key#%' 
					OR
					A.SerialNo LIKE '%#URL.Key#%'
					OR
					A.AssetBarCode LIKE '%#URL.Key#%'
					OR
					A.AssetDecalNo LIKE '%#URL.Key#%'
					OR
					A.Model LIKE '%#URL.Key#%'
				)
				OR
				EXISTS
				(
					SELECT 'X'
			        FROM   AssetItem A2
			        WHERE  A2.ParentAssetId = A.AssetId				
					AND
					(
						A2.Description LIKE '%#URL.Key#%' 
						OR
						A2.SerialNo LIKE '%#URL.Key#%'
						OR
						A2.AssetBarCode LIKE '%#URL.Key#%'
						OR
						A2.AssetDecalNo LIKE '%#URL.Key#%'
						OR
						A2.Model LIKE '%#URL.Key#%'					
					)
				)
            )			
		</cfif>
	
	AND    ActionCategory = '#URL.Code#'	
	      	
	
	GROUP BY I.Category, 
	         C.Description, 
			 RC.DetailMode,
			 RC.EditDays,
			 C.TabIcon
</cfquery>	



<!--- ----------------------------------------------------------- --->
<!--- ---------------------check the result set------------------ --->
<!--- ----------------------------------------------------------- --->

<cfif qCategory.recordcount eq 0 or (qCategory.counted gte "100" and client.location eq "")>

	<cfoutput>

	<table width="100%" border="0" cellspacing="0" cellpadding="0">

	    <tr><td height="10"></td></tr>
		<tr>
			<td align="left" style="">
				<table width="100%" border="0" cellspacing="0" cellpadding="0">
					<tr style="padding-bottom:6px">
												
			    		<td style="padding-left:7px" class="labellarge">#DateFormat(dte,CLIENT.DateFormatShow)#</td>
													
							<td width="2%" style="padding-left:8px">
														
							<cfquery name="WarehouseList" 
							datasource="AppsMaterials" 
							username="#SESSION.login#" 
							password="#SESSION.dbpw#">
								SELECT *
								FROM   Warehouse
								WHERE  Mission = '#url.mission#'
								AND    Operational = 1
																
								<cfif getAdministrator(url.mission) eq "1">
	
								<!--- no filtering --->
								
								<cfelse>
								
									AND    MissionOrgUnitId IN (
									
											SELECT DISTINCT O.MissionOrgUnitId
											FROM   Organization.dbo.Organization O, 
									               Organization.dbo.OrganizationAuthorization OA
										    WHERE  O.Mission      = '#url.Mission#'
											AND    O.OrgUnit      = OA.OrgUnit
											AND    OA.UserAccount = '#SESSION.acc#'             
											AND    OA.Role        = 'WhsPick'  
								 
										    UNION
							      
										    SELECT  DISTINCT O.MissionOrgUnitId 
										    FROM    Organization.dbo.Organization O, 
											        Organization.dbo.OrganizationAuthorization OA
										    WHERE   O.Mission  = '#url.Mission#'
										    AND     O.Mission = OA.Mission
										    AND     OA.OrgUnit is NULL
										    AND     OA.UserAccount = '#SESSION.acc#'             
										    AND     OA.Role     = 'WhsPick'  
											  
											) 		
								</cfif>		
								
								ORDER BY City				 
							</cfquery>
							
							<cfform>
											
							<cfselect name="warehouse"
						          group="city"
						          queryposition="below"
						          query="warehouselist"
						          value="warehouse"
						          display="warehousename"
						          visible="Yes"
						          enabled="Yes"
								  selected="#CLIENT.Location#"
						          id="warehouse"
								  class="regularxl"						         
								  onchange="do_change('#URL.adate#','#URL.scope#','#URL.Mission#',$('##searchkey').val(),this.value);">
									  <option>[Any]</option>
								  </cfselect>	
							  
							  </cfform>									    
							
						</td>					
						
						<td valign="middle" align="right" style="padding-right:8px" class="labelit">
							
							<cfoutput>
							<table>
							<tr>
							<td class="labelit" style="padding-right:3px"><cf_tl id="Search for">:</td>
							<td><input type="text" id="searchkey" style="padding-left:3px" class="regularxl" name="searchkey" value="#URL.Key#"></td>
							<td style="padding-left:3px"><input type="button" name="Search" id="Search" class="button10s" value="Find" style="height:25px;width:40px" 
							 onclick="javascript:do_change('#URL.adate#','#URL.scope#','#URL.Mission#',$('##searchkey').val(),$('##warehouse').val());">
							</td>
							</tr>
							</table>
							</cfoutput>				
						</td>
					</tr>
					<tr><td height="5"></td></tr>
				</table>
			</td>
		</tr>
		
		<tr><td colspan="1" class="linedotted"></td></tr>
		
		<cfif qCategory.recordcount eq 0>
		
		<tr height="20"><td></td></tr>
		<tr>
			<td width="100%" align="center" class="labelmedium">
				<cf_tl id="Your search"> <cfif url.key neq "">'#URL.Key#'</cfif> <cf_tl id="returned"> <b>0</b> <cf_tl id="results."> 
			</td>	
		</tr>
		<tr height="5"><td></td></tr>		
		<tr>
			<td width="100%" align="center" class="labelmedium">			
				<a href="##" onclick="javascript:do_change('#URL.adate#','#URL.scope#','#URL.Mission#','')">
					<cf_tl id="Search again">
				</a>			
			</td>	
		</tr>	
		
		<cfelse>
		
		<tr height="20"><td></td></tr>
		<tr>
			<td width="100%" align="center" class="label">
				<cf_tl id="Your selection"> <cf_tl id="returned"> <b>#qCategory.counted#</b> <cf_tl id="results."> 
			</td>	
		</tr>
		<tr height="5"><td></td></tr>		
		<tr>
			<td width="100%" align="center" class="label">			
				<cf_tl id="Limit your criteria">						
			</td>	
		</tr>	
		
		</cfif>
		
	</table>
	</cfoutput>
	<cfabort>	
	
</cfif>

<cfform id="fdetails">

<cfset cnt  = 0>

<cfloop query = "qCategory">
	<cfinvoke component = "Service.Access"  
   method           = "AssetHolder" 
   mission          = "#URL.Mission#" 
   assetclass       = "#qCategory.category#"
   returnvariable   = "access">	
	
	<cfset cnt  = cnt + 1>
	
	<!--- ------------------------------------------------------------------------------------------ --->
	<!--- -------------1. get the potential list of assets to process for the logging--------------- --->
	<!--- ------------------------------------------------------------------------------------------ --->
	
	<cfquery name="getAssets" 
	datasource="AppsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT  AssetId
			   
		FROM    AssetItem A INNER JOIN Item I ON A.ItemNo = I.ItemNo 
			 		   
		WHERE   A.AssetId in (#PreserveSingleQuotes(vListAssets)#)  
	
		AND     I.Category = '#qCategory.Category#'
		
		<!--- item is not a child as it will be shown as part of the parent item in conjunction below --->
		
		AND     (
		           A.ParentAssetId is NULL 
				   OR 
				   A.ParentAssetId NOT IN (SELECT AssetId
				                           FROM   AssetItem 
										   WHERE  Mission = '#url.mission#')  
				)
				   
		<cfif URL.Key neq "">
			AND 
			(
				(
					A.Description LIKE '%#URL.Key#%' 
					OR
					A.SerialNo LIKE '%#URL.Key#%'
					OR
					A.AssetBarCode LIKE '%#URL.Key#%'
					OR
					A.AssetDecalNo LIKE '%#URL.Key#%'
					OR
					A.Model LIKE '%#URL.Key#%'
				)
				OR
				EXISTS
				(
					SELECT 'X'
			        FROM   AssetItem A2
			        WHERE  A2.ParentAssetId = A.AssetId				
					AND
					(
						A2.Description LIKE '%#URL.Key#%' 
						OR
						A2.SerialNo LIKE '%#URL.Key#%'
						OR
						A2.AssetBarCode LIKE '%#URL.Key#%'
						OR
						A2.AssetDecalNo LIKE '%#URL.Key#%'
						OR
						A2.Model LIKE '%#URL.Key#%'					
					)
				)
            )			
		</cfif>
	   
	</cfquery>	
	
	<cfset assids = "">

	<cfloop query="getAssets">
	
	   <cfif assids eq "">
	      <cfset assids = "'#assetid#'">
	   <cfelse>
	      <cfset assids = "#assids#,'#assetid#'">	  
	   </cfif>
	
	</cfloop>
	
	<!--- ------------------------------------------------------------------------------------------ --->
	<!--- now we retrieve the full list of asset items including the children of the selected assest --->
	<!--- ------------------------------------------------------------------------------------------ --->

	<cfquery name="qAssetsInsert" 
	datasource="AppsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	
		SELECT  IsNull(Len(ParentAssetId),0) as Level,
				I.Category,
			    A.*, 
								
				<!--- ----------------------------------------------- --->
				<!--- check if this item has been receiving issuances --->
				<!--- ----------------------------------------------- --->
				
				(  SELECT count(*) 
			       FROM   ItemTransaction 
			       WHERE  AssetId = A.AssetId
				   AND    TransactionDate >= '#dateformat(dte,client.dateSQL)#' 
				   AND    TransactionDate < '#dateformat(dte+1,client.dateSQL)#'
			    ) AS Distribution,
								
				<!--- ----------------------------------------------- --->
				<!--- check if this asset is a parent item ---------- --->
				<!--- ----------------------------------------------- --->
				
		        ParentId = 
				
						CASE IsNull(Len(ParentAssetId),0)
				             WHEN 0 THEN A.AssetId 
							 ELSE ParentAssetId 
							 END, 
						   			
		        (  SELECT count(*) 
			       FROM   AssetItem 
			       WHERE  ParentAssetId = A.AssetId
			    ) AS Children,
				
		        M.Description as MakeDescription
		
		FROM    AssetItem A 
		        INNER JOIN Item I ON A.ItemNo = I.ItemNo 
			    INNER JOIN Ref_Make M ON A.Make = M.Code 
			    
		WHERE	1=1
		
		<cfif assids neq "">
		   		AND A.AssetId   IN (#PreserveSingleQuotes(assids)#)  
				OR
		        A.ParentAssetId IN (#PreserveSingleQuotes(assids)#)     
		</cfif>   	
		
		ORDER BY  ParentId,ParentAssetId 
	</cfquery>	
	
	<cfquery name="qAssets" dbtype="query">	
			SELECT   0 as Type,*
			FROM     qAssetsInsert
			WHERE    Children = 0 AND ParentAssetId IS NULL
			
			UNION
			
			SELECT   1 as Type,*
			FROM     qAssetsInsert
			WHERE    Children != 0 
			OR       (Children = 0 AND ParentAssetId IS NOT NULL)
			ORDER BY Type, ParentId	
	</cfquery>
	
	<cfquery name="qMetrics" 
	datasource="AppsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT Category, Metric
		FROM   Ref_AssetActionMetric
		WHERE  
		<cfif assids neq "">
		Category  IN 
		(
			SELECT I.Category
			FROM   AssetItem A INNER JOIN Item I
			ON     A.ItemNo = I.ItemNo INNER JOIN Ref_Category c ON c.Category = I.Category
				INNER JOIN Ref_AssetActionCategory RC ON C.Category = RC.Category AND RC.EnableTransaction != '1' 	 
			WHERE   A.AssetId       IN (#PreserveSingleQuotes(assids)#)  
					OR
			        A.ParentAssetId IN (#PreserveSingleQuotes(assids)#)     	
		)
		<cfelse>
			Category = '#qCategory.Category#'
		</cfif>
		AND    ActionCategory = '#URL.Code#'
	</cfquery>	
	
	<TABLE width="98%" align="center" cellspacing="0" cellpadding="0" style="padding-left:10px; padding-right:15px">
	
	<tr><td height="3"></td></tr>
	
    <!--- --------------------------------------------------------------------- --->
    <!--- -----------top banner line for selection and filter------------------ --->
    <!--- --------------------------------------------------------------------- --->
	
	<cfif NOT Search_Bar_Printed>
	
	<tr>
		<td align="left">
			<table cellspacing="0" cellpadding="0" class="formpadding">
				<tr style="padding-bottom:6px">
				
					<cfoutput>
				    <td align="left" valign="middle" class="labellarge"><font size="1">date:</font>&nbsp;#DateFormat(dte,CLIENT.DateFormatShow)#</td>
													
					<td align="right">
						
							<table cellspacing="0" cellpadding="0" class="formpadding">
								<tr>
									<td align="left" valign="middle"  class="labellarge">
									<font size="1">#qCategory.Description# <cf_tl id="for">:</font>
									</td>								
								</tr>
							</table>
						
					</td>
					</cfoutput>
					
					<td width="2%">
												
					<cfquery name="WarehouseList" 
					datasource="AppsMaterials" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
						SELECT *
						FROM   Warehouse
						WHERE  Mission = '#url.mission#'
												
						<cfif getAdministrator(url.mission) eq "1">
	
						<!--- no filtering --->
						
						<cfelse>
						
							AND    MissionOrgUnitId IN (
							
									SELECT DISTINCT O.MissionOrgUnitId
									FROM   Organization.dbo.Organization O, 
							               Organization.dbo.OrganizationAuthorization OA
							        WHERE  O.Mission      = '#url.Mission#'
									AND    O.OrgUnit      = OA.OrgUnit
									AND    OA.UserAccount = '#SESSION.acc#'             
									AND    OA.Role        = 'WhsPick'  
						 
								    UNION
					      
								    SELECT  DISTINCT O.MissionOrgUnitId 
								    FROM    Organization.dbo.Organization O, 
									        Organization.dbo.OrganizationAuthorization OA
								    WHERE   O.Mission  = '#url.Mission#'
								    AND     O.Mission = OA.Mission
								    AND     OA.OrgUnit is NULL
								    AND     OA.UserAccount = '#SESSION.acc#'             
								    AND     OA.Role        = 'WhsPick'  
																	  
									) 		
						</cfif>		
						
						ORDER BY City		
								 
					</cfquery>
									
					<cfselect name="warehouse"
				          group="city"
				          queryposition="below"
				          query="warehouselist"
				          value="warehouse"
				          display="warehousename"
				          visible="Yes"
				          enabled="Yes"
						  selected="#CLIENT.Location#"
				          id="warehouse"
				          style="font:11px; width:224px"
						  onchange="javascript:do_change('#URL.adate#','#URL.scope#','#URL.Mission#',$('##searchkey').val(),this.value);">
							  <option>[Any]</option>
						  </cfselect>										    
					
					</td>
					
					<td valign="middle" align="right" style="padding-right:3px" class="label">
						<font size="1"><cf_tl id="Search for">:
						<cfoutput>
							<input type="text" id="searchkey" style="padding:1px" class="regular" name="searchkey" value="#URL.Key#">
							<input type="button" name="Search" id="Search" class="button10s" value="Find" style="height:18px;width:40px" 
							 onclick="javascript:do_change('#URL.adate#','#URL.scope#','#URL.Mission#',$('##searchkey').val(),$('##warehouse').val());">
						</cfoutput>				
					</td>
					
				</tr>
				<tr><td height="5"></td></tr>
			</table>
		</td>
	</tr>
		<cfset Search_Bar_Printed = TRUE>
	<cfelse>
		<tr height="20">
			<td align="left" style="padding-top:3px">
				<cfoutput>
				<font face="calibri" size="2">#qCategory.Description#</font>
				</cfoutput>
			</td>
		</tr>
	</cfif>
	<tr><td class="linedotted"></td></tr>
		
	<tr>
		<td style="padding:0px">
			
				<table width="100%" border="0" cellspacing="0" cellpadding="0" id="table_details">
				
					<cfoutput>
					
					<!--- --------------------------------------------------------------------- --->
    				<!--- ---------------------------table top label--------------------------- --->
				    <!--- --------------------------------------------------------------------- --->
					
					<tr>
						
						<td width="1%" align="left" style="padding-left:6px"></td>						
						<td width="5%" align="left" style="padding-left:6px">#vNo#</td>													
						<td style="padding-left:2px">#vDescription#</td>						
						<td style="padding-left:2px"></td>						
						<td style="padding-left:2px">#vMode#</td>						
													
						
						<cfset cnt_metrics = 0>
						
						<cfloop query= "qMetrics">
							<td style="padding-left:2px">#qMetrics.Metric#<cf_space spaces="30"></td>						
							<cfset cnt_metrics = cnt_metrics + 1>
						</cfloop>
						
						<td style="padding-left:2px" style="border-bottom:0px dotted gray;">#vRemarks#</td>		
									
					</tr>				
									
					</cfoutput>	
														
					<cfset cnt = 1>
					<cfset cur = "">
					
					<cfoutput query="qAssets">
									   										
						<cfif Children eq "0">	
						
							<cfif cur neq parentid>
								<cfset cur = parentid>
							</cfif>
							
						<cfelse>
						
							<cfif cur neq parentid>
								<cfset cur = parentid>
							</cfif>
						
						</cfif>	
						
						<cfif Children gte "1">			
						
								<!--- show the header information --->
							    <cfinclude template="AssetActionFormDetailsParent.cfm">		
													
						<cfelse>
																
								<cfquery name="qAssetAction" datasource = "AppsMaterials"
								username="#SESSION.login#" 
								password="#SESSION.dbpw#">
									SELECT * 
									FROM   AssetItemAction
									WHERE  AssetId = '#qAssets.AssetId#' AND ActionDate = #dte#
									AND    ActionCategory = '#URL.Code#'
									AND    ActionType = 'Standard'
								</cfquery>
								
								<!--- check for previous entries --->
								
								<cfquery name="qAssetActionPrevious" 
								datasource = "AppsMaterials"
								username="#SESSION.login#" 
								password="#SESSION.dbpw#">
									SELECT * 
									FROM   AssetItemAction
									WHERE  AssetId = '#qAssets.AssetId#' AND 
									ActionDate IN
									(
										SELECT DISTINCT TOP 2 ActionDate 
										FROM   AssetItemAction  AIA
										WHERE  AssetId        = '#qAssets.AssetId#'
										AND    ActionDate     < #dte#
										AND    ActionCategory = '#URL.Code#'
										AND    EXISTS
										(
											SELECT 'X' FROM AssetItemActionMetric
											WHERE AssetActionId = AIA.AssetActionId 
											AND   MetricValue IS NOT NULL
											AND   MetricValue != ''
										)
										ORDER BY ActionDate DESC
									)	
									AND ActionCategory = '#URL.Code#'
									AND    ActionType = 'Standard'
									ORDER BY ActionDate DESC
								</cfquery>		
								
								<tr>
								
									<cfif assetid neq parentid>
									
										<cfset bd = "border-left:1px dotted silver;border-right:1px dotted silver">
										
									<cfelse>
									
										<cfset bd = "border-top:1px dotted gray;border-left:1px dotted silver;">
									
									</cfif>		
									
									<cfif qAssetActionPrevious.recordcount eq "0">
									
										<cfset span = 2>
										
									<cfelse>
									
										<cfset span = 1+qAssetActionPrevious.recordcount>
										
									</cfif>			
																		
									<td align="center" valign="top" style="width:40;#bd#;padding-left:4px" 
									  rowspan="#span#"		  						  
									  bgcolor= "<cfif assetid neq parentid>EBF7FE</cfif>">
									  #cnt#.
									  <input type="hidden" id="id_#qAssets.AssetId#_0" name="id_#qAssets.AssetId#_0" class="aid" value="'#qAssets.AssetId#'">
									  <input type="hidden" id="t_#qAssets.AssetId#_0" name="t_#qAssets.AssetId#_0" class="tid" value="0">									  
									</td>
																	
									<td valign="top" style="border-top:0px dotted silver" rowspan="#span#">
																	
									    <table cellspacing="0" cellpadding="0">
										
											<tr>
											    <td class="description" style="padding-top: 5px;">	
												<cfif access eq "ALL" or Access eq "EDIT">
												<a href="javascript:AssetDialog('#assetid#')">
												<font face="Calibri" size="2" color="0080C0">#Description#
												</a>
												<cfelse>
												#Description#	
												</cfif>
												</td>
											</tr>	
				
											<tr>	
												<td class="description" style="padding-top: 0px;" class="labelit">	
												<cf_space spaces="30">																						
												 #AssetBarCode# <cfif AssetBarcode eq "0" or AssetBarCode eq "">#AssetDecalNo# </cfif> (#SerialNo#)												
												</td>
											</tr>
											
											<tr><td height="4"></td></tr>
											
										</table>	
										
									</td>	
									
									<td style="border-top:1px dotted silver" width="2%">
									    <cfswitch expression="#qCategory.DetailMode#">
											<cfcase value="Hour,Standard">
												<cf_img icon="expand" toggle= "Yes" onClick="maximize('ldetails#cnt#','#cnt#')" safemode="yes">
											</cfcase>											
											<cfcase value="None">
											
											</cfcase>
												
										</cfswitch>
									</td> 
										
									<td style="padding-top:4px;border-top:1px dotted silver" class="labelit">
									  #MakeDescription#: #Model#
									</td>

									<cfinclude template = "AssetActionAllowEdit.cfm">									 									
									
									<td style="height:40px;padding-top:4px;border-top:1px dotted silver">
									
										<cfselect name="#qAssets.AssetId#_Action_0"
								          query    = "Lookup"
								          value    = "ListCode"
								          display  = "ListValue"
								          selected = "#list_selected#"
								          visible  = "Yes"
								          enabled  = "Yes"
								          type     = "Text"
								          class    = "regularxl action"/>		
										  			
									</td>												
									
									
									<cfloop query= "qMetrics">
									
										
										<td align="right" style="width:80;border-top:1px dotted silver;padding-top:4px;padding-left:2px;padding-right:2px;">
										
											<cfif qAssetAction.recordcount neq 0>
											
												<cfquery name="qActionMetrics" 
													datasource = "AppsMaterials"
													username="#SESSION.login#" 
													password="#SESSION.dbpw#">
													SELECT * 
													FROM   AssetItemActionMetric
													WHERE  AssetActionId = '#qAssetAction.AssetActionId#' 
													AND    Metric = '#qMetrics.Metric#'
												</cfquery>
												
											<cfelse>
											
												<cfquery name="qActionMetrics" 
												datasource = "AppsMaterials"
												username="#SESSION.login#" 
												password="#SESSION.dbpw#">
														SELECT * 
														FROM   AssetItemActionMetric
														WHERE 1=0
												</cfquery>					
												
											</cfif>						
											
											<cfset t_disabled = disabled>
											<cfif disabled eq "">
												<cfif CheckMetric(qAssets.AssetId, qMetrics.Metric)>
													<cfset disabled = "">
												<cfelse>
													<cfset disabled = "disabled='disabled'">			
												</cfif>
											</cfif>
											
											<cfif qAssets.Category eq qMetrics.Category>
													<input type   = "text" 
														name      = "#qAssets.AssetId#_0_#qMetrics.Metric#" 
														id        = "#qAssets.AssetId#_0_#qMetrics.Metric#"
														size      = "7"
														maxlength = "7" 									
														class     = "regularxl value" 
														value     = "#qActionMetrics.MetricValue#"
														style     = "text-align:right;padding-right:3px;width:100%;padding-top:1px;"
														#disabled#>
											</cfif>													
											<cfset disabled = t_disabled>
											
										</td>
																				
									</cfloop>
									
									<td width="20%" style="border-top:1px dotted silver;padding-top:4px;padding-left:2px;padding-right:2px;">
										
											<input type   = "text" 
												name      = "#qAssets.AssetId#_ActionMemo_0" 
												id        = "#qAssets.AssetId#_ActionMemo_0"
												size      = "40" 
												maxlength = "40" 								
												class     = "regularxl memo"
												value     = "#qAssetAction.ActionMemo#"
												style     = "width:100%;text-align:left;padding-left:3px;padding-top:1px;"
												#disabled#>

											
									</td>
									
									<td></td>
									
									</tr>
															
									<!--- ------------------------------------ --->
									<!--- SHOW PREVIOUS INFO PREVIOUS LISTINGS --->
									<!--- ------------------------------------ --->
									
									<cfif qAssetActionPrevious.recordcount eq "0">
									
									<tr>
									<td></td>
									<td style="border-top:1px dashed silver" align="center" class="labelit description" height="16" colspan="#3+cnt_metrics#">
									No prior measurements found.
									</td></tr>
									
									<cfelse>
									
									<cfinclude template="AssetActionFormDetailsPrevious.cfm">
									
									</cfif>
																		
									<cfif distribution gte "1">
																											
										<tr><td colspan="#7+cnt_metrics#" style="border-left:1px dotted silver">
										<!--- show the issuance transactions for this day --->																		
										<cfinclude template="AssetSupplyDistribution.cfm">									
										<!--- ------------------------------------------- --->									
										</td></tr>
																		
									</cfif>
									
									<!--- --------------This template needs to be driven by the category / action setting --------------- --->																								 
									<cfset category = qCategory.Category>
								    <cfswitch expression="#qCategory.DetailMode#">
										<cfcase value="Hour">
											<cfinclude template="LogByHour\AssetActionByHour.cfm">		
										</cfcase>
										<cfcase value="Standard">
											<cfinclude template="LogByTransaction\AssetActionByTransaction.cfm">													
										</cfcase>											
									</cfswitch>

								    <cfset cnt = cnt + 1>	
																					  
						</cfif>	  							
													   				  
					</cfoutput>
										
			</table>
		</TD>
				
	</TR>
				
	</TABLE>
	
</cfloop>

</cfform>

<cfset AjaxOnLoad("initConsumption")>