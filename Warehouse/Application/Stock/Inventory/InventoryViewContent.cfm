
<cfquery name="Get" 
datasource="appsMaterials" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT * 
	FROM   Warehouse
	WHERE  Warehouse = '#url.Warehouse#'	
</cfquery>

<cfparam name="form.location" default="xxx">

<cfif form.location neq "">

	<cfset url.loc = "">
	<cfloop index="itm" list="#form.location#">
	
		<cfif url.loc eq "">
			<cfset url.loc = "'#itm#'">
		<cfelse>
			<cfset url.loc = "#url.loc#,'#itm#'">
		</cfif>
		
	</cfloop>
	
<cfelse>

	<cfparam name="URL.loc" default="">

</cfif>


<cfquery name="parameter" 
datasource="appsMaterials" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT * 
	FROM   Ref_ParameterMission
	WHERE  Mission = '#get.Mission#'	
</cfquery>

<table width="98%" border="0" align="center" class="navigation_table">

<cftransaction isolation="read_uncommitted">
	
	<cfquery name="LocationCategoryList"
		datasource="AppsMaterials" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		
		    SELECT   DISTINCT 
				     R.Code as ClassCode,
				     R.Description as ClassName,								  
			         I.Location,
			         WL.Description, 
				     WL.ListingOrder,
				     WL.StorageCode,
					 
					 <!--- main category --->
				     C.Category,
				     C.Description as CategoryName,
					 
					 <!--- sub category --->
				     IT.CategoryItem,
				     CI.CategoryItemName,
					 
					 <!--- parent item --->
				     IT.ParentItemNo,
				     (SELECT ItemDescription 
					  FROM   Item IP 
					  WHERE  IP.ItemNo = IT.ParentItemNo) as ParentItemName,
					  
				     (SELECT SerialNo 
					  FROM   AssetItem 
					  WHERE  AssetId = WL.AssetId) as SerialNo,
					 
					 (SELECT  COUNT(*)
					  FROM    userTransaction.dbo.StockInventory#URL.Warehouse#_#SESSION.acc#  
					  WHERE   Warehouse    = '#url.warehouse#'
					  AND     Location     = I.Location
					  AND     Category     = IT.Category
					  AND     CategoryItem = IT.CategoryItem
					  AND     Counted > 0) as Recorded  <!--- one or more items recorded --->
						 
			FROM     ItemWarehouseLocation I,   <!--- item is defined for the warehouse allows us to control what is shown here 
			                                    for data entry !! --->
					 Item IT, 							         
					 Ref_CategoryItem CI,
					 #Client.LanPrefix#Ref_Category C,
			         WarehouseLocation WL,
				     Ref_WarehouseLocationClass R
					 
			WHERE    I.Warehouse      =  '#URL.Warehouse#'
			AND      I.Warehouse      =  WL.Warehouse
			
			<cfif url.loc neq "">
			AND      I.Location IN (#preservesingleQuotes(url.loc)#)
			
			</cfif>
			AND      I.Location       =  WL.Location
			AND      WL.LocationClass = R.Code							
			AND      WL.Operational   = 1
			AND      I.Operational    = 1

			AND      IT.ItemClass      = 'Supply' <!--- only supply items --->
			
			AND      I.ItemNo         = IT.ItemNo
			AND      IT.Category      = CI.Category
			AND      IT.CategoryItem  = CI.CategoryItem
			AND      IT.Category      = C.Category			
			
			<cfif Parameter.LotManagement eq "1">	
			
			<!--- we check if the item has at least one transaction recorded --->
			
			AND  EXISTS (SELECT 'x'
			             FROM   ItemTransaction
			             WHERE  Warehouse      =  I.Warehouse
						 AND    Location       =  I.Location
						 AND    ItemNo         =  I.ItemNo)
			<cfelse>
			
			<!--- we check if there is indeed any stock --->
			AND  EXISTS (SELECT 'x'
			             FROM   ItemTransaction
			             WHERE  Warehouse      =  I.Warehouse
						 AND    Location       =  I.Location
						 AND    ItemNo         =  I.ItemNo
						 AND    TransactionUoM = I.UoM
						 HAVING abs(SUM(TransactionQuantity)) > 0.05)
						 
			</cfif>			        
						
			ORDER BY R.Code, 
			         WL.ListingOrder, 
					 I.Location,
					 C.Description,
					 CI.CategoryItemName 
					 					 
	</cfquery>		
	
	</cftransaction>
		
	<cfif LocationCategoryList.recordCount eq 0>
		
		<tr><td  colspan="3" class="labelmedium" align="center" style="color:gray;height:80">
			<cf_tl id="There are no records to show in this view">
		</td></tr>
		
	</cfif>
						
	<cfoutput query="LocationCategoryList" group="ClassCode">
	
	<cfif className neq "">	
		<tr><td colspan="3" style="height:40px;font-size:26px" class="labellarge">#ClassName#</td></tr>	
	</cfif>
	
		<cfoutput group="ListingOrder">
		
			<cfoutput group="Location">
							 		
				  <tr bgcolor="DAF9FC" class="line fixrow" style="height:25px">					   										
					  <td colspan="2" class="labelmedium" style="font-size:16px;padding-left:8px">#Location#</td>						 		 		 					 
					  <td colspan="1" width="93%" style="padding-left:4px">					  
						  <table width="100%" cellpadding="0">
						  	<tr class="labelmedium">
							  <td width="50%" style="font-size:16px;padding-left:4px">#Description#</td>
							  <td width="20%">#StorageCode#</td>
							  <td width="30%">#SerialNo#</td>
						    </tr>								  
						  </table>					  
					  </td>
				  </tr>
				  
			<cfoutput group="ParentItemNo">	  
				  				 					  
				  <cfoutput group="CategoryName">
				  
				   <tr class="line">								     
					  <td colspan="3" style="font-size:19px;padding-top:2px;padding-left:4px;height:38" class="labellarge">#CategoryName# <cfif ParentItemNo neq "">/ #ParentItemNo# #ParentItemName#</cfif></td>								  										 
				   </tr>
					 					 
					 <!--- Category Item --->
					 					  
					 <cfoutput>
					  
					 <cfset apply = "locshow('#location#','#category#','#categoryitem#','box#currentrow#','#url.systemfunctionid#','','',document.getElementById('hidezero').checked,'#parentItemNo#',document.getElementById('ebox#currentrow#').checked,'1')">
					  
					  <tr class="navigation_row line fixrow2">
					  
					     <td class="navigation_action" align="left" style="fix:40px;min-width:40px;padding-top:3px;padding-left:5px"  onClick="#apply#">
						 						  						   
						   <cfif recorded eq "0">
						
						    <cfset cl = "hide">
						
						  	<img src="#SESSION.root#/Images/ct_collapsed.png" alt="" 
							id="box#currentrow#Exp" height="25" width="25" border="0" class="show" align="absmiddle" style="cursor: pointer">
							
							<img src="#SESSION.root#/Images/ct_expanded.png" 
							id="box#currentrow#Min" height="25" width="25" alt="" border="0" align="absmiddle" class="hide" style="cursor: pointer;">
						
						  <cfelse>
						
							<cfset cl = "regular">
						
							<img src="#SESSION.root#/Images/ct_collapsed.png" alt="" 
							id="box#currentrow#Exp" height="25" width="25" border="0" class="hide" align="absmiddle" style="cursor: pointer">
							
							<img src="#SESSION.root#/Images/ct_expanded.png" 
							id="box#currentrow#Min" height="25" width="25" alt="" border="0" align="absmiddle" class="show" style="cursor: pointer;">
															
						  </cfif>									 
						 
						 </td>
						 
					 	 <td width="100%" colspan="2" style="height:100%;fix:40px;">
						 
							 <table width="100%" style="height:100%">
							 <tr>
								 <td onclick="#apply#" style="fix:40px;font-size:15px;height:23px;padding-top:3px;padding-left:4px">#CategoryItem# #CategoryItemName#</td>
								 
								 <!--- filter box --->
								 
								 <td align="right" id="filterbox#currentrow#" class="#cl#">
								 
									  <table style="height:100%">									  
									  <tr>									  
									  <td class="labelit" style="fix:40px;font-size:14px;height:26px;"><cf_tl id="Earmarked">:</td>
									  <td style="fix:40px;padding-left:4px;padding-right:10px">
									   <input class="radiol" type="checkbox" id="ebox#currentrow#" value="1">
									  </td>
									  								  								   							 
									  <td class="labelit" style="fix:40px;font-size:14px;height:26px;"><cf_tl id="Filter">:</td>
									  <td style="fix:40px;padding-left:4px">
										
									  <input type="text" id="fbox#currentrow#"  class="regularxl enterastab" style="height:100%;width:140;border:0px;border-left:1px solid silver;border-right:1px solid silver" value=""></td>
										   
									  <td style="fix:40px;padding-left:3px;padding-right:4px">
											
										<input type="button" 
										    name="Find" 
											value="Find" 
											class="button10g"
											style="width:50;height:23;" 
											onclick="locshow('#location#','#category#','#categoryitem#','box#currentrow#','#url.systemfunctionid#','1',document.getElementById('fbox#currentrow#').value,document.getElementById('hidezero').checked,'#parentitemno#',document.getElementById('ebox#currentrow#').checked,'0')">
										
									   </td>										
									   </tr>
									   </table>
								 
								 </td>
							 </tr>
							 </table>					 
						 
						 </td>	
						 							  
					  </tr>
					  					  					 									 									  
					  <tr id="box#currentrow#" class="#cl#">
					  							 							     
						  <td colspan="3" id="cbox#currentrow#" sthle="height:100%">
						  
						      <cfparam name="url.zero" default="false">
							  											  									 										 								 									
							  <cfif recorded gte "1">
							  											      
								  <cfset url.box          = "box#currentrow#">
								  <cfset url.location     = location>
								  <cfset url.category     = category>
								  <cfset url.categoryitem = categoryitem>	
								  <cfset url.parentItemNo = parentItemNo>  										  
						  		  ...
						  		  <cfinclude template="InventoryViewList.cfm">
								  
							  </cfif>
						  
						  </td>
						  
					  </tr>  
					  
					  </cfoutput>
				  
				  </cfoutput>
				  
				  <tr><td colspan="3" class="line"></td></tr>
			
			</cfoutput> 
				<!---- parent item --->
				  
			</cfoutput>	  
				 										
		</cfoutput>
	
	</cfoutput>
	
    </table>
	
	<script>
		Prosis.busy("no")
	</script>