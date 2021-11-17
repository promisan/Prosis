
<!--- filter by owner of the position --->

<cfset mission = "">

<cfloop index="itm" list="#url.mission#" delimiters="__">

	<cfif mission eq "">
		<cfset mission = "'#itm#'">
	<cfelse>
		<cfset mission = "#mission#,'#itm#'">
	</cfif>	
	
</cfloop>

<cfparam name="url.orgunit" default="">

<cfif url.orgunit eq "0">
	<cfset unit = "">
<cfelse>
	<cfset unit = url.orgunit>	
</cfif>
<cfparam name="url.period"  default="">
<cfparam name="url.actor"   default="">
<cfparam name="url.layout"  default="trigger">
<cfparam name="url.sort"    default="ActionEffective">
<cfparam name="url.stage"   default="Pending">

<cfif url.orgunit neq "">

	<cfquery name="get" 
	     datasource="AppsOrganization" 
	     username="#SESSION.login#" 
	     password="#SESSION.dbpw#">	
		 SELECT * 
		 FROM   Organization 
		 WHERE  OrgUnit = '#url.orgunit#' 
	</cfquery>
	
</cfif>

<cfquery name="base" 
	     datasource="AppsEmployee" 
	     username="#SESSION.login#" 
	     password="#SESSION.dbpw#">	

	SELECT     Sub.Mission, 
	
	           <cfif unit neq "">
	           P.OrgUnit, 
			   P.OrgUnitName, 
			   </cfif>
			   Sub.Source,
			   Sub.EventYear, 
			   Sub.EventMonth, 
			   Sub.ActionStatus, 
			   Sub.EventTrigger, 
			   Sub.EventTriggerName, 
			   Sub.EventCode, 
			   Sub.EventName, 
	           Sub.Actor, 
			   COUNT(*) AS Actions
						  
	FROM         (SELECT    Pe.Mission, 
	
							(CASE WHEN OrgUnit = '0' THEN
	                                (SELECT    OrgUnitOperational
	                                 FROM      Position
	                                 WHERE     PositionNo = Pe.PositionNo) ELSE OrgUnit END) AS OrgUnit, 
									 
							 Pe.ActionStatus, 
							 
							 <cfif url.sort eq "EventMonth">
								 YEAR(CASE WHEN Pe.DateEventDue  is NULL THEN Pe.DateEvent ELSE Pe.DateEventDue END) AS EventYear, 
								 MONTH(CASE WHEN Pe.DateEventDue is NULL THEN Pe.DateEvent ELSE Pe.DateEventDue END) AS EventMonth,                      						
							 <cfelse>
								 YEAR(CASE WHEN Pe.ActionDateEffective  is NULL THEN Pe.DateEvent ELSE Pe.ActionDateEffective END) AS EventYear, 
								 MONTH(CASE WHEN Pe.ActionDateEffective is NULL THEN Pe.DateEvent ELSE Pe.ActionDateEffective END) AS EventMonth,
							 </cfif>
							 
						     Pe.EventTrigger, 
							 R.Description AS EventTriggerName, 
							 Pe.EventCode, 
							 E.Description AS EventName,
							 Pe.Source,
	                         
	                         (SELECT     TOP 1 U.Account
	                          FROM       Organization.dbo.OrganizationObjectActionAccess AS OOAA INNER JOIN
	                                     Organization.dbo.OrganizationObjectAction AS OOA ON OOAA.ObjectId = OOA.ObjectId INNER JOIN
	                                     System.dbo.UserNames AS U ON OOAA.UserAccount = U.Account INNER JOIN
	                                     Organization.dbo.OrganizationObject AS OO ON OOAA.ObjectId = OO.ObjectId
	                          WHERE      OO.ObjectKeyValue4 = Pe.EventId AND OOAA.AccessLevel = 1
	                          ORDER BY   OOAA.Created DESC) AS Actor
														
	            FROM       dbo.PersonEvent AS Pe INNER JOIN
	                       dbo.Ref_EventTrigger AS R ON Pe.EventTrigger = R.Code INNER JOIN
	                       dbo.Ref_PersonEvent AS E ON Pe.EventCode = E.Code
						   
	            WHERE      Pe.ActionStatus IN ('0','1','2','3')) AS Sub 
						   
		   <cfif Unit neq "">			   
		   INNER JOIN     Organization.dbo.Organization AS O ON Sub.OrgUnit = O.OrgUnit 
		   INNER JOIN     Organization.dbo.Organization AS P ON O.Mission = P.Mission AND O.MandateNo = P.MandateNo AND O.HierarchyRootUnit = P.OrgUnitCode						  
			</cfif>			  
						  
	WHERE  Sub.Mission IN (#preserveSingleQuotes(mission)#) 
	
	<cfif url.period eq "All">
		AND    Sub.EventYear >= '2015'
	<cfelse>
		AND    Sub.EventYear  = '#url.period#' 	
	</cfif>
	
	<cfif Unit neq "">
	AND    P.OrgUnit = '#url.orgunit#' 
	</cfif>		
	
	<cfif url.stage eq "">
	<cfelseif url.stage eq "pending">
	AND        ActionStatus < '3'	
	<cfelse>
	AND        ActionStatus = '3'
	</cfif>
						  
	GROUP BY Sub.Mission, 
	         Sub.OrgUnit, 
			 <cfif unit neq "">
			 P.OrgUnit, 
	         P.OrgUnitName,
			 </cfif>
			 Sub.ActionStatus, 
			 Sub.EventTrigger, 
			 Sub.EventTriggerName, 
			 Sub.Source,
			 Sub.EventCode, 
			 Sub.EventName, 
			 Sub.EventYear, 
			 Sub.EventMonth, 
			 Sub.Actor 
								  
	ORDER BY Sub.Mission, Sub.OrgUnit, Sub.EventYear, Sub.EventMonth, Sub.ActionStatus, Sub.EventTrigger
		
</cfquery>

<!--- check if actor has events recorded --->

<cfquery name="check" dbtype="query">
	    SELECT     *			   
	    FROM       Base		
		WHERE      Actor = '#url.actor#'			
</cfquery>	

<cfif check.recordcount eq "0">
	<cfset user = "">
<cfelse>
	<cfset user = url.actor>
</cfif>

<table width="100%" height="100%"  class="navigation_table" id="PersonEventMainContainer">

<tr>
					
	<td width="250" valign="top" style="height:150px;padding-top:8px">
	
	  <table height="100%" border="0">
	 
	 	  <tr><td valign="top" align="center" style="padding-top:7px;">
		  
		  	<table><tr><td>
		  				  
			  <cfquery name="Summary" dbtype="query">
				    SELECT     EventTrigger,
					           EventTriggerName, 		          				 
							   SUM(Actions) as Counted					   
				    FROM       Base		
					<cfif user neq "">
					WHERE      Actor = '#user#'
					</cfif>						
				    GROUP BY   EventTrigger,EventTriggerName    
					ORDER BY   EventTriggerName
			  </cfquery>				  					
				
			  <cfset vColorlist = "##D24D57,##52B3D9,##E08283,##E87E04,##81CFE0,##2ABB9B,##5C97BF,##9B59B6,##E08283,##663399,##4DAF7C,##87D37C">
			  <cf_getChartStyle chartLocation="#GetCurrentTemplatePath()#">
			  			  			  
			  <cfchart style = "#chartStyleFile#" 
				       format="png"
				       chartheight="350" 
					   chartwidth="540"    			  
				       seriesplacement="default"	 
					   showborder="No"
					   show3d="no"
					   fontsize="12" 
					   scaleFrom = "0"  					   
					   showlegend="yes"
					   pieslicestyle="solid"
					   showxgridlines="yes"
				       sortxaxis="yes">	
										
					   <cfchartseries
			             type="pie"
			             query="Summary"				 
			             itemcolumn="EventTriggerName"
			             valuecolumn="Counted"
						 datalabelstyle="value"
			             serieslabel="Events by Trigger"						
						 seriescolor = "EB974E" 				 			 
					     colorlist="#vColorlist#"/>			
					 
				</cfchart>	
				
				</td>
				<td>			
			  <cfquery name="Summary" dbtype="query">
				    SELECT     Source,							            				 
							   SUM(Actions) as Counted					   
				    FROM       Base		
					<cfif user neq "">
					WHERE      Actor = '#user#'
					</cfif>						
				    GROUP BY   Source   
					ORDER BY   Source
			  </cfquery>	
				
				 <cfchart style = "#chartStyleFile#" 
				       format="png"
				       chartheight="300" 
					   chartwidth="350"    			  
				       seriesplacement="default"	 
					   showborder="No"
					   show3d="no"
					   fontsize="12" 
					   scaleFrom = "0"  					   
					   showlegend="no"
					   pieslicestyle="solid"
					   showxgridlines="yes"
				       sortxaxis="yes">	
														
						 
						  <cfchartseries
			             type="bar"
			             query="Summary"				 
			             itemcolumn="Source"
			             valuecolumn="Counted"						 
			             serieslabel="Events by Source"						
						 seriescolor = "EB974E" 				 			 
					     colorlist="#vColorlist#"/>		 
						 
				</cfchart>	
				
				</td></tr></table>
										
		</td></tr>
		</table>
	
	</td>
	
	</tr>
		
	<cfif url.stage eq "">
		<cfset width = "32">
	<cfelse>
		<cfset width = "55">	
	</cfif>
		
	<tr>
				
	<!--- summary table --->
	
	<cfif url.layout eq "Event">

		<cfquery name="getList" dbtype="query">
	        SELECT     EventCode as FieldRow, 
			           EventName as FieldRowName, 
					   EventYear,
					   ActionStatus, 
					   EventMonth, 
					   SUM(Actions) as Counted
		    FROM       Base		
			<cfif user neq "">
			WHERE      Actor = '#user#'
			</cfif>					
		    GROUP BY   EventCode, 
			           EventName, 
					   EventYear, 
					   ActionStatus, 
					   EventMonth    
		</cfquery>	
	
	<cfelse>
	
		<cfquery name="getList" dbtype="query">
	        SELECT     EventTrigger     as FieldRow, 
			           EventTriggerName as FieldRowName, 
					   EventYear,
					   ActionStatus, 
					   EventMonth, 
					   SUM(Actions) as Counted
		    FROM       Base		
			<cfif user neq "">
			WHERE      Actor = '#user#'
			</cfif>	
		    GROUP BY   EventTrigger, 
			           EventTriggerName, 
					   EventYear,
					   ActionStatus, 
					   EventMonth    
		</cfquery>	
		
	</cfif>
				
	<td valign="top" style="border-left:1px solid silver;border-bottom:1px solid silver;border-top:1px solid silver">
		
		<table width="100%" height="100%" align="center">
		
		<cfif base.recordcount gte "800">
		
			<cfoutput>
			<tr class="line">
			  <td colspan="27" style="padding-left:4px" align="left" class="labelit clsNoPrint" style="cursor:pointer;padding-right:10px" onclick="loadmodule('#session.root#/Staffing/Reporting/ActionLog/EventListing.cfm','#base.mission#','header=1','')">
			  	<a><cf_tl id="Open"><cf_tl id="listing"></a>
			  </td>		  
			  </tr>
			</cfoutput>
		  
		</cfif>
								
		<cfoutput>	
				
		<tr class="labelmedium">
							
			<td style="padding-left:5px;width:100%;border-bottom:1px solid silver"><cf_tl id="Event"></td>		
			<cfloop index="mth" from="1" to="12">
			<td colspan="<cfif url.stage eq "">2<cfelse>1</cfif>" style="min-width:#width#px;border-bottom:1px solid silver;border-left:1px solid silver;<cfif mth eq 12>border-right:0px solid silver</cfif>" 
			    align="center">#left(monthasstring(mth),3)#</td>
			</cfloop>			
			<td align="center" style="min-width:#width#px;border-bottom:1px solid silver;border-left:1px solid silver;<cfif mth eq 12>border-right:0px solid silver</cfif>" colspan="2"><cf_tl id="Total"></td>
		
		</tr>
		
		<cfif url.stage eq "">
		
		<tr class="labelmedium line" bgcolor="f4f4f4" style="height:10px">
		
			<td style="width:100%"></td>	
										
			<cfloop index="mth" from="1" to="12">	
			    <cfif url.stage eq "">		
				<td align="center" bgcolor="yellow" style="font-size:10px;min-width:#width#px;border-left:1px solid silver">P</td>
				<td align="center" bgcolor="B9F4C4" style="font-size:10px;min-width:#width#px;border-left:1px solid silver">C</td>					
				<cfelseif url.stage eq "Pending">
				<td align="center" bgcolor="yellow" style="font-size:10px;min-width:#width#px;border-left:1px solid silver">P</td>					
				<cfelse>				
				<td align="center" bgcolor="B9F4C4" style="font-size:10px;min-width:#width#px;border-left:1px solid silver">C</td>	
				</cfif>
			</cfloop>
			
			<cfif url.stage eq "">
			   <td align="center" bgcolor="yellow" style="font-size:10px;min-width:#width#px;border-left:1px solid silver">P</td>
			   <td align="center" bgcolor="B9F4C4" style="font-size:10px;min-width:#width#px;border-left:1px solid silver;border-right:1px solid silver">C</td>	
			<cfelseif url.stage eq "Pending">
				<td align="center" bgcolor="yellow" style="font-size:10px;min-width:#width#px;border-left:1px solid silver">P</td>				
			<cfelse>				
				<td align="center" bgcolor="B9F4C4" style="font-size:10px;min-width:#width#px;border-left:1px solid silver;border-right:1px solid silver">C</td>	
			</cfif>
							
		</tr>
		
		</cfif>
		
		</cfoutput>	
				
		<cfquery name="list" dbtype="query">
		 	 SELECT   DISTINCT EventYear,FieldRow, FieldRowName
			 FROM     getList
			 ORDER BY FieldRowName,EventYear
		 </cfquery>
		 
		 <cfset prior = "">
		 
		  <!---	
		 
		 <tr><td height="100%" colspan="28">
				 	
			 
		     <cf_divscroll overflowy="scroll" style="height:100%">
			 			 			 		 
			 <table width="100%" border="0" cellspacing="0" cellpadding="0">
			 
			 --->
			 
			 <cfset trp = "border-left:1px solid silver;">
			 
			 <cfoutput>		 
			 <tr>
			
					<td style="padding-left:4px;width:100%"></td>		
					<cfloop index="mth" from="1" to="12">	
						<cfif url.stage eq "" or url.stage eq "Pending">		
						<td align="center" style="background-color:##ffffaf50;min-width:#width#px;#trp#"></td>
						</cfif>
						<cfif url.stage eq "" or url.stage eq "Completed">
						<td align="center" style="background-color:##B9F4C450;min-width:#width#px;#trp#"></td>					
						</cfif>
					</cfloop>
					<cfif url.stage eq "" or url.stage eq "Pending">
					<td align="center" bgcolor="yellow" style="min-width:#width#px;#trp#"></td>
					</cfif>
					<cfif url.stage eq "" or url.stage eq "Completed">
					<td align="center" bgcolor="B9F4C4" style="min-width:#width#px;#trp#;border-right:1px solid silver"></td>	
					</cfif>
					
				</tr>		
				
			</cfoutput>		
			 								
			 <cfoutput query="List">				 										
								
				<tr class="navigation_row line fixlengthlist">
				 
				  <td style="width:100%">
				  
					  <table width="95%" align="right">
					  <tr class="labelmedium2">
					  	<td style="height:23px;">													
							<cfif prior neq FieldRowName>
							#FieldRowName# 
							<cfset prior = fieldRowName>
							</cfif>
						</td>
						<cfif url.period eq "All">
						<td align="right" style="padding-right:3px;font-size:12px;">#EventYear#</td>
						</cfif>
					  </tr>
					  </table>
				  </td>	
				  	
				  <!--- Pending --->
										
				  <cfquery name="getPending" dbtype="query">
				        SELECT     EventMonth, SUM(counted) as Counted
					    FROM       getList
						WHERE      FieldRow     = '#FieldRow#'													  								
						AND        EventYear    = '#EventYear#'
						AND        ActionStatus < '3'										       
						GROUP BY   EventMonth
				  </cfquery>	
				  					
				  <cfset arPending=arraynew(1)> 					
				  <cfset ArraySet(arPending, 1, 12, 0)>
	 
				  <!--- Populate the array row by row ---> 
				  <cfloop query="getPending"> 
					    <cfset arPending[EventMonth]=Counted> 									   
				  </cfloop> 
					
				  <!--- Complete --->
					
				  <cfquery name="getComplete" dbtype="query">
					        SELECT     EventMonth, SUM(counted) as Counted
						    FROM       getList
							WHERE      FieldRow     = '#FieldRow#'		
							AND        EventYear    = '#EventYear#'											  								
							AND        ActionStatus = '3'										       
							GROUP BY   EventMonth
				  </cfquery>		
					
				  <cfset arComplete=arraynew(1)> 					
				  <cfset ArraySet(arComplete, 1, 12, 0)>
	 
				  <!--- Populate the array row by row ---> 
				  <cfloop query="getComplete"> 
				    <cfset arComplete[EventMonth]=Counted> 									   
				  </cfloop> 
				  				 
				  <cfloop index="mth" from="1" to="12">
													
						<cfset pend = arPending[mth]>
						
						<cfset thisDivName	="#LEFT(REPLACE(url.mission,"__","","ALL"),25)#YKK"> <!----throwing an error when selecting more than 7 entities---->
						
						<cfif url.stage eq "" or url.stage eq "Pending">
							<cfif pend eq "0">																	
								<td style="#trp#;min-width:#width#px" align="center">-</td>						
							<cfelse>							
								<td onclick="doPersonEvent('#url.mission#','#unit#','#eventyear#','#url.sort#','#mth#','#user#','#url.layout#','#fieldrow#','P','#thisDivName#')" 
								   style="#trp#;min-width:#width#px;cursor:pointer;background-color:##FFFF0050" align="center">#pend#</td>														
							</cfif>
						</cfif>
													
						<cfset cmpl = arComplete[mth]>		
						
						<cfif url.stage eq "" or url.stage eq "Completed">										
							<cfif cmpl eq "0">																	
								<td style="#trp#;min-width:#width#px" align="center">-</td>						
							<cfelse>							
								<td onclick="doPersonEvent('#url.mission#','#unit#','#eventyear#','#url.sort#','#mth#','#user#','#url.layout#','#fieldrow#','C','#thisDivName#')" 
								   style="#trp#;min-width:#width#px;cursor:pointer;background-color:##00FF4050" align="center">#cmpl#</td>														
							</cfif>						
						</cfif>
							
				</cfloop>	
				 				
				<cfset pend = ArraySum(arPending)>	
				
				<cfset thisDivName	="#LEFT(REPLACE(url.mission,"__","","ALL"),25)#YKK"> <!----throwing an error when selecting more than 7 entities---->
			
				<cfif url.stage eq "" or url.stage eq "Pending">
					<cfif pend eq "0">																	
						<td style="#trp#;min-width:#width#px" align="center">-</td>							
					<cfelse>							
						<td bgcolor="yellow" onclick="doPersonEvent('#url.mission#','#unit#','#eventyear#','#url.sort#','','#user#','#url.layout#','#fieldrow#','P','#thisDivName#')" 
						    style="#trp#;min-width:#width#px;cursor:pointer" align="center">#pend#</td>														
					</cfif>
				</cfif>
								
				<cfset cmpl = ArraySum(arComplete)>	
					
				<cfif url.stage eq "" or url.stage eq "Completed">		
					<cfif cmpl eq "0">						
					<td align="center" style="#trp#;min-width:#width#px;border-left:1px solid silver;border-right:1px solid silver">-</td>			  						
					<cfelse>
					<td align="center" bgcolor="00FF40" onclick="doPersonEvent('#url.mission#','#unit#','#eventyear#','#url.sort#','','#user#','#url.layout#','#fieldrow#','C','#thisDivName#')" 
					    style="min-width:#width#px;border-left:1px solid silver;border-right:1px solid silver">#cmpl#</td>			  												
					</cfif>		
				</cfif>				
				 
				</tr>
				
			</cfoutput>		
			
		 <!---	
			
			</table>
		 
		
		 </CF_DIVSCROLL>
		 
		 
		 </td></tr>	
		 
		 --->
		 
		<cfoutput>
		 
		<!--- Pending --->										
		<cfquery name="getPending" dbtype="query">
		        SELECT     EventMonth, SUM(counted) as Counted
			    FROM       getList
				WHERE      ActionStatus < '3'										       
				GROUP BY   EventMonth
		</cfquery>		
		
		<cfset arPending=arraynew(1)> 					
		<cfset ArraySet(arPending, 1, 12, 0)>

		<!--- Populate the array row by row ---> 
		<cfloop query="getPending"> 
		    <cfset arPending[EventMonth]=Counted> 									   
		</cfloop> 
		
		<!--- Complete --->
		
		<cfquery name="getComplete" dbtype="query">
		        SELECT   EventMonth, SUM(counted) as Counted
			    FROM     getList
				WHERE    ActionStatus = '3'														       
				GROUP BY EventMonth
		</cfquery>		
		
		<cfset arComplete=arraynew(1)> 					
		<cfset ArraySet(arComplete, 1, 12, 0)>

		<!--- Populate the array row by row ---> 
		<cfloop query="getComplete"> 
		    <cfset arComplete[EventMonth]=Counted> 									   
		</cfloop> 	
		
		 
		<tr class="navigation_row labelmedium">
			  <td width="100%" style="padding-left:4px"><cf_tl id="Total"></td>
			  
			  <cfloop index="mth" from="1" to="12">
			  						
					<cfset thisDivName	="#LEFT(REPLACE(url.mission,"__","","ALL"),25)#YKK"> <!----throwing an error when selecting more than 7 entities---->
					
					<cfif url.stage eq "" or url.stage eq "Pending">
					<cfset pend = arPending[mth]>										
					<td bgcolor="<cfif getPending.counted gt 0>yellow</cfif>" style="border-left:1px solid silver" align="center"
						onclick="doPersonEvent('#url.mission#','#unit#','#url.period#','#url.sort#','#mth#','#user#','#url.layout#','','P','#thisDivName#')">
						#pend#</td>
					</cfif>	
						
					<cfif url.stage eq "" or url.stage eq "Completed">											
					<cfset cmpl = arComplete[mth]>					
					<td align="center" bgcolor="00FF40" style="border-left:1px solid silver"
						onclick="doPersonEvent('#url.mission#','#unit#','#url.period#','#url.sort#','#mth#','#user#','#url.layout#','','C','#thisDivName#')">
						#cmpl#</td>		
					</cfif>				
				
			  </cfloop>	 
			  
			  <cfset thisDivName	="#LEFT(REPLACE(url.mission,"__","","ALL"),25)#YKK"> <!----throwing an error when selecting more than 7 entities---->
			  
			  <cfif url.stage eq "" or url.stage eq "Pending">
			  <cfset pend = ArraySum(arPending)>										
			  <td bgcolor="yellow" style="border-left:1px solid silver" align="center"
  				onclick="doPersonEvent('#url.mission#','#unit#','#url.period#','#url.sort#','','#user#','#url.layout#','','P','#thisDivName#')">#pend#</td>
			  </cfif>
			  
			  <cfif url.stage eq "" or url.stage eq "Completed">				 						
			  <cfset cmpl = ArraySum(arComplete)>							
			  <td align="center" bgcolor="e4e4e4" style="border-left:1px solid silver;border-right:1px solid silver"
				onclick="doPersonEvent('#url.mission#','#unit#','#url.period#','#url.sort#','','#user#','#url.layout#','','C','#thisDivName#')">#cmpl#</td>		
			   </cfif>	  
			 
			</tr>
						
			</cfoutput>
							
		</table>				
	
	</td>
		
</tr>

<cfset ajaxOnLoad("doHighlight")>

<cfset thisDivName	="#LEFT(REPLACE(url.mission,"__","","ALL"),25)#YKK"> <!----throwing an error when selecting more than 7 entities---->

<cfif user neq "">
	<cfset ajaxOnLoad("function(){ doPersonEvent('#url.mission#','#url.orgunit#','#url.period#','#url.sort#','','#user#','#url.layout#','','P','#thisDivName#'); }")>
<cfelse>
	<cfset ajaxOnLoad("function(){ doPersonEvent('#url.mission#','#url.orgunit#','#url.period#','#url.sort#','','xxxxxx','#url.layout#','','P','#thisDivName#'); }")>	
</cfif>

</table>
