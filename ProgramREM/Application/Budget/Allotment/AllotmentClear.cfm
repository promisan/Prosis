
<!--- ---------------------------------- --->
<!--- determine if clearance can be done --->
<!--- ---------------------------------- --->

<cfquery name="Edition" 
datasource="AppsProgram" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
  SELECT *
  FROM   Ref_AllotmentEdition
  WHERE  EditionId  = '#URL.EditionId#'
</cfquery>

<cfquery name="Program" 
datasource="AppsProgram" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
  SELECT *
  FROM   Program
  WHERE  ProgramCode  = '#URL.ProgramCode#'
</cfquery>

<cfquery name="Parameter" 
datasource="AppsProgram" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT   *
	FROM     Ref_ParameterMission
	WHERE    Mission = '#Program.Mission#'
</cfquery>

<cfset stop = 0>
	
<cfif Parameter.BudgetCeiling eq "Resource">
		
		<cfquery name="Resource" 
		datasource="AppsProgram" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		  SELECT Resource 
		  FROM   ProgramAllotmentCeiling
		  WHERE  ProgramCode  = '#URL.ProgramCode#'
		  AND    Period       = '#URL.Period#'
		  AND    EditionId    = '#URL.EditionId#'  
		  AND    Resource IN (SELECT Resource  
	                      FROM   Ref_ParameterMissionResource 
						  WHERE  Mission = '#Program.Mission#'
						  AND    Ceiling = 1)
		</cfquery>
			
		<cfloop query="Resource">
		
			<cfquery name="Ceiling" 
			datasource="AppsProgram" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			  SELECT sum(Amount) as Amount 
			  FROM   ProgramAllotmentCeiling
			  WHERE  ProgramCode  = '#URL.ProgramCode#'
			  AND    Period       = '#URL.Period#'
			  AND    EditionId    = '#URL.EditionId#'  
			  AND    Resource     = '#Resource#'
			</cfquery>
			
			<cfquery name="Budget" 
			datasource="AppsProgram" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			SELECT    SUM(Amount) AS Total
			FROM      ProgramAllotmentDetail
			WHERE     ProgramCode  = '#URL.ProgramCode#'
			  AND     Period       = '#URL.Period#'
			  AND     EditionId    = '#URL.EditionId#'	
			  AND     ObjectCode IN (SELECT Code 
			                         FROM   Ref_Object 
									 WHERE  Resource = '#Resource#')
		   </cfquery>
		   
		   <cfif  Ceiling.amount gt "0" and ceiling.amount lt budget.total>
		     <cfset stop = 1>
		   </cfif>
		
		</cfloop>
	
	<cfelse>
	
		<cfquery name="Ceiling" 
			datasource="AppsProgram" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			  SELECT sum(Amount) as Amount 
			  FROM   ProgramAllotmentCeiling
			  WHERE  ProgramCode  = '#URL.ProgramCode#'
			  AND    Period       = '#URL.Period#'
			  AND    EditionId    = '#URL.EditionId#'  
			  AND    Resource IN (SELECT Resource 
			                      FROM   Ref_ParameterMissionResource 
								  WHERE  Mission = '#Program.Mission#'
								  AND    Ceiling = 1) 
		</cfquery>	
			
		<cfquery name="Budget" 
			datasource="AppsProgram" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				SELECT    SUM(Amount) AS Total
				FROM      ProgramAllotmentDetail
				WHERE     ProgramCode  = '#URL.ProgramCode#'
				  AND     Period       = '#URL.Period#'
				  AND     EditionId    = '#URL.EditionId#'	
				  AND     ObjectCode IN (SELECT Code 
			                         FROM   Ref_Object 
									 WHERE  Resource IN (SELECT Resource 
			                      						 FROM   Ref_ParameterMissionResource 
													     WHERE  Mission = '#Program.Mission#'
														 AND    Ceiling = 1
														)
											)			
		</cfquery>
		
		 <cfif Ceiling.amount gt "0" and ceiling.amount lt budget.total>
		     <cfset stop = 1>
		 </cfif>
		
</cfif>

<!---	
</cfif>	
--->

<cfif stop eq "1" and Parameter.BudgetCeilingClear eq "0"> <!--- requires clearance AND exceeds ceiling --->

    <table width="100%" cellspacing="0" cellpadding="0" class="formpadding"><tr><td style="padding:3px">
	
	<table height="100%" width="100%" bgcolor="FFD5D5" style="border:1px solid silver;border-radius:5px">
		<tr><td class="labelit" align="center"><font color="800000"><cf_tl id="Ceiling exceeded"></font></td></tr>
		
		<cfif Parameter.BudgetCeiling neq "Resource">
		<tr bgcolor="ffffff"><td>
		
			<table width="100%" cellspacing="0" cellpadding="0" class="formpadding">
			<tr class="labelit">		
		    <td style="padding-left:5px"><cf_tl id="Ceiling">:</td>
			
		    <td align="right" style="padding-right:13">
			
			<cfif Parameter.BudgetAmountMode eq "0">
				<cf_numbertoformat amount="#Ceiling.amount#" present="1" format="number">
		  	<cfelse>
				<cf_numbertoformat amount="#Ceiling.amount#" present="1000" format="number1">
			  </cfif> 
			  <cfoutput>#val#</cfoutput> 
			
			</td>
						
			<td style="padding-left:3px"><cf_tl id="Requested">:</td>
			
			<td align="right" style="padding-right:5px">
			
			<cfif Parameter.BudgetAmountMode eq "0">
				<cf_numbertoformat amount="#budget.total#" present="1" format="number">
		  	<cfelse>
				<cf_numbertoformat amount="#budget.total#" present="1000" format="number1">
			</cfif> 
			<cfoutput>#val#</cfoutput> 
			
			</td>
			
			</table>
			
			</tr>
		</tr>	
		</cfif>
		
	</table>
	</td></tr></table>
	

<cfelse>	

	<cfquery name="Check" 
	     datasource="AppsProgram" 
	     username="#SESSION.login#" 
	     password="#SESSION.dbpw#">
	     SELECT     P.*, 		
		            (SELECT MIN(Status) 
					 FROM   ProgramAllotmentDetail 
					 WHERE  ProgramCode = P.ProgramCode and Period = P.Period and EditionId = P.EditionId)
					       as EditionStatus,          
		            E.EntryMethod, 
					E.EditionClass, 
					E.ControlEdit
	     FROM       Ref_AllotmentEdition E, ProgramAllotment P
	     WHERE      P.EditionId   = '#URL.EditionId#'	
		 AND        E.EditionId   = P.EditionId
		 AND        P.ProgramCode = '#URL.ProgramCode#'
		 AND        P.Period      = '#URL.Period#' 
	</cfquery>		
	
	<cfquery name="Entries" 
	     datasource="AppsProgram" 
	     username="#SESSION.login#" 
	     password="#SESSION.dbpw#">
	     SELECT     P.*
	     FROM       ProgramAllotmentDetail P
	     WHERE      P.EditionId   = '#URL.EditionId#'			
		 AND        P.ProgramCode = '#URL.ProgramCode#'
		 AND        P.Period      = '#URL.Period#' 
	</cfquery>	
		  
	 <cfinvoke component="Service.Access"  <!--- get access levels based on top Program--->
			Method         = "budget"
			ProgramCode    = "#URL.ProgramCode#"
			Period         = "#URL.Period#"	
			EditionId      = "'#URL.editionID#'"  
			Role           = "'BudgetManager'"
			ReturnVariable = "BudgetAccess">	
																
		<cfif Check.ControlEdit eq "1" and (BudgetAccess eq "EDIT" or BudgetAccess eq "ALL")>
														
			<cfif Check.EntryMethod eq "Snapshot">
									
				<!--- allotment status is set to pending clearance --->
				
			    <cfif Check.EditionStatus eq "0">
					
					<cfoutput>
					
					<table cellspacing="0" cellpadding="0"><tr><td class="labelmedium">
					<cf_tl id="Clear">
					</td>
					<td style="padding-left:2px" class="labelmedium">
				       <input type   = "checkbox" 
				           name   = "Clear" 
						   class  = "radiol"
						   value  = "#Editionid#"
				           onclick= "ptoken.navigate('#SESSION.root#/ProgramREM/Application/Budget/Allotment/AllotmentClearanceSubmit.cfm?programcode=#url.programcode#&period=#url.period#&editionid=#url.editionid#','box#url.editionid#')">
						   
						   </td></tr>
						   </table>
				</cfoutput>			 
					
				<cfelse>				
												
					<cfquery name="Clear" 
				     datasource="AppsProgram" 
				     username="#SESSION.login#" 
				     password="#SESSION.dbpw#">
					     SELECT     top 1 *
					     FROM       ProgramAllotmentAction A, ProgramAllotment P
					     WHERE      A.ActionClass = 'Snapshot'	
						 AND        A.ActionType IN ('Cleared', 'Approved')				 
						 AND        P.EditionId   = '#URL.EditionId#'
						 AND        P.ProgramCode = '#URL.ProgramCode#'
						 AND        P.Period      = '#URL.Period#'
						 ORDER BY A.Created DESC
					 </cfquery>
					 
					  <cfoutput>
					  
						 <table width="100%" height="100%" cellspacing="0" cellpadding="0" class="formpadding">
						 <tr><td align="center" class="labelit">
					     <cf_tl id="Cleared">:<font color="008080">#DateFormat(Clear.Created, CLIENT.DateFormatShow)#
						 </td>
						 <td>
						
						 <input type="checkbox" 
						   name="LockEdition" 
						   class  = "radiol"
						   onclick="ptoken.navigate('#SESSION.root#/ProgramREM/Application/Budget/Allotment/AllotmentLock.cfm?ProgramCode=#url.programcode#&period=#url.period#&editionid=#url.editionid#&lock='+this.checked,'lock#url.editionid#')"
						   value="1" <cfif check.LockEntry eq "1">checked</cfif>>						 						 
						 </td>
						 <td style="padding-left:4px"><cf_tl id="Lock"></td>
						 <td class="hide" id="lock#url.editionid#"></td>
						 </tr>
						 </table>									  
					  
					  </cfoutput>
				
				</cfif>
					   
			<cfelse> <!--- = transactional --->
			
			    <cfif Check.Status eq "0" and Parameter.EnableDonor eq "0"> <!--- handle as snapshot as it is the first submission but only if the donor option is turned off --->
															
					<!--- Hanno disabled 16/7/2018 , as it SHOULD go through the review part of the workflow to be openened as status = 1 and then
					picked up by the allotment process screen we have  
					
					<cfoutput>	
					
					<table cellspacing="0" cellpadding="0"><tr><td>
					<cf_tl id="Clear">
					</td>
					<td style="padding-left:2px">				
					
						<input type = "checkbox" 
							name    = "Clear" 
							class   = "radiol"
							value   = "#Editionid#" 
							onclick = "ptoken.navigate('#SESSION.root#/ProgramREM/Application/Budget/Allotment/AllotmentClearanceSubmit.cfm?programcode=#url.programcode#&period=#url.period#&editionid=#url.editionid#','box#url.editionid#')">
							
					</td>
					</tr>
					</table>	
						
					</cfoutput>
					
					--->
									
				<cfelse> 				
								
					<!--- status = 1 has been cleared before, but MAY have adjustments  --->
				
					<cfquery name="Details" 
					     datasource="AppsProgram" 
					     username="#SESSION.login#" 
					     password="#SESSION.dbpw#">
					     SELECT     MIN(Status) as Status
					     FROM       ProgramAllotmentDetail A
					     WHERE      A.EditionId   = '#URL.EditionId#'
						 AND        A.ProgramCode = '#URL.ProgramCode#'
						 AND        A.Period      = '#URL.Period#'
						 AND        A.Amount <> 0
						 AND        A.TransactionType = 'Standard'
						 AND        A.Status      IN ('0','1')
					 </cfquery>
					 					 														
				     <cfif Details.Status eq "1">
					 
						 <cfquery name="Clear" 
					     datasource="AppsProgram" 
					     username="#SESSION.login#" 
					     password="#SESSION.dbpw#">
						     SELECT     A.Created
						     FROM       ProgramAllotmentAction A, ProgramAllotment P
						     WHERE      (
							            ( A.ActionClass = 'Snapshot' and ActionType = 'Approved' ) 
							             				OR
							            (  A.ActionClass = 'Transaction' and A.ActionType = 'Processed' )
										)
							 AND        P.ProgramCode = A.ProgramCode
							 AND        P.Period      = A.Period
							 AND        P.EditionId   = A.EditionId
							 AND        P.EditionId   = '#URL.EditionId#'
							 AND        P.ProgramCode = '#URL.ProgramCode#'
							 AND        P.Period      = '#URL.Period#'
							 ORDER BY A.Created DESC
						 </cfquery>
						 
					    <cfoutput>
						
						 <table width="100%" height="100%" class="formpadding">
						 
						 <tr>
						 <td align="center" class="labelit">
					     <cf_tl id="Cleared">: <font color="008080">#DateFormat(Clear.Created, CLIENT.DateFormatShow)#
						 </td>
						 <td style="padding-left:4px" align="center" class="labelit" title="Lock/unlock data entry for financial requirements by Project Officers if relevant">
						 							 
							 <input type    = "checkbox" 
							        name    = "LockEdition" 
							        class   = "radiol"							   
							        onclick = "ptoken.navigate('#SESSION.root#/ProgramREM/Application/Budget/Allotment/AllotmentLock.cfm?ProgramCode=#url.programcode#&period=#url.period#&editionid=#url.editionid#&lock='+this.checked,'lock#url.editionid#')"
							        value   = "1" <cfif check.LockEntry eq "1">checked</cfif>>							
							 
						 </td>						
						 <td style="padding-left:4px" class="labelit"><cf_tl id="lock"></td>
						 <td class="hide" id="lock#url.editionid#"></td>
						 </tr>
						 </table>
						 
						</cfoutput> 
					  
					 <cfelseif details.status gte "0">
					 
					  <cfoutput>
					 
					 	 <table width="100%" height="100%" class="formpadding">
						 <tr>
						 <td align="center">
						 
				  		  <cf_tl id="Allocate" var="1">
						  						  
						   <input type = "button" 
						       name    = "clear" 
							   class   = "button10g"
							   id      = "drill" 
							   value   = "#lt_text#" 
							   style   = "width:120px;font-size:13px" 
							   onClick = "allotdrill('#URL.ProgramCode#','#url.period#','#url.Editionid#')"> 						 
						
						 	</td>
						 </tr>
						 </table>
						
					  </cfoutput>					  
					 
					 </cfif>						
				
				</cfif>	
				 
			</cfif>
		
		<cfelse>
		
		   <table width="100%"  height="100%" cellspacing="0" cellpadding="0">
		   
		        <tr class="line labelit">
			    <cfif entries.recordcount gte "1">			
				<td align="center">		    
					<cfif check.status eq "1">
					   <cf_tl id="Cleared">
					<cfelse>
					  <cf_UItooltip tooltip="Has pending requirements">
					   <cf_tl id="Pending">
					  </cf_UItooltip>
					</cfif>			
				</td>
				<td align="center">|</td>	
				</cfif>
					
					<cfif edition.status eq "3" or edition.status eq "9">
					   <td align="center" title="Edition is CLOSED">							   
					        <cf_tl id="Closed">
					   </td>							   
					<cfelse>
					   <td align="center" title="Edition is OPEN for authorised data entry/amendments">					   
		        			<cf_tl id="Open">
				       </td>	
					</cfif>
				</td>	
				<td align="center">|</td>				   
				<cfif check.LockEntry eq "1">					  
				    <td align="center" title="This program is CLOSED for requirement definition">
				   	    <cf_tl id="Locked">					  
					</td>
				<cfelse>
				    <td align="center" title="This program is ENABLED (open) for requirement definition">					    
				         <cf_tl id="Enabled">
				    </td>  
			   </cfif>						
			   </tr>
				
			</table>
			
		</cfif>	
				
</cfif>	