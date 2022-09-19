
<CF_DateConvert Value="#URL.dte#">
<cfparam name="Date" default="#dateValue#">

<cf_droptable dbname="AppsQuery" tblname="#SESSION.acc#Position"> 
<cf_droptable dbname="AppsQuery" tblname="#SESSION.acc#Assignment"> 
<cf_droptable dbname="AppsQuery" tblname="#SESSION.acc#_AppStaffingDetail_#url.fileno#"> 

<cfquery name="getMandate" 
   datasource="AppsOrganization" 
   username="#SESSION.login#" 
   password="#SESSION.dbpw#">
     SELECT *	 
     FROM   Ref_Mandate
	 WHERE  Mission = '#url.mission#'
     AND    DateExpiration      >= #date#
	 AND    DateEffective       <= #date#	
</cfquery>	 

<cfset accesslist = "">	

<cf_treeUnitList
	 mission   = "#URL.Mission#"
	 mandateno = "#getMandate.MandateNo#"
	 role      = "'HROfficer','HRAssistant','HRPosition', 'HRLoaner', 'HRLocator','HRInquiry'"
	 tree      = "0">	

<!--- obtain valid position 
	 							 		 					
<cfquery name="getPosition" 
   datasource="AppsEmployee" 
   username="#SESSION.login#" 
   password="#SESSION.dbpw#">
     SELECT PositionNo	 
     FROM   vwPosition Pos
     WHERE  Pos.DateExpiration      >= #date#
	 AND    Pos.DateEffective       <= #date#	
	 
	 <!--- 27/3/2011
		   enhanced query to show all positions for units that beling to this mission/mandate --->
		
	     AND (		
				   
					   (   Pos.OperationalMission = '#url.mission#'
				           AND Pos.OperationalOrgUnit IN (SELECT OrgUnit
						                                  FROM   Organization.dbo.Organization
														  WHERE  Mission   = '#URL.Mission#'												
														  AND    OrgUnit   = Pos.OperationalOrgUnit )
												  
					   )						  
			   														  
			      	   OR
			   
					   (  Pos.Mission      = '#URL.Mission#'				       
					   )
			   
			   )							  
	 
	  <!--- 3/9/2014 enhanced query to limit unit to what you have access to --->
	  
	  <cfif accessList neq "" and accesslist neq "full">
	  AND OrgUnitOperational IN (#preservesinglequotes(accesslist)#)	 
	  </cfif>
	 	 
     ORDER BY Pos.HierarchyCode 
</cfquery>

<cfif quotedValueList(getPosition.PositionNo) eq "">
	<!--- positions found --->
	<cfabort>
</cfif>

<cfquery name="getAssignment" 
   datasource="AppsEmployee" 
   username="#SESSION.login#" 
   password="#SESSION.dbpw#">
    SELECT AssignmentNo	
    FROM   vwAssignment Ass
    WHERE  Ass.DateExpiration      >= #date#
	 AND   Ass.DateEffective       <= #date#
	 AND   Ass.Incumbency <> 0
	 AND   Ass.AssignmentStatus IN ('0','1')
</cfquery>	 

<cfif QuotedValueList(getAssignment.AssignmentNo) eq "">
	<cfset ass = "0">	
<cfelse>
	<cfset ass = QuotedValueList(getAssignment.AssignmentNo)>
</cfif>

<cfoutput>2. #cfquery.executiontime#</cfoutput>

--->

<cfquery name="Merge" 
   datasource="AppsEmployee" 
   username="#SESSION.login#" 
   password="#SESSION.dbpw#">
    SELECT     IDENTITY(INT,1,1) as RecordNo,
		        Pos.*, 
				(SELECT    count(*) 
				 <!--- current mandate --->
				 FROM     Vacancy.dbo.Document D INNER JOIN
					      Vacancy.dbo.DocumentPost DP ON D.DocumentNo = DP.DocumentNo 
				 WHERE    D.Status = '0'
				 AND      DP.PositionNo = Pos.PositionNo
				 AND      D.EntityClass is not NULL) as DocumentNo,
					
				(SELECT   count(*)
				 <!--- next mandate --->
				 FROM     Vacancy.dbo.Document D INNER JOIN
				          Vacancy.dbo.DocumentPost DP ON D.DocumentNo = DP.DocumentNo INNER JOIN
				          Position P ON DP.PositionNo = P.SourcePositionNo
				 WHERE    D.Status = '0'		 
				 AND      P.PositionNo = Pos.PositionNo			
				 AND      D.EntityClass is not NULL) as DocumentNextNo,	
				 	
		        Ass.PersonNo             AS PersonNo, 
		        Ass.IndexNo              AS IndexNo, 
				Ass.LastName             AS LastName, 
				Ass.FirstName            AS FirstName, 
				Ass.FullName             AS FullName, 
				Ass.Nationality          AS Nationality,
	            Ass.Gender               AS Gender, 
				Ass.BirthDate            AS BirthDate, 
				Ass.eMailAddress         AS eMailAddress, 
				Ass.ParentOffice         AS ParentOffice, 
	            Ass.ParentOfficeLocation AS ParentOfficeLocation,
				Ass.DateEffective        AS AssignmentEffective,
				Ass.DateExpiration       AS AssignmentExpiration,
				Ass.Incumbency,
				Ass.AssignmentClass
				
	 INTO       userQuery.dbo.#SESSION.acc#_AppStaffingDetail_#url.fileno#
	 
     FROM       vwPosition Pos LEFT OUTER JOIN vwAssignment Ass 
	            ON Pos.PositionNo = Ass.PositionNo 
				
				 AND Ass.AssignmentNo IN ( SELECT AssignmentNo	
										   FROM   vwAssignment A
										   WHERE  A.DateExpiration      >= #date#
										   AND    A.DateEffective       <= #date#
										   AND    A.Incumbency <> 0
										   AND    A.AssignmentStatus IN ('0','1'))	
	  			
	 WHERE      EXISTS (
	 
					 SELECT 'X'	 
				     FROM   Position P
					 WHERE  PositionNo = Pos.PositionNo 
				     AND    P.DateExpiration      >= #date#
					 AND    P.DateEffective       <= #date#	
					 
					 <!--- 27/3/2011
						   enhanced query to show all positions for units that beling to this mission/mandate --->
						
					     AND (		 
									  (   P.MissionOperational = '#url.mission#'
								           AND P.OrgUnitOperational IN (SELECT OrgUnit
										                                FROM   Organization.dbo.Organization
																	    WHERE  Mission   = '#URL.Mission#'												
																		AND    OrgUnit   = P.OrgUnitOperational )															  
									   ) OR ( P.Mission = '#URL.Mission#'  )
							   
							   )							  
					 
					  <!--- 3/9/2014 enhanced query to limit unit to what you have access to --->				  
					  <cfif accessList neq "" and accesslist neq "full">
					  AND    P.OrgUnitOperational IN (#preservesinglequotes(accesslist)#)	 					  
					  </cfif>
					   )
	
</cfquery>	


<!---
<cfoutput>4. #cfquery.executiontime#</cfoutput>
--->


<cfif url.scope eq "vac">

	<cfquery name="Delete" 
	   datasource="AppsQuery" 
	   username="#SESSION.login#" 
	   password="#SESSION.dbpw#">
	   DELETE FROM #SESSION.acc#_AppStaffingDetail_#url.fileno#
	   WHERE  PersonNo is not NULL
	</cfquery>
	
</cfif>	
	
<cfif url.scope eq "inc">

	<cfquery name="Delete" 
	   datasource="AppsQuery" 
	   username="#SESSION.login#" 
	   password="#SESSION.dbpw#">
	   DELETE FROM #SESSION.acc#_AppStaffingDetail_#url.fileno#
	   WHERE  PersonNo is NULL 
	</cfquery>
   
</cfif> 


<cfset base   = "\\Staffing\\Reporting\\Inquiry\\">
<cfset path   = "Vacancy">
<cfset parent = "Template">
			
<cfif fileExists("#SESSION.rootpath#\#base#\#path#\Property.cfm")>
	<cfset pty = "#path#">							
<cfelseif fileExists("#SESSION.rootpath#\#base#\#parent#\Property.cfm")>
	<cfset pty = "#parent#">					
</cfif>		

<cfif fileExists("#SESSION.rootpath#\#base#\#path#\Filter.cfm")>
	<cfset fil = "#path#">							
<cfelseif fileExists("#SESSION.rootpath#\#base#\#parent#\Filter.cfm")>		   
	<cfset fil = "#parent#">					
</cfif>	

<cfquery name="Overall" 
   datasource="AppsQuery" 
   username="#SESSION.login#" 
   password="#SESSION.dbpw#">	
		SELECT  COUNT(DISTINCT PositionNo) AS countedPosition, 
				COUNT(DISTINCT PersonNo) AS Occupied, 
				COUNT(DISTINCT PositionNo) - COUNT(DISTINCT PersonNo) AS Vacant	
		FROM    #SESSION.acc#_AppStaffingDetail_#url.fileno#	
</cfquery>	

<cfif Overall.countedPosition eq "0">

	<cf_message message="Problem, not positions have been recorded">
	<cfabort>

</cfif>

<cfset ov = (Overall.Vacant/Overall.countedPosition)*100>

<input type="hidden" id="graphitem"   name="graphitem">
<input type="hidden" id="graphselect" name="graphselect">
<input type="hidden" id="graphseries" name="graphseries">

<link href="<cfoutput>#SESSION.root#/tools\pivot\crosstab.css</cfoutput>" rel="stylesheet" type="text/css">
	
<cf_layoutScript>

<cf_layout id="vacancyDB" type="border">
		   						
	<cf_layoutarea  
		position      = "top"			
		name          = "graph"
		collapsible   = "true"
        maxsize       = "220"
        size          = "220">				
				
		<cfif fileExists("#SESSION.rootpath#\#base#\#path#\Graph.cfm")>
			  <cfinclude template="#path#/Graph.cfm">																			
		<cfelseif fileExists("#SESSION.rootpath#\#base#\#parent#\Graph.cfm")>
			  <cfinclude template="#parent#/Graph.cfm">											
		<cfelse>
		      Not found				
		</cfif>	
								
	</cf_layoutarea>		
			
	<cf_layoutarea position = "right"
          name          = "filter"          
		  source        = "#SESSION.root#/#base#/#fil#/Filter.cfm?fileno=#fileno#&scope=#url.scope#" 						 						
          maxsize       = "200"
          size          = "150"
          overflow      = "hidden"
          collapsible   = "true"
          initcollapsed = "true"
		  splitter      = "true"/>			 
					
	<cf_layoutarea position    = "center"		    		  
		  splitter      = "true"				  		  		    		 
          name          = "listingbox"
		  overflow      = "hidden">
		
		<table width="100%" height="100%"><tr><td style="padding-left:15px" valign="top" id="listing"></td></tr></table>  			
			
	</cf_layoutarea>		
				  							   		
</cf_layout>



	