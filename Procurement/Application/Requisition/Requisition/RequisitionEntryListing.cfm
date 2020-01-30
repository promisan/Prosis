<cfoutput>
<head>
		<title>Print</title>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />		
		<link rel="stylesheet" type="text/css"  href="#SESSION.root#/#client.style#"> 	
	</head>
</cfoutput>	

<cfparam name="URL.Mode" default="Entry">
<cfparam name="URL.Print" default="0">
<cfparam name="URL.ajax" default="0">

<cf_verifyOperational 
         module="WorkOrder" 
		 Warning="No">				
	
<cfif URL.Mode eq "Entry">

	<cfquery name="Requisition" 
	datasource="AppsPurchase" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT   L.*,
	         R.*,
			 M.EntryClass, 
			 M.Description as ItemMasterDescription, 			
			 O.OrgUnitName,
			 
			 <cfif Operational eq "1">
			 
				 (SELECT Reference 
				  FROM   WorkOrder.dbo.WorkOrder 
				  WHERE  WorkOrderId = L.WorkOrderId) as WorkOrderReference,
			  
			 <cfelse>
			 
				 '' as WorkOrderReference,
			 
			 </cfif> 
			 
			 (SELECT count(*)
			  FROM   RequisitionLineTopic R, Ref_Topic S
			  WHERE  R.Topic = S.Code
			  AND    S.Operational   = 1
			  AND    R.RequisitionNo = L.RequisitionNo) as CountedTopics
			  
	FROM     RequisitionLine L, 
	         Status R, 
			 ItemMaster M, 
			 Organization.dbo.Organization O
	WHERE    L.ActionStatus = R.Status
	AND      L.OrgUnit      = O.OrgUnit
	AND      R.StatusClass  = 'Requisition' 
	AND      M.Code         = L.ItemMaster
	AND      L.Period       = '#url.period#'
	
	<!--- linked to unit under the entity --->
	AND      L.OrgUnit IN (SELECT OrgUnit 
	                       FROM   Organization.dbo.Organization 
						   WHERE  Mission = '#URL.Mission#')
	AND      L.ActionStatus = '1'
	
	<cfif getAdministrator(url.mission) eq "1">
	
	<!--- no filtering --->
	
	<cfelse>
		
	AND      ( <!---  L.RequisitionNo IN (SELECT RequisitionNo 
	                               FROM   RequisitionLineAction 
								   WHERE  OfficerUserId = '#SESSION.acc#') 
				OR
				
				--->
				
				L.RequisitionNo IN (
				                    SELECT RequisitionNo 
	                                FROM   RequisitionLineActor 
								    WHERE  OfficerUserId = '#SESSION.acc#'
								    AND    Role = 'ProcReqEntry' 
								   )
								      	
				OR	L.OfficerUserid = '#SESSION.acc#'
				)			  					 
	
	</cfif>			
				 
	ORDER BY O.OrgUnitName, L.Created DESC							
		
	</cfquery>
	

<cfelse>

	<!--- header lising --->

	<cfquery name="Requisition" 
	datasource="AppsPurchase" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT     L.*,
	           R.*,
			   M.EntryClass, 
			   M.Description as ItemMasterDescription, 
			   M.ObjectCode, 
			   O.OrgUnitName,
			   
			   <cfif Operational eq "1">
			   
			   (SELECT Reference 
			    FROM   Workorder.dbo.WorkOrder 
				WHERE WorkOrderId = L.WorkOrderId) as WorkOrderReference,
				
			   <cfelse>
			   
			    '' as WorkOrderReference,
			   			   
			   </cfif>	
			   
			   (SELECT count(*)
			    FROM   RequisitionLineTopic R, Ref_Topic S
			    WHERE  R.Topic = S.Code
			    AND    S.Operational   = 1
			    AND    R.RequisitionNo = L.RequisitionNo) as CountedTopics
			  
	FROM       RequisitionLine L, 
	           Status R, 
			   ItemMaster M,
			   Organization.dbo.Organization O
	WHERE      L.ActionStatus = R.Status
	AND        L.OrgUnit      = O.OrgUnit
	AND        M.Code         = L.ItemMaster
	AND        R.StatusClass  = 'Requisition' 
	AND        L.Reference    = '#URL.Reference#'
	ORDER BY   O.OrgUnitName, L.WorkOrderId, L.WorkOrderLine, L.Created DESC
	</cfquery>

</cfif>

<cfquery name="Parameter" 
	datasource="AppsPurchase" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT * 
	FROM   Ref_ParameterMission
	WHERE  Mission = '#URL.Mission#' 
</cfquery>

<!--- refreshing the view by status --->
<cfset url.role = "ProcReqEntry">
<cfinclude template="../RequisitionView/RequisitionViewTreeRefresh.cfm">
		
	<table width="97%" border="0" cellspacing="0" cellpadding="0" align="center">
	
	  <tr><td height="3" bgcolor="ffffff"></td></tr>
	  
	  <tr>
	    <td>
		
		<table border="0" cellpadding="0" cellspacing="0" width="100%" align="center" class="navigation_table">
			
			<tr class="line">		
			<td colspan="4" style="height:50;font-size:28px;font-weight:200" class="labelmedium"><cf_tl id="Draft requirements"></td>
			<td class="labelit">
				<cfif url.print eq "0">
				<a href="javascript:printme()"><font color="0080C0">Print</font></a>
				</cfif>
			</td>			
			<td colspan="4" align="right" style="padding:2px">
			
			    <cf_space spaces="50">
			
				<table border="0" cellspacing="0" cellpadding="0" class="formpadding">
				<tr>			   
				   <td bgcolor="FFFFAF" class="labelit" style="padding:3px;border: 1px solid Gray;"><cf_tl id="Selected"></td>
				   <td bgcolor="FFD5D5" class="labelit" style="padding:3px;border: 1px solid Gray;"><cf_tl id="Over Budget"></td>			  
			     </tr>
				</table>
			
			</td>
			</tr>
				   		
			<cfset tot = 0>
			
			 <TR class="labelmedium line">
			   <td style="height:30" width="2%">&nbsp;</td>
			   <td><cf_tl id="Status"></td>			  
			   <td width="70"><cf_tl id="Period"></td>
			   <td><cf_tl id="Date"><cf_space spaces="26"></td>
			   <td width="60%"><cf_tl id="Item"></td>
			   <td><!--- <cf_tl id="Obj"> ---></td>		   
			   <td style="padding-left:3px" align="right"><cf_tl id="Qty"></td>
			   <td style="padding-left:3px" align="right"><cf_tl id="Unit"></td>	
			   <!---	  
			   <td class="labelit" style="padding-left:3px" align="right"><cf_tl id="Price"></td>
			   --->
			   <td style="padding-left:3px" align="right"><cf_tl id="Amount"></td>
		    </TR>	
						
			<cfoutput query="Requisition" group="OrgUnitName">
			
				<tr><td height="4"></td></tr>
				<tr><td height="26" colspan="10" class="labellarge">#OrgUnitName#</td></tr>
				
				<cfoutput group="WorkOrderId">
				
					<cfif workorderreference neq "">	
								
							<tr><td height="4"></td></tr>
							
							<cfquery name="Customer" 
							datasource="AppsWorkOrder" 
							username="#SESSION.login#" 
							password="#SESSION.dbpw#">
								SELECT  C.*
								FROM    WorkOrder W, Customer C
								WHERE   W.CustomerId = C.Customerid
								AND     WorkOrderId  = '#WorkOrderId#'			
							</cfquery>
							
							<tr>
								<td height="26" style="padding-left:4px" colspan="10" class="labelmedium">
								#WorkorderReference# - #Customer.CustomerName#
								</td>
							</tr>
							
					<cfelse>
					
						<tr>
								<td height="26" style="padding-left:4px" colspan="10" class="labelmedium">
								Direct Requests
								</td>
							</tr>
																		
					</cfif>
				
					<cfoutput group="WorkOrderLine">
										
						<cfif workorderid neq "">
				
							<cfquery name="getworkorderline" 
								datasource="AppsWorkOrder" 
								username="#SESSION.login#" 
								password="#SESSION.dbpw#">							
									SELECT   WS.Description, WL.Reference, WL.WorkOrderLineId
									FROM     WorkOrderLine WL INNER JOIN
						                     WorkOrderService WS ON WL.ServiceDomain = WS.ServiceDomain AND WL.Reference = WS.Reference
									WHERE    WorkOrderId   = '#WorkOrderId#'			
									AND      WorkorderLine = '#workorderline#'
								</cfquery>
								
								<cfif getworkorderline.recordcount eq "1">
								
								<tr>
									<td height="20" style="padding-left:4px" colspan="10" class="labelmedium">
									<a href="javascript:workorderlineopen('#getworkorderline.workorderlineid#')"><font size="1" color="808080">line:</font><font color="6688aa">#getworkorderline.Reference# #getworkorderline.Description#</font></a>
									</td>
								</tr>
								
								</cfif>
								
						</cfif>	
													
						<cfoutput>
						
						<cfquery name="Check" 
						datasource="AppsPurchase" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">
							SELECT    *
							FROM      Ref_ParameterMissionEntryClass
							WHERE     Mission = '#Mission#' 
							AND       Period = '#Period#' 
							AND       EntryClass = '#EntryClass#'
							AND       EditionId IN (SELECT EditionId 
												    FROM   Program.dbo.Ref_AllotmentEdition)
						</cfquery>
									
						<cfif Check.EditionId neq "">
						 	  		
							<CF_RequisitionFundingCheck 
							    RequisitionNo="'#RequisitionNo#'" 
								EditionId="#check.editionid#">
							
						<cfelse>
						
							<cfset funds = "Yes">
							
						</cfif>								
												
						<cfif funds eq "No">
						 <cfset cl = "FFD5D5">
						<cfelseif URL.ID eq RequisitionNo>
						 <cfset cl = "FFFFaF"> 
						<cfelse>
						 <cfset cl = "white"> 
						</cfif>
						
						<tr><td class="line" colspan="9"></td></tr>
				
						<tr bgcolor="#cl#" class="navigation_row labelmedium">
					
						 <td align="center">
						 
						 	   <table cellspacing="0" cellpadding="0">
							   <tr>
							   <td style="padding-left:7px">	   
								   <cf_img icon="edit" navigation="yes" onclick="ProcReqEdit('#requisitionno#','portal');">		   
							   </td>
							   <td style="padding-left:6px">		
							   	   
								   <img src="#client.root#/images/copy.png" 
							   		    onclick="copyRequisition('#requisitionno#');"
								   		height="11" 
										width="13" 
										style="cursor:pointer" 
										alt="Copy Requisition" 
										border="0">			   
										
									<cfdiv id="copyRequisitionDiv"/>
							   </td>
							    <td style="padding-left:7px;padding-right:8px;padding-top:1px">	   
								   <cf_img icon="delete" onclick="deleteRequisition('#requisitionno#');">		   
							   </td>
							   </tr>
							   </table>
								   
						   </td>
						  
						   <td><cf_space spaces="20">#StatusDescription#</td>
						   <td><cf_space spaces="20">#Period#</td>		
						   <td style="padding-left:3px">#DateFormat(Created,client.dateformatshow)#</td>
						    
						   <td>
						   
						   <table cellspacing="0" cellpadding="0">
							   <tr>
							   <cfif requirementid neq "">
							   <td class="labelit" style="padding-right:4px"><b><font color="FF8000">FP:</b></td>
							   </cfif>
							   <td style="padding-left:0px;word-break: break-all;" class="labelit"><b>#ItemMasterDescription#</b>  	<cfif caseNo eq "">#RequestDescription#<cfelse>(#CaseNo#) - #RequestDescription#</cfif></td>							  	
							   </tr>
						   </table>
						   
						   </td>
						   <td><!--- #ObjectCode# ---></td>
						   <td style="padding-left:3px" align="right">#RequestQuantity# </td>
						   <td style="padding-left:3px" align="right">#QuantityUoM#</td>
						   
						  <td style="padding-left:3px;padding-right:4px" align="right">#NumberFormat(RequestAmountBase,"__,__.__")#</td>
						</tr>			
						
						<cfif countedtopics gte 1>
							<tr class="navigation_row_child labelmedium">
							  <td></td>
							  <td></td>
							  <td></td>
							  <td colspan="9">				   				 
									<cf_getRequisitionTopic RequisitionNo="#RequisitionNo#" TopicsPerRow="3">				
							  </td>
							</tr>
						</cfif>
								  
						<cfif Personno neq "">
								
							<cfquery name="Person" 
							datasource="AppsEmployee" 
							username="#SESSION.login#" 
							password="#SESSION.dbpw#">
								SELECT    *
								FROM      Person
								WHERE     PersonNo = '#PersonNo#'			
							</cfquery>
							
							<tr class="navigation_row_child labelmedium">
								<td></td>
								<td></td>
								<td></td>
								<td></td>
								<td colspan="8"><font color="silver">emp:</font><a href="javascript:EditPerson('#PersonNo#')"><font color="0080FF">#Person.FirstName# #Person.LastName#</a></td>
							</tr>
						
						</cfif>	
														
						<cfif RequestAmountBase neq "">
							<cfset tot = tot + RequestAmountBase>
						</cfif>
						
						</cfoutput>
					
					</cfoutput>	
				
				</cfoutput>
					
			</cfoutput>
			
			<tr><td height="1" class="line" colspan="9"></td></tr>
			
			<cfoutput>
			<tr><td height="24" colspan="8" style="padding-right:10px" align="right" class="labelit"><cf_tl id="Total">:<td align="right" class="labelmedium"><b>#NumberFormat(tot,"__,__.__")#</td></td></tr>
			</cfoutput>
			
			<tr><td height="1" class="line" colspan="9"></td></tr>
			
			<tr><td height="4"></td></tr>
				
		</table>
		
		</td>
		</tr>
		
	</table>	
	
<cfif url.print eq "1">
	<script language="JavaScript">
		window.print()
	</script>
<cfelse>

	<cfif URL.ajax eq 1>
		<cfset AjaxOnLoad("doHighlight")>
	</cfif>	
</cfif>
		

	