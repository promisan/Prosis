<table width="93%" align="center" class="formspacing">

	<cfquery name="AllotmentAction"
	datasource="AppsProgram" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	
		SELECT     P.ProgramCode, 
		           Pe.Reference,
				   PA.Reference as DocumentReference,
				   Pe.Period,
				   P.ProgramClass, 
				   P.ProgramName, 
				   R.EditionId,
				   R.Description AS EditionDescription, 
				   RA.Description AS ActionDescription, 
				   PA.ActionType, 
	               PA.ActionMemo, 
				   PA.Status, 
				   PA.ActionDate,
				   PA.OfficerUserId, 
				   PA.OfficerLastName, 
				   PA.OfficerFirstName, 
				   PA.Created
		FROM       ProgramAllotmentAction PA INNER JOIN
	               Ref_AllotmentEdition R ON PA.EditionId = R.EditionId INNER JOIN
	               Program P ON PA.ProgramCode = P.ProgramCode INNER JOIN
	               ProgramPeriod Pe ON PA.ProgramCode = Pe.ProgramCode AND PA.Period = Pe.Period LEFT OUTER JOIN
	               Ref_AllotmentAction RA ON PA.ActionClass = RA.Code
		WHERE      PA.ActionId = '#url.id#'
		
	</cfquery>	
	
	<cfoutput query="allotmentaction">
	
		<tr><td height="8"></td></tr>
		<tr  style="height:20px" class="labelmedium fixlengthlist">
		    <td width="80"  style="height:20px;padding-right:30px"><cf_tl id="Document">:</td>
			<td width="35%" style="height:20px" id="tdReference">
				<cfinclude template="AllotmentActionReferenceEdit.cfm">
			</td>		
			 <td width="80" style="height:20px"><cf_tl id="Date">:</td>
			<td width="45%" style="height:20px">#dateformat(ActionDate,CLIENT.dateformatshow)#</td>		
		</tr>
		
		<tr style="height:20px" class="labelmedium fixlengthlist">
		    <td><cf_tl id="Reference">:</td>
			<td>#Reference#</td>
			<td><cf_tl id="Name">:</td>
			<td>#ProgramName#</td>		
		</tr>
		
		<tr style="height:20px" class="labelmedium fixlengthlist">
		    <td><cf_tl id="Edition">:</td>
			<td>#EditionDescription#</td>
			<td><cf_tl id="Period">:</td>
			<td>#Period#</td>		
		</tr>
		
		<tr style="height:20px" class="labelmedium fixlengthlist">
		    <td><cf_tl id="Transaction">:</td>
			<td>#ActionDescription#</td>
			<td><cf_tl id="Status">:</td>
			<td id="actstatus">
			    <cfif status eq "0"> <cf_tl id="In process">
			    <cfelseif status eq "1"><font color="gray"> <cf_tl id="In Process">
				<cfelseif status eq "3"><b><font color="green"> <cf_tl id="Completed">
				<cfelseif status eq "9"><font color="FF0000"> <cf_tl id="Cancelled"> </font></cfif>
			</td>		
		</tr>
		
		<tr style="height:20px" class="labelmedium line fixlengthlist">
		    <td><cf_tl id="Officer">:</td>
			<td>#OfficerFirstName# #OfficerLastName#</td>
			<td style="padding-right:30px"><cf_tl id="Recorded">:</td>
			<td>#dateformat(created,CLIENT.dateformatshow)# #timeformat(created,"HH:MM")#</td>		
		</tr>
			
		<cfif ActionMemo neq "">
		<tr style="height:20px" class="labelmedium line fixlengthlist">
		    <td><cf_tl id="Memo">:</td>
			<td colspan="3">#ActionMemo#</td>		
		</tr>
		</cfif>
				
	</cfoutput>
		
	<cfquery name="Detail"
	datasource="AppsProgram" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT    R.Code,  
		          R.Description, 
				  PAD.ProgramCode,
				  PAD.Period,
				  PAD.TransactionType,
				  PAD.Fund, 
				  (SELECT OrgUnitName FROM Organization.dbo.Organization WHERE OrgUnit = PAD.OrgUnit) as OrgUnitName, 
				  PAD.Currency,
				  PAD.Amount,
				  TransactionId
		FROM      ProgramAllotmentDetail PAD INNER JOIN Ref_Object R ON PAD.ObjectCode = R.Code
		WHERE     PAD.ActionId = '#url.id#'	
		AND       PAD.Status != '9'
		ORDER BY  R.Code, PAD.Amount 
	</cfquery>	
	
	<tr><td aling="center" colspan="4" style="width:99%;padding:0px">
	
		<table width="100%" cellspacing="0" cellpadding="0" align="center" class="navigation_table">
		
			<tr height="20" class="line">
			   
				<td style="width:20%" class="labelmedium"><cf_tl id="Type"></td>		
				<td class="labelmedium"><cf_tl id="Fund"></td>		
				<td class="labelmedium"><cf_tl id="Organization"></td>
				<td align="right" class="labelmedium"><cfoutput>#detail.currency#</cfoutput> <cf_tl id="Amount"></td>
			</tr>
					
			<cfoutput query="detail" group="Code">
			
				<tr class="line">			    
					<td class="labellarge" style="height:30px" colspan="4">#Code# #Description# 
					
					<cfif ProgramCode neq AllotmentAction.ProgramCode>
				
				
						<cfquery name="getProgram"
						datasource="AppsProgram" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">
						
							SELECT     *
							FROM       Program P INNER JOIN ProgramPeriod Pe ON P.ProgramCode = Pe.ProgramCode
							WHERE      P.ProgramCode = '#programcode#'
							AND        Pe.Period = '#period#'
									
						</cfquery>		
						
						<b><font color="008000">(#getProgram.ProgramName# #getprogram.Reference#)
					
					
					</cfif></td>					
				</tr>
			
				<cfoutput>
				
				<tr class="navigation_row labelmedium" style="height:20px">			    
					<td style="padding-left:5px" height="20">#TransactionType#</td>	
					<td>#Fund#</td>			
					<td c>#OrgUnitName#</td>
					<td align="right" style="padding-right:4px">#numberformat(amount,"__,__")#</td>
				</tr>
				
				<!--- donor information --->
								
				<cfquery name="Donor"
				datasource="AppsProgram" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">			
	
					SELECT    C.Contributionid,
					          C.Reference, 
					          C.OrgUnitDonor, 
							  (SELECT OrgUnitName FROM Organization.dbo.Organization WHERE OrgUnit = C.OrgUnitDonor) as OrgUnitName, 
							  CL.DateEffective, 
							  CL.DateExpiration, 
							  CL.Reference AS ContributionReference, 
							  PADC.Amount
					FROM      ProgramAllotmentDetailContribution PADC INNER JOIN
	            	          ContributionLine CL ON PADC.ContributionLineId = CL.ContributionLineId INNER JOIN
		                      Contribution C ON CL.ContributionId = C.ContributionId							  
					WHERE     PADC.TransactionId = '#transactionid#'
					
				</cfquery>	
								
				<cfloop query="Donor">
							    
					<tr class="navigation_row labelmedium line" style="height:20px">			    
						<!---
						<cfset oSecurity = CreateObject("component","Service.Process.System.UserController")/>
						<cfset mid = oSecurity.gethash()/>   
						--->
						
						<cfif Donor.currentrow eq "1">
						<td height="18" bgcolor="EAFBFD" style="padding-left:20px">
						<font color="gray"><cf_tl id="Contributions">:						
						</td>						
						<cfelse>
						<td height="18" style="padding-left:20px"></td>	
						</cfif>
						
						<cfparam name="url.idmenu" default="">
						
					    <td height="18" style="padding-left:5px">
						<a href="javascript:OpenContribution('#url.idmenu#','#contributionid#')" tabindex="999"><font color="0080FF">#Reference#</a>
						</td>
						<td>#ContributionReference#</td>														
						<td align="right" style="padding-right:40px">#numberformat(amount,",")#</td>
					</tr>
									
				</cfloop>	
				
				<!--- requirement information --->
				
				<cfquery name="Details"
				datasource="AppsProgram" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">		
							
					SELECT   PAD.ProgramCode, PAD.Period, PAD.EditionId, PAD.Fund, PAD.ObjectCode, PAD.Amount, PAR.RequestType, 
			                 PAR.RequestDescription, PAR.ItemMaster, Purchase.dbo.ItemMaster.Description, PADR.Amount AS AmountRequirement, PAD.AmountRounded
					FROM     ProgramAllotmentDetail AS PAD INNER JOIN
		                	 ProgramAllotmentDetailRequest AS PADR ON PAD.TransactionId = PADR.TransactionId INNER JOIN
	    		             ProgramAllotmentRequest AS PAR ON PADR.RequirementId = PAR.RequirementId INNER JOIN
			                 Purchase.dbo.ItemMaster ON PAR.ItemMaster = Purchase.dbo.ItemMaster.Code 
					WHERE    PAD.TransactionId = '#TransactionId#'
													
				</cfquery>
					
				
				<cfloop query="Details">
							    
					<tr class="navigation_row labelmedium line" style="height:15px">	  
						
						<td style="padding-left:25px" colspan="3">#Description# #RequestDescription# </td>															
						<td align="right" style="padding-right:40px">#numberformat(amountRequirement,",")#</td>
					</tr>
									
				</cfloop>	
					
				</cfoutput>
			
			</cfoutput>
		
		</table>	
	
	</td></tr>
	
	<tr class="hide"><td>
	
	 <cfset wflnk = "#client.root#/programREM/Application/Budget/Action/AllotmentActionViewWorkflow.cfm">
	 
	 <cfoutput>
	   
	 <input type="hidden" 
	          name="workflowlink_#url.id#" 
			  id="workflowlink_#url.id#"
	          value="#wflnk#"> 
			  
	 <input type="button" class="hide"
		     name  = "workflowlinkprocess_#url.id#"
             id    ="workflowlinkprocess_#url.id#"
		     onClick= "ColdFusion.navigate('#client.root#/programREM/Application/Budget/Action/AllotmentActionStatus.cfm?id=#url.id#','actstatus')">
			 
	 </cfoutput>		
	
	</td></tr>
	
	<tr><td colspan="4" style="padding-top:5px">					 
		 <cfdiv id="#url.id#"  bind="url:#wflnk#?ajaxid=#url.id#"/>	
		</td>
	</tr>

</table>