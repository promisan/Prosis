
<cfparam name="Form.Location"          default="">
<cfparam name="URL.systemfunctionid"   default="">

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

<!--- filter criteria of items --->
<cfparam name="URL.mde"                default="">
<cfparam name="URL.fnd"                default=""> <!--- search --->

<cfparam name="Object.ObjectKeyValue4" default="">
<cfparam name="URL.stockorderid"       default="#Object.ObjectKeyValue4#">

<cfparam name="URL.Group"              default="Location">

<cfparam name="URL.WarerhouseTo"       default="">
<cfparam name="URL.locationTo"         default="">

<cfif url.warehouseto eq "">
	<cfset url.mode  = "standard">
<cfelse>
	<cfset url.mode  = "quick">	
</cfif>

<cfquery name="Param"
	datasource="AppsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT  *
		FROM    Ref_ParameterMission
		WHERE   Mission = '#URL.Mission#'
</cfquery>	

<cfset selloc = url.loc>

<!--- show the result --->
<cfset vSearchFnd = trim(URL.fnd)>
<cfset vSearchFnd = replace(vSearchFnd," ","%","ALL")>
<cfset vSearchFnd = "%#vSearchFnd#%">

<cfquery name="SearchResult"
	datasource="AppsTransaction" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT   *
	FROM     Transfer#URL.Warehouse#_#SESSION.acc# WITH (NOLOCK)
	WHERE    1 = 1
	<cfif trim(URL.fnd) neq "">
		    <!--- sync this search with the other receipt search --->
	AND    (ItemNo LIKE '#vSearchFnd#' 
	    OR ItemBarCode LIKE '#vSearchFnd#'
		OR ItemNoExternal  LIKE '#vSearchFnd#'
		OR ItemDescription LIKE '#vSearchFnd#'  
		OR TransactionLot LIKE '#vSearchFnd#'
		OR TransactionReference LIKE '#vSearchFnd#')
	</cfif> 
	
				
	<cfif url.loc neq "" and url.stockorderid eq "">			
		AND  Location IN (#preservesingleQuotes(selloc)#) 
	</cfif>	
	
	<cfif url.mde eq "pending">
	AND     TransferQuantity is NOT NULL
	</cfif>
	
	ORDER BY #URL.Group#, 
	         Detail DESC, 
			 ItemDescription		 
</cfquery>

<table style="width:98.5%" align="left" class="navigation_table">
			
<cfif url.stockorderid neq "">							
	 				 
	 <cfquery name="Prior" 
		datasource="AppsMaterials" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		   SELECT    P.*
		   FROM      WarehouseBatch P WITH (NOLOCK)
		   WHERE     P.StockOrderId = '#url.stockorderid#'  		
		   AND       BatchNo IN (SELECT TransactionBatchNo 
		                         FROM   ItemTransaction WITH (NOLOCK)
								 WHERE  TransactionBatchNo = P.BatchNo)					  
	 </cfquery>
	 
	<!--- show the prior transactions for this flow --->
	 
	<cfif Prior.recordcount neq "0">
	 
	 <tr><td colspan="<cfoutput>#cols#</cfoutput>" class="labelit line">Already recorded transfers as part of this action</td></tr>
	 	 
	</cfif>
	   
	<cfloop query="prior">
	   <tr><td colspan="12">
	   <!--- show this batch --->
	   <cfdiv bind="url:#SESSION.root#/warehouse/application/stock/batch/batchviewtransaction.cfm?stockorderid=#url.stockorderid#&batchno=#batchno#">				  
	   </td></tr>		
	</cfloop>		
	 					
	<tr><td height="3"></td></tr>
	
	<!--- entry screen for additional transfers --->		
	 
	<cfif Prior.recordcount gte "1">	 				 				 		 				 

	     <tr><td height="7"></td></tr>
	     <tr><td colspan="<cfoutput>#cols#</cfoutput>" class="labellarge"><cf_tl id="Record another transfer"></td></tr>
		 <tr><td colspan="<cfoutput>#cols#</cfoutput>" class="linedotted"></td></tr>
	 
	</cfif>
			
	<cfinclude template="TransferViewOperators.cfm">
					
	<tr><td height="3"></td></tr>											
					
	<!--- show the submit button if condition exisit --->
	 
	<TR> 
         <td colspan="<cfoutput>#cols#</cfoutput>" align="center" id="save" class="hide">
	  
	    <table width="100%" align="center">
		
			<tr>
			<td bgcolor="ffffaf" align="center" style="border:0px solid silver;padding-top:2px">
		  
		    <!--- option to post the transaction --->
			
			<cfoutput>
			
		   	<button name="Save" id="Save" type="button"
				 value="Transfer Quantities" 
				 class="Button10g" 
				 style="width:190px;height:27px" 
				 onclick="trfsubmit('#url.mission#','#url.systemfunctionid#','#url.stockorderid#','#url.loc#')">
			    	<cf_tl id="Save">
			</button>	
			
			</cfoutput>
			
			</td>
			</tr>
			
		</table>		
			
  	  </td>			  	   
       </TR>	
									
	<tr class="line">			       
		<td colspan="<cfoutput>#cols#</cfoutput>" style="height:30;padding-top:7px;padding-left:2px" class="labellarge"><cf_tl id="Storage Locations"></td>
	</tr>
	
</cfif>

<cfoutput>

<cfset cols = "13">
					
<cfif searchresult.recordcount eq "0">
		
	<tr><td class="labelarge" colspan="#cols#" style="font-size:16px;padding-top:15px" align="center"><cf_tl id="No storage locations with stock found"></td></tr>

<cfelse>

					
<tr class="fixrow labelmedium line">
    <td width="1%" height="17"></td>							
	<td width="1%"></td>	
	<cfif url.mode eq "standard">
	<TD width="1%" align="right"></TD>						
	<cfelse>
	<TD width="8%" align="right"><cf_tl id="Transfer"></TD>	
	</cfif>			
	<TD style="padding-left:5px;min-width:50px"><cf_tl id="Cat"></TD>		
	<TD style="min-width:60px"><cf_tl id="No"></TD>		
	<td style="min-width:100px"><cf_tl id="Code"></td>		
	<TD style="width:100%"><cf_tl id="Product"></TD>	
	<cfif url.loc eq "">
	<TD style="min-width:60px"><cf_tl id="Location"></TD>	
	</cfif>
	<TD style="min-width:60px" align="right"><cf_tl id="Min"></TD>
	<TD style="min-width:80px" align="center"><cfif Param.lotManagement eq "Yes"><cf_tl id="Lot"></cfif></TD>	
	<TD style="min-width:60px"><cf_tl id="Reference"></TD>
	<TD style="min-width:80px;padding-left:4px"><cf_tl id="Measure"></TD>					
    <td style="min-width:60px;padding-right:5px" align="right"><cf_tl id="On Hand"></td>			
</TR>
	
</cfif>			
	
<cfset rows = ceiling((url.height-110)/17)>
<cfset first   = ((URL.Page-1)*rows)+1>

<cfif url.mde eq "pending">
	<cfset first = "1">
	<cfset rows  = 1000>
</cfif>

<script language="JavaScript">

    try {
    prior = document.getElementById('totalrecords').value
	if (prior != '#SearchResult.recordcount#') {
	    _cf_loadingtexthtml='';	
		ptoken.navigate('#session.root#/Warehouse/Application/Stock/Transfer/setPage.cfm?mode=#url.mde#&systemfunctionid=#url.systemfunctionid#&height=#url.height#&total=#SearchResult.recordCount#','pagebox')
		document.getElementById('totalrecords').value = '#SearchResult.recordCount#' 
	}	
	} catch(e) {}
			
</script>

</cfoutput>
		
<cfset cnt   = 0>
<cfset row   = 0>
<cfset grp   = 1>
<cfset prior = "">
									
<cfoutput query="SearchResult" startrow="#first#">
			
	<cfif currentrow-first lt rows>
	
	  <cfset row = "#currentrow-first+1#">			  
					   
	  <cfif detail eq "0">			  
	  
	  		<cfset cnt=cnt+1>
	    
	        <cf_precision number="#ItemPrecision#">
	  		
			<cfif url.stockorderid eq "">	
			
		    <tr bgcolor="#IIf(CurrentRow Mod 2, DE('ffffff'), DE('Ffffff'))#"
			    style="cursor:pointer;height:20px;padding:0px"
				class="labelmedium2 navigation_row regular line"					
				ondblclick="item('#ItemNo#','#url.systemfunctionid#','#URL.Mission#')">
				
			<cfelse>	
			
			 <!--- embedded mode --->
			
			 <tr bgcolor="#IIf(CurrentRow Mod 2, DE('f4f4f4'), DE('Ffffff'))#"
			    class="navigation_row labelmedium2 line" style="cursor : pointer;height:20px;padding:0px">
				
			</cfif>
				
		    <td style="padding-left:6px"></td>								
			<td height="20"></td>	
			
			<td style="padding-left:5px;padding-right:5px;padding-top:3px">
			
				<cfif url.mode eq "Quick">
				
				<cfelse>
					
				     <!--- check if the transfer transaction is enabled --->
				 
					 <cfif url.stockorderid neq "" and Quantity gt "0">
					 
					 	<cf_img icon="select" 
							 navigation="Yes"  
							 onclick="ptoken.navigate('#SESSION.root#/Warehouse/Application/Stock/Transfer/StockTransfer.cfm?loc=#location#&whs=#url.warehouse#&mode=insert&warehouse=#url.warehouse#&id=#TransactionId#&systemfunctionid=#url.systemfunctionid#&stockorderid=#url.stockorderid#','transfer#TransactionId#')">
																	 
					 <cfelseif  Quantity gt "0">
					 
					  <!--- checking if the transfer option is enabled --->
					 
					  <cfquery name="isInitialised"
						datasource="AppsMaterials" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">
						  SELECT    *
						  FROM      ItemWarehouseLocationTransaction WITH (NOLOCK)
						  WHERE     Warehouse = '#url.Warehouse#' 
						  AND       Location  = '#location#' 
						  AND       ItemNo    = '#ItemNo#' 
						  AND       UoM       = '#UnitOfMeasure#' 						 							 
					  </cfquery>
					 
					 <cfquery name="CheckEnabled"
						datasource="AppsMaterials" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">
						  SELECT    *
						  FROM      ItemWarehouseLocationTransaction WITH (NOLOCK)
						  WHERE     Warehouse = '#url.Warehouse#' 
						  AND       Location  = '#location#' 
						  AND       ItemNo    = '#ItemNo#' 
						  AND       UoM       = '#UnitOfMeasure#' 						 
						  AND       TransactionType IN ('6','8') 
						  AND       Operational = '1'
					  </cfquery>
					  
					<cfif CheckEnabled.recordcount gte "1" or isInitialised.recordcount eq "0">
						<cf_img icon="select" 
							 navigation="Yes"  
							 onclick="ptoken.navigate('#SESSION.root#/Warehouse/Application/Stock/Transfer/StockTransfer.cfm?loc=#Location#&whs=#url.warehouse#&mode=insert&warehouse=#url.warehouse#&id=#TransactionId#&systemfunctionid=#url.systemfunctionid#&stockorderid=#url.stockorderid#','transfer#TransactionId#')">
																				 
					 </cfif>	
					 
					</cfif>  
				
				</cfif>
				 
			</td>
								
			<TD style="padding-left:5px;padding-right:3px">#Category#</TD>												
			<TD style="padding-right:3px"><cfif prior neq itemno>#ItemNo#<cfelse>&nbsp;</cfif></TD>			
			<td style="padding-right:5px;">#ItemNoExternal#</td>
			
			<cfif url.stockorderid eq "">					
			
				<TD><cfif prior neq itemno>
				     <a href="javascript:item('#ItemNo#','#url.systemfunctionid#','#url.mission#',)">#ItemDescription#</a>
					<cfelse>#ItemDescription#</cfif>
				</TD>
	
			<cfelse>
			
				<TD><cfif prior neq itemno>#ItemDescription#<cfelse>&nbsp;</cfif></TD>					
				
			</cfif>
			
			<cfif url.loc eq "">
			<td>#Location#</td>
			</cfif>
			
			<td align="right">
			
				<cfquery name="qOffer"
					datasource="AppsMaterials" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">						
						SELECT   IVO.OfferMinimumQuantity 
						FROM     ItemVendor IV WITH (NOLOCK) INNER JOIN 
							     ItemVendorOffer IVO WITH (NOLOCK) ON IV.ItemNo = IVO.ItemNo
						WHERE    IV.ItemNo  = '#ItemNo#'
						AND      IV.Preferred = '1'
						ORDER BY DateEffective DESC
				</cfquery>
					
				<cfif qOffer.recordcount neq 0>
					#qOffer.OfferMinimumQuantity#
				</cfif>	
						
			</td>		
			
			<td align="right"><cfif param.LotManagement is "1" and TransactionLot neq "0">#TransactionLot#</cfif></td>	
			<td><cfif Transactionreference neq "Stock discrepancy" and StockControlMode eq "Individual">#TransactionReference#</cfif></td>	
			<td style="padding-left:4px">#UoMDescription#</td>	
			<td align="right" style="padding-right:4px"><cfif Quantity lte "0"><b><font color="FF0000"></cfif>#NumberFormat(Quantity,'#pformat#')#</font></td>													
					
			<cfif url.mode eq "Quick">
				<td align="right" style="padding-left:5px;">
				<cfinclude template="StockTransfer.cfm">
				<a class="hide" id="f#TransactionId#"></a>
				<a class="hide" id="transfer#TransactionId#"></a>	
				</td>
			<cfelse>
				<td></td>	
			</cfif>		
			
			
					
			</tr>		
			
			<cfif url.mode eq "Standard">		
				
				<cfif transferquantity eq "">	
				
				<tr class="hide" id="transfer#TransactionId#row">				
					<td colspan="#cols+1#" style="background-color:ffffff">											
						<cfdiv id="transfer#TransactionId#">																
					</td>
				</tr>		
				
				<cfelse>	
						
				<tr class="hide" id="transfer#TransactionId#row">
					<td colspan="#cols+1#" style="background-color:ffffff">																									
						<cfdiv id="transfer#TransactionId#" 
						   bind="url:#SESSION.root#/Warehouse/Application/Stock/Transfer/StockTransfer.cfm?whs=#url.warehouse#&loc=#url.loc#&mode=insert&id=#TransactionId#&systemfunctionid=#url.systemfunctionid#&stockorderid=#url.stockorderid#">																		
					</td>
				</tr>	
				</cfif>
			
			</cfif>
							  
	  <cfelse>
	  			     												
			<cfquery name="sum" dbtype="query">
				 SELECT  sum(Amount) as Amount
				 FROM    SearchResult	
				 <cfswitch expression = "#URL.Group#">
				     <cfcase value = "Location">
					    WHERE Location = '#Location#'
					 </cfcase>
				</cfswitch>	 
			</cfquery>										 				
			
			<cfswitch expression = "#URL.Group#">
			
			     <cfcase value = "Location">
				 
				 <tr style="cursor:pointer" class="line fixrow2">
															 
					<td colspan="14" class="labelmedium" style="font-size:24px;height:35px;padding-bottom:3px;padding-top:4px;padding-left:8px">				
						 
					<cfquery name="Loc"
					datasource="AppsMaterials" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
						SELECT  *
						FROM  WarehouseLocation WL WITH (NOLOCK)
								INNER JOIN Ref_WarehouseLocationClass R WITH (NOLOCK)
								 	ON WL.LocationClass = R.Code
						WHERE Warehouse = '#URL.Warehouse#'
						AND   Location = '#Location#'														    
					</cfquery>
											   
				 	#Loc.Description# <cfif Loc.StorageCode neq Loc.Description>#Loc.StorageCode#</cfif> <font size="2"><cfif Loc.StorageCode neq Location>(#location#)</cfif></font> 
					  
					</td>
										
				 </TR>
												
				 </cfcase>			
				 
			</cfswitch>	 
					
	  </cfif>
	  
	  <cfset prior = itemno>
										  
	 </cfif>	
							 									
</CFOUTPUT>
			
</TABLE>

<script>
	Prosis.busy('no')
</script>

<cfset AjaxOnLoad("doHighlight")>	
