
<cfparam name="URL.ID"     default="Cat">
<cfparam name="URL.ID1"    default="xxx">
<cfparam name="URL.Status" default="0">

<cfif URL.find neq "">
    <cfset Criteria = "(I.ItemDescription LIKE '%#URL.find#%' OR I.ItemNo LIKE '%#URL.find#%' OR I.Classification LIKE '%#URL.find#%')">
</cfif>   

<cfoutput>

    <!--- show only items that are enabled for that mission as well --->
	
	<cfsavecontent variable="sql">
	
	    FROM  Item I 
		      INNER JOIN   ItemUoM U ON I.ItemNo = U.ItemNo 			  
			  <!--- show only items that are enabled for that mission as well --->			   
			  INNER JOIN   ItemUoMMission M ON U.ItemNo = M.ItemNo AND U.UoM = M.UoM AND M.Mission = '#url.mission#' 
			  
			  LEFT OUTER JOIN WarehouseCart C ON U.ItemNo = C.ItemNo AND U.UoM = C.UoM AND C.UserAccount = '#SESSION.acc#' AND C.Warehouse = '#url.warehouse#'	 
	    
		WHERE U.EnablePortal = 1 
		
		AND   M.Operational = 1
		
		<cfif URL.find neq "">
		
		AND   #PreserveSingleQuotes(Criteria)#   
		
		</cfif>		
		
		AND   I.ItemProcessMode = 'Pickticket'						
		
		<cfif URL.category neq "undefined" and URL.Category neq "All">
		
		AND   I.Category = '#URL.Category#'  
		
		<cfelse>

		<!--- only valid categories are shown for the warehouse --->
		AND   I.Category IN (SELECT Category 
		                     FROM   WarehouseCategory
							 WHERE  Warehouse = '#url.warehouse#' 
							 AND    OperationaL = 1 
							 AND    SelfService = 1)
		</cfif>			
		
	</cfsavecontent>
	
</cfoutput>

<!--- Query returning search results --->
<cfquery name="Total" 
datasource="AppsMaterials" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT count(*) as Total
    #preserveSingleQuotes(sql)# 
</cfquery>

<cfparam name="url.page" default="1">
<cfset cpage  = url.page>
<cfset pages = ceiling(total.total/9)>
<cfif pages lt "1">
   <cfset pages = '1'>
</cfif>

<cfset top    = (page)*9>
<cfset first  = ((page-1)*9)+1>

<!--- Query returning search results --->
<cfquery name="SearchResult" 
datasource="AppsMaterials" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT TOP #top# I.*, 
	        C.ItemNo as Cart, 
		    U.Uom, 
		    U.UoMDescription, 
		    U.UoMMultiplier, 
		    U.StandardCost,
		    U.ItemUoMDetails
     #preserveSingleQuotes(sql)#
	ORDER BY I.Category, I.ItemDescription  
</cfquery>


<!--- Query returning search results --->


<cf_divscroll>

<table width="100%" border="0" cellspacing="0" cellpadding="0" align="center" bordercolor="e4e4e4" class="formpadding">
 
<tr><td>
		
		<table width="97%" align="center" border="0" cellspacing="0" cellpadding="0" class="formpadding">
		
		<cfoutput query="SearchResult" group="Category" startrow="#first#">
				
			<cfquery name="get" 
			datasource="AppsMaterials" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
		    	SELECT *
				FROM #Client.LanPrefix#Ref_Category
				WHERE Category = '#Category#'	
			</cfquery>
		
			<tr><td colspan="6" style="padding:3px"><font face="Verdana" size="3">#get.Description#</font></td></tr>								
			<cfset cnt = 0>
			<cfset rc  = 0>
			
		<cfoutput>			
		
		    <cfif Cart eq "">
										
				<cfset rc = rc+1>
				
				<cfif rc MOD 3>
					<cfset rc = rc+1>
				</cfif>				
				
				<cfset cnt = cnt+1>
				<cfif cnt eq "1"><TR></cfif>
				<td class="regular1">
					<table cellpadding="0" cellspacing="0" width="100%">
						<tr>							
							<td	width="50%" 
								height="100%" 									
								id="b#currentrow#_1" class="reg"
								onmouseover="hl('b#currentrow#_1','b#currentrow#_2')"
								onmouseout="sl('b#currentrow#_1','b#currentrow#_2')" onclick="add('#itemno#','#uom#')"
								style="cursor: pointer;"
					            align="center"									
								bgcolor="white">
								
									<cf_tableround mode="solidborder" color="silver" onmouseover="this.bgColor='6095b1'" onmouseout="this.bgColor='silver'" >
										
									<table width="100%" height="100%" 
									<cfif #rc# MOD 2>
									bgcolor="F9F9F9"
									<cfelse>
									bgcolor="WHITE" 
									</cfif>  border="0" >
										<tr>
										<td width="150" bgcolor="white" valign="top" align="center" style="padding:2px">	
															 
											<cfif FileExists("#SESSION.rootDocumentPath#/Warehouse/Pictures/#ItemNo#.jpg")>
											
											 <cftry> 	
											 
											 <!--- too slow 				 
											
											 <cfimage action="RESIZE" 
											  source="#SESSION.rootDocument#Warehouse/Pictures/#ItemNo#.jpg" 
											  name="showimage" 
											  height="150" 
											  width="140">
											  
											  <cfimage action="WRITETOBROWSER" source="#showimage#">
											  
											  --->
											  
											  <img src="#SESSION.rootDocument#/Warehouse/Pictures/#ItemNo#.jpg"
											     alt="#ItemDescription#"
											     height="150"
												 width="140"
											     border="0"
											     align="absmiddle">
											  
											  <cfcatch>
											  
											  	<img src="#SESSION.root#/images/image-not-found.gif"
											     alt="#ItemDescription#"
											     height="150"
												 width="140"
											     border="0"
												 style="border: 1px dotted silver"
											     align="absmiddle">
											  
											  </cfcatch>
											  
											  </cftry>					  
																   
											 <cfelse>
											 
											 	<img src="#SESSION.root#/images/image-not-found.gif"
											     alt="#ItemDescription#"
											     height="150"
												 width="140"
											     border="0"
												 style="border: 1px dotted silver"
											     align="absmiddle">
											 </cfif>
										 
										</td>
																											
										<td width="80%" id="b#currentrow#_2" 
											valign="top" 
											style="padding-top:3px; padding-right:6px; cursor:pointer;">
											
										     <table width="100%" cellspacing="0" cellpadding="0">
											 
											 <!--- check for different standard cost --->
											 
											 
												<!--- Query returning search results --->
												<cfquery name="Cost" 
												datasource="AppsMaterials" 
												username="#SESSION.login#" 
												password="#SESSION.dbpw#">
												    SELECT *
													FROM   ItemUoMMission
													WHERE  Mission = '#url.mission#'
													AND    ItemNo = '#itemno#'
													AND    UoM    = '#uom#'   
												</cfquery>											 						 
											    				     	 
												 <tr height="15px"><td width="100" style="padding-left:4px"><font face="Verdana" color="gray"><cf_tl id="Item">:</font></td><TD>#ItemDescription#</TD></tr>
												 <tr height="15px"><td style="padding-left:4px"><font face="Verdana" color="gray"><cf_tl id="UoM">:</font></td><TD>#UoMDescription#</TD></tr>
												 <tr height="15px"><TD style="padding-left:4px"><font face="Verdana" color="gray"><cf_tl id="Category">:</TD><TD>#Category#</TD></tr>
												 <tr height="15px"><td style="padding-left:4px"><font face="Verdana" color="gray"><cf_tl id="Details">:</font></td><TD>#ItemUoMDetails#</TD></tr>
			
												 <tr>
												 <td style="padding-left:4px"><font face="Verdana" color="gray"><cf_tl id="Cost Price">:</font></td>
												 <td>
												 
													 <cfif cost.standardcost eq "0">
													 #NumberFormat(StandardCost,'__,__.__')#
													 <cfelse>
													 #NumberFormat(StandardCost,'__,__.__')#
													 </cfif>
												 
												 </td>
												 </tr>												 
												 <tr><td><b><!--- <font color="0080FF">Available</font></b>---></td></tr>
										     </table>
										 </td>
																	
										</tr>
				     					</table>	
									 
									</cf_tableround>
								 
							</td>
						</tr>
					</table>
				</td>					
				 
				 <cfif cnt eq "2"></TR>				
					 <cfset cnt=0>
				 </cfif>
						
			</cfif>
		</cfoutput>
		
		</cfoutput>
		
		<tr><td align="center" colspan="6">
									
		<cf_pagenavigation cpage="#cpage#" pages="#pages#">					
		
		</td></tr>
		
		</TABLE>
		
</td></tr>
					
</table>			
</cf_divscroll>