
<cfparam name="url.mission"            default="">
<cfparam name="url.selecteddate"       default="05/05/2019">
<cfparam name="url.positionno"         default="">
<cfparam name="url.personno"           default="">
<cfparam name="url.systemfunctionid"   default="">

<cfquery name="Mission"
	datasource="AppsOrganization"
	username="#SESSION.login#"
	password="#SESSION.dbpw#">
	SELECT *
	FROM   Ref_Mission
	WHERE  Mission = '#url.mission#'
</cfquery>


<cfoutput>
<cfsavecontent variable="SelectLine">

 SELECT *
 FROM (

    SELECT     WL.Reference, 
	           R.Code, 
			   R.Description, 
			   WL.WorkOrderLine, 
			   WL.DateEffective, 
			   WL.WorkOrderLineId,
			   WL.WorkOrderId,
			   WL.OrgUnit, 
			   o.OrgUnitName, 
			   WL.SourceNo, 
			   WLA.ActionClass, 
			   WL.PersonNo, 
			   P.LastName, 
			   P.FirstName,
			   P.IndexNo
    FROM       WorkOrderLine AS WL INNER JOIN
               Ref_ServiceItemDomainClass AS R ON WL.ServiceDomain = R.ServiceDomain AND WL.ServiceDomainClass = R.Code INNER JOIN
               WorkOrderLineAction AS WLA ON WL.WorkOrderId = WLA.WorkOrderId AND WL.WorkOrderLine = WLA.WorkOrderLine INNER JOIN
               Employee.dbo.Person AS P ON WL.PersonNo = P.PersonNo INNER JOIN
               Organization.dbo.Organization AS o ON WL.OrgUnit = o.OrgUnit INNER JOIN
               WorkOrder AS W ON WL.WorkOrderId = W.WorkOrderId
    WHERE      W.Mission = '#url.mission#' 
    AND        CAST(WLA.DateTimeRequested AS Date) = '#url.selecteddate#'
	
	) as B
	WHERE 1=1
	--condition
	
	
</cfsavecontent>
</cfoutput>

<cfset itm = 0>
		
<cfset fields=ArrayNew(1)>

<cfset itm = itm + 1>	
<cf_tl id="Reference" var = "1">					
<cfset fields[itm] = {label          = "#lt_Text#", 					
					  field          = "Reference",										
					  search         = "text"}>	
					  
<cfset itm = itm + 1>	
<cf_tl id="Description" var = "1">					
<cfset fields[itm] = {labelfilter    = "#lt_Text#", 	
                      label          = "#lt_text#",				
					  field          = "Description"}>	
				  					  
<cfset itm = itm + 1>	
<cf_tl id="Class" var = "1">						
<cfset fields[itm] = {label          = "#lt_text#", 					
					  field          = "ActionClass",										
					  search         = "text",
					  column         = "common",	
					  filtermode     = "3"}>						  
				  
	  
<cfset itm = itm + 1>					  
<cfset fields[itm] = {label          = "OrgUnit",                  					
					  field          = "OrgUnitName",					  			
					  search         = "text",
					  filtermode     = "3"}>	
			  
<cfset itm = itm + 1>						
<cfset fields[itm] = {label          = "LastName",                     
					  field          = "LastName", 													
					  search         = "text"}>	
					  
<cfset itm = itm + 1>						
<cfset fields[itm] = {label          = "FirstName",                     
					  field          = "FirstName", 													
					  search         = "text"}>			
					  
<cfset itm = itm + 1>						
<cfset fields[itm] = {label          = "IndexNo",                     
					  field          = "IndexNo", 													
					  search         = "text"}>			
	
	
<cfset fil = "Hide">

<!--- embed|window|dialogajax|dialog|standard --->
			
<cf_listing header  = "FollowupListing"
    box             = "FollowupListing_#url.mission#"
	link            = "#SESSION.root#/WorkOrder/Application/FollowUp/ServiceDetails/WorkOrderLine/WorkOrderLineViewContent.cfm?mission=#url.mission#&selecteddate=#url.selecteddate#&systemfunctionid=#url.systemfunctionid#"
    html            = "No"		
	datasource      = "AppsWorkOrder"
	listquery       = "#selectline#"
	listorder       = "DateEffective"
	listorderalias  = ""
	listorderdir    = "ASC"
	headercolor     = "ffffff"				
	tablewidth      = "100%"
	listlayout      = "#fields#"
	FilterShow      = "#fil#"
	ExcelShow       = "Yes"
	drillmode       = "tab" 
	drillargument   = "980;1100;true"	
	drilltemplate   = "#SESSION.root#/WorkOrder/Application/FollowUp/ServiceDetails/WorkOrderline/WorkOrderLineView.cfm?id="
	drillkey        = "workorderlineid">	



	