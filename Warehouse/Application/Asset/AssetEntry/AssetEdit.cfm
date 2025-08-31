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
<cfquery name="Asset" 
 datasource="AppsMaterials" 
 username="#SESSION.login#" 
 password="#SESSION.dbpw#">
 SELECT *
 FROM   AssetItem
 WHERE   AssetId = '#URL.AssetId#' 
</cfquery>	

<cfquery name="Item" 
 datasource="AppsMaterials" 
 username="#SESSION.login#" 
 password="#SESSION.dbpw#">
 SELECT *
 FROM   Item
 WHERE   ItemNo = '#Asset.ItemNo#' 
</cfquery>	

<cfquery name="SourceList" 
 datasource="AppsMaterials" 
 username="#SESSION.login#" 
 password="#SESSION.dbpw#">
 SELECT   *
 FROM     Ref_Source
 ORDER BY ListDefault DESC, ListOrder 
</cfquery>	

<cfquery name="Scale" 
 datasource="AppsMaterials" 
 username="#SESSION.login#" 
 password="#SESSION.dbpw#">
 SELECT  *
 FROM    Ref_Scale
 WHERE   Code = '#Item.DepreciationScale#' 
</cfquery>	

<cfquery name="Category" 
 datasource="AppsMaterials" 
 username="#SESSION.login#" 
 password="#SESSION.dbpw#">
 SELECT *
 FROM     Ref_Category
 WHERE    Category = '#Item.Category#' 
</cfquery>	

<cfquery name="MakeList" 
	datasource="appsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	  SELECT *
	  FROM   Ref_Make
	  ORDER By Description
</cfquery>

<!--- check access rights --->

<cfinvoke component = "Service.Access"  
   method           = "AssetHolder" 
   mission          = "#Asset.Mission#" 
   assetclass       = "#item.category#"
   returnvariable   = "access">	
   

<cfinvoke component = "Service.Access"  
   method           = "AssetManagerMission" 
   mission          = "#Asset.Mission#"   
   returnvariable   = "accessmanager">	   
   
<cfif access eq "ALL" or Access eq "EDIT">
   <cfset url.mode = "edit">
<cfelse>
   <cfset url.mode = "view">
</cfif>

<table width="100%" height="99%" align="center" border="0" class="formspacing" cellspacing="0" cellpadding="0" class="formpadding">

<tr class="hide"><td height="100"><iframe name="process" id="process" width="100%" height="100"></iframe></td></tr>
<tr class="hide"><td height="100" id="processmanual"></td></tr>
<tr><td style="height:100%">

<cf_divscroll>

<cfoutput query="Asset">

 	<cfform action="../AssetEntry/AssetEditSubmit.cfm?assetid=#url.assetId#" method="post" name="assetedit" target="process">
	   
	   <table width="95%" border="0" class="formspacing formpadding" cellpadding="0" align="center">
	   	  
	    <tr><td height="3" colspan="2" stlye="width:800"></td></tr>
		
	   	<tr>
		<td width="12%" style="height:25" class="fixlength labelmedium"><cf_tl id="Master Item"></td>
		<td width="88%">
		<table cellspacing="0" cellpadding="0">
		
		    <tr><td class="fixlength labelmedium">#Mission# - #Item.ItemDescription#</b></td>
			
			<cfif accessmanager eq "EDIT" or accessmanager eq "ALL">
			
				<td width="20%" height="20" align="right" class="labelmedium" style="padding-left:4px;padding-right:4px"><cf_tl id="Change Master">:</td>
				
				<td>
					<table cellspacing="0" cellpadding="0">
						<tr><td>
						 <img src="#SESSION.root#/Images/contract.gif" alt="Select item master" name="img3" 
							  onMouseOver="document.img3.src='#SESSION.root#/Images/button.jpg'" 
							  onMouseOut="document.img3.src='#SESSION.root#/Images/contract.gif'"
							  style="cursor: pointer;" alt="" width="16" height="18" border="0" align="absmiddle" 
							  onClick="javascript:selectitem('itemno','itembox');">
						</td>
						<td width="3"></td>
						<td id="itembox">
						<input type="text" name="itemno" id="itemno" size="4" value="" class="regular" readonly style="text-align: center;">
					    <input type="text" name="itemdescription" id="itemdescription" value="" class="regular" size="60" readonly style="text-align: center;">
						<input type="text" name="itemuom" id="itemuom" value="" class="regular" size="15" readonly style="text-align: center;">
						</td></tr>
					</table>  
				</td>	
			
			</cfif>
			
					
			</tr>
			
			</table>
		</td>
	    </tr>
					   		
	    <tr>
		<td height="20" class="fixlength labelmedium"><cf_tl id="Description">:<font color="FF0000">*</font></td>
		<td class="labelmedium">
		
			<cfif url.mode eq "edit">
			
				<cfinput type="Text"
			       name="Description"
			       value="#Description#"
			       required="Yes"  
				   size="100"
				   maxlength="200"
				   class="regularxl enterastab"   
			       typeahead="No">
			   
			 <cfelse>
			 
			   #description#
			   
			 </cfif>  
		</td>
	    </tr>
		
		<tr>
		<td height="18" class="fixlength labelmedium"><Cf_tl id="Make">:<font color="FF0000">*</font></td>
		<td class="labelmedium">
		
		    <cfif url.mode eq "edit"> 
			
			<select name="Make" id="Make" required="No"  class="regularxl enterastab">
				<cfloop query="MakeList">
				<option value="#Code#" <cfif code eq asset.make>selected</cfif>>#Description#</option>
				</cfloop>
			</select>
			
			<cfelse>
			
			#asset.make#
			
			</cfif>	
			
			
		</td>
	    </tr>	
						
		<tr>
		<td height="18" class="fixlength labelmedium"><cf_tl id="Model">:</td>
		<td class="labelmedium"><cfif url.mode eq "edit">
		    <input type="text" name="Model" id="Model" value="#Model#" size="40" maxlength="40" class="regularxl enterastab">
			<cfelse>
			#Model#
			</cfif>	
		</td>
		</tr>
				
		<tr>
		<td height="18" class="fixlength labelmedium"><cf_tl id="SerialNo">:</td>
		<td class="labelmedium">
		
		  <table cellspacing="0" cellpadding="0"><tr><td>
		
		   <cfif url.mode eq "edit">
		   <input type="text" name="SerialNo" id="SerialNo" value="#SerialNo#" size="15" maxlength="40" class="regularxl enterastab">
		   <cfelse>
		   #SerialNo#	
		   </cfif>	
		   
		   </td>
		   
		   <td class="fixlength labelmedium" style="padding-left:8px" height="18"><cf_tl id="Barcode">:</td>
		   <td class="labelmedium" style="padding-left:5px"><cfif url.mode eq "edit">
			<input type="text" name="Barcode" id="Barcode" value="#AssetBarCode#" size="10" maxlength="20" class="regularxl enterastab">
			<cfelse>
			#AssetBarCode#
			</cfif>	
			
		   </td>
		   
		   <td class="fixlength labelmedium" style="padding-left:8px" height="18"><cf_tl id="DecalNo">:</td>
			<td class="labelmedium" style="padding-left:5px"><cfif url.mode eq "edit">
				<input type="text" name="AssetDecalNo" id="AssetDecalNo" value="#AssetDecalNo#" size="20" maxlength="20" class="regularxl enterastab">
				<cfelse>
				#AssetDecalNo#
				</cfif>	
				
			</td>
			
			<td class="fixlength labelmedium" style="padding-left:8px" height="18"><cf_tl id="Manufacturer">:</td>
			<td class="labelmedium" style="padding-left:5px">
			    <cfif url.mode eq "edit">
			    <input type="text" name="MakeNo" id="MakeNo" value="#MakeNo#" size="20" maxlength="40" class="regularxl enterastab">
				<cfelse>
				#MakeNo#
				</cfif>	
			</td>
		   
		   </tr></table>
		   
	    </td>		   
		</tr>
		
		<tr>

			<td class="fixlength labelmedium" height="20"><cf_tl id="Program">:</td>
			<td class="labelmedium" colspan="1">
			
			 <!--- Query returning search results --->
		          <cfquery name="Prg"
		          datasource="AppsProgram" 
		          username="#SESSION.login#" 
		          password="#SESSION.dbpw#">
		          SELECT *
			      FROM   Program
			      WHERE  ProgramCode = '#ProgramCode#'
			      </cfquery>	
				  
				  <cfif url.mode eq "edit">	
				  
				
						<table><tr><td>  
					  <input type="text" name="programdescription" id="programdescription" value="#Prg.ProgramName#" class="regularxl enterastab" size="60" maxlength="80" readonly>
					  <input type="hidden" name="programcode" id="programcode" value="#ProgramCode#" size="20" maxlength="20" readonly>
					  </td>
					  
					  <td>
					   
					   <img src="#SESSION.root#/Images/search.png" alt="Select project" name="img5" 
							  onMouseOver="document.img5.src='#SESSION.root#/Images/contract.gif'" 
							  onMouseOut="document.img5.src='#SESSION.root#/Images/search.png'"
							  style="cursor: pointer;" alt="" width="23" height="25" border="0" align="absmiddle" 
							  onClick="selectprogram('#mission#','','applyprogram','')">
							  
						</td></table>		  
					  
				  				  
				  <cfelse>
				  
				  	#Prg.ProgramName#
				  
				  </cfif>
				  
			</td>
		</tr>	
		
		<tr>
		<td height="20" class="fixlength labelmedium"><cf_tl id="Receipt Date">:</td>
		<td colspan="1" class="labelmedium" style="z-index:2; position:relative;">
		
			<cfif url.mode eq "edit">	
			
			 <cf_intelliCalendarDate9
				FieldName="ReceiptDate" 
				Default="#Dateformat(ReceiptDate, CLIENT.DateFormatShow)#"
				class="regularxl enterastab"
				AllowBlank="False">
				
			<cfelse>
			
				#Dateformat(ReceiptDate, CLIENT.DateFormatShow)#
			
			</cfif>	
					
		</td>
		</tr>	
		
	    <tr>
		<td height="18" class="fixlength labelmedium"><cf_tl id="Inspection No">:</td>
		<td>
		<table width="0" cellspacing="0" cellpadding="0">
		<tr><td class="labelmedium">
		
		<cfif url.mode eq "edit">
		    <input type="text" name="InspectionNo" id="InspectionNo" value="#InspectionNo#" size="20" maxlength="20" class="regularxl enterastab">
			<cfelse>
			#InspectionNo#
			</cfif>	
					
		</td>
						
		<td height="18" class="fixlength labelmedium" style="padding-left:8px"><cf_tl id="Inspection Date">:</td>
		
		<td colspan="1" style="padding-left:10px" style="z-index:1; position:relative;" class="labelmedium">
			<cfif url.mode eq "edit">
				
			 <cf_intelliCalendarDate9
				FieldName="InspectionDate" 
				Default="#Dateformat(InspectionDate, CLIENT.DateFormatShow)#"
				class="regularxl enterastab"
				AllowBlank="True">	
				
			<cfelse>
			
			#Dateformat(InspectionDate, CLIENT.DateFormatShow)#
			
			</cfif>	
				
		</td>
		</tr>
		
		
		</table>	
		</td></tr>	
				
		<cfif Category.VolumeManagement eq "1">
				
			<tr>
			<td height="20" class="fixlength labelmedium"><cf_tl id="Weight in kgs">:</td>
			<td>
			
			<table cellspacing="0" cellpadding="0">
			<tr><td class="labelmedium" width="184">
			
				<cfif url.mode eq "edit">
				
			    <cfinput type="text" 
					name="ItemWeight" 
					value="#ItemWeight#" 
					validate="float" 
					size="6" 
					maxlength="6" 
					class="regularxl enterastab">
					
				<cfelse>
				
				#ItemWeight#
			
				</cfif>		
					
					
			</td>
			
			<td height="20"  width="102" class="fixlength labelmedium"><cf_tl id="Volume in m3">:</td>
			<td class="labelmedium">
			
				<cfif url.mode eq "edit">
			
			      <cfinput type="text" 
			       validate="float" 
			       name="ItemVolume" 
				   value="#ItemVolume#" 
				   size="6" 
				   maxlength="10" 
				   class="regularxl enterastab">
				   
				<cfelse>
				
				#ItemVolume#
			
				</cfif>	  
				   
		     </td>
			 
			 </tr>
			 </table>
			 
			</tr>
			
		<cfelse>
		
			<input type="hidden" name="ItemWeight" id="ItemWeight" value="">
			<input type="hidden" name="ItemVolume" id="ItemVolume" value="">
			
		</cfif>
				
		<tr>
			<td class="fixlength labelmedium" valign="top" style="padding-top:2px"><cf_tl id="Source">:</td>
			<td class="labelmedium">
			
			  <cfif url.mode eq "edit"> 
			
			<select name="Source" id="Source" required="No"  class="regularxl enterastab">
				<cfloop query="SourceList">
				<option value="#Code#" <cfif code eq asset.Source>selected</cfif>>#Description#</option>
				</cfloop>
			</select>
			
			<cfelse>
			
						
			<cfquery name="getSource" 
			 datasource="AppsMaterials" 
			 username="#SESSION.login#" 
			 password="#SESSION.dbpw#">
				 SELECT   *
				 FROM     Ref_Source
				 WHERE    Code = '#asset.source#'
			</cfquery>	
			
			#getSource.Description#
			
			</cfif>	
			
			</td>
			
		</tr>			
				
		<tr>
			<td class="fixlength labelmedium" valign="top" style="padding-top:2px"><cf_tl id="Active Actions">:</td>
			<td>
				<cfquery name="ActionList" 
					datasource="appsMaterials" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
					  SELECT	*,
					  			(SELECT ActionCategory FROM AssetItemAssetAction WHERE AssetId = '#URL.AssetId#' AND ActionCategory = A.Code) as Selected,
								(SELECT Operational FROM AssetItemAssetAction WHERE AssetId = '#URL.AssetId#' AND ActionCategory = A.Code) as ActionOperational
					  FROM  	Ref_AssetAction A
					  WHERE		A.Operational = 1
					  ORDER BY Description ASC 
				</cfquery>
				<table width="100%" cellspacing="0" cellpadding="0">
					<tr>
					
						<cfif url.mode neq "edit">						
						
						    <cfset actionCols = 3>
							
							<cfset actionCnt = 0>
							
							<cfloop query="ActionList">
								<cfset actionCnt = actionCnt + 1>
								
								<td id="tdAction_#Code#" width="#100/actionCols#%" style="padding-left:3px;<cfif code eq selected>background-color:'E0E7FE';</cfif>">
									
									<table width="100%" cellspacing="0" cellpadding="0">
										<tr>
											<td width="70%" style="height:15;padding-right:10px">
											    <table cellspacing="0" cellpadding="0">
												<tr><td>
												<img title="#Description#" src="#SESSION.root#/Images/#TabIcon#" height="14" align="absbottom">
												</td>
												<td style="height:20px;padding-left:10px" class="labelmedium">
												<cfif code eq selected><i></cfif>#Description#		
												</td></tr>
												</table>									
											</td>											
										</tr>
									</table>
								</td>
								
								<cfif actionCnt eq actionCols>
									<cfset actionCnt = 0>
									</tr>
									<tr>
								</cfif>
								
							</cfloop>
						
						<cfelse>
											
							<cfset actionCols = 2>
							<cfset actionCnt = 0>
							<cfloop query="ActionList">
								<cfset actionCnt = actionCnt + 1>
								<td id="tdAction_#Code#" width="#100/actionCols#%" style="padding-left:3px;<cfif code eq selected>background-color:'ffffcf';</cfif>">
									
									<table width="100%" cellspacing="0" cellpadding="0">
										<tr>
											<td width="70%" style="height:20px;padding-right:10px">
											    <table cellspacing="0" cellpadding="0">
													<tr><td style="height:20px;padding-left:4px">
													<input type="Checkbox" class="radiol enterastab" name="action_#Code#" id="action_#Code#" onclick="selectaction('#code#',this);" <cfif Code eq Selected>checked</cfif>>
													</td>
													<td style="padding-left:4px"><img title="#Description#" src="#SESSION.root#/Images/#TabIcon#" height="21" align="absbottom"></td>
													<td style="padding-left:10px" class="labelmedium">#Description#</td>
													</tr>
												</table>										
											</td>
											<cfset vClass = "hide">
											<cfif code eq selected>
												<cfset vClass = "regular">
											</cfif>
											<td id="lblAction_#Code#" class="#vClass#">
											    <table cellspacing="0" cellpadding="0"><tr><td class="labelsmall" style="padding-right:4px">Oper.:</td>
												<td>
												<input type="Checkbox" class="enterastab" name="action_#Code#_operational" id="action_#Code#_operational" <cfif ActionOperational eq "1" or ActionOperational eq "">checked</cfif>>
												</td></tr>
												</table>
											</td>
										</tr>
									</table>
								</td>
								<cfif actionCnt eq actionCols>
									<cfset actionCnt = 0>
									</tr>
									<tr>
								</cfif>
							</cfloop>
						
						</cfif>						
						
					</tr>
				</table>
			</td>
		</tr>
						
		<cfset itemNo = asset.ItemNo>		
		<cfset ass    = asset.ItemNo>
				
		<cfinclude template="CustomFields.cfm">
										
		<tr><td height="18" class="fixlength labelmedium"><cf_tl id="Depreciation">:</td>
		<td colspan="3">
		<table cellspacing="0" cellpadding="0">
			<tr><td>
			<td height="20" class="labelmedium"><cf_tl id="Schedule"></td>
			<td style="padding-left:3px" class="labelmedium">#Scale.description#</td>
			<td style="width:10px"></td>		
			<td height="20" align="right" class="labelmedium"><cf_tl id="Year Start">:</td>
			<td class="labelmedium">
			  
			  <cfif ReceiptDate neq "">
				  <cfset st = year(ReceiptDate)>	
			  <cfelse>
			      <cfset st = year(Created)>
			  </cfif>	
			  
			  <cfif depreciationYearStart lt st>
			     <cfset dep = st>
			  <cfelse>
			   	 <cfset dep = depreciationYearStart>    
			  </cfif>		
			  	  						  
			  <cfif url.mode eq "edit">
		
				   <cfinput type="Text"
				       name="DepreciationYearStart"
				       value="#dep#"
				       range="#st#,2030"
				       message="Please enter a valid year"
				       validate="range"  
					   mask="2099"   
					   style="width:47;text-align:center" 	      
				       maxlength="4"
				       class="regularxl enterastab">		
				   
			  <cfelse>
				
				#DepreciationYearStart#
				
			  </cfif>
					
			</td>
			</tr>	
		</table>
		</td>
		</tr>
								
		<tr>
			<td height="18" class="labelmedium"><cf_tl id="Base Value"> #APPLICATION.BaseCurrency#: <font color="FF0000">*</font></td>
			<td class="labelmedium">
			
			   <cfif url.mode eq "edit">
			
			   <cfinput type="Text"
			       name="DepreciationBase"
			       value="#numberformat(DepreciationBase,"__,__.__")#"
			       message="Please enter a valid amount"
			       validate="float"
			       size="10"		
				   style="text-align:right;padding-top:1px;padding-right:2px"	   
			       maxlength="20"
			       class="regularxl enterastab">
			   
			   <cfelse>
			   
			   #numberformat(DepreciationBase,"__,__.__")#
			
			   </cfif>	
			   
			</td>
		</tr>	
		
		
		
		<cfif url.mode eq "edit"> 				
		
		<tr><td colspan="2" class="linedotted"></td></tr>
		
		<tr>
			<td class="labelmedium"><cf_tl id="Attachment">:</td>
			<td>
									
			<cf_filelibraryN
				DocumentPath="Asset"
				SubDirectory="#URL.assetid#" 
				Filter=""				
				Loadscript="No"
				color="transparent"
				Insert="yes"
				Remove="yes"
				ShowSize="1">	
				
			</td>		
			
		</tr>
		
		<cfelse>
		
		<cf_fileLibraryCheck DocumentPath="Asset"
				SubDirectory="#URL.assetid#" 
				Filter="">	
				
				
			<cfif files gte "1">	
			
			<tr><td colspan="2" class="linedotted"></td></tr>	
				
			<tr>
			<td valign="top" style="padding-top:3px" class="labelmedium"><cf_tl id="Attachment">:</td>
			<td>
			
			<cf_filelibraryN
				DocumentPath="Asset"
				SubDirectory="#URL.assetid#" 
				Filter=""				
				Loadscript="No"
				color="transparent"
				Insert="no"
				Remove="no"
				ShowSize="1">	
								
			</td>
		
			</tr>
			
			</cfif>	
			
		</cfif>	
		
		<tr>
			<td class="labelmedium" style="height:25px;padding-top:3px"><cf_tl id="Operational">:</td>
			<td class="labelmedium">
			
			<cfif url.mode eq "edit">
			
				<input type="radio" class="radiol enterastab" name="Operational" id="Operational" <cfif Asset.Operational eq "1">checked</cfif> value="1"><cf_tl id="Active">
				<input type="radio" class="radiol enterastab" name="Operational" id="Operational" <cfif Asset.Operational eq "0">checked</cfif> value="0"><cf_tl id="Disabled">
				
			<cfelse>
			
				<cfif operational eq 1><cf_tl id="Active"><cfelse><b><cf_tl id="Disabled"></b></cfif>
			
			</cfif>	
				
				
			</td>
		
		</tr>
				
		<tr>
			<td valign="top" style="padding-top:3px" class="labelmedium"><cf_tl id="Memo">:</td>
			<td class="labelmedium">
			
			<cfif url.mode eq "edit">
			
				<textarea style="width:99%;height:60;padding:3px;font-size:14px" totlength="300" class="regular" name="ItemMemo"  onkeyup="return ismaxlength(this)">#ItemMemo#</textarea>
				
			<cfelse>
			
				<cfif itemMemo eq "">n/a<cfelse>#ItemMemo#</cfif>
			
			</cfif>	
				
				
			</td>
		
		</tr>
		
		<script>
		
		function ask(id) {

			if (confirm("Do you want to remove this asset item ?")) {	
			ColdFusion.navigate('../AssetEntry/AssetEditPurge.cfm?assetid='+id,'processasset')	
		   }		
		   return false		   
		}
				
		</script>
		
		<tr><td colspan="2" class="line"></td></tr>			
			
		
		<tr>
		  <td  style="height:25px" class="labelmedium"><cf_tl id="Unit">:</td>
		  <td class="labelmedium">
				  				  
			<cfquery name="Unit" 
			 datasource="AppsMaterials" 
			 username="#SESSION.login#" 
			 password="#SESSION.dbpw#">
				 SELECT   TOP 1 *
				 FROM     AssetItemOrganization A, Organization.dbo.Organization O
				 WHERE    A.OrgUnit = O.OrgUnit
				 AND      AssetId = '#URL.AssetId#' 
				 ORDER BY A.DateEffective DESC
			</cfquery>	
			
			#unit.OrgUnitName#		  
		  
		  </td>
		</tr>
						
		<tr>
		  <td  style="height:25px" class="labelmedium"><cf_tl id="Location">:</td>
		  <td class="labelmedium">
		  
		  <cfquery name="Loc" 
			 datasource="AppsMaterials" 
			 username="#SESSION.login#" 
			 password="#SESSION.dbpw#">
				 SELECT   TOP 1 *
				 FROM     AssetItemLocation A, Location O
				 WHERE    A.Location = O.Location
				 AND      AssetId = '#URL.AssetId#' 
				 ORDER BY A.DateEffective DESC
			</cfquery>	
			
			#loc.LocationName#
		  </td>
		</tr>
						
		<tr>
		  <td style="height:25px" class="labelmedium"><cf_tl id="Officer">:</td>
		  <td class="labelmedium">#OfficerFirstName# #OfficerLastName# on #dateformat(created,"DDDD")# #dateformat(created,CLIENT.DateFormatShow)#</td>
		</tr>
		
		<tr><td height="3"></td></tr>
		<tr><td height="1" colspan="2" class="line"></td></tr>
				
		<cfif url.mode eq "edit">
		
			<tr><td colspan="2" align="center" height="26">
			
			<table cellspacing="0" cellpadding="0" class="formpadding formspacing"><tr><td>
			
			<cf_tl id="Close" var="1">		
		    <input class="button10g" style="width:140px;height:30" type="button" name="Cancel" id="Cancel" value="#lt_text#"  onClick="window.close()">
			</td>
			<td>
			<cfif getAdministrator(asset.mission) eq "1" and DepreciationCumulative eq "0">
				<!--- item transaction remove and deduct --->				
			    <input class="button10g" style="width:140px;height:30" type="button" name="Delete" id="Delete" value="Delete" onclick="ask('#assetid#')">		
			</cfif>
			</td>
			<td id="processasset"></td>
			<td>
			<cf_tl id="Save" var="1">
			<input class="button10g" style="width:140px;height:30" type="submit" name="Update" id="Update" value="#lt_text#">				
			</td></tr></table>
			
			</td></tr>
		
		</cfif>
						
		</table>
				
		</cfform>		
								
</cfoutput>	

</cf_divscroll>
		
</td>
</tr>

</table>	

<cfset ajaxonload("doCalendar")>
