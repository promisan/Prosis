
<cfset dateValue = "">
<CF_DateConvert Value="#url.dts#">
<cfset DTS = dateValue>

<table width="100%" cellspacing="0" cellpadding="0" class="navigation_table" navigationhover="transparent">

		<tr><td colspan="2" style="padding:10px">
		
			<cfquery name="getHome"
				datasource="appsOrganization" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">		
				SELECT    A.Address, A.AddressCity, A.Coordinates
				FROM      OrganizationAddress AS OA INNER JOIN
		                  System.dbo.Ref_Address AS A ON OA.AddressId = A.AddressId
				WHERE     OA.OrgUnit IN
		                          (SELECT    OrgUnit
		                            FROM     Organization
		                            WHERE    Mission = '#url.mission#' AND (TreeUnit = 1)) 
				AND       OA.AddressType = 'Home'
			</cfquery>
			
			<cfif getHome.coordinates neq "">
			
				<cfset row = 0>
			
				<cfloop index="itm" list="#getHome.Coordinates#" delimiters=",">
					<cfset row = row+1>
					<cfif row eq "1">
					   <cfset  lat = itm>
					<cfelse>
					   <cfset  lng = itm>  		
					</cfif>
				</cfloop>	
			
			<cfelse>
			
				<cfset lat = "0">
				<cfset lng = "0">
				
			</cfif>	
		
			<!--- embed a map --->
			
			<cfmap name="gmap"	   
		    centerlatitude   = "#lat#" 
		    centerlongitude  = "#lng#" 	
		    doubleclickzoom  = "true" 
			collapsible      = "false" 			
		    overview         = "true" 
			continuouszoom   = "true"
			height           = "250"
			width            = "410"		
			zoomcontrol      = "large3d"
			hideborder       = "true"		
		    scrollwheelzoom  = "true" 		
			showmarkerwindow = "true"
		    showscale        = "true"
			markerbind       = "url:MAP/MAPDetail.cfm?mode=small&date=#url.date#&mission=#url.mission#&cfmapname={cfmapname}&cfmapaddress={cfmapaddress}" 	    
		    zoomlevel        = "9"> 	
				
		</td></tr>
		
		<!--- as a precoution we populate the workplan.positionno if this is still blank --->
		
		<cfquery name="getWorkPlan"
			datasource="appsWorkOrder" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">		
			SELECT *
			FROM   WorkPlan W
			WHERE  Mission = '#url.mission#'
			AND    DateEffective  <= #dts# 
            AND    DateExpiration >= #dts# 		
			AND    (PositionNo is NULL 
			        OR 
				    PositionNo NOT IN (SELECT PositionNo FROM Employee.dbo.Position WHERE PositionNo = W.PositionNo))
		</cfquery>
		
		<cfloop query="getWorkPlan">
			
			<!--- get positionno for employee,date --->
			
			<cfquery name="getActor"
				datasource="appsEmployee" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">						
				
				SELECT     PA.PositionNo
									   
				FROM       PersonAssignment AS PA INNER JOIN
		                   Position AS Pos ON PA.PositionNo = Pos.PositionNo
						   
				WHERE      PA.PersonNo = '#PersonNo#'
				AND        PA.DateEffective  <= #dts#
				AND        PA.DateExpiration >= #dts#
				AND        PA.AssignmentStatus IN ('0', '1') 
				AND        Pos.Mission = '#url.mission#' 
																 			     	     
		   </cfquery>	
			
			<!--- updated --->
			
			<cfquery name="setWorkPlan"
				datasource="appsWorkOrder" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">		
				UPDATE WorkPlan
				SET    PositionNo = '#getActor.PositionNo#'
				WHERE  WorkPlanId = '#workplanid#'			
			</cfquery>
				
		</cfloop>
			
		<cfquery name="Actor"
			datasource="appsEmployee" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">						
			
			SELECT     PA.PositionNo, 
			           PA.FunctionNo, 
					   PA.FunctionDescription, 
					   P.PersonNo, 
					   P.LastName, 
					   P.FirstName, 
					   PA.DateEffective, 
					   PA.DateExpiration,
					   
					   (SELECT TOP 1 PositionNo 
                        FROM   WorkOrder.dbo.WorkPlan W
                        WHERE  W.Mission         = '#url.mission#'
						AND    W.DateEffective  <= #dts# 
                        AND    W.DateExpiration >= #dts# 		  			   
					    AND    W.PositionNo      = Pos.PositionNo) as WorkPlan 
					   
			FROM       Person AS P INNER JOIN
                       PersonAssignment AS PA ON P.PersonNo = PA.PersonNo INNER JOIN
	                   Position AS Pos ON PA.PositionNo = Pos.PositionNo
					   
			WHERE      PA.DateEffective <= #dts#
			AND        PA.DateExpiration >= #dts#
			AND        PA.AssignmentStatus IN ('0', '1') 
			AND        Pos.Mission = '#url.mission#' 
			
			AND        EXISTS (
							  SELECT  'X'
              				  FROM    PositionGroup
							  WHERE   PA.PositionNo = PositionNo
		                      AND     PositionGroup = 'Driver' )
			ORDER BY   WorkPlan DESC, P.LastName 
											 			     	     
	   </cfquery>	
			
		<cfoutput query="actor">
					
			<tr class="navigation_row">

				<td style="padding-left:5px;width:30px" class="navigation_pointer"></td>	

			    <td class="labelmedium navigation_action" style="cursor:pointer;font-size:14px;height:20px" 
				    onclick="positionselect('#positionno#','#url.dts#','all')" id="workplan_#positionno#">
				    <cfif currentrow eq "1"><cf_space spaces="114"></cfif>
						  <cfif workplan neq ""><font color="0080C0"><cfelse><font color="gray"></cfif>#FirstName# #LastName#</font> <font size="2">/ #PositionNo# #FunctionDescription# </font></font>				 						
			    </td>
			</tr>
									
			<tr name="position" id="position_#positionno#" class="hide">									
				<td colspan="2" bgcolor="white" style="height:30px;padding-left:3px;padding-right:18px;padding-bottom:5px" id="positioncontent_#positionno#"></td>			
			</tr>
			
			<tr><td colspan="2" class="line"></td></tr>		
		
		</cfoutput>
	
	</table>
	
	<cfset ajaxonload("doHighlight")>
