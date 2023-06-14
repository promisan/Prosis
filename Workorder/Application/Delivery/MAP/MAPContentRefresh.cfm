
<cftry>

<cfparam name="url.mode" default="delivery">
<cfparam name="workactionids" default="">

<cfset vInitTotal = GetTickCount()>
<cfset vInitDate = now()>

<cfset vInit = GetTickCount()>

<cfif url.mode eq "delivery">
	
	<cfinclude template="../getTreeData.cfm">
			
<cfelseif url.mode eq "workplan">
	
		<cfset dateValue = "">
		<CF_DateConvert Value="#url.dts#">
		<cfset DTS = dateValue>

		<cfquery name="Actor"
			datasource="appsEmployee" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">						
			
			SELECT     PA.PositionNo, 
					   PA.OrgUnit,	
			           PA.FunctionNo, 
					   PA.FunctionDescription, 
					   P.PersonNo, 
					   P.LastName, 
					   P.FirstName, 
					   PA.DateEffective, 
					   PA.DateExpiration
					   
			FROM       Person AS P INNER JOIN
                       PersonAssignment AS PA ON P.PersonNo = PA.PersonNo INNER JOIN
	                   Position AS Pos ON PA.PositionNo = Pos.PositionNo
			WHERE      PA.DateEffective  <= #dts#
			AND        PA.DateExpiration >= #dts#
			AND        PA.AssignmentStatus IN ('0', '1') 
			AND        Pos.Mission       = '#url.mission#' 
			AND        Pos.PositionNo    = '#url.PositionNo#'
		</cfquery>			

		<cfset person = actor.personno>
		<cfset units  = ""> <!--- all --->
		
</cfif>	

<cfquery name="getCountry"
	datasource="appsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">		
	SELECT    *
	FROM      Ref_Mission
	WHERE     Mission = '#url.mission#'		
</cfquery>

<cfset nat = getCountry.CountryCode>

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
				 C.Coordinates,		 
		         C.CustomerName,					 
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

									
<cfif person eq "" and unitchecked neq "">	
			
<cfelseif person eq "">
			
	<cfset unitchecked = ValueList(Branch.OrgUnit)>
			
	<!--- we take the units --->
							
<cfelse>	
					
	<!--- the units as relevant for this driver --->
	
	<cfquery name="getBranch" 
	     dbtype="query">
		 	SELECT DISTINCT OrgUnitOwner
			FROM  Deliveries
	</cfquery>	
	
	<cfset unitchecked = ValueList(getBranch.OrgUnitOwner)>	
			
</cfif>

<cfoutput>
				     

<cfloop index="unit" list="#unitchecked#">
			
    <!--- note we can tune this queries to make just one main query and then loop through this --->
											
		<cfquery name="getBranchAddress"
			datasource="appsWorkOrder" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">			
			 SELECT  City,Address1,PostalCode,MarkerColor,MarkerIcon,OrgUnitName
			 FROM    Organization.dbo.Organization O, 
			         Organization.dbo.vwOrganizationAddress A
			 WHERE   O.OrgUnit   = A.OrgUnit
			 AND     O.OrgUnit   = '#unit#'
			 AND     AddressType = 'Office'			 
		 </cfquery>
		
		<cfquery name="qChildren" dbtype="query">
			SELECT *
		    FROM   Deliveries
			WHERE  OrgUnitOwner = '#unit#'
		</cfquery>		
		
		<cfsavecontent variable="jRelated">[<cfloop query="qChildren">{"name":"#qChildren.WorkOrderLineId#"},</cfloop>{}]</cfsavecontent>
		 
				
		<cfif getBranchAddress.markercolor neq "">
						
			<cfif getbranchaddress.postalcode neq "">
									
			    <cfset postal = replaceNoCase(getbranchaddress.PostalCode," ","","ALL")>
				<cfset postal = replaceNoCase(postal,"'","","ALL")>
				<cfset postal = replaceNoCase(postal,"`","","ALL")> 
				<cfset postal = replaceNoCase(postal,"-","","ALL")>
					 
				<cfquery name="Check"
					datasource="appsSystem" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">		
						SELECT *
						FROM   PostalCode
						WHERE  Country    = '#nat#'
						AND    PostalCode = '#postal#' 
				</cfquery>		
																					
				<cfif check.recordcount eq "0">		
				
					<cfset vInit = GetTickCount()>
									
					<cfinvoke component="service.maps.googlegeocoder3" method="googlegeocoder3" returnvariable="details">	
					  
					  <cfif getbranchaddress.postalcode neq "">
					       <cfinvokeargument name="address" value="The Netherlands, #getbranchaddress.postalcode#">
					  <cfelse>
					       <cfinvokeargument name="address" value="The Netherlands, #getbranchaddress.city# #getbranchaddress.address1#">
					  </cfif>
					  <cfinvokeargument name="ShowDetails" value="false">
					  
				    </cfinvoke>
					
					<cfquery name="Insert"
						datasource="appsSystem" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">		
						INSERT PostalCode
								(Country,
								 PostalCode,
								 Latitude,
								 Longitude,
								 Location)
						VALUES
								('#nat#',
								 '#postal#',
								 '#details.latitude#',
								 '#details.longitude#',
								 '#details.formatted_address#')
					</cfquery>	
										
					<cfset vLatitude = details.latitude>
					<cfset vLongitude = details.longitude>					
					 											
					<cfif getbranchaddress.markercolor neq "" and  getbranchaddress.markericon neq "">
										
						<cf_addMarker name="#unit#" 
									  latitude="#details.latitude#"
									  longitude="#details.longitude#"
						  			  title="Branch : #getbranchaddress.OrgUnitName#"
									  markericon="#session.root#/images/mapicons/#getbranchaddress.markercolor#_#getbranchaddress.markericon#.png"
									  related="#jRelated#">
											
					<cfelse>
															
						<cf_addMarker name="#unit#" 
									  latitude="#details.latitude#"
									  longitude="#details.longitude#"
						  			  title="Branch : #getbranchaddress.OrgUnitName#"
									  markercolor="#getbranchaddress.markercolor#"
									  related="#jRelated#">						
					   																	
					</cfif>		  	
												
				<cfelse>		
								
					<cfset vLatitude = check.latitude>
					<cfset vLongitude = check.longitude>						
				
					<cfif getbranchaddress.markercolor neq "" and  getbranchaddress.markericon neq "">
							
						<cf_addMarker name="#unit#" 
									  latitude="#check.latitude#"
									  longitude="#check.longitude#"
						  			  title="Branch : #getbranchaddress.OrgUnitName#"
									  markericon="#session.root#/images/mapicons/#getbranchaddress.markercolor#_#getbranchaddress.markericon#.png"
									  related="#jRelated#">																							
							
					<cfelse>
					
						<cf_addMarker name="#unit#" 
									  latitude="#check.latitude#"
									  longitude="#check.longitude#"
						  			  title="Branch : #getbranchaddress.OrgUnitName#"
									  markercolor="#getbranchaddress.markercolor#"
									  related="#jRelated#">				
									  																			
					</cfif>		
											
				</cfif>		
				
			<cfelse>
			
				<cfset postal = "">			

			</cfif>						
								
		</cfif>	
		
		
</cfloop>

</cfoutput>
			
<cfset color_list     = ArrayNew(1)>
<cfset color_list[1]  = "Blue">
<cfset color_list[2]  = "Green">
<cfset color_list[3]  = "Red">			
<cfset color_list[4]  = "Yellow">
<cfset color_list[5]  = "White">
<cfset color_list[6]  = "Black">
<cfset color_list[7]  = "LightBlue">
<cfset color_list[8]  = "Orange">
<cfset color_list[9]  = "Purple">

<cfset current_color  = 0>
<cfset current_person = 0>
													
<cfloop query="deliveries">

	<cfparam name="form.color_#orgunitowner#" default="FFFF00">
	
	<cfset color = evaluate("form.color_#orgunitowner#")>
	
	<cfset application.colorunit[orgunitowner] = evaluate("form.color_#orgunitowner#")>
	
	<cfset postal = replaceNoCase(PostalCode," ","","ALL")>	
	<cfset postal = replaceNoCase(postal,"'","","ALL")>
	<cfset postal = replaceNoCase(postal,"`","","ALL")> 
	<cfset postal = replaceNoCase(postal,"-","","ALL")>
						
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
		
	<cfelseif Check.recordcount eq "1">						
	
	    	<cfif 
			(
				(left(check.latitude,1) eq "4" or left(check.latitude,1) eq "5" )
				and 
				(left(check.longitude,2) eq "3."  or left(check.longitude,2) eq "4." or left(check.longitude,2) eq "5." or left(check.longitude,2) eq "6.")
			)>		
			
				<cfset showmarker = "1">						
				<cfset lat        = check.latitude>	
			    <cfset lon        = check.longitude>	
			
			</cfif>					
	
	<cfelse>
	
		<cfset vInit = GetTickCount()>
									
		<cfinvoke component="service.maps.googlegeocoder3" method="googlegeocoder3" returnvariable="details">	  
		  <cfinvokeargument name="address" value="The Netherlands, #replace(PostalCode,' ','','ALL')#">
		  <cfinvokeargument name="ShowDetails" value="false">
	    </cfinvoke>		
		
		<!--- check if this is indeed a dutch address --->
																					
		<cfif (
				(left(details.latitude,1) eq "4" or left(details.latitude,1) eq "5" )
				and 
				(left(check.longitude,2) eq "3." or left(details.longitude,2) eq "4." or left(details.longitude,2) eq "5." or left(details.longitude,2) eq "6." )
			)>
			
				<cfif check.recordcount eq "1">
						
					<cfquery name="Update"
					datasource="appsSystem" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">		
						UPDATE PostalCode	
						SET    latitude  = '#details.latitude#',
						       longitude = '#details.longitude#',
							   Location  = '#details.formatted_address#' 
						WHERE  Country    = '#nat#'
						AND    PostalCode = '#Postal#'
				   	</cfquery>	
			
				<cfelse>
				
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
				
				<cfset showmarker = "1">						
				<cfset lat        = details.latitude>	
			    <cfset lon        = details.longitude>	
														
		</cfif>	
		
	</cfif>	
	
	<cfif showmarker eq "1">	
					
	    <cfif actual eq "1">
						
			<cf_addMarker  
			      name="#workorderlineid#" 
				  latitude="#lat#"
				  longitude="#lon#"
				  title="#CustomerName# #Postalcode#"
				  markericon="Icons/Delivered.png">								
			
		<cfelseif Icon neq "">			
			
			<cfif deliveries.personNo neq current_person>
				<cfset current_person = deliveries.personNo>
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
						<cfset vIcon = "Icons/Composed/#color_list[current_color]#/#Icon#.png">	
					<cfelse>
						<cfset vIcon = "Icons/Composed/Yellow/#Icon#.png">
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
						
			<cf_addMarker 
			      name="#workorderlineid#" 
				  latitude="#lat#"
				  longitude="#lon#"
				  title="#CustomerName# #Postalcode# #schedule# : #OrgUnitOwnerName#"
				  markericon="#vIcon#">					
					
		<cfelse>
					
			<cf_addMarker  
			      name="#workorderlineid#" 
				  latitude="#lat#"
				  longitude="#lon#"
				  title="#CustomerName# #Postalcode# #schedule# : #OrgUnitOwnerName#"
				  markercolor="#color#">					
					
		</cfif>			
			
	</cfif>		
	

</cfloop>	

<cfcatch></cfcatch>

</cftry>

<script>   
	try { Prosis.busy('no') } catch(e) {}
</script>
