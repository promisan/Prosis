

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

<table width="98%" class="navigation_table">

<cfparam name="url.parent" default="0">
<cfparam name="url.lot"    default="">

<cftransaction isolation="read_uncommitted">
	
	<cfquery name="LocationCategoryList"
		datasource="AppsMaterials" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		
		    SELECT   			
          			 <!--- location --->
				     R.Code        as ClassCode,
				     R.Description as ClassName,						 							  
			         I.Location,					 
			         WL.Description, 
				     WL.ListingOrder,
				     WL.StorageCode,
					 
					 <!--- fuel tank --->					  
				     (SELECT SerialNo 
					  FROM   AssetItem 
					  WHERE  AssetId = WL.AssetId) as SerialNo,
					 
					 <!--- main category --->
				     C.Category,
				     C.Description as CategoryName,
					 
					 <!--- sub category --->
				     IT.CategoryItem,
				     CI.CategoryItemName,
					 
					 <cfif url.parent eq "1">
					 
					 <!--- parent item --->
				     IT.ParentItemNo,
				     (SELECT ItemDescription 
					  FROM   Item IP 
					  WHERE  IP.ItemNo = IT.ParentItemNo) as ParentItemName,
					  
					  <cfelse>
					  '' as ParentItemNo,
					  '' as ParentItemName,				  					  
					  </cfif>
					  
					
					 <!--- has already some inventory entries made --->					 
					 (SELECT  COUNT(*)
					  FROM    userTransaction.dbo.StockInventory#URL.Warehouse#_#SESSION.acc#  
					  WHERE   Warehouse    = '#url.warehouse#'
					  AND     Location     = I.Location
					  AND     Category     = C.Category
					  AND     CategoryItem = IT.CategoryItem
					  AND     Counted > 0) as Recorded  <!--- one or more items recorded --->
						 
			FROM     ItemWarehouseLocation I,   <!--- item is defined for the warehouse allows us to control what is shown here for data entry !! --->
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
									
			<!--- 20/8/22 : we have a few individual transaction that do not have a transactionidorig anymore 
			  and as such have a negative on the item level, and those are shown in the list, 
			  but are not show in the inventory detail list as in inventory
			  we apply based on the parentid --->
			  
			  <cfif url.lot neq "">
			  
			  AND  EXISTS (SELECT 'x'
				             FROM   ItemTransaction
				             WHERE  Warehouse      =  I.Warehouse
							 AND    Location       =  I.Location
							 AND    ItemNo         =  I.ItemNo
							 AND    TransactionUoM =  I.UoM		 
							 AND    TransactionLot = '#url.lot#'	
											 
							 )				  
			  
			  </cfif>
			  
			  <cfif url.parent eq "1">
			
				AND  EXISTS (SELECT 'x'
				             FROM   ItemTransaction
				             WHERE  Warehouse      =  I.Warehouse
							 AND    Location       =  I.Location
							 AND    ItemNo         =  I.ItemNo
							 AND    TransactionUoM =  I.UoM		
							 -- and TransactionLot != '18190505'
							 <cfif url.lot eq "">
							 HAVING ABS(SUM(TransactionQuantity)) >= 0.02	
							 </cfif>
							 )	
						 
				</cfif>
						 		
						 
			<cfelse>
			
			<!--- we check if there is indeed any stock --->			
			AND  EXISTS (SELECT 'x'
			             FROM   ItemTransaction
			             WHERE  Warehouse      =  I.Warehouse
						 AND    Location       =  I.Location
						 AND    ItemNo         =  I.ItemNo
						 AND    TransactionUoM = I.UoM						
						 <cfif findNoCase(get.LocationReceipt,url.loc)>
						 HAVING ABS(SUM(TransactionQuantity)) >= 1)							
						 <cfelse>
						 HAVING ABS(SUM(TransactionQuantity)) >= 0)	
						 </cfif>		
						 
			</cfif>		
			
			GROUP BY R.Code, 
			         WL.ListingOrder, 
					 I.Location,					 					 
					 C.Description,
					 IT.CategoryItem,
					 CI.CategoryItemName,
					 <cfif url.parent eq "1">
					 IT.ParentItemNo, 	
					 </cfif>
					 WL.Description, 
				     WL.StorageCode,        
					 WL.AssetId,
					 R.Description,
					 C.Category
					
						
			ORDER BY R.Code, 
			         WL.ListingOrder, 
					 I.Location,					 					 
					 C.Description,
					 IT.CategoryItem,
					 CI.CategoryItemName
					 <cfif url.parent eq "1">
					 ,IT.ParentItemNo 	
					 </cfif>
					
										 
					
					 					 
	</cfquery>		
	
	<!---
	<cfoutput>#cfquery.executiontime#</cfoutput>
	--->
			
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
							 		
				  <tr bgcolor="DAF9FC" class="fixrow clsFilterRow" style="height:25px">					   										
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
				   				  				 					  
				  <cfoutput group="CategoryName">
				  
				   <tr class="line clsFilterRow">								     
					  <td colspan="3" style="font-size:19px;padding-top:2px;padding-left:4px;height:38px" class="labellarge">#CategoryName# #url.lot#</td>								  										 
				   </tr>
				   
				   <cfoutput group="CategoryItem">	
				   				   										 					  
					 <cfoutput>
					  
					 <cfset apply = "locshow('#location#','#category#','#categoryitem#','box#currentrow#','#url.systemfunctionid#','','',document.getElementById('hidezero').checked,'#parentItemNo#',document.getElementById('ebox#currentrow#').checked,'1','#url.lot#')">
					  
					  <tr class="navigation_row fixrow2 clsFilterRow line">
					  
					     <td class="navigation_action clsCategoryLine" 
						    data-value="#currentrow#" 
							align="left" 
							style="max-width:40px;min-width:40px;padding-top:3px;padding-left:5px"  onClick="#apply#">
						 						  						   
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
						 
					 	 <td colspan="2" style="width:100%;height:100%">
						 
							 <table width="100%" style="height:100%">
							 
							 <tr class="clsFilterRow">
								 <td onclick="#apply#" style="font-size:14px;height:20px;padding-top:2px;padding-left:4px">#CategoryItem# #CategoryItemName# <font size="2" title="Parent Item"><cfif ParentItemNo neq "">/ #ParentItemNo# #ParentItemName#</cfif></font></td>
								 
								 <!--- filter box --->
								 
								 <td align="right" id="filterbox#currentrow#" class="#cl#">
								 
									  <table style="height:100%">									  
									  <tr style="fixlengthlist">									  
									  <td class="labelit" style="font-size:13px;height:26px;"><cf_tl id="Include earmarked">:</td>
									  <td style="padding-left:4px;padding-right:10px">
									   <input class="radiol" type="checkbox" id="ebox#currentrow#" value="1" checked onclick="document.getElementById('find#currentrow#').click()">
									  </td>
									  								  								   							 
									  <td class="labelit" style="font-size:13px;height:26px;"><cf_tl id="Filter">:</td>
									  <td style="padding-left:4px">
									
									<!---  
									  search(event,'#currentrow#')
									  
									  function search(e) {
	  
											   se = document.getElementById("find");	   
											   keynum = event.keyCode ? event.keyCode : event.charCode;	   	 						
											   if (keynum == 13) {
											      document.getElementById("locate").click();
											   }		
														
										    }
											--->
										
									  <input type="text" 
									   id        = "fbox#currentrow#"  
									   class     = "regularxl enterastab" 
									   onKeyUp   = "keynum = event.keyCode ? event.keyCode : event.charCode;val = this.value;if (val.length > 3) {document.getElementById('find#currentrow#').click()}"
									   style     = "height:100%;width:120px;border-left:1px solid silver;border-right:1px solid silver" value=""></td>
										   
									  <td style="padding-left:3px;padding-right:4px">
											
										<input type="button" 
										    id="find#currentrow#" 
											value="find" 
											class="button10g"
											style="width:50px;height:26px;" 
											onclick="locshow('#location#','#category#','#categoryitem#','box#currentrow#','#url.systemfunctionid#','1',document.getElementById('fbox#currentrow#').value,document.getElementById('hidezero').checked,'#parentitemno#',document.getElementById('ebox#currentrow#').checked,'0','#url.lot#')">
										
									   </td>										
									   </tr>
									   </table>
								 
								 </td>
							 </tr>
							 </table>					 
						 
						 </td>	
						 							  
					  </tr>
					  					  					 									 									  
					  <tr id="box#currentrow#" class="#cl#">
					  							 							     
						  <td colspan="3" id="cbox#currentrow#" style="width:98%;height:100%">
						  
						      <cfparam name="url.zero" default="false">
							  											  									 										 								 									
							  <cfif recorded gte "1">
							  											      
								  <cfset url.box          = "box#currentrow#">
								  <cfset url.location     = location>
								  <cfset url.category     = category>
								  <cfset url.categoryitem = categoryitem>	
								  <cfset url.parentItemNo = parentItemNo>  										  
						  		  
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
	
	<cfset ajaxOnLoad("doHighlight")>
	
	<script>
		Prosis.busy("no")
	</script>