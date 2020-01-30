<!--- listing --->

<cfoutput>
	<cfsavecontent variable="myquery">
		SELECT  R.RequestId, 
				R.Reference, 
				R.RequestDate, 
				RW.RequestActionName, 
				RL.ServiceItem, 
				SI.Description, 
				RR.Description as CDescription, 
				R.emailaddress,
				R.OfficerLastName, 
				R.OfficerFirstName,
				R.ActionStatus
		FROM    Request R 
				INNER JOIN Ref_RequestWorkflow RW
					ON R.ServiceDomain = RW.ServiceDomain 
					AND R.ServiceDomainClass=RW.ServiceDomainClass 
					AND R.RequestAction=RW.RequestAction
					AND R.RequestType=RW.RequestType
				INNER JOIN RequestLine RL ON 
					RL.RequestId = R.RequestId AND RL.RequestLine = 1
				INNER JOIN ServiceItem SI ON 
					SI.Code = RL.Serviceitem
				INNER JOIN Ref_Request RR ON RR.Code = R.RequestType		
		WHERE   R.PersonNo = '#URL.id#'
		AND     ActionStatus != 9
		ORDER BY R.RequestDate
	</cfsavecontent>
</cfoutput>

<cf_tl id="Reference"   	var="vReference">
<cf_tl id="RequestDate"     var="vRequestDate">
<cf_tl id="ServiceItem"		var="vServiceItem">
<cf_tl id="Class"			var="vClass">
<cf_tl id="ServiceDomain"   var="vServiceDomain">
<cf_tl id="Action"   		var="vAction">
<cf_tl id="Email"   		var="vEmail">
<cf_tl id="LastName"   		var="vLastName">
<cf_tl id="Status"   		var="vStatus">

<cfset fields=ArrayNew(1)>
				
<cfset itm = 0>

<cfset itm = itm+1>
<cfset fields[itm] = {label    = "#vReference#", 
					width      = "0", 
					field      = "Reference",	
					search     = "text",							
					alias      = ""}>		
			
<cfset itm = itm+1>
<cfset fields[itm] = {label    = "#vRequestDate#", 
					width      = "25", 
					field      = "RequestDate",	
					formatted  = "dateformat(RequestDate,CLIENT.DateFormatShow)",	
					search     = "date",								
					alias      = ""}>				
			
<cfset itm = itm+1>				
<cfset fields[itm] = {label    = "#vServiceItem#",    
					width      = "0", 
					field      = "Description",
					search     = "text",
					filtermode = "2",					
					alias      = "SI"}>

<!---
<cfset itm = itm+1>				
<cfset fields[itm] = {label    = "#vClass#",    
					width      = "0", 
					field      = "CDescription",
					search     = "text",
					filtermode = "2",					
					alias      = "RR"}>
--->					

<cfset itm = itm+1>				
<cfset fields[itm] = {label      = "#vAction#",    
					width      = "0", 
					field      = "RequestActionName",
					search     = "text",
					filtermode = "2",					
					alias      = "RW"}>					

<!---					
<cfset itm = itm+1>				
<cfset fields[itm] = {label    = "#vEmail#",    
					width      = "0", 
					field      = "emailaddress",							
					alias      = "RW"}>					
					--->

<cfset itm = itm+1>				
<cfset fields[itm] = {label    = "#vLastName#",    
					width      = "0", 
					field      = "OfficerLastName",								
					alias      = "RW"}>

<cfset itm = itm+1>			
<cfset fields[itm] = {label       = "#vStatus#",      
					LabelFilter = "Status", 
					field       = "ActionStatus",  
					width       = "10",    					
					align       = "center",
					search     = "text",
					filtermode = "2",		
					formatted   = "Rating",
					ratinglist  = "9=Red,0=white,1=Gray,2=yellow,3=Green"}>
								
<!--- embed|window|dialogajax|dialog|standard --->

<cfsavecontent variable="myaddscript">

	<cfoutput>
		ptoken.navigate('#SESSION.root#/WorkOrder/Application/Medical/Complaint/Create/DocumentForm.cfm?context=portal&owner=#URL.owner#&id=#URL.id#&mission=#URL.mission#','requestbox');		
	</cfoutput>

</cfsavecontent>


<cfif url.EntryScope eq "Portal">

	<cfset menu=ArrayNew(1)>
	<cf_tl id="Record Medical Complaint" var="add">
	<cfset menu[1] = {label = "#add#", icon = "add.png", script = "#myaddscript#"}>
	
	<cf_listing header      = "listing1"
		    box             = "orderdetail"
			link            = "#SESSION.root#/Workorder/Application/Medical/Complaint/Listing/ComplaintListingContent.cfm?entryscope=#url.entryscope#&id=#URL.id#&owner=#URL.owner#&mission=#URL.mission#"
		    html            = "No"		
			datasource      = "AppsWorkOrder"
			listquery       = "#myquery#"
			listorder       = "RequestDate"		
			listorderdir    = "ASC"
			headercolor     = "transparent"		
			height          = "100%"
			menu            = "#menu#"
			filtershow      = "Hide"
			excelshow       = "No"
			listlayout      = "#fields#"			
			show            = "30"
			drillmode       = "drillbox"	
		    drillargument   = "870;1020;true;true"				
			drilltemplate   = "WorkOrder/Application/Medical/Complaint/Create/DocumentForm.cfm"
			drillkey        = "RequestId"
			drillstring     = "owner=#URL.owner#&id=#URL.id#&context=portal"
			drillbox        = "requestbox">	
	
<cfelse>

	<cf_listing header      = "listing1"
		    box             = "orderdetail"
			link            = "#SESSION.root#/Workorder/Application/Medical/Complaint/Listing/ComplaintListingContent.cfm?id=#URL.id#&owner=#URL.owner#&mission=#URL.mission#"
		    html            = "No"		
			datasource      = "AppsWorkOrder"
			listquery       = "#myquery#"
			listorder       = "RequestDate"		
			listorderdir    = "ASC"
			headercolor     = "transparent"		
			height          = "100%"
			filtershow      = "No"
			excelshow       = "No"
			listlayout      = "#fields#"			
			show            = "30"
			drillmode       = ""	
		    drillargument   = "870;1020;true;true"				
			drilltemplate   = ""
			drillkey        = "RequestId"
			drillstring     = "owner=#URL.owner#&id=#URL.id#&context=backoffice"
			drillbox        = "drilldetail">		
</cfif>		
														
				 		
					
