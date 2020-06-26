
<cfparam name="url.script"        default="0">
<cfparam name="url.operational"   default="1">
<cfparam name="url.domain"        default="">
<cfparam name="url.status"        default="0">
<cfparam name="url.workorderid"   default="">
<cfparam name="url.requesttype"   default="">
<cfparam name="url.workorderline" default="">

<cfif url.script eq "1">

    <cf_screentop jquery="Yes" html="No">
    <cfajaximport>
    <cf_listingscript>
	<cf_dialogWorkorder>
</cfif>

<cfif url.workorderid neq "">
	
	<cfquery name="WorkOrder" 
	datasource="AppsWorkOrder" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		 SELECT  *	
	     FROM    WorkOrder
		 WHERE   WorkOrderId = '#url.workorderid#'	
	</cfquery>	
	
	<cfquery name="ServiceItem" 
	datasource="AppsWorkOrder" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	 SELECT  *	
     FROM    ServiceItem
	 WHERE   Code   = '#workorder.serviceitem#'	
	</cfquery>
	
	<cfquery name="WorkOrderLine" 
	datasource="AppsWorkOrder" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		 SELECT  *	
	     FROM    WorkOrderLine
		 WHERE   WorkOrderId   = '#url.workorderid#'	
		 AND     WorkorderLine = '#url.workorderline#'
	</cfquery>
	
	<cfset url.domain      = serviceitem.servicedomain>
	<cfset url.mission     = workorder.mission>
	<cfset url.serviceitem = workorder.serviceitem>

</cfif>

<cfquery name="Parameter" 
datasource="AppsWorkOrder" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	 SELECT  *	
     FROM    Ref_ParameterMission
	 WHERE   Mission  = '#url.mission#'	
</cfquery>

<cfquery name="Domain" 
datasource="AppsWorkOrder" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	 SELECT  *	
     FROM    Ref_ServiceItemDomain
	 WHERE   Code   = '#url.domain#'	
</cfquery>
   
<!--- limit access if the role of ServiceRequester and limit access if role is WorkOrderProcessor --->

<cfoutput>
<cfsavecontent variable="myquery">	

   SELECT  TOP 2000 R.Requestid,
           R.Reference, 
           R.OrgUnit, 
		   R.DateEffective,
		   R.DateExpiration,
		   (SELECT OrgUnitNameShort FROM Organization.dbo.Organization WHERE OrgUnit = R.OrgUnit) as OrgUnitName,				   
		   (SELECT PersonNo FROM Employee.dbo.Person WHERE PersonNo = R.PersonNo) as PersonNo,
		   (SELECT IndexNo FROM Employee.dbo.Person WHERE PersonNo = R.PersonNo) as IndexNo,
		   (SELECT FirstName+' '+LastName FROM Employee.dbo.Person WHERE PersonNo = R.PersonNo) as Name,
			
		   (SELECT TOP 1 Reference 
			 FROM   WorkOrderLine W, RequestWorkorder RO
			 WHERE  W.WorkorderId = RO.WorkorderId
			 AND    W.WorkOrderLine = RO.WorkOrderLine 
			 AND    RO.Requestid = R.Requestid) as Id,		
		
		   R.RequestType, 
		   R.RequestDate,
		   S.Description, 
		   (SELECT StatusDescription
		    FROM   Organization.dbo.Ref_EntityStatus 
			WHERE  EntityCode = 'WrkRequest'
		    AND    EntityStatus = R.ActionStatus) as ActionStatus,		   
		   ES.StatusDescription, 
		   W.RequestActionName,		   
		   R.Created
		   
    FROM   Request AS R 
	       INNER JOIN Ref_Request AS S ON R.RequestType = S.Code 
		   INNER JOIN Ref_RequestWorkFlow AS W ON R.RequestType = W.RequestType AND R.ServiceDomain = W.ServiceDomain AND R.RequestAction = W.RequestAction 
		   INNER JOIN Organization.dbo.Ref_EntityStatus ES ON ES.EntityCode = 'WrkRequest' AND ES.EntityStatus = R.ActionStatus
			
	WHERE  1=1
	
	<cfif url.workorderid eq "">
	
	AND    R.Mission      = '#url.mission#'
	AND    R.ActionStatus = '#url.status#' 
	
	<cfelse>
	
	AND   R.RequestId IN (SELECT RequestId 
	                      FROM   RequestWorkOrder RS, Workorder WS, WorkOrderLine WL
						  WHERE  RS.WorkOrderId   = WL.WorkOrderId
						  AND    RS.WorkorderLine = WL.WorkOrderLine
						  AND    WL.Reference     = '#workorderline.reference#'
						  AND    RS.Workorderid   = WS.WorkorderId
						  AND    WS.Serviceitem IN (SELECT Code 
						                            FROM   Serviceitem 
													WHERE  ServiceDomain = '#url.domain#') 
									   
						 )		
						 
	</cfif>		
		
	<cfif getAdministrator(url.mission) eq "1">
	
		<!--- no filtering --->
		
	<cfelse>
				
		AND  ( 
		
			     <!--- requester if he has access to that request unit as requester --->
			
				 R.OrgUnit IN (SELECT OrgUnit 
		                       FROM   Organization.dbo.OrganizationAuthorization 
							   WHERE  UserAccount = '#SESSION.acc#'
							   AND    Role = 'ServiceRequester'
							  )
							 
				OR 
				
				<!--- processor if user has access to that service item for the mission --->
				
				R.RequestId IN (
				                SELECT RequestId 
	                       		FROM   RequestLine 
								WHERE  ServiceItem IN (
								                      SELECT ClassParameter
									                  FROM   Organization.dbo.OrganizationAuthorization
											          WHERE  UserAccount = '#SESSION.acc#'
													  AND    Role        = 'WorkOrderProcessor'
													  AND    Mission     = '#url.mission#'
													 )
								UNION
								
								SELECT RequestId 
	                       		FROM   RequestWorkOrderDetail
								WHERE  Amendment = 'ServiceItem' 
								AND    ValueFrom IN (
								                      SELECT ClassParameter
									                  FROM   Organization.dbo.OrganizationAuthorization
											          WHERE  UserAccount = '#SESSION.acc#'
													  AND    Role        = 'WorkOrderProcessor'
													  AND    Mission     = '#url.mission#'
													 )								
													 
							   )
			  )				 
						
	</cfif>			 
						 
	<cfif url.domain neq "">
	
	AND    R.RequestId IN (
	                       SELECT RequestId 
	                       FROM   RequestLine 
						   WHERE  ServiceItem IN (SELECT Code 
						                          FROM   ServiceItem 
												  WHERE  ServiceDomain = '#url.domain#')
																					
						   UNION
								
						   SELECT RequestId 
	                       FROM   RequestWorkOrderDetail
						   WHERE  Amendment = 'Serviceitem' 	
						   AND    ValueFrom IN (SELECT Code 
						                        FROM   ServiceItem 
												WHERE  ServiceDomain = '#url.domain#')				  
												  
						)	
	</cfif>		
	
	<cfif url.requesttype neq "">
	AND    R.RequestType = '#url.requesttype#'	
	</cfif>				
		
						
</cfsavecontent>

</cfoutput>


<cfset itm = 0>

<cfset fields=ArrayNew(1)>

<cfset itm = itm + 1>			
<cf_tl id="RFS No" var="vRFS">
<cfset fields[itm] = {label      = "#vRFS#",
					  field      = "Reference",																
					  search     = "text"}>		
	
<cfset itm = itm + 1>		
<cf_tl id="Request Type" var="vRequest">
<cfset fields[itm] = {label      = "#vRequest#", 					
					  field      = "Description",	
					  filtermode = "2",												
					  search     = "text"}>		
					  

<cfset itm = itm + 1>			
<cf_tl id="Action" var="vAction">
<cfset fields[itm] = {label      = "#vAction#", 					
					  field      = "RequestActionName",	
					  filtermode = "2",												
					  search     = "text"}>							  	

<!---					  
<cfif url.workorderid eq "">		  
	
	<cfset itm = itm + 1>						
	<cfset fields[itm] = {label   = "#Domain.Description#", 					
						  field   = "Id",	
						  search  = ""}>	

</cfif>		
--->
			  				
<cfset itm = itm + 1>
<cf_tl id="Stage" var="vStage">
<cfset fields[itm] = {label       = "#vStage#",                    
     				  field       = "ActionStatus",
					  align       = "center",
					  filtermode  = "2",		
					  search      = "text"}>		

				  				
<cfset itm = itm + 1>
<cf_tl id="Effective" var="vEffective">
<cfset fields[itm] = {label       = "#vEffective#",                    
     				  field       = "DateEffective",
					  formatted   = "dateformat(dateeffective,CLIENT.DateFormatShow)",												
					  search      = "date"}>		
					  
<cfset itm = itm + 1>
<cf_tl id="Expiry" var="vExpiry">
<cfset fields[itm] = {label       = "#vExpiry#",                    
     				  field       = "DateExpiration",
					  formatted   = "dateformat(dateexpiration,CLIENT.DateFormatShow)",												
					  search      = "date"}>								  						  						  
								  					  				  					  				  
					
<cfset itm = itm + 1>
<cf_tl id="Unit" var="vUnit">
<cfset fields[itm] = {label       = "#vUnit#",                    
     				  field       = "OrgUnitName",						
					  search      = "text"}>							
					
<cfset itm = itm+1>		
<cf_tl id="Requester" var="vRequester">					
<cfset fields[itm] = {label       = "#vRequester#",                    
					  field       = "Name", 													
					  search      = "text"}>	
					  
<cfset itm = itm+1>
<cf_tl id="Date" var="vDate">
<cfset fields[itm] = {label       = "#vDate#",                   		
					  field       = "RequestDate",		
					  align       = "center",			
					  alias       = "R",	
					  formatted   = "dateformat(created,CLIENT.DateFormatShow)",												
					  search      = "date"}>						  

					  <!---
<cfset itm = itm+1>
<cfset fields[itm] = {label       = "Time",                   		
					  field       = "Created",		
					  align       = "center",			
					  alias       = "R",	
					  formatted   = "timeformat(created,'HH:MM')"}>			
					  --->					  								  			

<cfset itm = itm + 1>			
<cf_tl id="RequestId" var="vRequestId">			
<cfset fields[itm] = {label      = "#vRequestId#", 					
					  field      = "RequestId",											
					  display    = "No",
					  search     = ""}>							  				  									

										
<cfset menu=ArrayNew(1)>	

<!--- define access --->

<cfinvoke component = "Service.Access"  
   method           = "ServiceRequester" 
   mission          = "#Parameter.TreeCustomer#"  
   returnvariable   = "access">	
   
<!--- check if this line has children then entry is not allowed --->

<cfif url.workorderid eq "">

	<cfif access eq "EDIT" or access eq "ALL">		
		<cf_tl id="Add Request" var="vAdd">
		<cfset menu[1] = {label = "#vAdd#", icon = "add.png",	script = "addworkorderrequest('#url.mission#','#url.domain#','#url.status#','#url.workorderid#','#url.workorderline#')"}>				 		
	</cfif>		

<cfelse>

	<cfquery name="get" 
		datasource="AppsWorkOrder" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">	
		SELECT   *
	     FROM    WorkOrderLine 		 
		 WHERE   WorkOrderId   = '#url.workorderid#'
		 AND     WorkorderLine = '#url.workorderline#'					 
	</cfquery>

	 <cfquery name="Expiration" 
		datasource="AppsWorkOrder" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">	
		SELECT   *
	     FROM    WorkOrderLine 		 
		 WHERE   WorkOrderId   = '#url.workorderid#'
		 AND     WorkorderLine = '#url.workorderline#'			
		 AND     DateExpiration <= getDate()		 
	</cfquery>
					
	 <cfquery name="Children" 
		datasource="AppsWorkOrder" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
	
		SELECT   WO.*, 
		         P.IndexNo AS IndexNo, 
				 P.LastName AS LastName, 
				 P.FirstName AS FirstName,
				 P.Nationality,
				 P.Gender				
				 
	     FROM    WorkOrderLine WO LEFT OUTER JOIN
		         Employee.dbo.Person P ON WO.PersonNo = P.PersonNo				 
		 WHERE   WO.ParentWorkOrderId   = '#url.workorderid#'
		 AND     WO.ParentWorkorderLine = '#url.workorderline#'			
	</cfquery>

	<cfif children.recordcount eq "0" and Expiration.recordcount eq "0" and get.Operational eq "1">
			  			
		<cfif access eq "EDIT" or access eq "ALL">		
			<cf_tl id="Add New Request" var="vAdd">
			<cfset menu[1] = {label = "#vAdd#", icon = "add.png",	script = "addworkorderrequest('#url.mission#','#url.domain#','#url.status#','#url.workorderid#','#url.workorderline#')"}>				 		
		</cfif>
		
	<cfelse>
	
		<!--- if there are children do not allow for enterung a request --->	
		<cfset menu = "">			
		
	</cfif>
	
</cfif>		

<cfif url.workorderid eq "">
	<cfset sh = "show">
<cfelse>
    <cfset sh = "hide">
</cfif>
									
<cf_listing
	    header        = "requestlinelist"
	    box           = "requestlinelistdetail"
		link          = "#SESSION.root#/WorkOrder/Application/Request/Listing/RequestListing.cfm?mission=#url.mission#&domain=#url.domain#&status=#url.status#&requesttype=#url.requesttype#&workorderid=#url.workorderid#&workorderline=#url.workorderline#"
	    html          = "No"		
		tableheight   = "100%"
		tablewidth    = "100%"
		datasource    = "AppsWorkOrder"
		listquery     = "#myquery#"
		listorderfield = "Created"
		listorder      = "Created"
		listorderalias = "R"
		listorderdir   = "DESC"
		headercolor   = "ffffff"
		show          = "40"		
		menu          = "#menu#"
		filtershow    = "#sh#"
		excelshow     = "Yes" 		
		listlayout    = "#fields#"
		drillmode     = "window" 
		annotation    = "wrkRequest"
		drillargument = "#client.height-130#;#client.width-100#;true;true"	
		drilltemplate = "WorkOrder/Application/Request/Request/Create/Document.cfm?drillid="
		drillkey      = "RequestId"
		drillbox      = "addworkorder">	
		