
<!--- Query returning search results --->

<cfparam name="URL.ID2"           default="0">
<cfparam name="URL.LeaveType"     default="">
<cfparam name="URL.class"         default="">
<cfparam name="URL.webapp"        default="">
<cfparam name="URL.balancestatus" default="0">
<cfparam name="URL.mission"       default="">

<cfquery name="Contract" 
	datasource="AppsEmployee" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT   TOP 1 L.*, 
			     R.Description as ContractDescription, 
			     A.Description as AppointmentDescription
	    FROM     PersonContract L, 
		         Ref_ContractType R,
			     Ref_AppointmentStatus A
		WHERE    L.PersonNo      = '#URL.ID#'
		AND      L.ContractType = R.ContractType		
		AND      L.AppointmentStatus = A.Code
		AND      L.ActionStatus IN ('0','1')
		ORDER BY L.DateEffective DESC 
</cfquery>

<cfquery name="getPerson" 
	datasource="AppsEmployee" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT   *
	    FROM     Person
		WHERE    PersonNo = '#URL.ID#'
</cfquery>
	
		<table width="98%" align="center" border="0" cellspacing="0" cellpadding="0" class="formpadding navigation_table">
								
		  <cfif url.webapp eq "">
		  		
		  <tr class="line">
						
			<cfquery name="Initial" 
			datasource="AppsEmployee" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
					SELECT   TOP 2 *
				    FROM     PersonContract L, 
					         Ref_Action A
					WHERE    L.PersonNo      = '#URL.ID#'
					AND      L.ActionCode = A.ActionCode				
					AND      L.ActionStatus IN ('0','1')
					AND      A.ActionInitial = '1'
					ORDER BY L.DateEffective DESC 
			</cfquery>
				
			<cfif initial.recordcount gt "1">
			
				<td style="width:170px">	
				<table>
				<tr class="labelmedium">
				<td><cf_tl id="EOD">:</td>
				<cfset cnt = url.balancestatus+1>				
				<cfset last = "">		
					
				<cfoutput query="initial">
												
					<cfquery name="Last" 
					datasource="AppsEmployee" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
							SELECT   *
						    FROM     PersonContract L
							WHERE    L.PersonNo      = '#URL.ID#'
							AND      L.Mission       = '#Mission#'									
							AND      L.ActionStatus IN ('0','1')
							<cfif last neq "">
							AND      L.DateExpiration <= '#last#'							
							</cfif>
							ORDER BY L.DateEffective DESC 
					</cfquery>
				
					<cfif cnt eq currentrow>
					<td style="padding-left:3px;font-size:20px;padding-right:10px">
						<u>#dateformat(DateEffective,client.dateformatshow)#</u>
					</td>								
					<cfelse>
					<td style="min-width:200px;padding-left:13px;font-size:15px;padding-right:5px">
					  <a href="javascript:ptoken.navigate('LeaveBalances.cfm?id=#url.id#&balancestatus=#currentrow-1#','contentbox2')">#dateformat(DateEffective,client.dateformatshow)# - #dateformat(Last.DateExpiration,client.dateformatshow)#</a>
					</td>
					</cfif>
					
					<cfset last = dateEffective>
				</cfoutput>
				</tr>
				</table>
				</td>
			</cfif>
					  
		 	<td style="height:30;padding-left:7px" align="left" colspan="1"  class="labellarge">				
			
			<cfoutput>
					   
			    <cfinvoke component="Service.Access"  method="employee"  personno="#URL.ID#" returnvariable="access">
						   
			    <cfif access eq "EDIT" or access eq "ALL">
			    	<input type="button" style="width:140px;height:34;font-size:15px" value="Calculate All" class="button10g" onClick="calculate('','1','','#url.balancestatus#')">
				</cfif>
				<cfif access eq "EDIT" or access eq "ALL" and contract.recordcount gte "1">
			    	<input type="button" style="width:140px;height:34;font-size:15px" value="Initialize" class="button10g" onClick="init('#URL.ID#')">
				</cfif>
			
			</cfoutput>						
			
			</td>
			<cfif URL.ID2 eq "1" and contract.recordcount gte "1">
			<td class="labelit" style="padding-right:4px" align="right"><cf_tl id="Refreshed"> <font color="808080"><cfoutput>#timeformat(now(),"HH:MM")#</cfoutput></td>
			</cfif>
			
			<td align="right" style="padding-right:15px;">
			
				<cfoutput>
				
					<cf_tl id="Leave Balances" var="1">
					<span id="printTitle" style="display:none;">#ucase('#lt_text#: [#getPerson.IndexNo#] #getPerson.Fullname#')#</span>
					<cf_tl id="Print" var="1">
					
					<cf_button2 
						mode		= "icon"
						type		= "Print"
						title       = "#lt_text#" 
						id          = "Print"					
						height		= "20px"
						width		= "25px"
						imageHeight = "25px"
						printTitle	= "##printTitle"
						printContent = ".clsPrintBalance, .clsPrintContentFooter">
						
				</cfoutput>
				
			</td>
		
		   </tr>
		   
		 <cfelse>   
		 
		  <tr class="line">
		  
		 	<td style="height:30;padding-left:7px" align="left" colspan="1"  class="labellarge">
				<cfoutput><cf_tl id="Leave Balances">: #getPerson.IndexNo# #getPerson.Firstname# #getPerson.LastName#</cfoutput>				
			</td>
			
			<cfif URL.ID2 eq "1" and contract.recordcount gte "1">
				<td class="labelit" style="padding-right:4px" align="right">
					<cf_tl id="Refreshed"> <font color="808080"><cfoutput>#timeformat(now(),"HH:MM")#</cfoutput>
				</td>
			</cfif>
			
			<td align="right" style="padding-right:15px;">
			
				<cfoutput>
				
					<span id="printTitle" style="display:none;"><cf_tl id="Leave Balances">: #getPerson.IndexNo# #getPerson.Fullname#</span>
					
					<cf_tl id="Print" var="1">
					
					<cf_button2 
						mode		= "icon"
						type		= "Print"
						title       = "#lt_text#" 
						id          = "Print"					
						height		= "20px"
						width		= "25px"
						imageHeight = "25px"
						printTitle	= "##printTitle"
						printContent = ".clsPrintBalance">
						
				</cfoutput>
				
			</td>
		
		   </tr>
		  		  
		 </cfif> 
		  
		  <tr><td height="3"></td></tr>		   
		  <tr>
		  <td width="100%" colspan="3" class="clsPrintBalance">
		  <table border="0" cellpadding="0" cellspacing="0" width="99%" align="center" class="formpadding">
		  		  				
			<tr class="line labelmedium">			
			<td height="18"></td>
			<td><cf_tl id="Class"></td>
			<td><cf_tl id="Contract"></td>
			<td><cf_tl id="Last updated"></td>
			<td style="min-width:90px"><cf_tl id="Balance date"></td>
			<td style="min-width:70px" align="right"><cf_tl id="Last Accrual"></td>
			<td style="min-width:90px" align="right"><cf_tl id="Balance"></td>
			</tr>			
					
		<cfquery name="getLeaveType" 
			datasource="AppsEmployee" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				SELECT    R.*, 
				          C.Description as Parent, C.ListingOrder as ParentOrder
				FROM      Ref_LeaveType R, Ref_TimeClass C 
				WHERE     R.LeaveParent = C.TimeClass
				AND       LeaveAccrual IN ('1','2','3','4')
				
				<!--- show only relevant balances for the contract --->
				AND       LeaveType IN (SELECT LeaveType
				                        FROM   Ref_LeaveTypeClassAppointment
										WHERE  AppointmentStatus = '#contract.AppointmentStatus#')
				
				ORDER BY  C.ListingOrder, R.ListingOrder 
		</cfquery>	
		
		<cfif getLeaveType.recordcount eq "0">
		
			<cfquery name="getLeaveType" 
				datasource="AppsEmployee" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
					SELECT    R.*, 
					          C.Description as Parent, C.ListingOrder as ParentOrder
					FROM      Ref_LeaveType R, Ref_TimeClass C 
					WHERE     R.LeaveParent = C.TimeClass
					AND       LeaveAccrual IN ('1','2','3','4')									
					ORDER BY  C.ListingOrder, R.ListingOrder 
			</cfquery>	
		
		</cfif>
										   
		<cfoutput query="getLeaveType" group="ParentOrder">
		
			<cfoutput group="Parent">
					
			<tr><td height="4"></td></tr>
			<tr class="line"><td style="height:50px;font-size:26px" colspan="6" class="labelit">#Parent#</td></tr>				
					
			<cfoutput>			
																		
				<cfset row = currentrow>
				
				<cfif URL.ID2 eq "1">				
									
					<cfif contract.recordcount eq "0">		
								
						  <tr>
						    <td colspan="9" height="30" align="center" class="labelit"><font color="FF0000">Calculation Interrupted as no contract information has been recorded</font></td>
						  </tr>
						<cfabort>						
						
				    <cfelse>	
														
						<cfif url.leaveType eq leaveType or url.leavetype eq "">
						
							<cfif URL.balancestatus eq "0">					
																				
									<cfquery name="LastLeave" 
										datasource="AppsEmployee" 
										username="#SESSION.login#" 
										password="#SESSION.dbpw#">
										SELECT MIN(DateEffective) as DateEffective
										FROM   (SELECT   TOP 5 *
											    FROM     PersonLeave L
												WHERE    L.PersonNo      = '#URL.ID#'
												AND      L.Mission       = '#Contract.Mission#'									
												AND      L.LeaveType     = '#LeaveType#'										
												ORDER BY L.Created DESC 
												) as L
									</cfquery>								
																	
									<!--- to be tuned in order to limit recalculation to what makes sense --->
									
									<cfset start = lastleave.dateEffective>
																																																																																																			
									<cfinvoke component = "Service.Process.Employee.Attendance"
									 method         = "LeaveBalance" 
									 PersonNo       = "#URL.ID#" 
									 LeaveType      = "#LeaveType#" 
									 Mission        = "#Contract.mission#"
									 Mode           = "batch"
									 BalanceStatus  = "#url.balancestatus#"
									 StartDate      = "01/01/2017"
									 EndDate        = "12/31/#Year(now())#">									 
																										 
							  <cfelse>
							  							  							  
							  		<cfinvoke component = "Service.Process.Employee.Attendance"
									 method         = "LeaveBalance" 
									 PersonNo       = "#URL.ID#" 
									 LeaveType      = "#LeaveType#" 
									 Mission        = "#Contract.mission#"
									 Mode           = "batch"
									 BalanceStatus  = "#url.balancestatus#"
									 StartDate      = "01/01/2017"
									 EndDate        = "12/31/#Year(now())#">								  
							  
							  </cfif>		 							 
								 								 							 
						</cfif>						
						
					</cfif>			
												 
				</cfif>			
				
				<cfquery name="Balance" 
				datasource="AppsEmployee" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				SELECT TOP 1 L.*, R.Description as ContractDescription 
				    FROM     PersonLeaveBalance L INNER JOIN Ref_ContractType R ON L.ContractType = R.ContractType
					WHERE    L.PersonNo    = '#URL.ID#' 
					  AND    L.LeaveType   = '#LeaveType#'	
					  AND    L.BalanceStatus = '#url.balancestatus#'
					  <!--- the parent --->		
					  AND    L.LeaveTypeClass is NULL		
					  AND    DateEffective <= getDate()			 
					ORDER BY DateEffective DESC 
				</cfquery>
								
				 <tr class="navigation_row labelmedium line">
				 <td width="30" align="center" style="height:35px;padding-top:5px;padding-left:5px">							 
				    <cf_img icon="expand" toggle="yes" name="s#Row#" id="s#Row#" onClick="detail('b#Row#','#leaveType#','','','#url.balancestatus#')">								
				 </td>
				 
				 <td>
				 
					 <table>
					 <tr class="labelmedium"><td style="height;20px;font-size:16px;"><a href="javascript:do_toggle('name','s#Row#');detail('b#Row#','#leaveType#','','force','#url.balancestatus#')">#Description#</a></td>
				 					 								 
						<cfquery name="getLeaveClass" 
						datasource="AppsEmployee" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">
							SELECT       T.*
							FROM        Ref_LeaveTypeClass AS T
							WHERE       LeaveType = '#leaveType#' 
							AND         Code IN
					                          (SELECT  LeaveTypeClass
					                           FROM    Ref_LeaveTypeThreshold
					                           WHERE   LeaveType = T.LeaveType)
						</cfquery>	
						
						<cfloop query="getLeaveClass">
						<td style="padding-left:5px;padding-right:5px">|</td>
						<td style="padding-left:0px;font-size:16px;">
							<a href="javascript:do_toggle('name','s#Row#');detail('b#Row#','#leaveType#','#Code#','force','#url.balancestatus#')">#Description#</a>
						</td>
						</cfloop>
										 			 
				     </tr>
					 </table>
					 
				 </td>
				 <td style="padding-left:0px;font-size:16px;">#Balance.ContractDescription#</td>
				 
				 <cfquery name="Last" 
					datasource="AppsEmployee" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
					 SELECT    TOP (1) Created
					 FROM      PersonLeaveBalance
					 WHERE     PersonNo =  '#URL.ID#' 
					 AND       BalanceStatus = '#url.balancestatus#'
					 AND       LeaveType = '#LeaveType#'
					 ORDER BY  Created DESC
				</cfquery>			 
				 
				 <td style="padding-left:0px;font-size:12px;">								 
				 <table><tr><td>
				 #Dateformat(Last.Created, CLIENT.DateFormatShow)# #Timeformat(Last.Created, "HH:MM")#
				 </td></tr>
				  <tr><td>
				  <cfif url.webapp eq "">
					  <cfif Last.Created gt "">
						  <cfif access eq "EDIT" or access eq "ALL">						  
				    		<input type="button" style="width:110px;height:18" value="Update" class="button10g clsNoPrint" onClick="calculate('0','1','#LeaveType#','#url.balancestatus#')">
						  </cfif>
					  </cfif>
				  </cfif>
				  </td>
				  </tr>
				  </table>
				 
				 </td>				 
				 
				 <td align="center" style="border:1px solid silver;padding-right:4px;font-size:16px;">#Dateformat(Balance.DateExpiration, CLIENT.DateFormatShow)#</td>
				 <td align="right" style="border:1px solid silver;padding-left:0px;font-size:16px;padding-right:4px">
				 <cfif LeaveBalanceMode eq "Relative">
				 <cfelse>
					 #NumberFormat(Balance.Credit,".__")#
				 </cfif>				 
				 </td>
				 <td align="right" style="background-color:##e4e4e480;border:1px solid silver;font-size:16px;padding-right:4px"><cfif Balance.Balance lt "0"><font color="FF0000"></cfif>#NumberFormat(Balance.Balance,".__")#</td>
				 </tr>	
				 				 				 
				 <cfif url.leavetype eq leavetype>
									 				 
				 <tr class="regular" id="b#currentrow#"><td></td>
				 	<td colspan="5" id="ib#currentrow#" style="padding-left:10px;padding-right:20px;height:40px">							
						<cfinclude template="EmployeeBalanceDetail.cfm">	
					</td><td></td>
				 </tr>
				 
				 <cfelse>
				 
				  <tr class="hide" id="b#currentrow#"><td></td>
				 	<td colspan="5" id="ib#currentrow#" style="padding-left:10px;padding-right:20px;height:40px"></td><td></td>
				 </tr>
				 
				 </cfif>
						
			</cfoutput>
			
		</cfoutput>	
		 
		</cfoutput>
		 		 		 
		</TABLE>
				
</td></tr>
	
</table>

<cfoutput>

	<table width="100%" align="center">
		<tr>
			<td style="display:none;" class="clsPrintContentFooter">
				<table width="100%" class="formpadding">
					<tr><td style="padding-top:50px;">&nbsp;</td></tr>
					<tr>
						<td width="50%">
							<table width="70%" align="center">
								<tr>
									<td style="border-bottom:1px solid ##C0C0C0; padding:10px;">&nbsp;</td>
								</tr>
							</table>
						</td>
						<td>
							<table width="70%" align="center">
								<tr>
									<td style="border-bottom:1px solid ##C0C0C0; padding:10px;">&nbsp;</td>
								</tr>
							</table>
						</td>
					</tr>
					<tr>
						<td>
							<table width="70%" align="center">
								<tr>
									<td align="center">#ucase("#getPerson.FirstName# #getPerson.LastName#")#</td>
								</tr>
							</table>
						</td>
						<td>
							<table width="70%" align="center">
								<tr>
									<td align="center"><cf_tl id="Chief of Section" var="1">#ucase(lt_text)#</td>
								</tr>
							</table>
						</td>
					</tr>
				</table>
			</td>
		</tr>
	</table>
	
</cfoutput>

<cfoutput>

	<cfset ajaxonload("doHighlight")>
	<script>
		Prosis.busy('no')	
	</script>
	
</cfoutput>
