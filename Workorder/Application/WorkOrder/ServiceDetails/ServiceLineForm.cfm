
<cfparam name="url.accessmode"             default="edit">
<cfparam name="url.openmode"               default="dialog">
<cfparam name="url.mode"                   default="view">
<cfparam name="form.personno"              default="">
<cfparam name="form.orgunit"               default="">
<cfparam name="form.orgunitimplementer"    default="">
<cfparam name="form.servicedomainclass"    default="">
<cfset newrecord = "0">

<!--- ----------------------- --->
<!--- process the save action --->
<!--- ----------------------- --->

<cfif url.mode eq "save">

		<cfset accessmode = "edit">
		
		<cfquery name="WorkOrder" 
			     datasource="AppsWorkOrder" 
			     username="#SESSION.login#" 
			     password="#SESSION.dbpw#">
					 SELECT *
					 FROM   WorkOrder W,ServiceItem I
					 WHERE  WorkOrderId = '#url.workorderid#'			 
					 AND    W.ServiceItem = I.Code
			</cfquery>	

		<cfif url.workorderline eq "0">
		
			<!--- generate a non operational record for data entry --->
			
			<cfquery name="Last" 
			     datasource="AppsWorkOrder" 
			     username="#SESSION.login#" 
			     password="#SESSION.dbpw#">
					 SELECT    TOP 1 WorkOrderLine as Line 
					 FROM      WorkOrderLine
					 WHERE     WorkOrderId = '#url.workorderid#'
					 ORDER BY  WorkOrderLine DESC
			</cfquery>		
			
			<cfquery name="WorkOrder" 
			     datasource="AppsWorkOrder" 
			     username="#SESSION.login#" 
			     password="#SESSION.dbpw#">
					 SELECT *
					 FROM   WorkOrder W,ServiceItem I
					 WHERE  WorkOrderId = '#url.workorderid#'			 
					 AND    W.ServiceItem = I.Code
			</cfquery>	
				
			<cfif last.recordcount eq "0">
				<cfset No = 1>
			<cfelse>
				<cfset No = last.Line+1>	
			 </cfif> 
				
			<cfset url.workorderid   = url.workorderid>
			<cfset url.workorderline = No>					
			<cfset newrecord = "1">		
		</cfif>
	
		<cfset dateValue = "">
		<cfset vThisDate = replace(Form.DateEffective, "'", "", "ALL")>
		<CF_DateConvert Value="#vThisDate#">
		<cfset eff = dateValue>
		
		<cfif Form.DateEffective eq "">
		
			<cf_tl id="You may not record a entry without an effective date" var="vAlert" class="message">
			<script>
				alert("<cfoutput>#vAlert#</cfoutput>");
			</script>
			
			<cfif newrecord eq "1">	
				<cfabort>
			</cfif>
			
		<cfelse>	
		
		<cfquery name="Item" 
			datasource="AppsWorkOrder" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				 SELECT  *	
			     FROM    ServiceItem
				 WHERE   Code   = '#workorder.serviceitem#'	
			</cfquery>
				
		<cfset dateValue = "">
		<cfif Form.DateExpiration neq ''>
		    <cfset vThisDate = replace(Form.DateExpiration, "'", "", "ALL")>
			<CF_DateConvert Value="#vThisDate#">
		    <cfset exp = dateValue>
		<cfelse>
		    <cfif Item.ServiceMode eq "WorkOrder">
			   <cfset exp = eff>
			<cfelse>
			    <cfset exp = 'NULL'>
			</cfif>	
		</cfif>	
		
		<cfif Form.reference eq "">	
			
			<cf_tl id="You may not save a service line without a reference" var="vAlert" class="message">
			<script>
				alert("<cfoutput>#vAlert#</cfoutput>")
			</script>
			
			<cfif newrecord eq "1">	
				<cfabort>
			</cfif>
		
		<cfelse>		
		
			<cfparam name="Form.Operational" default="1">	
						
			<cfquery name="WorkOrder" 
			datasource="AppsWorkOrder" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				 SELECT  *	
			     FROM    WorkOrder
				 WHERE   WorkOrderId     = '#url.workorderid#'	
			</cfquery>
								
			<cfquery name="Item" 
			datasource="AppsWorkOrder" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				 SELECT  *	
			     FROM    ServiceItem
				 WHERE   Code   = '#workorder.serviceitem#'	
			</cfquery>
			
			 <cfquery name="CheckDomain" 
			  datasource="AppsWorkOrder" 
			  username="#SESSION.login#" 
			  password="#SESSION.dbpw#">
			    SELECT   * 
				FROM     WorkOrderService 
				WHERE    Reference          = '#Form.Reference#' 				
				AND      ServiceDomain      = '#item.servicedomain#'
		    </cfquery>
			
			<cfif CheckDomain.recordcount eq "0" and Item.ServiceDomain neq "">
			
				 <cfquery name="Log" 
				     datasource="AppsWorkOrder" 
				     username="#SESSION.login#" 
				     password="#SESSION.dbpw#">
				     INSERT INTO WorkOrderService
							 (ServiceDomain,
							  Reference,	
							  Description,	 
							  OfficerUserId,
							  OfficerLastName,
							  OfficerFirstName)
					 VALUES ('#item.servicedomain#',
	         				 '#Form.Reference#',
							 '#Form.Description#',
							 '#SESSION.acc#',
							 '#SESSION.last#',
							 '#SESSION.first#')				
			     </cfquery>	
				
			<cfelse>
			
				<cfparam name="Form.Description" default="">
				
				<cfif form.description neq "">
			
					<cfif len(Form.Description) gt 100>
					   <cfset des = left(Form.Description,100)>
					<cfelse>
					  <cfset des = Form.Description>
					</cfif>
				
					<cfquery name="CheckDomain" 
					  datasource="AppsWorkOrder" 
					  username="#SESSION.login#" 
					  password="#SESSION.dbpw#">
					    UPDATE WorkOrderService 
						SET    Description     = '#des#'
						WHERE  Reference       = '#Form.Reference#' 				
						AND    ServiceDomain   = '#item.servicedomain#'
				    </cfquery>	
				
				</cfif>				
			
			</cfif>

			<cfif newrecord eq "0">
						
				<cfquery name="WorkOrderLine" 
					datasource="AppsWorkOrder" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
					 SELECT  *	
				     FROM    WorkOrderLine
					 WHERE   WorkOrderId     = '#url.workorderid#'
					 AND     WorkOrderLine   = '#url.workorderline#'	
				</cfquery>
				
			<cfelse>
				
				<cfquery name="workorderline" 
				  datasource="AppsWorkOrder" 
				  username="#SESSION.login#" 
				  password="#SESSION.dbpw#">
					  SELECT  * 
					  FROM    WorkOrderLine WL			  
					  WHERE   ServiceDomain      = '#item.servicedomain#' 
					  AND     Reference          = '#Form.Reference#'
					  AND    (DateExpiration IS NULL OR DateExpiration > #Eff#)
					  AND     ServiceDomain IN (SELECT Code 
					                            FROM   Ref_ServiceItemDomain 
												WHERE  Code = WL.ServiceDomain 
												AND    AllowConcurrent = 0)
					  AND	  Operational = 1 
			    </cfquery>						
					
			   <cfif workorderline.recordcount gt "0">
			   
			        <cfoutput>
	   					<script>
					     alert("This reference already exists [#workorderline.recordcount#]. Operation not allowed.")
					    </script>
				    </cfoutput>					   
					<cfabort>
					
				</cfif>	
			</cfif>
			
			<cfif workorderline.recordcount eq "0">			
			
				 <cfquery name="Insert" 
				     datasource="AppsWorkOrder" 
				     username="#SESSION.login#" 
				     password="#SESSION.dbpw#">
				     INSERT INTO WorkOrderLine 
					         (WorkOrderId,
							 WorkOrderLine,					 
							 ServiceDomain,
							 <cfif form.ServiceDomainClass neq "">
							   ServiceDomainClass,
							 </cfif>
							 <cfif form.OrgUnitImplementer neq "">
							   OrgUnitImplementer,
							 </cfif>						   
							 <cfif form.orgunit neq "">
							   OrgUnit,
							 </cfif>
							 Reference, 	
							 WorkOrderLineMemo,			
							 PersonNo,
							 Source,
							 DateEffective,
							 DateExpiration,								 
							 Operational,
							 OfficerUserId,
							 OfficerLastname,
							 OfficerFirstName)
				      VALUES ('#URL.WorkOrderId#',
						      '#No#',
							  '#Item.ServiceDomain#',
							  <cfif form.ServiceDomainClass neq "">
								  '#form.ServiceDomainClass#',
							  </cfif>
							  <cfif form.OrgUnitImplementer neq "">
								  '#Form.OrgUnitImplementer#',
							  </cfif>						   
							  <cfif form.orgunit neq "">
								  '#Form.OrgUnit#',
							  </cfif>
							  '#Form.Reference#', 	
							  '#Form.WorkOrderLineMemo#',			
							  '#Form.PersonNo#',
							  '#Form.Source#',
							  #Eff#,
							  #Exp#,									 
							  '#Form.Operational#', 
					      	  '#SESSION.acc#',
							  '#SESSION.last#',
							  '#SESSION.first#')
	   			   </cfquery>
					
				   <cfset id = url.workorderid>
				   <cfinclude template="../Create/CustomFieldsSubmit.cfm">		
				   
				   <cfoutput>
				   
				   		<!--- open the edit screen --->
				   
					    <script>	
						   
							try {			
						    opener.applyfilter('1','','content') } 
							catch(e) { }	
												
							ColdFusion.navigate('ServiceLineFormEdit.cfm?workorderid=#URL.workorderId#&workorderline=#url.workorderline#','contentbox')
						</script>	
						
					</cfoutput>		
					
					<cfabort>
			
			<cfelse>
			
				<cfquery name="check" 
				  datasource="AppsWorkOrder" 
				  username="#SESSION.login#" 
				  password="#SESSION.dbpw#">
			    	SELECT * 
				    FROM   Ref_ServiceItemDomain 
				    WHERE  Code = '#item.ServiceDomain#' 
				</cfquery>
				
				<cfset pWorkorderId    = "">
				<cfset pWorkorderLine  = "">
				
				<cfif check.allowConcurrent eq "0">
				
					<cfquery name="list" 
					  datasource="AppsWorkOrder" 
					  username="#SESSION.login#" 
					  password="#SESSION.dbpw#">
						  SELECT    WorkOrderId, 
						            WorkorderLine,
									DateEffective, 
									ISNULL(DateExpiration,'12/31/9999') as DateExpiration 
						  FROM      WorkOrderLine 			  
						  WHERE     ServiceDomain   = '#item.servicedomain#' 
						  AND       Reference       = '#Form.Reference#'					  
						  AND       (
						  				WorkOrderId     != '#URL.WorkOrderId#' 
										OR 
										(WorkOrderId = '#URL.WorkOrderId#' AND WorkOrderLine != '#URL.workorderline#')
									)							  
						  AND	    Operational     = 1
						  ORDER BY  DateEffective
				    </cfquery>
				
					<cfloop query="list">
					
						<cfif (DateEffective lte exp and DateExpiration gte eff)> 
												
							   <cfif DateEffective lte eff>
							   
							   		<!--- if the prior line has an effective date smaller than the revised start
									date of the currently we correct it --->
							   
							   		<cfset dte = dateAdd("d","-1",eff)>
																	
									<cfquery name="Log" 
									     datasource="AppsWorkOrder" 
									     username="#SESSION.login#" 
									     password="#SESSION.dbpw#">
									     INSERT INTO WorkOrderLineLog
												 (WorkOrderId,
												  WorkOrderLine,
												  UserAction,
												  Reference,					 
												  DateEffective,
												  DateExpiration,
												  PersonNo,					 
												  OfficerUserId,
												  OfficerLastName,
												  OfficerFirstName)
										 SELECT   WorkOrderId,
												  WorkOrderLine,
												  'Date',
												  Reference,					 
												  DateEffective,
												  DateExpiration,
												  PersonNo,					
												  '#SESSION.acc#',
												  '#SESSION.last#',
												  '#SESSION.first#'
										 FROM  WorkOrderLine
										 WHERE WorkOrderId   = '#WorkOrderId#'
										 AND   WorkOrderLine = '#workorderline#'
								   </cfquery>					
				   				
								   <cfquery name="Update" 
									  datasource="AppsWorkOrder" 
									  username="#SESSION.login#" 
									  password="#SESSION.dbpw#">
									  UPDATE   WorkOrderLine 
									  SET      DateExpiration  = #dte#				
									  WHERE    WorkOrderId     = '#WorkOrderId#' 
									  AND      WorkOrderLine   = '#workorderline#'
								    </cfquery>	
									
									<cfset pWorkorderId    = workorderid>
									<cfset pWorkorderLine  = workorderline>
							   
							   <cfelse>
							   
							   	  <script>
								     alert("The effective period overlaps with another line. Operation is not allowed")
								   </script>
								   <cfabort>
							   
							   </cfif>								 
					
						</cfif>
				
					</cfloop>				
				
				</cfif>	
													   
				<cfparam name="PersonNo" default="">

				<cfquery name="Log" 
					     datasource="AppsWorkOrder" 
					     username="#SESSION.login#" 
					     password="#SESSION.dbpw#">
					     INSERT INTO WorkOrderLineLog
								 (WorkOrderId,
								  WorkOrderLine,
								  UserAction,
								  Reference,					 
								  DateEffective,
								  DateExpiration,
								  PersonNo,					 
								  OfficerUserId,
								  OfficerLastName,
								  OfficerFirstName)
						 SELECT   WorkOrderId,
								  WorkOrderLine,
								  'Edit',
								  Reference,					 
								  DateEffective,
								  DateExpiration,
								  PersonNo,					
								  '#SESSION.acc#',
								  '#SESSION.last#',
								  '#SESSION.first#'
						 FROM  WorkOrderLine
						 WHERE WorkOrderId   = '#URL.WorkOrderId#'
						 AND   WorkOrderLine = '#URL.workorderline#'
				</cfquery>					
			   				
				<cfquery name="Update" 
					  datasource="AppsWorkOrder" 
					  username="#SESSION.login#" 
					  password="#SESSION.dbpw#">
					  UPDATE   WorkOrderLine 
						  SET  Operational        = '#form.operational#',
						       ServiceDomain      = '#item.servicedomain#',
							   <cfif form.ServiceDomainClass neq "">
							   ServiceDomainClass = '#form.ServiceDomainClass#',
							   </cfif>
							   <cfif form.OrgUnitImplementer neq "">
							   OrgUnitImplementer = '#Form.OrgUnitImplementer#',
							   </cfif>				   
							   <cfif form.orgunit neq "">
							   OrgUnit           = '#Form.OrgUnit#',
							   <cfelse>
							   OrgUnit           = NULL,
							   </cfif>
				 		       Reference          = '#Form.Reference#', 
							   WorkOrderLineMemo  = '#Form.WorkOrderLineMemo#',				
							   PersonNo           = '#Form.PersonNo#',
							   Source             = '#Form.Source#',
							   DateEffective      = #Eff#,
							   DateExpiration     = #Exp#				
						 WHERE WorkOrderId   = '#URL.WorkOrderId#' AND WorkOrderLine = '#URL.workorderline#'
				</cfquery>	
				
				<!--- if the prior record is going to be shorter we
				do an effort to align details to the new lines --->
				
				<cfif pWorkorderId neq "">
				
					<cfloop index="tbl" list="Detail,DetailNonBillable,DetailCharge">
							
						<cfquery name="UpdateUsage" 
							datasource="AppsWorkOrder" 
							username="#SESSION.login#" 
							password="#SESSION.dbpw#">
							    UPDATE  WorkOrderLine#tbl#
								SET     WorkorderId   = '#url.WorkOrderid#',
								        WorkorderLine = '#url.WorkOrderLine#'				
								WHERE   WorkorderId   = '#pWorkOrderid#'
								AND     WorkorderLine = '#pWorkOrderLine#'   
								AND     TransactionDate >= #eff#
					    </cfquery>	
			
					</cfloop>	
					
				</cfif>	
								
				<cfset id = url.workorderid>					
				<cfinclude template="../Create/CustomFieldsSubmit.cfm">	
								
				<cfoutput>
						
						<script language="JavaScript">
						<cfif url.openmode eq "dialog">					
						try {									
					      parent.opener.applyfilter('1','','#workorderline.workorderlineid#') 
					    } 
						catch(e) { }					
						</cfif>	
						ColdFusion.navigate('ServiceLineHeader.cfm?workorderid=#URL.workorderId#&workorderline=#url.workorderline#','custom')
						</script>	
					
				</cfoutput>	
					
			
		    </cfif>
		
		</cfif>
		
		</cfif>
				
	    <cfset url.mode = "view">		
		
</cfif>

<cfquery name="Workorder" 
	datasource="AppsWorkOrder" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	 SELECT  *	
     FROM    WorkOrder
	 WHERE   WorkOrderId     = '#url.workorderid#'		
</cfquery>

<cfquery name="Line" 
	datasource="AppsWorkOrder" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	 SELECT  *	
     FROM    WorkOrderLine WL INNER JOIN 
	         WorkOrderService WS ON WL.ServiceDomain = WS.ServiceDomain AND WL.Reference = WS.Reference 
	 WHERE   WL.WorkOrderId     = '#url.workorderid#'	
	 AND     WL.WorkOrderLine   = '#url.workorderline#'
</cfquery>
			
<cfquery name="DomainClass" 
	datasource="AppsWorkOrder" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	 SELECT   *					 
     FROM    Ref_ServiceItemDomainClass			 
	 WHERE   ServiceDomain   = '#Line.ServiceDomain#'
	 AND     Code            = '#Line.ServiceDomainClass#'		
</cfquery>

<!--- check if this line was transferred --->
				
 <cfquery name="Children" 
	datasource="AppsWorkOrder" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">

	SELECT   WO.*, 
	         P.IndexNo AS IndexNo, 
			 P.LastName AS LastName, 
			 P.FirstName AS FirstName,
			 P.Nationality,
			 P.Gender				
			 
     FROM    WorkOrderLine WO LEFT OUTER JOIN
	         Employee.dbo.Person P ON WO.PersonNo = P.PersonNo
			 
	 WHERE   WO.ParentWorkOrderId   = '#url.workorderid#'
	 AND     WO.ParentWorkorderLine = '#url.workorderline#'					

</cfquery>

<!--- set the processing mode --->

<cfif Line.reference eq "" and url.mode neq "save">
	 <cfset url.mode = "edit">
</cfif>


<cfquery name="Customer" 
	datasource="AppsWorkOrder" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	 SELECT  *	
     FROM    Customer
	 WHERE   CustomerId     = '#WorkOrder.customerid#'	
</cfquery>

<cfquery name="Item" 
datasource="AppsWorkOrder" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	 SELECT  *	
     FROM    ServiceItem
	 WHERE   Code   = '#workorder.serviceitem#'	
</cfquery>

<cfquery name="Domain" 
datasource="AppsWorkOrder" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	 SELECT  *	
     FROM    Ref_ServiceItemDomain
	 WHERE   Code   = '#item.servicedomain#'	
</cfquery>

<cfparam name="url.tabno" default="">

<table width="100%" border="0" class="formpadding" cellspacing="0" align="center">

<!--- check if we have active requests --->
		
		<cfquery name="checkopen" 
			     datasource="AppsWorkOrder" 
			     username="#SESSION.login#" 
			     password="#SESSION.dbpw#">
					SELECT  *
					FROM    RequestWorkOrder WO INNER JOIN
			                Request R ON WO.RequestId = R.RequestId
					WHERE   WorkorderId   = '#url.workorderid#'
					AND     WorkorderLine = '#url.workorderline#'			  
					AND     R.ActionStatus IN ('0', '1', '2')
			</cfquery>		

	<cfif url.mode eq "View" and accessmode eq "Edit">
			
			 <!--- define access --->
		
		   	<cfinvoke component = "Service.Access"  
			   method           = "WorkorderProcessor" 
			   mission          = "#workorder.mission#" 
			   serviceitem      = "#workorder.serviceitem#"
			   returnvariable   = "access">	
			
			    <cfif Access eq "EDIT" or Access eq "ALL">
				
			
					<cfoutput>
					
					<!--- if the line was transferred do not allow for changes anymore --->
							
						<tr><td colspan="2" height="34">
						
							<cf_tl id="Edit" var="vEdit">
							
							<input type    = "button" 
							       name    = "Edit" 
			                       id      = "Edit"
								   Value   = "#vEdit#"
								   class   = "button10g" 
								   style   = "width:130;height:25"
								   onclick = "ColdFusion.navigate('ServiceLineForm.cfm?openmode=#url.openmode#&tabno=#url.tabno#&workorderid=#url.workorderid#&workorderline=#url.workorderline#&mode=edit','contentbox#url.tabno#')")>

							<cfquery name="TransferEnabled" 
							datasource="AppsWorkOrder" 
							username="#SESSION.login#" 
							password="#SESSION.dbpw#">								   
								SELECT    *
								FROM      Ref_RequestWorkflow
								WHERE     ServiceDomain = '#item.servicedomain#' 
								AND       CustomForm = 'RequestTransfer.cfm'								   
							</cfquery>
							
							
							
						
						    <cfif TransferEnabled.recordcount gte "0">  
							
								<!--- manual mode --->							
								
							 	<cf_tl id="Transfer" var="vTransfer">
								
								<input type    = "button" 
								       name    = "Transfer"
				                       id      = "Transfer" 
									   Value   = "#vTransfer#"
									   class   = "button10g" 
									   style   = "width:120;height:25"
									   onclick = "ColdFusion.navigate('ServiceLineTransfer.cfm?openmode=#url.openmode#&tabno=#url.tabno#&workorderid=#url.workorderid#&workorderline=#url.workorderline#&mode=transfer','contentbox#url.tabno#')")>
									   
							</cfif>
						   
						</td></tr>
						
						<tr><td colspan="2" class="line"></td></tr>
							
					</cfoutput>
				
				</cfif>
			
		</cfif>
					
		<cfif checkopen.recordcount gte "1">
		
			<tr><td class="labelit" align="center" style="height:50">
			
				<font color="FF0000">
					<cf_tl id="There are one or more pending requests. Operation not allowed" class="message">
				</font>
				
			</td></tr>	
		
		<cfelse>
		
		<tr>
		
			<td align="center" colspan="2" style="padding-left:10px">			
				<cfform name="customform" method="POST">						   			
					<cfinclude template="ServiceLineFormData.cfm"> 
				</cfform>
			</td>
		
		</tr>
		
		</cfif>
	
		<tr><td height="5"></td></tr>
		<tr><td colspan="2" class="line"></td></tr>

<!---
			
<cfelse>
		
	<tr><td>
	
		<cfform name="customform" method="POST">
		
			<cfset url.mission     = "#workorder.mission#">
			<cfset url.serviceitem = "#workorder.serviceitem#">
			<cfset ass = "Field">			
			<cfinclude template    = "../Create/CustomFields.cfm">		
			
		</cfform>
	
		</td>
	</tr>
	
	<tr><td height="5"></td></tr>
	<tr><td colspan="2" class="line"></td></tr>
	
</cfif>

--->
			
<cfoutput>
	
	<cfif mode eq "Edit" and checkopen.recordcount eq "0">
	
		<tr><td colspan="2" height="30">
		
			<cf_tl id="Save" var="tSave">
		
			<input type    = "button" 
			       name    = "Save" 
                   id      = "Save"
				   Value   = "#tSave#"
				   class   = "button10g" 
				   style   = "width:130;height:25"
				   onclick = "updateTextArea();ptoken.navigate('ServiceLineForm.cfm?openmode=#url.openmode#&tabno=#url.tabno#&workorderid=#url.workorderid#&workorderline=#url.workorderline#&mode=save','contentbox#url.tabno#','','','POST','customform')")>
		
		</td></tr>
		
	<cfelse>
	
	  <tr><td>
	  
		  <cfdiv id="memobox" 
		     bind="url:../Memo/WorkorderLineMemo.cfm?tabno=contentbox2&workorderid=#URL.workorderId#&workorderline=#url.workorderline#&tabno=memobox">
											
	  </td></tr>		
								
	</cfif>
		
</cfoutput>	
	
</table>


