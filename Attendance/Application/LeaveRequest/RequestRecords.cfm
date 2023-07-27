
<cfparam name="url.action"          default="">
<cfparam name="url.filterleavetype" default="">
<cfparam name="url.filteryear"      default="#year(now())#">
<cfparam name="url.filterstatus"    default="">
 
<cfif url.action eq "delete">
 
 	<cfquery name="Delete" 
     datasource="AppsEmployee" 
     username="#SESSION.login#" 
     password="#SESSION.dbpw#">
	     DELETE FROM PersonWorkDetail
		 WHERE  LeaveId = '#url.leaveid#'	
		 AND    LeaveId is not NULL
    </cfquery> 
	
	 <cfquery name="Old" 
     datasource="AppsEmployee" 
     username="#SESSION.login#" 
     password="#SESSION.dbpw#">
	     SELECT * FROM PersonLeave
		 WHERE   LeaveId = '#url.leaveid#'	
    </cfquery> 
 
	 <cfquery name="Delete" 
     datasource="AppsEmployee" 
     username="#SESSION.login#" 
     password="#SESSION.dbpw#">
	     DELETE FROM PersonLeave
		 WHERE   LeaveId = '#url.leaveid#'	
    </cfquery> 
	
	<cfinvoke component  = "Service.Process.Employee.Attendance"  
		   method        = "LeaveBalance" 
		   PersonNo      = "#old.PersonNo#" 			   
		   LeaveType     = "#old.LeaveType#"
		   BalanceStatus = "0"
		   StartDate     = "#old.DateEffective#"
		   EndDate       = "#old.DateExpiration#">			
	 
</cfif>
 
<cfquery name="Base" 
     datasource="AppsEmployee" 
     username="#SESSION.login#" 
     password="#SESSION.dbpw#">
	 
     SELECT   L.*, 
	 
	   		( SELECT Description 
		      FROM   Ref_LeaveTypeClass 
			  WHERE  LeaveType = L.LeaveType 
			  AND    Code      = L.LeaveTypeClass   ) as LeaveTypeClassDescription,
			
		    ( SELECT Description 
		      FROM   Ref_PersonGroupList 
			  WHERE  GroupCode     = L.GroupCode 
			  AND    GroupListCode = L.GroupListCode) as LeaveClassGroupDescription,
			  
			( SELECT TOP 1 ObjectKeyValue4 
			  FROM     Organization.dbo.OrganizationObject 
			  WHERE    ObjectKeyValue4 = L.LeaveId
			  AND      EntityCode = 'EntLve' 
			  AND      Operational = 1) as WorkflowId,
	 
	        ( SELECT FirstName+' '+LastName 
			  FROM System.dbo.UserNames 
			  WHERE Account = L.HandoverUserId) as Handover,
			  
			  Year(DateEffective) as LeaveYear,			   
	          R.Description
			
     FROM     PersonLeave L, Ref_LeaveType R
	 WHERE    L.PersonNo        = '#URL.ID#'     
	  AND     R.LeaveType = L.LeaveType 
	  AND     L.TransactionType IN ('Request','Manual')		
	  
	 UNION ALL
	  
	 SELECT   L.*, 
	 
	   		( SELECT Description 
		      FROM   Ref_LeaveTypeClass 
			  WHERE  LeaveType = L.LeaveType 
			  AND    Code      = L.LeaveTypeClass   ) as LeaveTypeClassDescription,
			
		    ( SELECT Description 
		      FROM   Ref_PersonGroupList 
			  WHERE  GroupCode     = L.GroupCode 
			  AND    GroupListCode = L.GroupListCode) as LeaveClassGroupDescription,
			  
			( SELECT TOP 1 ObjectKeyValue4 
			  FROM     Organization.dbo.OrganizationObject 
			  WHERE    ObjectKeyValue4 = L.LeaveId
			  AND      EntityCode = 'EntLve' 
			  AND      Operational = 1) as WorkflowId,
	 
	        ( SELECT FirstName+' '+LastName 
			  FROM System.dbo.UserNames 
			  WHERE Account = L.HandoverUserId) as Handover, 
			  
			  Year(DateEffective) as LeaveYear,			   			  
	          R.Description
			  
     FROM     PersonLeave L, Ref_LeaveType R
	 WHERE    L.PersonNo        = '#URL.ID#'     
	  AND     R.LeaveType = L.LeaveType 
	  AND     L.TransactionType IN ('External')		
	  AND     L.Status < '8'
	  
	  
     ORDER BY Year(DateEffective) DESC, L.DateEffective DESC 
</cfquery> 

<cfset found = "0">

<table width="100%" align="center">
	<tr>
		<td class="clsPrintContent">
			<table width="100%">
			<tr class="line">
			<td>

				<cfoutput>
				 <table>
						   <tr style="height:35px">	
						  			  		   
						   <td class="labelmedium" style="padding-left:10px"><cf_tl id="Leave type">:</td>
						   <td style="padding-left:10px">
						   
						   <cfquery name="qLeaveType" dbtype="query">
							   SELECT DISTINCT LeaveType, Description
							   FROM Base
						   </cfquery>		   
						   
						   <select name="filterleavetype" id="filterleavetype" class="regularxl" onchange="records('#url.id#')">
						   <option value=""><cf_tl id="All"></option>
						   <cfloop query="qleavetype">
						     <option value="#LeaveType#" <cfif url.filterleavetype eq leavetype>selected</cfif>>#Description#</option>
						   </cfloop>		   
						   </select>
						   
						   </td>
						   <td class="labelmedium" style="padding-left:10px"><cf_tl id="Status">:</td>
						   <td style="padding-left:10px">
						   
						     <cfquery name="qStatus" dbtype="query">
							   SELECT DISTINCT Status
							   FROM Base
						   </cfquery>		   
						   
						   <select name="filterstatus" id="filterstatus" class="regularxl" onchange="records('#url.id#')">
						   <option value=""    <cfif url.filterstatus eq "">selected</cfif>><cf_tl id="All excl. cancelled"></option>
						   <option value="All" <cfif url.filterstatus eq "All">selected</cfif>><cf_tl id="All incl. cancelled"></option>						  
						   <cfloop query="qStatus">
						   
						    <cfswitch expression="#Status#">
							 		<cfcase value="0"><cf_tl id="Pending"    var="1"></cfcase>
						            <cfcase value="1"><cf_tl id="In Process" var="1"></cfcase>
									<cfcase value="2"><cf_tl id="Approved"   var="1"></cfcase>				
									<cfcase value="8"><cf_tl id="Cancelled"  var="1"></cfcase>
									<cfcase value="9"><cf_tl id="Denied"     var="1"></cfcase>
							</cfswitch>			
						   
						     <option value="#Status#" <cfif url.filterstatus eq status>selected</cfif>>#lt_text#</option>
						   </cfloop>		   
						   </select>
						   
						   </td>
						    <td class="labelmedium" style="padding-left:10px"><cf_tl id="Year">:</td>
						   <td style="padding-left:10px">
						   
						    <cfquery name="qYear" dbtype="query">
							   SELECT DISTINCT LeaveYear
							   FROM Base
							   ORDER BY LeaveYear DESC
						   </cfquery>			
						   
						   <select name="filteryear" id="filteryear" class="regularxl" onchange="records('#url.id#')">
						   <option value=""><cf_tl id="All"></option>
						   <cfloop query="qyear">
						     <option value="#LeaveYear#" <cfif url.filteryear eq leaveyear>selected</cfif>>#LeaveYear#</option>
							 
							 <cfif url.filteryear eq leaveyear>
								 <cfset found = "1">
							 </cfif>
						   </cfloop>		   
						   </select>
						   
						   </td>
						   </tr>
						   
				  </table> 
				  </cfoutput>
						   
			</td>
			<td align="right" style="padding-right:10px;" class="clsNoPrint">
				<cfoutput>
					<cfquery name="qPerson" 
				     datasource="AppsEmployee" 
				     username="#SESSION.login#" 
				     password="#SESSION.dbpw#">
					     SELECT *
					     FROM 	Person
						 WHERE  PersonNo = '#url.id#'
				    </cfquery> 
					
					<span id="printTitle" style="display:none;"><cf_tl id="Leave Records" var= "1"> #ucase("#lt_text# - #qPerson.IndexNo# (#qPerson.PersonNo#) - #qPerson.fullname#")#</span>
					
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
				</cfoutput>
			</td>
			</tr>		

			<!--- Query returning search results --->
			<cfquery name="Search" dbtype="query">
			  	SELECT *
				FROM Base  
			  	WHERE 1=1
				<cfif url.filterleavetype neq "">
				  AND LeaveType = '#url.filterleavetype#'
			  	</cfif>
			   <cfif url.filterstatus eq "All">
					<!--- show all --->
			    <cfelseif url.filterstatus neq "">
				  AND Status = '#url.filterstatus#'
				<cfelse>
			      AND Status NOT IN ('8','9')		  
				</cfif>
			    <cfif url.filteryear neq "" and found eq "1">
				  AND LeaveYear = '#url.filteryear#' 
				</cfif>
			</cfquery>	   

			<tr><td>
				
				<cfif Search.recordCount gt 0>
									
						<table width="97%" style="min-width:900" align="center" class="navigation_table">
							
						    <tr class="labelmedium line">
							  <td height="23"></td>
							  <td></td>
							  <td style="width:40px"></td>
							  <td style="width:35%"><cf_tl id="Type">/<cf_tl id="Class"></td>			 				  
							  <td style="padding-left:4px"><cf_tl id="Recorded by"></td>
							  <td><cf_tl id="First Day"></td>
							  <td><cf_tl id="Last Day"></td>
							  <td style="padding-left:4px"><cf_tl id="Backup"></td>				  
							  <td align="right"><cf_tl id="Days"></td>
							  <td align="right" style="padding-right:4px"><cf_tl id="Deduct"></td>					 
							  
							</tr>
							
							<cfoutput group="LeaveYear" query="Search">
							
								<tr class="line">
								<td colspan="10" style="padding-left:10px;font-size:20px">
								
									<cfquery name="LeaveStatus" 
									datasource="AppsEmployee" 
									username="#SESSION.login#" 
									password="#SESSION.dbpw#">
										SELECT    P.LeaveType, R.Description, P.LeaveTypeClass,
					                              (SELECT        Description
					                               FROM            Ref_LeaveTypeClass
					                               WHERE        (LeaveType = P.LeaveType) AND (Code = P.LeaveTypeClass)) AS ClassName, 							  								   
												   
												   
											      SUM(P.DaysDeduct) AS Taken
										FROM      PersonLeave AS P INNER JOIN
					                    		  Ref_LeaveType AS R ON P.LeaveType = R.LeaveType
										WHERE     P.PersonNo = '#url.id#' 
										AND       YEAR(P.DateEffective) = '#leaveyear#'
										AND       Status IN ('0','1','2')
										GROUP BY  P.LeaveType, P.LeaveTypeClass, R.Description
										ORDER BY  P.LeaveType, P.LeaveTypeClass, R.Description
									</cfquery>	
								
									<table width="100%" height="100%">
									  <tr class="labelmedium2">
									  <td style="font-size:29px" valign="top">#LeaveYear#</td>
									  <td align="right" style="width:400px">
									  
										  <table bgcolor="ffffcf" width="100%" style="border:1px solid silver;">
										  <cfloop query="leavestatus">
										  <tr class="<cfif currentrow neq recordcount>line</cfif> labelmedium2" style="height:25px">
										  	<td style="padding-left:4px">#Description# : <cfif classname neq description>#ClassName#</cfif></td>							
											<td align="right" style="padding-right:3px;">#NumberFormat(Taken,"__.__")#</td>
										  </tr>
										  </cfloop>
										  </table>
									  
									  </td>
									  </tr>
									</table>  
												
								</td>
								
								</tr>					
						
							<cfoutput>
							
								<cfif status eq "0">
								  <cfset cl = "ffffaf">
								<cfelse>
								  <cfset cl = "transparent">
								</cfif>    
							
								<tr class="line labelmedium navigation_row" bgcolor="#cl#" style="height:24px">
								   							   					   								
										<cfif workflowid neq "">
									 
										 <td align="center" style="cursor:pointer; padding-left:20px;" onclick="workflowdrill('#workflowid#','box_#workflowid#')">
										 
										 		<cfif status neq "0">
																			
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
													 
												<cfelse>
												
												<img id="exp#WorkflowId#" 
												     class="hide" 
													 src="#SESSION.root#/Images/arrowright.gif" 
													 align="absmiddle" 
													 alt="Expand" 
													 height="9"
													 width="7"			
													 border="0"> 	
																 
											   <img id="col#WorkflowId#" 
												     class="regular" 
													 src="#SESSION.root#/Images/arrowdown.gif" 
													 align="absmiddle" 
													 height="10"
													 width="9"
													 alt="Hide" 			
													 border="0"> 
													 
												
												
												</cfif>	 
											
										<cfelse>
										
										<td align="center" style="padding-left:20px;">	
										  
								        </cfif>	 
								
								<td style="width:30px;padding-left:8px">
								
									<cfif Status eq "2">
										<cfset cl = "lime">
										<cf_tl id="Pending" var="1"> 
									<cfelseif status eq "9">	
									    <cfset cl = "red">
										<cf_tl id="Denied" var="1"> 
									<cfelseif status eq "8">	
									    <cfset cl = "##c7c7c7">
										<cf_tl id="Cancelled" var="1"> 
									<cfelseif status eq "1">
										<cfset cl = "yellow">
										<cf_tl id="Process" var="1"> 
									<cfelse>
										<cfset cl = "white">		
										<cf_tl id="Draft" var="1">
									</cfif>
									
									<table style="width:20px">
										<tr class="labelit" style="height:20px">
										<td align="center" style="border:1px solid b1b1b1;background-color:#cl#"><!--- #lt_text# ---></td>
										</tr>
									</table>
								
								 </td>	
								
								 <td style="padding-left:6px;padding-right:6px" align="center">
								 
									  <table cellspacing="0" cellpadding="0">
									  <tr>
													
									   <cfif Status eq "0">
										   <td>							   
										     <cf_img icon="edit" onclick="leaveedit('#LeaveId#')">							   
										   </td>
										   
										   <td style="padding-left:4px">
										   <cfif getAdministrator("*") eq "1">
										       <cf_img icon="delete" onclick="ColdFusion.navigate('#session.root#/attendance/application/leaveRequest/RequestRecords.cfm?id=#url.id#&action=delete&leaveid=#leaveid#','log')">
										   </cfif>
										   </td>
										<cfelse>
										   <td>	
										   	
												<cfquery name="GetComments" 
												datasource="AppsOrganization" 
												username="#SESSION.login#" 
												password="#SESSION.dbpw#">
													SELECT     *
													FROM       OrganizationObjectActionMail M
													WHERE      ObjectId = '#LeaveId#'
													AND        MailType = 'Comment'
													<cfif getAdministrator("*") eq "0">
													AND        MailScope = 'All'
													</cfif>
													ORDER BY SerialNo 
												</cfquery>										   	
										   							   
										     	<cfif GetComments.recordcount neq 0>
										     		<img src="#session.root#/images/chat20.png" onclick="viewcomments('#LeaveId#')">
										     	</cfif>									   
										   </td>
										</cfif>
										
										</tr>
									 </table>			
							          
							     </td>	
								 <td>#Description#
								  
										<cfif LeaveTypeClassDescription neq "" and LeaveTypeClassDescription neq Description>/&nbsp;<font color="008080">#LeaveTypeClassDescription#</cfif>
										<cfif LeaveClassGroupDescription neq "">#LeaveClassGroupDescription#</cfif>		
								 
								 </td>					
								 <td style="padding-left:4px">
								 <cfif transactionType neq "External">
								 #OfficerFirstName# #OfficerLastName# <font size="1">[#DateFormat(Created, CLIENT.DateFormatShow)# #TimeFormat(Created, "HH:MM")#]</font>
								 <cfelse>
								 <font color="C0C0C0"><cf_tl id="Migrated record"></font>
								 </cfif>
								 </td>				 						 
								 <td>#DateFormat(DateEffective, CLIENT.DateFormatShow)# <cfif DateEffectiveFull eq "0">(1/2)</cfif><cfif DateEffectiveHour eq "6">AM<cfelseif DateEffectiveHour eq "12">PM</cfif></td>
								 <td>#DateFormat(DateExpiration, CLIENT.DateFormatShow)# <cfif DateExpirationFull eq "0">(1/2)</cfif><cfif DateExpirationHour eq "6">AM<cfelseif DateExpirationHour eq "12">PM</cfif></td>
								 <td style="padding-left:4px">
								 	<cfif Handover eq ""><cfelse>#Handover#</cfif>
								 </td>							 
								 <td align="right">#DaysLeave#</td>
								 <td align="right" style="padding-right:4px">#DaysDeduct#</td>											 					 
							    </tr>
								
								<cfif HandoverNote neq "" and TransactionType neq "External">
									<tr class="labelmedium line">
										<td></td>							
										<td colspan="2" align="right"><cf_tl id="Handover">:</td>
									    <td colspan="7" bgcolor="EBF7FE" style="padding:4px;">#HandoverNote#</td>
									</tr>			
								</cfif>
								
								<cfif Memo neq "" and TransactionType neq "External">
									<tr class="labelmedium line">
									   <td></td>						   
									   <td colspan="2" align="right"><cf_tl id="Note">:</td>
									   <td bgcolor="f4f4f4" colspan="7" style="padding:4px;">#Memo#</td>
								   </tr>			
								</cfif>
								
								<cfif workflowid neq "">
																		
								 <cfset wflnk = "#session.root#/Attendance/Application/LeaveRequest/RequestWorkflow.cfm">
								 <cfset url.ajaxid = leaveid>
				   
							     <input type="hidden" 
						            name="workflowlink_#url.ajaxid#" 
									id="workflowlink_#url.ajaxid#"
						            value="#wflnk#">
									
									<cfif status eq "0">
									
										 <tr id="box_#workflowid#" class="regular">
										    <td colspan="2"></td>
											<td colspan="9" id="#workflowid#">
											<cfinclude template="RequestWorkFlow.cfm">
											</td>
										</tr>	
									
									<cfelse>
									
									   <tr id="box_#workflowid#" class="hide">
										    <td colspan="2"></td>
											<td colspan="9" id="#workflowid#"></td>
										</tr>	
										
									</cfif>	
									
								</cfif>
								
							</cfoutput>
							
						</cfoutput>	
					
						</table>
						
				<cfelse>
				
					<table width="97%" align="center" border="0" cellspacing="0" cellpadding="0">
						
						<tr class="labellarge">
						<td colspan="9" align="center" height="30"><cf_tl id="There are no records to show in this view"></td>
						</tr>		
						
					</table>		
					
				</cfif>

			</td></tr>

			</table>

		</td>
	</tr>
</table>

<cfset ajaxonload("doHighlight")>

<script>Prosis.busy('no')</script>