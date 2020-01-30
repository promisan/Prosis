
<cfajaximport tags="cfwindow,cfform">
<cf_dialogworkorder>
<cf_dialogProcurement>
<cf_textareascript>
<cf_calendarscript>

<cfparam name="URL.Mode"                default="entry">
<cfparam name="URL.Header"              default="0">
<cfparam name="Status"                  default="1">
<cfparam name="client.width"            default="800">
<cfparam name="client.orgunit"          default="">
<cfparam name="URL.mycl"                default="0">
<cfparam name="add"                     default="0">

<cfif url.refer eq "Workflow">
	 <cfset url.mode = "Edit">
</cfif>

<!--- clear collaboration for cancelled request to prevent that workflow
still shows as action --->

<cfquery name="Clear" 
datasource="AppsOrganization" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    UPDATE OrganizationObject
	SET    Operational = '0'
	WHERE  ObjectkeyValue1 IN (SELECT RequisitionNo 
	                           FROM   Purchase.dbo.RequisitionLine 
							   WHERE  ActionStatus = '9')
	AND    EntityCode IN ('ProcReq','ProcReview')
</cfquery>

<!--- provisision to receive a correct link --->
<cfset url.id = replace(URL.ID,"'","","ALL")> 

<cfquery name="Line" 
datasource="AppsPurchase" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
    FROM   RequisitionLine 
	WHERE  RequisitionNo = <cfqueryparam value="#URL.ID#" cfsqltype="CF_SQL_CHAR"> 
</cfquery>

<cfif url.header eq "1" or url.refer eq "workflow">

	<cf_tl id="Requisition" var="1">
			
	<cfparam name="url.sessionNo" default="0">
						
	<cf_screentop 
		  html   = "Yes" 		 
		  label  = "#Line.Mission# #lt_text#" 		 		 
		  height = "100%" 
		  scroll = "yes" 
		  banner = "yellow" 
		  jquery = "yes"
		  line   = "no"
		  layout = "webapp" 	
		  MenuAccess    = "context"	  
		  SystemModule  = "Procurement"
		  FunctionClass = "Window"
		  FunctionName  = "Requisition Edit" <!--- creates an entry in systemfunctionid --->
		  close  ="window.close();try { opener.document.getElementById('refreshbutton').click() } catch(e) {}">		
		  
<cfelse>

	<cf_screentop scroll="yes" html="No">
		
</cfif>

<cfoutput>
	<script>
	
		function changeDates(range)	{
			vFormat = "#Replace(CLIENT.DateFormatShow,'mm','MM')#";

			if (range.start) {
				var vStart = kendo.toString(range.start, vFormat);
				console.log(vStart);
			}
			
			if (range.end) {
				var vEnd   = kendo.toString(range.end, vFormat);
				console.log(vEnd);
			}				
			
		}	
	
		function showProjectListing(mis, per){
			try{
				ColdFusion.Window.destroy('wProjectListing');
			}catch(ee){}
			ColdFusion.Window.create('wProjectListing', 'Projects', '#session.root#/Procurement/Application/Requisition/Program/ProgramListing.cfm?mission='+mis+'&period='+per,{x:50,y:50,height:document.body.clientHeight-80,width:document.body.clientWidth-80,modal:true,center:true})    
		}
	</script>
</cfoutput>

<cf_dialogPosition>

<cfquery name="Org" 
datasource="AppsOrganization" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
    FROM   Organization 
	WHERE  OrgUnit   = '#Line.OrgUnit#'
</cfquery>

<cfif Line.recordcount eq "0">

	<cfoutput>
		<cf_message message="Requisition #URL.ID# has been removed from the system.">
		</cfoutput>
	<cfabort>

</cfif>

<cfparam name="url.period" default="#Line.Period#">

<cfquery name="Parameter" 
	datasource="AppsPurchase" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT * 
	FROM   Ref_ParameterMission
	WHERE  Mission = '#Line.Mission#' 
</cfquery>
	
<table width="100%" height="100%">
					
	<cfoutput>	
	
					
	<cfif URL.Mode eq "Listing" or url.mode eq "Budget" or URL.mode eq "Dialog" or URL.Mode eq "View" or URL.Mode eq "Portal" or URL.refer eq "Workflow">
		
		<tr><td height="20" style="padding-top:4px;padding-left:10px;padding-right:20px">
						
			<table border="0" width="100%">
			
			<tr class="line"><td>
			
			<table width="100%">
			
				<tr>
				<td style="height:28px;padding-left:10px" class="labelmedium">#Org.OrgUnitName#:&nbsp;<b>#Line.OfficerLastName#</td>								
				<td style="padding-left:6px" class="labelit"><cf_tl id="Reference">:</td>
				<td bgcolor="FDFEDE" class="labelmedium" align="center" style="padding-left:3px;border:1px solid silver"><cfif line.reference eq "">in Process<cfelse>#Line.Reference# (#Line.RequisitionNo#)</cfif></td>
				<cfif Line.ParentRequisitionNo neq "">
				<td style="padding-left:6px" class="labelit"><cf_tl id="Parent">:</td>
				<td bgcolor="FDFEDE" class="labelmedium" align="center" style="border:1px solid silver"><a href="javascript:ProcReqEdit('#Line.ParentRequisitionNo#','#url.mode#','')">#Line.ParentRequisitionNo#</a></td>
				</cfif>				
				<td style="padding-left:6px" class="labelit"><cf_tl id="Initiated">:</td>
				<td bgcolor="FDFEDE" class="labelmedium" align="center" style="border:1px solid silver">#dateformat(Line.Created, CLIENT.DateFormatShow)#</td>				
				<td style="padding-left:6px" class="labelit"><cf_tl id="Status">:</td>				
				<td bgcolor="FDFEDE" class="labelmedium" style="border:1px solid silver" align="center">
				<cfdiv bind="url:RequisitionEditStatus.cfm?requisitionno=#url.id#" id="reqstatus">		
				</td>
				</tr>	
								
				<!--- process details --->
				
				<tr class="labelmedium" style="height:1px">
				
				<td style="height:1px;padding-left:15px;font-size:17.5px">
				
				<cfif Line.source eq "Workflow">							
				<a href="javascript:workflowobjectopen('#Line.RequirementId#')"><font color="800080">[<cf_tl id="More on this request">...]</a>				
				</cfif>
				
				</td>
				
				
				<cfif Line.JobNo neq "" or Line.actionStatus gte "2">
		
					<cfquery name="Buyer" 
						datasource="AppsPurchase" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">
							SELECT   A.*,U.FirstName, U.LastName
							FROM     RequisitionLineActor A, System.dbo.UserNames U
							WHERE    A.ActorUserId = U.Account
							AND      RequisitionNo = '#Line.RequisitionNo#'    		
						</cfquery>
					
					<cfif buyer.recordcount gte "1">
												
						   <td style="padding-left:6px" height="23" class="labelit"><cf_tl id="Buyer">:</td>
							
							<td bgcolor="FDFEDE" class="labelmedium" style="padding-left:6px;border:1px solid silver">
								<table align="center" cellspacing="0" cellpadding="0">				
								<tr>
								<cfloop query="Buyer">
								<td style="height:15px" class="labelmedium">#LastName#;</td>
								</cfloop>				
								</tr>
								</table>
							</td>
							
													
					</cfif>	
				
				</cfif>
					
				<cfif Line.JobNo neq "">		
								
					    <td style="padding-left:6px" height="23" class="labelit"><cf_tl id="Procurement Job">:</td>
						<td bgcolor="FDFEDE" class="labelmedium" style="padding-left:3px;border:1px solid silver">	
							
							<cfquery name="Job" 
							datasource="AppsPurchase" 
							username="#SESSION.login#" 
							password="#SESSION.dbpw#">
							SELECT   *
							FROM     Job
							WHERE    JobNo = '#Line.JobNo#'    		
							</cfquery>
										
							<a href="javascript:ProcQuote('#Line.JobNo#','view')">							
								<font color="6688aa"><u><cfif job.caseNo neq "">#Job.CaseNo#<cfelse>#Job.JobNo#</cfif></font>				
							</a>
							
							</td>
											
				</cfif>		
		
				<cfquery name="Proc" 
					datasource="AppsPurchase" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
						SELECT   *
						FROM     PurchaseLine PL, Purchase P
						WHERE    RequisitionNo = '#Line.RequisitionNo#' 
						AND      PL.ActionStatus <> '9'
						AND      PL.PurchaseNo = P.PurchaseNo
				</cfquery>
						
				<cfif Proc.PurchaseNo neq "">
					
					<td style="padding-left:6px" height="23" class="labelit"><cf_tl id="Purchase No">:</td>
					<td bgcolor="FDFEDE" align="center" class="labelmedium" style="padding-left:3px;border:1px solid silver" class="labelmedium">
						<a href="javascript:ProcPOEdit('#Proc.PurchaseNo#','view')">#Proc.PurchaseNo#</a>
						 <cfif Proc.OrderDate eq "">
						   Pending
						   <cfelse>
						   [#dateformat(Proc.OrderDate,CLIENT.DateFormatShow)#]
						   </cfif>
					</td>
						
					
				</cfif>	
				
				</tr>								
				<!--- -------------- --->
						
								
				<cf_verifyOperational module="WorkOrder" Warning="No">				
				
				<cfif Operational eq "1" and Line.workorderid neq "">
						
					<cfquery name="workorder" 
					 datasource="AppsWorkOrder" 
					 username="#SESSION.login#" 
					 password="#SESSION.dbpw#">
						 SELECT  *			
						 FROM    WorkOrder W, Customer C
						 WHERE   W.CustomerId = C.CustomerId
						 AND     W.WorkorderId = '#Line.workorderid#'
					 </cfquery>	
													
				    <tr><td></td><td style="padding-left:3px;height:25;width:150px" class="labelit"><cf_tl id="WorkOrder">:</td>
						<td bgcolor="FDFEDE" style="padding-left:3px;border:1px solid silver" class="labelmedium"><a href="javascript:workorderview('#Line.workorderid#')"><font color="0080C0">#workorder.Reference#</font></a></td>
						
						<td style="padding-left:6px" class="labelit"><cf_tl id="Customer">:</td>
						<td bgcolor="FDFEDE" style="padding-left:3px;border:1px solid silver" class="labelmedium">#workorder.CustomerName#</td>
						
						<cfif line.requirementid neq "">
						
							<!--- check if already an requisition was made --->
							
							<cfquery name="getPrior" 
							 datasource="AppsPurchase" 
							 username="#SESSION.login#" 
							 password="#SESSION.dbpw#">
								 SELECT SUM(RequestQuantity) as Total			
								 FROM   RequisitionLine
								 WHERE  WorkorderId   = '#Line.workorderid#'
								 AND    WorkOrderLine = '#line.workorderline#'
								 AND    RequirementId = '#line.requirementid#'							 
								 AND    RequisitionNo != '#line.requisitionno#'
								 AND    ActionStatus >= '1' and ActionStatus < '9' 
							 </cfquery>	
							 
							 <cfif getPrior.Total gte "1">
							 
							    <td style="padding-left:6px" class="labelit"><cf_tl id="Already requested">:</td>
								<td bgcolor="FDFEDE" style="padding-left:3px;border:1px solid silver" class="labelmedium"><font color="FF0000">#getPrior.Total#</td>
							 
							 </cfif>	
						 
						 </cfif>					
						
				    </tr>	
				
				</cfif>
				
				<tr><td height="4"></td></tr>
				
				</table>
			</td></tr>
															
			</table>
			
		</td></tr>
		
	<cfelse>
			
		<tr><td class="hide" id="reqstatus"></td></tr>	
		
		<tr><td style="padding-left:26px">
		
		<table>
		
		<cf_verifyOperational module="WorkOrder" Warning="No">				
				
				<cfif Operational eq "1" and Line.workorderid neq "">
						
					<cfquery name="workorder" 
					 datasource="AppsWorkOrder" 
					 username="#SESSION.login#" 
					 password="#SESSION.dbpw#">
						 SELECT  *			
						 FROM    WorkOrder W, Customer C
						 WHERE   W.CustomerId = C.CustomerId
						 AND     W.WorkorderId = '#Line.workorderid#' 
					 </cfquery>	
				
				    <tr class="line"><td style="padding-left:23px:height:25" class="labelit"><cf_tl id="WorkOrder">:</td>
						<td style="padding-left:10px" height="18" class="labelmedium"><a href="javascript:workorderview('#Line.workorderid#')">#workorder.Reference#</a></td>
						<td style="padding-left:10px" class="labelit"><cf_tl id="Customer">:</td>
						<td style="padding-left:10px" class="labelmedium">#workorder.CustomerName#</td>
						
						<!--- check if already an requisition was made --->
						
						<cfquery name="getPrior" 
						 datasource="AppsPurchase" 
						 username="#SESSION.login#" 
						 password="#SESSION.dbpw#">
							 SELECT SUM(RequestQuantity) as Total			
							 FROM   RequisitionLine
							 WHERE  WorkorderId    = '#Line.workorderid#'
							 AND    WorkOrderLine  = '#line.workorderline#'
							 AND    RequirementId  = '#line.requirementid#'
							 AND    RequisitionNo != '#line.requisitionno#'
							 AND    ActionStatus >= '1' and ActionStatus < '9' 
						 </cfquery>	
						 
						 <cfif getPrior.Total gte "1">
						 
						    <td style="padding-left:10px" class="label"><cf_tl id="Already requested">:</td>
							<td style="padding-left:10px" class="labelmedium"><font color="FF0000">#getPrior.Total#</td>
						 
						 </cfif>						
						
				    </tr>	
					
				</cfif>
		
		</table>		
		</td></tr>		
		
				
	</cfif>
	</cfoutput>	
		
	<tr class="hide" id="resultbox"><td height="10" id="resultsubmit"></td></tr>
			   	    				
	<tr><td colspan="2" style="padding-left:14px;height:100%" valign="top">
		
		<table width="100%" height="100%">
				
		<cfif line.actionStatus neq "0">
		 	<cf_tl id="Line No" var="1">
		    <cfset hdr = "#lt_text#: #Line.Reference# (#URL.ID#)">		
		<cfelse>
			<cf_tl id="Entry Form" var="1">
			<cfset hdr = "#lt_text#">		
		</cfif>		
								
		<cfif add eq "1">
		
			<tr><td valign="top" height="100%">
		
			  <table width="100%" height="100%">
			  
				  <tr>
					  <td valign="top" style="padding-left:10px;">
										 					  
					  <cfform action= "RequisitionEditSubmit.cfm?ID=#URL.ID#&Mode=#URL.Mode#" 
				    	  method= "POST" 		
						  style="height:98%"		
						  name  = "processaction">
															
							<cfinclude template="RequisitionEditForm.cfm">				
									
					  </cfform>
								  
					  </td>
				  </tr>
				  
				  <tr class="hide">
				  
				  	<td><cfdiv id="unitinfolist" bind="url:RequisitionUnitInfo.cfm?ID=#URL.ID#&orgunit="></td>
					
				  </tr>
			  
			  </table>	
			  
			  <input type="hidden" name="reqno" id="reqno" value="<cfoutput>#url.id#</cfoutput>">				
		
		<cfelse>	
				
			<!--- 25/11 not longer needed to be removed as it is part of the menu --->
							
			<tr class="hide">
			  	<td><cfdiv id="unitinfolist" bind="url:RequisitionUnitInfo.cfm?ID=#URL.ID#&orgunit="></td>
			</tr>		
								
			<tr><td align="center" valign="top" style="padding-right:20px">
						
			<!--- top menu --->
					
			<table width="100%" style="height:1px;border-bottom:1px solid silver"  align="center">		
										
				<cf_menuscript>
							
				<cfset ht = "58">
				<cfset wd = "58">
				<cfset pad = "2">		
				
				<cfset add = 1>
							
				<input type="hidden" name="reqno" id="reqno" value="<cfoutput>#url.id#</cfoutput>">
			
				<tr>		
					
					<cf_tl id="Edit Request" var="vEdit">
					
					<cfset itm = 1>
					
					<cf_menutab item       = "#itm#" 
			            iconsrc    = "Logos/Procurement/Edit.png" 
						iconwidth  = "#wd#" 
						iconheight = "#ht#" 
						padding    = "#pad#"
						class      = "highlight1"
						name       = "#vEdit#">	
						
					<cfquery name="Check" 
					     datasource="AppsPurchase" 
					     username="#SESSION.login#" 
					     password="#SESSION.dbpw#">
						 SELECT  P.EntityClass
						 FROM    ItemMaster IM INNER JOIN
			                     RequisitionLine L ON IM.Code = L.ItemMaster INNER JOIN
				                 Ref_ParameterMissionEntryClass P ON IM.EntryClass = P.EntryClass 
							 AND L.Mission = P.Mission 
							 AND L.Period = P.Period
						 WHERE   (L.RequisitionNo = '#URL.ID#')
					</cfquery>	
					
					<cfif line.ActionStatus eq "1" or line.ActionStatus eq "1p" or line.ActionStatus eq "1f">	
										
						<cfif check.entityclass eq "" 
						    and (Line.OfficerUserId eq session.acc or getAdministrator(Line.Mission) eq "1")>	
						
							<!--- no workflow and requester iof this request --->	
															
							<cfset itm = itm+1>	
							<cf_tl id="Grant Access" var="vAccess">
							<cf_menutab item       = "#itm#" 
					            iconsrc    = "Logos/User/Password.png" 
								iconwidth  = "#wd#" 
								iconheight = "#ht#" 	
								targetitem = "2"
								padding    = "#pad#"	
								source="../Authorization/Authorization.cfm?id=#URL.ID#"			
								name       = "#vAccess#">	
							
						</cfif>			
					
					</cfif>
						
					<cfset itm = itm+1>	
					<cf_tl id="Schedule Request" var="vSchedule">
					<cf_menutab item       = "#itm#" 
			            iconsrc    = "Logos/Attendance/Schedule.png" 
						iconwidth  = "#wd#" 
						iconheight = "#ht#" 	
						targetitem = "2"
						padding    = "#pad#"	
						source="../Schedule/RequisitionSchedule.cfm?id=#URL.ID#"			
						name       = "#vSchedule#">			
						
					<cfset itm = itm+1>	
					
					<cf_tl id="Memo" var="vNotes">
					<cf_menutab item       = "#itm#" 
			            iconsrc    = "Logos/System/Notes.png" 
						iconwidth  = "#wd#" 
						iconheight = "#ht#" 	
						targetitem = "2"
						padding    = "#pad#"				
						name       = "#vNotes#"
						source="RequisitionEditNote.cfm?requisitionno=#URL.ID#">			
													
					<cfquery name="Actions" 
					datasource="AppsPurchase" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
					    SELECT   R.ActionId, R.ActionDate, R.OfficerLastName, R.OfficerFirstName, S.StatusDescription, R.ActionMemo
						FROM     RequisitionLineAction R INNER JOIN
					             Status S ON R.ActionStatus = S.Status
						WHERE    S.StatusClass = 'Requisition'
						AND      RequisitionNo = '#URL.ID#'
						ORDER BY R.Created DESC
					</cfquery>
											
					<cfif Actions.recordcount gt "0">			
									
						<cfset itm = itm + 1>	
						
						<cf_tl id="Edit and Clearance Log" var="1">		
									
					    <cf_menutab item       = "#itm#" 
						            iconsrc    = "Logos/System/Log.png" 
									iconwidth  = "#wd#" 
									iconheight = "#ht#" 
									targetitem = "2"
									padding    = "0"
									name       = "#lt_text#"
									source="RequisitionActionLog.cfm?id=#URL.ID#">					
		
					</cfif>
					
					<!--- ----------------------------------------------------------- --->		
					<!--- trigger or show collaboration workflow in regular edit mode --->
					<!--- ----------------------------------------------------------- --->
					
					<cf_workflowenabled 
					     mission="#line.mission#" 
						 entitycode="ProcReq">	 
						 			 
						 <cfquery name="CheckWF" 
						     datasource="AppsOrganization" 
						     username="#SESSION.login#" 
						     password="#SESSION.dbpw#">
							 SELECT     * 
							 FROM       OrganizationObject
							 WHERE      Operational = 1
							 AND        EntityCode = 'ProcReq'
							 AND        ObjectKeyValue1 = '#URL.ID#'
						</cfquery>	
																	
						<cfif workflowenabled eq "1" 
						    and (line.actionstatus eq "1p" or line.actionStatus gte "2" or line.actionStatus gte "2a") 
						    and checkwf.recordcount gte "1">
						
							<cf_ActionListingScript>
							<cf_FileLibraryScript>
							
							<cfset itm = itm + 1>	
							
							<cfoutput>	
						
							  <input type="hidden" 
						   		     name="workflowlink_prepare_#url.id#" 
									 id="workflowlink_prepare_#url.id#" 
							         value="RequisitionEditFlow.cfm">						
								
							</cfoutput>					
						
							    <cf_tl id="Approval Flow" var="1">
															
					    		<cf_menutab item       = "#itm#" 
						            iconsrc    = "Logos/System/Reset.png" 
									iconwidth  = "#wd#" 
									iconheight = "#ht#" 
									targetitem = "2"
									padding    = "#pad#"
									name       = "#lt_text#"
									source="RequisitionEditFlow.cfm?ajaxid=prepare_#URL.ID#">			
							
																
						</cfif>	
						
						<!--- ----------- --->
						<!--- review flow --->	 
						<!--- ----------- --->
						
						<cfquery name="Check" 
						     datasource="AppsPurchase" 
						     username="#SESSION.login#" 
						     password="#SESSION.dbpw#">
							 SELECT     P.EntityClass
							 FROM       ItemMaster IM INNER JOIN
				                        RequisitionLine L ON IM.Code = L.ItemMaster INNER JOIN
					                    Ref_ParameterMissionEntryClass P ON IM.EntryClass = P.EntryClass 
										AND L.Mission = P.Mission 
										AND L.Period = P.Period
							 WHERE      L.RequisitionNo = '#URL.ID#'
						</cfquery>	
						
						<cfquery name="FlowSetting" 
						datasource="AppsPurchase" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">		
								SELECT   S.*
								FROM     RequisitionLine R INNER JOIN
						                 ItemMaster M ON R.ItemMaster = M.Code INNER JOIN
						                 Ref_ParameterMissionEntryClass S ON R.Mission = S.Mission AND R.Period = S.Period AND M.EntryClass = S.EntryClass
								WHERE    (R.RequisitionNo = '#URL.ID#')
						</cfquery>		
						
						<cfif FlowSetting.EnableFundingClear eq "0">
					      <cfset wfs = "2">
						<cfelse>
					      <cfset wfs = "1p"> 
						</cfif>			
						
						<cfif check.entityclass neq "" and (line.actionstatus gt wfs or line.actionstatus gte "#wfs#a")>	 
							
								<cf_ActionListingScript>
								<cf_FileLibraryScript>
									
								<cfoutput>	
							
								  <input type="hidden" 
							   		name="workflowlink_review_#url.id#" 
	                                id="workflowlink_review_#url.id#"
								    value="RequisitionReviewFlow.cfm">					 					 	
								
								</cfoutput>
								
								<cfset itm = itm + 1>	
								
								<cf_tl id="Requisition Review" var="1">
								
								<cf_menutab item       = "#itm#" 
						            iconsrc    = "Logos/System/Reset.png" 
									iconwidth  = "#wd#" 
									iconheight = "#ht#" 
									targetitem = "2"
									padding    = "#pad#"
									name       = "#lt_text#"
									source="RequisitionReviewFlow.cfm?ajaxid=review_#URL.ID#">		
												
						</cfif>		
						
						<cf_tl id="Unit Information" var="1">
						
						<cfset itm = itm + 1>	
									
						<cf_menutab item       = "#itm#" 
						            iconsrc    = "Logos/System/Info.png" 
									iconwidth  = "#wd#" 
									iconheight = "#ht#" 
									targetitem = "2"
									padding    = "#pad#"
									name       = "#lt_text#"
									source     = "RequisitionUnitInfo.cfm?ID=#URL.ID#&orgunit={orgunit2}">		
									
			</tr>
			
			</table>	
			
			</td>
			
			</tr>
										
			<tr><td height="100%" valign="top" width="100%" style="padding-left:20px;padding-right:20px">
						
						<table width="100%" 
					      border="0"	
						  height="100%"				 
						  cellspacing="0" 
						  valign="top"						  
						  cellpadding="0">									  													
								  
						<cf_menucontainer item="1" class="regular">							
																	
								<cfform action= "RequisitionEditSubmit.cfm?ID=#URL.ID#&Mode=#URL.Mode#&refer=#url.refer#" 
							    	method= "POST" 	
									style="height:100%"
									name  = "processaction">												
														
									<cfinclude template="RequisitionEditForm.cfm">						
											
								</cfform>
						
						</cf_menucontainer>
						
						<cf_menucontainer item="2" class="hide">
						
						</table>
								
					
				
				</td>
				
			</tr>		
			
		</cfif>		
			
		</td></tr>
		
		</table>
		
	</td></tr>
		
	</table>	

		
<cfif url.header eq "1" or url.mode eq "workflow">
	<cf_screenbottom layout="webapp">	
</cfif>


