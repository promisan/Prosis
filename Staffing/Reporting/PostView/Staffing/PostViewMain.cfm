
<cfset cellspace = round(800/Resource.recordcount)>	
<cfif cellspace lt "39">
   <cfset cellspace = 39>	
</cfif>

<cf_divscroll>

<cfoutput>

 <table width="100%" height="100%" cellspacing="0" cellpadding="0">
 	 
	<tr><td colspan="#tblr#" height="30">
		 	  
		   <table width="97%" align="center" cellspacing="0" cellpadding="0">
		   
		    <tr class="line">
			       <td colspan="2"> 
			
					<table width="100%" cellspacing="0" cellpadding="0">
					<tr>
					
					<td height="40">
										
						<table cellspacing="0" cellpadding="0"><tr>	
						
						<td height="50" style="padding-left:3px">
						
							<table cellspacing="0" cellpadding="0">
							<tr>
												
								<cfquery name="MandateList" 
								datasource="AppsOrganization" 
								username="#SESSION.login#" 
								password="#SESSION.dbpw#">
								    SELECT   *
								    FROM     Ref_Mandate
									WHERE    Mission = '#URL.Mission#'
									AND      Operational = 1
									ORDER BY DateEffective
								</cfquery>
								
							<td style="height:28px;border:1px solid gray;padding-left:3px;padding-right:3px">
							
								<select name="MandateSelect" id="MandateSelect" style="border:0px;font-size:14px;height:26px;width:150" class="regularxl" onChange="Prosis.busy('yes');reloadview(totals.value,snapshot.value,'operational',this.value)">
									<cfloop query="MandateList">
										<option value="#MandateNo#" 
										<cfif MandateNo eq "#URL.Mandate#">selected</cfif>>
										#MandateNo# [#DateFormat(DateExpiration, CLIENT.DateFormatShow)#]
									</option>						
									</cfloop>
								</select>
																		
							</td>
							</tr>
							
							</table>
							
						</td>					
												
						<td class="labelit" align="center" style="padding-left:2px"> 
							
						<cfquery name="Snapshot" 
						    datasource="AppsOrganization" 
						    username="#SESSION.login#" 
						    password="#SESSION.dbpw#">
							SELECT   R.*, M.DateExpiration
							FROM     Ref_MandateView R, Ref_Mandate M
							WHERE    R.MandateNo    = '#URL.Mandate#'
							AND      R.Mission      = '#URL.Mission#'
							AND      R.Mission      = M.Mission
							AND      R.MandateNo    = M.MandateNo
							ORDER BY SnapshotDate 
						</cfquery>	
												
					    <cfif SnapShot.recordcount gte "1">
						
							<table>
							<tr><td class="labelmedium" style="height:28px;border:1px solid gray;padding-left:3px;padding-right:3px">
						
							<select name="snapshot" 
							     id="snapshot" 
								 class="regularxl" style="border:0px;font-size:14px;height:26px;width:160"
								 onChange="Prosis.busy('yes');reloadview(document.getElementById('totals').value,this.value,document.getElementById('treename').value,'<cfoutput>#URL.Mandate#</cfoutput>')">
									
									<cfoutput>
										<option value="today"><cf_tl id="Today"></option>
									</cfoutput>
									<cfloop query="snapshot">
										<option value="#DateFormat(SnapshotDate,CLIENT.DateFormatShow)#"
											<cfif URL.snap eq "#DateFormat(SnapshotDate,CLIENT.DateFormatShow)#">selected</cfif>>
											#Snapshot.SnapshotLabel#
										</option>
									</cfloop>	
									
							</select>
							
							</td>
							</tr>
							</table>
						
						<cfelse>
						
							<cfquery name="DateSelect" 
							datasource="AppsOrganization" 
							username="#SESSION.login#" 
							password="#SESSION.dbpw#">
							    SELECT *
							    FROM Ref_Mandate
								WHERE Mission = '#URL.Mission#'
								AND MandateNo = '#URL.Mandate#'								
							</cfquery>	
							
							<!---
							
							<table>
							<tr><td bgcolor="E6E6E6" class="labelmedium" style="height:28px;border:1px solid gray;padding-left:6px;padding-right:9px">
							
							<cfif DateSelect.dateexpiration lt now()>							
								<cf_tl id="Matrix selection date">:
								</td>
								<td style="height:28px;border:1px solid gray;padding-left:6px;padding-right:9px">
								 <font size="4" color="black">#DateFormat(DateSelect.dateexpiration,CLIENT.DateFormatShow)#</b>
								 
							<cfelse>
								
								<cf_tl id="Matrix selection date">: 
								</td>
								<td style="height:28px;border:1px solid gray;padding-left:6px;padding-right:9px">
								<font size="4" color="black">#DateFormat(now(),CLIENT.DateFormatShow)#</b>
							</cfif>
							
							</td></tr>
							</table>
							
							--->
												
							<input type="hidden" name="snapshot" id="snapshot" value="today">	
							
						</cfif>							
											
						</td>
						
						</table>
					
					</td>	
					
					
					<td style="padding-left:4px">
					
					<table><tr class="labelmedium">
					
					<cfif maintain neq "NONE">	
			
						<td>		
						<cf_tl id="Workforce maintenance" var="1">
						<input type="button" onclick="maintain()" name="maintain" value="#lt_text#" class="button10g" style="height:28px;width:200px;font-size:14px">							
						</td>
					
					</cfif>
					
					<!--- determine global access to the inquiry functions of the staffing table --->
			
					<!--- determine global access to the inquiry functions of the staffing table --->
					
					<cfinvoke component = "Service.Access"  
					   method           = "RoleAccess" 
					   mission          = "#url.mission#" 
					   anyunit          = "No"			 
					   Role             = "'HRInquiry'"
					   returnvariable   = "inquiryaccess">			
			
					<cfif maintain neq "NONE" or inquiryaccess eq "GRANTED">	
																									
							<td style="padding-left:2px">
					
							<cfinvoke component="Service.Analysis.CrossTab"  
											  method      = "ShowInquiry"
											  buttonName  = "Analysis"
											  buttonClass = "variable"		  
											  buttonIcon  = "#SESSION.root#/Images/dataset.png"					  
											  buttonStyle = "height:29px;width:120px;"
											  reportPath  = "Staffing\Reporting\PostView\Staffing\"
											  SQLtemplate = "FactTableMission.cfm"
											  queryString = "Mission=#URL.Mission#&Sel=#dt#"
											  dataSource  = "appsQuery" 
											  module      = "Staffing"
											  reportName  = "Facttable: Staffing Table Inquiry"
											  olap        = "1"
											  target      = "analyse"
											  table1Name  = "Positions"
											  table2Name  = "Assignments"
											  table3Name  = "Vacancy"
											  filter      = "1"
											  returnvariable = "script"> 	
											  
											  <cf_tl id="Dimensional Analysis" var="1">	
							
							
							<input type="button" onclick="#script#" name="olap" value="#lt_text#" class="button10g" style="height:28px;width:200px;font-size:14px">							
					
							</td>
														
												
						<td style="padding-left:2px">
							<cf_tl id="Org Chart" var="1">	
														
							<input type="button" onclick="treeview('#URL.Mission#','#url.mandate#','#url.tree#')" name="tree" value="#lt_text#" class="button10g" style="height:28px;width:200px;font-size:14px">							
					
						
						</td>
					
					</cfif>	
					
					</td>
					
					</tr>
					
					
					</table>
					
					</td>
					
					<!--- only visible if you have access to the full staffing table --->					
					
					<td width="54%" align="right">
					
						<table>
						
						<tr><td>	
						
						<cfinvoke component="Service.Access"  
					     method="position" 
						 mission="#url.mission#"    
						 mandate="#url.mandate#"
					     returnvariable="accessPosition">
						
						<cfif accessPosition neq "NONE">			
																		
							<cfinvoke component="Service.Analysis.CrossTab"  
								  method         = "ShowInquiry"
								  buttonName     = "Excel"
								  buttonText     = "&nbsp;Export&nbsp;"
								  buttonClass    = "button10g"
								  buttonIcon     = "/Logos/Staffing/Excel.png"
                                  buttonStyle    = "font-size:14px;"
								  reportPath     = "Staffing\Reporting\PostView\Staffing\"
								  SQLtemplate    = "PostViewDetailExcel.cfm"
								  queryString    = "mode=full&Mission=#URL.Mission#&Mandate=#URL.Mandate#&selectiondate=#url.snap#&box=1&filterid=#url.filterid#"
								  filter         = ""
								  target         = "analyse"							 
								  dataSource     = "appsQuery" 
								  module         = "Staffing"
								  reportName     = "Facttable: Staffing Table"
								  table1Name     = "Export file"
								  data           = "1"							 
								  ajax           = "0"
								  olap           = "0" 
								  excel          = "1"> 
							  
						</cfif>	  
					
					</td>							
					
					<td style="padding-left:20px;padding-right:4px" class="labelit">
					 <a href="javascript:refresh()" title="Review Workforce Structure in grahical representation.">
					<cf_tl id="Refresh">:
					</a>
					</td>

					<td class="labelmedium" style="border: 1px solid Gray;padding-left:10px;padding-right:10px">
					#DateFormat(Source.Created,CLIENT.DateFormatShow)# #TimeFormat(now(),"HH:mm")#</b>				
					</td>
					
					<td style="padding-left:9px;">
					
						<span id="printTitle" style="display:none;"><cf_tl id="Workforce Table"> - #url.mission#</span>
						<cf_tl id="Print" var="1">				
						<cf_button2
							type="print"
							mode="icon"
							title="#lt_text#"
							height="24px"
							width="24px"
							printTitle="##printTitle"
							printContent=".clsPrintContent">
					</td>
					
					</tr>
					
					</table>
					
					</td>
				
					</cfoutput>
						
				</tr>
					
				</table>
				
			</td>
			</tr>			
			
			<tr><td colspan="2" class="line"></td></tr>
			
		  </table>		
      </td>
	</tr>		
				
	<cfinvoke component = "Service.Access"  
	   method           = "staffing" 
	   mission          = "#URL.Mission#"
	   mandate          = "#URL.Mandate#"
	   returnvariable   = "mandateAccessStaffing">	
	   
	<cfinvoke component = "Service.Access"  
	   method           = "position" 
	   mission          = "#URL.Mission#"
	   mandate          = "#URL.Mandate#"
	   returnvariable   = "mandateAccessPosition">		   	      
	
	<cfif mandateAccessStaffing eq "NONE" and mandateAccessPosition eq "NONE">
	
		<tr><td align="center" class="labelmedium" style="height:30px;padding-top:40px"><font color="FF0000">You have no access to this staffing period.<br>Please contact your administrator</td></tr>
		
		<cfoutput>
			  <input type="hidden" name="totals"   id="totals"   value="cumulative">
			  <input type="hidden" name="treename" id="treename" value="Operational">
		</cfoutput>		
	
	<cfelse>
	
	   <tr><td colspan="<cfoutput>#tblr#</cfoutput>" align="center" style="padding-left:30px;height:30px" width="<cfoutput>#tblw1#</cfoutput>" class="clsNoPrint">
			<cfinclude template="MandateFilterInit.cfm">
	   </td></tr>
	   	   
	   <tr><td colspan="<cfoutput>#tblr#</cfoutput>" style="height:10px" class="clsNoPrint">
		
		    <table align="center">
			<cfinclude template="PostViewHeader.cfm">
			</table>
			
	   </td></tr>	   
	   	   	  
	   <tr><td style="padding-top:1px" colspan="<cfoutput>#tblr#</cfoutput>" style="height:100%" class="clsPrintContent">	 
	   		
				<cf_divscroll style="align:center" overflowy="scroll">	     	   	
								
				<table align="center">
					
				  <tr><td colspan="<cfoutput>#tblr#</cfoutput>" style="padding-right:19px;padding-bottom:4px" align="center" width="<cfoutput>#tblw1#</cfoutput>">
						   <cfinclude template="PostViewOrgClass.cfm"> 
				  </td></tr>	
				  
				   				   		   
				  <tr><td>
				  
				   <table width="100%">
				    
					<tr><td>
					
					<table width="100%" class="formpadding">
					    <tr><td></td>
						<td>
						
						<table width="100%">
						<tr>
																
						<td class="labelmedium" style="font-size:29px;font-weight:200">
							
							<cfquery name="Tree" 
							datasource="AppsOrganization" 
							username="#SESSION.login#" 
							password="#SESSION.dbpw#">
								SELECT   *
								FROM     Ref_Mission
								WHERE    Mission = '#URL.Mission#'
							</cfquery>
													
							<cfif Tree.TreeAdministrative neq "" or Tree.TreeFunctional neq "">
							
								<!--- check if any functional relations are found for this tree --->
								 
								<cfquery name="Check" 
								datasource="AppsOrganization" 
								username="#SESSION.login#" 
								password="#SESSION.dbpw#">							 
									SELECT TOP 1 P.Mission
									FROM   Ref_Mandate R INNER JOIN 
									       Employee.dbo.Position P ON P.Mission = R.Mission and P.MandateNo = R.MandateNo
									
									WHERE  R.Mission IN 
									                  (SELECT Mission FROM Ref_Mission WHERE TreeFunctional IS NOT NULL AND Operational = 1)
									
									AND   R.DateEffective IN
									
									     ( SELECT MAX(DateEffective)
									               FROM     Ref_Mandate 
									               WHERE    DateEffective < '#dte#'
									               AND      Mission = R.Mission
									               GROUP BY Mission
									     )
										 
									AND  P.OrgUnitFunctional is not NULL  	 
									
									AND  P.OrgUnitFunctional IN (SELECT OrgUnit 
									             FROM   Organization 
												 WHERE  OrgUnit = P.OrgUnitFunctional
												 AND   MissionAssociation = '#url.mission#')
																							
															
														
								</cfquery> 
														
							    <cfoutput>
								
								<select name="treename"
								        id="treename"
								        class="regularxl"
								        onChange="Prosis.busy('yes');reloadview('#URL.Unit#',snapshot.value,this.value,'<cfoutput>#URL.Mandate#</cfoutput>')">
										
								 <option value="Operational" <cfif URL.tree eq "Operational">selected</cfif>>
								    <cf_tl id="Operational">
								 </option>
								 
								 <cfif Tree.TreeAdministrative neq "">
								 	<option value="Administrative" 
									  <cfif URL.tree eq "Administrative">selected</cfif>><cf_tl id="Administrative">
									</option>
								 </cfif>
								 																 
								 <cfif check.recordcount gte "1">						 
									<option value="Functional" 
									  <cfif URL.tree eq "Functional">selected</cfif>>
									     <cf_tl id="Functional Relationship">
									 </option>
								 </cfif>
								 
								</select>
																								
								</cfoutput>
																
								
							<cfelse>
							  <cf_tl id="operational">	
							   <input type="hidden" name="treename" id="treename" value="Operational">
							</cfif>
							
							<cfoutput>
							  <input type="hidden" name="totals" id="totals" value="#URL.UNIT#">
							</cfoutput>					
						
						</td>
						
						<td align="right" style="padding-right:4px">
							<table class="formpadding">
							<tr>
							
							<td style="height:30px;padding-left:3px"></td>
							<td>					
							<input type="radio" class="radiol" style="height:20px;width:20px"
							   name="summarytotal" id="unittotal" 
							   value="unit" 
							   onClick="Prosis.busy('yes');totals.value='unit';reloadview('unit',snapshot.value,treename.value,'<cfoutput>#URL.Mandate#</cfoutput>')" <cfif URL.UNIT neq "cum">checked</cfif>>
							</td>   
																					   
							<td onclick="Prosis.busy('yes');unittotal.click()" style="cursor: pointer;;padding-left:4px" class="labelmedium">
							
								<cfif URL.UNIT neq "cum">
								<font color="0080C0" style="font-size: 16px;">
								<cfelse>
								<font style="font-size: 14px;">
								</cfif>
								<cf_tl id="Unit totals">	
									
							</td>			
							
							<td style="padding-left:10px">
							<input type="radio" class="radiol" style="height:20px;width:20px"
							     name="summarytotal" id="cumtotal" 
								 value="cum" 
								 onClick="Prosis.busy('yes');totals.value='cum';reloadview('cum',snapshot.value,treename.value,'<cfoutput>#URL.Mandate#</cfoutput>')" <cfif URL.UNIT eq "cum">checked</cfif>>
							</td>
							<td onclick="Prosis.busy('yes');cumtotal.click()" class="labelmedium" style="cursor: pointer;padding-left:4px;padding-right:10px">
							
								<cfif URL.UNIT eq "cum">
									<font color="0080C0" style="font-size: 16px;">
								<cfelse>
									<font style="font-size: 14px;">
								</cfif>
								<cf_tl id="Cumulative totals">
							
							</td>
							</tr>
							</table>
						</td>
						</tr>
						</table>
						
						</td>
											
						</tr>
						</table>
						</td></tr>
						</table>
						
						</td>
						</tr>		
						
																							  
						<tr id="detailh" bgcolor="transparent">
						
						      <td align="right" style="padding-right:17px">
							  
							  <!--- feature to clean the results based on the access rights --->
		 
							  <cfset accesslist = "">	
								  
							  <cf_treeUnitList
								 mission   = "#URL.Mission#"
								 mandateno = "#URL.Mandate#"
								 role      = "'HROfficer','HRAssistant','HRPosition', 'HRLoaner', 'HRLocator','HRInquiry'"
								 tree      = "1">	
												 		 					
								 
							  <cfif accesslist neq "" and accesslist neq "full">
							  
							  	 <cfquery name="ClearNoAccess" 
								  datasource="AppsQuery" 
								  username="#SESSION.login#" 
								  password="#SESSION.dbpw#">
								  	  DELETE  
									  FROM   userquery.dbo.#SESSION.acc#Grade2_#FileNo#
								      WHERE  OrgUnit NOT IN (#preservesinglequotes(accesslist)#)	   
								  </cfquery>							  
								  
							  						  
							  </cfif>	
							  							   						
							  
							 <!--- create HTML output on the parent level ---> 
							 
							 <!--- this table has the correct hierarchy already --->
							 
							 <cfquery name="OrgUnitList" 
								datasource="AppsOrganization" 
								username="#SESSION.login#" 
								password="#SESSION.dbpw#">
									SELECT    DISTINCT Mission, OrgUnitCode, OrgUnitName, HierarchyCode  
									FROM      userquery.dbo.#SESSION.acc#Grade2_#FileNo# 						
									WHERE     HierarchyCode LIKE '__'													
									ORDER BY  HierarchyCode   
							 </cfquery>
														 							 							 																				 						 						
							 <cfoutput query="OrgUnitList">
									
									<cfset HStart = hierarchycode>
									
									<cfset No = HStart+1>
									<cfif No lt 10>
								     	<cfset HEnd = "0#No#">
									<cfelse>
									    <cfset HEnd = "#No#">
									</cfif>
																																							
									<cfquery name="Max"
									datasource="AppsQuery"
									username="#SESSION.login#"
									password="#SESSION.dbpw#">
									SELECT  MAX(Total) as Total
									FROM  	#SESSION.acc#Grade2_#FileNo# V
									WHERE 	HierarchyCode >= '#HStart#' 
									AND 	HierarchyCode < '#HEnd#'
									</cfquery>
																																													   
							   		<cfinclude template="PostViewOrganization.cfm"> 
										  						      
								</cfoutput>															
														 
							  </td>
						  </tr>
												  					  
					  </table>				  
					 
					  
				</cf_divscroll>	  
					 		 			  
		  </td></tr>
		 		  
	</cfif>  
	
 </table>
 
 </cf_divscroll>
 
 
