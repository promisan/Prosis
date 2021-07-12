

<cfparam name="url.balancestatus"   default="0">
<cfparam name="url.effective"       default="">
<cfparam name="url.expiration"      default="">
<cfparam name="url.effectivefull"   default="">
<cfparam name="url.expirationfull"  default="">
<cfparam name="url.leavetype"       default="">
<cfparam name="url.leavetypeclass"  default="">
<cfparam name="url.grouplistcode"   default="">
<cfparam name="url.leaveid"         default="">


<cfset dateValue = "">
<CF_DateConvert Value="#url.Effective#">
<cfset STR = dateValue>

<CF_DateConvert Value="#url.Expiration#">
<cfset END = dateValue>

<!--- the month that determines the balance to be compared with is driven by the month
in which the leave ends --->

<cfset PRI = dateAdd("M",0,END)>

<cfquery name="Threshold" 
    datasource="AppsEmployee" 
    username="#SESSION.login#" 
    password="#SESSION.dbpw#">
    SELECT   *
    FROM     Ref_LeaveTypeThreshold
    WHERE    leaveType      = '#URL.LeaveType#'
	AND      LeaveTypeClass = '#URL.leaveTypeClass#'	
</cfquery>

<cfif Threshold.recordcount gte "1">
		
	<cfquery name="LastBalance" 
	    datasource="AppsEmployee" 
	    username="#SESSION.login#" 
	    password="#SESSION.dbpw#">
	    SELECT   *
	    FROM     PersonLeaveBalance 
	    WHERE    PersonNo       = '#URL.ID#'
		AND      BalanceStatus  = '#url.balancestatus#'
		AND      leaveType      = '#URL.LeaveType#'
		AND      LeaveTypeClass = '#URL.leaveTypeClass#'
		AND      DateEffective >= #PRI#   
		ORDER BY DateEffective DESC
	</cfquery>

<cfelse>
	
	<cfquery name="LastBalance" 
	    datasource="AppsEmployee" 
	    username="#SESSION.login#" 
	    password="#SESSION.dbpw#">
	    SELECT   *
	    FROM     PersonLeaveBalance 
	    WHERE    PersonNo       = '#URL.ID#'
		AND      BalanceStatus  = '#url.balancestatus#'
		AND      leaveType      = '#URL.LeaveType#'
		AND      LeaveTypeClass is NULL
		AND      DateEffective >= #PRI#   
		ORDER BY DateEffective DESC
	</cfquery>

</cfif>
   
<cfquery name="Type" 
   datasource="AppsEmployee" 
   username="#SESSION.login#" 
   password="#SESSION.dbpw#">
	   SELECT *
	   FROM   Ref_LeaveType R
	   WHERE  LeaveType       = '#URL.LeaveType#'  
</cfquery> 

<cfif url.effectivefull eq "1">
    <cfset efffull = "1">
<cfelseif url.effectivefull eq "0">
    <cfset efffull = "0">
<cfelseif url.effectivefull eq "TRUE">
	<cfset efffull = "1">
<cfelse>
	<cfset efffull = "0">	
</cfif>

<cfif url.expirationfull eq "1">
    <cfset expfull = "1">
<cfelseif url.expirationfull eq "0">
    <cfset expfull = "0">
<cfelseif url.expirationfull eq "TRUE">
	<cfset expfull = "1">
<cfelse>
	<cfset expfull = "0">	
</cfif>

<table width="100%" cellspacing="0" cellpadding="0">
 
<tr class="labelmedium" style="height:18px;border-bottom:1px solid black">
<td colspan="3" align="right" style="padding-left:6px;height:18px;font-size:10px;"><cfoutput>#Type.Description# #url.leavetypeclass#</cfoutput><cf_tl id="agent"></td></tr> 			
  
<cfif Type.LeaveAccrual eq "0">

	 <cf_BalanceDays personno  = "#url.id#" 
	    LeaveType         = "#url.LeaveType#" 
		leavetypeclass    = "#url.Leavetypeclass#" 
		start             = "#STR#" 
		startfull         = "#efffull#" 
		end               = "#END#" 
		endfull           = "#expfull#">	
	
	<cfoutput>	
	
	  <cfif END lt STR>
		 		     	
				 <tr bgcolor="FFFF00" class="labelmedium line"><td colspan="3" align="center" style="height:30">
				 <cf_tl id="Enter consecutive dates"></td></tr>	 				 
				 
	  <cfelse>			  		
	  <tr class="labelmedium line"><td height="16"  colspan="3" width="240" align="center"><cf_tl id="Calendar days">:<b>&nbsp;#numd#</b>&nbsp;&nbsp;|&nbsp;<cf_tl id="Workdays">:<b>&nbsp;#days#</b></td></tr>	
	  	  
	  <cfif url.grouplistcode eq "" or url.grouplistcode eq "1"> <!--- apply maximum only for default, not for special reasons --->
	
		  <tr class="labelmedium line">
		  <td height="16" colspan="3" width="240" align="center">
		  	  
	      <cfif dmin neq "0" and dmin neq "">
		  
			  <cfset min = "1">
			  <cfif dminmode eq "0">
			  	<cfif dmin gt numd>
			  		<cfset min = "9">
				</cfif>
			  <cfelse>		 
			  	<cfif dmin lt days>
					<cfset min = "9">
				</cfif>
			  </cfif>
			  
			  <tr class="labelmedium line">
			  <td height="16" colspan="3" width="240" align="center" style="padding-left:10px" bgcolor="<cfif min eq "9">red</cfif>">			  
			   <cf_tl id="Minimum">:&nbsp;<cfif min eq "9"></cfif>#dmin#<cfif dminmode eq "1"><cf_tl id="days"><cfelse><cf_tl id="days">(<cf_tl id="Calendar">)</cfif>			   
			  </td>			  
			  </tr> 
			  
		  </cfif>
		  
		  <cfif dmax neq "0" and dmax neq "">
		  
			  <cfset max = "1">
			  <cfif dmaxmode eq "0">
			  	<cfif dmax lt numd>
			  		<cfset max = "9">
				</cfif>
			  <cfelse>		 
			  	<cfif dmax lt days>
					<cfset max = "9">
				</cfif>
			  </cfif>
			  
			  <tr class="labelmedium line">
			 
			  <td height="16" colspan="3" width="240" align="center" style="padding-left:10px" bgcolor="<cfif max eq "9">red</cfif>">
			  <cf_tl id="Maximum">:&nbsp;<cfif max eq "9"></cfif>#dmax#<cfif dmaxmode eq "1"><cf_tl id="days"><cfelse><cf_tl id="days">(<cf_tl id="Calendar">)</cfif>
			  </td>
			  </tr>
			  
		  </cfif>	  
		  
	 </cfif>	  
		
	 <tr class="labelmedium line"><td height="16"  colspan="3" width="240" align="center"><font color="808000"><cf_tl id="Balances are not applicable"></td></tr>				
	 	 	 
	 </cfif>
	 
	 </cfoutput>
	   
<cfelse>
		
		<cfquery name="Accrual" 
		   datasource="AppsEmployee" 
		   username="#SESSION.login#" 
		   password="#SESSION.dbpw#">
		    SELECT   TOP 1 *
			FROM     Ref_LeaveTypeCredit
			WHERE    LeaveType       = '#url.LeaveType#'
			AND      ContractType    = '#LastBalance.ContractType#'
			AND      DateEffective   <= #end#  		
			ORDER BY DateEffective DESC
		</cfquery>
			  
		 <!--- added 2/12/2012 --->
			  
		<cfif Accrual.recordcount gte "1">	  
			  <cfset AllowedOverdrawInMonth  = Accrual.AdvanceInCredit>			  
		<cfelse>	       
			  <cfset AllowedOverdrawInMonth  = "0">  <!--- was 4 --->			  
		</cfif>		
					
						
		<!--- now check if we have leave balance records until this date
		if not we are going to calculate those on the fly if not
		we work with what we have, which usually should be 
		fine --->
		
				
		<cfquery name="orgunit" 
		datasource="AppsEmployee" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		    SELECT 	O.OrgUnit, O.OrgUnitName, O.Mission
		   	FROM 	PersonAssignment P INNER JOIN Organization.dbo.Organization O ON P.OrgUnit         = O.OrgUnit
			WHERE	P.DateEffective   <= #STR# 
			AND     P.DateExpiration  >= #STR#
			AND     P.AssignmentStatus < '8' <!--- planned and approved --->
		    AND     P.AssignmentType  = 'Actual'		   
			AND     P.PersonNo        = '#url.id#' 
			AND     P.Incumbency > 0
		</cfquery>
		
		<cfquery name="contract" 
			datasource="AppsEmployee" 
			username="#SESSION.login#" 
		    password="#SESSION.dbpw#">
			   	SELECT 	 *
			    FROM 	 PersonContract 
			   	WHERE    PersonNo      = '#url.id#'
				<!--- remove as this will not show future contracts which are needed 
				AND      DateEffective <= #END# 
				--->				
				AND      ActionStatus != '9'
				AND      (DateExpiration >= #END# or DateExpiration is NULL)					
			    AND      Mission       = '#orgunit.mission#'	
				ORDER BY DateEffective DESC   
		</cfquery>		
		
				
		<cfset overdrawdate = dateadd("m",AllowedOverdrawInMonth,END)>
		
		<cfif contract.dateexpiration lt overdrawdate>
			<cfset CEND = contract.dateexpiration>						
		<cfelse>
			<cfset CEND = dateformat(overdrawdate,client.dateSQL)>	
		</cfif>			
			
		<cfif END lt STR>
			<cfoutput>			     	
				 <tr bgcolor="FFFF00" class="labelmedium line"><td colspan="3" align="center" style="height:30">
				 <cf_tl id="Enter consequitive dates"></td></tr>	 				 
			</cfoutput>
		
		<cfelse>
		
			<cfif contract.recordcount eq "0">
			
				<cfoutput>			     	
					 <tr bgcolor="FFFF00" class="labelmedium line"><td height="180" colspan="3" align="center" style="height:200">
					 <cf_tl id="Your request exceeds your issued contract."></td></tr>	 				 
				</cfoutput>
				
			<cfelseif CEND eq "">
			
				<cfoutput>			     	
					 <tr bgcolor="FFFF00" class="labelmedium line"><td height="180" colspan="3" align="center" style="height:200">
					 <cf_tl id="Record the dates of your leave"></td></tr>	 				 
				</cfoutput>
				
			<cfelse>
																								
				<!--- provision to always recalculate the balances, 
				     comment : it might be a bit heavy  --->
																
				<cfinvoke component  = "Service.Process.Employee.Attendance"  
					   method        = "LeaveBalance" 
					   PersonNo      = "#url.id#" 
					   Mission       = "#orgunit.Mission#"
					   LeaveType     = "#url.LeaveType#"
					   Leaveid       = "#url.leaveid#"
					   BalanceStatus = "#url.balancestatus#"
					   StartDate     = "#STR#"
					   EndDate       = "#CEND#">	

																
				<!--- now check if we have leave balance records until this date
				if not we are going to calculate those on the fly if not
				we work with what we have, which usually should be 
				fine --->		
				
				<!-- we generate balance to this next period --->
				
				<cfquery name="checkThreshold" 
				   datasource="AppsEmployee" 
				   username="#SESSION.login#" 
				   password="#SESSION.dbpw#">	  
					   SELECT     *
					   FROM       Ref_LeaveTypeThreshold
					   WHERE      LeaveType      = '#URL.LeaveType#'
					   AND        LeaveTypeClass = '#URL.LeaveTypeClass#'		  
				</cfquery> 	
				
				<cfif checkThreshold.recordcount eq "1">	
																				
					<cfset thresholddate = createDate(year(end), checkThreshold.ThresholdMonth, 1)>
					<cfif end gt thresholddate>
					  <cfset thresholddate = createDate(year(end)+1, checkThreshold.ThresholdMonth, 1)>
					</cfif>
										
					<cfquery name="Balance" 
					   datasource="AppsEmployee" 
					   username="#SESSION.login#" 
					   password="#SESSION.dbpw#">	  
						   SELECT     TOP 1 *, 0 as NetTakenFuture
						   FROM       PersonLeaveBalance WITH(NOLOCK)
						   WHERE      PersonNo       = '#URL.ID#'
						   AND        BalanceStatus  = '#url.balancestatus#'
						   AND        LeaveType      = '#URL.LeaveType#'
						   AND        LeaveTypeClass = '#URL.LeaveTypeClass#'
						   AND        DateExpiration >= #END#	  <!--- this will take the correct balance record to be used for comparison --->
						   AND        DateExpiration < #ThresholdDate# 		
						   ORDER BY   DateEffective DESC							   	   
					</cfquery> 					
				
				<cfelse>				
													
					<cfquery name="Balance" 
				   datasource="AppsEmployee" 
				   username="#SESSION.login#" 
				   password="#SESSION.dbpw#">
					   SELECT   PersonNo, LeaveType, DateEffective, DateExpiration, ContractType, Credit, Taken, Balance, 
					    
						            (SELECT ISNULL(SUM(Credit-Taken),0)
									 FROM   PersonLeaveBalance WITH(NOLOCK)
									 WHERE  PersonNo       = '#URL.ID#'
									 AND    BalanceStatus  = '#url.balancestatus#'
						             AND    LeaveType      = '#URL.LeaveType#'
        						     AND    LeaveTypeClass is NULL									 
									 AND    DateExpiration > B.DateExpiration) as NetTakenFuture
									
									 
					   FROM     PersonLeaveBalance B WITH(NOLOCK)
					   WHERE    PersonNo        = '#URL.ID#'
					   AND      BalanceStatus   = '#url.balancestatus#'
					   AND      leaveType       = '#URL.LeaveType#'
					   AND      LeaveTypeClass  = '#URL.Leavetypeclass#'
					   AND      DateExpiration >= #END#	  <!--- this will take the correct start balance period --->
					   AND      DateEffective  <= '#CEND#' 		
					   ORDER BY DateEffective
					</cfquery> 
					
				</cfif>				
																				
				<cfif Balance.recordcount eq "0">	
																		
					<!--- we move to the parent --->
														  	 
					<cfquery name="Balance" 
					   datasource="AppsEmployee" 
					   username="#SESSION.login#" 
					   password="#SESSION.dbpw#">
						   SELECT   PersonNo, LeaveType, DateEffective, DateExpiration, ContractType, Credit, Taken, Balance, 
						             (SELECT ISNULL(SUM(Credit-Taken),0)
									 FROM   PersonLeaveBalance WITH(NOLOCK)
									 WHERE  PersonNo       = '#URL.ID#'
									 AND    BalanceStatus  = '#url.balancestatus#'
						             AND    LeaveType      = '#URL.LeaveType#'
        						     AND    LeaveTypeClass is NULL									 
									 AND    DateExpiration > B.DateExpiration) as NetTakenFuture
									
									 
						   FROM     PersonLeaveBalance B WITH(NOLOCK)
						   WHERE    PersonNo       = '#URL.ID#'
						   AND      BalanceStatus  = '#url.balancestatus#'
						   AND      leaveType      = '#URL.LeaveType#'
						   AND      LeaveTypeClass is NULL
						   AND      DateExpiration >= #END#	  <!--- this will take the correct start balance period --->
						   AND      DateEffective <= '#CEND#' 		
						   ORDER BY DateEffective
						  
					</cfquery> 			
					
																		
				</cfif>		
									    	 	
				<cfoutput>
				
			     	<cfif Balance.recordcount eq "0">
						 <tr class="labelmedium line"><td colspan="3" align="center"><cf_tl id="No balances found"></td></tr>	 
					 </cfif>
					 
				</cfoutput>				 
								
				<!--- ------------------------------------------- ---> 
				<!--- get the days this leave will count as TAKEN --->
				<!--- ------------------------------------------- --->
								
				<cf_BalanceDays personno  = "#url.id#" 
					    LeaveType         = "#url.LeaveType#" 
						leavetypeclass    = "#url.Leavetypeclass#" 
						start             = "#STR#" 
						startfull         = "#efffull#" 
						end               = "#END#" 
						endfull           = "#expfull#">		
				
				 <cfoutput> 		
				 <tr class="labelmedium line" style="background-color:d3d3d3"><td height="16" colspan="3" width="240" align="center"><cf_tl id="Days"><cf_tl id="Calendar">:<b>&nbsp;&nbsp;#numd#</b>&nbsp;&nbsp;|&nbsp;-<cf_tl id="Work">:<b>&nbsp;&nbsp;#days#</b></td></tr>	
				 </cfoutput>
				
				<cfset required = days>				
				<cfset takennew = 0>								
											
				<cfoutput query = "Balance">	
				
					<cfif nettakenfuture lt 0>				
						<cfset balancecorrected = balance - takennew + nettakenfuture>										
					<cfelse>					
						<cfset balancecorrected = balance - takennew>							
					</cfif>
					
																							 
				    <cfif DateEffective gt END>
						<cfset color = "red">
					<cfelse>
						<cfset color = "black">	
					</cfif>
										
					<cfif balancecorrected lte 0>
						<cfset source = "0">
					<cfelseif balancecorrected gte required>
						<cfset source = required>
					<cfelse>
						<cfset source = balancecorrected>
					</cfif>
					
					<cfif required gt "0">							 
										
					     <tr bgcolor="yellow" class="labelmedium line" style="height:18px">
						    <td style="height:22px;padding-left:10px">
							
								<!--- <cfif currentrow eq "1"><cf_tl id="Balance"></cfif> --->
							</td>
							<td><font color="#color#">#DateFormat(DateExpiration, CLIENT.DateFormatShow)#:</font></td>								
							<td align="right" style="padding-left:3px;padding-right:14px">
							<cfif balancecorrected lt 0><font color="red"></cfif>#numberFormat(source,".__")#
							
							</td>
						 </tr>
						 
					 </cfif>	 
							
					 <cfif source gt "0">
						<cfset required = required - source>
						<cfset takennew = takennew + source>
					</cfif>							
					 
				</cfoutput>		
					
				<cfif url.effective neq "" and url.expiration neq "">
						 
					 <cfif required gt 0>
					  
					    <tr bgcolor="FF0000" style="height:25px;" class="line labelmedium">		 
						 <td style="padding-left:10px" colspan="2"><font color="white"><cf_tl id="Not allowed">:</td>
						 <td align="right" style="padding-left:3px;padding-right:10px" ><font color="white"> <cfoutput>#numberformat(days,"._")#</cfoutput></td>
					    </tr>	
						
					    <cfif Type.LeaveBalanceEnforce eq "0"> 
						
					     <tr class="line labelmedium" style="background-color:D0FDC4;height:25px;">		 
						   <td colspan="3" style="padding-left:10px" align="center"><cf_tl id="Request granted as balances are not enforced"></td>					 				
					     </tr>	
						 
					    </cfif>
						
					 <cfelse>
					 
					    <tr bgcolor="80E382" class="line labelmedium" style="height:22px;">		 
						 <td align="center" style="padding-left:10px" colspan="3"><cf_tl id="Sufficient"></td>
						</tr>	 
					 
					 </cfif>  
				 
				</cfif>
				
				<cfif url.leaveType eq "Annual">
				
					<cfquery name="CTO" 
						   datasource="AppsEmployee" 
						   username="#SESSION.login#" 
						   password="#SESSION.dbpw#">
				
							SELECT     TOP (1) Balance
							FROM       PersonLeaveBalance
							WHERE      LeaveType = 'CTO' 
							AND        PersonNo = '#url.id#'
							ORDER BY   DateEffective DESC
							
					</cfquery>		
					
					<cfif CTO.Balance gte "7.5">
					
					 <cfoutput>
					 <tr bgcolor="red" class="line labelmedium" style="height:22px;">		 
						 <td align="center" style="padding-left:10px" colspan="3">
						 <font color="FFFFFF">
						 <cf_tl id="Attention, you have #CTO.Balance# hours of unused CTO. Please submit a request to consume your CTO first.">
						 </font>
						 </td>
					 </tr>	
					 </cfoutput> 
										
					</cfif>			
				
				</cfif>
				
				<cfif url.grouplistcode eq "" or url.grouplistcode eq "1"> <!--- apply maximum only for default, not for special reasons --->
				 
				  <cfoutput>
										  	  
			      <cfif dmin neq "0" and dmin neq "">
				  
					 <cfset min = "1">
					 <cfif dminmode eq "0">
					  	<cfif dmin gt numd>
					  		<cfset min = "9">
						</cfif>
					 <cfelse>		 
					  	<cfif dmin lt days>
							<cfset min = "9">
						</cfif>
					 </cfif>
					  
					 <tr class="labelmedium line">
					 <td height="16" colspan="3" width="240" align="center" style="padding-left:10px;color:<cfif max eq "9">white</cfif>" bgcolor="<cfif min eq "9">red</cfif>">					  
					  <cf_tl id="Minimum">:&nbsp;#dmin#<cfif dminmode eq "1"><cf_tl id="days"><cfelse><cf_tl id="days">(<cf_tl id="Calendar">)</cfif>
					 </td>
					 </tr>	   
					  
				  </cfif>
				  		  
				  <!--- for balances maximum is not so relevant ---> 		  
				  
				  <cfif dmax neq "0" and dmax neq "">
				  
					  <cfset max = "1">
					  <cfif dmaxmode eq "0">
					  	<cfif dmax lt numd>
					  		<cfset max = "9">
						</cfif>
					  <cfelse>		 
					  	<cfif dmax lt days>
							<cfset max = "9">
						</cfif>
					  </cfif>
					  
					  <tr class="labelmedium line">
						  <td height="16" colspan="3" width="240" align="center" style="padding-left:10px;color:<cfif max eq "9">white</cfif>" bgcolor="<cfif max eq "9">red</cfif>">		
						  <cf_tl id="Maximum">:&nbsp;#dmax#<cfif dmaxmode eq "1"><cf_tl id="days"><cfelse><cf_tl id="days">(<cf_tl id="Calendar">)</cfif>
						  </td>
					  </tr>
					  
				  </cfif>	
							   
				  </td>
				  
				</tr>   
			 	
				</cfoutput>
				
				</cfif>
							
			</cfif>	
		
		</cfif>
		 		  					 
	 </table>
	 
</cfif>	 

</table>

<!--- we also will check if the leavetype is workflow enabled, if not we hide some portions --->

<script language="JavaScript">
		
	  se = document.getElementsByName("backup")

	  cnt = 0
	  while (se[cnt]) {
	   
	    <cfif Type.HandoverActionCode neq "">  
		  	se[cnt].className = "regular"
		<cfelse>
		    se[cnt].className = "hide"	
		</cfif>
		cnt++
		  
	  }
		 
</script>

<cfif Type.ReviewerActionCodeOne eq "">

	<script language="JavaScript">
	  try {
		document.getElementById('reviewer').className = "hide" } catch(e) {}
	</script>

<cfelse>

	<script language="JavaScript">
	  try {
	    document.getElementById('reviewer').className = "regular" } catch(e) {}
	</script>

</cfif>
	