<!--
    Copyright © 2025 Promisan B.V.

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

        http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
-->
<cfparam name="url.mission"       default="">
<cfparam name="url.zone"          default="">
<cfparam name="url.addresstype"   default="">
<cfparam name="url.filter"        default="Active">

<cfquery name="Param" 
	datasource="AppsWorkOrder" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	 SELECT  *	
     FROM    Ref_ParameterMission
	 WHERE   Mission = '#url.mission#'	
</cfquery>

<cfinvoke component  = "Service.Access" 
	      method         = "RoleAccess"				  	
		  role           = "'LeaveClearer'"		
		  returnvariable = "manager">	

<cf_listingscript>

<cfsavecontent variable="myquery">

	<cfoutput>
	
	  SELECT *
	  FROM (
	   
		SELECT    P.PersonNo, 
		          P.IndexNo, 
				  P.LastName, 
				  P.FirstName, 
				  P.Gender, 
				  P.Nationality, 
				  N.Name as NationalityCountry,
				  A.Address, 
				  A.AddressCity, 
				  A.AddressPostalCode, 
				  A.Country, 
				  A.EMailAddress, 
				  A.Contact, 
				  A.Source,
				  A.ContactRelationship, 
				  A.ActionStatus,
				  A.AddressId
	    FROM      vwPersonAddress A INNER JOIN
	              Person P ON A.PersonNo = P.PersonNo INNER JOIN
				  System.dbo.Ref_Nation N ON P.Nationality = N.Code
		WHERE     AddressZone = '#URL.Zone#' 
		AND       (AddressCity != '' AND AddressCity is not NULL)
		
		AND       A.PersonNo IN (SELECT PersonNo 
		                         FROM   PersonAssignment 
							     WHERE  AssignmentStatus IN ('0','1')
							     AND    DateEffective  <= getDate() 
								 AND    DateExpiration >= getDate()
								 
								 <cfif manager eq "GRANTED">
		
									  <!--- full access --->
				
								<cfelse>
								 
								 AND  OrgUnit IN (SELECT A.OrgUnit
							                      FROM   Organization.dbo.OrganizationAuthorization A, 
		                  		                         Organization.dbo.Organization O
			   	                                  WHERE  A.UserAccount = '#SESSION.acc#' 
				                                  AND    A.Mission     = '#url.Mission#'
				                                  AND    O.OrgUnit     = A.OrgUnit
				                                  AND    O.Mission     = '#url.Mission#'		
				                                  AND    Role IN ('Timekeeper', 'HROfficer')
									             )		   
								 
								 </cfif>
								 
							     AND   PositionNo IN (SELECT PositionNo 
								                      FROM   Position 
													  WHERE  MissionOperational = '#url.mission#'))
		
		<cfif url.addresstype neq "">
		  AND     AddressType = '#url.addresstype#'
		</cfif>		  
	
		<cfif url.filter eq "active">	
		  AND      (DateEffective <= getDate() or DateExpiration is NULL) AND (DateExpiration > getDate() or DateExpiration is NULL)	 	 
		</cfif>  
		
		) as B
		WHERE 1=1
		-- condition
		
	</cfoutput>	
	
</cfsavecontent>

<cfset itm = 0>

<cfset fields=ArrayNew(1)>
	
	<cfset itm = itm+1>	
	<cfset fields[itm] = {label        = "IndexNo",                    
	     				field          = "IndexNo",											
						alias          = "",		
						functionscript = "EditPerson",
						functionfield  = "PersonNo",																			
						search         = "text"}>		

	<cfset itm = itm+1>		
	<cfset fields[itm] = {label        = "FirstName",                    
	     				field          = "FirstName",											
						alias          = "",																			
						search         = "text"}>				
							
	<cfset itm = itm+1>	
	<cfset fields[itm] = {label        = "LastName",                    
	     				field          = "LastName",					
						alias          = "",																			
						search         = "text"}>							
						
	<cfset itm = itm+1>	
	<cfset fields[itm] = {label        = "G",  
	                    labelfilter    = "Gender",                  
	     				field          = "Gender",					
						alias          = "",	
						filtermode     = "2",	
						align          = "center",																	
						search         = "text"}>							
					
	<cfset itm = itm+1>	
	<cfset fields[itm] = {label        = "Nat",   
	                    labelfilter    = "Nationality",                     
	     				field          = "NationalityCountry",					
						filtermode     = "2",
						alias          = "",																			
						search         = "text"}>																		
					

	<!---
	
	<cfset itm = itm+1>					
	
	<cfset fields[itm] = {label     = "Effective",                    
						field       = "DateEffective", 		
						formatted   = "dateformat(dateeffective,CLIENT.DateFormatShow)",		
						align       = "left",		
						search      = "date"}>		
						
	<cfset itm = itm+1>															
	<cfset fields[itm] = {label      = "Expiration", 					
						field      = "DateExpiration",	
						align       = "left",		
						formatted   = "dateformat(dateexpiration,CLIENT.DateFormatShow)",					
						search     = "date"}>	
						
	--->

				
	<cfset itm = itm+1>
	
	<cfset fields[itm] = {label     = "City",                    
	     				field       = "AddressCity",	
						filtermode     = "2",				
						alias       = "",																			
						search      = "text"}>	
						
	<cfset itm = itm+1>
	
	<!--- second row --->
	
	<cfset fields[itm] = {label     = "Address",                    
	     				field       = "Address",											
						alias       = "",																			
						search      = "text"}>						
						
			
	<cfset itm = itm+1>
	
	<cfset fields[itm] = {label     = "Type",                    
	     				field       = "ContactRelationship",	
						filtermode     = "2",				
						alias       = "",																			
						search      = "text"}>							
						
	
	<cfset itm = itm+1>
	
	<cfset fields[itm] = {label     = "Contact",                    
	     				field       = "Contact",					
						alias       = "",																			
						search      = "text"}>	
						
	
	<!---							
	<cfset itm = itm+1>
	
	<cfset fields[itm] = {label     = "eMail",                    
	     				field       = "eMailAddress",					
						display     = "No",
						alias       = "",																			
						search      = "text"}>	
						
						--->
						
	<cfset itm = itm+1>
	
	<cfset fields[itm] = {label     = "Source",                    
	     				field       = "Source",					
						display     = "No"}>																			
						
				
	<cfset itm = itm+1>
	
	<!--- hidden fields --->
	
	<cfset fields[itm] = {label     = "Contact",                    
	     				field       = "AddressId",					
						display     = "No",
						alias       = ""}>		
						
																																				
		
<cfset menu=ArrayNew(1)>	

<!---

<cfif url.workorderid neq "">
		
	<cfif filter eq "active">
		
		<!--- define access --->
		<cfinvoke component = "Service.Access"  
		   method           = "WorkorderProcessor" 
		   mission          = "#url.mission#"	  
		   serviceitem      = "#serviceitem.code#"
		   returnvariable   = "access">	
					
		<cfif access eq "EDIT" or access eq "ALL">		
														
				<cfset menu[1] = {label = "Add Line", icon = "insert.gif",	script = "lineadd('#url.workorderid#','0')"}>				 
				
		</cfif>						
	
	</cfif>

</cfif>

--->
	
<!--- embed|window|dialogajax|dialog|standard --->
							
<cf_listing
	    header              = "addresslist"
	    box                 = "address"
		link                = "#SESSION.root#/Attendance/Application/Address/AddressListingContent.cfm?systemfunctionid=#url.systemfunctionid#&filter=#url.filter#&mission=#url.mission#&zone=#url.zone#&addresstype=#url.addresstype#"
	    html                = "No"		
		tableheight         = "100%"
		tablewidth          = "100%"
		font                = "Verdana"
		datasource          = "AppsEmployee"
		listquery           = "#myquery#"		
		listorderfield      = "LastName"
		listorder           = "LastName"
		listorderdir        = "ASC"
		headercolor         = "ffffff"
		show                = "35"		
		menu                = "#menu#"
		filtershow          = "Yes"
		excelshow           = "Yes" 		
		listlayout          = "#fields#"
		drillmode           = "window" 
		drillargument       = "#client.height-80#;#client.width-70#;false;false"	
		drilltemplate       = "Staffing/Application/Employee/Address/AddressEdit.cfm?drillid="
		drillkey            = "AddressId"
		drillbox            = "addaddress">	