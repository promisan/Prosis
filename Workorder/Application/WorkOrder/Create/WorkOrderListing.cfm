<cfoutput>

<cfparam name="url.serviceclass" default="">
<cfparam name="url.height" default="full">

<cfquery name="Workflow" 
	datasource="AppsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">	
	SELECT    *
    FROM      Ref_EntityMission
    WHERE     EntityCode = 'WorkOrder'
    AND       Mission = '#URL.Mission#'										  
</cfquery>

<cfquery name="Param" 
	datasource="AppsWorkOrder" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		 SELECT  *	
	     FROM    Ref_ParameterMission
		 WHERE   Mission = '#url.mission#'	
</cfquery>

<!--- obtain the type of workorder to be shown here for this customer --->

<cfquery name="Customer" 
	datasource="AppsWorkOrder" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT    *
	FROM      Customer
    WHERE     CustomerId = '#url.CustomerId#'	
</cfquery>	

<cfquery name="Mode" 
	datasource="AppsWorkOrder" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT    TOP 1 S.ServiceMode
	FROM      WorkOrder W INNER JOIN
              ServiceItem S ON W.ServiceItem = S.Code
    WHERE     W.Mission = '#url.mission#'
	AND       W.CustomerId = '#url.CustomerId#'
	ORDER BY  W.Created DESC
</cfquery>	

<!--- define the totals on a line basis first --->

<cfsavecontent variable="myquery">

    SELECT * --,OrderDate
	FROM (

	SELECT     W.WorkOrderId,
	           W.Reference, 
			   C.Description as ClassDescription,
			   R.Description as ServiceDescription, 					 
			   W.OrderDate, 					  
			   O.OrgUnitName AS Owner, 			  
			   W.Created,
			   W.ActionStatus,
			   S.StatusDescription,
			   			
				<cfif Mode.ServiceMode eq "WorkOrder">
				
				   (SELECT count(*) 
				    FROM   WorkOrderLine 
					WHERE  WorkOrderId = W.WorkorderId								
					AND    Operational = 1) as Lines,
					
				   (SELECT ISNULL(sum(SaleAmountIncome),0) 
			    	FROM   WorkOrderLineItem 
					WHERE  WorkOrderId = W.WorkorderId	
					AND    ActionStatus != '9'				
					) as Amount,
					
			   
			    <cfelse>
				
					(SELECT   SUM(Amount) 
				    FROM     WorkorderBaseLine WB, WorkOrderBaseLineDetail WL
					WHERE    WB.TransactionId = WL.TransactionId
					AND      WB.TransactionId IN (SELECT TOP 1 TransactionId 
					                              FROM WorkorderBaseLine 
												  WHERE WorkOrderId = W.WorkorderId 
												  ORDER BY DateEffective DESC)
					AND      WorkOrderId = W.WorkorderId) as AgreementAmount,
					
				   (SELECT   TOP 1 TransactionReference 
				    FROM     WorkOrderBaseLine 
					WHERE    WorkOrderId = W.WorkorderId) as AgreementReference,	
				
				   (SELECT count(*) 
				    FROM   WorkOrderLine 
					WHERE  WorkOrderId = W.WorkorderId
					AND    DateEffective <= getDate() 
					AND    (DateExpiration >= getDate()	or DateExpiration is NULL) 					
					AND    Operational = 1) as Lines,
					
				   (SELECT sum(Amount) 
			    	FROM   skWorkOrderCharges 
					WHERE  WorkOrderId = W.WorkorderId
					AND    SelectionDate >= '01/01/#year(now())#' 
					AND    SelectionDate <= '12/31/#year(now())#'
					) as Amount,
					
				</cfif>					
										
			   CASE W.ActionStatus WHEN '3' THEN 'Completed' ELSE 'Pending' END as Status
			   
			   
	FROM       WorkOrder W INNER JOIN
	           ServiceItem R ON W.ServiceItem = R.Code INNER JOIN
			   ServiceItemClass C ON C.Code = R.ServiceClass 		   
			   LEFT OUTER JOIN
	           Organization.dbo.Organization O ON W.OrgUnitOwner = O.OrgUnit
			   LEFT OUTER JOIN
	           Organization.dbo.Ref_EntityStatus S ON S.EntityCode = 'WrkStatus' and EntityStatus = W.ActionStatus
	WHERE      W.Mission  = '#url.Mission#'
	AND        CustomerId = '#url.CustomerId#' 
	AND        R.Operational = 1
	
	<cfif getAdministrator(url.mission) eq "1">
	
			<!--- no filtering --->
						
	<cfelse>
	
							
				AND (
						W.ServiceItem IN (
						                SELECT ClassParameter
						                FROM   Organization.dbo.OrganizationAuthorization
									    WHERE  UserAccount = '#SESSION.acc#'
									    AND    Role = 'WorkOrderProcessor'
									   )	
									   
						OR 		
						
						 <!--- is a requester for this service item --->
							
						 W.ServiceItem IN (
						                SELECT ClassParameter
						                FROM   Organization.dbo.OrganizationAuthorization
									    WHERE  UserAccount = '#SESSION.acc#'
										AND    Mission = '#param.treecustomer#'
									    AND    Role = 'ServiceRequester'
									   )		   
					 )				    
							
		</cfif>
		
	<!---	
	
	<cfif getAdministrator(url.mission) eq "1">
	
			<!--- no filtering --->
						
	<cfelse>
	
	AND        W.Mission IN (SELECT Mission 
	                         FROM   Organization.dbo.OrganizationAuthorization
							 WHERE  UserAccount = '#SESSION.acc#' 
							 AND    Role IN ('WorkOrderProcessor')	
							 AND    ClassParameter = W.ServiceItem
							 AND    Mission = W.Mission
							 )			
	</cfif>
	
	--->
	
	<cfif url.serviceclass neq "">
	AND        R.ServiceClass = '#url.serviceclass#'			
	</cfif>
	
	) as W
	
	WHERE 1=1 
	--condition
	
	ORDER BY W.ListingOrder, W.Created
	
</cfsavecontent>

<cfif url.portal eq "0" and customer.operational eq "1">
																																				   
	<cfset menu=ArrayNew(1)>	
	
	<!--- access only for processors --->	
		   		   
	<cfinvoke component = "Service.Access"  
		   method           = "WorkOrderProcessor" 
		   mission          = "#url.mission#"  
		   returnvariable   = "access">
							   
	<cfif access eq "EDIT" or access eq "ALL">			
		
		<cf_tl id="Add Order" var="1">									
		<cfset menu[1] = {label = "#lt_text#", icon = "add.png",	script = "addorder('#customerid#')"}>				 
				
	</cfif>					
		
<cfelse>

	<cfset menu = "">		
							
</cfif>

</cfoutput>

<cfset fields=ArrayNew(1)>

<cfset itm = 0>

<cfset fields[1] = {label       = "Class",                   		
					field       = "ClassDescription",
					column      = "Common",					
					searchfield = "Description",									
					search      = "text"}>									

<cfset itm = itm+1>						
<cf_tl id="Created" var="1">
<cfset fields[itm] = {label      = "#lt_text#",    					
					field        = "Created",		
					fieldentry   = "1",							
					align        = "center",			
					labelfilter  = "#lt_text#",						
					formatted    = "dateformat(Created,CLIENT.DateFormatShow)"}>	

<cfset itm = itm+1>			
<cf_tl id="Reference" var="vReference">					
<cfset fields[itm] = {label       = "#vReference#",                    
					field       = "Reference", 	
					searchfield = "Reference",											
					search      = "text"}>	

<cfset itm = itm+1>	
<cf_tl id="OrderDate" var="vOrderDate">
<cfset fields[itm] = {label     = "#vOrderDate#",                    
     				field       = "OrderDate",											
					alias       = "",	
					column      = "month",
					width       = "20",
					align       = "center",	
					formatted   = "dateformat(OrderDate,client.dateformatshow)",																					
					search      = "date"}>				
										
<cfset itm = itm+1>		
<cf_tl id="Description" var="vDescription">		
			
<cfset fields[itm] = {label       = "#vDescription#",                    
			field       = "ServiceDescription", 	
			filtermode  = "2",	
			searchfield = "Description",									
			search      = "text"}>	

<cfif Mode.ServiceMode eq "WorkOrder">	

	<cfset itm = itm+1>								
	<cf_tl id="Lines" var="vLines">										
	<cfset fields[itm] = {label      = "#vLines#", 					
						field      = "Lines",
						width      = "10",
						align      = "right",
						alias      = ""}>		
						
	<cfif workflow.recordcount eq "1">		
			
		<cfset itm = itm+1>								
		<cf_tl id="Status" var="vStatus">
		<cfset fields[itm] = {label     = "#vStatus#",                    
		     				field       = "StatusDescription",											
							alias       = "",	
							column      = "common",
							filtermode  = "2",																									
							search      = "text"}>		
							
	</cfif>		
	
	 <cfset itm = itm+1>					
	  <cfset fields[itm] = {label      = "Amount", 					
							field      = "Amount",					
							align      = "right",
							aggregate  = "sum",
							formatted  = "numberformat(amount,',.__')",
							alias      = ""}>														

<cfelse>

	<cfset itm = itm+1>					
	<cfset fields[itm] = {label       = "SLA",                    
						field       = "AgreementReference",
						searchfield = "TransactionReference",																			
						searchalias = "R"}>	
	
	<cfset itm = itm+1>		
	<cf_tl id="SLAAmount" var="vSLA">								
	<cfset fields[itm] = {label      = "#vSLA#", 					
					  field      = "AgreementAmount",					
					  align      = "right",
					  aggregate  = "sum",
					  formatted  = "numberformat(AgreementAmount,',__')",
					  alias      = ""}>		
	
	<cfset itm = itm+1>								
	<cf_tl id="Lines" var="vLines">										
	<cfset fields[itm] = {label      = "#vLines#", 					
						field      = "Lines",
						width      = "10",
						align      = "right",
						alias      = ""}>											
									
	<cfif workflow.recordcount eq "1">		
		
		<cfset itm = itm+1>								
		<cf_tl id="Status" var="vStatus">
		<cfset fields[itm] = {label     = "#vStatus#",                    
		     				field       = "StatusDescription",											
							fieldorder  = "Status",
							alias       = "",	
							filtermode  = "2",																									
							search      = "text"}>		
	
	<cfelse>
		
	  <cfset itm = itm+1>					
	  <cfset fields[itm] = {label      = "Charges #year(now())#", 					
							field      = "Amount",					
							align      = "right",
							aggregate  = "sum",
							formatted  = "numberformat(amount,',.__')",
							alias      = ""}>				
	
	</cfif>		

</cfif>

<cfset itm = itm+1>										
<cfset fields[itm] = {label      = "Id",                 		
					display    = "No",
					alias      = "",
					field      = "WorkOrderId"}>						

<cfset itm = itm+1>										
<cfset fields[itm] = {label      = "Listorder",                 		
					display    = "OrderList",
					alias      = "W",
					field      = "ListingOrder"}>								

<cfif url.height eq "full" or url.height eq "undefined">

	<cfset ht = "">
	<cfset sh = "9999">

<cfelse>		
    
	<cfset ht = url.height-300>
	<cfif ht lt 200>
	  <cfset ht = 200>
	</cfif>					
	<cfset sh = int(ht/25)>

</cfif>

<cfparam name="menu" default="">

<!--- embed|window|dialogajax|dialog|standard --->
							
<cf_listing
    header         = "workorderorderlist"
	screentop      = "no"
    box            = "orderdetail#url.customerid#"
	link           = "#SESSION.root#/WorkOrder/Application/Workorder/Create/WorkOrderListing.cfm?portal=#url.portal#&height=#url.height#&mission=#url.mission#&customerid=#url.customerid#&systemfunctionid=#url.systemfunctionid#"
    html           = "No"		
	tableheight    = "100%"
	tablewidth     = "100%"
	datasource     = "AppsWorkOrder"
	listquery      = "#myquery#"	
	listgroup      = "ClassDescription"		
	listorder      = "Created"		
	listorderdir   = "DESC"
	listorderalias = "W"
	headercolor    = "ffffff"
	show           = "#sh#"		
	menu           = "#menu#"
	filtershow     = "Hide"	
	allowgrouping  = "enforce"	
	excelshow      = "Yes" 		
	listlayout     = "#fields#"
	drillmode      = "tab" 
	drillargument  = "#client.height-80#;#client.widthfull-70#;true;true"	
	drilltemplate  = "WorkOrder/Application/WorkOrder/WorkOrderView/WorkOrderView.cfm?workorderid="
	drillkey       = "WorkOrderId"
	drillbox       = "addworkorder">	