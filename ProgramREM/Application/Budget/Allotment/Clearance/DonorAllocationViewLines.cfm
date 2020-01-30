
<cfparam name="processmode"            default="view">  <!--- view, entry, amendment --->
<cfparam name="url.datamode"           default="all">
<cfparam name="url.contributionLineId" default="">
<cfparam name="url.transactionid"      default="">
<cfparam name="url.box"                default="1">

<cfset traid = "">

<cfloop index="id" list="#url.transactionid#">

    <cfif traid eq "">
    	<cfset traid = "'#id#'">
	<cfelse>
		<cfset traid = "#traid#,'#id#'">
	</cfif>
	
</cfloop> 

<cfif traid eq "">
	 <cfabort>
</cfif>

<cfset total = "0">

<!--- --------------------------------------------------------------------------------- --->
<!--- information on the transaction, incase of initial allotment we allow to aggregate --->
<!--- --------------------------------------------------------------------------------- --->

<cfquery name="get" 
	datasource="AppsProgram" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">	
	SELECT     PA.TransactionId,
	           P.Mission, 
	           P.ProgramCode, 
			   Pe.PeriodParentCode,
			   Pe.PeriodHierarchy,
	           PA.Fund, 
			   PA.ObjectCode,
   			   PA.Amount,			   
			   Per.Period   as PlanningPeriod, 
			   R.Period     as ProgramPeriod,
			   Per.DateEffective, 
			   Per.DateExpiration
	FROM       ProgramAllotmentDetail PA INNER JOIN
			   ProgramPeriod Pe ON PA.ProgramCode = Pe.ProgramCode AND PA.Period = Pe.Period INNER JOIN
               Program P ON PA.ProgramCode = P.ProgramCode INNER JOIN
               Ref_AllotmentEdition R ON PA.EditionId = R.EditionId INNER JOIN
               Ref_Period Per ON R.Period = Per.Period			  
	WHERE      PA.TransactionId IN (#preserveSingleQuotes(traid)#) 
</cfquery> 

<!--- to be used --->
<cfset EarmarkScope = get.PeriodHierarchy>

<cfif get.PeriodParentCode eq "">
	<cfset hasParent  = "0">
	<cfset parentProgramcode = "">
<cfelse>
    <cfset hasparent = "1">
	<cfset parentProgramcode = get.PeriodParentCode> 
</cfif>	

<cfloop condition="#hasparent# eq 1">
	
	<cfquery name="parent" 
		datasource="AppsProgram" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">	
		SELECT     *
		FROM       Program P, ProgramPeriod Pe
		WHERE      P.ProgramCode = Pe.ProgramCode
		AND        P.Mission     = '#get.Mission#'
		AND        Pe.Period     = '#get.PLanningPeriod#'		
		AND        P.ProgramCode = '#ParentProgramCode#' 
	</cfquery> 
	
	<cfif Parent.recordcount eq "0">
	    <!--- stops the loop --->
		<cfset hasParent = "0">
		
	<cfelse>	
	
		<!--- check if earmarked --->
				
		<cfquery name="check" 
			datasource="AppsProgram" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">		
			SELECT     CLP.ProgramCode
			FROM       Contribution C INNER JOIN
		               ContributionLine CL ON C.ContributionId = CL.ContributionId INNER JOIN
		               ContributionLineProgram CLP ON CL.ContributionLineId = CLP.ContributionLineId
			WHERE      CLP.ProgramCode = '#parent.ProgramCode#'
			AND        C.Mission       = '#get.Mission#'	
		</cfquery> 
		
		<cfif check.recordcount gte "1">			
			<cfset EarmarkScope      = parent.PeriodHierarchy>						
		</cfif>
		
		<cfset parentProgramCode = parent.PeriodParentCode>
			
	</cfif>	
		
</cfloop>

<!--- -------------------------------------------------------------------------------- --->
<!--- ------information on the valid contributions for the selected transaction------- --->
<!--- -------------------------------------------------------------------------------- --->
	 
<cfquery name="Period" 
	datasource="AppsProgram" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT * 
	FROM   Ref_Period 
	WHERE  Period = '#get.PlanningPeriod#'
</cfquery>	
	 
<cfquery name="ContributionLines" 
	datasource="AppsProgram" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	
	  SELECT    C.ContributionId,
			    CL.ContributionLineId,
	            C.OrgUnitDonor, 
				C.ContributionClass,
				R.Description,
				O.OrgUnitName,
				C.Reference, 
				CL.Reference as LineReference,
				CL.DateEffective, 
				CL.DateExpiration,
				CL.OverAllocate, 
				
				<!--- this tranche original --->
				CL.AmountBase,
								
				<!--- added value for this or prior periods : correction --->
				
				( SELECT ISNULL(SUM(AmountBase),0)
				  FROM   ContributionLinePeriod
				  WHERE  ContributionLineId = CL.ContributionLineId 
				  AND    Period IN (SELECT Period 
								    FROM   Ref_Period
				                    WHERE  DateExpiration <= '#period.dateExpiration#')
				 ) as AmountBaseAdditional,		
				 
				<!--- determine how much was alloted from this contribution to this very same project/period/fund/objectcode already 
				 I deliberately excluded the editionid here, and maybe we also need to drop the period here  
				---> 
				 
				( SELECT ISNULL(SUM(Amount),0) 
			      FROM   ProgramAllotmentDetailContribution C		 	 
				  WHERE  ContributionLineId = CL.ContributionLineId
				  AND    TransactionId IN (SELECT TransactionId 
				                           FROM   ProgramAllotmentDetail
										   WHERE  TransactionId = C.TransactionId
										   AND    ProgramCode = '#get.ProgramCode#'
										   AND    Period      IN (SELECT Period 
												                  FROM   Ref_Period
												                  WHERE  DateExpiration <= '#period.dateExpiration#')										  
										   AND    Fund        = '#get.Fund#'
										   AND    ObjectCode  = '#get.ObjectCode#'
										   AND    Status = '1') 
				) as AmountBasePrevious,						   
				   				 				
				<cfif url.datamode eq "all">
					
					<!--- we show additional data --->
				
					(   SELECT ISNULL(SUM(Amount),0) 
					    FROM   ProgramAllotmentDetailContribution C
					    WHERE  ContributionLineId = CL.ContributionLineId
						<!--- atention contributions linked to an allotment with status 0 are included here --->
						AND    TransactionId IN (SELECT TransactionId 
						                         FROM   ProgramAllotmentDetail 
												 WHERE  TransactionId = C.TransactionId 
												 AND    Period IN (SELECT Period 
												                   FROM   Ref_Period
												                   WHERE  DateExpiration <= '#period.dateExpiration#')
												 AND    Status != '9')							
						
						<!--- we excluded the current transaction to reflect a proper balance to be reported --->	
						
						<!---
						<cfif ProcessMode neq "View"> I moved this to the code to ddeduct the estaimte amount + support for data entry line 308
						AND	   TransactionId NOT IN (#preserveSingleQuotes(traid)#)						
						</cfif>		
						--->				
											
					) as AmountBaseAllocated,
										
				</cfif>	
					  
					(   SELECT 	ISNULL(SUM(Amount),0) 
					    FROM   	ProgramAllotmentDetailContribution C
					    WHERE  	TransactionId IN (#preserveSingleQuotes(traid)#)
						AND    	TransactionId IN 	(SELECT TransactionId 
						        	                 FROM   ProgramAllotmentDetail 
													 WHERE  TransactionId = C.TransactionId 
													 AND    Status != '9')  <!--- atention contributions linked to an allotment with status 0 are included here --->
					    AND    ContributionLineId = CL.ContributionLineId
	
					) as AmountBaseUsedThis,  <!--- allocated to this transaction --->
					
															
					(	SELECT  ISNULL(SUM((PADC.Amount * PA.SupportPercentage)/100),0) 
						FROM    ProgramAllotmentDetailContribution PADC INNER JOIN
    	                        ProgramAllotmentDetail PAD ON PADC.TransactionId = PAD.TransactionId INNER JOIN
        	                    ProgramAllotment PA ON PAD.ProgramCode = PA.ProgramCode AND PAD.Period = PA.Period AND PAD.EditionId = PA.EditionId
						WHERE   PADC.TransactionId IN (#preserveSingleQuotes(traid)#)		
						AND     PAD.Status != '9'  <!--- atention contributions linked to an allotment with status 0 are included here --->
						AND     PADC.ContributionLineId = CL.ContributionLineId  
					) as AmountBaseSupportThis 	<!--- calculated support to this transaction also charged to this contribution to be corrected from the balance --->	
													  
      FROM      Contribution C INNER JOIN
                ContributionLine CL ON C.ContributionId           = CL.ContributionId INNER JOIN
                Organization.dbo.Organization O ON C.OrgUnitDonor = O.OrgUnit INNER JOIN
				Ref_ContributionClass R ON R.Code                 = C.ContributionClass
						
	  <cfif processmode neq "view">		  
	 	  	  	  			
	      WHERE  (
		  
		  			C.Mission  = '#get.mission#' 
					
					AND      C.ActionStatus   NOT IN ('0','9')            <!--- reached a status --->
					
					AND      R.Execution IN ('1','2')                     <!--- execution contribution or simple grant --->
					
					AND      CL.Fund            = '#get.Fund#'            <!--- fund of the requirement --->
					AND      CL.DateEffective   < '#get.DateExpiration#'  <!--- execution falls within the valid period of the donor --->
					AND      (CL.DateExpiration > '#get.DateEffective#' OR CL.DateExpiration is NULL)
					
					<!--- 16/6/2016 limit search to only enable contributions enabled for that plan period to be selected --->
					
					AND      CL.ContributionLineId IN (
														SELECT ContributionLineId 
														FROM   ContributionLinePeriod 
					                                    WHERE  ContributionLineId = CL.ContributionLineId 
													    AND    Period = '#get.PlanningPeriod#'
													   )
									 
					<!--- limit search 	--->
					
					AND
					
						(
						
						EXISTS ( 
						
							SELECT 'X'
							FROM   ContributionLineProgram CLP
							WHERE  CLP.ContributionLineId = CL.ContributionLineId
							<!--- contribution earmarked for any program in the branch of the select program/project,
							31/8/2014 usage : for DPA rapod response program is earmarked and thus all the projects under it can be funded
							with it  --->							
							AND    CLP.ProgramCode        IN ( SELECT ProgramCode
							                                   FROM   ProgramPeriod
															   WHERE  Period = '#get.PlanningPeriod#'
															   AND    PeriodHierarchy LIKE ('#EarmarkScope#%')
															   ) 
															 							
						) OR
						
						    <!--- there is no program earmarking for this tranche at all --->
							
							NOT EXISTS (
								SELECT 'X'
								FROM   ContributionLineProgram CLP
								WHERE  CLP.ContributionLineId = CL.ContributionLineId
							)
						
						)								
		
					AND
					
						(
						
						EXISTS ( 
							SELECT 'X'
							FROM  ContributionLineLocation CLL INNER JOIN 
									ProgramLocation PL ON PL.LocationCode = CLL.LocationCode
							WHERE CLL.ContributionLineId = CL.ContributionLineId
							AND   PL.ProgramCode         = '#get.ProgramCode#'
						) OR
						    <!--- there is no location earmarking for this line at all --->
							NOT EXISTS (
								SELECT 'X'
								FROM  ContributionLineLocation CLL
								WHERE CLL.ContributionLineId = CL.ContributionLineId
							)
						
						)	
			
			)
			
			 OR   CL.ContributionLineId IN (
			                                SELECT ContributionLineId 
			                                FROM   ProgramAllotmentDetailContribution 
					 					    WHERE  TransactionId IN (#PreserveSingleQuotes(traid)#)
											)  
											 
			<cfif url.contributionlineid neq "">		
			 OR   CL.ContributionLineId = '#URL.ContributionLineId#'						
			</cfif>
					 
      <cfelse>
	  
	  	  <!--- show the tot this line associated contributions --->
		 	  
		  WHERE    CL.ContributionLineId IN (
		                                     SELECT ContributionLineId
					     					 FROM   ProgramAllotmentDetailContribution PADC
							    			 WHERE  TransactionId IN (#PreserveSingleQuotes(traid)#)
								    		 AND    ContributionLineId = CL.ContributionLineId
											 AND    TransactionId IN (SELECT TransactionId
											                          FROM   ProgramAllotmentDetail 
																	  WHERE  TransactionId = PADC.TransactionId 
																	  AND    Status != '9')
											 )	  
	  	  
	  </cfif>  	 
	  	  	  
	  ORDER BY ContributionClass, OrgUnitName, CL.DateEffective
	  	 
</cfquery>	 

<!--- now we going to present the data by class / orgunitname --->

<cfif processmode eq "view">

	<!--- used for show the result in the process clearance screen --->
	<table width="100%" cellspacing="0" cellpadding="0" align="right">
	
</cfif>

<cfoutput query="ContributionLines" group="ContributionClass">

	<cfoutput group="OrgUnitName">	
	
		<span name="line_#url.box#">
		
		<tr name="line_#url.box#" class="clsdonor line">
		<td style="padding-left:6px" colspan="8" class="labelit ccontent">
		     <div class="hide">#OrgUnitName#</div>
		     <b>#Description#:</b> #OrgUnitName#</td>
		</tr>
				
		<cfoutput>
		
			<cfset AmountContribution = AmountBase + (AmountBase*(overallocate/100)) + AmountBaseAdditional>
			
			<cfif (url.contributionlineid eq contributionlineid or AmountBaseUsedThis neq "0" and processmode neq "view")>
			
			    <!--- prevent it to be hidden --->						
				<cfset cl = "80FF00">
				<cfset sc = "">
				
			<cfelse>
			
				<cfset cl = "transparent">	
				<cfset sc = "clsdonor navigation_row">
			
			</cfif>
		
			<tr id="line_#url.box#_#contributionlineid#" name="line_#url.box#" style="height:15" class="#sc# line" bgcolor="#cl#">	
						   
			    <td width="2%" style="height:20px" class="ccontent"><div class="hide">#OrgUnitName# #Reference# #LineReference#</div></td>				   
						
				<td class="labelit" style="padding-left:34px"><a href="javascript:OpenContribution('','#contributionid#')" tabindex="999"><font color="0080C0">#Reference#</font> #LineReference#</a></td>
				<td class="labelit"><font color="808080">#DateFormat(DateExpiration,CLIENT.DateFormatShow)#</font></td>
				<td class="labelit" style="border-left:1px solid silver" align="right" bgcolor="ffffcf"><font color="808080">#numberformat(AmountBase,"__,__")#</font></td>
								
				<cfif url.datamode eq "all">
				
					<td bgcolor="ffffcf" style="border-left:1px solid silver" align="right"><font color="808080">#numberformat(OverAllocate,'_._')#%</td>
					<td bgcolor="ffffcf" style="border-left:1px solid silver" align="right"><font color="808080">#numberformat(AmountBaseAdditional,"__,__")#</td>
					<td bgcolor="e6e6e6" class="labelit" style="border-left:1px solid silver" align="right" style="padding-left:3px">#numberformat(AmountContribution,"__,__")#</td>
				
					<!--- we show limited and used --->
					
					<cfif ProcessMode eq "View">
						<cfset allocated = AmountBaseAllocated>
					<cfelse>
					    <cfset allocated = AmountBaseAllocated - AmountBaseUsedThis - AmountBaseSupportThis>						
					</cfif>	
													
					<td class="labelit" align="right" style="border-left:1px solid silver;padding-left:3px">#numberformat(allocated,"__,__")#</td>	
					<td class="labelit" align="right" style="border-left:1px solid silver;padding-left:3px">
					
						<cfif AmountBaseAllocated neq "">
							<cfset bal = AmountContribution-allocated>
						<cfelse>
						    <cfset bal = AmountBase>
						</cfif>
						
											
						<cfif abs(bal) lt 1>
						    <font color="green"><b>--</b></font>
						<cfelseif bal lt -1>
							<font color="FF0000">(#numberformat(-bal,"__,__")#)</b></font>
						<cfelse>
							#numberformat(bal,"__,__")#
						</cfif>
					
					</td>	
					
				<cfelse>
				
					<td style="padding-left:3px" class="labelit">
					
						<!--- check if we have funds --->
						
						<cfif AmountBaseUsedThis lt 0 and get.recordcount eq "1">
																			
							<!--- check if we can indeed make such a negative transaction safely --->
							
							<cfinvoke component   = "Service.Process.Program.ProgramAllotment"  
							   method             = "validateContributionBalance" 
							   ProgramCode        = "#get.programcode#" 
							   Period             = "#get.ProgramPeriod#"	
							   Fund               = "#get.Fund#"
							   ObjectCode         = "#get.ObjectCode#"						  
							   ContributionLineId = "#ContributionLineId#"
							   returnvariable     = "contribution">
							   
							   <cfif contribution.accept eq "No">							  
							   
							   <cfsavecontent variable="overspent">VALIDATION\n\nThis contribution participates for an amount of #numberformat(contribution.allotment,"_.__")# in the allotment for this project over period #get.ProgramPeriod#. \n\nHowever the total amount of disbursements mapped to this contribution exceed this amount with #numberformat(contribution.balance*-1,"_.__")#.\n\nConsider to reset the mapping.</cfsavecontent>							   									   
							   <a href="javascript:alert('#overspent#')"><font color="FF0000"><u>Alert: overspending (#numberformat(contribution.balance,"__.__")#)</a></font>
							   </cfif>
						  						   
						</cfif>  								
											
					</td>	
				
				</cfif>
				
				<td align="right" style="border-left:1px solid silver;border-right:1px solid silver;padding-left:5px;padding-right:5px" class="labelit" id="cell_#contributionlineid#">
					
				    <cfif processmode eq "view">
					
						<cfset total = total+AmountBaseUsedThis>						
						<b><font color="0080C0">#numberformat(AmountBaseUsedThis,",__.__")#</font></b>
					
					<cfelse>								
					
						<cfif url.scope neq "">
						
							<cfif contributionLineId eq URL.contributionlineid>
								<cfset total = total+AmountBaseUsedThis>
								<cfset vAmountBaseUsedThis = AmountBaseUsedThis>	
							<cfelse>
								<cfset vAmountBaseUsedThis = 0>	
							</cfif>
							
						<cfelse>
						
							<cfset vAmountBaseUsedThis = AmountBaseUsedThis>		
							<cfset total = total + vAmountBaseUsedThis>		
														
						</cfif>		
												
						<cfif vAmountBaseUsedThis neq "0">
						
						<input type = "text" 
						   class    = "enterastab regular"
						   onchange = "ColdFusion.navigate('#session.root#/ProgramREM/Application/Budget/Allotment/Clearance/setDonorAllocationTotal.cfm?box=#url.box#&transactionid=#url.transactionid#&contributionlineid=#contributionlineid#&scope=#URL.scope#&cid=#URL.ContributionLineId#&process=yes','total_#url.box#','','','POST','donorform')"
						   style    = "padding-top:2px;width:70px;text-align:right" 
						   name     = "AllocationAmount_#left(TransactionId,8)#_#left(contributionlineid,8)#" 
						   id       = "AllocationAmount_#left(TransactionId,8)#_#left(contributionlineid,8)#" 
						   value    = "#numberformat(vAmountBaseUsedThis,",__")#">
						
						<cfelseif get.Amount gte 1 and bal gte 1>	
																												
						<input type = "text" 
						   class    = "enterastab regular"
						   onchange = "ColdFusion.navigate('#session.root#/ProgramREM/Application/Budget/Allotment/Clearance/setDonorAllocationTotal.cfm?box=#url.box#&transactionid=#url.transactionid#&contributionlineid=#contributionlineid#&scope=#URL.scope#&cid=#URL.ContributionLineId#&process=yes','total_#url.box#','','','POST','donorform')"
						   style    = "padding-top:2px;width:70px;text-align:right" 
						   name     = "AllocationAmount_#left(TransactionId,8)#_#left(contributionlineid,8)#" 
						   id       = "AllocationAmount_#left(TransactionId,8)#_#left(contributionlineid,8)#" 
						   value    = "#numberformat(vAmountBaseUsedThis,",__")#">
						   
						<cfelseif get.Amount lt 0 and AmountBasePrevious gte (get.Amount*-1)>
												
						<!--- The idea here is that you can not return an amount to a contribution if that contribution did not contribute that
						amount or more to this project in the first place, otherwise you start paying contributions. --->
						
						<!--- show only if the contribution was used before for this project --->
											
						<input type = "text" 
						   class    = "enterastab regular"
						   onchange = "ColdFusion.navigate('#session.root#/ProgramREM/Application/Budget/Allotment/Clearance/setDonorAllocationTotal.cfm?box=#url.box#&transactionid=#url.transactionid#&contributionlineid=#contributionlineid#&scope=#URL.scope#&cid=#URL.ContributionLineId#&process=yes','total_#url.box#','','','POST','donorform')"
						   style    = "padding-top:2px;width:70px;text-align:right" 
						   name     = "AllocationAmount_#left(TransactionId,8)#_#left(contributionlineid,8)#" 
						   id       = "AllocationAmount_#left(TransactionId,8)#_#left(contributionlineid,8)#" 
						   value    = "#numberformat(vAmountBaseUsedThis,",__")#">	
						   
						<cfelse>
						
						<!--- 
						
						n/a
						
						<!--- discussion with Augustin to give back the money from another discussion 
						
						Due to account division requirement to discontinue a project after a final financial 
						report is finalized I had to reverse the allotment from PG01 to PG11. 
						However some charges had already bn proceed and so I reduced only the available balance 
						and pass JV to reverse the charges from PG01 to PG11. 
						In same time i borrowed fund from Swiss and allotted to PG11 
						to ensure that salary was paid. 
						Now to reallocate funding from suiss to turkey I need the total contribution 
						in Turkey. currently there is 18500 and negative allotment 
						will take to it 30 000 which is the exact amount I need to be 
						able to reallocate contribution from suiss to turkey. Hope this clarify
						
						---> --->
						
						<input type = "text" 
						   class    = "enterastab regular"
						   onchange = "ColdFusion.navigate('#session.root#/ProgramREM/Application/Budget/Allotment/Clearance/setDonorAllocationTotal.cfm?box=#url.box#&transactionid=#url.transactionid#&contributionlineid=#contributionlineid#&scope=#URL.scope#&cid=#URL.ContributionLineId#&process=yes','total_#url.box#','','','POST','donorform')"
						   style    = "padding-top:2px;width:70px;text-align:right" 
						   name     = "AllocationAmount_#left(TransactionId,8)#_#left(contributionlineid,8)#" 
						   id       = "AllocationAmount_#left(TransactionId,8)#_#left(contributionlineid,8)#" 
						   value    = "#numberformat(vAmountBaseUsedThis,",__")#">	
						
																											  					
						
						</cfif>
					   
					 </cfif>  
			    </td>
				
			</tr>
						
			</span>
		
		</cfoutput>
				
	</cfoutput>
	
	<cfif currentrow eq recordcount>
	<cfelse>
		<tr><td colspan="11" class="line ccontent"><div class="hide">#OrgUnitName#</div></td></tr>
	</cfif>

</cfoutput>

<cfoutput>

<!--- valid contributions --->
	
	<input type="hidden" 
	    id    = "ContributionLineIds_#left(TransactionId,8)#" 
		name  = "ContributionLineIds_#left(TransactionId,8)#" 
		value = "#quotedValueList(ContributionLines.ContributionLineId)#">
	
	<script>
	    try {
		document.getElementById('clear#transactionid#').className = "hide"
		document.getElementById('clear#transactionid#').checked = false
		} catch(e) {}
	</script>

</cfoutput>

<cfif ContributionLines.recordcount gte "1">
	
	<cfoutput>
						
		<cfif processmode eq "view">
					
		    <!--- determine if we can show the clearance option to be pressed --->
						   			
			<cfif abs(get.Amount-total) lt 0.1>
								
				<script>
				    try {					
					document.getElementById('clear#transactionid#').className = "regular"										
					document.getElementById('clear#transactionid#').checked = true					
					} catch(e) {}
				</script>				
					
			<cfelse>			
						
				<script>
				    try {
					document.getElementById('clear#transactionid#').className = "hide"
					document.getElementById('clear#transactionid#').checked = false
					} catch(e) {}
				</script>
									
			</cfif>
				
		<cfelse>
		
			<tr name="line_#url.box#"><td height="5"></td></tr>
			
			<tr name="line_#url.box#">
				<td align="right" colspan="8" height="25" style="font:15px" class="labellarge">Assigned:</td>   	
				<td></td>
				<!--- ajaxbox for showing the total --->
				<td align="right" id="total_#url.box#" 
				    class="labellarge" 
					style="border:0px solid silver;padding-right:5px;font:18px">		
					#numberformat(total,"__,__.__")#			
				</td>
			</tr>
		
			<tr><td height="5"></td></tr>
			
		
		</cfif>
	
	</cfoutput>

</cfif>

<cfif processmode eq "view">
	
	</table>
	
</cfif>