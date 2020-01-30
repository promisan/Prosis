
<cf_tl id="Do you want to remove this schedule ?" var="confirmMess">

<cfinvoke component="Service.Access"  
  method         = "position" 
  mission        = "#URL.Mission#" 
  role           = "'HRPosition'"
  returnvariable = "accessPosition">	

<cfparam name="url.mandate" default="">

<table width="95%" align="center">

	<tr><td style="font-size:25px;height:45" class="labellarge"><cf_tl id="Workforce schedules"></td></tr>

	<tr>
		<td style="padding-left:5px">
			<cfinvoke component = "Service.Presentation.TableFilter"  
			   method           = "tablefilterfield" 
			   filtermode       = "direct"
			   name             = "filtersearch"
			   style            = "font:15px;height:35px;width:250px;"
			   rowclass         = "clsWarehouseRow"
			   rowfields        = "ccontent">
		</td>
	</tr>
		
	<cfquery name="get" 
		datasource="AppsEmployee" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT   *, R.Description as Class,
		         (SELECT MAX(CalendarDate) 
			      FROM   WorkScheduleDateHour 
				  WHERE  WorkSchedule = D.Code) as lastDate
		FROM     WorkSchedule D, Ref_ScheduleClass R
		WHERE    Mission   = '#URL.Mission#'	
		AND      D.ScheduleClass = R.Code
		AND      Operational = 1
		ORDER BY R.ListingOrder, D.ListingOrder, D.Description
	</cfquery>		
	
	<tr><td style="padding:20px">
	
	<table width="100%" class="navigation_table" border="0" cellspacing="0" cellpadding="0">
	
	<tr class="labelmedium line">
		
		<td width="10%"><cf_tl id="Class"></td>		
		<td width="30%"><cf_tl id="Name"></td>			
		<td width="10%"><cf_tl id="Mode"></td>					
		<td width="20%"><cf_tl id="Last rec date"></td>
		<td width="10%"><cf_tl id="Officer"></td>	
		<td width="10%"><cf_tl id="Created"></td>	
		<td width="10%" style="padding-right:5px;" align="right">
		 <cfif accessPosition eq "ALL">
			<cfoutput>
				<a href="javascript:editWorkSchedule('#URL.Mission#', '#url.mandate#', '');" style="color:0080FF;">
					[<cf_tl id="Add">]
				</a>
			</cfoutput>
		  </cfif>	
		</td>
	</tr>	
			
	<cfoutput query="get" group="Class">	

	<tr class="line">	
	<td class="labelmedium ccontent" colspan="5" style="height:26;padding-left:3px">#Class#</b></td>
	</tr>
	
	<cfoutput>

	<tr class="clsWarehouseRow">
		<td colspan="7">
			<table width="100%">
				<tr class="labelmedium navigation_row">
	  
				  <td bgcolor="white" style="padding-left:3px" width="10%"></td>	  
				  <td style="padding-left:4px" class="ccontent" width="30%">#Description# (#code#)</td>	
				  <td width="10%">#Hourmode#</td>  	 	 
				  <td width="20%">#DateFormat(LastDate,client.dateformatshow)#</td>
				  <td width="10%">#OfficerLastName#</td>
				  <td width="10%">#DateFormat(created,client.dateformatshow)#</td>	
				  
				  <td style="padding-top:2px; padding-right:5px;" align="right" width="10%">
				  	<table>
						<tr>
							<cfif accessPosition eq "ALL">
								<td style="padding-left:8px;">
									<cfif lastDate lt now()>
										<cf_img icon="delete" onclick="if (confirm('#confirmMess#')) { #ajaxLink('#client.root#/staffing/application/workschedule/planning/setSchedule.cfm?workschedule=#code#&mission=#url.mission#&mandate=#url.mandate#')# }">
									</cfif>
								</td> 
								<td style="padding-left:8px;">				
									<cf_tl id="Edit Schedule Definition" var="vEditSchedule">
									<cf_img tooltip="#vEditSchedule#"  icon="edit" onclick="editWorkSchedule('#URL.Mission#', '#url.mandate#', '#Code#');">					
								</td>
							</cfif>
											
							<td style="padding-left:8px;padding-right:6px">
								<cf_tl id="Edit Schedule" var="vEdit">
								<cf_img tooltip="#vEdit#" icon="calendar" navigation="Yes" onclick="#ajaxLink('#client.root#/staffing/application/workschedule/planning/PlanningView.cfm?workschedule=#code#&mission=#url.mission#&mandate=#url.mandate#')#">		
							</td>
						</tr>
					</table>
				  </td>  
				
			    </tr>	
				
					<cfquery name="getUnits" 
						datasource="AppsEmployee" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">			
						SELECT DISTINCT O.OrgUnitName, O.MandateNo, P.OrgUnitName AS ParentName
						FROM         WorkScheduleOrganization W INNER JOIN
			                      Organization.dbo.Organization O ON W.OrgUnit = O.OrgUnit LEFT OUTER JOIN
			                      Organization.dbo.Organization P ON O.MandateNo = P.MandateNo AND O.Mission = P.Mission AND O.ParentOrgUnit = P.OrgUnitCode
						WHERE     W.WorkSchedule = '#code#'
						ORDER BY O.MandateNo		
					</cfquery>		
					
					<cfloop query="getUnits">
						<tr class="navigation_row_child">
						   <td bgcolor="white"></td>			  
						   <td></td>			 	 
						    <td></td>
						   <td class="labelit ccontent" colspan="5"><font color="808080">#MandateNo# <cfif ParentName neq "">#ParentName#/</cfif>#OrgUnitName#</td>
						</tr>	
					</cfloop>
					
				<tr><td colspan="7" class="line"></td></tr>
			</table>
		</td>
	</tr>
	
	</cfoutput>
	
	</cfoutput>

</table>

<cfset AjaxOnLoad("doHighlight")>
