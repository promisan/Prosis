
<cf_screentop html="no" height="100%" scroll="no">

<cfparam name="session.selectworkorderid" default="">
<cfparam name="session.selectactiondate"  default="">



<cfquery name="WorkOrder" 
	datasource="appsWorkOrder" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#"> 
	SELECT    *
	FROM      WorkOrder
	<cfif session.selectworkorderid neq "">
	WHERE     WorkOrderId = '#session.selectworkorderid#'
	<cfelse>
	WHERE     1 = 0
	</cfif>	
</cfquery>	

<cfset go = "0">


<cfquery name="Roles" 
	datasource="appsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#"> 
	SELECT    Role
	FROM      Ref_AuthorizationRole
	WHERE     SystemModule = 'workorder'	
</cfquery>
																						
<!--- determine the processing mode --->
	
<cfinvoke  component = "Service.Access"  
       method           = "WorkorderAccessList" 
	   mission          = "#mission#" 
	   Role             = "#QuotedvalueList(roles.Role)#"
	   mode             = "Any" 								  
	   returnvariable   = "accesslist">
	

<cfif  accesslist eq "">

	<table width="100%" align="center">
		<tr><td style="height:80" class="labellarge" align="center"><font color="FF0000">You were not granted access to select.</td></tr>
	</table>

<cfelse>
		   
	<cfquery name="Customer" 
		datasource="appsWorkOrder" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#"> 
		SELECT    C.CustomerId, 
		          C.CustomerName, 
				  C.OrgUnit,
				  O.OrgUnitName,
				  PO.OrgUnit AS ParentOrgUnit,
				  UPPER(PO.OrgUnitName) AS ParentOrgUnitName
		FROM      Customer C
					INNER JOIN Organization.dbo.Organization O
						ON C.OrgUnit = O.OrgUnit
					LEFT OUTER JOIN Organization.dbo.Organization PO
						ON O.ParentOrgUnit = PO.OrgUnitCode
		WHERE     C.Mission = '#URL.Mission#' 
		AND       C.Customerid IN (SELECT CustomerId 
		                         FROM   Workorder 
								 WHERE  WorkOrderId IN (#preservesingleQuotes(accesslist)#))
		ORDER BY PO.OrgUnitName ASC, C.CustomerName ASC
	</cfquery>		   

	<table width="100%" height="100%"><tr>
	
		    <td valign="top" style="padding-top:40px;border:1px dotted silver">
				
			<table width="70%" align="center">	
				<tr><td align="center">	
					
					<table cellpadding="0" cellspacing="0" width="100%" height="100%" bgcolor="white">
						<tr>
							<td>						
							<table width="90%" cellspacing="5" align="center" class="formpadding">
							
							    <tr><td height="10"></td></tr>					
								<tr><td colspan="2" class="labellarge" style="font-size:35;height:30;"><cf_tl id="Selection criteria"></td></tr>
								<tr><td colspan="2" class="line"></td></tr>
								<tr>
								    <td width="30%" style="padding-left:9px;padding-top:4px" class="labellarge"><cf_tl id="Customer Site">:</b></td>
									<td class="labellarge" style="width:100;padding-left:9px; padding-top:10px;">
										
										<cfform name="customerform">
											<cfselect 
												name="customerid" 
												id="customerid" 
												class="regularxl" 
												style="font-size:18; height:30; width:100%;" 
												query="Customer" 
												display="CustomerName" 
												value="CustomerId" 
												group="ParentOrgUnitName"
												selected="#workorder.customerid#">
											</cfselect>											
										</cfform>
																	
									</td>
								</tr>
								
								<tr>
									<td valign="top" style="padding-left:9px;padding-top:8px;" class="labellarge"><cf_tl id="Service">:</b></td>
									<td style="padding-top:8px;">																
										<cfdiv bind="url:Action/WorkOrderSelect.cfm?mission=#url.mission#&customerid={customerid}"/>									
									</td>
								</tr>
								<tr>
									<td class="labellarge" style="padding-left:9px"><cf_tl id="Date">:</b></td>
									<td style="padding:10px">	
									
																	    
								 	<cf_calendarView 
									   mode           = "picker"		
									   title          = "mypicker"	
									   FieldName      = "selection_date" 					   		   				   						  				   		  					    			  				      	   
									   cellwidth      = "40"
									   cellheight     = "40">  	
									  
									
									</td>
								</tr>					
								<tr><td colspan="2" class="line"></td></tr>					
								<tr><td colspan="2" align="center" style="padding-top:10px">
									
									<cf_tl id="Apply selection" var="1">
									<cfoutput>
									<input type="button" 
									     name="go" 
										 value="#lt_text#" 
										 class="button10s" 
										 width="200"
										 onclick="ColdFusion.navigate('Action/WorkorderActionListing.cfm?mission=#url.mission#&workorderid='+document.getElementById('workorderid').value+'&date='+document.getElementById('selection_date').value+'&entryMode=#url.entryMode#','menucontent');" 
										 style="font-size:15px;width:210;height:36">
									</cfoutput>	 
										
								</td></tr>
								<tr><td height="20"></td></tr>									
							</table>				
						</td></tr></table>
							
				</td></tr>	
			</table>
			</td>
		</tr>
	</table>
	
</cfif>	
