<!--- Prosis template framework --->
<cfsilent>
	<proUsr>jmazariegos</proUsr>
	<proOwn>Jorge Mazariegos</proOwn>
	<proDes>Translated</proDes>
	<proCom></proCom>
</cfsilent>

<cfquery name="PO" 
	  datasource="AppsPurchase" 
	  username="#SESSION.login#" 
	  password="#SESSION.dbpw#">
	  SELECT P.* 
	  FROM   InvoicePurchase IP , Purchase P
	  WHERE  InvoiceId = '#URL.ID#'
	  AND    IP.PurchaseNo = P.PurchaseNo
</cfquery>

<cfquery name="Invoice" 
	  datasource="AppsPurchase" 
	  username="#SESSION.login#" 
	  password="#SESSION.dbpw#">
	  SELECT * 
	  FROM   Invoice
	  WHERE  InvoiceId = '#URL.ID#'	 
</cfquery>

<cfquery name="Parameter1" 
datasource="AppsPurchase" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT  *
    FROM    Ref_ParameterMission
	WHERE   Mission = '#PO.Mission#' 
</cfquery>

<cfquery name="Check" 
	  datasource="AppsPurchase" 
	  username="#SESSION.login#" 
	  password="#SESSION.dbpw#">
	  SELECT SUM(Amount) as Total 
	  FROM   InvoiceFunding
	  WHERE  InvoiceId = '#URL.ID#'
</cfquery>
 	 	
<cfinvoke component="Service.Access"  
  method="ProcApprover" 
  orgunit="#Invoice.OrgUnitOwner#"  
  returnvariable="accessreq">	

<cfoutput>

<table width="100%" border="0" cellspacing="0" class="navigation_table" cellpadding="0" style="padding:3px;border-top:0px solid silver;;border-bottom:0px solid silver">
	       
	    <TR height="17" class="labelmedium line">
		  		   
		   <td><cf_tl id="Fund"></td>
	       <td><cf_tl id="Period"></td>
		   <td><cf_tl id="Program">/<cf_tl id="Activity"></td>
		   <td width="200"><cf_tl id="Object"></td>	  		  
		   <td align="right"><cf_tl id="Amount"></td>
		   <td></td>
		   <td align="right"><cf_tl id="Percentage"></td>		 
				 
		 </TR> 		  
		 
		 
		 	<cfif Parameter1.EnforceProgramBudget eq "1">			
				
				<cfquery name="Lines" 
				datasource="AppsPurchase" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
					SELECT  F.FundingId,
					        F.Percentage,
							F.InvoiceId, 
							PF.ProgramCode, 							
							PF.ProgramName, 
							F.Fund, 
							F.ActivityId,
							F.ProgramPeriod, 
							F.ObjectCode, 
							O.Description, 
							F.Amount
					FROM    InvoiceFunding F INNER JOIN 
			                Program.dbo.Program PF ON F.ProgramCode = PF.ProgramCode INNER JOIN
		    	            Program.dbo.Ref_Object O ON F.ObjectCode = O.Code
					WHERE   F.InvoiceId = '#URL.ID#' 
					ORDER BY F.ProgramCode, F.ActivityId
				</cfquery> 
				
				<cfif Lines.recordcount eq "0">
				
					<cfquery name="Lines" 
					datasource="AppsPurchase" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
					SELECT  F.FundingId,
					        F.Percentage,
							F.InvoiceId, 
							'' as Reference, 
							'' as ProgramCode, 
							'Default' as ProgramName,
							F.ProgramPeriod, 
							F.Fund, 
							F.ActivityId,
							F.ObjectCode, 
							O.Description, 
							F.Amount
					FROM    InvoiceFunding F INNER JOIN 
			                Program.dbo.Ref_Object O ON F.ObjectCode = O.Code
					WHERE   F.InvoiceId = '#URL.ID#' 
					ORDER BY F.ProgramCode
					</cfquery> 
							
				</cfif>
			
			<cfelse>
			
				<cfquery name="Lines" 
				datasource="AppsPurchase" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				SELECT  F.FundingId, 
				        F.Percentage,
						F.InvoiceId, 
						'' as Reference, 
						ProgramCode, 
						'Default' as ProgramName, 
						F.ProgramPeriod,
						F.Fund, 
						F.ActivityId,
						F.ObjectCode, 
						O.Description, 
						F.Amount
				FROM    InvoiceFunding F INNER JOIN 
		                Program.dbo.Ref_Object O ON F.ObjectCode = O.Code
				WHERE   F.InvoiceId = '#URL.ID#' 
				ORDER BY F.ProgramCode
				</cfquery> 
			
			</cfif> 
							
			<cfif Lines.recordcount eq "0">
	
				 <tr><td class="labelmedium" height="30" colspan="8" align="center"><font color="FF0000">Alert, Invoice is not funded.  Please contact your administrator</td></tr>  
	 
			<cfelse>		
			
			<cfloop query="Lines">
			
				 <cfquery name="Period" 
					datasource="AppsProgram" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
					    SELECT * 
						FROM  ProgramPeriod
						WHERE ProgramCode = '#ProgramCode#'
						AND   Period = (SELECT PlanningPeriod 
						                FROM   Organization.dbo.Ref_MissionPeriod 
										WHERE  Mission = '#PO.Mission#' 
										AND    Period = '#ProgramPeriod#')					
			     </cfquery>
			   
			     <cfif ActivityId neq "">
		   
				   <cfquery name="Activity" 
						datasource="AppsProgram" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">
						    SELECT * 
							FROM  ProgramActivity
							WHERE ActivityId = '#ActivityId#'							
				   </cfquery>
				   
				   <cfset act = Activity.ActivityDescriptionShort>
			   
			     <cfelse>
		   
			   		<cfset act = "">
					   
			     </cfif>
									
				 <tr class="line labelmedium navigation_row">
									
					<td style="height:20px">#Fund#</td>
					<td>#ProgramPeriod#</td>
															
					<cfif act eq "">
					<td class="labelit"><cfif Period.recordcount eq "1"><a href="javascript:EditProgram('#ProgramCode#','#PO.Period#','project')"><font color="0080C0"><cfif Period.Reference neq "">#Period.Reference#&nbsp;</cfif>#ProgramName#</a><cfelse>n/a</cfif></td>					
				    <cfelse>
					<td>
					<table cellspacing="0" cellpadding="0">
					  <tr class="labelit" style="height:15px">
					  <td style="height:15px"><cfif Period.recordcount eq "1"><a href="javascript:EditProgram('#ProgramCode#','#PO.Period#','project')"><font color="0080C0"><cfif Period.Reference neq "">#Period.Reference#&nbsp;</cfif>#ProgramName#</a><cfelse>n/a</cfif></td>										 		  
					  <td style="height:15px" colspan="1">/#act#</td>
					  </tr>				  
				    </table>
					</td>				
				    </cfif>										
										
					<td>#ObjectCode# #Description#</td>					
					<td align="right" id="c#fundingid#">#NumberFormat(Amount,",__.__")#</td>
					
					<td width="20" style="padding-left:3px">	
										
					<cfif Invoice.ActionStatus eq "0" and AccessReq eq "ALL" and Lines.recordcount gte "2">
					
						<cf_img icon="edit" onclick="ptoken.navigate('setInvoiceMatchFunding.cfm?invoiceid=#invoiceid#&fundingid=#fundingid#','c#fundingid#')">
										   
					</cfif>   
						
					</td>
					
					<td align="right">
					
						<cfif percentage neq "0">					
						
						#NumberFormat(Percentage*100,"._")#%		
									
						<cfelse>																						
						
						<cfif check.total eq "0">
						
						<!--- no lines selected --->
						
						<cfelse>
						
						#NumberFormat(Amount*100/Check.Total,".__")#%
																	
						<cfquery name="Set" 
							  datasource="AppsPurchase" 
							  username="#SESSION.login#" 
							  password="#SESSION.dbpw#">
							  UPDATE InvoiceFunding
							  SET    Percentage = '#Amount/Check.Total#'
							  WHERE  InvoiceId = '#URL.ID#'
							  AND    FundingId = '#fundingid#'
						</cfquery>		
						
						</cfif>								
					
						</cfif>
					
					</td>
					
													
	           	</tr>
				
											
			</cfloop>		
	
	</cfif>		
			
</table>

</cfoutput>	