
<cfoutput>
 
<cfsavecontent variable="myquery">

SELECT *
FROM (
	
		SELECT *, 'Expired' as PostStatus
		FROM (	
				SELECT   PP.PostGrade, 
				         PP.FunctionDescription,
						 PP.PostType, 
						 PP.DateEffective,
						 (CASE WHEN Pos.SourcePostNumber > '' THEN Pos.SourcePostNumber ELSE CONVERT(VARCHAR,Pos.PositionParentId) END) as SourcePostNumber,				  				         						 
						 Pos.PostClass,
						 Pos.DateExpiration, 	        
						 Pos.PositionNo,
						 Pos.LocationCode,
						 Pos.PositionParentId,
						 O.OrgUnitName,
						 
						 (SELECT   TOP 1 P.LastName
						  FROM     PersonAssignment PA INNER JOIN
			                       Person P ON PA.PersonNo = P.PersonNo
						  WHERE    PA.PositionNo           = Pos.PositionNo
						  AND      PA.Incumbency > 0 
						  AND      PA.AssignmentStatus IN ('0', '1')
						  ORDER BY PA.DateExpiration DESC
						  ) as Incumbent,
						  
						 (SELECT   count(DISTINCT PositionParentId)
						  FROM     PositionParentFunding PF 
						  WHERE    PF.PositionParentid  = Pos.PositionParentId						
						  ) as Funding,
						  
						 Pos.Created    	 					   
						  
				FROM     PositionParent PP, 
				         Position Pos, 
						 Organization.dbo.Organization O
						 
				WHERE    PP.PositionParentId = Pos.PositionParentId
				AND      O.OrgUnit           = Pos.OrgUnitOperational
				AND      PP.Mission          = '#URL.Mission#' 
				AND      PP.MandateNo        = '#URL.Mandate#' 		
				<!--- last position within the parent --->	
				AND      Pos.PositionNo = (SELECT MAX(PositionNo) 
				                           FROM   Position 
										   WHERE  PositionParentid = PP.PositionParentid) 
										   
										   
						   
								
				) P
				
		WHERE DateExpiration < '#url.dte#' 
	
	UNION ALL 
	
		SELECT *, 'Active' as PostStatus
		FROM (	
				SELECT   PP.PostGrade, 
				         PP.FunctionDescription,
						 PP.PostType, 
						 PP.DateEffective, 						 			  
				         (CASE WHEN Pos.SourcePostNumber > '' THEN Pos.SourcePostNumber ELSE CONVERT(VARCHAR,Pos.PositionParentId) END) as SourcePostNumber,	
						 Pos.PostClass,
						 Pos.DateExpiration, 	        
						 Pos.PositionNo,
						 Pos.LocationCode,
						 Pos.PositionParentId,
						 O.OrgUnitName,
						 
						 (SELECT   TOP 1 P.LastName
						  FROM     PersonAssignment PA INNER JOIN
			                       Person P ON PA.PersonNo = P.PersonNo
						  WHERE    PA.PositionNo           = Pos.PositionNo
						  AND      PA.Incumbency > 0 
						  AND      PA.AssignmentStatus IN ('0', '1')
						  ORDER BY PA.DateExpiration DESC
						  ) as Incumbent,
						  
						   (SELECT   count(DISTINCT PositionParentId)
						  FROM     PositionParentFunding PF 
						  WHERE    PF.PositionParentid  = Pos.PositionParentId						
						  ) as Funding	,
						  Pos.Created    						   
						  
				FROM     PositionParent PP, 
				         Position Pos, 
						 Organization.dbo.Organization O
						 
				WHERE    PP.PositionParentId = Pos.PositionParentId
				AND      O.OrgUnit           = Pos.OrgUnitOperational
				AND      PP.Mission          = '#URL.Mission#' 
				AND      PP.MandateNo        = '#URL.Mandate#' 		
				<!--- last position within the parent --->	
				AND      Pos.PositionNo = (SELECT MAX(PositionNo) 
				                           FROM   Position 
										   WHERE  PositionParentid = PP.PositionParentid) 
										   
										   
						   
								
				) P
				
		WHERE DateExpiration >= '#url.dte#' 
	
	) as P
	
	WHERE 1=1
	
	--Condition
										
</cfsavecontent>

<cfset itm = 0>
		
<cfset fields=ArrayNew(1)>


<cfset itm = itm + 1>					
<cfset fields[itm] = {label      = "Position", 					
					  field      = "SourcePostNumber",										
					  search     = "text",
					  filtermode = "2"}>	
					  
<cfset itm = itm + 1>					
<cfset fields[itm] = {label      = "Budget Position", 					
					  field      = "PositionParentId",										
					  Display    = "no",
					  search     = "text",
					  filtermode = "2"}>						  	
					  
<cfset itm = itm+1>						
<cfset fields[itm] = {label       = "F", 	
                    LabelFilter   = "Funding",				
					field         = "Funding",					
					filtermode    = "3",    
					search        = "text",
					align         = "center",
					formatted     = "Rating",
					ratinglist    = "0=Yellow,1=Green"}>							  
					  
		  
					  
<cfset itm = itm + 1>					  
<cfset fields[itm] = {label      = "Status",                  					
					  field      = "PostStatus",					
					  search     = "text",
					  filtermode = "3"}>	
					  
<cfset itm = itm + 1>						
<cfset fields[itm] = {label      = "Type", 					
					  field      = "PostType",													
					  search     = "text", 
					  filtermode = "2"}>							  				  

<cfset itm = itm + 1>					  
<cfset fields[itm] = {label      = "Grade",                  					
					  field      = "PostGrade",					
					  search     = "text",
					  filtermode = "2"}>

<cfset itm = itm + 1>
<cfset fields[itm] = {label      = "PositionId", 					
					  field      = "PositionNo",
					  Display    = "False"}>	

					
<cfset itm = itm + 1>						
<cfset fields[itm] = {label      = "Class", 					
					  field      = "PostClass",													
					  search     = "text", 
					  filtermode = "3"}>																

<cfset itm = itm + 1>						
<cfset fields[itm] = {label      = "Budget Title",                     
					  field      = "FunctionDescription", 													
					  search     = "text", 
					  filtermode = "2"}>					
								
<cfset itm = itm + 1>	
<cfset fields[itm] = {label      = "Location",					
					  field      = "LocationCode",	
					  search     = "text",
					  filtermode = "2"}>							

<cfset itm = itm + 1>						
<cfset fields[itm] = {label      = "Unit", 					
					  field      = "OrgUnitName",
					  search     = "text",
					  filtermode = "2"}>	

<cfset itm = itm + 1>						
<cfset fields[itm] = {label      = "Last Incumbent", 					
					  field      = "Incumbent",										
					  search     = "text"}>																					

<cfset itm = itm + 1>																
<cfset fields[itm] = {label      = "Effective", 					
					  field      = "DateEffective",										
					  formatted  = "dateformat(DateEffective,'#CLIENT.DateFormatShow#')",
					  search     = "date"}>

<cfset itm = itm + 1>									
<cfset fields[itm] = {label      = "Expiration", 					
					  field      = "DateExpiration",											
					  formatted  = "dateformat(DateExpiration,'#CLIENT.DateFormatShow#')",		
					  search     = "date"}>						

<cfset itm = itm + 1>				
<cfset fields[itm] = {label      = "PositionParentId",    					
					  field      = "PositionParentId",
					  Display    = "False"}>		
					  
<cfset itm = itm + 1> 
<cfset fields[itm] = {label      = "Created", 
					  field      = "Created", 
					  formatted  = "dateformat(Created,'#CLIENT.DateFormatShow#')"}>   


<!--- embed|window|dialogajax|dialog|standard --->

<table width="100%" height="100%" align="center">
	
	<tr><td width="100%" height="100%">			
	
	<cf_listing header  = "PositionExpiration"
	    box             = "actiondetail"
		link            = "#SESSION.root#/Staffing/Reporting/PostView/Position/PositionMandateContent.cfm?systemfunctionid=#url.systemfunctionid#&mission=#url.mission#&mandate=#url.mandate#&dte=#url.dte#"
	    html            = "No"		
		datasource      = "AppsEmployee"
		listquery       = "#myquery#"
		listorder       = "DateExpiration"
		listorderalias  = "P"
		listorderdir    = "DESC"
		headercolor     = "ffffff"				
		tablewidth      = "100%"
		listlayout      = "#fields#"
		FilterShow      = "Yes"
		ExcelShow       = "Yes"
		drillmode       = "tab" 
		drillargument   = "980;1100;true"	
		drilltemplate   = "Staffing/Application/Position/PositionParent/PositionView.cfm?drillid="
		drillkey        = "PositionNo">	
		
	</td></tr>

</table>	

<cfset ajaxonload("doCalendar")>	

</cfoutput>
	