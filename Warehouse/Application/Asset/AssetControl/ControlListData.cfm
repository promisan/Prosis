<!--
    Copyright © 2025 Promisan B.V.

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
<cfquery name="Clean" 
	datasource="AppsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	DELETE   AssetDisposal
	WHERE    ActionStatus = '0'
	AND      OfficerUserId = '#SESSION.acc#'	
</cfquery>

<cfparam name="url.mde" default="0">
<!--- refresh all shown values --->
<cfif url.mde eq "1">
	<cfinclude template="ControlListPrepare.cfm">
</cfif>

<cfparam name="URL.page"    default="1">
<cfparam name="client.view" default="location">
<cfparam name="URL.view" default="#client.view#">
<cfset client.view = url.view>
<cfparam name="URL.sort" default="B.Description">

<!--- filter values from ControlListLocate.cfm --->

<cfparam name="Form.Operational"     default="1">
<cfparam name="Form.Location"        default="">
<cfparam name="Form.Category"        default="">
<cfparam name="Form.Make"            default="">
<cfparam name="Form.SerialNo"        default="">
<cfparam name="Form.PersonNo"        default="">
<cfparam name="Form.AssetBarcode"    default="">
<cfparam name="Form.AssetDecalNo"    default="">
<cfparam name="Form.OrgUnitVendor"   default="">
<cfparam name="Form.AssetItem"       default="">
<cfparam name="Form.DateStart"       default="">
<cfparam name="Form.DateEnd"         default="">
<cfparam name="Form.CreatedStart"    default="">
<cfparam name="Form.CreatedEnd"      default="">

<cfset condition = "">

<cfif form.operational eq "0">
	<cfset condition    = "#condition# AND (B.Operational = 0 OR AssetId IN (SELECT AssetId FROM Materials.dbo.AssetItemDisposal WHERE Assetid = B.AssetId))">
<cfelse>
	<cfset condition    = "#condition# AND (B.Operational = 1 AND AssetId NOT IN (SELECT AssetId FROM Materials.dbo.AssetItemDisposal WHERE Assetid = B.Assetid))">	
</cfif>

<cfif Form.Make neq "">
     <cfset condition   = "#condition# AND B.Make = '#Form.Make#'">
</cfif>
  
<cfif Form.Location neq "">
      <cfset condition  = "#condition# AND B.Location = '#Form.Location#'">
</cfif>
  
<cfif Form.SerialNo neq "">
      <cfset condition  = "#condition# AND (B.SerialNo LIKE '%#Form.SerialNo#%' OR  B.AssetBarCode LIKE ('%#Form.SerialNo#%') or B.AssetDecalNo LIKE '%#Form.SerialNo#%')">
</cfif>
  
<cfif Form.OrgUnitVendor neq "">
     <cfset condition   = "#condition# AND P.OrgUnitVendor = '#Form.OrgUnitVendor#'">
</cfif>

<cfif Form.Category neq "">
     <cfset condition   = "#condition# AND B.ItemNo IN (SELECT ItemNo FROM Materials.dbo.Item WHERE Category = '#Form.Category#')">
</cfif>
	
<cfif Form.AssetItem neq "">
     <cfset condition   = "#condition# AND (ParentDescription LIKE '%#Form.AssetItem#%' OR B.Description LIKE '%#Form.AssetItem#%' OR Model LIKE '%#Form.AssetItem#%')">
</cfif>	

<cfif Form.PersonNo neq "">
     <cfset condition   = "#condition# AND B.PersonNo = '#Form.PersonNo#'">
</cfif>

<cfif url.id eq "ITM">	
	
		<cfquery name="Topic" 
		datasource="appsMaterials" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		  SELECT  R.*
		   FROM   ItemTopic T, Ref_Topic R
		  WHERE   ItemNo = '#URL.ID1#'
		    AND   R.Operational = 1
			AND   R.Code = T.Topic
		</cfquery>
			
		<cfif Topic.recordcount gt "0">
			
			<cfoutput query="topic">
			
				<cfparam name="Form.ListCode_#Code#" default="">	
				<cfset val = evaluate("Form.ListCode_#Code#")>
				
				<cfif val neq "">
				
					 <cfset condition   = "#condition# AND B.AssetId IN (SELECT AssetId FROM Materials.dbo.AssetItemTopic WHERE Topic = '#Code#' and ListCode IN ('#val#'))">
				
				</cfif>					
			
			</cfoutput>
		
		</cfif>	
		
</cfif>		
  
<cfif Form.DateStart neq "">
     <cfset dateValue = "">
	 <CF_DateConvert Value="#Form.DateStart#">
	 <cfset dte = dateValue>
	 <cfset condition = "#condition# AND B.ReceiptDate >= #dte#">
</cfif>	
  
<cfif Form.DateEnd neq "">
	 <cfset dateValue = "">
	 <CF_DateConvert Value="#Form.DateEnd#">
	 <cfset dte = dateValue>
	 <cfset condition = "#condition# AND B.ReceiptDate <= #dte#">
</cfif>

<cfif Form.CreatedStart neq "">
     <cfset dateValue = "">
	 <CF_DateConvert Value="#Form.CreatedStart#">
	 <cfset dte = dateValue>
	 <cfset condition = "#condition# AND B.Created >= #dte#">
</cfif>	
  
<cfif Form.CreatedEnd neq "">
	 <cfset dateValue = "">
	 <CF_DateConvert Value="#Form.CreatedEnd#">
	 <cfset dte = dateValue>
	 <cfset condition = "#condition# AND B.Created <= #dte+1#">
</cfif>

<cf_verifyOperational 
         module="Procurement" 
		 Warning="No">
		 
<cfset currrow = 0>

    
  <cfquery name="SearchResult" 
	datasource="AppsQuery" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#"> 
	
		SELECT  B.*, 
		        (
		        SELECT ActionStatus 
				FROM Materials.dbo.AssetItemOrganization 
				WHERE AssetId = B.AssetId and MovementId = B.OrgMovementId 
				) as OrgStatus,
				
				(
		        SELECT Status 
				FROM Materials.dbo.AssetItemLocation 
				WHERE Assetid = B.AssetId and MovementId = B.LocationMovementId 
				) as LocationStatus,
				
		        M.Description as MakeDescription,
		        Per.LastName, 
				Per.FirstName, 
				Per.Birthdate, 
				O.OrgUnitName, 
				<cfif operational eq "1">
				P.OrgUnitVendor, 
				<cfelse>
				'0' as OrgUnitVendor,
				</cfif>
				Loc.LocationCode,
				Loc.LocationName as LocationName, 
				
					(SELECT   count(*)
					 FROM     Materials.dbo.AssetItemDisposal I 
		             WHERE    I.AssetId = B.AssetId				
					) as Disposal
					
		FROM    #SESSION.acc#AssetBase#url.id# B 
		        INNER JOIN Organization.dbo.Organization O ON B.OrgUnit = O.OrgUnit 
				INNER JOIN Materials.dbo.Ref_Make M ON B.Make = M.Code 
				<cfif operational eq "1">
				LEFT OUTER JOIN Purchase.dbo.Purchase P ON B.PurchaseNo = P.PurchaseNo 
				</cfif>
				LEFT OUTER JOIN Employee.dbo.Person Per    ON B.PersonNo = Per.PersonNo 
				LEFT OUTER JOIN Materials.dbo.Location Loc ON B.Location = Loc.Location			
		
		WHERE   B.Assetid IN (SELECT AssetId 
		                      FROM   Materials.dbo.AssetItem 
							  WHERE  AssetId = B.AssetId)	
							  
        #preservesingleQuotes(condition)# 
				 
		ORDER BY #URL.Sort# 

  </cfquery> 
   					
<cfset counted = Searchresult.recordcount>
	
<table width="98%" align="center">

<tr>

<td colspan="1" height="30">	

	<table class="formspacing"><tr>
		
	<cfif url.id neq "Per"> 
	
	   <cfoutput>
		
		<td>
		
		    <button name="DetailShow" id="DetailShow" type="Button"
				class="button10g" 
				style="width:35;height:26" 
			    onClick="detail('show')">	
				<img src="#SESSION.root#/images/Expand_panel.png" alt="Show Details" border="0">
		    </button>		
		 
		</td>
		
		<td>
		
			<button name="DetailHide" id="DetailHide" class="hide" type="Button"
				class="button10g" 
				style="width:35;height:26" 
			    onClick="detail('hide')">	
				<img src="#SESSION.root#/images/Collapse_panel.png" alt="Hide" border="0">
            </button>	

		</td>
		
		</cfoutput>
		
	</cfif>
	
	<td>
	
	
	
	<cfset filter = replaceNoCase(condition,"'","|","ALL")>	
	
	<!---
		
    <!--- button to show inquiry function --->
	<cfinvoke component="Service.Analysis.CrossTab"  
		  method      = "ShowInquiry"
		  buttonName  = "Inquiry"
		  buttonClass = "button10g"
		  buttonIcon  = "#SESSION.root#/images/dataset.png"
		  buttonText  = "Dataset"
		  buttonStyle = "width:95;height:26"
		  reportPath  = "Warehouse\Application\Asset\AssetControl\"
		  SQLtemplate = "FactTableAsset.cfm"
		  queryString = "id=#url.id#&header=1"
		  filter      = "#filter#"		  
		  ajax        = "1"
		  dataSource  = "appsQuery" 
		  module      = "Warehouse"
		  reportName  = "Facttable: Non-Expendables"
		  olap        = "1"
		  table1Name  = "Equipment"> 	
		  
		  --->	  
		  
	</td>
		
	<td>
		
		  <!--- button to show inquiry function --->

		  <cfinvoke component="Service.Analysis.CrossTab"  
		  method      = "ShowInquiry"
		  buttonName  = "Inquiry"
		  buttonClass = "button10g"		  
		  buttonText  = "Excel"
		  buttonStyle = "width:95;height:26"
		  reportPath  = "Warehouse\Application\Asset\AssetControl\"
		  SQLtemplate = "ExcelAsset.cfm"
		  queryString = "id=#url.id#"
		  filter      = "#filter#"		  
		  ajax        = "1"
		  dataSource  = "appsQuery" 
		  module      = "Warehouse"
		  reportName  = "Excel: Non-Expendables"
		  excel       = "1"
		  table1Name  = "Equipment"> 		
				
	</td>
				
    <cfoutput>	
		
		<td id="actions" class="hide">	
		
		    <cfif form.operational eq "1">		
									
				<table class="formpadding"><tr>			

				<td>
					
					<button name="Actions" id="Actions" type="button"
						class="button10g" 
						style="width:110;height:26" 
					    onClick="javascript:record_actions()">
					     <img src="#SESSION.root#/images/record_actions.png" height="13" align="absmiddle" alt="" border="0"><cf_tl id="Operations">
					</button> 
				</td>
							
				<td style="padding-left:2px">
					<button name="Transfer" id="Transfer"  type="button"
					   class="button10g" 
					   style="width:96;height:26" 
					   onClick="javascript:move('#url.id#','#URL.ID#','#URL.ID1#','#URL.ID2#',page.value,sort.value,view.value,'0')">	
							<img src="#SESSION.root#/images/logos/warehouse/Transfer.png" height="13" align="absmiddle" alt="" border="0">
							<cf_tl id="Transfer">
					</button> 
				</td>
				
				<td style="padding-left:2px">			
					<button name="Disposal" id="Disposal" type="button"
					   class="button10g" 
					   style="width:96;height:26" 
					   onClick="javascript:disposal('#url.id#','#URL.ID#','#URL.ID1#','#URL.ID2#',page.value,sort.value,view.value,'0')">	
						<img src="#SESSION.root#/images/logos/warehouse/recycle.png" height="13" align="absmiddle" alt="" border="0"><cf_tl id="Disposal">
					</button> 				
				</td>
				
				</tr>
				
				</table>
			
			</cfif>
			
		</td>	
			
	</cfoutput>	
				
	</tr>
		
	</table>
			
</td>

<cfoutput>

<td colspan="1" align="right">

		<table cellspacing="0" cellpadding="0"><tr><td>

			<select name="view" id="view" size="1" class="regularxl"
	          onChange="listreload('#URL.ID#','#URL.ID1#','#URL.ID2#',page.value,sort.value,this.value,'0')">
				 <option value="Default" <cfif URL.View eq "Default">selected</cfif>><cf_tl id="Item listing"></option>
				 <option value="Purchase" <cfif URL.View eq "Purchase">selected</cfif>><cf_tl id="Purchase"></option>
				 <option value="Location" <cfif URL.View eq "Location">selected</cfif>><cf_tl id="Location"></option>			 
				 <option value="LocationHolder" <cfif URL.View eq "LocationHolder">selected</cfif>><cf_tl id="Location/Holder"></option>			 
	        </SELECT>
		
		</td>
		<td style="padding-left:4px;padding-right:4px">
        
		<select name="sort" id="sort" size="1" class="regularxl"
          onChange="listreload('#URL.ID#','#URL.ID1#','#URL.ID2#',page.value,this.value,view.value,'0')">
			 <option value="B.Description" <cfif URL.Sort eq "B.Description">selected</cfif>><cf_tl id="Description"></option>
			 <option value="Make" <cfif URL.Sort eq "Make">selected</cfif>><cf_tl id="Make"></option>
			 <option value="LocationName" <cfif URL.Sort eq "LocationName">selected</cfif>><cf_tl id="LocationName"></option>
			 <!---
			 <option value="Status" <cfif URL.Sort eq "Status">selected</cfif>>Status</option>
			 --->
			 <option value="DepreciationBase" <cfif URL.Sort eq "DepreciationBase">selected</cfif>><cf_tl id="Value"></option>
        </SELECT>
		
		</td>
		
		<td width="30" align="center" style="padding-left:4px;padding-right:4px">
		
		<img src="#SESSION.root#/images/refresh.gif" 
		  id="refreshme" 
		  name="refreshme"
		  alt="" 
		  border="0" 
		  onclick="listreload('#URL.ID#','#URL.ID1#','#URL.ID2#',page.value,sort.value,this.value,'0')">
		  
		</td>
		
		<cf_PageCountN count="#counted#">	
		
		<cfif pages eq "1">
					
			<cfoutput>
			<input type="hidden" name="page" id="page" value="#URL.Page#">
			</cfoutput>
	
		<cfelse>
			<td>	
	         <select name="page" id="page" size="1" style="color: gray;" class="regularxl"
	          onChange="listreload('#URL.ID#','#URL.ID1#','#URL.ID2#',this.value,sort.value,view.value,'0')">
			  <cfloop index="Item" from="1" to="#pages#" step="1">
	             <cfoutput><option value="#Item#"<cfif #URL.page# eq "#Item#">selected</cfif>><cf_tl id="Page"> #Item# <cf_tl id="of"> #pages#</option></cfoutput>
	          </cfloop>	 
	         </SELECT>
			 </td>
			 
		</cfif>	 
		
		</tr></table>
</td>

</cfoutput>

</tr>

<tr><td colspan="2">
	
	<table width="100%" cellspacing="0" cellpadding="0" align="center" id="t_asset_list" class="navigation_table">
	<tbody>
			
		<tr class="line"><td height="25" colspan="9">
			 <cfinclude template="Navigation.cfm">			 				 
		</td></tr>		
		
		<cfquery name="SearchTotal" dbtype="query">
		    SELECT  count(AssetId) as Items,
			        sum(DepreciationBase) as Total
			FROM    SearchResult
			</cfquery>
		
		<cfoutput>
		<TR class="line labelmedium">
		    <td height="20" colspan="4" style="padding-left:4px"><cf_tl id="Items">: <b>#SearchTotal.Items#</td>
			<td colspan="5" align="right" style="padding-left:5px;padding-right:5px"><cf_tl id="Value">: <b>#numberFormat(SearchTotal.Total,"_,__.__")#</td>
		</TR>
		</cfoutput>
				
		<cfoutput>
		<TR class="line labelmedium">
		    <td height="18" style="padding-top:1px;padding-left:7px;padding-right:8px">
			 <cfif form.operational eq "1">	
			   <input type="checkbox" name="batch" id="batch" value="1" style="width:15px;height:15px" onclick="selectall()">
			 </cfif> 
			</td>  
		    <td height="18"></td>  
			<td></td>								  
			<td style="cursor:pointer" onclick="listreload('#URL.ID#','#URL.ID1#','#URL.ID2#',page.value,'B.description',view.value,'0')" width="34%"><cfif url.sort eq "b.description"><b><u></cfif><cf_tl id="Description"></td>
			<td style="cursor:pointer" onclick="listreload('#URL.ID#','#URL.ID1#','#URL.ID2#',page.value,'assetbarcode',view.value,'0')" width="15%"><cfif url.sort eq "b.location"><b><u></cfif><cf_tl id="Barcode">/<cf_tl id="DecalNo"></a></td>
			<td style="cursor:pointer" onclick="listreload('#URL.ID#','#URL.ID1#','#URL.ID2#',page.value,'serialno',view.value,'0')" width="20%"><cfif url.sort eq "serialno"><b><u></cfif><cf_tl id="SerialNo"></a></td>
			<td style="cursor:pointer" onclick="listreload('#URL.ID#','#URL.ID1#','#URL.ID2#',page.value,'make',view.value,'0')" width="20%"><cfif url.sort eq "make"><b><u></cfif><cf_tl id="Make"></a></td>
			<td style="cursor:pointer" onclick="listreload('#URL.ID#','#URL.ID1#','#URL.ID2#',page.value,'depreciationbase',view.value,'0')" width="15%" align="right"><cfif url.sort eq "depreciationbase"><b><u></cfif><cf_tl id="Value"></a></td>
			<td height="18">			
			</td>  
		</TR>
		</cfoutput>
				
		<cfif URL.View eq "Purchase">
		
		<TR class="line labelmedium">
		    <td height="20" width="5%"></td>
			<td></td>
			<td></td>
			<td bgcolor="ffffcf"  width="34%" colspan="1"><cf_tl id="Add. description"></td>
		    <td bgcolor="ffffcf"  width="20%" colspan="1"><cf_tl id="Model"></td>
			<td bgcolor="ffffcf"  width="10%" colspan="1"><cf_tl id="PurchaseNo"></td>
			<td bgcolor="ffffcf"  width="10%" colspan="1"><cf_tl id="Requisition"></td>
			<td bgcolor="ffffcf"  width="15%" colspan="1"><cf_tl id="Received"></td>
			<td></td>
		</TR>
				
		</cfif>
		
		<cfif URL.View eq "Location">
		
		<TR bgcolor="ffffff" class="line labelmedium">
		    <td height="15" width="5%"></td>
			<td></td>
			<td></td>
			<td width="34%" colspan="1"><cf_tl id="Unit"></td>
		    <td width="10%" colspan="1"><cf_tl id="Location"></td>
			<td width="15%" colspan="1"><cf_tl id="Building"></td>
			<td width="15%" colspan="2"><cf_tl id="Description"></td>
			<td></td>
		</TR>
				
		</cfif>
		
		
		<cfif SearchResult.recordcount eq "0">
		
			<tr class="labelmedium"><td colspan="9" align="center" style="height:30"><cf_tl id="There are no items to show in this view">.</td></tr>
		
		<cfelse>
		
		<cfoutput>
			<input type="hidden" name="rowno" id="rowno"  value="0">
			<input type="hidden" name="rowid" id="rowid"  value="">		
			<input type="hidden" name="seriallist" id="seriallist" value="#ValueList(SearchResult.AssetSerialNo,'|')#">			
		</cfoutput>
			
		<cfoutput query="SearchResult">
		
			<cfset currrow = currrow + 1>
									
				<cfif currrow gte first and currrow lte last>							
				   
					<tr id="r#currrow#" class="labelmedium navigation_row">
						
						<td height="20" align="right" style="padding-left:7px;padding-right:8px;padding-top:1px">
						
						      <table width="100%" cellspacing="0" cellpadding="0">
							  <tr><td style="padding-right:5px">
															  						  
							  <cfif OrgStatus eq "0" or LocationStatus eq "0">
									       
							       <!--- do not allow movement if still pending --->
										  
							  <cfelse>
									  
							      <cfif Disposal eq "0">
								  
									  <cfif assetid neq "">
									  	  <input type="checkbox" 
										      name="AssetId" 
											  id="AssetId" style="width:15px;height:15px"
											  value="'#AssetId#'" 
											  onclick="selectthis(this.checked)">
									  </cfif>
								  
								  <cfelse>
								  
								      <img src="#SESSION.root#/images/trash2.gif" align="absmiddle" alt="Disposed" border="0">
										
								  </cfif>
										  
							  </cfif>	  
								</td>	  
						
							   <td style="padding-top:4px;padding-left:3px;width:20px;padding-right:3px" align="right">								   																
									<cf_img icon="expand" toggle= "Yes" onClick="maximize('d#currrow#')">
							   </td>
							   
							   </tr>
								
								</table>	
																  
						  </td>						
						  
						  <td style="padding-right:7px;width:30px">#currentrow#.</td>
						  
						  <td width="50">
						  
						       <table>
							   
							    <tr class="labelmedium" style="height:20px">
									<td style="padding-top:1px">
							  
							  		<cfif url.id neq "Per">
										<cf_img icon="edit" onClick="AssetDialog('#AssetId#')" navigation="Yes">																
									</cfif>	
									
									</td>
									<td>&nbsp;&nbsp;</td>
									<td></td>
									<td>&nbsp;&nbsp;</td>
								</tr>
								
							   </table>		
																										
						</td>
					    <TD>#Description# #Model#</td>
					    <TD><cfif AssetDecalNo neq "">#AssetDecalNo#<cfelse>#AssetBarCode#</cfif></td>
					    <TD>#SerialNo#</TD>
						<TD>#MakeDescription#</TD>
						<td style="padding-right:6px" align="right">#numberFormat(DepreciationBase,",.__")#</td>						
						<td></td>
						
					</TR>
					
					<cfif URL.View eq "Purchase">
													  
					<tr id="d#currrow#" name="d#currrow#" style="height:20px" class="labelmedium navigation_row_child">
						<td></td>
						<td></td>
						<td></td>
						<td class="labelit" bgcolor="e4e4e4">
							<table width="100%" border="0" cellspacing="0" cellpadding="0">
							<tr><td width="25"><img src="#SESSION.root#/images/join.gif" alt="" border="0"></td>
							<td class="labelit">#Description#</td>				
							</tr>
							</table>
						</td>
						<td bgcolor="e4e4e4">#Model#</td>
						<td bgcolor="e4e4e4"><a href="javascript:ProcPOEdit('#Purchaseno#','view')"><u>#PurchaseNo#</a></td>
						<td bgcolor="e4e4e4">#RequisitionNo#</td>
						<td style="padding-right:3px" bgcolor="e4e4e4" align="right">#dateFormat(InspectionDate,CLIENT.DateFormatShow)#</td>						
						<td></td>
					</tr>	
					
					</cfif>
									
					<cfif URL.View eq "Location" or url.view eq "LocationHolder">
					  <cfset p = "labelit navigation_row_child">					 
					<cfelse>
					  <cfset p = "hide">
					</cfif>
					
					<cfif OrgStatus eq "0" or LocationStatus eq "0">
						<cfset color = "ffffcf">
					<cfelse>
						<cfset color = "ffffff">
					</cfif>
								  
					<tr class="#p#" id="d#currrow#" name="d#currrow#">
						<td height="16"></td>
						<td></td>
						<td></td>
						<td>
							<table width="100%" border="0" cellspacing="0" cellpadding="0">
								<tr class="labelmedium">
									<td width="25">
									<cfif PersonNo eq "">
									<img src="#SESSION.root#/images/join.gif" alt="" border="0">
									<cfelseif URL.View neq "LocationHolder">
									<img src="#SESSION.root#/images/join.gif" alt="" border="0">
									<cfelse>
									<img src="#SESSION.root#/images/joinbottom.gif" alt="" border="0">
									</cfif>
									</td>
									<td class="labelit">#OrgUnitName#</td>				
								</tr>
							</table>
						</td>
						<td class="labelmedium" colspan="2">#LocationCode# #LocationName#</td>						
										
						<cfif OrgStatus eq "0" or LocationStatus eq "0">
						
							<td colspan="2" id="box#AssetId#">
							
							<table cellspacing="0" cellpadding="0"><tr class="labelit">							
							
								<td style="padding-left:3px">
							
								<img src="#SESSION.root#/images/reminder.gif" id="#assetid#ref" align="absmiddle" height="10" alt="" border="0" 
									onclick="ColdFusion.navigate('ControlListDataWFCheck.cfm?assetid=#assetid#','box#AssetId#')">
									
								</td>	
								
								<td style="padding-left:3px">													
													
							    <cf_tl id="Confirm">							
								
								</td>
													
							<cfif OrgStatus eq "0">
							
								<td style="padding-left:3px">
														
								<a href="javascript:process('#OrgMovementId#','#AssetId#')">
								<font color="6688aa"><cf_tl id="Resposibility"></font>
								</a>
								
								</td>
														
							</cfif>
							
							<cfif LocationStatus eq "0">
							
								<td style="padding-left:3px">
							
							    <cfif OrgStatus eq "0"> and </cfif>							
								<a href="javascript:process('#LocationMovementId#','#AssetId#')">
								<font color="6688aa"><cf_tl id="Location"></font>
								</a>
								
								</td>
								
							</cfif>
							
							</tr>
							
						   </table>
							
						   </td>
						
						<cfelse> 
						
						<td colspan="2"></td>
						
						</cfif>
						
						<td></td>
					</tr>	
					
					<cfif URL.View eq "LocationHolder">
					  <cfset p = "regular navigation_row_child">
					  <!--- <tr><td colspan="9" class="linedotted"></td></tr> --->
					<cfelse>
					  <cfset p = "hide">
					</cfif>
						
					<cfif PersonNo neq "">
						
						<tr class="#p#" id="d#currrow#">
							<td height="16"></td>
							<td></td>
							<td></td>
							<td colspan="6" bgcolor="FBFDDF">
								<table width="100%">
								<tr><td width="25"><img src="#SESSION.root#/images/join.gif" alt="" border="0"></td>
								<td width="99%">
									<table width="100%" cellspacing="0" cellpadding="0">
									<tr class="labelmedium">
									 <td width="50%" style="padding-left:7px"><a href="Javascript:EditPerson('#PersonNo#')"><font color="0080C0">#LastName#, #FirstName#</font></a></td>
									 <td width="50%">#DateFormat(DateEffective,CLIENT.DateFormatShow)#
									</tr>
									</table>
								</td>
								</tr>
								</table>
							</td>
							<td></td>
						</tr>	
						
					</cfif>
					
			  </cfif>	
			  
			  <cfif currrow gte first and currrow lte last>
			       <tr><td height="1" colspan="9" class="line"></td></tr>	   	 				
			  </cfif>
			  
			  <cfif currrow gt last>
			  		
			 		 <tr><td colspan="9" height="25">
				        	 <cfinclude template="Navigation.cfm">
				     </td></tr>
					 <tr><td height="1" colspan="9" class="line"></td></tr>
					 <cfset AjaxOnLoad("doHighlight")>	
					 
					<script>
						Prosis.busy('no')
					</script>				 
					
					 <cfabort>
			  </cfif>	
			      
		</cfoutput>   
	
		<tr>
			<td colspan="9" height="25">
				<cfinclude template="Navigation.cfm">
		    </td>
		</tr>
		
		</cfif>
			
		<tr><td colspan="9" class="line"></td></tr>
	</tbody>	
	</TABLE>			 

</td></tr>

</table>

<cfset AjaxOnLoad("doHighlight")>	

<script>
	Prosis.busy('no')
</script>



