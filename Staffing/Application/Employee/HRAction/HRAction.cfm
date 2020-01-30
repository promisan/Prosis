<!--- Create Criteria string for query from data entered thru search form --->

<cfset ctr= 0>

<table width="100%" align="center" class="formpadding">

<cfparam name="url.header" default="0">

<cfif url.header eq "1">

   <tr><td><cfinclude template="../PersonViewHeader.cfm"></td></tr>
   
</cfif>

<tr><td>

	<table width="95%" align="center" border="0" cellpadding="0" class="formpadding">
	
	<cfparam name="url.status" default="valid">
	
	<!--- Query returning search results --->
	
	<cfquery name="SearchResult" 
	datasource="AppsEmployee" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT   *, 
	        	 (SELECT  Description 
				  FROM    Ref_Action 
				  WHERE   ActionCode = L.ActionCode) as ActionDescription,			
							 	  
				 (SELECT TOP 1 ObjectKeyValue4 
					  FROM     Organization.dbo.OrganizationObject 
					  WHERE    (Objectid   = L.PersonActionId OR ObjectKeyValue4 = L.PersonActionId)
					  AND      EntityCode = 'HRAction' 
					  AND      Operational = 1) as Workflow				  			
					  
	    FROM     PersonAction L INNER JOIN Ref_Action R ON L.ActionCode = R.ActionCode
		WHERE    L.PersonNo = '#URL.ID#' 
		<cfif url.status eq "valid">
		AND      ActionStatus IN ('0','1')
		</cfif>
		ORDER BY L.ActionCode, L.DateEffective, L.ActionStatus DESC <!--- make sure the expired contract show first --->
	</cfquery>
	
	<tr><td>
		
	<table width="100%" class="formpadding">
	  <tr>
	    <td height="18">
		
			<table>
			
				<tr>		
				
				<cfoutput>
				
				 <td style="padding-left:3px" class="labellarge"><cf_tl id="Payroll and Leave calculation actions"></td>
				 <td>&nbsp;&nbsp;</td>	
									 
				 <cfif url.status eq "valid">			 
				     <td class="labelit">
					 <a href="#ajaxlink('#SESSION.root#/staffing/application/employee/HRAction/HRAction.cfm?id=#url.id#&status=all')#">
					 <font color="0080C0" size="1">[Show both CANCELLED and ACTIVE]</font>
					 </a>
					 </td>			 
				 <cfelse>			 
				 	<td class="labelit">
					 <a href="#ajaxlink('#SESSION.root#/staffing/application/employee/HRAction/HRAction.cfm?id=#url.id#&status=valid')#">
					 <font color="0080C0" size="1">[HIDE Cancelled records]</font>
					 </a>
				    </td>				 
				 </cfif>
				 		
				<td><cf_space spaces="20"></td>		
				
				</tr>
				
			</table>
		
		</td>
		
		<td align="right" height="24">
		
		<!--- check if there are any pending actions --->
				
		<!--- Query returning search results --->
		<cfquery name="Pending" 
		datasource="AppsEmployee" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT   *
		    FROM     PersonAction
			WHERE    PersonNo = '#URL.ID#' 
			AND      ActionStatus = '0'	   	
		</cfquery>
		
		<cfinvoke component="Service.Access" 
			     method="contract"
				 personno="#URL.ID#"			
				 returnvariable="access">
			
		<cfif Pending.recordcount eq "0">		
						
			<cfquery name="getAction" 
			datasource="AppsEmployee"
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			    SELECT *
			    FROM   Ref_Action
				WHERE  ActionSource = 'Payroll'
				AND    Operational = 1
			</cfquery>
		 	
			<cfif (access eq "EDIT" or access eq "ALL") and getAction.recordcount gte "0">	
						
		  	    <cf_tl id="Record an Action" var="1">		   
		    	<input type="button" value="<cfoutput>#lt_text#</cfoutput>" class="button10g" style="width:180" 
				onClick="#ajaxlink('#SESSION.root#/staffing/application/employee/HRAction/HRActionEdit.cfm?ID=#URL.ID#')#">
				
			</cfif>
			
		<cfelse>
		
			<font color="red"><cf_tl id="Open actions"></font>&nbsp;
			
		</cfif>
		
	    </td>
		</cfoutput>
	   </tr>
	   <tr>
	   <tr><td height="1" colspan="2" class="line"></td></tr>
	   
	  <td width="100%" colspan="2">
	 
	  <table cellspacing="0" width="100%" class="navigation_table">
			
		<TR class="labelmedium line">
		    <td width="3%" height="18" align="center"></td>
			<td width="3%"></td>		
			<TD width="170"><cf_tl id="Action"></TD>			
			<TD width="90"><cf_tl id="Mission"></TD>	
		    <td width="90"><cf_tl id="Effective"></td>
			<TD width="90"><cf_tl id="Expiration"></TD>	
			<TD width="7%"><cf_tl id="Status"></TD>		
			<TD width="90"><cf_tl id="Recorded"></TD>
			<TD width="10%"><cf_tl id="Officer"></TD>	   	
		</TR>
		
		<cfset last = "1">	
			
		<cfoutput query="SearchResult" group="ActionCode">
		
			<cfset dte = "01/01/1900">
		
			<cfoutput>
					
			<cfif ActionStatus eq "0" or ActionStatus eq "1">		
					
				<cfif DateEffective lte dte>
					<tr><td align="center" height="20" colspan="14">
						<table width="95%" align="center"><tr bgcolor="red">
						<td align="center" height="20" class="labelit">
						<font color="FFFFFF"><b><cf_tl id="Attention: Effective periods should not overlap.">
						</td>
						</table>
					</td>
					</tr>
				<tr><td height="2"></td></tr>
				</cfif>
								
				<cfset dte = dateformat(DateExpiration,client.dateSQL)>
				<!---- to be cleared by Hvp by JM on 28/04/10 ----->
				<cfif dte eq ""> 
					<!---- can this be a parameter? ----->			
					<cfset dte="1/1/2050">			
				</cfif>
			
			</cfif>
			
			<cfif actionStatus eq "9" or actionstatus eq "8">
			
				<!--- 16/2/2011 adjustment to handle cancelled records better	
				check if the workflow of the cancelled record is still open, we close it in that case 	
				--->
				
			    <cf_wfActive entitycode="HRAction" objectkeyvalue4="#PersonActionId#">	
				
				<cfif wfstatus eq "open">
				
					<cfquery name="ArchiveFlow" 
						datasource="AppsOrganization" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">
							UPDATE OrganizationObjectAction
							SET    ActionStatus     = '2',
							       OfficerUserId    = 'administrator',
								   OfficerLastName  = 'Agent',
								   OfficerFirstName = 'System',
								   OfficerDate      = getDate()					   		
							WHERE  ObjectId IN (SELECT ObjectId 
							                    FROM   OrganizationObject 
												WHERE  ObjectKeyValue4 = '#PersonActionId#')
							AND    ActionStatus = '0'			
					</cfquery>	
				
				</cfif>
			
			<tr bgcolor="f1f1f1" class="navigation_row line labelmedium">
			
			<cfelseif dateeffective lte now() and (dateExpiration is "" or dateExpiration gte now())>
			
			<!--- active contract --->
			<tr bgcolor="ffffcf" class="navigation_row labelmedium line">
			
			<cfelse>
			
			<TR bgcolor="#IIf(CurrentRow Mod 2, DE('FFFFFF'), DE('FFFFFF'))#" class="navigation_row labelmedium line">
			
			</cfif>
						
			<cfif workflow neq "">
				 
				 <td height="20"
				    align="center" 			
					style="cursor:pointer;width:20px" 
					onclick="workflowdrill('#workflow#','box_#workflow#')" >
				 
				 	<cfif ActionStatus eq "0">
					
						  <img id="exp#Workflow#" 
						     class="hide" 
							 src="#SESSION.root#/Images/arrowright.gif" 
							 align="absmiddle" 
							 alt="Expand" 
							 height="9"
							 width="7"			
							 border="0"> 	
										 
						   <img id="col#Workflow#" 
						     class="regular" 
							 src="#SESSION.root#/Images/arrowdown.gif" 
							 align="absmiddle" 
							 height="10"
							 width="9"
							 alt="Hide" 			
							 border="0"> 
					
					<cfelse>				
												
						   <img id="exp#Workflow#" 
						     class="regular" 
							 src="#SESSION.root#/Images/arrowright.gif" 
							 align="absmiddle" 
							 alt="Expand" 
							 height="9"
							 width="7"			
							 border="0"> 	
										 
						   <img id="col#Workflow#" 
						     class="hide" 
							 src="#SESSION.root#/Images/arrowdown.gif" 
							 align="absmiddle" 
							 height="10"
							 width="9"
							 alt="Hide" 			
							 border="0"> 
					
					</cfif>
					
				<cfelse>
				
				<td height="20" align="center">	
				  
				</cfif>	 
				
				</td>
				
				<td align="center" width="30">
						      
				 	<cfif ActionStatus neq "9">							
					 <cfif access eq "EDIT" or access eq "ALL">			 
					   <cf_img icon="edit" navigation="Yes" onclick="#ajaxlink('#SESSION.root#/staffing/application/employee/HRAction/HRActionEdit.cfm?ID=#personno#&id1=#PersonActionId#')#">			  			 
					 </cfif>  		 
				   </cfif>		
					 
				</td>	
						
				<td>#ActionCode# #ActionDescription#</td>		
				<td>#Mission#</td>
				<td>#Dateformat(DateEffective, CLIENT.DateFormatShow)#</td>
				<td>#Dateformat(DateExpiration, CLIENT.DateFormatShow)#</td>
				
				<td style="padding-right: 3px;" id="status_#personactionid#">
						
					<cfif actionStatus eq "9">
						<font color="red"><cf_tl id="Cancelled">				
					<cfelse>
					   			    
						<cfif actionstatus eq "1">
						   <cf_tl id="Cleared">
						<cfelse>
						   <font color="red"><b><cf_tl id="Pending">
					   </cfif>
					</cfif>		
					
				</td>
				
				<td>#Dateformat(Created, CLIENT.DateFormatShow)#</td>		
				<td style="padding-right:4px">#OfficerLastName#</td>
				
			</TR>
			
			<cfif Remarks neq "">
			
		    	<cfif actionStatus eq "9" or actionstatus eq "8">	
			       <tr bgcolor="fafafa" class="navigation_row_child labelmedium line">	
				<cfelseif dateeffective lte now() and (dateExpiration is "" or dateExpiration gte now())>
					<TR bgcolor="ffffcf" class="navigation_row_child labelmedium line">
				<cfelse>
					<TR bgcolor="#IIf(CurrentRow Mod 2, DE('FFFFFF'), DE('F9F9F9'))#" class="navigation_row_child labelmedium line">
				</cfif>
				<td colspan="2" height="20"></td>
				<td colspan="12" align="left" class="labelit" style="padding-right:4px">#Remarks#</b></td>
				</tr>		
				
			</cfif>	
			
				
			<!--- show only if it has a workflow --->
						
			<cfif workflow neq "">
			
				<input type="hidden" 
				   name="workflowlink_#workflow#" 
				   id="workflowlink_#workflow#" 		   
				   value="#SESSION.root#/staffing/application/employee/HRAction/HRActionWorkflow.cfm">			   
				  
				<input type="hidden" 
				   name="workflowlinkprocess_#workflow#" 
				   onclick="ColdFusion.navigate('#SESSION.root#/staffing/application/employee/HRAction/HRActionStatus.cfm?id=#personactionid#','status_#workflow#')">		    
				   
				<!---  only for pending contract the workflow is shown / triggered --->   
						
				<cfif ActionStatus eq "0" and entityclass neq "">
								
					<tr id="box_#workflow#">
					
					<td colspan="14" id="#workflow#">
			
						<cfset url.ajaxid = personactionid>				
						<cfinclude template="HRActionWorkflow.cfm">
								
					</td></tr>		
					
				<cfelse>
				
					<tr id="box_#workflow#" class="hide">
						<td colspan="14" id="#workflow#"></td>
					</tr>
				
				</cfif>		
			
			</cfif>
				
			</cfoutput>
		
		</cfoutput>
		
		</TABLE>
	
	</td>
	
	</table>
	
	</td>
	</tr>
	
	</table>

</td>
</tr>

</table>

<cfset ajaxonload("doHighlight")>
