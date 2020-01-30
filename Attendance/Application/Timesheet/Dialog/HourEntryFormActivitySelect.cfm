	<cfset dateValue = "">
	<CF_DateConvert Value="#url.date#">
	<cfset dte = dateValue>
	
<!--- remember --->

<cfparam name="url.slot"        default="">
<cfparam name="url.actionclass" default="">
<cfparam name="url.actioncode"  default="">
	
<cfif url.hour eq "">

	<cfquery name="Last" 
	  datasource="AppsEmployee" 
	  username="#SESSION.login#" 
	  password="#SESSION.dbpw#">
	      SELECT TOP 1 * 
		  FROM   PersonWorkDetail
		  WHERE  PersonNo = '#URL.ID#'
		  ORDER BY Created DESC
	</cfquery>
	
<cfelse>
	
	<cfif url.slot eq "" or url.slot eq "undefined">
	  <cfset slot = "1">
	<cfelse>
	  <cfset slot = url.slot>  
	</cfif>
	
	<cfif url.actionclass eq "" or url.actionclass eq "undefined">
	  <cfset actionclass = "">
	<cfelse>
	  <cfset actionclass = url.actionclass>  
	</cfif>
	
	<cfif url.actioncode eq "" or url.actioncode eq "undefined">
	  <cfset actioncode = "">
	<cfelse>
	  <cfset actioncode = url.actioncode>  
	</cfif>

	<!--- we determine the relevant selection for this so we can
	 show relevant information selected --->
	 
	 <cfquery name="Last" 
	  datasource="AppsEmployee" 
	  username="#SESSION.login#" 
	  password="#SESSION.dbpw#">
	      SELECT TOP 1 * 
		  FROM   PersonWorkDetail
		  WHERE  PersonNo         = '#URL.ID#'
		   AND   CalendarDate     = #dte#		  
		   AND   (
		          
				  (CalendarDateHour = '#URL.Hour#' and HourSlot = '#slot#')
				  
				  OR 
				  
		          (ActionClass = '#actionclass#'  <cfif actioncode neq "">  AND ActionCode = '#actioncode#' </cfif>)
				  
				 )
	</cfquery>	
		  
</cfif>		 

<cfquery name="WorkActions" 
  datasource="AppsEmployee" 
  username="#SESSION.login#" 
  password="#SESSION.dbpw#">
      SELECT * 
	  FROM   Ref_WorkAction
	  WHERE  ActionClass = '#URL.actionclass#'
	  AND    Operational = 1
</cfquery>

<cfset dateValue = "">
<CF_DateConvert Value="#url.date#">
<cfset dte = dateValue>

<cfif WorkActions.ProgramLookup eq "1">
	
	<cfquery name="assign" 
	datasource="AppsEmployee" 
	username="#SESSION.login#" 
	      password="#SESSION.dbpw#">
	  	    SELECT 	Pos.PositionParentId, P.*, O.OrgUnit, O.OrgUnitName
	      	FROM 	Position Pos, PersonAssignment P, Organization.dbo.Organization O
	  		WHERE	Pos.Positionno = P.PositionNo
			AND     P.DateEffective    <= #dte# 
			AND     P.DateExpiration   >= #dte#
			AND     P.Incumbency       > '0'
			AND     P.AssignmentStatus < '8' <!--- planned and approved --->
	        AND     P.AssignmentClass = 'Regular'
	        AND     P.AssignmentType  = 'Actual'
	       	AND     P.OrgUnit         = O.OrgUnit
	  		AND     P.PersonNo        = '#URL.ID#'
	</cfquery>
		
	<cfquery name="getWork" 
	  datasource="AppsProgram" 
	  username="#SESSION.login#" 
	  password="#SESSION.dbpw#">
	  
	  SELECT *
	  FROM (
	  	  
	  SELECT   A.ProgramCode AS ProgramCode, 
	           A.ActivityPeriod as Period,
	           P.ProgramName,
	           Pe.PeriodDescription as ProgramDescription, 
			   A.ActivityDescription, 
			   A.ListingOrder,
			   A.ActivityId,
			   A.Reference,
			   (SELECT count(*) 
			    FROM   ProgramActivitySchema 
				WHERE  ProgramCode  = P.ProgramCode 
				AND    ActivityId   = A.ActivityId 
				AND    Operational  = 1) as hasSchema,
			
			    (SELECT count(*) 
			    FROM    ProgramActivitySchema 
				WHERE   ProgramCode = P.ProgramCode 
				AND     ActivityId = A.ActivityId 
				AND     Weekday = '#dayofweek(dte)#'
				and     Operational = 1) as hasSchemaWeekDay	
				
	  FROM     Program P INNER JOIN           
	           ProgramActivity A ON P.ProgramCode = A.ProgramCode INNER JOIN
			   ProgramPeriod Pe ON A.ProgramCode = Pe.ProgramCode AND A.ActivityPeriod = Pe.Period
	  WHERE    P.ProgramCode IN (SELECT ProgramCode  
	  							 FROM   ProgramActivityPerson
								 WHERE  ProgramCode = P.ProgramCode
								 AND    ActivityId  = A.ActivityId
								 AND    PersonNo = '#URL.ID#'
								 
								 UNION
								 
								 SELECT ProgramCode  
	  							 FROM   ProgramPeriodOfficer
								 WHERE  ProgramCode = P.ProgramCode
								 AND    PersonNo = '#URL.ID#'
								 
								 UNION
								 
								 SELECT ProgramCode  
	  							 FROM   ProgramActivity 
								 WHERE  ProgramCode = P.ProgramCode
								 AND    OrgUnit = '#assign.orgunit#' 
	  								 
								 UNION
								 
								 SELECT ProgramCode  
	  							 FROM   Employee.dbo.PositionParentFunding
								 WHERE  PositionParentId = '#assign.PositionParentId#'
								 AND    ProgramCode = P.ProgramCode
								 AND    DateEffective <= #dte# 
								 
								 )
						 								 
	  AND      (A.ActivityDateStart <= #dte# or A.ActivityDateStart is NULL)
	  AND      A.ActivityDate >= #dte#  
	  AND 	   A.RecordStatus != '9' 	
	  ) as B
	  WHERE  hasSchema = 0 or hasSchemaWeekDay > 0
	  ORDER BY Reference, ListingOrder, hasSchema DESC 	
	  
	  	  	  
	</cfquery>	
	
	<cfif getWork.recordcount gte "1">
			
		<table style="width:100%">
		
		<cfif getWork.recordcount gte "5">
		
		<tr><td>
		
			<cfinvoke component = "Service.Presentation.TableFilter"  
				   method           = "tablefilterfield" 
				   filtermode       = "auto"
				   name             = "#URL.actionclass#filtersearch"
				   style            = "font:14px;height:24;width:130"
				   rowclass         = "clsDetail"
				   rowfields        = "cactivity">							
			
		</tr>
		
		</cfif>
		
		<tr><td valign="top" style="width:100%;padding-left:5px;min-height:160px;height:230px;max-height:230px">
				
		<cf_divscroll style="width:100%">
		
			<table width="100%" align="center">
			   		   		 				
				<cfoutput query="getWork" group="ProgramCode">
				
					<tr class="line labelmedium"> 
						<td height="17" colspan="2" style="padding-right:5px">#ProgramName#</td>
					</tr>
									
					<cfoutput>
									
					<cfif ActivityDescription neq "">
					
					<cfif Last.ActionCode eq ActivityId>
					   <cfset cl = "highlight2"> 
					<cfelse>
					   <cfset cl = "regular">
					</cfif>								
										
					<cfquery name="Activity" 
					  datasource="AppsEmployee" 
					  username="#SESSION.login#" 
					  password="#SESSION.dbpw#">
					      SELECT * 
						  FROM   Ref_WorkActivity
						  WHERE  ActionCode = '#ActivityId#'	
					</cfquery>					
										
					<tr class="clsDetail"><td>
										
					<table width="98%">
															
						<tr class="#cl# labelmedium" 
						    id="r#URL.actionclass#_#currentrow#" 
							style="cursor:pointer;height:15px"
							onmouseover="if (this.className=='regular') {this.className='highlight4'}"
							onmouseout="if (this.className=='highlight4') {this.className='regular'}"
							onclick="selectact('#activityid#','#URL.actionclass#','#currentrow#');">
							
							<td width="30" style="padding-left:15px" align="center">
								<table style="height:100%;width:100%">
									<tr><td style="height:13px;min-width:12px;border:1px solid gray;background-color:#Activity.actioncolor#"></td></tr>
								</table>
							</td>					
							
							<td style="padding-left:8px;font-size:14px" class="cactivity">#ActivityDescription#</td>					
						</tr>
					
					</table>
					
					</td>
					</tr>
					
					</cfif>
					
					</cfoutput>
			    
				</cfoutput>
				
			</table>
		
		</cf_divscroll>
			
		</td>
	</tr>	
	</table>	
	
	</cfif>

			
</cfif>
