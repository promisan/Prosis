<cfparam name="URL.InfoBox" default="">
<script>
	Prosis.busy('no')
</script>	

<cfset vInitTotal = GetTickCount()>
<cfset vInitDate = now()>

<cfset vInit = GetTickCount()>

<cfinclude template="../getTreeData.cfm">

<!--- drivers selected --->

<!--- -------------------------------------- --->
<!--- keep the history of the selected nodes --->
<!--- -------------------------------------- --->

<cfquery name="Deliveries"
		datasource="appsWorkOrder" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">		
		SELECT   A.DateTimePlanning, 	
		         W.WorkOrderId,
				 wl.WorkOrderLineId,
				 W.OrgUnitOwner,
				 (SELECT OrgUnitName FROM Organization.dbo.Organization WHERE OrgUnit = W.OrgUnitOwner) as OrgUnitOwnerName,
				 C.PostalCode,
				 C.Address,
				 C.City,				 
		         C.CustomerName,	
				 C.Coordinates,				 
				 PL.PersonNo,
				 PL.FirstName,
				 PL.LastName,
				 PL.PlanOrderCode as Schedule,
				 PL.DateTimePlanning as ScheduleTime,
				 OP.Icon,  
				 1 as Planned,				 				 				 
				 (CASE WHEN DateTimeActual is NULL THEN 0 ELSE 1 END) as Actual
				 
	    FROM     WorkOrder AS W 
				 INNER JOIN Customer as C ON W.CustomerId = C.CustomerId  
		         INNER JOIN WorkOrderLine AS WL ON W.WorkOrderId = WL.WorkOrderId 
				 INNER JOIN WorkOrderLineAction AS A ON WL.WorkOrderId = A.WorkOrderId AND WL.WorkOrderLine = A.WorkOrderLine 
				 
				 <cfif person eq "">	 
												 
				    LEFT OUTER JOIN 
				 
				 <cfelse>
				
				 
				    INNER JOIN
				 
				 </cfif>
				 
				 	(
				 
				    SELECT  W.WorkPlanId, D.PlanOrder, D.PlanOrderCode, W.PersonNo, P.LastName, P.FirstName, D.DateTimePlanning, D.WorkActionId
				    FROM    WorkPlan AS W INNER JOIN
                            WorkPlanDetail AS D ON W.WorkPlanId = D.WorkPlanId INNER JOIN
                            Employee.dbo.Person AS P ON W.PersonNo = P.PersonNo
					WHERE   W.Mission = '#url.mission#' 
					AND     W.DateEffective  <= #dts# 
					AND     W.DateExpiration >= #dts# 
					<cfif person neq "">
					AND     W.PersonNo IN (#preservesinglequotes(person)#)
					</cfif>
					AND     D.WorkActionId IS NOT NULL ) PL ON A.WorkActionId = PL.WorkActionId
					
					LEFT OUTER JOIN Ref_PlanOrder OP ON OP.Code = PL.PlanOrderCode  
												
	   WHERE     A.ActionClass = 'Delivery' 
	   AND       A.DateTimePlanning = #dts#
	   AND       W.Mission = '#url.mission#'		   	
	   <cfif units neq "" or workactionids neq "">	  
	   AND       (
	   			 <cfif units neq "">
	             W.OrgUnitOwner IN (#units#) 
				 </cfif>
				 <cfif units neq "" and workactionids neq "">
				 OR
				 </cfif>
				 <cfif workactionids neq "">
				 WL.WorkOrderLineId IN (#preservesinglequotes(workactionids)#)
				 </cfif>
				 ) 	 	   
	   </cfif>	     
	   AND       WL.Operational = '1'
	   AND       W.ActionStatus != 9	
	   ORDER BY  PL.PersonNo, A.DateTimePlanning 	
	  
	</cfquery>	
	
	<cfquery name="getHome"
		datasource="appsOrganization" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">		
		SELECT    A.Address, A.AddressCity, A.Coordinates, A.Country
		FROM      OrganizationAddress AS OA INNER JOIN
                  System.dbo.Ref_Address AS A ON OA.AddressId = A.AddressId
		WHERE     OA.OrgUnit IN
                          (SELECT    OrgUnit
                            FROM     Organization
                            WHERE    Mission = '#url.mission#' AND (TreeUnit = 1)) 
		AND       OA.AddressType = 'Home'
	</cfquery>
	
	
	<cfif getHome.coordinates neq "">
	
   	    <cfset nat = getHome.Country>
				
	    <cfset row = "0">
		<cfloop index="itm" list="#getHome.Coordinates#" delimiters=",">
			<cfset row = row+1>
			<cfif row eq "1">
			   <cfset  lat = itm>
			<cfelse>
			   <cfset  lng = itm>  		
			</cfif>
		</cfloop>	
	
	<cfelse>
	
		<cfset nat = "NET">
		<cfset lat = "0">
		<cfset lng = "0">
		
	</cfif>	
	
	<cfset l = "">
	
		
	<cfif url.size eq "true">	
		<cfset w = url.width-512>
	<cfelse>
		<cfset w = url.width-32>
	</cfif>	
				
	<table width="100%" height="100%" cellspacing="0" cellpadding="0" align="center">
	
	<tr><td valign="top" bgcolor="white">	
		
			<table width="96%" height="100%">			
							
			<tr>
			<td align="right" style="padding-top:11px;height:0;z-index:5;position:absolute;padding-left:400px">
			
				<table style="height:29px;border:0px inset dadada" align="right" bgcolor="FFFFFF">
				       <tr>
					    					  
				         <td style="padding-bottom:2px;border-left:1px solid silver;padding-left:10px;padding-right:5px" class="labelit"><cf_tl id="Inquiry"></td>
						 <td style="padding-right:15px"><input onclick="setoperation('inquiry')" checked type="radio" name="mapmode" id="mapmode" value="Inquiry"></td>
						 <td style="padding-bottom:2px;padding-right:5px" class="labelit"><cf_tl id="Quick Visual Planner"></td>
						 <td style="padding-right:10px"><input onclick="setoperation('planner')" type="radio" name="mapmode" id="mapmode" value="Inquiry"></td>
						 
						 <cfoutput>						
					     <td bgcolor="ffffcf" class="labelmedium" style="border-left:1px solid silver;padding-top:1px;font-size:12px;padding-left:10px;height:20px">Scheduled:</td>
						 </cfoutput>					     
						 <td bgcolor="ffffcf"  id="mapplanned" style="border-radius:3px;width:50px;padding-left:8px;padding-right:8px;font-size:18px;font-weight:bold"></td>	
						
				       </tr>
			    </table>
		   
		    </td></tr>
						
			<tr><td style="padding-top:0px;padding-bottom:0px" valign="top">
									
			<cfmap name="gmap"	   
			    centerlatitude   = "#lat#" 
			    centerlongitude  = "#lng#" 	
			    doubleclickzoom  = "true" 
				collapsible      = "false" 			
			    overview         = "true" 
				continuouszoom   = "true"
				height           = "#url.height-50#"
				width            = "#w#"		
				zoomcontrol      = "large3d"
				hideborder       = "true"		
			    scrollwheelzoom  = "true" 		
				showmarkerwindow = "true"
			    showscale        = "true"
				markerbind       = "url:MAP/MAPDetail.cfm?date=#url.date#&mission=#url.mission#&cfmapname={cfmapname}&cfmapaddress={cfmapaddress}" 
			    tip              = "#SESSION.welcome# Delivery Planner" 
			    zoomlevel        = "9"> 	
										
					<cfif person eq "" and unitchecked neq "">	
					
					<cfelseif person eq "">
					
						<cfset unitchecked = ValueList(Branch.OrgUnit)>
					
					<cfelse>						
						
						<!--- the units as relevant for this driver --->
			
						<cfquery name="getBranch" 
						     dbtype="query">
							 	SELECT DISTINCT OrgUnitOwner
								FROM  Deliveries
						</cfquery>	
						
						<cfset unitchecked = ValueList(getBranch.OrgUnitOwner)>
				
					</cfif>
									     
					<cfloop index="unit" list="#unitchecked#">
					
					    <!--- note we can tune this queries to make just one main query and then loop through this --->
													
						<cfquery name="getBranchAddress"
							datasource="appsWorkOrder" 
							username="#SESSION.login#" 
							password="#SESSION.dbpw#">			
							 SELECT   City,
							          Address1,
									  PostalCode,
									  MarkerColor,
									  MarkerIcon,
									  OrgUnitName
							 FROM     Organization.dbo.Organization O, 
							          Organization.dbo.vwOrganizationAddress A
							 WHERE    O.OrgUnit   = A.OrgUnit
							 AND      O.OrgUnit   = '#unit#'
							 AND      AddressType = 'Office'
						 </cfquery>		
										 
						<cfif getBranchAddress.markercolor neq "">
						
							<cfif getbranchaddress.postalcode neq "">
							
							   <cfset postal = replaceNoCase(getbranchaddress.PostalCode," ","","ALL")>
							   <cfset postal = replaceNoCase(postal,"'","","ALL")>
							   <cfset postal = replaceNoCase(postal,"`","","ALL")> 
							   <cfset postal = replaceNoCase(postal,"-","","ALL")> 
							   
							   <!--- obtain the postal code coodincates of the branch --->
							 
							   <cfquery name="Check"
								datasource="appsSystem" 
								username="#SESSION.login#" 
								password="#SESSION.dbpw#">		
									SELECT *
									FROM   PostalCode
									WHERE  Country    = '#nat#'
									AND    PostalCode = '#postal#'
							   	</cfquery>		
								
								<!--- valid the coordinates based on the country NET --->
								
								<cfif (
									(left(check.latitude,1) eq "4" or left(check.latitude,1) eq "5" )
									and 
									(left(check.longitude,2) eq "3." or left(check.longitude,2) eq "4." or left(check.longitude,2) eq "5." or left(check.longitude,2) eq "6." )
								)>		
								
									<cfif getbranchaddress.markercolor neq "" and  getbranchaddress.markericon neq "">
										<cfmapitem name="#unit#" 
										    latitude="#check.latitude#" 
									    	longitude="#check.longitude#" 	   
											markericon="#session.root#/images/mapicons/#getbranchaddress.markercolor#_#getbranchaddress.markericon#.png"						
									    	tip="Branch : #getbranchaddress.OrgUnitName#"/>
									<cfelse>
										<cfmapitem name="#unit#" 
										    latitude="#check.latitude#" 
									    	longitude="#check.longitude#" 	   
											markercolor="#getbranchaddress.markercolor#"						
									    	tip="Branch : #getbranchaddress.OrgUnitName#"/>								
									</cfif>							
								
								<cfelse>										 
										
									<!--- this runs only once --->
									
									<cfset vInit = GetTickCount()>
													
									<cfinvoke component="service.maps.googlegeocoder3" method="googlegeocoder3" returnvariable="details">	
									  
									  <cfif getbranchaddress.postalcode neq "">
									       <cfinvokeargument name="address" value="The Netherlands, #getbranchaddress.postalcode#">
									  <cfelse>
									       <cfinvokeargument name="address" value="The Netherlands, #getbranchaddress.city# #getbranchaddress.address1#">
									  </cfif>
									  <cfinvokeargument name="ShowDetails" value="false">
									  
								    </cfinvoke>								
									
									<cfif check.recordcount eq "1">
														
										<cfquery name="Update"
										datasource="appsSystem" 
										username="#SESSION.login#" 
										password="#SESSION.dbpw#">		
											UPDATE PostalCode	
											SET    Latitude    = '#details.latitude#',
											       Longitude   = '#details.longitude#',
												   Location    = '#details.formatted_address#',
												   LastUpdated = getDate()
											WHERE  Country     = '#nat#'
											AND    PostalCode  = '#Postal#'
									   	</cfquery>	
							
									<cfelse>
									
										<cftry>		
					
										<cfquery name="Insert"
											datasource="appsSystem" 
											username="#SESSION.login#" 
											password="#SESSION.dbpw#">		
											INSERT PostalCode
												(Country,
												 PostalCode,
												 Latitude,
												 Longitude,
												 Location,
												 OfficerUserId,
												 OfficerLastName,
												 OfficerFirstName)
											VALUES
												('#nat#',
												 '#postal#',
												 '#details.latitude#',
												 '#details.longitude#',
												 '#details.formatted_address#',
												 '#session.acc#',
												 '#session.last#',
												 '#session.first#')
										</cfquery>	
										
										<cfcatch></cfcatch>
										
										</cftry>
									
									</cfif>
									
									<cfif getbranchaddress.markercolor neq "" and  getbranchaddress.markericon neq "">
										
										<cfmapitem name="#unit#" 
								      	latitude="#details.latitude#" 
							          	longitude="#details.longitude#" 	   
									  	markericon="#session.root#/images/mapicons/#getbranchaddress.markercolor#_#getbranchaddress.markericon#.png"	
								      	tip="Branch : #getbranchaddress.OrgUnitName#"/>
										
									<cfelse>
									
										<cfmapitem name="#unit#" 
								      	latitude="#details.latitude#" 
							          	longitude="#details.longitude#" 	   
									  	markercolor="#getbranchaddress.markercolor#"	
								      	tip="Branch : #getbranchaddress.OrgUnitName#"/>								
										
									</cfif>		  	
								
															
								</cfif>		
								
							</cfif>	
											
						</cfif>	
										
					</cfloop>			
					
					<cfset color_list    = ArrayNew(1)>
					<cfset color_list[1]  = "Blue">
					<cfset color_list[2]  = "Green">
					<cfset color_list[3]  = "Red">			
					<cfset color_list[4]  = "Yellow">
					<cfset color_list[5]  = "White">
					<cfset color_list[6]  = "Black">
					<cfset color_list[7]  = "LightBlue">
					<cfset color_list[8]  = "Orange">
					<cfset color_list[9]  = "Purple">
					<cfset current_color = 0>
					<cfset current_person = "">
																					
					<cfloop query="deliveries">		
								
						<cfset postal = replaceNoCase(PostalCode," ","","ALL")>	
						<cfset postal = replaceNoCase(postal,"'","","ALL")>
						<cfset postal = replaceNoCase(postal,"`","","ALL")> 
						<cfset postal = replaceNoCase(postal,"-","","ALL")>
								
						<cfparam name="form.color_#orgunitowner#" default="FFFF00">
						
						<cfset color = evaluate("form.color_#orgunitowner#")>
						
						<cfset application.colorunit[orgunitowner] = evaluate("form.color_#orgunitowner#")>
								
						<cfquery name="Check"
						datasource="appsSystem" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">		
							SELECT *
							FROM   PostalCode
							WHERE  Country    = '#nat#'
							AND    PostalCode = '#Postal#'
					   	</cfquery>	
										
						<cfset showmarker = "0">	
						
						<cfif len(Coordinates) gte "20">
						
							<cfset lat        = "">	
						    <cfset lon        = "">	
							
							<cfset showmarker = "1">	
							
							<cfloop index="itm" list="#Coordinates#">
							
								<cfif lat eq "">
									<cfset lat = itm>
								<cfelse>
									<cfset lon = itm>
								</cfif>
							
							</cfloop>		
												
																	
						<cfelseif Check.recordcount eq "1" 
						       AND check.Latitude  neq "0" 
							   AND check.Longitude neq "0">		
							   				   						
								<cfset showmarker = "1">						
								<cfset lat        = check.latitude>	
							    <cfset lon        = check.longitude>					
						
						<cfelse>
						
							<!--- not found or invalid latitude, so we obtain --->
						
							<cfset vInit = GetTickCount()>
														
							<cfinvoke component="service.maps.googlegeocoder3" method="googlegeocoder3" returnvariable="details">	  
							  <cfinvokeargument name="address" value="The Netherlands, #replace(PostalCode,' ','','ALL')#">
							  <cfinvokeargument name="ShowDetails" value="false">
						    </cfinvoke>		
							
							<!--- valid the coordinates based on the country NET --->
																										
							<cfif (
									(left(details.latitude,1) eq "4" or left(details.latitude,1) eq "5" )
									and 
									(left(details.longitude,2) eq "3." or left(details.longitude,2) eq "4." or left(details.longitude,2) eq "5." or left(details.longitude,2) eq "6." )
								)>											 
								
								<cfif check.recordcount eq "1">
														
									<cfquery name="Update"
									datasource="appsSystem" 
									username="#SESSION.login#" 
									password="#SESSION.dbpw#">		
										UPDATE PostalCode	
										SET    Latitude    = '#details.latitude#',
										       Longitude   = '#details.longitude#',
											   Location    = '#details.formatted_address#',
											   LastUpdated = getDate()
										WHERE  Country     = '#nat#'
										AND    PostalCode  = '#Postal#'
								   	</cfquery>	
							
								<cfelse>
								
								    <cftry>
								
									<cfquery name="Insert"
									datasource="appsSystem" 
									username="#SESSION.login#" 
									password="#SESSION.dbpw#">		
									INSERT PostalCode
										(Country,PostalCode,latitude,longitude,Location,OfficerUserId,OfficerLastName,OfficerFirstName)
									VALUES
										('#nat#',
										 '#postal#',
										 '#details.latitude#',
										 '#details.longitude#',
										 '#details.formatted_address#',
										 '#session.acc#',
										 '#session.last#',
										 '#session.first#')
								    </cfquery>	
									
									<cfcatch></cfcatch>								
									
									</cftry>
								
								</cfif>						
								
								<cfset showmarker = "1">						
								<cfset lat        = details.latitude>	
							    <cfset lon        = details.longitude>	
															
							<cfelse>
							
									<cfset vInit = GetTickCount()>
									
									<cfinvoke component="service.maps.googlegeocoder3" method="googlegeocoder3" returnvariable="details">	  
										   <cfinvokeargument name="address" value="The Netherlands,#city# #address#">
										   <cfinvokeargument name="ShowDetails" value="false">
								    </cfinvoke>		
									
									<cfif Details.recordcount eq "1"  
									  AND (Check.latitude eq -1 and Check.Longitude eq -1) or (Check.latitude eq 0 and Check.Longitude eq 0)>
									
									<!--- if no valid postal code we no longer also store this in the table 						
																
									<cfquery name="Insert"
										datasource="appsWorkOrder" 
										username="#SESSION.login#" 
										password="#SESSION.dbpw#">		
										INSERT stPostalCode (PostalCode,latitude,longitude,Address)
										VALUES
											   ('#PostalCode#','#details.latitude#','#details.longitude#','#details.formatted_address#')
									</cfquery>	
									
									--->	
									
									<cfset showmarker = "1">						
									<cfset lat        = details.latitude>	
								    <cfset lon        = details.longitude>	
									
									<cfelse>
									
									<cfset showmarker = "0">	
																
									</cfif>
															
							</cfif>	
							
						</cfif>	
						
						<cfif showmarker eq "1">	
										
						    <cfif actual eq "1">
					
								<cfset vIcon = "Icons/Delivered.png">
		
								<cfmapitem name="#workorderlineid#" 
									    latitude="#lat#" 
									    longitude="#lon#" 	   
										markericon="#icon#"						
									    tip="#CustomerName# #Postalcode#"/>		
								
							<cfelseif Icon neq "">					
								
								
								<cfif deliveries.personNo neq current_person>
									<cfset current_person = "#deliveries.PersonNo#">
									<cfset current_color = current_color + 1>
								</cfif>						
								
								<cfswitch expression="#color#">						
								
									<cfcase value="000000">
										<cfset vIcon = "Icons/Black.png">
									</cfcase>							
									
									<cfcase value="FF8040">
										<cfset vIcon = "Icons/Orange.png">
									</cfcase>	
														
									<cfcase value="FFFF00">
																
										<!--- Color overwrite--->
										<cfif current_color lte arrayLen(color_list)>
											<cfset vIcon = "Icons/Composed/#color_list[current_color]#/#icon#.png">	
										<cfelse>
											<cfset vIcon = "Icons/Composed/Yellow/#icon#.png">
										</cfif>									
										
									</cfcase>
									
									<cfcase value="FF0000">
									    <cfset vIcon = "Icons/Red.png">
									</cfcase>
									
									<cfcase value="008000">
										<cfset vIcon = "Icons/Green.png">
									</cfcase>
									
									<cfcase value="FFFFFF">
										<cfset vIcon = "Icons/white.png">
									</cfcase>
									
									<cfcase value="0000FF">
										<cfset vIcon = "Icons/Blue.png">
									</cfcase>
												
								</cfswitch>
								
								<!--- workplan --->			
								
								<cftry>		
																																								
								<cfmapitem name="#workorderlineid#" 
								    latitude="#lat#" 
								    longitude="#lon#" 																			 
									markericon="#vIcon#"						
								    tip="#CustomerName# #Postalcode# #schedule# : #OrgUnitOwnerName# #current_color#"/>			
									
										
									<cfcatch>
									
									</cfcatch>
									
								</cftry>					
							
							<cfelse>
							
								<!--- workorder --->
								
								<cftry>
																			
								<cfmapitem name="#workorderlineid#" 
								    latitude="#lat#" 
								    longitude="#lon#" 	   
									markercolor="#color#"						
								    tip="#CustomerName# #Postalcode# #schedule# : #OrgUnitOwnerName#"/>	
									
									<cfcatch>
									
									</cfcatch>
									
								</cftry>	
									
										
							</cfif>			
								
						</cfif>		
					
					</cfloop>	
														
		   </cfmap>
		     
			</td></tr>
			</table>
		
		</td>
		</tr>
	</table>

<script>
	Prosis.busy('no')
</script>	