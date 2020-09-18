

<cfquery name="Zone"
		datasource="appsEmployee" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">				   
		SELECT    *
	    FROM      Ref_AddressZone
		WHERE     Code = '#URL.Zone#'				
</cfquery>	

<cfquery name="Listing"
		datasource="appsEmployee" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">			
	   
		SELECT    P.PersonNo, 
		          P.IndexNo, 
				  P.LastName, 
				  P.FirstName, 
				  P.Gender, 
				  P.Nationality, 
				  A.Address, 
				  A.AddressCity, 
				  A.AddressPostalCode, 
				  A.Country, 
				  A.EMailAddress, 
				  A.Contact, 
				  A.ContactRelationship, 
				  A.ActionStatus,
				  A.Coordinates,
				  A.AddressId
	    FROM      vwPersonAddress A INNER JOIN
	              Person P ON A.PersonNo = P.PersonNo
		WHERE     AddressZone = '#URL.Zone#'
		
		<!--- on board --->
		AND       A.PersonNo IN (SELECT Personno 
		                       FROM PersonAssignment 
							   WHERE AssignmentStatus IN ('1','0')
							   AND   (DateEffective <= getDate() and DateExpiration >= getDate())
							   AND   PositionNo IN (SELECT PositionNo FROM Position WHERE MissionOperational = '#url.mission#'))
		
		<cfif url.addresstype neq "">
		  AND     AddressType = '#url.addresstype#'
		</cfif>		  
			
		<cfif url.filter eq "active">	
		  AND      (DateEffective <= getDate() or DateEffective is NULL) AND (DateExpiration > getDate() or DateExpiration is NULL)	 	 
		</cfif>  
		
</cfquery>	

<!--- central point for the zone --->
	
<cfinvoke component="service.maps.googlegeocoder3" method="googlegeocoder3" returnvariable="details">	  
	  <cfinvokeargument name="address" value="">
	  <cfinvokeargument name="ShowDetails" value="false">
</cfinvoke>	

<table width="100%" align="center" height="100%"><tr><td align="center">

<cfset url.height = url.height - 15>
<cfset url.width  = url.width - 15>
					
		<cfmap name="gmap"
	     centerlatitude="#Zone.centerLatitude#" 
	     centerlongitude="#Zone.centerlongitude#" 	 	
	     doubleclickzoom="true" 
		 collapsible="false" 			
	     overview="true" 
		 initshow="true"		
		 height="#url.height+8#"
		 width="#url.width+8#"
		 typecontrol="advanced" 		
		 hideborder="true"
	     scrollwheelzoom="true" 
	 	 showmarkerwindow="true"
		 showcentermarker="true"
	     showscale="true"
		 markerbind="url:#SESSION.root#/Attendance/Application/Address/AddressMAPDetail.cfm?cfmapname={cfmapname}&cfmapaddress={cfmapaddress}" 
	     tip="Warden Support"
		 zoomcontrol="large3d" 
	     zoomlevel="11"> 	
												
		<cfloop query="Listing">		
		
			<cfif coordinates neq "">
			
			     <cfset lat = "">
				 <cfset lng = "">
					 		 
				 <cfloop index="itm" list="#coordinates#">
				 
				   <cfif lat eq "">
					   <cfset lat = itm>
				   <cfelse>
					   <cfset lng = itm>
				   </cfif>
				 
				 </cfloop>
			
				<cfif lat neq "" and lng neq "">
				
					<cfmapitem name="#addressid#" 
					    latitude="#lat#" 
					    longitude="#lng#" 	   
						markercolor="FFFF00"						
					    tip="#FirstName# #LastName#"/>		
							
				</cfif>		
								
			<cfelseif Country neq "" and Address neq "" and AddressCity neq "">
			
					<cfquery name="getCountry"
					datasource="appsSystem" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">		
						SELECT * FROM Ref_Nation	
						WHERE  Code = '#country#'																											
				   	</cfquery>	
			
					<cfinvoke component="service.maps.googlegeocoder3" method="googlegeocoder3" returnvariable="details">	
					
						<cfif len(addresspostalcode) gte 4>							
							<cfinvokeargument name="address" value="#getCountry.Name#, #addresspostalcode#">
						<cfelse>
						    <cfinvokeargument name="address" value="#getCountry.Name#, #addresscity# #address#">
						</cfif>
						<cfinvokeargument name="ShowDetails" value="false">
					
					</cfinvoke>	
										
					<cfif isvalid("float",details.latitude)>
															
					<cfquery name="Update"
					datasource="appsSystem" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">		
						UPDATE Ref_Address	
						SET    Coordinates = '#details.latitude#,#details.longitude#'											
						WHERE  AddressId   = '#addressid#'											
				   	</cfquery>	
					
					<cfmapitem name="#addressid#" 
					    latitude="#details.latitude#" 
					    longitude="#details.longitude#" 	   
						markercolor="FFFF00"						
					    tip="#FirstName# #LastName#"/>		
						
					</cfif>						
			
			</cfif>							
					
		</cfloop>	
									
</cfmap>


</td></tr>

<tr><td></td></tr>

</table>