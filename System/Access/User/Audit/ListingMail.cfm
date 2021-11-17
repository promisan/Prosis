
<cf_listingscript>
<cf_screentop html="No" jquery="Yes">

<cfoutput>
<cfsavecontent variable="myquery">

    SELECT * 
	FROM (
	
		SELECT Account, 
		       MailId, 
			   Source, 
			   SourceId, 
			   Reference, 
			   MailAddress, 
			   MailAddressFrom, 
			   MailSubject, 
			   MailDateSent, 
			   MailStatus 
		FROM   UserMail 
		WHERE  Account = '#URL.ID#'  
		AND    Source != 'Listing'
	
		UNION ALL
	
		SELECT  U.Account,
		        M.MailId, 
				'WorkOrder', 
				M.WorkOrderId, 
				L.Reference, 
				M.EMailAddress, 
				'', 
				R.Description, 
				M.DateSent, 
				M.ActionStatus
		FROM    WorkOrder.dbo.WorkOrderLineMail M
				INNER JOIN WorkOrder.dbo.vwWorkOrderLine L ON L.WorkOrderId=M.WorkOrderId AND L.WorkOrderLine=M.WorkOrderLine
				INNER JOIN WorkOrder.dbo.Ref_Action R ON R.Code = M.Action	
				INNER JOIN System.dbo.userNames U ON U.PersonNo = M.PersonNo
		
		WHERE   M.ActionStatus = '1'
		AND     M.Action IN ('MailInvitation','Close')
		AND     M.EMailAddress IS NOT NULL
		AND     U.Account = '#URL.ID#'
	
	)  as P
	
	WHERE 1=1
	--- condition
	
			
</cfsavecontent>
</cfoutput>

<cfset fields=ArrayNew(1)>
			
<cfset fields[1] = {label      = "Subject", 					
					field      = "MailSubject",
					search     = "text"}>

<cfset fields[2] = {label      = "Source",                   
					field      = "Source",
					search     = "text"}>
					
<cfset fields[3] = {label      = "Address",                   
					field      = "MailAddress", 
					special    = "Mail",
					search     = "text"}>
					
<cfset fields[4] = {label      = "Reference",                   
					field      = "Reference", 					
					search     = "text"}>					
							
<cfset fields[5] = {label      = "Sent",    					
					field      = "MailDateSent",
					formatted  = "dateformat(MailDateSent,CLIENT.DateFormatShow)",
					search     = "date"}>
					
<cfset fields[6] = {label      = "Time",    					
					field      = "MailDateSent",
					formatted  = "timeformat(MailDateSent,'HH:MM')"}>					
		
							
<cf_listing
	    header        = "User Error mail"
	    box           = "usererrordetail"
		link          = "#SESSION.root#/System/Access/User/Audit/ListingMail.cfm?id=#url.id#"
	    html          = "No"
		tableheight   = "100%"
		listquery     = "#myquery#"
		listorder     = "MailDateSent"
		headercolor   = "ffffff"
		filtershow    = "Yes"
		excelshow     = "Yes"
		listlayout    = "#fields#"
		drillmode     = "embed" <!--- embed|window|dialog|standard --->
		drillargument = "640;700;false;false"	
		drilltemplate = "System/Access/User/Audit/ListingMailDetail.cfm"
		drillkey      = "MailId">	