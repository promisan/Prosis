
<!--- Prosis template framework --->

<cfsilent>
	<proUsr>jmazariegos</proUsr>
	<proOwn>Jorge Mazariegos</proOwn>
	<proDes>Translated</proDes>
	<proCom></proCom>
</cfsilent>

<cfparam name="url.navigation" default="0">
<cfparam name="wfcheck"        default="">
<cfparam name="md"             default="reference">
<cfparam name="processlevel"   default="line">
<cfparam name="url.ajax"   	   default="1">

<cfoutput>
   <input type="hidden" name="selectedlines" id="selectedlines" value="#QuotedValueList(requisition.requisitionno)#">	
</cfoutput>
 
<!--- End Prosis template framework --->

	<cfparam name="Mode" default="Pending">
	
	<cfparam name="url.Process"       default="Checkbox">
	<cfparam name="url.Search"        default="">
	<cfparam name="url.Unit"          default="">
	<cfparam name="url.Fun"           default="Hide">
	<cfparam name="url.Fund"          default="">
	<cfparam name="url.annotationid"  default="">
	<cfparam name="req"               default="">
	<cfparam name="navigation"        default="0">
	<cfparam name="url.OrgUnit"       default="">	
		
    <cfset mode = lcase(mode)>
	
	<cfif mode eq "Denied">
	     <cfset cl = "FFCCCC">
	<cfelse>
	     <cfset cl = ""> 
	</cfif>
					
    <table width="100%" height="100%" >
					
		<cfif Mode eq "Pending">	
						    
			<tr><td height="2" colspan="9"></td></tr>
								
			<tr>
			    <td colspan="9">
					<table width="100%">
					<tr>
					
					<cfif url.process eq "Checkbox">
					<td width="90">					
						<cf_tl id="Select All" var="1">						
						<input type="button" name="selectall" id="selectall" value="<cfoutput>#lt_text#</cfoutput>" onclick="togglesel();" class="button10g" style="height:25;width:120">					
					</td>		
					</cfif>
					
					<td width="90" class="labelit" style="padding-left:9px;padding-right:4px"><cf_tl id="Search">:</td>					
					<td>					
					
						<table style="border:1px solid silver" cellspacing="0" cellpadding="0" align="left">
												
						<tr>		
									
							<cfoutput>		
										
							<td>
							
								<input type="text"
									  name="#Mode#_search" 
	                                  id="#Mode#_search"
									  value="#url.search#" 
									  class="regularxl" 
									  style="border:0px"
									  size="15"
									  onkeydown="search('1')">				
									  
							</td>
							
							<td width="26" align="center" style="border-left:1px solid silver">				
							
								 <img src="#SESSION.root#/Images/search.png" 
									 alt="find" height="25" width="26"
									 border="0" align="absmiddle"
									 onclick="reqsearch('#url.page#')">							
							
							</td>
							
							</cfoutput>
						
						</tr>
						
						</table>
						
					</td>					
															
					<td align="right">
					
						<table class="formspacing">
						
						<tr>					
						<td>
							
							<!--- define funds --->																	
							
							<cfoutput>
							
								<select name="fundsel" id="fundsel" class="regularxl" onchange="reqsearch('#url.page#')">					
									<option value="hide"><cf_tl id="Hide Funding"></option>
									<option value="funding" <cfif url.fun eq "funding">selected</cfif>><cf_tl id="Show Funding"></option>																															
								</select>
								
							</cfoutput>
						
						</td>	
										
						<td>
						
							<!--- define funds --->
							
							<cfif QuotedValueList(Requisition.RequisitionNo) neq "">
							
								<cfquery name="Fund" 
								datasource="AppsPurchase" 
								username="#SESSION.login#" 
								password="#SESSION.dbpw#">
									SELECT  DISTINCT Fund
									FROM    RequisitionLineFunding
									WHERE   RequisitionNo IN (#QuotedValueList(Requisition.RequisitionNo)#) 
									</cfquery>					
								
								<cfoutput>
									<select name="fundcode" id="fundcode" class="regularxl" onchange="reqsearch('#url.page#')">					
										<option value=""><cf_tl id="Any"></option>														
										<cfloop query="Fund">							
										<option value="#fund#" <cfif url.fund eq fund>selected</cfif>>#Fund#</option>		
										</cfloop>																		
									</select>
								</cfoutput>
								
							<cfelse>
							
								<input type="hidden" name="fundcode" id="fundcode" value="">	
							
							</cfif>
						
						</td>	
												
						<td>
							
							<cfquery name="Unit"
		        		        dbtype="query">
								SELECT DISTINCT OrgUnit,OrgUnitName
								FROM Requisition
							</cfquery>	
							
							<cfoutput>	
														
							<select name="#Mode#_unit" id="#Mode#_unit" style="width:200px" class="regularxl" onchange="reqsearch('#url.page#')">					
								<option value="">--<cf_tl id="All units">--</option>
								<cfloop query="unit">
								<option value="#OrgUnit#" <cfif orgunit eq url.unit>selected</cfif>>#OrgUnitName#</option>
								</cfloop>
							</select>
							</cfoutput>		
							
						</td>			
						
						</tr>
						
						</table>
					
					</td>	
					</tr>
					</table>
			</td></tr>				
					
			<tr>
						
			<td colspan="5" height="26">
			
				<table cellspacing="0" cellpadding="0"><tr><td>
				
				 <cf_tl id="Export to Excel" var="vExport">
				
				  <cfinvoke component="Service.Analysis.CrossTab"  
					  method      = "ShowInquiry"
					  buttonClass = "td"					  						 
					  buttonText  = "#vExport#"						 
					  reportPath  = "Procurement\Application\Requisition\RequisitionView\"
					  SQLtemplate = "RequisitionViewExcel.cfm"
					  queryString = ""
					  dataSource  = "appsQuery" 
					  module      = "Procurement"						  
					  reportName  = "Requisition View"
					  table1Name  = "Requisition"					 
					  table2Name  = "Requisition Funding"		
					  data        = "1"
					  ajax        = "1"
					  filter      = "1"
					  olap        = "0" 
					  excel       = "1"> 	
					  
					  </td>
					  <td id="process" class="hide"></td>
					  </tr>
				 </table>
			
			</td>
			
				<td colspan="4" align="right" height="29">									
					<cf_annotationfilter annotationid="#url.annotationid#" onchange="reqsearch('#url.page#')">												 			
				</td>
				
			</tr>
			
					
			<tr><td colspan="9" height="1" class="line"></td></tr>
												
		<cfelse>
		
			<tr><td height="6" colspan="9"></td></tr>
			
		</cfif>		
					 		
		<cfif Requisition.recordcount eq "0" and Mode eq "Pending">
		
			<cfif url.search eq "">
								
				<tr><td height="6" colspan="9"></td></tr>
				<tr><td colspan="9" align="center" class="labelmedium"><cf_tl id="REQ014"></td></tr>
				<tr><td height="5" colspan="9"></td></tr>
				
			<cfelse>
			
				<tr><td height="6" colspan="9"></td></tr>
				<tr><td colspan="9" align="center" class="labelmedium"><cf_tl id="There are no records to show in this view" class="message">.</td></tr>
				<tr><td height="5" colspan="9"></td></tr>
			
			</cfif>
					
		</cfif>	
						
		<cfif Mode eq "Done">
				
			<cfif Requisition.recordcount eq "0">
				<tr><td colspan="9" height="15" align="center" class="labelmedium"><cf_tl id="REQ015"></td></tr>			
			</cfif>	
						
		</cfif>
		
		<tr>
		<td colspan="9" style="height:100%;padding:9px">
												
			<cf_divscroll style="height:100%">
					
			<table style="width:99%" border="0" class="navigation_table" navigationhover="f5f5f5" navigationselected="eaeaea">
							
			<cfif Requisition.recordcount neq "0">	
			
			<TR class="line labelmedium2 fixlengthlist fixrow">
			  
			   <td>		
				<cfif url.process eq "Radio">
					<cfoutput>
						<a href="javascript:ptoken.navigate('#session.root#/Procurement/Application/Requisition/Process/setRequisitionProcess.cfm','process','','','POST','req')">[<cf_tl id="Clear all">]</a>		
					</cfoutput>	
				</cfif>
				</td>		
			   <td><cf_tl id="Description"></td>
			   <td></td>
			   <td><cf_tl id="Date"></td>
			   <td align="center"><cf_tl id="Quantity"></td>
			   <td align="center"><cf_tl id="UoM"></td>
			   <td align="right"><cf_tl id="Price"></td>
			   <td colspan="2" align="right"><cf_tl id="Amount"></td>		  
		    </TR>			
			
			</cfif>
			
			<cfset myreq="">
			<cfset myclr="">
				
			<cfset currrow = 0>
			
			<!--- ------------- --->
			<!--- Start Header- --->
			<!--- ------------- --->		
																
			<cfoutput query="Requisition" group="#md#">
			
				<cfif navigation eq "1">						
			
					<cfset currrow = currrow + 1>
					
					<cfif currrow gte first and currrow lte last>				
						<cfset show = 1>				
					<cfelse>				
						<cfset show = 0>					
					</cfif>	
					
				<cfelse>
				
					<cfset show = 1>	
				
				</cfif>
				
				<!--- navigation --->
				
				<cfif show eq "1">
					
					<cfif reference neq "">
							
						<cfquery name="Total" 
						datasource="appsPurchase" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">		
							SELECT count(*) as Lines, 
							       SUM(RequestAmountBase) as Total
							FROM   RequisitionLine
							WHERE  Reference = '#Reference#'
							AND    ActionStatus >= '1' AND ActionStatus < '9'						
						</cfquery>			
						
						<cfquery name="this" 
						   dbtype="query">
						    SELECT count(*) as Lines,	
								   SUM(RequestAmountBase) as Total					      
							FROM   Requisition
							WHERE  Reference = '#Reference#'						
						</cfquery>						
						
						<cfquery name="GetCurrency" 
						datasource="AppsSystem" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">	
							SELECT BaseCurrency
							FROM   Parameter
						</cfquery>		
						
						<cfquery name="Header" 
						datasource="appsPurchase" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">		
							SELECT * 
							FROM   Requisition
							WHERE  Reference = '#Reference#'
						</cfquery>					
																
						<tr style="padding-bottom:3px" class="labelmedium2 fixlengthlist">
						   <td style="font-size:22px;height:36px;padding-right:5px;padding-left:5px" colspan="4">					       
						       <a href="javascript:RequisitionView('#mission#','#period#','#Reference#')">#Reference#</a>
						   </td>
						   <td align="right" style="font-size:15px;padding-right:10px" colspan="2">[#This.Lines#]&nbsp;&nbsp;#GetCurrency.BaseCurrency#&nbsp;#NumberFormat(This.Total,",.__")#</td>
						   <td align="right" style="font-size:15px;padding-right:10px" colspan="2">[#Total.Lines#]&nbsp;&nbsp;#GetCurrency.BaseCurrency#&nbsp;#NumberFormat(Total.Total,",.__")#</td>
				 	    </TR>									
						
						<cfif Header.RequisitionPurpose neq "">					
							<TR class="labelmedium2 fixlengthlist">												
							<td colspan="8" style="font-size:15px;height:26px;border-bottom:1px solid gray;padding-left:5px;padding:5px">#Header.RequisitionPurpose#</td>						
							</TR>										
						</cfif>		
																					
					<cfelse>
					
						<cfset this.lines = 0>	
								
					</cfif>		
					
					<cfset hdr_enforcedwf = "No">
					<cfset hdr_funds      = "Yes">
					<cfset row_line       = "0"> 
					
					<!--- ------------------------------- --->
					<!--- --detail lines of the request-- --->
					<!--- ------------------------------- --->	
						
					<cfoutput>
										
						<cfparam name="fundcheck" default="No">
						<cfparam name="url.role"  default="">
						<cfset row_line = row_line+1>
										
						<!--- deterine if funding validation should be bypassed based on parameter value --->
						<cfset fundbyPass  = "Yes">		
										
						<!--- set default result of fund check = Yes --->
						<cfset funds       = "Yes">									
						<cfset enforcedwf  = "No">								  
						
						<!--- ---------------Processing option------------ --->
						<!--- --if funding is a problem, stop processing-- --->		
						<!--- --if wf is required, stop processing ------- --->		
						<!--- ---------------Processing option------------ --->	
																						
						<cfif mode eq "Pending">	
														  					
							<cfif fundcheck is "Funds">										
																																																		
							   	<CF_RequisitionFundingCheck 
									RequisitionNo="'#requisitionNo#'"
									Role = "#URL.Role#">											
																	
							<cfelseif fundcheck is "Budget">
														
									<cfquery name="Check" 
									datasource="AppsPurchase" 
									username="#SESSION.login#" 
									password="#SESSION.dbpw#">
										SELECT    *
										FROM      Ref_ParameterMissionEntryClass
										WHERE     Mission    = '#Mission#' 
										AND       Period     = '#Period#' 
										AND       EntryClass = '#EntryClass#'
										AND       EditionId IN (SELECT EditionId 
										                        FROM Program.dbo.Ref_AllotmentEdition)														
									</cfquery>
									
									<cfif check.editionid neq "">		
									
									   	<CF_RequisitionFundingCheck 
										     RequisitionNo = "'#requisitionNo#'" 
											 editionid     = "#check.editionid#">
										 
									</cfif>								
									
							<cfelseif fundcheck is "Determine">
													
								<cfquery name="Check" 
									datasource="AppsPurchase" 
									username="#SESSION.login#" 
									password="#SESSION.dbpw#">
										SELECT  *
										FROM    Ref_ParameterMissionEntryClass
										WHERE   Mission = '#Mission#' 
										AND     Period = '#Period#' 
										AND     EntryClass = '#EntryClass#'
										AND     EditionId IN (SELECT EditionId 
										                      FROM   Program.dbo.Ref_AllotmentEdition)														
									</cfquery>
																
									<cfif check.editionid neq "" and check.enforceBudget eq "1">		
									
									   	<CF_RequisitionFundingCheck 
										     RequisitionNo = "'#requisitionNo#'" 
											 editionid     = "#check.editionid#">
											 
									<cfelse>
									
										<CF_RequisitionFundingCheck 
											RequisitionNo="'#requisitionNo#'">				 
										 
									</cfif>	 					 		
		
							<cfelse>
												
								<!--- nada --->
																			
							</cfif>		
																		
							<cfif funds eq "Yes" and wfcheck neq "">
												
								<cfquery name="Check" 
								datasource="AppsOrganization" 
								username="#SESSION.login#" 
								password="#SESSION.dbpw#">
								    SELECT ObjectId
									FROM   OrganizationObject
									WHERE  Operational     = '1'
									AND    ObjectkeyValue1 = '#RequisitionNo#'
									AND    EntityCode      = '#wfcheck#'
								</cfquery>
								
								<cfif Check.recordcount gte "1">
								
									<!--- workflow has been created, disable batch --->						
									<cfset enforcedwf     = "Yes">
									<cfset hdr_enforcedwf = "Yes">
								
								</cfif>		
								
							</cfif>		
													
						</cfif>					
																				
						<cfquery name="Fund" 
						datasource="AppsPurchase" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">
							SELECT    ROUND(SUM(Percentage),2) AS Funding
							FROM      RequisitionLineFunding
							WHERE     RequisitionNo = '#RequisitionNo#'
						</cfquery>	
						
						<cfset fullyfunded = fund.funding>
																									
						<cfquery name="Parameter" 
							datasource="AppsPurchase" 
							username="#SESSION.login#" 
							password="#SESSION.dbpw#">
							    SELECT *
							    FROM Ref_ParameterMission
								WHERE Mission = '#Mission#' 
						</cfquery>
							
						<cfif RequestDue neq "" and RequestDue lt now() and Parameter.EnableDueDate eq "1">
						
							<cfset cl = "ffffef">
															 
						<cfelseif fundByPass eq "No" and (funds neq "Yes" or Fund.Funding neq "1")>							
							
							<cfset cl = "FFCCCC">	
						    
						<cfelse>
						
							<cfset cl = "white">	
						
						</cfif>		
																											
						<tr id="#mode#_#currentrow#_1" class="fixlengthlist">
						
						   <td rowspan="3" valign="top">
						   					   				
						   	 <cfif mode eq "Pending">
							 						 												 
							     <cfif enforcedwf eq "Yes">
								 
								   <cf_img icon="edit"  onClick="javascript:ProcReqEdit('#requisitionno#','dialog');">	   						  
												     
							 	 <!--- check if line is fully funded --->
								
							     <cfelseif Fund.Funding eq "1" or FundByPass eq "yes">
																								 										
								 	<cfif url.process eq "Checkbox">
																								    
										    <cfif funds neq "No">
																				       
												<cfquery name="Unit" 
													datasource="AppsOrganization" 
													username="#SESSION.login#" 
													password="#SESSION.dbpw#">
													SELECT    OrgUnitName
													FROM      Organization
													WHERE     OrgUnit = '#OrgUnit#' 
												</cfquery>
																																								
												<cfparam name="CustomDialog" default="">
												<cfparam name="CustomForm"   default="">
							
												<cfif CustomDialog eq "Contract" and CustomForm eq "1" and IndPosition eq "0">
																						    
													<cfset hdr_funds = "No">	
												
												   <!--- do not allow if somehow the position is missing --->
																																
												<cfelse>	
												
													<cfif processlevel eq "line" or 
													       (processlevel eq "header" and this.lines eq row_line and hdr_funds eq "Yes")>
														   										
														<input type="hidden" 
														       id="Unit#RequisitionNo#" 
															   value="#Unit.OrgUnitName#">		
														
														           				
													    <input type="checkbox" 
													    	   class="chk_requisition"
														       name="RequisitionNo" 
	                                                           id="RequisitionNo_#currentrow#"
															   style="height:17px;width:17px"
															   value="#RequisitionNo#" 
															   onClick="hl(this,this.checked,'#mode#_#currentrow#')">			
														   
													</cfif>	   
													   																	
												</cfif>	
												
											<cfelse>
											
												<cfset hdr_funds = "No">	   							   
													 										   									   
											</cfif>	   
										   
									<cfelse>
																	
											<!--- radio box options --->
									
											<cfif myreq eq "">
												<cfset myreq = "f#currentrow#">
											<cfelse>
											    <cfset myreq = "#myreq#,f#currentrow#">
											</cfif>
											
											<cfif Funds eq "No">	
											    <!--- header will have no funds either --->									
												<cfset hdr_funds = "No">												
											</cfif>	
																					
											<!--- now show data to be processed --->
																					
											<cfif processlevel eq "line" or 
												 (processlevel eq "header" and this.lines eq row_line)>
																					
												<table border="0" style="height:10px">
												
												<tr><td style="height:25px">
											
													<table border="0" style="border:1px solid silver">
													
													  <tr>
													  
													  <cf_tl id="Pending" var="1">
													  <td style="padding:3px" height="21" bgcolor="white" title="#lt_text#">	
														
													  	<input type="radio" 
													       name="f#currentrow#" 
	                                                       id="f#currentrow#"
														   style="width:21;height:21"
														   value="" checked
														   onClick="hl('0','#mode#_#currentrow#')">	   	
														
														   
													  </td> 
													  													  
													  <cf_tl id="Send back request" var="1">
													  
													  <td style="padding:3px" height="21" bgcolor="yellow" title="#lt_text#">													  
													  														
															<input type="radio" 
														       name="f#currentrow#"
	                                                           id="f#currentrow#" 
															   style="width:21;height:21"
															   value="R_#RequisitionNo#" 
															   onClick="hl('1','#mode#_#currentrow#');reason('#currentrow#','#mode#_#currentrow#','#RequisitionNo#','requisition','9')">
																												 
													  </td>		
													  
													  <cf_tl id="Cancel Request" var="1">							 					  
													 									  										
													  <td style="padding:3px" height="21" bgcolor="red" title="#lt_text#">
													  
															<input type="radio" 
														       name="f#currentrow#" 
	                                                           id="f#currentrow#"
															   style="width:20;height:20"
															   value="D_#RequisitionNo#" 
															   onClick="hl('1','#mode#_#currentrow#');reason('#currentrow#','#mode#_#currentrow#','#RequisitionNo#','requisition','9')">
																												
													  </td>
													  
													  <cf_tl id="Forward Request" var="vForward">
							
													  <cfif Funds neq "No" or hdr_funds eq "Yes">
													  
													  	  <cfif myclr eq "">
															<cfset myclr = "c_#currentrow#">
														  <cfelse>
														    <cfset myclr = "#myclr#,c_#currentrow#">
														  </cfif>
													  												  
													      <!--- tuning 10/01/2012 to honor the ability not to select a funding by requester/reviewer --->
													  
														  <td style="padding:3px" height="50" bgcolor="00FF00" title="#vforward#">
														  
														   <!--- inclomplete funding --->
														   <cfif fullyfunded neq "1" AND url.role eq "ProcReqReview"  AND parameter.FundingByReviewer eq "2">
														      
															   <!--- inclomplete funding and funding not required for review step --->
															  
																	<input type="radio" 
																       name="f#currentrow#" 
	                                                                   id="c_#currentrow#"		
																	   style="width:20;height:20"														 
																	   value="C_#RequisitionNo#" 
																	   onClick="hl('1','#mode#_#currentrow#');reason('#currentrow#','#mode#_#currentrow#','#RequisitionNo#','requisition','2i')">
																															   
														   <cfelseif fullyfunded neq 1>	  
														  														   
														   	  <!--- inclomplete funding and funding required --->
															  
															  <!--- not enabled --->
															  	  
																	<input type="radio" 
																       name="f#currentrow#"
	                                                                   id="c_#currentrow#" 
																	   style="width:20;height:20"
																	   <cfif fullyfunded neq "1">disabled</cfif>
																	   value="C_#RequisitionNo#" 
																	   onClick="hl('1','#mode#_#currentrow#');reason('#currentrow#','#mode#_#currentrow#','#RequisitionNo#','requisition','2i')">
																  
														   <cfelse>
														   
														   		<!--- enabled --->
														  																 
																	<input type="radio" 
																       name="f#currentrow#" 
	                                                                   id="c_#currentrow#"		
																	   style="width:20;height:20"														   
																	   value="C_#RequisitionNo#" 
																	   onClick="hl('1','#mode#_#currentrow#');reason('#currentrow#','#mode#_#currentrow#','#RequisitionNo#','requisition','2i')">
																															 
															</cfif> 
															 
														  </td>
													 
													   </cfif>	   
													  
													  </tr>
													  
													</table>
												</td>										
												<td>&nbsp;&nbsp;&nbsp;</td>										
												</tr>
												
												</table>
												
											</cfif>	
										
									</cfif>	   
																						 
								 <cfelse>	
								 
								 	<cfset hdr_funds = "No">
												 																								
									<img src="#SESSION.root#/Images/nofund.gif" 
										alt="Requisition was not funded" 
										style="cursor: pointer;" 
										onclick="ProcReqEdit('#requisitionno#','dialog');" 
										border="0" align="absmiddle">
					
								 </cfif> 
							 
							 </cfif>
						 		   
						   </td>	
						   
						    <td class="labelmedium2" style="font-size:17px;" colspan="4">
									
									<cfif IndTravel eq "0" and IndPosition eq "0" and IndService eq "0">								
							        	<cfif caseNo neq "">#CaseNo# </cfif> #RequestDescription#						
									<cfelse>	
															
							   			<a href="javascript:showreqdetail('#requisitionno#_#mode#','#requisitionno#','#mission#','#itemmaster#','#requesttype#','#warehouseitemno#','listing')">					
										<font color="000000">													
								        <cfif caseNo neq "">#CaseNo# </cfif> #RequestDescription#						  									
										</a>															
									</cfif>
									
									<cfif workorderid neq "">
									
										<cfquery name="WorkOrder" 
										datasource="appsWorkOrder" 
										username="#SESSION.login#" 
										password="#SESSION.dbpw#">		
											SELECT * 
											FROM   WorkOrder
											WHERE  WorkOrderId = '#workorderid#'
										</cfquery>		
																												
										#workorder.reference#		
										
										<cfif RequirementId neq "">
										
											<cfquery name="Raw" 
											datasource="appsWorkOrder" 
											username="#SESSION.login#" 
											password="#SESSION.dbpw#">		
												SELECT * 
												FROM   WorkOrderLineResource
												WHERE  ResourceId = '#requirementid#'
											</cfquery>	
											
											<cfif raw.recordcount eq "1">								
											  : <b><cf_tl id="Bill of Material"></b> 
											<cfelse>
											  : <b><cf_tl id="Finished Product"></b>										
											</cfif>
										
										</cfif>
									
									</cfif>
									
						    </td>
							
							<td align="right" colspan="3" style="padding-top:2px;padding-right:2px">
						   					   				     
						   	   <table border="0" align="right">
							   
							    <tr>							
								  <td align="center" style="padding-top:3px;padding-left:2px">	
								     <cf_img icon="log" onClick="requisitionlog('#requisitionno#_#mode#','#requisitionno#')">								  			   					   	        					   								  
							      </td>							  							  
							      <td align="center" style="padding-top:1px;padding-left:2px">							  
								   <cf_img icon="edit" onClick="ProcReqEdit('#requisitionno#','dialog');">				 								 
								  </td>														 
								  <td align="center" style="padding-right:3px" id="note_#mode#_#RequisitionNo#">								 
									 <cf_annotationshow entity="ProcReq" 
						                   keyvalue1="#requisitionno#" 
										   docbox="note_#mode#_#RequisitionNo#">							 
								  </td>							 
								</tr>
								 
							  </table>	
																		   
						   </td>
							
						 </tr>
						 				 
						 <!--- second row --->
						   
						 <tr id="#mode#_#currentrow#_2" bgcolor="#cl#" class="labelmedium2 navigation_row_child fixlengthlist" style="height:20px">
						   			   		    	  
						   <td style="padding:1px;border:0px solid silver" rowspan="2">
						   					   					   
						   	   <cfparam name="FundsMode" default="">															
							   <cfparam name="bud" default="">																								
							   <cfparam name="res" default="">																								
							   <cfparam name="obl" default="">																																										
							   <cfparam name="inv" default="">																																										
							   <cfparam name="bal" default="">
							   
							   <cfif funds eq "ByPass">
						  
						        <!---  &nbsp;skipped fund sufficienty</font> --->
						  					  
							   <cfelseif funds eq "Yes">
							  					  						   
							   		<cfif bud neq "">	
																							   						  							
											<table width="100%">
																				
											<cfif fundsmode neq "">
											
											<tr><td style="padding-top:5px;padding-left:5px">		
																
											<table bgcolor="FFFFCA">
											<tr><td bgcolor="D9FFD9">								
											
											<cfif revert eq "">	
											
												<table width="200" cellspacing="0" cellpadding="0">
													
													<!---	
													<tr bgcolor="cacaca" class="labelmedium" style="height:20px">													
													  <td colspan="5" style="padding-left:6px;padding-top:2px">#fundsmode# validation in #application.basecurrency#</td>
													</tr>
													--->
													
													<tr class="labelmedium" style="height:20px">
													   <td style="padding-left:13px;font-size:13px;"><cf_tl id="Budget">:</td>
													   <td colspan="5" align="right" style="padding-right:10px;;height:22px">#numberformat(bud,',__')#</td>
													</tr>
													
													<tr class="labelmedium line" style="height:20px">  
													   <td style="font-size:12px;padding-left:20px">Pre:</td>
													   <td align="right" style="padding-right:15;height:22px">#numberformat(res,',__')#</td> 									
													   <td style="font-size:12px;padding-left:10px"><cfif Parameter.FundingClearTransaction eq "0">Obl<cfelse>Unl</cfif>:</td>
													   <td align="right" style="padding-right:15">#numberformat(obl,',__')#</td> 
													   <cfif inv neq "0">
													   <td style="font-size:12px;padding-left:20px">Inv:</td>
													   <td align="right" style="padding-right:15">#numberformat(inv,',__')#</td> 
													   </cfif>
													<tr>  												
													<tr class="labelmedium line" style="height:20px">  
													   <td style="font-size:13px;padding-left:13px"><cf_tl id="Balance">:</td>
													   <td colspan="5" align="right" style="padding-right:10px"><b>#numberformat(bal,',__')#</td> 
													</tr>
															
												</table>	
																																
											<cfelse>
																							
												<img src="#SESSION.root#/Images/alert.png" 
												 height="16" width="16" alt="" border="0" align="absmiddle">&nbsp;
												<font size="1" style="font-family: Verdana;" color="FF0000"> <cf_tl id="Requisition was sent back to funder" class="message"></font>&nbsp;&nbsp;
											
											</cfif>
											
											</td></tr>								
											
											</table>	
											</td></tr> 
											
											</cfif>
																		
											</table>
											
									<cfelse>
									
									<font color="008000"><cf_tl id="funds">:<b><cf_tl id="Available"></b></font>	
									
									</cfif>
									
							   <cfelse>
							
									<cf_tl id="REQ011" var="1">
									<cfset vReq011=lt_text>
									
									<!--- if we have a budget defined, we can validate it --->
																			
									<cfif bud neq "">	
																									
										<table width="100%" cellspacing="0" cellpadding="0">
																				
											<tr><td style="padding-left:5px">							
											<table cellspacing="0" cellpadding="0">
											<tr><td bgcolor="FFD2A6" style="border:1px solid gray">																
																				
												<cfif revert eq "">		
																																	
						                                <table cellspacing="0" cellpadding="0" width="250">
														
														    <!---
															<tr bgcolor="c5c5c5">													
															  <td colspan="5" style="padding-left:6px;padding-top:2px;height:15px" class="labelit">#fundsmode# validation in #application.basecurrency#</td>
															</tr>
															<tr class="line"><td colspan="5"></td></tr>
															--->
															
															<tr class="labelmedium line" style="height:20px">
															   <td style="padding-left:13px"><cf_tl id="Budget">:</td>
															   <td colspan="5" align="right" style="padding-right:10px;;height:18px">#numberformat(bud,',__')#</td>
															</tr>
															
															<tr class="labelmedium line" style="height:20px">  
															   <td style="padding-left:20px"><cf_tl id="Enc">:</td>
															   <td align="right" style="padding-right:15;height:18px">#numberformat(res,',__')#</td> 									
															   <td style="padding-left:10px"><cfif Parameter.FundingClearTransaction eq "0"><cf_tl id="Obl"><cfelse><cf_tl id="Unliq."></cfif>:</td>
															   <td align="right" style="padding-right:15">#numberformat(obl,',__')#</td> 
															   <cfif inv neq "0">
															   <td style="padding-left:20px"><cf_tl id="Invoice">:</td>
															   <td align="right" style="padding-right:15">#numberformat(inv,',__')#</td> 
															   </cfif>
															<tr>  
															
															<tr class="labelmedium line" style="height:20px">  
															   <td style="padding-left:13px"><cf_tl id="Balance">:</td>
															   <td colspan="5" align="right" style="padding-right:10px">#numberformat(bal,',__')#</td> 
															</tr>
															
														</table>
																						
												<cfelse>
																									
													<img src="#SESSION.root#/Images/alert.png" 
													 height="16" width="16" alt="" border="0" align="absmiddle">&nbsp;
													<font size="1" style="font-family: Verdana;" color="FF0000"><cf_tl id="Requisition is with funder for additional funding"></font>&nbsp;&nbsp;
												
												</cfif>		
											
											</td></tr></table>	
											</td></tr> 
																		
										</table>	
									
									</cfif>
																			
							   </cfif>
						   
						   </td>
						   
						   <td style="padding-left:3px;border-bottom:1px solid silver" class="line">
						   <cfif source eq "workflow">
						   <a href="javascript:process('#RequirementId#')">#RequestType#</a>
						   <cfelse>
						   #RequestType#
						   </cfif></td>
						   
				    	   <td align="center" style="border-bottom:1px solid silver" class="line">					  
						   <cfif IndTravel eq "0" and IndPosition eq "0" and IndService eq "0">
						    <cfif warehouseItemNo neq "" and WarehouseUoM neq "">
							   <a href="javascript:itemopen('#warehouseitemno#')">#RequestQuantity#</a>
							<cfelse>
							   #RequestQuantity#
							</cfif>
						   </cfif> 
						   </td>
						   
						   <td align="center" style="border-bottom:1px solid silver" class="line">
						   <cfif IndTravel eq "0" and IndPosition eq "0" and IndService eq "0">#QuantityUoM#</cfif> 				  
						   </td>
						   
						   <td align="right" style="border-bottom:1px solid silver" class="line">#NumberFormat(RequestCostprice,",.__")#</td>
						   <td style="padding-right:4px;border-bottom:1px solid silver" colspan="2" align="right">#NumberFormat(RequestAmountBase,",.__")#</td>
						   					   
						</tr>									
						
						<cfif countedtopics gte 1>
											
							<tr class="navigation_row_child labelmedium line" style="height:20px">								 					 
							  <td colspan="8" style="padding-left:4px">									 							  				 
								<cf_getRequisitionTopic RequisitionNo="#RequisitionNo#" TopicsPerRow="3">				
							  </td>
							</tr>
							
						</cfif>
						
						<!--- thirdrow --->
										
						<tr id="#mode#_#currentrow#_3" bgcolor="#cl#" class="labelmedium navigation_row_child fixlengthlist" style="height:20px">		
												
						<td height="16" style="padding-left:4px" colspan="1">
																											
						<cfif PersonNo neq "">
						
							<cfquery name="Person" 
							datasource="AppsEmployee" 
							username="#SESSION.login#" 
							password="#SESSION.dbpw#">
								SELECT *
								FROM  Person
								WHERE PersonNo = '#PersonNo#'
							</cfquery>
													
							#Description# :
							<a href="javascript:EditPerson('#PersonNo#')">#Person.FirstName# #Person.LastName#</a> 
														
						<cfelseif fun eq "Job">
						
							 <font color="black">#VendorOrgUnitName#</font>
						
						<cfelse>
						
							#Description#
											
						</cfif>
						
						</td>
						
						<td style="padding-right:4px;">
									
						<cfif RequestDue neq "" and RequestDue lt now()>
							<font color="red">#DateFormat(RequestDue, client.dateformatshow)#</font>
						<cfelse>
							#DateFormat(RequestDate, CLIENT.DateFormatShow)#					
						</cfif>		
									
						</td>						
																		
						<cfif Fun eq "Job" AND WarehouseItemNo eq "" and ParentRequisitionNo eq "">
						
						<td colspan="3">#OrgUnitName# #RequestPriority#</td>						
						<td align="right">
							 <a href="javascript:ProcReqSplit('#RequisitionNo#');"><cf_tl id="split line"></a>
						</td>		
						
						<cfelse>
						
							<cfif url.orgunit neq "" and warehouseitemNo neq "">
							
								<cfquery name="Offer" 
								datasource="AppsMaterials" 
								username="#SESSION.login#" 
								password="#SESSION.dbpw#">
									SELECT    *
									FROM      ItemVendor AS IV INNER JOIN
			                        		  ItemVendorOffer AS IVO ON IV.ItemNo = IVO.ItemNo AND IV.UoM = IVO.UoM
									WHERE     IV.ItemNo = '#warehouseitemno#' 
									AND       IV.UoM = '#warehouseUoM#' AND IV.OrgUnitVendor = '#url.orgunit#'
									ORDER BY  IVO.DateEffective DESC								
								</cfquery>
							
								<cfif Offer.recordcount gte "1">
							
									<td colspan="2">#OrgUnitName#</td>			
									<td bgcolor="C6F2E2" style="padding-left:3px">Minimum Order: #Offer.OfferMinimumQuantity#</td>
									<td bgcolor="C6F2E2">Offer : #Offer.Currency# #numberformat(Offer.ItemPrice,",.__")#</td>
							
								<cfelse>
							
									<cfif RequestCurrency neq APPLICATION.BaseCurrency>
									    <td colspan="2">#OrgUnitName#</td>							    
										<td bgcolor="ffffcf" align="right">#numberformat(RequestCurrencyPrice,",.__")# <font size="1">#RequestCurrency#</td>
										<td bgcolor="ffffcf" style="padding-right:15px" align="right">#numberformat(RequestCurrencyPrice*RequestQuantity,",.__")#</td>
									<cfelse>
										<td colspan="4">#OrgUnitName#: #OfficerLastName#</font></td>							
									</cfif>
									
								</cfif>	
									
							<cfelse>
							
								<cfif RequestCurrency neq APPLICATION.BaseCurrency>
								    <td colspan="2">#OrgUnitName#</td>							    
									<td bgcolor="ffffcf" align="right">#numberformat(RequestCurrencyPrice,",.__")# <font size="1">#RequestCurrency#</td>
									<td bgcolor="ffffcf" style="padding-right:15px" align="right">#numberformat(RequestCurrencyPrice*RequestQuantity,",.__")#</td>
								<cfelse>
									<td colspan="4">#OrgUnitName#: #OfficerLastName#</font></td>							
								</cfif>		
													
							</cfif>
													
						
						</cfif>
						
						<cfset amt = "#Requisition.RequestAmountBase#">
						
						</tr>
										
						<cfparam name="CustomForm"   default="1"> <!--- is enabled --->
						<cfparam name="CustomDialog" default=""> <!--- value of the custom form --->
										
						<cfif CustomForm eq "1" and CustomDialog eq "Contract" and IndPosition eq "0">
						
							<tr>
								<td colspan="8" bgcolor="FF0000" align="center" height="20"><font color="FFFFFF"><cf_tl id="Please associate a position to fund through this request" class="message"> .</font></td></tr>
							</tr>
						
						</cfif>
						
						<tr id="bdet#requisitionNo#_#mode#" class="hide">					   
						    <td colspan="8" style="padding:3px"><cfdiv id="det#requisitionNo#_#mode#"></td>
						</tr>
										
						<tr id="blog#requisitionNo#_#mode#" class="hide">					   
						   <td colspan="8" id="log#RequisitionNo#_#mode#">					  					 
						</td></tr>
														
						<cfswitch expression="#url.fun#">
				
							<cfcase value="funding">
							
							   <cfquery name="Funding" 
									datasource="AppsPurchase" 
									username="#SESSION.login#" 
									password="#SESSION.dbpw#">
									SELECT    F.*, O.CodeDisplay, O.Description as ObjectDescription
									FROM      RequisitionLineFunding F, 
									          Program.dbo.Ref_Object O
									WHERE     F.RequisitionNo = '#RequisitionNo#'	
									AND       F.ObjectCode = O.Code
				    			</cfquery>
								
								
								<cfif Funding.recordcount eq "0">
								
									<tr id="#requisitionno#_4">
																					
										<td colspan="8" align="center" bgcolor="red" class="labelmedium">
										<font color="FFFFFF"><cf_tl id="No funding was recorded for this request"></font>
										</td>
									</tr>	
								
								</cfif>
								
								<cfset per = "#Requisition.Period#">
								<!--- define the planning period for this execution period --->
								
								<cfquery name="PlanningPeriod" 
										datasource="AppsOrganization" 
										username="#SESSION.login#" 
										password="#SESSION.dbpw#">
										SELECT    *
										FROM      Ref_MissionPeriod
										WHERE     Mission = '#url.mission#'									
										AND       Period = '#per#'
					    		</cfquery>		
								
								<tr id="#requisitionno#_4">
																																														
								<td colspan="8" align="center" bgcolor="D9FFD9">	
								
								<table width="100%">
																		
								<cfloop query="Funding">
								
									<cf_assignid>
									
									<cfquery name="Program" 
										datasource="AppsProgram" 
										username="#SESSION.login#" 
										password="#SESSION.dbpw#">
										SELECT    P.*, Pe.Reference, Org.OrgUnitName
										FROM      Program P, 
										          ProgramPeriod Pe, 
												  Organization.dbo.Organization Org
										WHERE     P.ProgramCode = '#ProgramCode#'	
										AND       P.ProgramCode = Pe.ProgramCode
										AND       pe.OrgUnit = Org.OrgUnit
										AND       Pe.Period = '#PlanningPeriod.PlanningPeriod#'
					    			</cfquery>
																										
									<tr class="labelmedium">										   
									   
									   <td width="30" class="noprint" style="padding-left:3px" onclick="programobject('#requisitionno#','#programcode#','#url.mission#','#PlanningPeriod.PlanningPeriod#','#per#','#Program.programclass#','','#PlanningPeriod.editionid#','#fund#','','budget_#rowguid#')">
												   			
											   <cf_space spaces="4">									
																	
											   <img src="#SESSION.root#/Images/arrow.gif" alt="" 
													id="budget_#rowguid#Exp" border="0" class="regular" align="absmiddle" style="cursor: pointer;">
																	
											   <img src="#SESSION.root#/Images/arrowdown.gif" 
													id="budget_#rowguid#Min" alt="" border="0" align="absmiddle" class="hide" style="cursor: pointer;" height="12" width="12">
																							
										</td>		
									   
									   </td>
									   <td width="70" style="padding-left:6px">#Fund#</td>	
									   <td width="100" style="padding-left:6px">#ProgramPeriod#</td>									  							  
									   <td width="30%" style="padding-left:6px">
										   <a href="javascript:AllotmentInquiry('#ProgramCode#','#fund#','#Per#','','')">
										   <cfif Program.reference neq "">#Program.Reference#<cfelse>#ProgramCode#</cfif>
										   &nbsp;#Program.ProgramName#
										   </a>
									   </td>									   
									   <td width="16%" style="padding-left:6px">#Program.OrgUnitName#</td>
									   <td width="20%" style="padding-left:6px">#CodeDisplay#&nbsp;#ObjectDescription#</td>
									   <td width="70" style="padding-left:6px">#Percentage*100#%</td>
									   <td align="right" style="padding-right:10px;padding-left:10px">#numberFormat(Percentage*amt,"__,__.__")#</td>								   
									</tr>
											
									
									<tr>
									
									<td colspan="8" id="budget_#rowguid#" class="hide">														
										<table width="100%" cellspacing="0" cellpadding="0" bgcolor="white">
												<tr>	
												<td id="budget_#rowguid#_content"></td>
												</tr>
										</table>																					
									</td>
									</tr>
											
								</cfloop>
								
								</table>
										
								</td>	  
										
			            	</tr>
										
							</cfcase>
							
							<cfcase value="job">
																
								<cfquery name="Vendor" 
									datasource="AppsPurchase" 
									username="#SESSION.login#" 
									password="#SESSION.dbpw#">
									SELECT    Q.*, Org.OrgUnitName
									FROM      RequisitionLineQuote Q INNER JOIN
					                	      Organization.dbo.Organization Org ON Q.OrgUnitVendor = Org.OrgUnit
									WHERE     Q.RequisitionNo = '#RequisitionNo#'	
									ORDER BY  Q.QuoteAmountBase 
											
								</cfquery>
																													
								<cfloop query="Vendor">
								
								<cfif QuoteAmountBase lte "0">
												
								<tr class="labelmedium" bgcolor="D3FAFA" id="#mode#_#currentrow#_4">
								
								<cfelse>
								
								<tr class="labelmedium" bgcolor="f6f6f6" id="#mode#_#currentrow#_4">
								
								</cfif>
								
							   <td align="center">
							   
								  <cfif Selected eq "1">
								  
								     	<img src="#SESSION.root#/Images/check.gif" 
										     alt="Cleared" 
											 width="10" 
											 height="12" 
											 border="0">
									 
		 						  </cfif>						  
							   </td>	  
									
						       <td rowspan="1" align="center" style="padding-top:3px">							   						   
							   	<cf_img icon="edit"  onClick="javascript:ProcQuoteEdit('#quotationid#')">								
						       </td>
							   <td>#OrgUnitName#</td>
				    		   <td align="center"
				    		       style="padding: 1px;">#QuotationQuantity#</td>
							   <td style="padding: 1px;" align="center">#QuotationUoM#</td>
						       <td style="padding: 1px;" align="right">#NumberFormat(QuoteAmountBase/QuotationQuantity,",.__")#</td>
						       <td style="padding: 1px;padding-right:5px" align="right">#NumberFormat(QuoteAmountBase,",.__")#</td>				   
						       <td rowspan="1" align="center" width="30">
							  
						      	<!--- 
							       <input type="checkbox" name="QuotationId" value="#QuotationId#" onClick="javascript:hl(this,this.checked,'#QuotationId#')">
								--->				 				   
						        </td>
				            	</tr>
											
								</cfloop>
										
							</cfcase>
							
						</cfswitch>						
						
						<cfif mode eq "Pending">
							
							<!--- container for reason --->	
							<tr id="#mode#_#currentrow#_5">
							<td colspan="8">					
								<cfdiv id="#mode#_#currentrow#_reason"/>
							</td>
							</tr>	
						
						</cfif>
						
						<cfif processlevel eq "Line" or this.lines eq row_line>																						
						<tr><td colspan="8" class="line"></td></tr>												
						</cfif>				
										
						<!--- ---------------- --->
						<!--- end of the lines --->
						<!--- ---------------- --->
					
					</cfoutput>
					
					<!--- process on the header level --->							
									
				</cfif>	
				
				<!--- ------------------- --->
				<!--- end of the headers- --->
				<!--- ------------------- --->
			
			</cfoutput>
			
			</table>
			
			</cf_divscroll>
						
		     
							
			</td>
		</tr>
						
		<cfparam name="myreq" default="">		
		
		<input type="hidden" 
		   name="reqlist" id="reqlist"
		   value="<cfoutput>#myreq#</cfoutput>">	
		   
		 <input type="hidden" 
		   name="clrlist" id="clrlist"
		   value="<cfoutput>#myclr#</cfoutput>">
						
	</table>	
	
	<cfset ajaxonload("doHighlight")>

	
	
	
	