<!--- Prosis template framework --->
<cfsilent>
	<proUsr>jmazariegos</proUsr>
	<proOwn>Jorge Mazariegos</proOwn>
	<proDes>Translated</proDes>
	<proCom></proCom>
</cfsilent>

<!--- End Prosis template framework --->

<cf_screentop height="100%" html="No" scroll="Yes" jquery="Yes">

<cfquery name="Parameter" 
  datasource="AppsPurchase" 
  username="#SESSION.login#" 
  password="#SESSION.dbpw#">
      SELECT *
      FROM   Ref_ParameterMission
	  WHERE  Mission = '#URL.Mission#'
</cfquery>

<cfif url.jobNo neq "">
	
	<cfquery name="Job" 
	datasource="AppsPurchase" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		UPDATE Job
		SET    ActionStatus = '3'
		WHERE  JobNo = '#URL.JobNo#'
	</cfquery>
	
	<cfquery name="Job" 
	datasource="AppsPurchase" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT * 
		FROM   Job
		WHERE  JobNo = '#URL.JobNo#'
	</cfquery>
		
	<cfquery name="OrderClass" 
	datasource="AppsPurchase" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT * 
		FROM   Ref_OrderClass
		WHERE  Code = '#Job.OrderClass#'
	</cfquery>
	
	<cfparam name="URL.Period" default="#Job.Period#">
	
	<cfset preparationmode = OrderClass.preparationMode>

<cfelse>

	<cfparam name="URL.Period" default="#Parameter.DefaultPeriod#">
	
	<cfset preparationmode = "JOB">

</cfif>

<cfquery name="PeriodList" 
datasource="AppsProgram" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT  *
	FROM    Ref_Period
	WHERE   Period IN (SELECT Period 
	                   FROM Purchase.dbo.RequisitionLine WHERE Mission = '#URL.Mission#')
</cfquery>

<cfif url.period eq "">
 <cfset url.period = periodlist.period>
</cfif>

<cf_workflowenabled mission="#url.mission#" entitycode="ProcJob">

<cfif preparationMode eq "SSA">

	<cfquery name="Contractor" 
	datasource="AppsPurchase" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT     DISTINCT Q.PersonNo,Q.PersonClass,P.LastName, P.FirstName
	FROM       RequisitionLineQuote Q INNER JOIN
	           JobActor A ON Q.JobNo = A.JobNo INNER JOIN
	           RequisitionLine L ON Q.RequisitionNo = L.RequisitionNo INNER JOIN
	           Employee.dbo.Person P ON Q.PersonNo = P.PersonNo
	WHERE      Q.PersonClass = 'Employee'
	AND        Q.Selected = '1' 
	AND        L.ActionStatus in  ('2k', '2q')
	 AND       L.JobNo IN (SELECT JobNo FROM Job WHERE Period = '#URL.Period#' AND Mission = '#URL.Mission#')	 
	<cfif URL.JobNo neq "">
	AND        L.JobNo = '#URL.JobNo#'
	</cfif>
	
	<cfif getAdministrator(url.mission) eq "1">
	
		<!--- no filtering --->
		
	<cfelse>
		
	 AND        (A.ActorUserId         = '#SESSION.acc#'		
				  			
				OR
					
	    	    L.Mission IN (SELECT Mission 
	          				  FROM   Organization.dbo.OrganizationAuthorization					
						   	  WHERE  Role IN ('ProcApprover','ProcManager')
							  AND    UserAccount = '#SESSION.acc#')
							  
				)
																		  
	</cfif>     
	
	UNION ALL
	
	SELECT     DISTINCT Q.PersonNo,Q.PersonClass,P.LastName, P.FirstName
	FROM       RequisitionLineQuote Q INNER JOIN
	           JobActor A ON Q.JobNo = A.JobNo INNER JOIN
	           RequisitionLine L ON Q.RequisitionNo = L.RequisitionNo INNER JOIN
	           Applicant.dbo.Applicant P ON Q.PersonNo = P.PersonNo
	WHERE      Q.PersonClass = 'Applicant'
	AND        Q.Selected = '1' 
	AND        L.ActionStatus in ('2k','2q')
	 AND       L.JobNo IN (SELECT JobNo 
	                       FROM   Job 
	                       WHERE  Period = '#URL.Period#' 
						   AND    Mission = '#URL.Mission#')	 
	<cfif URL.JobNo neq "">
	AND        L.JobNo = '#URL.JobNo#'
	</cfif>
	
	<cfif getAdministrator(url.mission) eq "1">
	
		<!--- no filtering --->
	
	<cfelse>
	
	 AND        (A.ActorUserId         = '#SESSION.acc#'		
				  			
				OR
					
	    	    L.Mission IN (SELECT Mission 
	          				  FROM   Organization.dbo.OrganizationAuthorization					
						   	  WHERE  Role IN ('ProcApprover','ProcManager')
							  AND    UserAccount = '#SESSION.acc#')
							  
				)
																		  
	</cfif>     
			 
	</cfquery>
		
	<cfparam name="URL.Contractor"  default="#Contractor.PersonNo#,#Contractor.PersonClass#">

<cfelse>
			
	<cfquery name="Contractor" 
	datasource="AppsPurchase" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT     DISTINCT Q.OrgUnitVendor, 
	           Organization.dbo.Organization.OrgUnitName
	FROM       RequisitionLineQuote Q INNER JOIN
	           JobActor A ON Q.JobNo = A.JobNo INNER JOIN
	           RequisitionLine L ON Q.RequisitionNo = L.RequisitionNo INNER JOIN
	           Organization.dbo.Organization ON Q.OrgUnitVendor = Organization.dbo.Organization.OrgUnit
	WHERE      Q.Selected = '1' 
	AND        L.ActionStatus in ('2k', '2q')
	 AND       L.JobNo IN (SELECT JobNo 
	                       FROM   Job 
	                       WHERE  Period  = '#URL.Period#' 
						   AND    Mission = '#URL.Mission#')	 
	<cfif URL.JobNo neq "">
	AND        L.JobNo = '#URL.JobNo#'
	</cfif>
	
	<cfif getAdministrator(url.mission) eq "1">
	
		<!--- no filtering --->
		
	<cfelse>	
	
	 AND        (A.ActorUserId         = '#SESSION.acc#'		
				  			
				OR
					
	    	    L.Mission IN (SELECT Mission 
	          				  FROM   Organization.dbo.OrganizationAuthorization					
						   	  WHERE  Role IN ('ProcApprover','ProcManager')
							  AND    UserAccount = '#SESSION.acc#')
							  
				)
																		  
	</cfif>     	
	
		 
	</cfquery>
	
	<cfparam name="URL.Contractor"  default="#Contractor.OrgUnitVendor#,vendor">
	
</cfif>
	
<cfparam name="URL.ActionId" default="">

<cfoutput>

<script language="JavaScript">
	
	function selected(contractor) {
	    if (contractor == "") {
		   alert("Please select a contractor")
		} else {
		   ptoken.navigate('PurchaseCreateSelectPO.cfm?period=#url.period#&mission=#URL.mission#&contractor='+contractor,'selection')
		}
	}
	
	function reloadForm(per,contractor) {
		ptoken.location("PurchaseCreate.cfm?actionid=#url.actionid#&header=#url.header#&jobno=#url.jobNo#&mission=#URL.Mission#&period="+per+"&contractor="+contractor)
	}
	
	function show(box) {
		itm = document.getElementById('add')
		itm.className = "Hide"
		itm = document.getElementById('exist')
		itm.className = "Hide"
		itm = document.getElementById(box)
		itm.className = "regular"
	}

</script>

</cfoutput>

<cfajaximport tags="CFFORM">

<cfform action="PurchaseCreateSubmit.cfm?header=#url.header#&ActionId=#URL.actionId#&JobNo=#URL.JobNo#&Mission=#URL.Mission#&period=#URL.Period#" 
        method="post" 
		target="result">

<table width="100%" border="0" bordercolor="d4d4d4">

<tr class="hide"><td width="100%" ><iframe name="result" id="result" width="100%"></iframe></td></tr>

<tr><td style="padding:10px">

	<table width="98%" border="0" align="center" class="formpadding formspacing">
		
	<!--- select requisition of non-work and workflow jobs 
	workflow jobs MUST have an actionStatus = 3 to be selectable
	--->
	
	<cfset cnt = 0>
	<cfparam name="vendor" default="">
	<cfparam name="vclass" default="">
	
	<cfloop index="itm" list="#url.contractor#" delimiters=",">
	 
	  <cfset cnt = cnt+1>
	  <cfif cnt eq "1">
	     <cfset vendor = itm>
	  <cfelse>
	     <cfset vclass = itm>	 
	  </cfif>  
	  
	</cfloop>
		
		<cfquery name="Requisition" 
			datasource="AppsPurchase" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			SELECT    L.*, 
			          J.*,
					  ( SELECT RequisitionNo 
					    FROM   PurchaseLine 
					    WHERE  RequisitionNo = L.RequisitionNo) as PurchaseExist,
					  REQ.RequisitionPurpose	
			FROM      RequisitionLineQuote L INNER JOIN Job J ON L.JobNo = J.JobNo 
						INNER JOIN RequisitionLine R ON R.RequisitionNo = L.RequisitionNo 
							LEFT OUTER JOIN Requisition REQ ON REQ.Reference = R.Reference 
			WHERE     R.ActionStatus  in ('2k', '2q')
			AND       L.Selected      = 1
		    AND       J.Period        = '#URL.Period#'	 
			AND       J.Mission       = '#URL.Mission#'	
			<cfif vclass eq "vendor">
			  AND        L.OrgUnitVendor = '#vendor#'
			<cfelse>
			  AND        L.PersonNo    = '#vendor#'
			  AND        L.PersonClass = '#vclass#'
			 </cfif>		
			<!--- no workflow enabled --->
			
			AND       J.JobNo NOT IN (SELECT  ObjectKeyValue1
		                              FROM    Organization.dbo.OrganizationObject
		                              WHERE   EntityCode = 'ProcJob'
								      AND     ObjectKeyValue1 = J.JobNo)
									  
		    <cfif URL.JobNo neq "">
			AND        R.JobNo = '#URL.JobNo#'
			</cfif>						 
			
			<cfif getAdministrator(url.mission) eq "1">
	
					<!--- no filtering --->
					
			<cfelse>
			
			AND       (L.JobNo IN (SELECT JobNo
			                      FROM JobActor 
								  WHERE ActorUserId = '#SESSION.acc#') 
								  
						OR
						
			    	  J.Mission IN (SELECT Mission 
		          				  FROM Organization.dbo.OrganizationAuthorization					
							   	  WHERE Role IN ('ProcApprover','ProcManager')
								  AND  UserAccount = '#SESSION.acc#')
								  
					)					  
			</cfif>							
			
			UNION ALL
			
			<!--- improvement : allows lines to be selected only if job has reached the last step 
			can be adjusted to check if only one step in WF is pending and then
			upon sumission close the step as well 
			--->
			
			SELECT    L.*, J.*,
			          (SELECT RequisitionNo FROM PurchaseLine WHERE RequisitionNo = L.RequisitionNo) as PurchaseExist,
					  REQ.RequisitionPurpose					  
			FROM      RequisitionLineQuote L INNER JOIN Job J ON J.JobNo = L.JobNo  
					  	INNER JOIN RequisitionLine R ON R.RequisitionNo = L.RequisitionNo
					  	LEFT OUTER JOIN Requisition REQ ON REQ.Reference = R.Reference				  
			WHERE     R.ActionStatus  in ('2k','2q') 
			AND       L.Selected      = 1
		    AND       J.Period        = '#URL.Period#'	 
			AND       J.Mission       = '#URL.Mission#'
			<cfif vclass eq "vendor">
			  AND        L.OrgUnitVendor = '#vendor#'
			<cfelse>
			  AND        L.PersonNo    = '#vendor#'
			  AND        L.PersonClass = '#vclass#' 
			</cfif>		
			<cfif URL.JobNo neq "">
			AND        R.JobNo = '#URL.JobNo#'
			</cfif>
			
			<cfif getAdministrator(url.mission) eq "1">
	
				<!--- no filtering --->
			
			<cfelse>
			
			AND      (L.JobNo IN (SELECT JobNo
			                      FROM JobActor 
								  WHERE ActorUserId = '#SESSION.acc#') 
								  
					OR
						
			    	  J.Mission IN (SELECT Mission 
		          				    FROM   Organization.dbo.OrganizationAuthorization					
							   	    WHERE  Role IN ('ProcApprover','ProcManager')
								    AND    UserAccount = '#SESSION.acc#')
								  
					)			  
								  			  
			</cfif>		
					
			<!--- check if workflow is completed, no pending actions --->		
			
			AND      
			        (
					
					<!--- last step reached --->
			        J.JobNo IN (SELECT  ObjectKeyValue1
		                         FROM    Organization.dbo.OrganizationObject O
		                         WHERE   EntityCode = 'ProcJob'
								 AND     Operational = 1
								 AND     ObjectId NOT IN (SELECT ObjectId 
								                          FROM   Organization.dbo.OrganizationObjectAction 
														  WHERE  ObjectId = O.ObjectId 
														  AND    ActionStatus = '0'
														  GROUP BY ObjectId
														  HAVING count(*) = 2
														 )
								 AND     ObjectKeyValue1 = J.JobNo
							   )
								 
					 OR 
					 
					 <!--- specifically allowed for PO creation despite the above --->
					 J.ActionStatus = '2'
					 
					 )
					 			 
			AND      J.ActionStatus != '9'	
			ORDER BY J.Mission, L.JobNo			
		</cfquery>
		
	
	<!--- if job has a workflow it would need a status = 3 in order to select items --->
		
	<tr class="labelmedium2">
	   <td style="min-width:200;width:100"><cf_tl id="Period">:</td>
	   <td>
	    <select name="period" id="period" class="regularxxl" onChange="reloadForm(this.value,document.getElementById('contractor').value)">
			  <cfoutput query="PeriodList">
			     <option value="#Period#" <cfif URL.Period eq Period> SELECTED</cfif>>#Period#</option>
			  </cfoutput>
	   </select>
	   </td>
	</tr>
		
	<tr class="labelmedium2">
	   <td><cf_tl id="Contractor">:</td>
	   <td>
	   
	   <cfif preparationMode eq "SSA">
	     
	   	 <select name="contractor" id="contractor" class="regularxxl" style="width:200px" onChange="reloadForm(document.getElementById('period').value,this.value)">
		      <option value=""><cf_tl id="select"></option>
			  <cfoutput query="Contractor">
			     <option value="#PersonNo#,#personclass#" <cfif url.contractor eq "#PersonNo#,#PersonClass#"> SELECTED</cfif>>#FirstName# #LastName# <cfif personclass eq "applicant">[<cf_tl id="Candidate">]</cfif></option>
			  </cfoutput>
	   </select>
	   
	   <cfelse>
	   
	    <select name="contractor" id="contractor" class="regularxxl" style="width:200px" onChange="reloadForm(document.getElementById('period').value,this.value)">
		      <option value=""><cf_tl id="select"></option>
			  <cfoutput query="Contractor">
			     <option value="#OrgUnitVendor#,vendor" <cfif vendor eq OrgUnitVendor> SELECTED</cfif>>#OrgUnitName#</option>
			  </cfoutput>
	   </select>
	   
	   </cfif>
	   
	   </td>
	</tr>
		
	<tr class="labelmedium2">
	   <td><cf_tl id="Purchase Order">:</td>
	   <td><table>
	       <tr class="labelmedium2">
	       <td><input type="radio" name="Select" class="radiol" id="Select" value="add" checked onClick="show('add')"></td>
		   <td style="padding-left:4px"><cf_tl id="New"></td>
		   <td style="padding-left:8px">
		   <input type="radio" name="Select" class="radiol" id="Select" value="exist" onClick="show('exist');selected(document.getElementById('contractor').value)">
		   </td>
		   <td style="padding-left:4px"><cf_tl id="Existing"></td>
		   </tr>
		   </table>
	   </td>
	</tr>
		
	<tr id="add"><td colspan="2">
	
		<table width="100%">
		
		<tr><td width="100%">
		
			<table width="100%" class="formpadding">
				
			<cfquery name="OrderClass" 
			datasource="AppsPurchase" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			SELECT  *
			FROM    Ref_OrderClass
			WHERE   PreparationMode != 'Direct'
			AND     (
			        Mission         = '#URL.Mission#' 
			                  OR Mission is NULL 
							  OR Code IN (SELECT Code 
	                                      FROM   Ref_OrderClassMission 
										  WHERE  Mission = '#url.mission#')
				    )
			</cfquery>			
			
			
			<!---- URL.MISSION Added by Jorge Mazariegos on feb 03/2011 ---->
			
			<tr>
			   <td style="min-width:200;width:100" class="labelmedium2"><cf_tl id="Order Class">:</td>
			   
			   <td width="100%" class="labelmedium2">
			   
			   	<cfif orderclass.recordcount eq "0">
				
				  <font color="FF0000"><cf_tl id="Contact administrator"></font>
				  
				  <input type="hidden" name="orderclass" id="orderclass" value="">
			
				<cfelse>
			   		    
				  <cfinvoke component="Service.Access"
					   Method         = "RoleAccess"
					   Mission        = "#url.mission#"
					   Role           = "'ProcManager'"
					   AccessLevel    = "'EDIT','ALL'"				   					  
					   ReturnVariable = "ManagerAccess">	
			   
			     <select name="orderclass" id="orderclass" style="width:200px" class="regularxxl">
				 
				  <cfset show = "0">
				 
				  <cfoutput query="OrderClass">
				  				  			  
				  	 <!--- check access for a class --->				
					 
					 <cfinvoke component="Service.Access"
					   Method         = "procApprover"
					   Mission        = "#url.mission#"
					   OrderClass     = "#code#"
					   ReturnVariable = "ApprovalAccess">	
					   
					   <cfif ApprovalAccess eq "EDIT" or ApprovalAccess eq "ALL" or ManagerAccess eq "GRANTED">				   
					   
					     <cfset show = "1">
					 			  
					     <option value="#Code#" <cfif requisition.OrderClass eq code>selected</cfif>>&nbsp;#Description#</option>
					 
					   </cfif>			 
					 
				  </cfoutput>
				  
				   <!--- --------------------------------------------------------------------------- --->
				   <!--- if nothing is shown we make sure we show any to have backward compatibility --->
				   <!--- --------------------------------------------------------------------------- --->
				  
				  <cfif show eq "0">
				  
				   <cfoutput query="OrderClass">
				   	   <option value="#Code#" <cfif requisition.OrderClass eq code>selected</cfif>>&nbsp;#Description#</option>
				   </cfoutput>
				   
				  </cfif>
				  
			     </select>
				 
				 </cfif>
				 
			   </td>
			</tr>
							
			<tr>
			   <td class="labelmedium2"><cf_tl id="Order Type">:</td>
			   <td>		   	   
			   	 <cfdiv bind="url:#SESSION.root#/Procurement/Application/PurchaseOrder/Create/getOrderType.cfm?mission=#url.mission#&orderclass={orderclass}"> 			      
			   </td>
			  
			</tr>
			
			<tr><td></td>
			    <td style="padding-top:4px" class="labelmedium2" id="infobox"></td>
			</tr>
					
			</table>
			
		</td>	
		
		</tr>
		
		</table>
	
	</td></tr>
	
	<tr id="exist" class="hide">				
		   <td></td>	  
		   <td><cfdiv id="selection"/></td>
	</tr>	
	
	<tr><td height="8"></td></tr>
	
	<tr>
	   <td colspan="2" style="padding-left:10px" class="labelmedium2"><cf_tl id="Select lines for this obligation">:</b></td>
	</tr>
	
	<tr><td colspan="2" style="padding-left:20px">
	
		<!--- create selection lines --->
					
		<cfif Requisition.recordcount eq "0">
		
			<script language="JavaScript">
			  <!---	  alert("There are NO requisition lines found that are pending issuing of a purchase order for this period.") --->
			  <!--- parent.window.close()  parent.opener.history.go() --->
			</script>
		
		</cfif>
			
		<cfset fun = "0">
		
		<cfinclude template="PurchaseCreateLines.cfm">
		
	</td></tr>
	
	<cfparam name="PurchaseRemarks" default="">
	
	<tr>
		   <td class="labelmedium2" valign="top" style="padding-top:3px;padding-left:10px"><cf_tl id="Remarks">:</b></td>
		   <td>
		      <textarea style="width:100%;height:40;padding:3px;font-size:13px" class="regular" name="Remarks"><cfoutput>#Purchaseremarks#</cfoutput></textarea>
		   </td>
		</tr>
	
	<cfif Requisition.recordcount gt "0">
		
		<cfoutput>
			
			<tr><td colspan="2" align="center" height="45">
			
				 <cf_tl id="Close" var="1">
			
			     <input type="button"
			       name="Close"
			       id="Close"
			       value="#lt_text#" class="button10g"	 
				   onclick="parent.ProsisUI.closeWindow('mydialog',true)"  
			       style="width: 170px; font-size:12px;height: 30px;">	
				   
				<cf_tl id="Submit Obligation" var="1">
				   
			    <input type="submit"
			       name="Submit"
			       id="Submit"
			       value="#lt_text#" class="button10g"	
				   onclick="Prosis.busy('yes')"    
			       style="width: 170px; font-size:12px;height: 30px;">
				   
			</td></tr>
		
		</cfoutput>
	
	</cfif>
	
	<tr><td height="4"></td></tr>
	
	</table>

</td></tr>

</table>

</cfform>
