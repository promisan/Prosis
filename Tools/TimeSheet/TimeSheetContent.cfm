
<cfparam name="client.timesheetdetail"  default="true">

<cfparam name="url.init"           default="0">
<cfparam name="url.detail"         default="#client.timesheetdetail#">
<cfparam name="session.Timesheet['Presentation']"   default="Month">

<cfset client.timesheetdetail = url.detail>
<cfset client.timesheetdate   = url.selectiondate>

<cfset date = url.selectiondate>

<cfif session.timesheet["presentation"] eq "month">

	<cfset session.Timesheet["DateStart"] = CreateDate(Year(Date),Month(Date),1)>
	<cfset session.Timesheet["DateEnd"]   = CreateDate(Year(Date),Month(Date),DaysInMonth(Date))>
	
<cfelse>

	<cfset session.timesheet["DateStart"] = date>
	<cfset session.Timesheet["DateEnd"]   = DateAdd("ww", "6", date-1)>

</cfif>	
		
<cfset showtop      = DayOfWeek(session.timesheet["DateStart"]) - 1> 

<cfswitch expression="#url.Object#">

  <cfcase value="unit">
  
  	  <cfset url.orgunit = url.objectKeyValue1>
	  
	  <cftransaction isolation="READ_UNCOMMITTED">

	  <cfquery name="getPersons" 
		  datasource="AppsEmployee" 
		  username="#SESSION.login#" 
		  password="#SESSION.dbpw#">
		  
		  SELECT *, Postorder
		  FROM (
					SELECT 	DISTINCT P.PersonNo, 
					        P.LastName, 
							P.ListingOrder,
							P.FirstName, 
							A.FunctionDescription, 
							A.LocationCode,
							P.IndexNo, 
							A.AssignmentNo, 
							A.DateEffective, 
							A.DateExpiration,
							(SELECT   TOP 1 ContractLevel
							 FROM     PersonContract
							 WHERE    PersonNo     = P.PersonNo
							 AND      Mission      = Pos.Mission
							 AND      ActionStatus IN ('0','1')
							 AND      DateEffective <= #session.timesheet["DateEnd"]#
							 ORDER BY DateEffective DESC) as PostGrade
					FROM 	Person P 
					        INNER JOIN PersonAssignment A ON P.PersonNo = A.PersonNo
							INNER JOIN Position Pos ON A.PositionNo = Pos.PositionNo
							
					WHERE   P.PersonNo = A.PersonNo
					<!--- the unit of the operational assignment --->
					AND     A.OrgUnit = '#url.ObjectKeyValue1#'
					-- AND     A.Incumbency       > '0'
					AND     A.AssignmentStatus IN ('0','1')
					-- AND     A.AssignmentClass  = 'Regular'	<!--- not needed anymore as loaned people have leave as well --->		
					AND     A.AssignmentType   = 'Actual'
					AND     A.DateEffective   <= #session.timesheet["DateEnd"]#
					AND     A.DateExpiration  >= #session.timesheet["DateStart"]#
			
				) as P INNER JOIN Ref_PostGrade R ON P.PostGrade = R.PostGrade
						
			ORDER BY P.ListingOrder, R.PostOrder, P.LastName, P.DateEffective
			
			
	  </cfquery>	
	  
	  </cftransaction>
	  
	  <!---
	  <cfoutput>#cfquery.executiontime#</cfoutput>
	  --->
  
  </cfcase>
  
  <cfcase value="requisition">
    
  	   <!--- get any requisition to which this user has been involved as requester/reviewer --->
  
	   <cfquery name="getSource"  
			datasource="AppsPurchase" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			
			SELECT * 
			FROM   Employee.dbo.Position			
			WHERE  PositionParentId IN (			
			
		        SELECT    PPF.PositionParentId
		        FROM      RequisitionLine L INNER JOIN
		                  Employee.dbo.PositionParentFunding PPF ON L.RequisitionNo = PPF.RequisitionNo
		    	WHERE     L.Mission = '#url.objectkeyvalue1#' 
				AND       L.Period  = '#url.objectkeyvalue2#' 
		        AND 	  L.RequisitionNo IN
		                          (SELECT    RequisitionNo
		                            FROM     RequisitionLineAction
									<cfif getAdministrator("#url.objectkeyvalue1#") eq "0">																		
		                            WHERE    Officeruserid = '#session.acc#' 
									<cfelse>
									WHERE    1=1
									</cfif>
									AND      ActionStatus >= '1' AND ActionStatus < '3')																	
			    )					
				
	   </cfquery> 
	   	   
	   <cfquery name="getPersons" 
		  datasource="AppsEmployee" 
		  username="#SESSION.login#" 
		  password="#SESSION.dbpw#">
		  
			SELECT 	DISTINCT P.PersonNo, 
			        P.LastName, 
					P.FirstName, 
					A.FunctionDescription, 
					P.IndexNo, 
					A.LocationCode,
					A.AssignmentNo, 
					A.DateEffective, 
					A.DateExpiration
			FROM 	Person P, PersonAssignment A
			WHERE   P.PersonNo = A.PersonNo
			<cfif getSource.recordcount gte "1">
			AND     A.PositionNo IN (#quotedValueList(getSource.PositionNo)#)		
			<cfelse>
			AND    1=0
			</cfif>
			-- AND     A.Incumbency       > '0'
			AND     A.AssignmentStatus IN ('0','1')
			-- AND     A.AssignmentClass  = 'Regular'
			AND     A.AssignmentType   = 'Actual'
			
			AND     A.DateEffective   <= #session.timesheet["DateEnd"]#
			AND     A.DateExpiration  >= #session.timesheet["DateStart"]#		
			
	  </cfquery>	  
  
  </cfcase>
  
  <cfcase value="purchase">
    
	  <!--- we obtain a list of people that we are interested in to show, the below
	  query likely is to be expanded to the person sitting on the posts instead --->
	  
	   <cfquery name="getPO"  
		datasource="AppsPurchase" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT    *
			FROM      Purchase
			WHERE     PurchaseNo = '#url.ObjectKeyValue1#'			
	  </cfquery>
	  
	  <cfquery name="getSource"  
		datasource="AppsPurchase" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT    PL.PurchaseNo, 
			          R.RequisitionNo, 
					  R.PersonNo, 
					  PL.Created, 
					  F.PositionParentId, 
					  F.DateExpiration
			FROM      PurchaseLine AS PL INNER JOIN
			          RequisitionLine AS R ON PL.RequisitionNo = R.RequisitionNo INNER JOIN
			          Employee.dbo.PositionParentFunding AS F ON R.RequisitionNo = F.RequisitionNo
			WHERE     PL.PurchaseNo = '#url.ObjectKeyValue1#'
			ORDER BY  PL.PurchaseNo DESC		 
	  </cfquery>
	  	  
	  <cfif getPO.OrderDate neq "" and url.init eq "1">	  
	  	  	
			<cfset date = getPO.OrderDate>
			
	  	  	  		
			<cfset session.timesheet["DateStart"] = CreateDate(Year(Date),Month(Date),1)>
			<cfset session.timesheet["DateEnd"]   = CreateDate(Year(Date),Month(Date),DaysInMonth(Date))>
			<cfset showtop      = DayOfWeek(session.timesheet["DateStart"]) - 1>  
	  
	  </cfif>
	  	  
	  <cfquery name="getPersons" 
		  datasource="AppsEmployee" 
		  username="#SESSION.login#" 
		  password="#SESSION.dbpw#">
		  
			SELECT 	DISTINCT P.PersonNo, 
			        P.LastName, 
					P.FirstName, 
					A.FunctionDescription, 
					P.IndexNo, 
					A.LocationCode,
					A.AssignmentNo, 
					A.DateEffective, 
					A.DateExpiration
			FROM 	Person P, PersonAssignment A
			WHERE   P.PersonNo = A.PersonNo
			 <cfif getSource.recordcount gte "1">
			AND     A.PersonNo IN (#quotedValueList(getSource.PersonNo)#)			
			<cfelse>
			AND    1=0
			</cfif>
			-- AND     A.Incumbency       > '0'
			AND     A.AssignmentStatus IN ('0','1')
			< '8' <!--- planned and approved --->
			-- AND     A.AssignmentClass  = 'Regular'
			AND     A.AssignmentType   = 'Actual'
			
			AND     A.DateEffective   <= #session.timesheet["DateEnd"]#
			AND     A.DateExpiration  >= #session.timesheet["DateStart"]#		
			
	  </cfquery>	  
  
  </cfcase>
  
  <cfcase value="invoice">
  
  </cfcase>
  
</cfswitch>

<cfif getPersons.recordcount eq "0">

   <cfset client.timesheetdate = now()>

   <cfswitch expression="#url.Object#">
      
   <cfcase value="unit">
   
   		  <cfquery name="getUnit" 
			  datasource="AppsOrganization" 
			  username="#SESSION.login#" 
			  password="#SESSION.dbpw#">
			  SELECT *
			  FROM Organization
			  WHERE OrgUnit = '#url.ObjectKeyValue1#'
		   </cfquery>
		   
		   <cfoutput>
   
		   <table width="99%" align="center">
		    <tr class="line" style="height:50px;border-top:1px solid silver">
				<td align="center" class="labelmedium" style="padding-top:85px;font-size:22px">   
			   	<font color="FF0000">No staff assigned to organization level : #getUnit.OrgUnitName#</font>
				</td>
			</tr>  
			
		    <cfif getUnit.recordcount gte "1">
			
				<tr><td style="height:10px"></td></tr>	
			
				<tr style="height:40px;">
					<td align="center" class="labelmedium" style="height:28px;font-size:18px">   
				   	You likely were looking for one of the below units:
					</td>
				</tr>  
				
				 <cfquery name="MissionCheck" 
					  datasource="AppsOrganization" 
					  username="#SESSION.login#" 
					  password="#SESSION.dbpw#">
						SELECT DISTINCT Mission 
						FROM   Organization.dbo.OrganizationAuthorization OA  <!--- no link needed this is done below --->
						WHERE  UserAccount = '#SESSION.acc#' 
						AND    Mission = '#getUnit.mission#'
						AND    Role IN ('Timekeeper', 'HROfficer')
						AND    OrgUnit = '0'
				 </cfquery>
								  
				 <cfquery name="getUnits" 
					  datasource="AppsOrganization" 
					  username="#SESSION.login#" 
					  password="#SESSION.dbpw#">
					  SELECT *
					  FROM   Organization
					  WHERE  Mission        = '#getUnit.Mission#'
					  AND    MandateNo      = '#getUnit.MandateNo#'
					  AND    ParentOrgUnit  = '#getUnit.OrgUnitCode#'
					  <cfif missionCheck.recordcount gte "1" or getAdministrator("#getUnit.Mission#")>
					     <!--- no filter --->
					  <cfelse>
					  AND    OrgUnit IN ( SELECT OrgUnit  
										  FROM   OrganizationAuthorization
										  WHERE  UserAccount = '#SESSION.acc#' 
										  AND    Mission     = '#getUnit.Mission#'							  
										  AND    Role IN ('Timekeeper', 'HROfficer')
									     )		  					  							
					  </cfif>					 
				  </cfquery>				  
						
				  <cfloop query="getUnits">
				
					<tr style="height:28px">
						<td align="center" class="labelmedium" style="height:28px;font-size:18px">   
					   	<a href="#session.root#/Attendance/Application/TimeView/OrganizationListing.cfm?presentation=month&id2=#mission#&id0=#orgUnit#">#orgunitName#</a>
						</td>
					</tr>  
			   
			      </cfloop>
			
			</cfif>
			
			</cfoutput>
			 
	   </table>
      
   </cfcase>
   
   <cfdefaultcase>
	   
	   <table width="99%" align="center"><tr style="height:40px;padding-top:35px;border-top:1px solid silver"><td align="center" class="labellarge">
	   <font color="FF0000">There are no records to show in this view</td></tr>
	   </table>
   
   </cfdefaultcase>
      
   
   </cfswitch>


<cfelse>
	
	<cfquery name="class" 
	  datasource="AppsEmployee" 
	  username="#SESSION.login#" 
	  password="#SESSION.dbpw#">
		SELECT    *
		FROM      Ref_TimeClass
		WHERE     ShowInAttendance = 1
		ORDER BY  ListingOrder
	</cfquery>	
	
	<cfset cl = "">
	<cfloop query="class">
		<cfif cl eq "">
		   <cfset cl = "#TimeClass#">
		<cfelse>
		   <cfset cl = "#cl#,#TimeClass#">
		</cfif>
		<cfparam name="#timeclass#" default="#viewcolor#">
	</cfloop>	
	
		<table height="100%" width="100%">
	
		<tr><td width="100%" height="100%" valign="top">
		
				<table width="100%" height="100%">	
				
				<cfif session.timesheet["presentation"] eq "month"> 
				
					<cfset str   = "1">
					<cfset end   = "#daysinmonth(session.timesheet["DateStart"])#">
					<cfset pad   = "34"> 
					<cfset cwd   = "28">
					
				<cfelse>
				  
				    <cfset str   = "0">
		   	        <cfset end   = "41">
					<cfset pad   = "34"> 
					<cfset cwd   = "28">
				  
				</cfif>							
				
				<!--- --------- --->
				<!--- - Header- --->
				<!--- --------- --->
				
				<tr style="height:40px">					
											
					<td style="padding-right:<cfoutput>#pad#</cfoutput>px" width="100%" colspan="2">																			
						<cfinclude template="TimeSheetContentHeader.cfm">																									
					</td>
				</tr>
				
				<tr><td height="1"></td></tr>
				
				<!--- -------- --->
				<!--- - Body - --->
				<!--- -------- --->
											
				<tr><td style="height:100%;padding-right:2px" valign="top">										
				  <cfinclude template="TimesheetContentBody.cfm">												
				</td></tr>
				
				<!--- -------------- --->
				<!--- Summary footer --->
				<!--- -------------- --->
				
				<tr><td style="height:1px"></td></tr>								
				<tr>										
				<td style="padding-right:<cfoutput>#pad#</cfoutput>px" width="100%" colspan="2">
																
					<cfif url.object eq "unit">
															
						<cfoutput>						
						
						<input type="hidden" id="personlist" value="#ValueList(getPersons.PersonNo)#">						
											
						<table width="100%" border="0" class="navigation_table">
							
							<!--- get relevant activities for this month --->
							
							<cfquery name="getActivitySchema" 
							  datasource="AppsProgram" 
							  username="#SESSION.login#" 
							  password="#SESSION.dbpw#">
							  
								  SELECT *
								  FROM (
								  	  
										  SELECT   A.ActivityId,			           
												   A.ActivityDescription, 
												   A.ListingOrder,
												   
												   (SELECT ActionColor 
												    FROM   Employee.dbo.Ref_WorkActivity 
													WHERE  ActionCode  = A.ActivityId) as ActionColor,
												   
												   (SELECT count(*) 
												    FROM   ProgramActivitySchema Sx 
															INNER JOIN ProgramActivitySchemaSchedule SSx 
																ON Sx.ActivitySchemaId = SSx.ActivitySchemaId
													WHERE  Sx.ProgramCode = P.ProgramCode 
													AND    Sx.ActivityId  = A.ActivityId 
													AND    Sx.Operational = 1) as hasSchema
													
										  FROM     Program P INNER JOIN           
										           ProgramActivity A ON P.ProgramCode = A.ProgramCode 
										  WHERE    P.ProgramCode IN (								 
																	 SELECT ProgramCode  
										  							 FROM   ProgramActivity 
																	 WHERE  ProgramCode = P.ProgramCode
																	 AND    OrgUnit = '#url.ObjectKeyValue1#' 								 
																	 )
															 								 
										  AND      (A.ActivityDateStart <= #session.timesheet["DateEnd"]# or A.ActivityDateStart is NULL)
										  AND      A.ActivityDate >= #session.timesheet["DateStart"]#
										  AND 	   A.RecordStatus != '9' 	
										  ) as B
										  
								  WHERE  hasSchema > 0 
								  ORDER BY ListingOrder	
							  	  
							</cfquery>	
																																
							<cfloop query="getActivitySchema">
												
								<tr class="labelmedium line" style="height:22px">
																										
									<td width="100%" align="right" style="background-color:###actioncolor#4D;min-width:#cwd#;padding-right:23px">#ActivityDescription#</td>										
									<td id="#activityid#">	
									    
										<cfset url.activityid = activityid>																			
										<cfset url.personlist = ValueList(getPersons.PersonNo)>								
										
									    <cfinclude template="TimesheetActivity.cfm">										
									</td>										
									
								</tr>	
							
							</cfloop>				
												
						</table>
							
					</cfoutput>
					
				</cfif>
								
				</td>
			    </tr>
							
			</table>
			
		</td>
				
		</tr>
	
	</table>
					
</cfif>

<cfoutput>
<script>
    <!--- we also refresh if there is a status bar --->
	if ($('##statusbar').length > 0) {
		ptoken.navigate('#session.root#/Attendance/Application/Timeview/OrganizationAction.cfm?id0=#url.ObjectKeyValue1#&year=#year(date)#&month=#month(date)#','statusbar')
	} 
	Prosis.busy('no')
</script>
</cfoutput>

<cfinclude template="../../Attendance/Application/Timeview/Propagate/ValidatePersonSelection.cfm">

	