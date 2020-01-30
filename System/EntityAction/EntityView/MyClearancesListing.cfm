
<cfparam name="URL.EntityCode"  default="">

<cfparam name="URL.Mission"     default="">
<cfparam name="URL.Owner"       default="">
<cfparam name="URL.EntityGroup" default="">
<cfparam name="URL.Me"          default="false">

<cfparam name="tot" default="0">
			
	<cftransaction isolation="READ_UNCOMMITTED">
	
	<cfquery name="ResultListing" 
		 datasource="AppsOrganization"
		 username="#SESSION.login#" 
		 password="#SESSION.dbpw#">
			 SELECT     *
			 FROM       userQuery.dbo.#SESSION.acc#Action  			 
		</cfquery>
		
			
		<cfquery name="ResultListing" 
		 datasource="AppsOrganization"
		 username="#SESSION.login#" 
		 password="#SESSION.dbpw#">
			 SELECT     OA.ActionId,
			            E.EntityCode, 
			            E.EntityDescription,
						P.ActionLeadTime, 
						P.ActionTakeAction,
						O.EntityGroup,
						O.Mission,
						O.Owner,
						M.Description,
						A.Description as Application,
						(CASE WHEN O.ObjectDue is not NULL 
					      THEN CONVERT(int,getDate()-ObjectDue)
						  ELSE CONVERT(int,getDate()-DateLast) END) as Due
			 FROM       OrganizationObjectAction OA 
			            INNER JOIN    OrganizationObject O                 ON OA.ObjectId  = O.ObjectId 
						INNER JOIN    userQuery.dbo.#SESSION.acc#Action D  ON OA.ActionId  = D.ActionId 
						INNER JOIN    Ref_Entity E                         ON O.EntityCode = E.EntityCode 
						INNER JOIN    Ref_EntityActionPublish P            ON OA.ActionPublishNo = P.ActionPublishNo AND OA.ActionCode = P.ActionCode 
						INNER JOIN    Ref_AuthorizationRole S              ON E.Role = S.Role
						INNER JOIN    System.dbo.xl#Client.LanguageId#_Ref_SystemModule M ON M.SystemModule = S.SystemModule
						INNER JOIN    System.dbo.Ref_ApplicationModule AM ON AM.SystemModule = M.SystemModule
						INNER JOIN    System.dbo.Ref_Application A ON A.Code = AM.Code AND Usage = 'System'
			 WHERE      P.EnableMyClearances = 1 
			  AND       O.ObjectStatus = 0
			  AND       O.Operational = 1  
			  AND       E.ProcessMode != '9'		
			  <!--- hide concurrent actions that were completed --->
			  AND       OA.ActionStatus != '2'		  
			 ORDER BY   A.ListingOrder,S.SystemModule,E.ListingOrder,E.EntityCode 
			 
		</cfquery>
				
	</cftransaction>		
			
	<cfquery name = "SearchResult" dbtype="query">
		SELECT * 
		FROM   ResultListing	
		WHERE  1=1
	    <cfif URL.EntityGroup neq "">
		  	AND EntityGroup = '#URL.EntityGroup#'
	    </cfif>
	    <cfif URL.Mission neq "">
		  	AND Mission = '#URL.Mission#'
	    </cfif>
	    <cfif URL.Owner neq "">
		  	AND Owner = '#URL.Owner#'
	    </cfif>		
	</cfquery>
	
	<cf_verifyOperational 
	         datasource= "AppsOrganization"
	         module    = "Procurement" 
			 Warning   = "No">
	
	<cfquery name="Roles" 
	 datasource="AppsOrganization"
	 username="#SESSION.login#" 
	 password="#SESSION.dbpw#">
		SELECT   *
		FROM     Ref_AuthorizationRole
		WHERE    Role IN ('ProcReqCertify','ProcReqObject','ProcReqReview','ProcReqApprove','ProcReqBudget','ProcManager','ProcBuyer')	
		<cfif operational eq 0>
			AND 1=0
		</cfif>	
		ORDER BY ListingOrder
	</cfquery>	
	
	<cfif operational>
				
			<cfloop query="Roles">
				<cfinvoke component = "Service.PendingAction.Check"  
				   	method           = "#Role#"
				   	returnvariable   = "rCheck_#Role#">
			</cfloop>
		
	</cfif>	
	
<!--- save the client variable --->

<cfset SESSION.MyClear= quotedValueList(SearchResult.ActionId)>

<table width="100%" height="99%" class="navigation_table" style="padding-left:30px;padding-right:20px">

<cfif SearchResult.recordcount eq "0">
	  <cfset cl = "green">
	<cfelse>
	  <cfset cl = "red">   
	</cfif>

<cfif url.mode eq "">
	
	<cfoutput>
		
	<tr>
			
	<td colspan="5" class="labellarge" id="summary" style="background-color:f4f4f4;width:100%;border-bottom:1px solid silver;padding-left: 18px; font-size: 23px; height: 35px; padding-top: 6px; padding-bottom: 4px;">
	
		<cfoutput>
	
		<table align="center">
			<tr class="labelit">		
			    <td>					
					<img style="" src="#SESSION.root#/Images/Pending-Actions.png" width="48" height="48">
			   </td>			
				<td style="padding-left:6px;font-size:21px;font-weight:200"><cfif SearchResult.recordcount eq "0"><cf_tl id="No"><cfelse><font color="#cl#">#SearchResult.recordcount#</font></cfif></td>
				<td style="padding-left:6px;font-size:21px;font-weight:200">
					<cfif SearchResult.recordcount eq "1">
					      <cf_tl id="action">
					<cfelse>
					      <cf_tl id="actions">
				    </cfif>
					<cf_tl id="and">
				</td>
				<td id="batch" style="font-weight:200;padding-left:6px;font-size:24px;padding-right:6px;"></td>	
			</tr>
		</table>
		
		</cfoutput>
		
	</td>
	
	</tr>
			
		<tr class="line">
				
			<td colspan="5" align="left" style="padding:3px 0 3px 30px;">
			
				<cfif ResultListing.recordcount gte "0">
					
					<table>		
					
					<tr class="labelmedium" style="margin-bottom: 10px; display: block;">
										
					 <td style="font-size:18px;min-width:80px;padding-left:15px"><font color="D50000"><cf_tl id="Filter">:</td>
							
				     <td class="hide" style="padding-left:2px">			 
					 
					 	<!--- for now hidden 16/8/2014 --->			 
						 <table>
						 <tr>
						 <td>
						 			 
						 <cfparam name="URL.Search" default="">
						 					 
						 <input type="text" name="find" id="find" size="10" style="padding-left:5px;padding:2px"
						   value="#URL.search#"
						   onKeyUp="javascript:search()"
					       maxlength="25"
					       class="regularxl">
						   
						  </td>
						  
						  <td width="28" align="center" style="padding-left:4px;padding-top:4px">
						  
						   <img src="#SESSION.root#/Images/locate2.gif" 
							  alt    = "Search" 
							  name   = "locate" 
							  onMouseOver= "document.locate.src='#SESSION.root#/Images/button.jpg'" 
							  onMouseOut = "document.locate.src='#SESSION.root#/Images/locate2.gif'"
							  style  = "cursor: pointer;" 				 
							  border = "0" height="13" width="13"
							  align  = "absmiddle" 
							  onclick="searching(document.getElementById('find').value)">
							  
						</td>		
						</tr>
						</table>	
					
					   </td>
						
					  	<cfquery name="qMission" dbtype="Query">
							SELECT DISTINCT Mission
							FROM   ResultListing
							WHERE  Mission IS NOT NULL
							<cfloop query="Roles">
								UNION
								SELECT DISTINCT Mission
								FROM rCheck_#Role# 
							</cfloop>						
							ORDER BY Mission
						</cfquery>						
																		
						<td style="padding-left:10px;padding-top:4px">
						
							<select id="sMission" name="sMission" class="regularx" onchange="doRefresh(document.getElementById('sEntityGroup').value,this.value,document.getElementById('sOwner').value,document.getElementById('sUser').checked)">
								<option value="" <cfif url.EntityGroup eq "">selected</cfif>>All Entities</option>
								<cfloop query="qMission">
									<option value="#qMission.Mission#" <cfif url.Mission eq qMission.Mission>selected</cfif>>#qMission.Mission#</option>
								</cfloop>
							</select>
						</td>
									
					  	<cfquery name="qEntityGroup" dbtype="Query">
							SELECT DISTINCT EntityGroup
							FROM   ResultListing
							WHERE  EntityGroup IS NOT NULL AND EntityGroup !=''
							ORDER BY EntityGroup
						</cfquery>
						
						<td width="1%" class="labelmedium" style="padding-left:40px;font-size:18px;min-width:230px"><font color="D50000">
                            <cf_tl id="Explicitly set for me" var="1">
                            #trim(lt_text)# :
                        </td>
						<td>						
							<input type="checkbox" 
							 id="sUser" name="sUser" <cfif url.me eq "true">checked</cfif> value="1" 
							 onclick="doRefresh(document.getElementById('sEntityGroup').value,document.getElementById('sMission').value,document.getElementById('sOwner').value,this.checked)" class="radiol">
						</td>
													
						<td width="5%" style="font-size:18px;min-width:140px;padding-left:15px"><font color="D50000">
                                <cf_tl id="Workgroup" var="1">
                                #trim(lt_text)# :
                        </td>				
						<td width="10%">
							
							<cfif qEntityGroup.recordcount gt 1>
						
							<select id="sEntityGroup" name="sEntityGroup" class="regularx" onchange="doRefresh(this.value,document.getElementById('sMission').value,document.getElementById('sOwner').value,document.getElementById('sUser').checked)">
								<option value="" <cfif url.EntityGroup eq "">selected</cfif>>All</option>
								<cfloop query="qEntityGroup">
									<option value="#qEntityGroup.EntityGroup#" <cfif url.EntityGroup eq qEntityGroup.EntityGroup>selected</cfif>>#qEntityGroup.EntityGroup#</option>
								</cfloop>
							</select>	
							
							<cfelse>
							<cf_tl id="n/a">
							<input type="hidden" id="sEntityGroup" name="" value="">	
							
							</cfif>			
						</td>					
												
					  	<cfquery name="qOwner" dbtype="Query">
							SELECT DISTINCT Owner
							FROM ResultListing
							WHERE Owner IS NOT NULL
							ORDER BY Owner
						</cfquery>
						
						<cfif qOwner.recordcount gt 1>
										
							<td align="right" style="padding-left:8px;padding-right:4px">
                                <cf_tl id="Owner" var="1">
                                #trim(lt_text)# :
                            </td>				
							<td>
						
							<select id="sOwner" name="sOwner" class="regularx" onchange="doRefresh(document.getElementById('sEntityGroup').value,document.getElementById('sMission').value,this.value)">
								<option value="" <cfif url.Owner eq "">selected</cfif>>All</option>
								<cfloop query="qOwner">
									<option value="#qOwner.Owner#" <cfif url.Owner eq qOwner.Owner>selected</cfif>>#qOwner.Owner#</option>
								</cfloop>
							</select>				
							</td>					
						<cfelse>
							<input type="hidden" id="sOwner" name="sOwner" value="">					
						</cfif>		
						
						<cfif getAdministrator("*") eq "1">
						<td width="25%" align="right" style="padding-left:15px;">
						 <a href="javascript:entity()"><cf_tl id="All"></a>
						</td>
						</cfif>				
					
					</tr>
					
				    </table>	
					
				 </cfif>	  
							
			</td> 	   
					      
		</tr>	
		
		</cfoutput>
		
	<cfelse>
	
		<tr>
				
		<td colspan="5" class="labellarge" id="summary" style="background-color:f4f4f4;width:100%;border-bottom:1px solid silver;padding-left: 18px; font-size: 23px; height: 35px; padding-top: 6px; padding-bottom: 4px;">
		
			<cfoutput>
		
			<table align="center">
				<tr class="labelit">		
				    <td>					
						<img style="" src="#SESSION.root#/Images/Pending-Actions.png" width="48" height="48">
				   </td>			
					<td style="padding-left:6px;font-size:21px;font-weight:200"><cfif SearchResult.recordcount eq "0"><cf_tl id="No"><cfelse><font color="#cl#">#SearchResult.recordcount#</font></cfif></td>
					<td style="padding-left:6px;font-size:21px;font-weight:200">
						<cfif SearchResult.recordcount eq "1">
						      <cf_tl id="action">
						<cfelse>
						      <cf_tl id="actions">
					    </cfif>
						<cf_tl id="and">
					</td>
					<td id="batch" style="font-weight:200;padding-left:6px;font-size:24px;padding-right:6px;"></td>	
				</tr>
			</table>
			
			</cfoutput>
			
		</td>
		
		</tr>
	
		<input type="hidden" id="sMission" name="sMission" value="">	
		<input type="hidden" id="sEntityGroup" name="sMission" value="">	
		<input type="hidden" id="sOwner" name="sOwner" value="">
		
	</cfif>
	
	<tr class="line">
		
		<td style="padding-left:20px" colspan="5" id="quickfilter" class="hide">
		
		   	<cf_space spaces="80">
			
			<cf_tl id="Filter result by keyword" var="1">
					
			<cfinvoke component = "Service.Presentation.TableFilter"  
				   method           = "tablefilterfield" 
				   filtermode       = "direct"
				   name             = "filter"
				   label            = "#lt_text#"
				   style            = "font-size::18px;height:28;width:120"
				   rowclass         = "clsRow"
				   rowfields        = "ccontent">						
										
		</td>
	
	</tr>		
	
	<tr><td colspan="5" height="100%" align="center" style="padding-right:10px">
					
		<cf_divscroll style="padding-right:15px" overflowy="scroll">
						
		<table width="96%">
				
		<cfoutput>
		
		<input type="hidden" name="row"   id="row"    value="0">
		<input type="hidden" name="total" id="total"  value="#SearchResult.recordcount#">
			
		</cfoutput>
		
		<!--- inquiry search result --->
		<tr class="hide"><td id="result" name="result" align="center" colspan="7" ></td></tr>
		
		<cfset prior = "">	
		<cfset priorapp = "">	
		
		<cfoutput query="SearchResult" group="EntityCode">
		
		<cfif Application neq priorapp>
			  <tr><td class="labellarge" colspan="4" style="font-weight:200;padding-top:10px;height:59px;padding-left:19px;font-size:26px">#Application#</td></tr>
		</cfif>
			  
		<tr class="navigation_row labelmedium" style="height:22px">  
		  	
		<td class="navigation_action" bgcolor="white" style="font-size:17px;padding-left:40px" onClick="more('#EntityCode#','','#url.me#')"></td>	
			
		<td class="line" onClick="more('#EntityCode#','','#url.me#')" style="min-width:30px;padding-left:4px">
				   
				<img src="#SESSION.root#/Images/Step-Down.png" alt="Expand" 
		            onMouseOver="document.#EntityCode#Exp.src='#SESSION.root#/Images/Step-Down.png'" 
				    onMouseOut="document.#EntityCode#Exp.src='#SESSION.root#/Images/Step-Down.png'"
					name="#EntityCode#Exp" id="#EntityCode#Exp" border="0" class="show" height="18" width="18"
					align="absmiddle" style="cursor: pointer;">
					
				<img src="#SESSION.root#/Images/Step-Up.png" 
					onMouseOver="document.#EntityCode#Min.src='#SESSION.root#/Images/Step-Up.png'" 
				    onMouseOut="document.#EntityCode#Min.src='#SESSION.root#/Images/Step-Up.png'"
					name="#EntityCode#Min" id="#EntityCode#Min" alt="Collapse" border="0" height="18" width="18"
					align="absmiddle" class="hide" style="cursor: pointer;">
								
			</td>
			
			<td class="line" width="60%"><cf_tl id="#EntityDescription#"></td>		
			<td class="line" align="right" width="45%" id="#entitycode#summary" name="#entitycode#summary">
			
			<cf_space spaces="30">
			
			<cfquery name="Total" dbtype="query">
				SELECT     *
				FROM       SearchResult
				WHERE      EntityCode = '#EntityCode#'
			</cfquery>			 
			
			<font color="002350">
			#Total.Recordcount#
			
			<cfquery name="Overdue"
			  dbtype="query">
				SELECT count(*)
				FROM   SearchResult
				WHERE  EntityCode = '#EntityCode#'
				AND    due > ActionLeadTime+5 
			</cfquery>		
			
			(&nbsp;#Overdue.recordcount#&nbsp;|&nbsp;<font color="FF0000">#Total.Recordcount-Overdue.recordcount#</font>&nbsp;)
			
			</td>
		
		</tr>	
		
		<!--- content --->
				
		<tr class="hide" id="#EntityCode#" name="#EntityCode#">
			
			<td colspan="7" align="center" style="background-image:url('#SESSION.root#/Images/clearances_bg.png'); background-repeat:repeat-x">
			
				<table width="95%" height="100%" border="0">					
					<tr>
						<td colspan="2">				
							<table height="100%" width="100%" cellspacing="0" cellpadding="0">
								<tr><td style="padding-left:45px;"><cfdiv id="c#EntityCode#"></td></tr>
							</table>
						</td>
						
					</tr>
					
				</table>
			</td>
			
		</tr>	
		
		<cfset priorapp = application>
			
		<cfif Description neq prior>
			<cfset prior = description>
			<tr><td colspan="5" height="0" bgcolor="ffffff"></td></tr>			
		<cfelse>
			<tr><td></td><td colspan="4" height="0" bgcolor="ffffff"></td></tr>		
		</cfif>
			
		</cfoutput>
		
		<!--- --------- --->		
		<!--- GL Record --->
		<!--- --------- --->
		
						 
		<cfif Operational eq "1"> 	 
				
		<!--- removed : ,'ProcReqEntry' --->
		
			<cfif Roles.recordcount gte "1">
				
				<tr><td height="15"></td></tr>
				
				<tr id="batchbox" class="xhide"><td colspan="4" style="font-weight:200;padding-left:12px;height:50;font-size:29px" height="39" width="287" class="labellarge">
				   <cf_tl id="Supply Chain clearances">
				   </td></tr>
				<tr><td colspan="5" class="line"></td></tr>   
				
				<tr><td height="7"></td></tr>
				
				<cfset md = "">
				<cfset tot = 0>
			
				<cfoutput query="Roles">
				       		
						<cfif md neq Roles.SystemModule>			
							
							<!---
							<tr><td colspan="7" height="1px" style="padding-top:3px;padding-bottom:3px;" class="linedotted"></td></tr>
							--->
							
							<cfset md = Roles.SystemModule>
						
						</cfif>			
				
						  	<cfquery name="qBatchResult" dbtype="Query">
								SELECT *
								FROM rCheck_#Role#
								<cfif URL.Mission neq "">
									WHERE Mission = '#URL.Mission#'
								</cfif>
							</cfquery>
										
							<cfif qBatchResult.recordcount gte "1">
											   							
								<tr bgcolor="white" class="linedotted">
							        			
								<td width="40%" align="left" valign="top" style="padding-left:25px;padding-top:4px" colspan="3" class="labellarge">									
								<cfif Roles.RoleTask neq "">
									#Roles.RoleTask#
								<cfelse>
									#Roles.Description# 
								</cfif>			
								<cf_space spaces="60">
								
								</td>
								
								<td width="60%" align="right" colspan="4" height="40" id="#roles.role#box">
																		
										<table border="0" cellspacing="0" cellpadding="0">
										
										    <cfset cnt = 0>
																		
											<cfloop query="qBatchResult">
										
											<cfset cnt = cnt+1>
											
											<cfif roles.role eq "procreqreview" or roles.role eq "procreqapprove" or roles.role eq "procreqbudget">
												<cfset template = "RequisitionClear">
											<cfelseif roles.role eq "procreqcertify">	
												<cfset template = "RequisitionCertify">	
											<cfelseif roles.role eq "procreqobject">	
												<cfset template = "RequisitionFunding">
											<cfelseif roles.role eq "procmanager">	
												<cfset template = "RequisitionBuyer">
											</cfif>
											
											<tr class="hide"><td id="button_#lcase(roles.role)#" 
											   onclick="cf_loadingtexthtml='';ColdFusion.navigate('#SESSION.root#/system/entityaction/entityview/MyClearancesBatch.cfm?role=#roles.role#','#roles.role#box')"></td>
											    </td>
											</tr>
																
											<cfif cnt eq "1">	
											
											    <cfif roles.role eq "ProcBuyer">
												<tr class="navigation_row labelmedium" style="cursor: pointer;" 
												onClick="#lcase(roles.role)#('#mission#','#period#','#lcase(roles.role)#')">
												<cfelse>
												<tr class="navigation_row labelmedium" style="cursor: pointer;" 
												onClick="procbatch('#mission#','#period#','#lcase(roles.role)#','#template#')">									
												</cfif>
												
											</cfif>	   
											   		<td bgcolor="white" >			
														<cf_space spaces="10">
													</td>
															  
													<td width="20" align="center" style="cursor: pointer">					  
														<cf_space spaces="5">	
														
														<cf_assignid>  
														
											  	  			<img src="#SESSION.root#/Images/contract.gif" alt="" name="img0_#left(rowguid,8)#" 
													  			onMouseOver="document.img0_#left(rowguid,8)#.src='#SESSION.root#/Images/button.jpg'" 
													  			onMouseOut="document.img0_#left(rowguid,8)#.src='#SESSION.root#/Images/contract.gif'"
													  			style="cursor: pointer" alt="" width="13" height="14" border="0" align="absmiddle">	  	
																  
											  		</td>
													
													<td><cf_space spaces="18" class="labelmedium" label="#Mission#"></td>			
											  		<td><cf_space spaces="15" class="labelmedium" label="#Period#"></td>	 
											   		<td style="padding-right:4px"><cf_space align="right" class="labelmedium" color="red" spaces="8" label="#Total#"></td>	  		
													
													<cfset tot = tot + total>
													
											<cfif cnt eq "1">  
												</tr>	
											<cfset cnt = 0>
											</cfif>	
											</cfloop>									
										
										</table>
										
										
						
								</td>
										
							</tr>	
										
							</cfif>	   
							
					</cfoutput>		
					
			</cfif>	
				
		</cfif>		
				
		</table>			
	
		</cf_divscroll>	
	
	</td></tr>	
	
</table>

<cfoutput>
<input type="hidden" id="batchtotal" value="#tot#">
</cfoutput>

<!--- set the data for the other actions, prevent we have to run the  again --->
<cfset ajaxonload("doSummary")>	
<cfset ajaxonload("doHighlight")>

<!--- connection object --->

<!-- objectain the system functionid --->

<cfquery name="get" 
 datasource="AppsSystem"
 username="#SESSION.login#" 
 password="#SESSION.dbpw#">
	SELECT   TOP 1 * 
	FROM     Ref_ModuleControl					
</cfquery>	

<cfinvoke component = "Service.Connection.Connection"  
   method           = "setconnection"   
   object           = "actioncenter"
   scopeid          = "#get.SystemFunctionid#"   
   objectcontent    = "#Roles#"  
   delay            = "40">	  
   
<!--- button to be clicked once it was determined that underlying data for this user has changed --->    

<cfoutput>   

<input type="hidden" id="actioncenter_refresh" onclick="_cf_loadingtexthtml='';ColdFusion.navigate('#SESSION.root#/System/EntityAction/EntityView/getSummary.cfm','summary')">  

</cfoutput> 
