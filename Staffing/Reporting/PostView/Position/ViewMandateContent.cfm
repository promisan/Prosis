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
<cfoutput>
 
<cfsavecontent variable="myquery">

SELECT *
FROM (
	
		SELECT *, 'Expired' as PostStatus
		FROM (	
				SELECT   PP.PostGrade, 
				         R.PostOrder,
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
						 O.HierarchyCode,
						 
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
						  
				FROM     PositionParent PP 
				         INNER JOIN Position Pos ON PP.PositionParentId = Pos.PositionParentId
						 INNER JOIN Organization.dbo.Organization O ON O.OrgUnit = Pos.OrgUnitOperational
						 INNER JOIN Ref_PostGrade R ON R.PostGrade = PP.PostGrade
						 
				WHERE    PP.Mission          = '#URL.Mission#' 
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
				         R.PostOrder,
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
						 O.HierarchyCode,
						 
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
						  
				FROM     PositionParent PP 
				         INNER JOIN Position Pos ON PP.PositionParentId = Pos.PositionParentId
						 INNER JOIN Organization.dbo.Organization O ON O.OrgUnit = Pos.OrgUnitOperational
						 INNER JOIN Ref_PostGrade R ON R.PostGrade = PP.PostGrade		   						   						  				
						 
				WHERE    PP.Mission          = '#URL.Mission#' 
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
					  search     = "text"}>	
					  
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
					  column     = "common",											
					  search     = "text", 
					  filtermode = "3"}>							  				  

<cfset itm = itm + 1>					  
<cfset fields[itm] = {label      = "Grade",                  					
					  field      = "PostGrade",		
					  fieldsort  = "PostOrder",					  			
					  search     = "text",
					  filtermode = "3"}>

<cfset itm = itm + 1>
<cfset fields[itm] = {label      = "PositionId", 					
					  field      = "PositionNo",
					  Display    = "False"}>	

					
<cfset itm = itm + 1>						
<cfset fields[itm] = {label      = "Class", 					
					  field      = "PostClass",		
					  column     = "common",											
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
					  column     = "common",
					  search     = "text",
					  filtermode = "2"}>							

<cfset itm = itm + 1>						
<cfset fields[itm] = {label      = "Unit", 					
					  field      = "OrgUnitName",
					  fieldsort  = "HierarchyCode",
					  search     = "text",
					  filtermode = "3"}>	

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
			
<cf_listing header  = "PositionExpiration"
    box             = "position_#url.mission#"
	link            = "#SESSION.root#/Staffing/Reporting/PostView/Position/viewMandateContent.cfm?systemfunctionid=#url.systemfunctionid#&mission=#url.mission#&mandate=#url.mandate#&dte=#url.dte#"
    html            = "No"		
	cachedisable    = "true"
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

<cfset ajaxonload("doCalendar")>	

</cfoutput>
	