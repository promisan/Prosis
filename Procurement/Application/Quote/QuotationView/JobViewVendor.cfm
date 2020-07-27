
<cfparam name="url.id1"                 default="">
<cfparam name="url.workflow"            default="0">
<cfparam name="Object.ObjectKeyValue1"  default="">

<!--- set url.id values based on the context --->
<cfif Object.ObjectKeyValue1 neq "">

	<cfset url.id1 = Object.ObjectKeyValue1>	
    <cfset url.workflow = "1">
	
<cfelse>

    <cfparam name="URL.ID1" default="">
	
</cfif>

<cfparam name="URL.Sort"   default="line">
<cfparam name="URL.Mode"   default="edit">

<cfinvoke component="Service.Access"  
	  method="procjob" 
	  jobno="#URL.ID1#"
	  returnvariable="access">
	   
<cfquery name="Job" 
	 datasource="AppsPurchase" 
	 username="#SESSION.login#" 
	 password="#SESSION.dbpw#">
	   SELECT  J.*
	   FROM    Job J
	   WHERE   J.JobNo ='#URL.Id1#' 
</cfquery>

<cfquery name="FlowDefined" 
	 datasource="AppsOrganization" 
	 username="#SESSION.login#" 
	 password="#SESSION.dbpw#">
		SELECT  *
		FROM    Ref_EntityClassPublish
		WHERE   EntityCode  = 'ProcJob' 
		AND     EntityClass = '#Job.OrderClass#'
</cfquery>		

<cfset URL.Period = Job.Period> 

<cfquery name="Parameter" 
	datasource="AppsPurchase" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
    SELECT *
    FROM Ref_ParameterMission
	WHERE Mission = '#Job.Mission#' 
</cfquery>  

	<!--- determine if job is not fully turned into a PO already --->

<cfquery name="JobOpen" 
	datasource="AppsPurchase" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT    JobLine.RequisitionNo, PurL.RequisitionNo AS Purchase
	FROM      RequisitionLine JobLine LEFT OUTER JOIN
              PurchaseLine PurL ON JobLine.RequisitionNo = PurL.RequisitionNo
	WHERE     JobLine.JobNo = '#URL.ID1#'
	AND       JobLine.ActionStatus NOT IN ('0z','9')
	GROUP BY  JobLine.RequisitionNo, PurL.RequisitionNo
	HAVING    PurL.RequisitionNo IS NULL 
</cfquery> 
					
<cfquery name="LowestBid" 
	datasource="AppsPurchase" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT    SUM(QuoteAmountBase) AS LowestTotal
	FROM      RequisitionLineQuote Q, RequisitionLine L
	WHERE     Q.JobNo = '#URL.ID1#'
	AND       L.RequisitionNo = Q.RequisitionNo
	<!---
	AND       L.ActionStatus IN ('2k','3')
	--->
	AND       L.ActionStatus NOT IN ('9','0z')
	AND OrgUnitVendor IN
	          (SELECT   OrgUnitVendor
						  FROM     RequisitionLineQuote Q1, RequisitionLine L1 
						  WHERE    L1.RequisitionNo = Q1.RequisitionNo
						  <!---
						  AND      L1.ActionStatus IN ('2k','3') 
						  --->
						  AND      L1.ActionStatus NOT IN ('9','0z') 
						  AND      Q1.JobNo = '#URL.ID1#'
						  AND      Q1.QuoteZero = 0
			 			  GROUP BY OrgUnitVendor
						  HAVING   MIN(QuoteAmountBase) > 0)
	GROUP BY OrgUnitVendor
	ORDER BY SUM(QuoteAmountBase) 
</cfquery>
	
<CF_DropTable dbName="AppsQuery" tblName="#SESSION.acc#VendorLow"> 
	
<cfquery name="CompletedBids" 
	datasource="AppsPurchase" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT    OrgUnitVendor, SUM(QuoteAmountBase) AS Total
	FROM      RequisitionLineQuote Q, RequisitionLine L
	WHERE     Q.JobNo = '#URL.ID1#'
	AND       L.RequisitionNo = Q.RequisitionNo
	<!---
	AND       L.ActionStatus IN ('2k','3')
	--->
	AND       L.ActionStatus NOT IN ('9','0z')
	AND       OrgUnitVendor IN
	                     (SELECT   OrgUnitVendor
						  FROM     RequisitionLineQuote Q1, RequisitionLine L1 
						  WHERE    L1.RequisitionNo = Q1.RequisitionNo
						  <!--- 
						  AND      L1.ActionStatus IN ('2k','3') 
						  --->
						  AND      L1.ActionStatus NOT IN ('9','0z') 
						  AND      Q1.JobNo = '#URL.ID1#'
						  AND      Q1.QuoteZero = 0
			 			  GROUP BY OrgUnitVendor
						  HAVING   MIN(QuoteAmountBase) > 0)
	GROUP BY OrgUnitVendor
	ORDER BY SUM(QuoteAmountBase) 
</cfquery>
					
<cfquery name="Vendor" 
  datasource="AppsPurchase" 
  username="#SESSION.login#" 
  password="#SESSION.dbpw#">
    SELECT Org.*
	FROM   JobVendor J, 
	       Organization.dbo.Organization Org
	WHERE  J.JobNo = '#URL.Id1#' 
	AND    J.OrgUnitVendor = Org.OrgUnit
</cfquery>		

<cf_tl id="remove" var="1">
<cfset vRemove=lt_text>


<cf_tl id="award all items" var="1">
<cfset vAward=lt_text>
	  		  		  
  <table width="100%" border="0" cellspacing="0" cellpadding="0">
  
	<tr><td style="padding:6px">
	
		<table width="100%" border="0" cellspacing="0" cellpadding="0">
		
		<cfset attach = "0">
		
		<cf_workflowenabled 
		     mission="#job.mission#" 
			 entitycode="ProcJob"
			 entityclass="#job.OrderClass#">		
							
		<cfif url.workflow eq "1"                   <!--- template is called from a workflow ---> 
				or WorkflowEnabled eq "0"           <!--- JOB WORKFLOW is disabled --->
				or flowdefined.recordcount eq "0">	<!--- workflow is not published --->
							    						
			<!--- if workflow enabled, only show from within the workflow --->
											
			<cfif JobOpen.recordcount gte "1" and (access eq "ALL" or url.workflow eq "1")>
												
				<cfset attach = "1">
						
				<tr><td height="28" colspan="5" style="padding-left:4px">
				
				<cfoutput>
				
				
				
				<table>
				
				<tr><td colspan="4" style="padding-left:20px" id="fundingstatus"></td></tr>
				
				<tr><td>
				
				<cfset link = "#SESSION.root#/procurement/application/quote/quotationview/VendorEntrySubmit.cfm?workflow=#url.workflow#||jobno=#url.id1#">			
				
				  <cf_tl id="Record a Vendor/Contractor" var="vRecord">
				
				   <cf_selectlookup
					    class        = "Organization"
					    box          = "dialog"
						title        = "#vRecord#"
						icon         = "More.png"
						iconwidth    = "24"
						iconheight   = "24"
						link         = "#link#"			
						dbtable      = "Purchase.dbo.RequisitionLineQuote"
						des1         = "OrgUnit"
						filter1      = "Mission"
						filter1Value = "#Parameter.TreeVendor#"
						filter2      = "Substantive"
						filter2Value = "">
						
											
					</td>
					
					<td class="labelmedium" style="padding-left:5px"><font color="0080C0">#vRecord#</td>
					
					</tr></table>
								
				<input type="button"
				 	 id="mybut" class="hide" style="width:40px"
					 onclick="_cf_loadingtexthtml='';ptoken.navigate('#SESSION.root#/procurement/application/quote/quotationview/JobViewVendor.cfm?workflow=#url.workflow#&id1=#url.id1#','dialog');ptoken.navigate('#SESSION.root#/procurement/application/Quote/QuotationView/JobFundingSufficient.cfm?id1=#url.id1#','fundingstatus')">
				 
				 </cfoutput>
				 
				 </td>
				 				 
				 <td align="right" class="labelmedium">
				
					<cfoutput>
						<cf_tl id="Costs" var="vCosts">
						<cf_tl id="Shipping and Handling" var="vShipping">
						
						<cf_UIToolTip  tooltip="#vShipping# #vCosts#">
						<a href="javascript:ProcReqAdd('#Job.JobNo#');">#vShipping#</a>											   
						</cf_UIToolTip>
						
					</cfoutput>
												
				</td></tr>
				
				<tr><td height="1" class="line" colspan="6"></td></tr>
				
			</cfif>
					
		</cfif>		
				
		<cfif Vendor.recordcount eq "0">
			
			<tr>
			   <td height="20" colspan="6" align="center" class="labelmedium">
			    <font color="FF0000"><cf_tl id="Attention">: <cf_tl id="REQ067">
			   </td>
			</tr>
			
		<cfelse>
		
		<!---
		<tr>
		   <td colspan="6" style="height:35" class="labelmedium"><cf_tl id="Vendor/Contractor"> </td>		  
		</tr>	
		--->
					
		<cfoutput query="Vendor">
				
		<tr>
		   
		   <td>
		   
		   	   <table cellspacing="0" cellpadding="0" class="formpadding">
				   <tr>
				   <td align="center" style="padding-left:10px">
				   				   
				   <cf_img icon="select" onClick="viewOrgUnit('#OrgUnit#');">
			   				 					   
				   </td>
				   <td height="17" class="labelmedium">			   
				   		<a href="javascript:viewOrgUnit('#OrgUnit#')">#OrgUnitName#</a>			   		   
				   </td>
				   </tr>
			   </table>
			   
		   </td>
		   
		   <td align="left" class="labelit">
		   
		   <cfquery name="Check" dbtype="query">
				   SELECT * 
				   FROM   CompletedBids
				   WHERE  OrgUnitVendor = #OrgUnit#
		   </cfquery>
		   
		   <cfif LowestBid.LowestTotal eq Check.Total and Check.recordcount eq "1">
		       <img src="#SESSION.root#/Images/validate.gif" align="absmiddle" alt="" border="0"> 
			   <font color="008040"><cf_tl id="Lowest bidder"></font>
	  		   </cfif>
		   </td>
		   
		   <td class="labelit" style="padding-left:4px">#OrgUnitCode#</td>
		   <td align="right" class="labelmedium">
		   		   
		   <cfif check.Total eq "">
			 
			     <font color="FF0000"><cf_tl id="Pending submission">
				  
		   <cfelse>#NumberFormat(check.Total,",.__")#
		   </cfif>
		   </td>
		   
		   <td class="labelit" style="padding-left:5px;padding-right:5px">
		   		   		  
		   <cfif job.actionStatus eq "1">
						
				<cfif LowestBid.LowestTotal eq Check.Total 
				     and LowestBid.LowestTotal neq "" 
					 and JobOpen.recordcount gte "1">
										 					 
					<cfif access eq "ALL" and (WorkflowEnabled eq "0" or flowdefined.recordcount eq "0")>				
					 	<a href="javascript: markvendor('#OrgUnit#','#Job.Mission#','#workflow#','#url.period#','#url.id1#','#url.sort#')"><font color="6688aa">[#vAward#]</b></a></td>							
					<cfelseif workflow eq "1">				 
					 	<a href="javascript: markvendor('#OrgUnit#','#Job.Mission#','#workflow#','#url.period#','#url.id1#','#url.sort#')"><font color="6688aa">[#vAward#]</b></a></td>										
					<cfelse>				
						<!--- no actionenabled --->							 				 
					</cfif>			
				
				</cfif>
				
		  <cfelse>	
		  
		  		<cfif LowestBid.LowestTotal eq Check.Total 
				     and LowestBid.LowestTotal neq "" 
					 and JobOpen.recordcount gte "1" and (WorkflowEnabled eq "0" or flowdefined.recordcount eq "0")>
					 
					<cfif access eq "ALL" and (WorkflowEnabled eq "0" or flowdefined.recordcount eq "0")>							
					 	<a href="javascript: markvendor('#OrgUnit#','#Job.Mission#','#workflow#','#url.period#','#url.id1#','#url.sort#')"><font color="6688aa">[#vAward#]</b></a></td>							
					<cfelseif workflow eq "1">				 
					 	<a href="javascript: markvendor('#OrgUnit#','#Job.Mission#','#workflow#','#url.period#','#url.id1#','#url.sort#')"><font color="6688aa">[#vAward#]</b></a></td>										
					<cfelse>				
						<!--- no actionenabled --->							 				 
					</cfif>			
				
				</cfif>			  
		
		  </cfif>
		   
		   </td>
		   <td align="right" style="padding-top:2px">
		   
		   <cfquery name="VendorRemove" 
	         datasource="AppsPurchase" 
   		     username="#SESSION.login#" 
	         password="#SESSION.dbpw#">
	  		   SELECT    DISTINCT P.OrgUnitVendor
	   		   FROM      PurchaseLine PL INNER JOIN
	                       Purchase P ON PL.PurchaseNo = P.PurchaseNo INNER JOIN
	                       RequisitionLineQuote QL ON PL.QuotationId = QL.QuotationId
	             WHERE     QL.JobNo = '#URL.ID1#' 
	    		   AND       (PL.ActionStatus <> '9')
	       </cfquery>   
		   
		   <cfif VendorRemove.recordcount eq "0" and JobOpen.recordcount gte "1">
			   
			   <cfif access eq "ALL" and (WorkflowEnabled eq "0" or flowdefined.recordcount eq "0")>	
			   
			       <cf_img icon="delete" onclick="removevendor('#OrgUnit#','#workflow#','#url.period#','#url.id1#','#url.sort#')">
			   						 	  
			   <cfelseif workflow eq "1">	
			   
			   	   <cf_img icon="delete" onclick="removevendor('#OrgUnit#','#workflow#','#url.period#','#url.id1#','#url.sort#')">	
			   			   						   
			   <cfelse>				
			   
					<!--- no actionenabled --->							 				 
					
			   </cfif>		   
			   		
		   </cfif>
		   
		   </td>
		   
		   <td width="1"></td>
		</tr>	
						
		<!--- embedded workflow for the vendor itself condition if the job has a workflow  --->
		
		<cf_workflowenabled 
		     mission="#job.mission#" 
			 entitycode="ProcJob"
			 entityclass="#job.OrderClass#">
			 				
		<cfif WorkflowEnabled eq "1">
				
			<cf_workflowenabled 
			     mission="#job.mission#" 
				 entitycode="ProcVendor"
				 entityclass="Standard">
			 			 
			 <cfif WorkflowEnabled eq "1">
				       
				 <tr>
				 <td colspan="7" valign="top" style="padding-left:17px">				 
																								
					<cfset wflnk = "#SESSION.root#/procurement/application/quote/quotationview/JobViewVendorWorkflow.cfm">
										   
				    <cfdiv id="#url.id1#_#orgunit#" 
					       bind="url:#wflnk#?ajaxid=#job.JobNo#_#orgunit#">
					
					<input type    = "hidden" 
				   	       name    = "workflowlink_#url.id1#_#orgunit#" 
                           id      = "workflowlink_#url.id1#_#orgunit#"
						   value   = "#wflnk#">							   
								
				 </td>
				 </tr>	
				 
			<cfelse>
			
				<tr>
				<td colspan="6" style="padding-top:2px;padding-left:30px">				
			    <cfinclude template="JobViewVendorAttachment.cfm">		
			    </td>
				</tr>
				
			</cfif>	
						 
		<cfelse>
				
		 	<tr><td colspan="6" style="padding-top:2px;padding-left:30px">
			    <cfinclude template="JobViewVendorAttachment.cfm">		
			    </td>
			</tr>
				
		</cfif>
			
		</cfoutput>
		
		</cfif>
							
	  </table>
	  
	<tr><td colspan="6" class="line"></td></tr>
	  
	<tr><td height="4"></td></tr>				
	<tr>
	  <td>
	      <table width="100%" cellspacing="0" cellpadding="0">
		  <tr>
		  
	      <td class="labelmedium" style="height:35;padding-left:12px;font-size:23px">		  
			  <cf_tl id="Goods/Services quoted">			  
		  </td>
		  
		  <cfif Vendor.recordcount neq "0"> 
	  		
			<cfoutput>  
				
				<td align="right" style="padding-right:8px" class="labelit">				 
								  
				 <cfif URL.Sort neq "Line"><cfelse><a href="javascript:Prosis.busy('yes');reloadvendorform('#URL.Mode#','#workflow#','#url.period#','#url.id1#','Vendor')"></cfif>[<cf_tl id="Sort by Vendor">]</b></font></a>		   	 
				 <cfif URL.Sort eq "Line"><cfelse><a href="javascript:Prosis.busy('yes');reloadvendorform('#URL.Mode#','#workflow#','#url.period#','#url.id1#','Line')"></cfif>[<cf_tl id="Sort by Request">]</b></font></a>
				  		  
				</td>
				
			</cfoutput>
			
		  </cfif>
		
		</tr>
		
		</table>
	  </td>
	</tr>
		
	<cf_workflowenabled 
		     mission="#job.mission#" 
			 entitycode="ProcJob"
			 entityclass="#job.OrderClass#">	 
	  
	<tr><td style="padding-left:5px"><cfinclude template="JobViewLines.cfm"></td></tr>	
			
	<!--- determine if job is not fully turned into a PO already --->
	
	<tr><td colspan="4" align="center">

		<cfif JobOpen.recordcount gte "1">

			<cfif access eq "ALL" and (WorkflowEnabled eq "0" or flowdefined.recordcount eq "0")>
					<cfinclude template="PurchaseCreate.cfm">	
			<cfelseif workflow eq "1">	
			
					<cfinclude template="PurchaseCreate.cfm">						 
			<cfelse>				
					<!--- no actionenabled --->							 				 
			</cfif>		 
				
		</cfif>
			
	</td></tr>		
	
</table>	

<script>
	Prosis.busy('no')
</script>
	
	