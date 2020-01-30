
<!--- activity view --->

<cfparam name="dte" default="#now()#">
<cfparam name="URL.edit" default="0">

<cfparam name="url.startyear"  default="#year(dte)#">
<cfparam name="url.startmonth" default="#month(dte)#">
<cfparam name="url.day"        default="#day(dte)#">

<cfinvoke component="Service.Presentation.Presentation" 
      	  method="highlight" 
		  class="highlight2"
		  returnvariable="stylescroll"/>

<cfset dateob=CreateDate(URL.startyear,URL.startmonth,URL.Day)>

<cfset st = DateAdd("d", "-#DayOfWeek(dateob) - 1#", dateob)>
<cfset ed = DateAdd("d", "6", st)>

<cfquery name="getOrganizationAction" 
	datasource="AppsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT 	*
	FROM 	OrganizationAction
	WHERE 	OrgUnit IN (
				SELECT 	PAx.OrgUnit 
				FROM 	Employee.dbo.PersonAssignment PAx 
						INNER JOIN Employee.dbo.Position POx 
							ON PAx.PositionNo = POx.PositionNo 
				WHERE 	PAx.AssignmentStatus IN ('0','1')
				AND 	#dateob# BETWEEN PAx.DateEffective AND PAx.DateExpiration
				AND		PAx.PersonNo = '#URL.id#'
			)
	AND     #dateob# BETWEEN CalendarDateStart AND CalendarDateEnd
    AND     WorkAction = 'Attendance'	
</cfquery>

<cfif getOrganizationAction.recordCount eq 0 OR getOrganizationAction.actionStatus eq "0">
	<cfset url.edit = "1">
</cfif>

<cfquery name  = "getlist" 
    datasource= "AppsEmployee" 
    username  = "#SESSION.login#" 
	password  = "#SESSION.dbpw#">      				 
	SELECT   *
	FROM     Ref_WorkAction AS R
	WHERE    Operational = 1
	ORDER BY R.ListingOrder
</cfquery>

<!--- we get the source data --->

<cfquery name  = "getdata" 
    datasource= "AppsEmployee" 
    username  = "#SESSION.login#" 
	password  = "#SESSION.dbpw#">      
				 
	SELECT   W.ActionClass, 
	         W.CalendarDate, 	
			 
			  (SELECT ViewColor
			  FROM   Employee.dbo.Ref_WorkAction
			  WHERE  ActionClass = W.ActionClass ) as ViewColor,	
			  
			 (SELECT ActionColor 
			  FROM   Employee.dbo.Ref_WorkActivity 
			  WHERE  ActionCode = A.ActivityId ) as ActionColor,	
			 		
			 A.ActivityId,
			 W.ActionCode,
			 W.ActivityPayment,
			 A.ActivityDescription,
			 A.ActivityDateStart,
			 A.ProgramCode,
			 P.ProgramName,
			 P.Mission,		
			 			 
			 ISNULL(SUM(CONVERT(Float,W.HourSlotMinutes) / 60), 0) AS Total
			 
	FROM     Program.dbo.Program P INNER JOIN
             Program.dbo.ProgramActivity A ON P.ProgramCode = A.ProgramCode RIGHT OUTER JOIN
             PersonWorkDetail W ON A.ActivityId = W.ActionCode				  		 
	
	WHERE    W.PersonNo = '#url.id#' 
		 AND W.CalendarDate >= #st# 
  	     AND W.CalendarDate <= #ed#
		 AND W.TransactionType = '1'
		 
	GROUP BY W.CalendarDate,
	         W.ActionClass, 
			 A.ActivityDateStart, 
			 A.ProgramCode, 
			 W.ActionCode, 
			 A.ActivityId, 
			 ActivityDescription, 
			 ActivityPayment, 
			 P.Mission,
			 P.ProgramName 
	ORDER BY W.CalendarDate, A.ProgramCode, A.ActivityDateStart 

</cfquery>

<cfoutput>


<table width="100%" cellspacing="0" cellpadding="0" align="center">

<tr><td height="15"></td></tr>

<tr><td>

	<table width="95%" cellspacing="0" cellpadding="0" align="center" style="border:0px solid silver">
		
	<tr class="line">
		
		<td colspan="19" class="labelmedium">
		
			<table cellspacing="0" cellpadding="0">
			<tr><td style="padding-left:10px;height:50px">
			 
				  <cfset dd = dateAdd("d",-2,st)>	  
				  <img src="#Client.VirtualDir#/Images/Back.png" height="32" width="32" style="cursor:pointer" alt="" border="0" onclick="gotoweek('#URL.ID#','#day(dd)#','#Month(dd)#','#Year(dd)#','1')">	
					  
			</td>
			<td class="labelmedium" style="padding-left:8px;padding-right:8px;width:90%" align="center">		  
				 <font color="6688aa"><b>Week <font size="6">#Week(st)#</font></b> &nbsp; #DateFormat(st,client.dateformatshow)# - #DateFormat(ed,client.dateformatshow)#
			</td>
			<td align="right" style="padding-right:10px;">
			
			<cfif ed gt now()>
			
			<cfelse>
			
				<cfset dd = dateAdd("d",+1,ed)>	  
			    <img src="#Client.VirtualDir#/Images/Next.png" height="32" width="32" style="cursor:pointer" alt="" border="0" onclick="gotoweek('#URL.ID#','#day(dd)#','#Month(dd)#','#Year(dd)#','1')">	
				
			</cfif>	
					
			</td>
			</tr>
			</table>
	
		</td>
	</tr>
		
	<tr class="line">
	<td width="28%" class="labelit" style="padding:4px;padding-left:6px"><cf_tl id="Activity"></td>
	
		<cfloop index="wk" from="1" to="7">
	
			<cfset dte = DateAdd("d", "#wk-1#", st)>
			
			<td class="labelit" align="center" style="min-width:60px;padding-left:10px;border-right:1px solid silver;padding-right:2px" colspan="2">
				
				  <!--- ------------------------------------------ --->
				  <!--- ------check if we have data for this date- --->
				  <!--- ------------------------------------------ --->
				  
				    <cfquery name="check" 
				  datasource="AppsEmployee" 
				  username="#SESSION.login#" 
				  password="#SESSION.dbpw#">
				      SELECT TOP 1 *
					  FROM   PersonWork
					  WHERE  PersonNo = '#URL.id#'
					  AND    CalendarDate = #dte#
				  </cfquery>
				  
			      <cfquery name="date" 
				  datasource="AppsEmployee" 
				  username="#SESSION.login#" 
				  password="#SESSION.dbpw#">
				      SELECT TOP 1 *
					  FROM   PersonWorkDetail S 
					  WHERE  PersonNo = '#URL.id#'
					  AND    CalendarDate = #dte#
				  </cfquery>
				
				  <!--- ---------------------------------------- --->
				  <!--- check if we have data for the prior date --->
				  <!--- ---------------------------------------- --->
				  
				  <cfquery name="priordate" 
				  datasource="AppsEmployee" 
				  username="#SESSION.login#" 
				  password="#SESSION.dbpw#">
				      SELECT TOP 1 *
					  FROM   PersonWorkDetail S 
					  WHERE  PersonNo = '#URL.id#'
					  AND    CalendarDate = '#dateformat(dte-1,client.dateSQL)#'
				  </cfquery>		
			    	
			    <table class="navigation_table" width="100%" align="center">
				
					<tr class="labelmedium">
					
						<td style="cursor:pointer" align="center">		
							<a href="javascript:entryhour('#url.id#','#day(dte)#','#month(dte)#','#year(dte)#','','1','week')">#DayOfWeekAsString(wk)#</a>
						</td>
					
						<td align="right" valign="top" style="padding-top:3px;padding-right:3px">
					
					  		<cfif (check.source eq "Manual" OR check.recordcount eq 0) and url.edit eq "1">
											
						  	<cfif priordate.recordcount gte "1" and date.recordcount eq "0">
						    
							 <img src="#Client.VirtualDir#/Images/copy4.gif" alt="Copy from Prior date : #dateformat(dte-1,CLIENT.DateFormatShow)#" 
							   height="16" style="cursor:pointer"
							   width="16" 
							   align="absmiddle" 					  
							   border="0" 
							   onclick="javascript:hourcopy('#url.id#','#dateformat(dte,CLIENT.DateFormatShow)#','#dateformat(dte-1,CLIENT.DateFormatShow)#','week')">							 
							   
						  	<cfelseif date.recordcount gte "1">
						  
						   	<img src="#Client.VirtualDir#/Images/delete5.gif" alt="Remove entries for date : #dateformat(dte,CLIENT.DateFormatShow)#" 
							   height="12" style="cursor:pointer"
							   width="12" 
							   align="absmiddle"				   
							   border="0" 
							   onclick="javascript:hourdel('#URL.ID#','#dateformat(dte,CLIENT.DateFormatShow)#','','','week')">	
						  	</cfif>
					  		</cfif>
						</td>
					</tr>
					
					<tr>
						<td colspan="2" align="right">
							<cf_tl id="Modality-1">
						</td>	
					</tr>	
				</table> 
				  
			</td>
			
		
		</cfloop>
	
		<td width="7%" class="labelit"  align="right" style="padding:4px;padding-left:4px">Total (hrs)</td>
		<td width="7%" class="labelit"  align="right" style="padding:4px;padding-left:4px"><cf_tl id="Modality-1"></td>
		<td width="7%" class="labelit"  align="right" style="padding:4px;padding-left:4px"><cf_tl id="Modality-2"></td>
		<td width="7%" class="labelit"  align="right" style="padding:4px;padding-left:4px"><cf_tl id="Percent"></td>
	
	</tr>
	
	</cfoutput>
	
	
	
	<cfquery name="getOverall"         
	         dbtype="query">
			 SELECT SUM(Total) as Total
			 FROM  getData			
	</cfquery>		
	
	<!--- ------------ --->
	<!--- content rows --->
	<!--- ------------ --->	
	
	<cfoutput query="getList">
	
	<tr class="labelmedium">
		<td style="padding-left:20px;border-right:1px dotted gray;background-color:###viewColor#4D;padding:4px">#ActionDescription#</b></td>
			
			<cfloop index="wk" from="1" to="7">
					
				<td align="right" style="border-right:1px solid silver;padding-right:7px;;background-color:###viewColor#33">		
				
					<cfquery name="getHours"         
					         dbtype="query">
							 SELECT SUM(Total) as Total
							 FROM   getData
							 WHERE  ActionClass = '#ActionClass#'
							 AND    CalendarDate = #dateAdd("d","#wk-1#",st)#
					</cfquery>
					<cfif getHours.Total eq "">
					-
					<cfelse>
					<b>#getHours.Total#</b></font>
					</cfif>
					
				</td>
				
				<td align="right" style="border-right:1px solid silver;padding-right:7px;;background-color:###viewColor#33">
					<cfquery name="getHours"         
					         dbtype="query">
							 SELECT SUM(Total) as Total
							 FROM   getData
							 WHERE  ActionClass = '#ActionClass#'
							 AND    CalendarDate = #dateAdd("d","#wk-1#",st)#
							 AND    ActivityPayment = '1'
					</cfquery>
					<cfif getHours.Total eq "">
					-
					<cfelse>
					<b>#getHours.Total#</b></font>
					</cfif>

				</td>	
			
			</cfloop>
			
			<td align="right" style="padding-right:6px;border-right:1px solid silver;background-color:###viewColor#4D;border-left:1px solid gray;">
			
			    <cfquery name="getHours"         
				         dbtype="query">
						 SELECT SUM(Total) as Total
						 FROM  getData
						 WHERE ActionClass = '#ActionClass#'					
				</cfquery>
				<cfif getHours.Total eq "">
				-
				<cfelse>
				<b>#getHours.Total#
				</cfif>
			
			</td>
			
			<td align="right" style="padding-right:6px;border-right:1px dotted silver;background-color:###viewColor#4D;border-left:1px solid gray;">
			
			    <cfquery name="getHours"         
				         dbtype="query">
						 SELECT SUM(Total) as Total
						 FROM  getData
						 WHERE ActionClass = '#ActionClass#'	
						 AND   ActivityPayment = '1'					
				</cfquery>
				<cfif getHours.Total eq "">
				-
				<cfelse>
				<b>#getHours.Total#
				</cfif>
			
			</td>
			
			<td align="right" style="padding-right:6px;border-right:1px dotted silver;background-color:###viewColor#4D;border-left:1px solid gray;">
			
			    <cfquery name="getHours"         
				         dbtype="query">
						 SELECT SUM(Total) as Total
						 FROM  getData
						 WHERE ActionClass = '#ActionClass#'	
						 AND   ActivityPayment = '2'					
				</cfquery>
				<cfif getHours.Total eq "">
				-
				<cfelse>
				<b>#getHours.Total#
				</cfif>
			
			</td>
			
			<td align="right" style="padding-right:6px;border-right:1px dotted silver;background-color:###viewColor#4D;border-left:1px solid gray;">
						
					<cfif getHours.Total neq "" and getOverall.Total neq "" and getOverall.Total neq "0">
																
					<cfset perc = (getHours.Total/getOverall.Total)*100>					
					#numberformat(perc,"__")# %										
					</cfif>
					
			</td>			
				
	  </tr>
	  
	  <!--- ---------------------- --->
	  <!--- subrow for an activity --->
	  <!--- ---------------------- --->	
					
	  <cfif ProgramLookup eq "1">
			
			<cfquery name="getActivity"         
			         dbtype="query">
					 SELECT DISTINCT ProgramCode, 
					                 ProgramName, 
									 ActionCode,
									 ActivityDescription,
									 ActionColor
					 FROM  getData
					 WHERE ActionClass = '#ActionClass#'					 
					 ORDER BY ActivityDateStart
			</cfquery>
			
			<cfset prior = "">
			
			<cfloop query="getActivity">
			
				<cfif actioncode neq "">
				
					<!--- program header --->
					<cfif programcode neq prior>						
						<tr><td colspan="1" style="border-right:1px dotted gray;padding:1px;padding-left:10px" class="labelmedium">#ProgramName#</td></tr>					
					</cfif>
					
					<cfset prior = ProgramCode>
				
					<tr class="labelmedium line navigation_row">	
						<td style="background-color:###actionColor#4D;border-right:1px solid silver;padding:3px;padding-left:15px">#ActivityDescription#</td>
						<cfloop index="wk" from="1" to="7">
						
							<cfset sdte = dateAdd("d","#wk-1#",st)>
										
							<cfquery name="getHours"         
						         dbtype="query">
								 SELECT SUM(Total) as Total
								 FROM   getData
								 WHERE  ActionClass = '#getList.ActionClass#'
								 AND    ActionCode  = '#ActionCode#'
								 AND    CalendarDate = #dateAdd("d","#wk-1#",st)#
							</cfquery>			
										
							<cfif getHours.Total eq "0">
								<td align="right" style="border-right:1px solid silver;padding-right:7px"></td>
							<cfelse>
							<td align="right" style="background-color:###actionColor#33;cursor:pointer;border-right:1px solid silver;padding-right:7px"
							onclick="javascript:entryhour('#url.id#','#day(sdte)#','#month(sdte)#','#year(sdte)#','0','0','week','#getList.ActionClass#','#ActionCode#')">
							    <table><tr class="labelmedium"><td>#getHours.Total#</td></tr></table>
							</td>
							</cfif>
							
							<cfquery name="getHours"         
						         dbtype="query">
								 SELECT SUM(Total) as Total
								 FROM   getData
								 WHERE  ActionClass = '#getList.ActionClass#'
								 AND    ActionCode  = '#ActionCode#'
								 AND    CalendarDate = #dateAdd("d","#wk-1#",st)#
								 AND    ActivityPayment = '1'
							</cfquery>			
							
							<cfif getHours.Total eq "0">
								<td align="right" style="border-right:1px solid silver;padding-right:7px"></td>
							<cfelse>
							<td align="right" style="background-color:###actionColor#33;cursor:pointer;border-right:1px solid silver;padding-right:7px"
							onclick="javascript:entryhour('#url.id#','#day(sdte)#','#month(sdte)#','#year(sdte)#','0','0','week','#getList.ActionClass#','#ActionCode#')">
							    <table><tr class="labelmedium"><td>#getHours.Total#</td></tr></table>
							</td>
							</cfif>
						
						</cfloop>
						
						
						
						<td align="right" style="background-color:###actionColor#4D;border-right:1px solid silver;padding-right:7px">
					
						    <cfquery name="getHours"         
						         dbtype="query">
								 SELECT SUM(Total) as Total
								 FROM  getData
								 WHERE ActionClass  = '#getList.ActionClass#'
								 AND   ActionCode  = '#ActionCode#'				
							</cfquery>
							<cfif getHours.Total eq "">
							-				
							<cfelse>
							#getHours.Total#
							</cfif>
					
						</td>		
						
						<td align="right" style="background-color:###actionColor#4D;border-right:1px solid silver;padding-right:7px">
					
						    <cfquery name="getMod"         
						         dbtype="query">
								 SELECT SUM(Total) as Total
								 FROM  getData
								 WHERE ActionClass  = '#getList.ActionClass#'
								 AND   ActionCode  = '#ActionCode#'		
								 AND   ActivityPayment = '1'		
							</cfquery>
							<cfif getMod.Total eq "">
							-				
							<cfelse>
							#getMod.Total#
							</cfif>
					
						</td>			
						
						
						<td align="right" style="background-color:###actionColor#4D;border-right:1px solid silver;padding-right:7px">
					
						    <cfquery name="getMod"         
						         dbtype="query">
								 SELECT SUM(Total) as Total
								 FROM  getData
								 WHERE ActionClass  = '#getList.ActionClass#'
								 AND   ActionCode  = '#ActionCode#'				
								 AND   ActivityPayment = '2'
							</cfquery>
							<cfif getMod.Total eq "">
							-				
							<cfelse>
							#getMod.Total#
							</cfif>
					
						</td>				
						
						<td align="right" style="background-color:###actionColor#4D;border-right:1px solid silver;padding-right:7px">
						
							<cfif getHours.Total neq "" and getOverall.Total neq "">						
							<cfset perc = (getHours.Total/getOverall.Total)*100>						
							#numberformat(perc,"__")# %						
							</cfif>
						
						</td>					
						
					</tr>
				
				</cfif>
			
			</cfloop>
			
		</cfif>
				
	</cfoutput>
	
	<cfoutput>
		
	<!--- ------------------ --->
	<!--- ----total rows---- --->
	<!--- ------------------ --->	
	
	<tr><td colspan="19" class="line"></td></tr>
		
	<tr class="line">	
		<td class="labelmedium" style="padding:4px"><cf_tl id="Total"></td>
		<cfloop index="wk" from="1" to="7">
		
			<cfquery name="getHours"         
			    dbtype="query">
					 SELECT SUM(Total) as Total
					 FROM  getData
					 WHERE CalendarDate = #dateAdd("d","#wk-1#",st)#
			</cfquery>					
			
			<td class="label" align="right" style="padding:4px;border-right:1px solid silver">
					<cfif getHours.Total eq "">
					-
					<cfelse>
						<font size="3">#getHours.Total#
					</cfif>
			</td>
			<td align="right" style="padding:4px;border-right:1px solid silver">
				
				<cfquery name="getHours"         
				    dbtype="query">
						 SELECT SUM(Total) as Total
						 FROM  getData
						 WHERE CalendarDate = #dateAdd("d","#wk-1#",st)#
						 AND   ActivityPayment = '1'				
				</cfquery>					
				
					<cfif getHours.Total eq "">
					-
					<cfelse>
						<font size="3">#getHours.Total#</font>
					</cfif>
			</td>
		
		</cfloop>
						
		<td class="label" align="right" style="padding-right:9px;border-right:1px solid silver">
		
		<cfif getOverall.Total eq "">
				-
				<cfelse>
				<font size="3">#getOverall.Total#
				</cfif>
		
		</td>
		
		<td align="right" style="padding-right:9px;border-right:1px solid silver">
				<cfquery name="getHours"         
				    dbtype="query">
						 SELECT SUM(Total) as Total
						 FROM  getData
						 WHERE ActivityPayment = '1'				
				</cfquery>					
				<cfif getHours.Total eq "">
				-
				<cfelse>
					<font size="3">#getHours.Total#</font>
				</cfif>			
		</td>
		<td align="right" style="padding-right:9px;border-right:1px solid silver">
				<cfquery name="getHours"         
				    dbtype="query">
						 SELECT SUM(Total) as Total
						 FROM  getData
						 WHERE ActivityPayment = '2'				
				</cfquery>					
				<cfif getHours.Total eq "">
				-
				<cfelse>
					<font size="3">#getHours.Total#</font>
				</cfif>			
		</td>
		
		<td class="label" align="right" style="padding-right:9px;border-right:1px solid silver">
		
			<cfif getHours.Total neq "" and getOverall.Total neq "">
						
				<cfset perc = (getOverall.Total/getOverall.Total)*100>						
				<font size="3">#numberformat(perc,"__")# %
						
			</cfif>
		
		</td>
			
	</tr>	
	
	</table>

</td></tr>

</table>

</cfoutput>

<cfset ajaxonload("doHighlight")>

<script>
		  
	  Prosis.busy('no')	

</script>

