
<cfparam name="url.module" default="Workorder">
<cfparam name="url.search" default="">
<cfparam name="itemlist" default="">	

<!--- ------------------------------------- --->
<!--- ------------------------------------- --->
<!--- ------------------------------------- --->

<cfquery name="getList" 
  datasource="AppsMaterials" 
  username="#SESSION.login#" 
  password="#SESSION.dbpw#">  
   
    SELECT TOP 25 I.* 
	
	<cfif url.module eq "materials" and  filter2 eq "imageclass">
	
		,II.ImagePathThumbnail, 
		 II.ImageClass,
		 R.ResolutionWidthThumbnail, 
		 R.ResolutionHeightThumbnail
		 
	<cfelse>
		, 
		 '' as ImagePathThumbnail, 
		 '' as ImageClass	
	</cfif>
	
    FROM   Item	I
	
	<cfif url.module eq "materials" and filter2 eq "imageclass">
	
		LEFT JOIN ItemImage II
			ON 	 II.ItemNo = I.ItemNo
			AND  II.ImageClass = '#filter2value#'
			AND  II.Mission = I.Mission
			
		LEFT JOIN Ref_ImageClass R
			ON  II.ImageClass = R.Code
	
	</cfif>
	
	WHERE  1 = 1	
		
	<cfif itemlist neq "">
	AND    ItemNo IN (
	              <cfqueryparam value="#itemlist#" cfsqltype="cf_sql_char" list="true"/>
		   )
	</cfif>		
	
	<cfif url.module eq "workorder">
	
		<cfif url.search neq "">
		AND  (
		     ItemDescription LIKE '%#URL.search#%' OR
			 ItemNo IN (SELECT ItemNo 
			            FROM   ItemUoM 
						WHERE  ItemBarCode LIKE '%#URL.search#%')
			 )
		</cfif>
		
		AND    ItemNo IN (SELECT ItemNo
		                  FROM   WorkOrder.dbo.ServiceItemUnitItem 
		                  WHERE  ServiceItem = '#url.filter1value#'
						  AND    ItemNo = I.ItemNo)		
						  
		<cfif url.filter2 neq "">
	    AND   #url.filter2# = '#url.filter2value#'
    	</cfif> 					  
					  			  
	<cfelseif url.module eq "materials">		
	
		<cfif url.search neq "">
		
		AND  (
		
	    	 I.ItemDescription LIKE '%#URL.search#%' 
			 OR I.ItemNo IN (SELECT ItemNo 
			                 FROM   ItemUoM 
						     WHERE  ItemBarCode LIKE '%#URL.search#%')
			 OR I.ItemNo = '#url.search#'

			 )
			 
		AND (
				I.ItemClass IN ('Service')
				OR  
				I.ItemNo IN (SELECT ItemNo 
			                   FROM   ItemWarehouse
							   WHERE  Warehouse = '#url.filter1value#'
							   AND    ItemNo = I.ItemNo
							   AND    Operational = 1) 	  
			)
						 
		AND   I.Operational = 1		
		
		<cfif url.onhand eq "true">
				
		AND   (
		        I.ItemClass IN ('Service') 
		       OR   (
				    I.ItemClass IN ('Supply')
				    AND
				    I.ItemNo IN (SELECT     ItemNo 
			                     FROM       ItemTransaction
					   		     WHERE      ItemNo    = I.ItemNo
								 AND        Mission   = I.Mission
								 AND        Warehouse = '#url.filter1value#'
								 GROUP BY   ItemNo
								 HAVING     SUM(TransactionQuantity) > 0)
				   )			 
			  )		
			 	

		<cfelse> 
	  
		AND    I.ItemClass IN ('Supply','Service')
		
		</cfif>
		
		AND    I.Destination = 'Sale'
		
		<cfelse>
		
		AND    1 = 0
		
		</cfif>
			  
	</cfif>
	<cfif session.acc eq "mleonardo">
		AND
		(
			EXISTS
			(
			SELECT 'X'
			FROM ItemWarehouseLocation IWL
			WHERE IWL.Location='006'
			AND IWL.ItemNo = I.ItemNo
			)
			OR
			EXISTS
			(
			SELECT 'X'
			FROM Item I2
			WHERE I2.ItemNo = I.ItemNo
			AND I2.Make = 'STIHL'
			)
		)
	</cfif>

</cfquery>

<cfif getList.recordcount eq "0" and url.search neq "">
	
	<table align="center" cellpadding="0" cellspacing="0">
	<tr><td class="labelmedium" style="padding-top:20px"><cf_tl id="No matching items found"></td></tr>
	</table>

</cfif>

<cfif getList.recordcount gt "200">
	
	<table align="center" cellpadding="0" cellspacing="0">
	<tr><td class="labelmedium" style="padding-top:20px"><cf_tl id="Refine your search"></td></tr>
	</table>

	<cfabort>

</cfif>

<cfset cnt = 0>

<cfset start = "1">
<cfset new   = link>

<cfloop condition="#start# lte #len(new)#">
		
		<cfif find("{","#new#",start)>
				
			<cfset str = find("{","#new#",start)>
			<cfset str = str+1>
			<cfset end = find("}","#new#",start)>
			<cfset end = end>			
			<cfset fld = Mid(new, str, end-str)>									
			<cfif fld eq "height">			
				<cfset qry = "'+document.body.clientHeight+'">									
			<cfelseif fld eq "width">			
				<cfset qry = "'+document.body.clientWidth+'">				
			<cfelse>			
			<cfset qry = "'+document.getElementById('#fld#').value+'">						
			</cfif>			
			<cfset new = replace(new,"{#fld#}","#qry#")>  			
			<cfset start = end>			
		<cfelse>		
			<cfset start = len(new)+1>	
		</cfif> 
	
</cfloop>	

<cfset link   = new>	

<table cellpadding="0" cellspacing="0">

		<tr>

		<cfoutput query="getList">
		
		<cfset cnt = cnt+1>		
			
		<cfif cnt eq "1"><tr></cfif>		
		
		    <cfif url.module eq "workorder">
			
			   <cfset setlink = "ptoken.navigate('#SESSION.root#/Tools/SelectLookup/ItemExtended/ItemDetail.cfm?module=#url.module#&link=#link#&close=#url.close#&des1=#url.des1#&box=#url.box#&itemno=#ItemNo#','dlist')">	
								
			<cfelse>	
					
				<cf_tl id="A valid customer or billing could not be determined" var="1">
				
				<cfsavecontent variable="setlink">
					document.getElementById('vaction').className='hide';
					document.getElementById('dlist').className='regular';
					_cf_loadingtexthtml='';	
					var _cust = document.getElementById('customeridselect').value;
					var _inv = document.getElementById('customerinvoiceidselect').value;					
					// if (_cust == '' || _cust == '00000000-0000-0000-0000-000000000000' || _inv == '' || _inv == '00000000-0000-0000-0000-000000000000') {
					if (_cust == ''  || _inv == '') {
						alert('#lt_text#');
					}else{					
						ptoken.navigate('#SESSION.root#/Tools/SelectLookup/ItemExtended/ItemStock.cfm?module=#url.module#&link=#link#&filter1value=#url.filter1value#&filter2=#filter2#&filter2value=#filter2value#&close=#url.close#&des1=#url.des1#&box=#url.box#&itemno=#ItemNo#&customerid='+document.getElementById('customeridselect').value+'&customeridinvoice='+document.getElementById('customerinvoiceidselect').value+'&currency='+document.getElementById('currency').value,'dlist');
					}
				</cfsavecontent>
				
				
			</cfif>	
			
			<td width="160" height="110" style="padding:3px;cursor:pointer;border:1px solid silver" height="20" 
			   onclick="#setlink#" onmouseover="this.bgColor='8cbdea'" onmouseout="this.bgColor='ffffff'">
								
				<table width="100%" height="100%" cellpadding="0" cellspacing="0">
				
					<tr>
					                                                  
                           <cfif ImagePathThumbnail neq "">
												
								<cfif FileExists("#SESSION.rootDocument#/#ImagePathThumbnail#")>
								
						            <td valign="top" align="center" style="min-width:80px;padding-top:3px"> 																									
									    <cfdiv bind="url:#session.root#/tools/selectlookup/ItemExtended/ItemListImage.cfm?id=#itemno#&image=#ImagePathThumbnail#">																		  
									 </td>
									  
								<cfelse>
																    
									<td valign="top" align="center" style="min-width:200px;padding-top:40px" class="labelit"> 	
										<font color="808080">[No Image]</font> 	                              
									</td>
																		
								</cfif>
								
                           <cfelse>
						   
						   	  <cfif FileExists("#SESSION.rootDocumentPath#/Warehouse/Pictures/#ItemNo#.jpg")>
						
						            <td valign="top" align="center" style="min-width:80px;padding-top:3px"> 
																
							         <img src="#SESSION.rootDocument#/Warehouse/Pictures/#ItemNo#.jpg"
										  alt="#ItemDescription# [#itemno#]"
	                                      height="70"
	                                      border="0"                                       
	                                      align="absmiddle">	
									  
									  </td>
								
								<cfelse>
															 
									<td valign="top" align="center" style="min-width:200px;padding-top:40px" class="labelit"> 	
										<font color="808080">[No Image]</font> 	                              
									</td>
									
									
								</cfif>
							
                           </cfif>
                                
                    </tr>
					
					<tr><td valign="bottom" style="padding-bottom:3px" align="center" class="labelmedium">#ItemDescription#</td></tr>  
					<cfif ItemNoExternal neq "">
						<tr><td valign="bottom" style="padding-bottom:3px" align="center" class="labelmedium">#ItemNoExternal#</td></tr>
					</cfif>	
				</table>
				
			</td>                   	

			<td style="width:3px"></td>
		
		<cfif cnt eq 5>
        </tr>		
		<tr><td height="4"></td></tr>		
		<cfset cnt= 0>		
		</cfif>		

		</cfoutput>
	</tr>
		
    <tr><td height="5"></td></tr>
									
</table>
