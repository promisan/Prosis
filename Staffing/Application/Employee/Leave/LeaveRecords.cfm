
<!--- workflow instructions 
0   = user may edit or delete the record and workflow is open
1   = workflow is active, only wf processing allowed
2   = workflow is closed, and record is closed, no actions
8/9 = cancelled record, deactivate, needs to be raised again
--->

<cfoutput>

<cfquery name="getPerson" 
	datasource="AppsEmployee" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT 	*
		FROM 	Person
		WHERE 	PersonNo = '#URL.ID#'
</cfquery>

<!--- Query returning search results --->
<cfquery name="Base" 
datasource="AppsEmployee" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">

    SELECT *,	
	       Year(DateEffective)  as LeaveYearStart,
	       Year(DateExpiration) as LeaveYear,
		   		   
	       (SELECT Description 
		    FROM   Ref_LeaveTypeClass 
			WHERE  LeaveType = L.LeaveType 
			AND    Code      = L.LeaveTypeClass) as LeaveTypeClassDescription,
			
		   (SELECT Description 
		    FROM   Ref_PersonGroupList 
			WHERE  GroupCode     = L.GroupCode 
			AND    GroupListCode = L.GroupListCode) as LeaveClassGroupDescription,
			
		   (SELECT TOP 1 ObjectKeyValue4 
			FROM     Organization.dbo.OrganizationObject 
			WHERE    ObjectKeyValue4 = L.LeaveId
			AND      EntityCode = 'EntLve' 
			AND      Operational = 1) as WorkflowId,
			
		   (SELECT sum(Deduction)
			FROM   PersonLeaveDeduct
			WHERE Leaveid = L.LeaveId) as LeaveDeductDetail,
			
		   (SELECT WorkSchema
			FROM   Organization.dbo.Organization
			WHERE  OrgUnit = L.OrgUnit) as WorkSchema			
					
    FROM   PersonLeave L, Ref_LeaveType R
	WHERE  L.PersonNo = '#URL.ID#' 
	AND    L.LeaveType = R.LeaveType
	AND    L.TransactionType IN ('Request','Manual','External')		
	<!--- AND    L.Status < '8'	 --->
	ORDER BY L.Status, Year(DateExpiration) DESC, L.DateEffective DESC 
	
</cfquery>


<cfparam name="session.filterleavetype" default="">
<cfparam name="session.filterstatus"    default="">
<cfparam name="session.filteryear"      default="#base.leaveYear#">

<cfparam name="url.filterleavetype" default="#session.filterleavetype#">
<cfparam name="url.filterstatus"    default="#session.filterstatus#">
<cfparam name="url.filteryear"      default="#session.filteryear#">

<cfset session.filterleavetype = url.filterleavetype>
<cfset session.filterstatus    = url.filterstatus>
<cfset session.filteryear      = url.filteryear>
			
<cfinvoke 
     component      = "Service.Access"
     method         = "contract"
     returnvariable = "access" 
	 personno       = "#URL.ID#">
	 
<!--- check for leave manager access --->	 
	 
<cfinvoke component  = "Service.Access" 
	 method         = "RoleAccess"				  	
	 role           = "'LeaveClearer'"		
	 returnvariable = "manager">		   
		  
<cfif manager eq "Granted">
	<cfset access = "ALL">
</cfif>

<!--- leave approver and monitor roles --->
	 
<cfinvoke component="Service.Access" 
     method         = "timesheet" 
	 returnvariable = "timekeeper" 
	 personno       = "#URL.ID#">
	 			
  <table width="96%" height="100%" align="center" class="formpadding">
	 	 		
	 
	 <!--- Query returning search results --->
	 <cfquery name="Search" dbtype="query">
	  	SELECT  *
		FROM    Base  
	  	WHERE   1=1
		<cfif url.filterleavetype neq "">
		AND     LeaveType = '#url.filterleavetype#'
	  	</cfif>
	    <cfif url.filterstatus eq "All">
		  <!--- show all --->
	    <cfelseif url.filterstatus neq "">
		AND     Status = '#url.filterstatus#'
	    <cfelse>
	    AND     Status NOT IN ('8','9')		  
	    </cfif>		
	    <cfif url.filteryear neq "">
		AND  ( LeaveYear IN (#url.filteryear#) OR LeaveYearStart IN (#url.filteryear#) )			
		</cfif>		
	</cfquery>		
					  
	<tr>
	  <td align="center" style="height:10px">
	  		
											   
			       <table>
				   <tr>	
				   
				   <td align="center" height="20" class="labelmedium" style="min-width:140px;;background-color:f5f5f5">		
				   	<table class="clsNoPrint">
				   		<tr>
				   			<td style="padding-left:4px" style="background-color:f5f5f5">
				   				<span id="printTitle" style="display:none;"><cf_tl id="Leave Records"> - [#getPerson.indexNo#] #getPerson.fullName#</span>
								<cf_tl id="Print" var="1">
								<cf_button2 
									mode		= "icon"
									type		= "Print"
									title       = "#lt_text#" 
									id          = "Print"					
									height		= "30px"
									width		= "35px"
									printTitle	= "##printTitle"
									printContent = ".clsPrintContent">
				   			</td>
				   			<td class="labelmedium" style="font-size:19px;padding-left:5px;padding-right:30px;min-width:110px;background-color:f5f5f5">
				   				<cfif access eq "EDIT" or access eq "ALL" or timekeeper eq "EDIT" or timekeeper eq "ALL">		
							    	<a href="javascript:leave('#URL.ID#')"><cf_tl id="Add Record"></a>	    	
								</cfif>
				   			</td>
				   		</tr>
				   	</table>
				   </td>
				   
				   <td class="labelmedium" style="min-width:50px;padding-left:10px;border-left:1px solid silver;background-color:f5f5f5"><cf_tl id="Type">:</td>
				   <td style="padding-left:10px;background-color:f5f5f5">
				   
					   <cfquery name="qLeaveType" dbtype="query">
						   SELECT DISTINCT LeaveType, Description
						   FROM   Base
					   </cfquery>		   
					   
					   <select name="filterleavetype" id="filterleavetype" class="regularxl" onchange="records('#url.id#')">
					   <option value=""><cf_tl id="All"></option>
					   <cfloop query="qleavetype">
					     <option value="#LeaveType#" <cfif url.filterleavetype eq leavetype>selected</cfif>>#Description#</option>
					   </cfloop>		   
					   </select>
				   
				  </td>
				   
			      <cfquery name="qStatus" dbtype="query">
					   SELECT DISTINCT Status
					   FROM Base
				   </cfquery>		
				   
				   <cfif qStatus.recordcount lte "1">
				   
				       <input type="hidden" id="filterstatus" name="filterstatus" value="#qStatus.status#">
				   
				   <cfelse>
				   
				   <td class="labelmedium" style="min-width:60px;padding-left:10px;background-color:f5f5f5"><cf_tl id="Status">:</td>
				   <td style="padding-left:10px">
				 
				   <select name="filterstatus" id="filterstatus" class="regularxl" onchange="records('#url.id#')">
				    <option value="All" <cfif url.filterstatus eq "All">selected</cfif>><cf_tl id="All"></option>
				    <option value="" <cfif url.filterstatus eq "">selected</cfif>><cf_tl id="All except denied/cancelled"></option>
					
				   <cfloop query="qStatus">
				   
				    <cfswitch expression="#Status#">
						<cfcase value="0"><cf_tl id="Pending Submission" var="1"></cfcase>
					    <cfcase value="1"><cf_tl id="In Process" var="1"></cfcase>
						<cfcase value="2"><cf_tl id="Approved" var="1"></cfcase>				
						<cfcase value="8"><cf_tl id="Cancelled" var="1"></cfcase>
						<cfcase value="9"><cf_tl id="Denied" var="1"></cfcase>
					</cfswitch>			
				   
				     <option value="#Status#" <cfif url.filterstatus eq status>selected</cfif>>#Status# #lt_text#</option>
				   </cfloop>		   
				   </select>
				   
				   </cfif>
				   
				   </td>
				   
				    <cfif base.recordcount eq "0">
					
					<cfelse>
										    
					    <td style="padding-left:10px;background-color:f5f5f5">
					   
					    <cfquery name="qYear" dbtype="query">
						   SELECT DISTINCT LeaveYear
						   FROM Base
						   ORDER BY LeaveYear DESC
					    </cfquery>
					   
					    <table>
						   <tr class="labelmedium">
						   <cfloop query="qyear">						   
							   <cfif url.filteryear eq "">
							         <td style="padding-right:4px"><input onclick="records('#url.id#')" type="checkbox" class="radiol" id="filteryear" name="filteryear" value="#LeaveYear#" checked></td>
							   <cfelse>
							   		 <td style="padding-right:4px"><input onclick="records('#url.id#')" type="checkbox" class="radiol" id="filteryear" name="filteryear" value="#LeaveYear#" <cfif find(leaveYear,url.filteryear)>checked</cfif>></td>
							   </cfif>			   
							   <td style="padding-right:7px"><cfif currentrow eq "1">#mid(LeaveYear,1,4)#<cfelse>-#mid(LeaveYear,3,2)#</cfif></td>
						   </cfloop>
						   </tr>
					    </table>
					  					   
					   </td>
				   
				   </cfif>
				   
				   </tr>
				   
				   </table> 
			 			  
		</td>
		</tr>
		
		</cfoutput>
		
		<tr>
		<td class="clsPrintContent" style="height:100%">  
		
			 <cf_divscroll>		
			  
			  <table width="100%" class="formpadding navigation_table"> 
			  
			  <cfoutput>
						  
			  <TR class="labelmedium line fixrow" style="height:27px">
			        <TD width="40" style="padding-left:4px"><cf_tl id="Type"></TD>	
				    <td style="min-width:20px" align="center"></td>
					<td style="min-width:10px" align="center"></td>
				    <td style="width:70%"><cf_tl id="Leave Class"></td>
					<TD style="width:20%"><cf_tl id="Officer"></TD>											
					<TD style="width:95;min-width:95px"><cf_tl id="Effective"></TD>
					<TD style="width:95;min-width:95px"><cf_tl id="Expiration"></TD>					
					<TD style="min-width:55px" align="right"><cf_tl id="Days"></TD>			
					<TD style="min-width:55px" align="right"><cf_tl id="Taken"></TD>		
					<TD style="min-width:55px;padding-right:3px" align="right"><cf_tl id="Calc"></TD>									
				</TR>
			  
			  </cfoutput>
						
			<cfset last = '1'>		
			
			<cfif base.recordcount eq "0">			
				<tr class="line labelmedium"><td colspan="9" align="center"><cf_tl id="There are no records to show in this view"></td>			
			</cfif>	
						
			<cfoutput query="Search" group="Status">
						
			<cfset cl = "ffffff">
			
			<cfset display="">
			
			<tr class="labelit fixrow2">
						
			    <td bgcolor="ffffff" style="height:35px;font-size:21px;padding-top:0px;padding-left:4px" colspan="10" align="left">
				 
			     <cfswitch expression="#Status#">
				 
				 		<cfcase value="0"><cf_tl id="Pending Submission"></cfcase>
			            <cfcase value="1"><cf_tl id="In Process"></cfcase>
						<cfcase value="2"><cf_tl id="Cleared and applied"></cfcase>				
						<cfcase value="8">
						
						    <cf_tl id="Cancelled"><cfset cl="dadada">
							
							<!---
							<table>
								<tr class="labelit">
									<td style="padding-top:4px"><cf_img icon="expand" toggle="Yes" onclick="toggleLines('status_#status#')"></td>
									<td style="height:50px;font-size:25px;padding-left:4px;color:red;font-weight: 200;"><cf_tl id="Cancelled"></td>
								</tr>
							</table>
							 
							 <cfset display="none">
							 <cfset cl="e4e4e4">
							 --->
							 							 
						</cfcase>
			            <cfcase value="9"><cf_tl id="Denied"><cfset cl="FFCCCC"></cfcase>
						
			     </cfswitch>
				 
			    </td>
			</tr>
			
				<cfoutput group="LeaveYear">
				
					<cfif status gte "2">
					 
						<tr class="line">
						<td colspan="10" style="padding-left:8px">
													
							<table width="100%" height="100%">
							  <tr>
							  <td class="labelmedium" style="height:20px;font-size:23px" valign="top">#LeaveYear#</td>
							 
								  <td align="right" style="width:400px">
								  
									  <table width="100%" bgcolor="e4e4e4" style="border:0px solid silver">
									  
									  <cfquery name="LeaveStatus" 
											datasource="AppsEmployee" 
											username="#SESSION.login#" 
											password="#SESSION.dbpw#">
												SELECT    P.LeaveType, R.Description, P.LeaveTypeClass,
							                              (SELECT   Description
							                               FROM     Ref_LeaveTypeClass
							                               WHERE    LeaveType = P.LeaveType 
														   AND      Code = P.LeaveTypeClass) AS ClassName, 
													      SUM(P.DaysDeduct) AS Taken
												FROM      PersonLeave AS P INNER JOIN
							                    		  Ref_LeaveType AS R ON P.LeaveType = R.LeaveType
												WHERE     P.PersonNo            = '#url.id#' 
												AND       YEAR(P.DateEffective) = '#leaveyear#'
												AND       Status                = '#status#'
												GROUP BY  P.LeaveType, P.LeaveTypeClass, R.Description
												ORDER BY  P.LeaveType, P.LeaveTypeClass, R.Description
									  </cfquery>
																		 
								      <cfset cnt = 0>
									  <cfloop query="leavestatus">		
									   <cfset cnt = cnt+1>
									    <cfif cnt eq "1">	
										  <tr class="<cfif currentrow neq recordcount>line</cfif> labelmedium" style="height:25px">		
									    </cfif>						 
									  	<td align="center" style="min-width:110px;border-left:1px solid silver;padding-left:4px">#ClassName#</td>							
										<td align="right" bgcolor="DBFFFF" style="min-width:50;border-left:1px solid silver;border-right:1px solid silver;padding-right:3px;">#NumberFormat(Taken,"__.__")#</td>								 
										<cfif cnt eq "5">
										  	<cfset cnt = 0>
										   </tr>
										</cfif>
									  </cfloop>
									  								  
									  </table>
									  					  
								  </td>
							  
							 
							  </tr>
							</table>  
										
						</td>
						
						</tr>
					
					 </cfif>
					 
					<cfif find(LeaveYear,url.filteryear) or find(LeaveYearStart,url.filteryear) or url.filteryear eq "">
					
					 <!---				 
						 <cfinvoke
				        component="Service.Access"
				        method="employee"
				        returnvariable="access" 
						personno="#URL.ID#"/>						
						--->										
									
						<cfoutput>		
																				
							<tr style="display:#display#;height:23px" name="status_#status#" bgcolor="#cl#" 
								  class="labelmedium navigation_row <cfif memo eq '' or transactionType eq 'External'>line</cfif>">
							
	      						   <td style="padding-left:14px;padding-right:4px"><cfif TransactionType eq "Manual"><cf_tl id="BackOffice"><cfelseif TransactionType eq "Request"><cf_tl id="Portal"><cfelse>#TransactionType#</cfif></td>																
																	
									<input type="hidden" 
									   name="workflowlink_#workflowid#" 
									   id="workflowlink_#workflowid#" 		   
									   value="EmployeeLeaveEditWorkflow.cfm">	
									   					   								
									<cfif workflowid neq "">
								 
									 <td align="center" style="cursor:pointer; padding-left:5px;" onclick="workflowdrill('#workflowid#','box_#workflowid#')" >
																 
									 	<cfif Status eq "1" and session.acc eq officerUserId>
										
											  <img id="exp#Workflowid#" 
											     class="hide" 
												 src="#SESSION.root#/Images/arrowright.gif" 
												 align="absmiddle" 
												 alt="Expand" 
												 height="9"
												 width="7"			
												 border="0"> 	
															 
										   <img id="col#Workflowid#" 
											     class="regular" 
												 src="#SESSION.root#/Images/arrowdown.gif" 
												 align="absmiddle" 
												 height="10"
												 width="9"
												 alt="Hide" 			
												 border="0"> 
										
										<cfelse>
										
											<img id="exp#WorkflowId#" 
											     class="regular" 
												 src="#SESSION.root#/Images/arrowright.gif" 
												 align="absmiddle" 
												 alt="Expand" 
												 height="9"
												 width="7"			
												 border="0"> 	
															 
										   <img id="col#WorkflowId#" 
											     class="hide" 
												 src="#SESSION.root#/Images/arrowdown.gif" 
												 align="absmiddle" 
												 height="10"
												 width="9"
												 alt="Hide" 			
												 border="0"> 
										
										</cfif>
										
									<cfelse>
									
									<td align="center" style="padding-left:4px;">	
									  
									</cfif>	 
									
									</td>	
									
									<cfset edt = "0">		
									
									<td align="center" style="padding-top:4px;padding-right:3px">
																			
									 	 <cfif access eq "ALL">		
										 	 									 
										      <cf_img icon="edit" onclick="leaveedit('#LeaveId#','0')">		
											  <cfset edt = "1">		
											  																																							
									     <cfelseif transactiontype neq "External" and
										    (access eq "EDIT" or timekeeper eq "EDIT" or timekeeper eq "ALL")>
																				 
											 <cfif Status lte "1">									 
											      <cf_img icon="edit" onclick="leaveedit('#LeaveId#','0')">		
												  <cfset edt = "1">								  			  
											 </cfif>   	  	  											 									 					  			  											  
											 
										 <cfelse>
										 
										 	<!--- no access --->	 									 	 	  
										   	   
										 </cfif>  
										
									 
									</td>	
									<td>#Description#
									<cfif LeaveTypeClassDescription neq "" and LeaveTypeClassDescription neq Description>:&nbsp;<font color="008000">#LeaveTypeClassDescription#</cfif>
									<cfif LeaveClassGroupDescription neq ""><font color="8000FF">:&nbsp;#LeaveClassGroupDescription#</cfif>							
									</td>														
									<td style="font-size:12px;padding-left:5px"><cfif TransactionType neq "External">#OfficerLastName#&nbsp;#DateFormat(Created,CLIENT.DateFormatShow)#</cfif></td>
									<td align="left" style="border-left:1px solid silver;padding-left:5px">#Dateformat(DateEffective, CLIENT.DateFormatShow)# <font size="1"><cfif DateEffectiveFull eq "0"><cfif DateEffectiveHour eq "6">AM<cfelse>PM</cfif><cfelse>...</cfif></font></td>
									<td align="left" style="border-left:1px solid silver;padding-left:5px;padding-right:3px"><cfif dateeffective neq dateexpiration>#Dateformat(DateExpiration, CLIENT.DateFormatShow)# <font size="1"><cfif DateExpirationFull eq "0"><cfif DateEffectiveHour eq "12">PM<cfelse>AM</cfif><cfelse>...</cfif></cfif></font></td>							
									<td align="right" style="border-left:1px solid silver;padding-left:4px;padding-right:3px;">#NumberFormat(DaysLeave,".__")#</TD>		
									<cfif LeaveAccrual eq "0" and WorkdaysOnly eq "0">
									
									<td align="right" style="cursor:pointer;border:1px solid silver;background-color:ffffff;padding-left:3px;padding-right:3px;">
										#NumberFormat(DaysDeduct,".__")#
									</td>
									<cfelse>
									
										<cfif leavedeductdetail gte "0" and edt eq "1">																				
										<td align="right" onclick="deduction('#leaveid#')" style="cursor:pointer;border:1px solid silver;background-color:##ffffaf50;padding-left:3px;padding-right:3px;" id="deduct_#leaveid#">
										#NumberFormat(LeaveDeductDetail,".__")#
										</td>
										<cfelseif leavedeductdetail gt "0">
										<td align="right" id="deduct_#leaveid#" style="background-color:##DAF9FC50;border:1px solid silver;padding-left:3px;padding-right:5px;" id="deduct_#leaveid#">	
										#NumberFormat(LeaveDeductDetail,".__")#
										</td>					
										<cfelse>
										<td align="right" id="deduct_#leaveid#" style=";background-color:##DAF9FC50;border:1px solid silver;padding-left:3px;padding-right:5px;" id="deduct_#leaveid#">	
										#NumberFormat(DaysDeduct,".__")#
										</td>
										</cfif>										
										
									</cfif>		
									
									<td align="right"
									style="cursor:pointer;border:1px solid silver;background-color:##ffffff50;padding-left:3px;padding-right:3px;">
									
									<cfif LeaveAccrual eq "0" and WorkdaysOnly eq "0">
									
										---
									
									<cfelse>
									
										<CF_DateConvert Value="#dateformat(dateEffective,client.dateformatshow)#">
										<cfset STR = dateValue>
	
										<CF_DateConvert Value="#dateformat(dateExpiration,client.dateformatshow)#">
										<cfset END = dateValue>
																			
										<cf_BalanceDays personno  = "#personno#" 
										    LeaveType         = "#LeaveType#" 
											leavetypeclass    = "#Leavetypeclass#" 
											start             = "#STR#" 
											startfull         = "#DateEffectiveFull#" 
											end               = "#END#" 
											endfull           = "#DateExpirationFull#">		
											
											<!--- ability to correct actual with proposed --->
											
											<cfif days eq DaysDeduct 
											    or abs(daysDeduct - days) gte "10"
												or workschema eq "0"
											    or LeaveAccrual eq "0" 
												or edt neq "1">
												
												<!--- no difference, no accrual, no flexible schedule, no edit allowed --->
																												
											#NumberFormat(Days,".__")#	
																					
											<cfelse>
											
												<table style="width:100%">
													<tr>
													<td align="left"><input style="width:50px;height:20px" onclick="Prosis.busy('yes');_cf_loadingtexthtml='';ptoken.navigate('setTaken.cfm?leaveid=#leaveid#','deduct_#leaveid#')" class="button10g" type="button" value="Apply"></td>
													<td align="right" style="background-color:red;padding-left:3px;padding-right:3px;color:white">#NumberFormat(Days,".__")#</td>
													</tr>
												</table>
											
											</cfif>
										
									</cfif>	
																			
									</td>							
										
							</tr>
										
							<cfif memo neq "" and transactionType neq "External">
															
								<tr style="display:#display#;height:15px" name="status_#status#" class="labelmedium navigation_row_child line">
								    <td></td><td></td>
									<td colspan="8" style="font-size:12px;padding-right:2px;padding-bottom:1px">#Memo#</td>
								</tr>
															
							</cfif>
																									
							<cfif workflowid neq "">
							
								<cfif Status eq "1" and session.acc eq officerUserId>
								
									<tr id="box_#workflowid#">
									   
										<td colspan="11" id="#workflowid#">
										
										<cfset url.ajaxid = workflowid>
										<cfinclude template="EmployeeLeaveEditWorkflow.cfm">
										
										</td>
									</tr>
								
								<cfelse>
								
									<tr id="box_#workflowid#" class="hide">									    
										<td colspan="11" id="#workflowid#"></td>
									</tr>
								
								</cfif>
							
							</cfif>
									
						</cfoutput>
					
					</cfif>
				
				</cfoutput>
											
			</cfoutput>
			
		</TABLE>
		
		</cf_divscroll>

	</td>
   </tr>

</TABLE>

<cfset ajaxonload("doHighlight")>

<script>
	Prosis.busy('no')
</script>
