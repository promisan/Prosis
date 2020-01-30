
<!--- gets the account periods based on the entity, fiscalyear and type of report --->

<cfparam name="url.mission"       default="">
<cfparam name="url.accountperiod" default="">
<cfparam name="url.report"        default="">
<cfparam name="url.format"        default="list">
<cfparam name="url.mode"          default="fiscal">
<cfparam name="url.aggregation"   default="group">
<cfparam name="url.showcenter"    default="no">

<cfquery name="Parameter"
datasource="AppsLedger" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT    *
	FROM      Ref_ParameterMission
	WHERE     Mission       = '#url.mission#' 	
</cfquery>

<table width="100%" cellspacing="0" cellpadding="0" align="center">

	<!--- these are potentially heavy queries to be tuned --->

	<cfif url.report eq "pl" or url.report eq "fund">
		
		<cfif Parameter.AdministrationLevel eq "Parent">		
		
			<!--- parent orgunit is enabled --->			
						
			<cfquery name="UnitOwner"
			datasource="AppsLedger" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				SELECT  DISTINCT H.OrgUnitOwner, O.OrgUnitName
				FROM    TransactionHeader AS H INNER JOIN
			            Organization.dbo.Organization AS O ON H.OrgUnitOwner = O.OrgUnit
				WHERE   H.Mission       = '#url.mission#' 
				AND     H.AccountPeriod = '#url.accountperiod#'
			</cfquery>
				
			
			<tr><td colspan="2" class="linedotted"></td></tr>
			
			<tr><td colspan="2"><table width="100%">
			
			<cfoutput query="UnitOwner">
						
				<tr><td style="width:20px;padding-left:2px;padding-right:8px">
				  <input type="checkbox" 
				       style="height:14px;width:14px" onchange="reloadalert();"					   				  
					   id="OrgUnitOwner" 
					   name="OrgUnitOwner" 
					   value="#OrgUnitOwner#">
				   </td>
				   <td class="labelmedium" style="width:94%;height:20px;padding-left:1px">#left(OrgUnitName,20)#</td>
				</tr>
					
		    </cfoutput>
		
		<cfelse>
		
			<input type="hidden" id="OrgUnitOwner" name="OrgUnitOwner" value="">
		
		</cfif>
		
		<cfquery name="CostUnitSelect"
			datasource="AppsLedger" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
		
			SELECT  DISTINCT ORG.MissionOrgUnitId, ORG.HierarchyCode
            FROM    TransactionHeader H 
					INNER JOIN TransactionLine HL ON H.Journal = HL.Journal AND H.JournalSerialNo = HL.JournalSerialNo 
					INNER JOIN Organization.dbo.Organization ORG ON HL.OrgUnit = ORG.OrgUnit
            WHERE   H.Mission       = '#url.mission#' 
			AND     H.AccountPeriod = '#url.accountperiod#'		
								
		</cfquery>
		
		<cfset orglist = "#quotedvalueList(costunitselect.missionOrgUnitId)#">
				
		<cfloop query="CostUnitSelect">
		
		    <cfset hier = HierarchyCode>		
			<cfset l = len(hier)>
						
			<cfloop condition="#l# gte '2'">
									
				<cfquery name="get"
				datasource="AppsLedger" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				
				    SELECT    MissionOrgUnitId
					FROM      Organization.dbo.Organization O INNER JOIN
		            	      Organization.dbo.Ref_MissionPeriod R ON O.Mission = R.Mission AND O.MandateNo = R.MandateNo
							  
				   	AND       R.Mission       = '#url.mission#' 
					AND       R.AccountPeriod = '#url.accountperiod#'							
					AND       O.HierarchyCode = '#hier#'
					
				</cfquery>
				
				<cfif get.recordcount eq "1">				
					<cfset orglist = "#orglist#,'#get.MissionOrgUnitId#'">
				</cfif>	
				
				<!--- obtain --->
								
				<cfif l gte "5">
					<cfset l = l-3>
					<cfset hier = left(hier,l)>
				<cfelse>
					<cfset l = "0">	
				</cfif>		
							
			</cfloop>						
		
		</cfloop>
		
		<!--- obtain the parent also for presentation on aggregated levels --->
			
		<!---
		<cfoutput>#cfquery.executiontime#</cfoutput>			
		--->		
		
		<!--- COST CENTER --->
		
		<cfquery name="CostUnit"
			datasource="AppsLedger" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			
				SELECT    DISTINCT O.OrgUnit, 
				          O.OrgUnitName, 
						  HierarchyCode
				FROM      Organization.dbo.Organization O INNER JOIN
	            	      Organization.dbo.Ref_MissionPeriod R ON O.Mission = R.Mission AND O.MandateNo = R.MandateNo
						  
			    <!--- 26/11 adjusted the below as it took too much time --->
				
				<cfif CostUnitSelect.recordcount gte "1">
				WHERE     O.MissionOrgUnitId IN (#preservesingleQuotes(orglist)#)
				<cfelse>
				WHERE     0=1
				</cfif>				
				AND       R.Mission       = '#url.mission#' 
				AND       R.AccountPeriod = '#url.accountperiod#'							
				ORDER BY  O.HierarchyCode
			
		</cfquery>
		
			<tr><td colspan="2" style="padding-top:2px;height:25px" class="line labelmedium"><cf_tl id="Cost center">:</td></tr>
						
			<tr><td colspan="2" style="padding-left:2px;padding-top:2px">
						  
			<select name="OrgUnit" id="costcenter" class="regularxl" onchange="reloadalert();" style="width:170px">
			
		     <option value=""><cf_tl id="All"></option>
			 		 
				<cfoutput query="CostUnit">		
				
					<cfset prefix = "">				
				
					<cfloop index="lvl" list="#hierarchycode#" delimiters=".">
						<cfset prefix = "#prefix# . ">				   
					</cfloop>				
					
					<option value="#orgunit#">#prefix##OrgUnitName#</option>	
									
			    </cfoutput>					
			</select>
			
			</td>
			</tr>
			
			<!--- added 19/1/2017 --->
			
			<cfquery name="Program"
			datasource="AppsLedger" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			
				SELECT    ProgramCode, ProgramName
				FROM      Program.dbo.Program PC
				WHERE     ProgramCode IN
				
                           (SELECT    L.ProgramCode
                            FROM      TransactionHeader H INNER JOIN
                                      TransactionLine L ON H.Journal = L.Journal AND H.JournalSerialNo = L.JournalSerialNo
                            WHERE     H.Mission       = '#url.mission#' 
							AND       H.AccountPeriod = '#url.accountperiod#')
							
				ORDER BY ProgramName				
							
			</cfquery>
			
			<tr><td colspan="2" style="padding-top:2px;height:25px" class="labelmedium"><cf_tl id="Program">:</td></tr>
						
			<tr><td colspan="2" style="padding-left:2px;padding-top:2px">
						  
				<select name="Program" id="Program" class="regularxl" onchange="reloadalert();" style="width:170px">
				
			        <option value=""><cf_tl id="Any"></option>			 					
					<cfoutput query="Program">										
						<option value="#ProgramCode#">#ProgramName#</option>										
				    </cfoutput>								
					
				</select>
			
			</td>
			</tr>			
	
	</cfif>	
	
	<tr><td style="height:4px"></td></tr>
	<tr><td colspan="2" class="line"></td></tr>
		
	<cfif url.report eq "pl" or url.report eq "fund">
	
		<tr class="linedotted">														
		<td class="labelmedium"><cf_tl id=" Currency">:<cf_space spaces="20"></td>
		<td class="labelmedium" style="padding-left:5px;height:40px">
		
			<cfquery name="Currency"
					datasource="AppsLedger" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
						SELECT    DISTINCT Currency
						FROM      Journal
						WHERE     Mission       = '#url.mission#' 
					</cfquery>
														
				<select name="Currency" class="regularxl"  onchange="reloadalert();">					   			 		 
					<cfoutput query="Currency">													
						<option <cfif currency eq application.basecurrency>selected</cfif> value="#currency#">#currency#</option>																
				    </cfoutput>					
				</select>
				
		</td>		
				
		</tr>		
						
		<tr><td colspan="2">
		
			<table class="formspacing">
				<tr>
				<td class="labelit">
				   <input type="radio" class="radiol" id="format" name="format" <cfif url.format eq "list">checked</cfif> value="list" onclick="reloadalert('1');document.getElementById('listaggregation').className='regular'">	   
				</td>
				<td class="labelmedium" style="padding-left:3px"><cf_tl id="Report"></td>
				<td class="labelit" style="padding-left:3px">
				   <input type="radio" class="radiol" id="format" name="format" <cfif url.format eq "chart">checked</cfif> value="chart" onclick="reloadalert('1');;document.getElementById('listaggregation').className='hide'">	   
				</td>	
				<td class="labelmedium" style="padding-left:3px"><cf_tl id="Chart"></td>							
				</tr>		
			</table>
		
		</td>
		</tr>	
		
	</cfif>
	
	<tr><td style="height:4px"></td></tr>
	
	<tr>
	
	<td colspan="2" style="padding-top:2px;padding-left:3px;" id="listaggregation">	
	
		<table>		
								
		<!--- horizontal cols --->
		
		<cfquery name="Category"
		datasource="AppsQuery" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT   *
			FROM     Accounting.dbo.Ref_GLCategory
			ORDER BY ListingOrder
		</cfquery>
				
		<tr>		
											
		<TD style="padding-right:4px; width:80%;">
		
		  <table>
		     
			 <tr>
			 	<td>
				
					<cfif url.report eq "pl" or url.report eq "fund">
															
						<cfif Category.recordcount gt "1">
							<cfparam name="URL.lay" default="vertical">
						<cfelse>
							<cfparam name="URL.lay" default="horizontal">	
						</cfif>
						
						<table cellpadding="0" class="formpadding">
						    <tr>
							
							<td>
							<table height="26" width="52" style="border:1px solid silver">
							  <tr>
							  <td height="13" bgcolor="f3f3f3" style="border:1px solid black"></td>					 
							  <td height="13" bgcolor="silver" style="border:1px solid black"></td>
							  </tr>
							</table>
							<td style="padding-left:5px">
							<input type="radio" class="radiol" id="layout" name="layout" <cfif url.lay eq "horizontal">checked</cfif> value="horizontal" onclick="reload('0')"></td>
							
							<td style="padding-left:10px">
							<table height="26" width="86" style="border:1px solid black" border="0">
							  <tr><td bgcolor="f3f3f3">							 
							  <table width="100%" height="100%" cellspacing="0" cellpadding="0">
							  	<tr>
								   <td width="33%" STYLE="border-right:1px solid gray"></td>
								   <td width="33%" STYLE="border-right:1px solid gray"></td>
								   <TD width="33%"></TD>
								</tr>
							  </table>
							  </td></tr>
							  
							  <tr><td bgcolor="silver">
							   <table width="100%" height="100%" cellspacing="0" cellpadding="0">
							  	<tr>
								   <td width="33%" STYLE="border-right:1px solid gray"></td>
								   <td width="33%" STYLE="border-right:1px solid gray"></td>
								   <TD width="33%"></TD>
								</tr>
							  </table>							  
							  </td></tr>
							  
							   <tr><td bgcolor="silver">
							   <table width="100%" height="100%" cellspacing="0" cellpadding="0">
							  	<tr>
								   <td width="33%" STYLE="border-right:1px solid gray"></td>
								   <td width="33%" STYLE="border-right:1px solid gray"></td>
								   <TD width="33%"></TD>
								</tr>
							  </table>
							  
							  </td></tr>

							</table>
							</td>
							<td class="labelit" style="padding-left:5px">
							<input type="radio" class="radiol" id="layout" name="layout" <cfif url.lay eq "vertical">checked</cfif> value="vertical" onclick="reload('0')"></td>
							
						</tr>
						</table>
					
					<cfelse>
					
					    <cfparam name="URL.lay" default="corporate">
												
						<table cellpadding="0" class="formpadding">
						
							<tr class="linedotted">														
							<td class="labelmedium"><cf_tl id=" Currency"></td>
							<td class="labelmedium" style="padding-left:5px;height:40px">
							
								<cfquery name="Currency"
										datasource="AppsLedger" 
										username="#SESSION.login#" 
										password="#SESSION.dbpw#">
											SELECT    DISTINCT Currency
											FROM      Journal
											WHERE     Mission       = '#url.mission#' 
										</cfquery>
																			
									<select name="Currency" class="regularxl"  onchange="reload('1');">					   			 		 
										<cfoutput query="Currency">													
											<option <cfif currency eq application.basecurrency>selected</cfif> value="#currency#">#currency#</option>																
									    </cfoutput>					
									</select>
									
							</tr>		
						    
							<tr>														
							<td><input type="radio" class="radiol" id="layout" name="layout" <cfif url.lay eq "corporate">checked</cfif> value="corporate" onclick="reload('0')"></td>
							<td class="labelmedium" style="padding-left:5px">
							
								<table>
								<tr>
								<td class="labelmedium"><cf_tl id="Corporate"></td>																								
								</tr>								
								</table>	
							
							</tr>
							
							<cfif Parameter.AdministrationLevel eq "parent">
							
							<tr>														
							<td><input type="radio" class="radiol" id="layout" name="layout" <cfif url.lay eq "owner">checked</cfif> value="owner" onclick="reload('0')"></td>
							<td class="labelmedium" style="padding-left:5px">
								<table>
								<tr><td class="labelmedium"><cf_tl id="Owner"></td></tr>
								</table>
							</td>
							</tr>
							
							</cfif>
							
							<tr>														
							<td><input type="radio" class="radiol" id="layout" name="layout" <cfif url.lay eq "period">checked</cfif> value="period" onclick="reload('1')"></td>
							<td class="labelmedium" style="padding-left:5px"><cf_tl id="Running Balances"></td>
							</tr>
							
						</table>
										
					</cfif>
							
				</td>
				
			 
			 </tr>
		  </table>
		
		</TD>
		
		</tr>
					
		<cfif url.report eq "balance">
		
			<tr><td style="padding-top:4px">
			
			<select name="aggregation" id="filter" class="regularxl" size="1" onChange="reload('0')">
			     <OPTION value="total"  <cfif URL.aggregation is "total">selected</cfif>> <cf_tl id="Parent totals"> 
				 <OPTION value="group"  <cfif URL.aggregation is "group">selected</cfif>> <cf_tl id="Group totals"> 
				 <OPTION value="detail" <cfif URL.aggregation is "detail">selected</cfif>> <cf_tl id="Account Details"> 
			</select> 
			
			</td> </tr>
		
		<cfelse>
		
			<tr><td colspan="2" style="height:33px" class="line labelmedium"><b><cf_tl id="Layout"></td></tr>
				
			<tr><td>
			
			<table><tr><td>
			
			<cfquery name="Custom"
				datasource="AppsLedger" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				SELECT     *
				FROM       Ref_StatementAccountUnit
				WHERE      Mission = '#url.mission#'
			</cfquery>		
			
			<cfif custom.recordcount gte "1">
			
				<cfset ht = "150">
				
			<cfelse>
			
				<cfset ht = "118">	
			
			</cfif>
			
			<cfoutput>
			
			<select name="aggregation" style="font-size:13px;width:200px;" id="filter" class="regularxl" onChange="reload('0')">
			
				 <OPTION value="parent"            <cfif URL.aggregation is "parent">selected</cfif>>      <cf_tl id="Class">: [drill]
			     <OPTION value="group"             <cfif URL.aggregation is "group">selected</cfif>>       <cf_tl id="Class">:<cf_tl id="Group">
				 <cfif custom.recordcount gte "1" and url.report eq "pl">
					 <OPTION value="custom"            <cfif URL.aggregation is "custom">selected</cfif>>      <cf_tl id="C">- [<cf_tl id="Custom">] :<cf_tl id="AG">: [drill] 
					 <OPTION value="customcenter"      <cfif URL.aggregation is "customcenter">selected</cfif>>      <cf_tl id="C">- [<cf_tl id="Custom">] :<cf_tl id="Center">: <cf_tl id="AG"> 
				 </cfif>
				 <OPTION value="center"            <cfif URL.aggregation is "center">selected</cfif>>      <cf_tl id="C">-<cf_tl id="Center">:<cf_tl id="AG">		 
				 <OPTION value="groupdetail"       <cfif URL.aggregation is "groupdetail">selected</cfif>> <cf_tl id="C">-<cf_tl id="AG">:<cf_tl id="Account"> 
				 <OPTION value="groupcenter"       <cfif URL.aggregation is "groupcenter">selected</cfif>> <cf_tl id="C">-<cf_tl id="AG">:<cf_tl id="Center"> 
				 <OPTION value="groupcenterdetail" <cfif URL.aggregation is "groupcenterdetail">selected</cfif>> <cf_tl id="C">-<cf_tl id="AG">:<cf_tl id="Center">:<cf_tl id="Account"> 
				 <OPTION value="groupdetailcenter" <cfif URL.aggregation is "groupdetailcenter">selected</cfif>> <cf_tl id="C">-<cf_tl id="AG">:<cf_tl id="Account">:<cf_tl id="Center"> 
				 
			</select> 
			
			</cfoutput>
			
			</td>	
			
			<!---
			
			<td class="labelit" style="padding-left:5px;height:29px"><cf_tl id="Center"></td>
			<td class="labelmedium" style="padding-left:5px;height:29px">
																	
					<input type="checkbox" class="radiol" name="showcenter" id="showcenter" value="yes" class="regularxl" onChange="reloadalert('1');">					   			 		 																				
					
			</td>
			
			--->
			
							
			</tr>
			
			</table>
			
			</td></tr>
		
		</cfif> 
		
		<tr><td style="height:4px"></td></tr>		
		
		</table>		
		
	</td>	
	
	</tr>	
		
	<cfif url.accountperiod neq ""> 
	
		<cfif report eq "pl" or url.report eq "fund">
		
		<tr><td style="height:3px"></td></tr>
			
		<tr>				
		<td style="padding-left:7px" class="labelmedium"><cf_tl id="Valuation">:<cf_space spaces="20"></td>
		<td class="labelmedium" align="right" style="padding-left:5px;height:29px;padding-right:7px">
																
				<select id="mode" name="mode" class="regularxl"  onchange="reloadalert('1');">					   			 		 
																
					<option <cfif url.mode eq "economic">selected</cfif> value="economic"><cf_tl id="Economic"></option>																
					<option <cfif url.mode eq "fiscal">selected</cfif> value="fiscal"><cf_tl id="Fiscal"></option>																
									    					
				</select>
			
				
		</td>
		</tr>	
		
		<tr><td style="height:4px"></td></tr>
				
		
		</cfif>
		
		<tr><td colspan="2" style="padding-left:4px;height:35px" class="line labelmedium"><b><cf_tl id="Period"></td></tr>
			
		<tr><td colspan="2" style="padding-bottom:5px;">
		
			<table class="formspacing">
				<tr>
				
				<td class="labelit" style="padding-left:4px">
				   <input type="radio" class="radiol" id="history" name="history" value="accountperiod" onclick="document.getElementById('boxpostperiod').className='hide';document.getElementById('boxaccountperiod').className='regular'">	   
				</td>
				<td class="labelit" style="padding-left:1px"><cf_tl id="Fiscal Year"></td>
				<td class="labelit" style="padding-left:3px">
				   <input type="radio" class="radiol" id="history" name="history" value="transactionperiod" checked onclick="document.getElementById('boxpostperiod').className='regular';document.getElementById('boxaccountperiod').className='hide'">	   
				</td>	
				<td class="labelit" style="padding-left:1px"><cfoutput>#url.accountperiod#</cfoutput><cf_tl id="PAP"></td>							
				
				</tr>		
			</table>
		
		</td>
		</tr>			
										
		<cfquery name="AccountPeriod"
		datasource="AppsLedger" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT    DISTINCT AccountPeriod
			FROM      TransactionHeader
			WHERE     Mission       = '#url.mission#' 
			AND       AccountPeriod <= '#url.accountperiod#'	
			ORDER BY  AccountPeriod
		</cfquery>
				
		<!--- account period --->
			
		<tr>
		
			<td colspan="2" id="boxaccountperiod" class="hide" style="padding-left:5px">
		
			<table width="100%" cellspacing="0" cellpadding="0">
													
					<cfif report eq "pl" or url.report eq "fund">
					
						<cfoutput query="AccountPeriod">
								
						<tr><td style="padding-left:11px">
						  <input type="checkbox" 
						       style="height:14px;width:14px" 							 
							   name="AccountPeriod" 
							   value="#AccountPeriod#">
						   </td>
						   <td class="labelIT" style="padding-left:3px">#AccountPeriod#</td>
						</tr>
						
						</cfoutput>
						
					<cfelse>
					
						<tr><td style="padding-left:11px;padding-top:4px">
						
							<select class="regularxl" name="AccountPeriod" style="width:90%">							
							<cfoutput query="AccountPeriod">
							<option value="#AccountPeriod#" <cfif recordcount eq currentrow>selected</cfif>>As of #AccountPeriod#</option>
							</cfoutput>							
							
							</select>
												
						   </td>
						 
						</tr>
						
					</cfif>
								
			</table>			
			
		</td>
		
		</tr>
		
		<cfif report eq "pl" or url.report eq "fund">
						
			<cfquery name="Period"
			datasource="AppsLedger" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				SELECT    DISTINCT L.TransactionPeriod
				FROM      TransactionHeader H,TransactionLine L
				WHERE     H.Mission       = '#url.mission#' 
				AND       H.AccountPeriod = '#url.accountperiod#'	
				AND       H.Journal         = L.Journal
				AND       H.JournalSerialNo = L.JournalSerialNo
				AND       H.RecordStatus    = '1'
				AND       H.ActionStatus IN ('0','1')				
				ORDER BY  L.TransactionPeriod
			</cfquery>
			
		<cfelse>		
		
			<cfquery name="Period"
			datasource="AppsLedger" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				SELECT    DISTINCT TransactionPeriod
				FROM      TransactionHeader
				WHERE     Mission       = '#url.mission#' 
				AND       AccountPeriod = '#url.accountperiod#'	
				AND       RecordStatus    = '1'
				AND       ActionStatus IN ('0','1')
				ORDER BY  TransactionPeriod
			</cfquery>
		
		
		</cfif>
		
		<!--- posting period --->
	
		<tr>
		    <td colspan="2" id="boxpostperiod" class="regular" style="padding-left:5px">
		
				<table cellspacing="0" cellpadding="0" class="formspacing">
							
				<tr><td colspan="2" class="linedotted"></td></tr>
				
				<cfset row = 0>
				
				<cfoutput query="Period">
				
					<cfif report eq "balance">
											
						<tr><td align="left" style="padding-left:28px">
						
					  		<input type="radio" 						       
						   		style="height:15px;width:15px" 
						   		checked 
						   		name="TransactionPeriod" 
						   		value="'#TransactionPeriod#'">
					   		</td>
					   		<td class="labelit" style="height:18px;padding-left:5px">#TransactionPeriod#</td>
						</tr>							
													
					<cfelse>
					
						<cfset row = row+1> 
						
						<cfif row eq "1"><tr></cfif>						
						
						  <td style="padding-left:5px">
						  <input type="checkbox" 
						       style="height:14px;width:14px" 
							   checked 
							   name="TransactionPeriod" 
							   value="'#TransactionPeriod#'">
						   </td>
						   <td class="labelit" style="font-size:14px;height:18px;padding-left:5px;padding-right:6px">#TransactionPeriod#</td>
						<cfif row eq "2">  
						</tr>
						<cfset row = "0">
						</cfif>
					
					</cfif>
					
				</cfoutput>
				
				</table>
				
			</td>
		</tr>
						
		<tr><td colspan="2" align="center" style="padding-top:3px"></td></tr>	
		<tr><td colspan="2" class="line"></td></tr>	
		<tr><td colspan="2" align="center" style="padding-top:7px">
			
			<cf_tl id="Apply" var="tApply">
			<cfoutput>
			<input type="button" class="button10g" name="Apply" value="#tApply#" onclick="reload('2')" style="width:140px;height:35px;font-size:15px">
			</cfoutput>
			
		</td></tr>
				
	</cfif>  
	
</table>

<script language="JavaScript">
   if (document.getElementById('alertme')) {
	    reloadalert()
   }
</script>

	