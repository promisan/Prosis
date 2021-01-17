
<cf_wfpending entityCode="EntLVE"  
      table="#SESSION.acc#wfLeave" mailfields="No" IncludeCompleted="No">		
	  
<cfparam name="url.mission"    default="">
<cfparam name="url.header"     default="1">
<cfparam name="url.systemfunctionid"     default="">

<cfif url.header eq "1">
	<cf_screentop jquery="Yes" html="No">
	<cf_listingscript>
</cfif>

<cfinvoke component  = "Service.Access" 
	      method         = "RoleAccess"				  	
		  role           = "'LeaveClearer'"		
		  returnvariable = "manager">	

<cf_dialogstaffing>

<cfsavecontent variable="myquery">

	<cfoutput>
	
		SELECT *, DateEffective
		FROM (
		
		SELECT      P.IndexNo, 
		            P.FirstName, 
					P.LastName, 
					P.LastName+','+P.FirstName as Name,	
					P.PersonNo,					 
					PL.GroupListCode, 
					
					<!--- this query slows down a lot so I removed it for now pending a better query--->
					
					(SELECT LastName
					FROM System.dbo.UserNames
					WHERE Account = PL.FirstReviewerUserId) as FRO,
					
					<!---
										 
					(CASE  WHEN Status = '1' THEN  
						case when V.ActionDescriptionDue like 'xxxHHRR%' then '-'
						     when V.ActionDescriptionDue like 'xxxConfirmation%' then '-' END
	--					else organization.dbo.nextapproval(PL.LeaveId,PL.FirstReviewerUserId,PL.SecondReviewerUserId, pl.Status)  END
		             ELSE '-' END) as FRO,
					 
					 --->
					 
					(CASE WHEN PL.GroupCode is not NULL THEN 
					 
					 (SELECT  TOP 1 Description
					  FROM    Ref_PersonGroupList
					  WHERE   GroupCode = PL.GroupCode 
					  AND     GroupListCode = PL.GroupListCode) ELSE R.Description END) as LeaveClass,
					  
					(CASE WHEN TransactionType = 'Manual' 
					       THEN 'Backoffice' 
						   ELSE ( CASE WHEN TransactionType = 'External' 
						               THEN 'Migrated' 
									   ELSE 'Portal' END) END) as TransactionType,
									   
											
					(SELECT O.OrgUnitCode+' '+O.OrgUnitName
					    FROM  Organization.dbo.Organization O 
						WHERE O.OrgUnit = PL.OrgUnit	  
						) as OrgUnitName,		
						
					(SELECT O.HierarchyCode
					    FROM  Organization.dbo.Organization O 
						WHERE O.OrgUnit = PL.OrgUnit	  
						) as OrgUnitName_ord,								   
					
 					PL.DateEffective, 
					PL.DateEffectiveFull, 
					PL.DateExpiration, 
		            PL.DateExpirationFull, 
					PL.DaysLeave, 
					PL.DaysDeduct, 
					PL.Status, 
					PL.OfficerUserid,
					PL.OfficerLastName,
					PL.OfficerFirstName,				    
					 
					CASE WHEN Status = '1' 
					       THEN V.ActionDescriptionDue 
						   ELSE (
						      SELECT    Description 
    						  FROM      Ref_Status
	    					  WHERE     Class = 'Leave'
		    				  AND       Status = PL.Status) END as StatusDescription,		  					  
					  
					 PL.LeaveId
					 
		FROM         PersonLeave AS PL INNER JOIN
		             Ref_LeaveTypeClass AS R ON PL.LeaveType = R.LeaveType AND PL.LeaveTypeClass = R.Code INNER JOIN
		             Person AS P ON PL.PersonNo = P.PersonNo  LEFT OUTER JOIN userQuery.dbo.#SESSION.acc#wfLeave V ON ObjectkeyValue4 = PL.LeaveId	
		WHERE        PL.Mission   = '#url.mission#' 
		
		<cfif url.leavetype neq "">	
		AND          PL.LeaveType = '#url.leaveType#' 
		</cfif>
		
		<cfif manager eq "GRANTED">
		
		<!--- full access --->
				
		<cfelse>
				
		AND          PL.OrgUnit IN (SELECT A.OrgUnit
				                    FROM   Organization.dbo.OrganizationAuthorization A, 
		                  		           Organization.dbo.Organization O
			   	                    WHERE  A.UserAccount = '#SESSION.acc#' 
				                    AND    A.Mission     = '#url.Mission#'
				                    AND    O.OrgUnit     = A.OrgUnit
				                    AND    O.Mission     = '#url.Mission#'		
				                    AND    Role IN ('Timekeeper', 'HROfficer')
									)		   
		</cfif>
		
		<cfif url.filter eq "Active">
		AND          PL.Status IN ('0','1','2')
		<cfelse>
		AND          PL.Status IN ('#url.filter#')	
		</cfif>
		
		<cfif url.filter gte "8">
		
		AND          PL.TransactionType != 'External'
		
		</cfif>
		
		) as B
		
		WHERE 1=1		
			
	</cfoutput>

</cfsavecontent>

<cfset fields=ArrayNew(1)>

<cfset itm = 1>		
<cfset fields[itm] = {label        = "IndexNo",                  
					field          = "IndexNo",
					functionscript = "EditPerson",
					functionfield  = "PersonNo",
					search         = "text"}>	
					
<cfset itm = itm+1>						
<cfset fields[itm] = {label        = "Name",                  
					field          = "Name",
					filtermode     = "0",
					search         = "text"}>				

<cfset itm = itm+1>							
<cfset fields[itm] = {label        = "Class",  					
					field          = "LeaveClass",
					filtermode     = "3",					
					search         = "text"}>								

<cfset itm = itm+1>							
<cfset fields[itm] = {label        = "Unit name",  					
					field          = "OrgUnitName",
					fieldsort      = "OrgUnitName_ord",
					filtermode     = "3",					
					search         = "text"}>						
					
<cfset itm = itm+1>							
<cfset fields[itm] = {label        = "Source",  					
					field          = "TransactionType",
					filtermode     = "3",					
					search         = "text"}>											
															
<cfset itm = itm+1>							
<cfset fields[itm] = {label        = "Status",  					
					field          = "StatusDescription",
					filtermode     = "2",					
					search         = "text"}>			
																
<cfset itm = itm+1>							
<cfset fields[itm] = {label        = "Recorded By",  					
					field          = "OfficerLastName",	
					search         = "text"}>	

<cfset itm = itm+1>							
<cfset fields[itm] = {label        = "Reviewer",  					
					field          = "FRO",	
					search         = "text"}>	
					
<cfset itm = itm+1>												
<cfset fields[itm] = {label        = "Effective",					
					field          = "DateEffective",
					search         = "date",					
					column         = "month",
					align          = "center",
					formatted      = "dateformat(DateEffective,'#CLIENT.DateFormatShow#')"}>	
					
<cfset itm = itm+1>							
<cfset fields[itm] = {label        = "Expiration",  					
					field          = "DateEffective",
					align          = "center",
					formatted      = "dateformat(DateExpiration,'#CLIENT.DateFormatShow#')"}>	
					
<cfset itm = itm+1>							
<cfset fields[itm] = {label        = "Days",  					
					field          = "DaysLeave",
					align          = "center",
					aggregate      = "sum",
					formatted      = "numberformat(DaysLeave,'_._')"}>						
					
<cfset itm = itm+1>							
<cfset fields[itm] = {label        = "Deduct",  					
					field          = "DaysDeduct",
					align          = "center",
					aggregate      = "sum",
					formatted      = "numberformat(DaysDeduct,'_._')"}>			
	
<cf_listing
	    header         = "Leave"
	    box            = "Leave"
		link           = "#SESSION.root#/Attendance/Application/LeaveRequest/LeaveListing.cfm?filter=#url.filter#&header=#url.header#&mission=#url.mission#&leavetype=#url.leavetype#&systemfunctionid=#url.systemfunctionid#"
	    html           = "No"
		show           = "40"
		datasource     = "AppsEmployee"
		listquery      = "#myquery#"			
		listorder      = "DateEffective"
		listorderdir   = "ASC"
		headercolor    = "ffffff"
		listlayout     = "#fields#"
		filterShow     = "Yes"
		excelShow      = "Yes"
		drillmode      = "window"
		drillargument  = "940;1190;false;false"	
		drilltemplate  = "Staffing/Application/Employee/Leave/EmployeeLeaveEdit.cfm?refer=workflow&action=1&scope=attendance&id1="
		drillkey       = "LeaveId">

