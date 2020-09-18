<cfparam name="url.loadcolor" default="0">

<cfquery name="Item" 
	datasource="appsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT  *,
			(SELECT Description FROM Ref_Category WHERE Category = I.Category) as CategoryDescription
	FROM    Item I
	WHERE   ItemNo = '#URL.ID#'
</cfquery>

<cfquery name="LastItem" 
	datasource="appsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT TOP 1 *
	FROM    Item I
	WHERE   OfficerUserId='#SESSION.acc#'
	<cfif URL.ID neq "">
		AND 1 = 0
	</cfif>	
    ORDER BY Created DESC
</cfquery>

<cfquery name="MakeList" 
	datasource="appsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	  SELECT   *
	  FROM     Ref_Make
	  ORDER BY Description
</cfquery>
 
<cfform name="itemform" onsubmit="return false" style="padding-left:6px">

<cfoutput>
	<input type="hidden" name="ItemCodeold" id="ItemCodeold" value="#item.ItemNo#" size="20" maxlength="20"class="regular">
	<input type="hidden" name="ItemMasterOld" id="ItemMasterOld" value="#item.ItemMaster#" size="20" maxlength="20"class="regular">
</cfoutput>	

<table width="100%" align="center">

	<tr><td>
	 
	<table width="100%" align="center" class="formspacing">
			
	    <cfoutput>	
		
		<cfquery name="Check" 
		datasource="AppsMaterials" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT  TOP 1 *
			FROM    ItemTransaction
			<cfif url.id eq "">
			WHERE 	1=0
			<cfelse>
			WHERE 	ItemNo = '#url.id#'
			</cfif>
		</cfquery>
		
		<cfquery name="Mis" 
		datasource="AppsMaterials" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT T.*
			FROM   Ref_ParameterMission T
			WHERE  Mission IN  (SELECT M.Mission 
			                    FROM   Organization.dbo.Ref_MissionModule M
								WHERE  T.Mission = M.Mission
								AND    SystemModule = 'Warehouse')
		</cfquery>
		
		
		<cfquery name="Mis" 
		datasource="AppsMaterials" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT  T.*
			FROM    Ref_ParameterMission T
			WHERE	Mission IN (SELECT M.Mission 
			                    FROM   Organization.dbo.Ref_MissionModule M
								WHERE  T.Mission    = M.Mission
								AND    SystemModule = 'Warehouse')
		</cfquery>
		
		<cfif check.recordcount eq 0>
			 
		 <TR>
			 <TD class="labelmedium" style="padding-left:5px" width="150"><cf_tl id="Managed by"> :<font color="FF0000">*</font></TD>  
			 <TD>
			 	<select name="mission" id="mission" class="regularxl">		
					<cfloop query="Mis">
						<option value="#Mission#" <cfif Item.Mission eq Mis.Mission or (url.fmission eq Mis.Mission and url.id eq "")>selected</cfif>>#Mission#</option>
					</cfloop>
				</select>
			 </TD>
		 </TR>
		 
		 </cfif>
						
		 
		 <TR>
			 <TD class="labelmedium" style="padding-left:5px" width="150"><cf_tl id="Last Project"> :<font color="FF0000">*</font></TD>  
			 <TD>		 
			 <cf_securediv id="bProgram" bind="url:getProgram.cfm?mission={mission}&itemNo=#URL.Id#">		 	
			 </TD>
		 </TR>		
		 
		 <cfif check.recordcount eq "1">
		
			<tr>
		    <td class="labelmedium" style="padding-left:5px" height="21" width="140"><cf_tl id="Class"> / <cf_tl id="Originated"> :</td>
		    <td class="labelmedium">#Item.ItemClass# / #Item.mission#
				<input type="hidden" name="mission" id="mission" value="#Item.mission#">
				<input type="hidden" name="itemclass" id="itemclass" value="#Item.ItemClass#">
				&nbsp;&nbsp;&nbsp;<font size="2" color="808080"><cfoutput>#item.OfficerFirstName# #Item.OfficerLastName# [#dateformat(item.created,CLIENT.DateFormatShow)#]</cfoutput></font>
		    </td>
		    </tr>
		
		<cfelse>
		
			<cfquery name="Cls" 
			datasource="AppsMaterials" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				SELECT     *
				FROM       Ref_ItemClass
				ORDER BY   ListingOrder 
			</cfquery>
			
	        <tr>
		    <td class="labelmedium" style="padding-left:5px" width="140"><cf_tl id="Class"> / <cf_tl id="Originated"> :</td>
		    <td>
				<select name="itemclass" id="itemclass" class="regularxl">		
				<cfloop query="Cls">
				    <!--- hidden other by hanno 16/1/2012 --->
				    <cfif code neq "Other">
						<option value="#Code#" <cfif Item.ItemClass eq Code>selected</cfif>>#Description# [#Code#]</option>
					</cfif>
				</cfloop>
				</select>
		    </td>
		    </tr>
		
		</cfif>	 
		 
		<cf_verifyOperational 
	         datasource= "AppsMaterials"
	         module    = "Accounting" 
			 Warning   = "No">			 
			 
		<!--- we check if there are transactions for this item if no transactions 
		then we allow to change	, if transactions then only to a category with the same stock account
		--->
		
		<cfquery name="check" 
		datasource="appsMaterials" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT TOP 1 *
			FROM   Materials.dbo.ItemTransaction T
			WHERE  ItemNo = '#url.id#'						
		</cfquery>		
		
		<cfif check.recordcount eq "0">
	
			<cfquery name="Cat" 
			datasource="AppsMaterials" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				SELECT  *
				FROM    #CLIENT.LanPrefix#Ref_Category R	
				WHERE 	1 = 1
				<cfif Operational eq "1">
				<!--- has a valid GL account --->
				AND 	R.Category IN (SELECT Category 
				                       FROM   Ref_CategoryGLedger R
								       WHERE  Area = 'Stock'
								       AND    GLAccount IN (SELECT GLAccount 
								                            FROM   Accounting.dbo.Ref_Account A
														    WHERE  A.GLAccount = R.GLAccount)
								   )
				</cfif>
				<!--- has subitems defined --->
				AND		R.Category IN (SELECT Category 
				                       FROM   Ref_CategoryItem 
									   WHERE  Category = R.Category)
				ORDER BY TabOrder					     
			</cfquery>			
		
		<cfelse>
		
			<cfquery name="getAccount" 
			datasource="appsMaterials" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				SELECT *
				FROM   Ref_CategoryGLedger
				WHERE  Category = '#item.Category#'
				AND    Area = 'Stock'						
			</cfquery>		
			
			<!--- we only allow to change to a category that has the same stock GLAccount --->
			
			<cfquery name="Cat" 
			datasource="AppsMaterials" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				SELECT  *
				FROM    #CLIENT.LanPrefix#Ref_Category R	
				WHERE 	1 = 1
				<cfif Operational eq "1">
				<!--- has a valid GL account --->
				AND 	R.Category IN (SELECT Category 
				                       FROM   Ref_CategoryGLedger R
								       WHERE  Area = 'Stock'
									   AND    GLAccount = '#getAccount.GLAccount#'
								       AND    GLAccount IN (SELECT GLAccount 
								                            FROM   Accounting.dbo.Ref_Account A
														    WHERE  A.GLAccount = R.GLAccount)
								   )
				</cfif>
				<!--- has subitems defined --->
				AND		R.Category IN (SELECT Category 
				                       FROM   Ref_CategoryItem 
									   WHERE  Category = R.Category)  
			</cfquery>	
		
		</cfif>
		
		<tr>
	    <td class="labelmedium" style="padding-left:5px"><cf_tl id="Stock Category">: <font color="FF0000">*</font></b></td>
	    <td>
		
			<table>	
			<tr>		
			<td>
			
			<!---
			<cfif check.recordcount gt 0>
		
				#Item.category# &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
				<input type="hidden" name="category" id="category" value="#Item.category#">
	
		
			<cfelse>
			
			--->
				<cfselect name="category" id="category"
					class    = "regularxl"
					query    = "Cat" 
					required = "Yes" 
					value    = "Category" 
					message  = "Please, select a valid asset category." 
					display  = "Description" 
					selected = "#Item.Category#"/>
			
			<!---
			</cfif>	
			--->
					
			</td>
			
			<td class="labelmedium" style="padding-left:10px" align="right"><cf_tl id="Sub Category">:<font color="FF0000">*</font></td>
			
		    <td style="padding-left:10px">			
				<cf_securediv id="divCategoryItem" bind="url:#SESSION.root#/Warehouse/Maintenance/Item/getCategoryItem.cfm?ItemNo=#Item.ItemNo#&CategoryItem=#Item.CategoryItem#&Category={category}">
		    </td>
			
			</tr>
			
			</table>
	    </td>
	    </tr>
		
		<TR>
	    <td class="labelmedium" style="padding-left:5px"><cf_tl id="Procurement Master">: <font color="FF0000">*</font></b></td>   
		    <td>
				<cf_securediv id="bItemMaster" bind="url:getItemMaster.cfm?itemmaster=#Item.ItemMaster#&mission={mission}">
		    </td>
	    </tr>
		
		<cfif URL.ID eq "">
		
			<tr id="warehouseenable">
				<td colspan="1" valign="top" class="labelmedium" style="padding-top:3px;padding-left:5px"><cf_tl id="Enable for">:
					<a href="javascript:" onclick="$('##warehouselist').toggle()"><cf_tl id="More">...</a>
				</td>
				<td id="warehouselist" class="hide" >
					<cf_securediv bind="url:getWarehouse.cfm?mission={mission}&itemclass={itemclass}" id="warehouse">	
				</td>
			</tr>
		
		</cfif>
				
	    <tr>
		    <td class="labelmedium" style="padding-left:5px"><cf_tl id="Item Code">: <font color="FF0000">*</font></td>
		    <td>
			
			<table><tr><td>
			<input type="text" name="Classification" id="Classification" 
			value="#item.Classification#" size="10" maxlength="20"class="regularxl" onchange="syncItemCode(this)" onkeyup="suggest(this)">
			<div id="suggestion"></div>
			</td>
			
			
			<cfif URL.ID neq "">
			
			<td class="labelmedium" style="padding-left:5px"><cf_tl id="Operational">:</b></td>
		    <TD class="labelmedium" style="padding-left:5px">
			
			
				<input type="radio" class="radiol" name="Operational" id="Operational" <cfif Item.Operational eq "1" or url.id eq "">checked</cfif> value="1"><cf_tl id="Active">
				<input type="radio" class="radiol" name="Operational" id="Operational" <cfif Item.Operational eq "0">checked</cfif> value="0"><cf_tl id="Disabled">
		    </td>
		    		
			</cfif>
			
			</tr>
			</table>
			</td>
		</tr>
		
		<TR>
		    <TD valign="top" class="labelmedium" style="padding-top:4px;padding-left:5px"><cf_tl id="Description">:<font color="FF0000">*</font></TD>
		    <TD class="labelmedium" style="padding-left:0px">
			
			<cf_LanguageInput
					TableCode       = "Item" 
					Mode            = "Edit"
					Name            = "ItemDescription"
					Type            = "Input"
					Required        = "No"
					Value           = "#Item.ItemDescription#"
					Key1Value       = "#Item.ItemNo#"
					Message         = "Please enter a description"
					MaxLength       = "200"
					Size            = "90"
					Class           = "regularxl">
				
		    </TD>
		</TR>	
			
		<tr id="custombox">
		<td width="140" height="21" valign="top" class="labelmedium" style="padding-top:3px;padding-left:5px"><cf_tl id="Information Element">:</td>
		<td>
		   <cf_securediv bind="url:RecordEditCustom.cfm?id=#url.id#&class={itemclass}" id="custom">
		</td>
		</tr>
					 
		<cfquery name="UoMList" 
		datasource="appsMaterials" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT *
			FROM   Ref_UoM		  
		</cfquery>
		
		<cfquery name="ItemUoM" 
		datasource="appsMaterials" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT *
			FROM   ItemUoM
			WHERE  ItemNo = '#URL.ID#'
			AND    UoMMultiplier = 1
		</cfquery>
		
		<cfif Item.ItemClass eq "Supply">
		   <cfset cl = "regular">
		<cfelse>
		   <cfset cl = "hide"> 
		</cfif>
		
		<cfif URL.ID eq "">
		
		<TR>
	      <TD class="labelmedium" style="padding-left:5px"><cf_tl id="Base UoM Code">:<font color="FF0000">*</font></TD>
		  <TD>
		  
				  <cfif ItemUoM.recordcount gte "1">
				  	<cfset val = itemUoM.UoMCode>
				  <cfelse>
				   	<cfset val = "#Mis.DefaultUoM#">
				  </cfif>				  
				  
				  <cfquery name="UoMDescription" 
					datasource="appsMaterials" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
						SELECT *
						FROM   Ref_UoM
						WHERE Code = '#val#'		  
				  </cfquery>			  
				  
				  <cfselect name="UoMCode" queryposition="below" query="UoMList" value="Code" display="Code" selected="#val#" visible="Yes" enabled="Yes" class="regularxl">
				  <option value="">n/a</option>
				  </cfselect>
		  		         				   
		   </TD>
		</TR>
		
		<TR>
	      <TD class="labelmedium" style="padding-left:5px"><cf_tl id="UoM Name">:<font color="FF0000">*</font></TD>
		  <TD>
		  
				  <cfif ItemUoM.recordcount gte "1">
				  	<cfset val = itemUoM.UoMDescription>
				  <cfelse>
				   	<cfset val = "#UoMDescription.Description#">
				  </cfif>
		  
			  	   <cfinput type="Text"
				       name="UoMDescription"
				       value="#val#"
				       required="Yes"
					   message="Please enter a UoM description"
				       visible="Yes"
				       enabled="Yes"
				       size="50"				   
				       maxlength="50"
				       class="regularxl">	  
					   
		   </TD>
		</TR>
			
		<TR>
	    <TD class="labelmedium" style="padding-left:5px"><cf_tl id="Estimated Standard Cost"> #application.basecurrency# :<font color="FF0000">*</font></TD>
	    <TD>
		
		  	   <cfinput type="Text"
			       name="StandardCost"
			       value="#itemUoM.StandardCost#"
			       validate="float"
			       required="Yes"
				   message="Please enter a valid amount"
				   visible="Yes"
			       enabled="Yes"
			       size="10"
			       maxlength="10"
				   style="text-align:right"
			       class="regularxl">	
				   
	    </TD>
		</TR>
		
		<cfquery name="getVendorTree" 
	    datasource="AppsPurchase" 
	    username="#SESSION.login#" 
	    password="#SESSION.dbpw#">
			SELECT 	TreeVendor 
			FROM 	Ref_ParameterMission 
			WHERE 	Mission = '#mis.mission#'
		</cfquery>
		
		<tr><td colspan="2" class="labellarge" style="height:45px;font-size:22px;padding-left:3px"><cf_tl id="Provider"></td></tr>	
					
		<TR>
	    <TD class="labelmedium" style="padding-left:5px"><cf_tl id="Name">:</TD>
	    <TD>
		
		  <table>
					<tr>
					
				   <td>
				   		<cfif Mis.EarmarkManagement eq 1>
							<cfset vRequired = "Yes">
						<cfelse>
							<cfset vRequired = "No">						
						</cfif>
	 				   <cfinput type="text"   id="referenceorgunitname1" name="referenceorgunitname1" class="regularxl" value="" size="46" maxlength="40" required="#vRequired#" message="Plaese, select a valid vendor." readonly>
					   <input type="hidden" name="referenceorgunit" id="referenceorgunit1" value="">		
					     			  
				   </td>
				   
				   <td style="padding-left:1px">				   					
	
						<img src="#SESSION.root#/Images/search.png" alt="Select vendor" name="img1" 
						  onMouseOver="document.img1.src='#SESSION.root#/Images/contract.gif'" 
						  onMouseOut="document.img1.src='#SESSION.root#/Images/search.png'"
						  style="cursor: pointer;" alt="" width="23" height="23" border="0" align="absmiddle" 
						  onClick="selectorgN('#getVendorTree.treeVendor#','','referenceorgunit','applyorgunit','1','1','modal')">
					  
			       </td>
				   
				   </tr>
				   </table>
		
		</td>
		</TR>
		
		<tr>
			<td class="labelmedium" style="padding-left:5px" ><cf_tl id="Price Location">:</td>
			<td class="labelmedium">
			
				<cfquery name="getLocations" 
					datasource="AppsMaterials" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
					SELECT 	L.*,
							(LocationCode + ' - ' + LocationName) as LocationDisplay,
							C.Description as ClassDescription
					FROM   	Location L,
							Ref_LocationClass C
					WHERE  	L.LocationClass = C.Code
					AND		L.Mission = '#mis.mission#'
				</cfquery>
				
				<cfselect 	name="locationId" 
							value="location" 
							class="regularxl"
							display="LocationDisplay" 
							group="ClassDescription" 
							query="getLocations" 
							selected=""/>
			</td>
		</tr>
		
		<TR>
	    <TD class="labelmedium" style="padding-left:5px"><cf_tl id="Offered Price"></TD>
	    <TD>
			<table>
			<tr class="labelmedium">
			<td>
			
				<cfquery name="getLookup" 
					datasource="AppsLedger" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
					SELECT *
					FROM   Currency
					where  Operational = 1				
				</cfquery>
				
				<cfset curr = APPLICATION.BaseCurrency>
												
				<select name="currency" id="currency" class="regularxl">
					<cfloop query="getLookup">
					  <option value="#getLookup.currency#" <cfif curr eq getLookup.currency>selected</cfif>>#getLookup.currency# - #getLookup.description#</option>
				  	</cfloop>
				</select>
			
			</td>
			
			<td style="padding-left:4px"><cfinput type="Text" class="regularxl" style="text-align:right" name="ItemPrice" value="0" 
					required="Yes" validate="numeric" message="Please, enter a valid price." size="10">
			</td>
			
			<td style="padding-left:10px"><cf_tl id="Tax in percentage">:</td>
			
			<td style="padding-left:4px">
			<cfinput type="Text" class="regularxl" name="ItemTax" value="0" style="text-align:right"
					required="Yes" validate="numeric" message="Please, enter a valid tax." size="6">
			</td>
			
			</tr></table>
				
		</td>
		</TR>
		
		<TR>
	    <TD class="labelmedium" style="padding-left:5px"><cf_tl id="Minimum Quantity"></TD>
	    <TD>
		   <cfinput type="Text"
			       name="OfferMinimumQuantity"
			       value="0"
			       validate="float"
			       required="Yes"
				   message="Please enter a valid quantity"
				   visible="Yes"
			       enabled="Yes"
			       size="10"
			       maxlength="10"
			       class="regularxl">	
		</td>
		</TR>
		
		<tr><td colspan="2" class="labellarge" style="height:45px;font-size:22px;padding-left:3px"><cf_tl id="Codification"></td></tr>	
		
		
		<TR>
	    <TD class="labelmedium" style="padding-left:5px"><cf_tl id="International Coding">:<cf_space spaces="50"></TD>
	    <TD>
			<table border="0" cellspacing="0" cellpadding="0">
				
					<tr>
					   <!---
						<td class="labelit" style="width:50px"><cf_tl id="Code">:</td>
						--->
						<td style="padding-left:0px;width:120;">
							<input type   = "text" 
							    name      = "ItemNoExternal" 
								ID        = "ItemNoExternal"
								style     = "width:100;"
								value     = "#item.ItemNoExternal#"
								size      = "20" 
							    maxlength = "20" 
								class     = "regularxl">
						</td>
						<td class="labelit" style="width:100;padding-left:5px"><cf_tl id="Name">:</td>
						<td style="padding-left:2px;">
							
							<cfif item.ItemDescriptionExternal eq "">
								<cfset vItemDescriptionExternal = LastItem.ItemDescriptionExternal>
							<cfelse>
								<cfset vItemDescriptionExternal = item.ItemDescriptionExternal>
							</cfif>						
							
							<input type   = "text" 
							    name      = "ItemDescriptionExternal" 
								id        = "ItemDescriptionExternal"
								value     = "#vItemDescriptionExternal#"
								size      = "60" 
							    maxlength = "100" 
								class     = "regularxl">
								
						</td>
					</tr>
			</table>
	  	   
	    </TD>
		</TR>
		
		<TR>
	    <TD class="labelmedium" style="padding-left:5px"><cf_tl id="Manufacturing">:</TD>
	    <TD>
			<table border="0" cellspacing="0" cellpadding="0">
				
					<tr>
					    <!---
						<td class="labelit" style="width:50px"><cf_tl id="Make">:</i></td>
						--->
						<td style="padding-left:0px;width:120;">
							<select name="Make" id="Make" required="No" class="regularxl" style="width:100">
							    <option value=""></option>
								<cfloop query="MakeList">
								<option value="#Code#" <cfif code eq Item.make>selected</cfif>>#Description#</option>
								</cfloop>
							</select>
						</td>
						<td class="labelit" style="width:100;padding-left:5px"><cf_tl id="Model">:</td>
						<td style="padding-left:2px;">
							
							<cfif Item.Model eq "">
								<cfset vModel = LastItem.Model>
							<cfelse>
								<cfset vModel = Item.Model>
							</cfif>	
							<input type="text" name="Model" id="Model" value="#vModel#" size="60" maxlength="40" class="regularxl">
						</td>
					</tr>
			</table>
	    </TD>
		</TR>
		
		<TR id="boxbarcode" class="#cl#">
	    <TD class="labelmedium" style="padding-left:5px"><cf_tl id="Barcode">:</TD>
	    <TD>
	  	   <input type="text" 
			    name="ItemBarcode" 			
			    id="ItemBarcode"
				value=""
				size="20" 
			    maxlength = "20" 
				class= "regularxl">
	    </TD>
		</TR>
			
		<cfelse>
		
			<TR>
		    <TD class="labelmedium" style="padding-left:5px"><cf_tl id="International Coding">:<cf_space spaces="50"></TD>
		    <TD>
				<table border="0" cellspacing="0" cellpadding="0">
					
						<tr>
						   <!---
							<td class="labelit" style="width:50px"><cf_tl id="Code">:</td>
							--->
							<td style="padding-left:0px;width:120;">
								<input type   = "text" 
								    name      = "ItemNoExternal" 
									ID        = "ItemNoExternal"
									style     = "width:100;"
									value     = "#item.ItemNoExternal#"
									size      = "20" 
								    maxlength = "20" 
									class     = "regularxl">
							</td>
							<td class="labelit" style="width:100;padding-left:5px"><cf_tl id="Name">:</td>
							<td style="padding-left:2px;">
								
								<cfif item.ItemDescriptionExternal eq "">
									<cfset vItemDescriptionExternal = LastItem.ItemDescriptionExternal>
								<cfelse>
									<cfset vItemDescriptionExternal = item.ItemDescriptionExternal>
								</cfif>						
								
								<input type   = "text" 
								    name      = "ItemDescriptionExternal" 
									id        = "ItemDescriptionExternal"
									value     = "#vItemDescriptionExternal#"
									size      = "60" 
								    maxlength = "100" 
									class     = "regularxl">
									
							</td>
						</tr>
				</table>
		  	   
		    </TD>
			</TR>
		
			<TR>
		    <TD class="labelmedium" style="padding-left:5px"><cf_tl id="Manufacturing">:</TD>
		    <TD>
				<table border="0" cellspacing="0" cellpadding="0">
					
						<tr>
						    <!---
							<td class="labelit" style="width:50px"><cf_tl id="Make">:</i></td>
							--->
							<td style="padding-left:0px;width:120;">
								<select name="Make" id="Make" required="No" class="regularxl" style="width:100">
								    <option value=""></option>
									<cfloop query="MakeList">
									<option value="#Code#" <cfif code eq Item.make>selected</cfif>>#Description#</option>
									</cfloop>
								</select>
							</td>
							<td class="labelit" style="width:100;padding-left:5px"><cf_tl id="Model">:</td>
							<td style="padding-left:2px;">
								
								<cfif Item.Model eq "">
									<cfset vModel = LastItem.Model>
								<cfelse>
									<cfset vModel = Item.Model>
								</cfif>	
								<input type="text" name="Model" id="Model" value="#vModel#" size="60" maxlength="40" class="regularxl">
							</td>
						</tr>
				</table>
		    </TD>
			</TR>
		
			<tr class="hide"><td id="boxbarcode"></td></tr>			
				
		</cfif>		
		
		<tr>
	    	<td class="labelmedium" style="padding-left:5px"><cf_tl id="Color">:</td>
	    	<td>
	    		<cfif Mis.PortalInterfaceMode eq "Internal">
					<cf_color name="color" 
						  value="#item.ItemColor#"
						  style="cursor: pointer; font-size: 0; border: 1px solid gray; height: 20; width: 20; ime-mode: disabled; layout-flow: vertical-ideographic;">
				<cfelse>
	  	   			<input type="text" 
			    		name="color" 			
						value="#item.ItemColor#"
						size="20" 
			    		maxlength = "20" 
						class= "regularxl">				
				</cfif>		  
	   		</td>
	    </tr>
		
		
		
		<tr>
	    	<td class="labelmedium" style="padding-left:5px"><cf_tl id="Reference1">:</td>
	    	<td>
	    		
					<cfif item.reference1 eq "">
						<cfset vReference1 = LastItem.reference1>
					<cfelse>
						<cfset vReference1 = item.reference1>
					</cfif>	   		
	    		
	  	   			<input type="text" 
			    		name="reference1" 			
						value="#vReference1#"
						size="50" 
			    		maxlength = "50" 
						class= "regularxl">				
	   		</td>
	    </tr>	
	    
		<tr>
	    	<td class="labelmedium" style="padding-left:5px"><cf_tl id="Reference2">:</td>
	    	<td>
					<cfif item.reference2 eq "">
						<cfset vReference2 = LastItem.reference2>
					<cfelse>
						<cfset vReference2 = item.reference2>
					</cfif>	   		
	    		
	  	   			<input type="text" 
			    		name="reference2" 			
						value="#vReference2#"
						size="50" 
			    		maxlength = "50" 
						class= "regularxl">				
	   		</td>
	    </tr>	    
		
		<tr>
	    	<td class="labelmedium" style="padding-left:5px"><cf_tl id="Reference3">:</td>
	    	<td>
					<cfif item.reference3 eq "">
						<cfset vReference3 = LastItem.reference3>
					<cfelse>
						<cfset vReference3 = item.reference3>
					</cfif>	   		
	    		
	  	   			<input type="text" 
			    		name="reference3" 			
						value="#vReference3#"
						size="50" 
			    		maxlength = "50" 
						class= "regularxl">				
	   		</td>
	    </tr>		
		
		<cfquery name="CommodityList" 
		datasource="AppsMaterials" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT    CommodityCode,
			          CommodityCode+' '+Description as Name
			FROM      Ref_Commodity R	
			ORDER BY  CommodityCode
		</cfquery>	
		
		<cfif CommodityList.recordcount neq 0>
		
		<TR>
	    <TD class="labelmedium" style="padding-left:5px"><cf_tl id="Commodity Code">:</TD>
	    <TD>	
			<cfselect name="CommodityCode" 
					class="regularxl"
					query="CommodityList" 
					required="No" 
					value="CommodityCode" 
					message="Please, select a commodity code" 
					display="Name" 
					selected="#Item.CommodityCode#"/>
	  	 
	    </TD>
		</TR>
		<cfelse>
	  	   			<input type="hidden" 
			    		name="CommodityCode" 			
						value="">				
		
		</cfif>	
			
				
		<tr><td colspan="2" class="labellarge" style="height:45px;font-size:22px;padding-left:3px"><cf_tl id="Miscellaneous">& <cf_tl id="Workflow Settings"></td></tr>	
		
		<TR>
			    <td class="labelmedium" style="padding-left:5px"><cf_tl id="Destination">:</td>
			    <TD class="labelmedium">
				
				<table>
				<tr><td>
				
					<select name="Destination" id="Destination" class="regularxl" onchange="javascript:if(this.value == 'Internal') { document.getElementById('clearance').className='regular'} else {  document.getElementById('clearance').className='hide' }">
						<option value="Sale" <cfif Item.Destination eq "Sale" or Item.Destination eq "">selected</cfif>><cf_tl id="Sale">/<cf_tl id="Customer">
						<option value="Distribution" <cfif Item.Destination eq "Distribution">selected</cfif>><cf_tl id="Internal Issuance">
						<option value="Internal" <cfif Item.Destination eq "Internal">selected</cfif>><cf_tl id="Internal Customer">						
					</select>
					
				</td>
				
				<cfif Item.Destination neq "Internal">
					<cfset cl = "hide">
				<cfelse>
					<cfset cl = "regular">
				</cfif>	
				
				<td id="clearance" class="#cl#">
				
					<table>
					
					<TR class="labelmedium">
					    <td class="labelmedium" style="padding-left:15px"><cf_tl id="Request Clearance">:</td>
					    <TD>
						<input type="radio" class="radiol" name="InitialApproval" id="InitialApproval" <cfif Item.InitialApproval neq "1">checked</cfif> value="0">
						<td>
						<td><cf_tl id="No">
						<td>
						<input type="radio" class="radiol" name="InitialApproval" id="InitialApproval" <cfif Item.InitialApproval eq "1">checked</cfif> value="1">
						</td>
						<td><cf_tl id="Yes"></td>
						
						<td class="labelmedium" style="padding-left:15px"><cf_tl id="Process Mode">:</td>
						<td class="labelmedium">
						<select name="ItemProcessMode" id="ItemProcessMode" class="regularxl">
						<option value="TaskOrder" <cfif lcase(Item.ItemProcessMode) eq "TaskOrder">selected</cfif>><cf_tl id="Task Order">
						<option value="PickTicket" <cfif lcase(Item.ItemProcessMode) eq "PickTicket" or url.id eq "">selected</cfif>><cf_tl id="Pick Ticket">
						</select>
						</td>
						
						
				    </tr>
					
					</table>
				
				</td>
				</tr>
				</table>	
				
				</td>
	    </tr>
		
		
		<tr>
			<td class="labelmedium" style="padding-left:5px"><cf_tl id="Item Shipment Mode">: <font color="FF0000">*</font></td>
			<td class="labelmedium">
				<select name="ItemShipmentMode" id="ItemShipmentMode" class="regularxl">
					<option value="Standard" <cfif Item.ItemShipmentMode eq "Standard" or url.id eq "">selected</cfif>><cf_tl id="Standard">
					<option value="Fuel" <cfif Item.ItemShipmentMode eq "Fuel">selected</cfif>><cf_tl id="Fuel">
				</select>
			</td>
		</tr>		
				
		
					
		<cfquery name="Val" 
		datasource="AppsMaterials" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT     *
			FROM       Ref_Valuation
			WHERE      Operational = 1
		</cfquery>
		
		<cfif Item.ItemClass eq "Supply">
		   <cfset cl = "regular">
		<cfelse>
		   <cfset cl = "hide"> 
		</cfif>
		
		<TR id="boxvaluation" class="#cl#">
	    <td class="labelmedium" style="padding-left:5px"><cf_tl id="Inventory Valuation">: <font color="FF0000">*</font></td>
	    <TD>
		
		<cfif Item.recordcount eq "0">
		
				<select name="ValuationCode" id="ValuationCode" class="regularxl">
				<cfloop query="Val">
				  <option value="#Code#" <cfif Item.ValuationCode eq Code>selected</cfif>>#Description#</option>
				</cfloop>
				</select>
			
		<cfelse>
		
				<cfquery name="Stock" 
				datasource="AppsMaterials" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
					SELECT     SUM(TransactionQuantity) as OnHand
					FROM       ItemTransaction
					WHERE      ItemNo = '#URL.ID#'
				</cfquery>
				
				<cfif Item.ValuationCode neq "Manual" or Stock.OnHand eq "0">
				
					<select name="ValuationCode" id="ValuationCode" class="regularxl">
					<cfloop query="Val">
					  <option value="#Code#" <cfif Item.ValuationCode eq Code>selected</cfif>>#Description#</option>
					</cfloop>
					</select>
				
				<cfelse>
				
					<select name="sValuationCode" id="sValuationCode" class="regularxl" disabled>
					<cfloop query="Val">
					  <option value="#Code#" <cfif Item.ValuationCode eq Code>selected</cfif>>#Description#</option>
					</cfloop>
					</select>
					
					<input type="hidden" name="ValuationCode" value="Manual">			
				
				</cfif>
		
		</cfif>	
		
	    </td>
	    </tr>
		
		<cfif Item.ItemClass eq "Supply">
		   <cfset cl = "regular">
		<cfelse>
		   <cfset cl = "hide"> 
		</cfif>
		
		<TR id="boxprecision" class="#cl#">
		    <td class="labelmedium" style="padding-left:5px"><cf_tl id="Stock Precision">:</td>
		    <TD class="labelmedium">
			<table><tr>
			<td><input type="radio" class="radiol" name="ItemPrecision" id="ItemPrecision" <cfif Item.ItemPrecision eq "0" or Item.ItemPrecision eq "">checked</cfif> value="0"></td>
			<td style="padding-left:4px">0</td>
			<td style="padding-left:8px"><input type="radio" class="radiol" name="ItemPrecision" id="ItemPrecision" <cfif Item.ItemPrecision eq "1">checked</cfif> value="1"></td>
			<td style="padding-left:4px">1</td>
			<td style="padding-left:8px"><input type="radio" class="radiol" name="ItemPrecision" id="ItemPrecision" <cfif Item.ItemPrecision eq "2">checked</cfif> value="2"></td> 
			<td style="padding-left:4px">2</td>
			<td style="padding-left:8px"><input type="radio" class="radiol" name="ItemPrecision" id="ItemPrecision" <cfif Item.ItemPrecision eq "3">checked</cfif> value="3"></td>
			<td style="padding-left:4px">3</td>
			</tr></table>
		    </td>
	    </tr>
		
		<cfquery name="Dep" 
		datasource="AppsMaterials" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT     *
			FROM       Ref_Scale
		</cfquery>
		
		<TR id="boxdepreciation">
	    <td class="labelmedium" style="padding-left:5px"><cf_tl id="Depreciation scale">:</b></td>
	    <TD>
			<select name="DepreciationScale" id="DepreciationScale" class="regularxl">
			<cfloop query="Dep">
			<option value="#Code#" <cfif Item.DepreciationScale eq Code>selected</cfif>>#Description#</option>
			</cfloop>
			</select>
	    </td>
	    </tr>	
					
		<tr><td height="1" colspan="2" class="line"></td></tr>
			
		</cfoutput>
		
		<tr><td colspan="2" align="center" id="processbutton">
		
			<table width="100%" cellspacing="0" cellpadding="0">	
			
			<cfoutput>
			
			<cfif url.id neq "">
				
				<cf_tl id ="Update" var="vUpdate">
				<cf_tl id ="Delete" var="vDelete">
				
				<td align="center">
					<cfif check.recordcount eq "0">
				    <input class="button10g"  style="width:160;height:25" type="button" name="Delete" id="Delete" value="#vDelete#" onclick="return ask()">
					</cfif>
				    <input class="button10g"  style="width:160;height:25" type="button" name="Update" id="Update" value="#vUpdate#" onclick="validate()">
				</td>	
				
			<cfelse>
			
				<cf_tl id="Cancel" var="vCancel">
				<cf_tl id="Save" var="vSave">
			
				<td align="center">
					<input class="button10g"  style="width:130;height:25" type="button" name="Cancel" id="Cancel" value="#vCancel#" onClick="window.close()">
				    <input class="button10g"  style="width:130;height:25" type="button" name="Insert" id="Insert" value="#vSave#" onclick="validate()">
				</td>	
				
			</cfif>	
			
			</cfoutput>
			
			</TABLE>
			
			</td>
		</tr>
		
	</TABLE>
	
	</td>
	
	<td valign="top" style="width:80px;padding-right:10px">
	
	<table>
	
	<cfinclude template="ItemPictureToggle.cfm">
	
	</table>
	
	</td>
	
	</tr>

</table>

</cfform>

<cfif url.loadcolor eq 1>
	<cfset AjaxOnLoad("colorInit")> 
</cfif>
 