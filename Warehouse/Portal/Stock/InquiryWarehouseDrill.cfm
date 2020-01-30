
<cfoutput>
	
	<cfparam name="url.itemlocationid" default="">
	<cfparam name="url.mission"        default="">
	<cfparam name="url.mode"           default="">
	<cfparam name="url.onrequest"      default="0">
	
	<cfquery name="get" 
	datasource="AppsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT * 
		FROM   ItemWarehouseLocation
		WHERE  ItemLocationid = '#url.itemlocationid#'
	</cfquery>	

	<cfif get.recordcount eq "1">
	
	<!--- drill template for details --->
	
	<table width="89%" border="0" align="center" style="border:1px dotted silver" bgcolor="FFFFF5" style="padding:10px">
						
		<tr>
			<td style="padding:3px;border:0px dotted silver">	
			    
				<table width="100%" height="100%" align="center" cellspacing="0" cellpadding="0">
				
				    <!--- pending for submission --->			
					
					<tr><td height="4"></td></tr>
					
					<cfset cl = "hide">						
					<cfif url.mode eq "cart">
						<cfset cl = "regular">
					</cfif>
					
					<tr>
						<td class="labellarge" style="padding-left:14px;padding-bottom:4px;">	
							
							<cfset cl2 = "regular">
							<cfif cl eq "regular">
								<cfset cl2 = "hide">
							</cfif>		
							
							<table><tr><td width="40">	
																						
							<img src="#client.virtualdir#/Images/arrowright.gif" alt="" 
								id="cart_#get.itemLocationId#Exp" border="0" class="#cl2#" 
								align="absmiddle" style="cursor: pointer" height="11" 
								onClick="showcart('#get.itemlocationid#','#url.mission#','#get.warehouse#','#get.location#','#get.itemno#','#get.uom#')">
							
							<img src="#client.virtualdir#/Images/arrowdown.gif" 
								id="cart_#get.itemLocationId#Min" alt="" border="0" 
								align="absmiddle" class="#cl#" height="11" 
								style="cursor: pointer;" 
								onClick="showcart('#get.itemlocationid#','#url.mission#','#get.warehouse#','#get.location#','#get.itemno#','#get.uom#')">												
								
							</td>
							<td style="padding-left:10px" class="labellarge">	
							
							<a href="javascript:showcart('#get.itemlocationid#','#url.mission#','#get.warehouse#','#get.location#','#get.itemno#','#get.uom#')">	
								
								 <cf_tl id="Submission">								
								
							</a>
							
							</td></tr>
							</table>
						</td>
					</tr>
					
					<tr><td class="linedotted"></td></tr>	
					
					<!--- pending submission box --->	
												
					<tr id="cart_#get.itemLocationId#" class="#cl#" style="padding:2px">							   		   
						<td style="padding-left:20px;padding-right:20px;padding:3px" id="cartcontent_#get.itemLocationid#">
						
						<cfif url.mode eq "cart">
						    <cfset url.shiptowarehouse = get.warehouse>
							<cfset url.shiptolocation  = get.location>
							<cfset url.itemno          = get.itemno>
							<cfset url.uom             = get.uom>
							<cfinclude template="../Requester/Cart.cfm">
						</cfif>
																		
						</td>									
					</tr>						
				
					<cfif url.onRequest gt "0">	
					
					<cfset cl = "hide">
					<cfif url.mode eq "line">
						<cfset cl = "regular">
					</cfif>	
																
					<tr>
						<td  style="padding-top:4px;padding-left:14px">
						
							<cfset cl2 = "regular">
							<cfif cl eq "regular">
								<cfset cl2 = "hide">
							</cfif>	
							
							<table><tr><td width="40">	
					
							<img src="#SESSION.root#/Images/arrowright.gif" alt="" 
								id="box_#url.itemlocationid#Exp" border="0" class="#cl2#" 
								align="absmiddle" style="cursor: pointer" height="11" 
								onClick="showrequest('#url.itemlocationid#','#url.mission#')">
							
							<img src="#SESSION.root#/Images/arrowdown.gif" 
								id="box_#url.itemlocationid#Min" alt="" border="0" 
								align="absmiddle" class="#cl#" height="11" 
								style="cursor: pointer;" 
								onClick="showrequest('#url.itemlocationid#','#url.mission#')">
								
							</td>	
							<td style="padding-bottom:4px;padding-left:10px" class="labellarge">
					
								<a href="javascript:showrequest('#url.itemlocationid#','#url.mission#')">			 								
								<cf_tl id="Delivery">									
								</a>
								
							</td>
							</tr>
							</table>
						</td>
					</tr>
					
					<tr><td class="linedotted"></td></tr>	
										
					<cfset editmode = "view">
					
					<!--- onrequest box --->														
					<tr id="box_#url.itemlocationid#" class="#cl#"> 							   			   
						<td style="padding:3px" id="boxcontent_#url.itemlocationid#">	
						<cfif url.mode eq "line">					
							<cfinclude template="../Requester/HistoryList.cfm">
						</cfif>					
						</td>						
					</tr>		
																													
					</cfif>		
															
				</table>		
				
			</td>
		</tr>
	</table>
	
	</cfif>

</cfoutput>