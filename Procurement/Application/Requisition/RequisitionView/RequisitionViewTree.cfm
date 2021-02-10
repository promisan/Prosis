
<cfset Criteria = ''>

<cfquery name="Parameter" 
	datasource="AppsPurchase" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT *
	    FROM   Ref_ParameterMission
		WHERE  Mission = '#URL.Mission#' 
</cfquery>

<cfparam name="URL.Period" default="#Parameter.DefaultPeriod#">

<cfquery name="Role" 
	datasource="AppsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	   SELECT *
	   FROM   Ref_AuthorizationRole
	   WHERE  Role = '#url.Role#' 
</cfquery>

<cftry>

<cfform name="treeview">

<table width="96%" align="center" class="formpadding">

  <cfquery name="Mandate" 
	   datasource="AppsOrganization" 
	   username="#SESSION.login#" 
	   password="#SESSION.dbpw#">
	   SELECT *
	   FROM   Ref_MissionPeriod
	   WHERE  Mission = '#URL.Mission#' 
	   AND    Period  = '#URL.Period#'
   </cfquery>

	<cfquery name="Access" 
	datasource="AppsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		
		SELECT *
		FROM   Organization
		WHERE  Mission = '#URL.Mission#'
		AND    MandateNo  = '#Mandate.MandateNo#'
		AND 

			<cfif Role.OrgUnitLevel eq "All">
						
				 OrgUnit IN 
		            (SELECT OrgUnit 
					 FROM   Organization.dbo.OrganizationAuthorization 
					 WHERE  Role        = '#URL.Role#' 
					 AND    UserAccount = '#SESSION.acc#')
								 
			<cfelse>
						
				  OrgUnit IN 
		            (SELECT   O.OrgUnit
					 FROM     Organization.dbo.Organization O INNER JOIN
		                      Organization.dbo.Organization Par ON 
							  	Par.OrgUnitCode = O.HierarchyRootUnit
								AND O.Mission = Par.Mission 
								AND O.MandateNo = Par.MandateNo INNER JOIN
		                      Organization.dbo.OrganizationAuthorization OA ON Par.OrgUnit = OA.OrgUnit
					 WHERE  OA.Role        = '#URL.Role#' 
					 AND    OA.UserAccount = '#SESSION.acc#')		
						
			</cfif>		
			
  </cfquery>		
	     
  <tr class="line">   
        <td class="labelmedium"> 
		
		<table width="100%" cellspacing="0" cellpadding="0">
		
		<tr class="labelmedium">
			
		 <cfif access.recordcount gte "1" and getAdministrator("*") eq "0">		
			 <td onclick="expandthis('access')" style="cursor:pointer" colspan="2" class="labelmedium"><font color="0080C0">
			 <img src="<cfoutput>#SESSION.root#</cfoutput>/images/locked.JPG" alt="" border="0" align="absmiddle">
			 <cf_tl id="Review my access">
		 </cfif>
		 
		<td align="right" class="labelit" style="padding-right:6px"><cf_tl id="Mode">:
			<b><cfif Parameter.EnforceProgramBudget eq "0"><cf_tl id="Isolated"><cfelse><cf_tl id="Budget"></cfif>
		</td>
		</tr>
		
		</table>	
  </tr> 
  
  <tr>
  
  	<td id="access" class="hide">
	
		<table width="100%" cellspacing="0" cellpadding="0">
		 <tr><td class="line"></td></tr>
			<cfoutput query="Access">
				<tr><td class="labelit">#hierarchyCode# #OrgUnitName#</td></tr>
			</cfoutput>		
		</table>

	</td>
	
  </tr>
        
 <cfoutput>
 
 	<!--- define the set of requisitions for this role --->
		
	<CF_DropTable dbName="AppsQuery" tblName="#SESSION.acc#RequisitionSet">
	<CF_DropTable dbName="AppsQuery" tblName="#SESSION.acc#PurchaseSet">	
			
	<!--- predefine for all roles except the buyer --->
					
	 <cfswitch expression="#URL.Role#">
		
		<cfcase value="ProcReqInquiry">		
			  <!--- nada --->				  
		</cfcase>
	
		<cfcase value="ProcReqEntry">
		
			<tr>
			  <td>
			    <table width="100%">	
						
				<tr>
			     
		         <td style="padding-left:7px;height:34px;padding-top:2px;font-size:18px" class="labelmedium2">
				 	
				    <a href="javascript: ProcReqEntry('#URL.Mission#',document.getElementById('PeriodSelect').value,'#url.systemfunctionid#')">							
					    <cf_tl id="Record Requisitions">
					</td>
					</a>
					
			    </tr>	
							
				<cfif Parameter.EnableExecutionRequest eq "1">
										
					<tr>
				      <td style="height:40px;padding-top:2px;font-weight:200;font-size:18px" class="labelmedium line">					  
					   <a title="Submit Open Contract Request" href="javascript: addRequest('#url.mission#','#url.period#',1,'','Status','0')">		
					   <cf_tl id="Record Open Contract">
					   </a>	
					 </td>
				    </tr>	
				
				</cfif>	
				
				</table>
			  </td>
	      </tr>		 
		  
		</cfcase>
					
		<cfcase value="ProcReqReview">
				
			<!--- check pending exist --->
			
			<cfinvoke component = "Service.PendingAction.Check"  
			   method           = "ProcReqReview" 
			   Mission          = "#URL.Mission#" 
			   Period           = "#URL.Period#"
			   returnvariable   = "Check">			
			   
			  						
			<cfif check.recordcount gte "1" and url.period neq "">		
					
				   <tr>
				  <td height="25">
				    <table width="100%"><tr>
				    <td width="5%"><img src="#SESSION.root#/Images/select4.gif" alt="" border="0"></td>
					 <td width="45%" class="labelmedium">
					<a href="javascript: ProcReqClear('#URL.Mission#',document.getElementById('PeriodSelect').value,'ProcReqReview','#url.systemfunctionid#')">
					<cf_tl id="Review requisitions"> (<a id='total'>#check.total#</a>)					
					</a></td>
				    </tr>
			        </table>
				  </td>
		        </tr>
			
			</cfif>		
			
		</cfcase>		
		
		<!--- req approver --->
		
		<cfcase value="ProcReqApprove">
				
			<!--- check pending exist --->
			
			<cfinvoke component = "Service.PendingAction.Check"  
			   method           = "ProcReqApprove" 
			   Mission          = "#URL.Mission#" 
			   Period           = "#URL.Period#"
			   returnvariable   = "Check">		
			  						
			<cfif check.recordcount gte "1" and url.period neq "">	
			
				<tr><td height="5"></td></tr>
					<tr><td colspan="2" class="linedotted"></td></tr>
				
			    <tr>
				  <td height="25">
				    <table width="100%"><tr>
				    <td width="5%"><img src="#SESSION.root#/Images/select4.gif" alt="" border="0"></td>
					 <td width="45%" class="labelmedium">
					<a href="javascript: ProcReqClear('#URL.Mission#',document.getElementById('PeriodSelect').value,'ProcReqApprove','#url.systemfunctionid#')">					
					<cf_tl id="Approve requisitions"> (<a id='total'>#check.total#</a>)					
					</a></td>
				    </tr>
			        </table>
				  </td>
		        </tr>
				
			<cfelseif url.period neq "">
			
				<tr><td height="5"></td></tr>
				<tr><td colspan="2" class="linedotted"></td></tr>						
				<tr>
					  <td height="25">
					    <table width="100%"><tr>
					    <td width="5%"></td>
						<td width="45%" class="labelmedium">	
						<i><cf_tl id="No actions pending for this period">						
						</td>
					    </tr>
				        </table>
					  </td>
			    </tr>		
										
			</cfif>
					
		</cfcase>	
		
		<!--- second approver --->	
		
		<cfcase value="ProcReqBudget">
				
			<!--- check pending action exist for this step --->
			
			<cfinvoke component = "Service.PendingAction.Check"  
			   method           = "ProcReqBudget" 
			   Mission          = "#URL.Mission#" 
			   Period           = "#URL.Period#"
			   returnvariable   = "Check">			
						
			<cfif check.recordcount gte "1" and url.period neq "">	
			
				<tr><td height="2"></td></tr>
				<tr><td colspan="2" class="linedotted"></td></tr>
				
			    <tr>
				  <td height="25">
				    <table width="100%"><tr>
				    <td width="5%"><img src="#SESSION.root#/Images/select4.gif" alt="" border="0"></td>
					 <td width="45%" class="labelmedium">
					  <a href="javascript: ProcReqClear('#URL.Mission#',document.getElementById('PeriodSelect').value,'ProcReqBudget','#url.systemfunctionid#')">
					  <cf_tl id="Review requisitions"> (<a id='total'>#check.total#</a>)					
					  </a>
					 </td>
				    </tr>
			        </table>
				  </td>
		        </tr>
			
			</cfif>	
		
		</cfcase>
		
		<!--- funder --->
		
		<cfcase value="ProcReqObject">
		
			<!--- check pending action exist for this step --->
			
			<cfinvoke component = "Service.PendingAction.Check"  
				   method           = "ProcReqObject" 
				   Mission          = "#URL.Mission#" 
				   Period           = "#URL.Period#"
				   returnvariable   = "Check">			
					
			<cfif check.recordcount gte "1" and url.period neq "">
			
				<tr><td class="linedotted"></td></tr>
				
				  <tr>
					    <td height="25">
						
					    <table width="90%"align="center"><tr>
					    
						<td width="45%" class="labelmedium" style="font-size:19px;font-weight:200;height:35px">
						<a href="javascript:ProcReqObject('#URL.Mission#',document.getElementById('PeriodSelect').value,'#url.systemfunctionid#')">						
						<cf_tl id="Clear requisitions"> (<a id='total'>#check.total#</a>)						
						</a></td>
					    </tr>
				        </table>
						
					   </td>
	           </tr>
				
			<cfelseif url.period neq "">
			
				<tr><td class="line"></td></tr>
				<tr><td height="25" valign="bottom" align="center" class="labelit">No pending requisitions</td></tr>	
				<tr><td></td></tr>
			
			</cfif>						
								
		</cfcase>
		
		<!--- certifier --->
	
		<cfcase value="ProcReqCertify">
								
			<!--- check pending exist --->
						
			<cfinvoke component = "Service.PendingAction.Check"  
			   method           = "ProcReqCertify" 
			   Mission          = "#URL.Mission#" 
			   Period           = "#URL.Period#"
			   returnvariable   = "Check">	
			   						
			<cfif check.recordcount gte "1" and url.period neq "">
			
				<tr><td class="line"></td></tr>
				
				<tr>
				  <td height="25">
				    <table width="90%"align="center"><tr>
				    <td width="45%" class="labelmedium" style="font-size:20px;font-weight:200;height:35px">			        
					   <a href="javascript: ProcReqCertify('#URL.Mission#',document.getElementById('PeriodSelect').value,'#url.systemfunctionid#')">					   
					   <font color="0080C0"><cf_tl id="Certify Requisitions"> (<a id='total'>#check.total#</a>)				  
					   </a></td>
				      </tr></table>
				  </td>
		        </tr>
				
			<cfelse>
			
				<tr><td class="lined"></td></tr>
				<tr><td height="23" class="labelmedium" valign="bottom" align="center">						
					<cf_tl id="No actions pending for this period">						
					
				</td></tr>	
				<tr><td></td></tr>
			
			</cfif>
					
								
		</cfcase>
		
		<!--- buyer assigner --->
		
		<cfcase value="ProcManager">
								
			<tr><td colspan="2" class="line"></td></tr>
			
			<tr>
			  <td height="22">
			    <table width="100%"><tr>			  
		         <td width="45%" class="labelmedium" style="font-size:22px;font-weight:200;height:35px">
				 <a href="javascript: ProcManager('#URL.Mission#',document.getElementById('PeriodSelect').value,'#url.systemfunctionid#')">				 	
				 	<cf_tl id="Assign"> #Parameter.BuyerDescription#</b>				 	
				 </a></td>
			     </tr></table>
			  </td>
	        </tr>			
					
		</cfcase>
				
		<cfcase value="ProcBuyer"></cfcase>
	  	  
	  </cfswitch>	  
		  
	  </cfoutput>    
	  
<cfinvoke component = "Service.Process.Procurement.Requisition"  
	   method           = "getQueryScope" 
	   role             = "#url.role#" 
	   mode             = "Both"
	   returnvariable   = "UserRequestScope">	  
	  		  									
	  <tr><td style="padding-top:1px">
						
		<cfif URL.Role neq "">
				
			<cfswitch expression="#URL.Role#">
					
				<cfcase value="ProcBuyer">
					<cfinclude template="RequisitionViewTreeBuyer.cfm">				
				</cfcase>
											
				<cfdefaultcase>		
	
					<cfinclude template="RequisitionViewTreeProcess.cfm">
				
				</cfdefaultcase>	
			
			</cfswitch>
		
		<cfelse>
		
			No, roles defined.
		
		</cfif> 
			
		</td></tr>
         
    </table>	
	
	 </cfform> 	
	 
	 <cfcatch></cfcatch>
	 </cftry>
	
<script>
 Prosis.busy('no')
</script>