
<cfparam name="attributes.panel"       default="debit">
<cfparam name="attributes.aggregation" default="group">
<cfparam name="attributes.showperiod"  default="0">
<cfparam name="attributes.periodlist"  default="">
<cfparam name="attributes.fileno"      default="1">

<!--- source data--->

<cfquery name="PanelData"
	datasource="AppsQuery" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT   *
		FROM     #SESSION.acc#PL#attributes.FileNo#
		WHERE    Panel = '#attributes.panel#'
		<cfif Aggregation eq "Parent" 
		      or Aggregation eq "Group" 
		      or Aggregation eq "GroupDetail" 
			  or Aggregation eq "GroupDetailCenter">
		ORDER BY AccountParent, 
		         AccountGroupOrder, 
				 AccountGroup, 
		         <cfif attributes.panel eq "Debit"> AccountType DESC, <cfelse>AccountType ASC,</cfif>
			     GLAccount, 
				 OrgUnitHierarchy
		<cfelseif Aggregation eq "Center">
		ORDER BY AccountParent, 
		         OrgUnitHierarchy, 
				 AccountGroupOrder, 
				 AccountGroup, 
				 GLAccount	
		<cfelseif Aggregation eq "Custom"> 		
		ORDER BY AccountParent, 
		         StatementOrder, 
				 AccountGroupOrder, 
				 AccountGroup, 
				 GLAccount	 
		<cfelseif Aggregation eq "CustomCenter"> 		
		ORDER BY AccountParent, 
		         StatementOrder, 
				 OrgUnitHierarchy, 
				 AccountGroupOrder, 
				 AccountGroup, 
				 GLAccount
		<cfelseif Aggregation eq "GroupCenter" or Aggregation eq "GroupCenterDetail">
		ORDER BY AccountParent, 
		         AccountGroupOrder, 
				 AccountGroup, 
				 OrgUnitHierarchy, 
				 GLAccount
		</cfif>
</cfquery>

<cfoutput>

	<!--- ---------- --->
	<!--- total line --->
	<!--- ---------- --->

	<cfset stl = "border:1px solid silver;padding-right:3px">
	
	<tr bgcolor="E6F2FF" style="border-top:0px solid silver" class="navigation_row fixlengthlist fixrow labelmedium2">	
		  		  		  
		  <td colspan="2" style="min-width:200px;border:1px solid silver;padding-left:14px;font-weight:bold;padding-bottom:4px;padding-top:2px;font-size:24px">
		  		  
		  <cfif attributes.panel eq "Credit">
		     <cf_tl id="Income"> 
		  <cfelse>
		  	 <cf_tl id="Operating costs">
		  </cfif> 
		 
		  </td>
		 
		  <cfif attributes.showperiod eq "1">
		 
			   <cfloop index="per" list="#attributes.periodlist#" delimiters=",">
			   
			   	    <!--- source data--->
					<cfquery name="Data"
					datasource="AppsQuery" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
						SELECT  SUM(#attributes.panel#) as Total
						FROM    #SESSION.acc#PL#attributes.FileNo#
						
						<cfif attributes.history eq "TransactionPeriod">
						WHERE   TransactionPeriod = '#per#'	
						<cfelse>
						WHERE   AccountPeriod     = '#per#'	
						</cfif>
						
						AND     Panel = '#attributes.panel#'
					</cfquery>
				
				<td align="right" style="#stl#">
				<font color="808080">
				<cfif data.total lt 0>
			    <font color="FF0000">#NumberFormat(evaluate("Data.Total"),'(,____)')#</font>
				<cfelse>
				#NumberFormat(evaluate("Data.Total"),',____')#
				</cfif>
				</font></td>
				
			   </cfloop>
		   
		  </cfif>
			  
		  <cfquery name="Data"
			datasource="AppsQuery" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				SELECT  SUM(#attributes.panel#) as Total
				FROM    #SESSION.acc#PL#attributes.FileNo#
				WHERE   Panel = '#attributes.panel#'
		  </cfquery>									
			  	
		  <td class="labellarge" align="right" style="#stl#">
			  <cfif data.total lt 0>
		      <font color="FF0000">#NumberFormat(evaluate("Data.Total"),'(_,____)')#</font>
			  <cfelse>
			  #NumberFormat(evaluate("Data.Total"),'_,____')#
			  </cfif>			  
			  </font>
		  </td>
			
	 </tr>		
	 
</cfoutput>	 

<cfoutput query="PanelData" group="AccountParent">

	<!--- Provision to toggle the parent --->
	<cfset pAccountParentId = trim(replace(AccountParent, " ", "", "ALL"))>
	
	<cfif attributes.aggregation eq "Parent">			
		<cfset pDetailVisible = "display:none;">
	<cfelse>
		<cfset pDetailVisible = "">	
	</cfif>

	<!--- 
	<cfif attributes.aggregation neq "Parent">
	<tr><td height="14"></td></tr>
	<cfelse>	
	</cfif>
	--->
	
    <tr style="border-bottom:1px solid silver; cursor:pointer;" class="labelmedium2" onclick="toggleSection('.clsParentDetail_#attributes.panel#_#pAccountParentId#');">
	   	   
	   		<cfif attributes.aggregation eq "Parent">					
			 
			  <cfset bold = "">
			  <cfset pCollapse = true>
			  <cfset stl = "border:0px solid silver;padding-right:3px">
			  <td bgcolor="ffffff" colspan="2" style="padding-left:10px;height:34px"><font color="gray">#AccountParent# #AccountParentDescription#</td>
			  				  						 
		   <cfelse>			
			 
			  <cfset bold = "<b>">
			  <cfset pCollapse = false>
			  <cfset stl = "border:1px solid silver;padding-right:3px;border-radius:4px">
			  <td bgcolor="ffffff" colspan="2" style="padding-left:10px;height:34px"><font color="gray">#AccountParent# #AccountParentDescription#</td>
				  						  
		   </cfif>		
						
	 		<cfif attributes.showperiod eq "1">
			 
				   <cfloop index="per" list="#attributes.periodlist#" delimiters=",">
				   
				   	  <!--- source data--->
					  <cfquery name="Data"
					   datasource="AppsQuery" 
					   username="#SESSION.login#" 
					   password="#SESSION.dbpw#">
						SELECT  sum(#attributes.panel#) as Total
						FROM    #SESSION.acc#PL#attributes.FileNo#
						WHERE   AccountParent  = '#AccountParent#'
						<cfif attributes.history eq "TransactionPeriod">
						AND     TransactionPeriod = '#per#'	
						<cfelse>
						AND     AccountPeriod     = '#per#'	
						</cfif>
						AND     Panel = '#attributes.panel#'
					  </cfquery>
				   			
					<td class="labellarge" align="right" style="#stl#">
							<font color="808080">		
								
							<cfif data.total eq "">
								-
							<cfelse>
							
								<cfif data.total lt 0>
							    <font color="FF0000">#bold##NumberFormat(evaluate("Data.Total"),',__')#</font>
								<cfelse>
								#bold##NumberFormat(evaluate("Data.Total"),',__')#
								</cfif>
							
							</cfif>
							
							</font>
					</td>
					
				   </cfloop>
			   
			</cfif>
			  
			<!--- source data--->
			
			<cfquery name="Data"
			   datasource="AppsQuery" 
			   username="#SESSION.login#" 
			   password="#SESSION.dbpw#">
					SELECT  SUM(#attributes.panel#) as Total
					FROM    #SESSION.acc#PL#attributes.FileNo#
					WHERE   AccountParent  = '#AccountParent#'		
					AND     Panel          = '#attributes.panel#'		
			</cfquery>
			 			  	
			<td class="labellarge" bgcolor="eaeaea" align="right" style="#stl#">
			  	  
				  <cfif data.total lt 0>
				  <font color="FF0000">#bold##NumberFormat(evaluate("Data.Total"),',__')#</font>
				  <cfelse>
			   	  #bold##NumberFormat(evaluate("Data.Total"),',__')#
				  </cfif>
				  
			</td>		
			  
		  </tr>			
		  
		   <cfif attributes.aggregation eq "Parent"
		          or attributes.aggregation eq "Group" 
				  or attributes.aggregation eq "Center"
				  or attributes.aggregation eq "Custom">				
			 
			  <cfset size = "14">
			 				  						 
		   <cfelse>
		   		   			
			  <cfset size = "16">
							  						  
		   </cfif>					   
			
		   <cfif left(Aggregation,6) neq "Center" and left(Aggregation,6) neq "Custom">	
		   
			   	<!--- ----------- --->
				<!--- Group level --->
				<!--- ----------- --->		
			
				<cfoutput group="AccountGroupOrder">
		
					<cfoutput group="AccountGroup">	
					
						<!--- account group --->								
						
						<cf_PLViewDataContent 
									Panel        = "#attributes.Panel#" 
									History      = "#attributes.History#"									
									ShowPeriod   = "#attributes.showPeriod#"
									PeriodList   = "#attributes.PeriodList#"
									FileNo       = "#attributes.FileNo#"
									Visible      = "#pDetailVisible#" 
									BaseId       = "#attributes.panel#_#pAccountParentId#"										
									fontsize     = "#size#"																									
									GroupField   = "AccountGroup"
									GroupValue   = "#AccountGroup#"
									GroupName    = "#AccountGroupDescription#"
									Filter1Field = "AccountParent"
									Filter1Value = "#AccountParent#">												
																	
						<cfif Aggregation eq "Parent" 					      
						  or Aggregation eq "Group" 
					      or Aggregation eq "GroupDetail" 
						  or Aggregation eq "GroupDetailCenter">
						  
						   <cfoutput group="GLAccount">	
						   													    
							<cfif attributes.aggregation eq "GroupDetailCenter">
											
								  <cfset stl = "border-bottom:1px solid silver;padding-right:3px;border-radius:4px">									 
								  <cfset bold = "">
									  									  						 
							<cfelse>
							
								  <cfset stl = "border-bottom:1px solid silver;padding-right:3px;0px;">										  
								  <cfset bold = "">
									  									  						  
							</cfif>		
							
							<cfif Aggregation eq "Parent" or Aggregation eq "Group">
								<cfset vDetailVisible = "display:none;">
							<cfelse>	
							    <cfset vDetailVisible = "">
							</cfif>
							
							<cfset vAccountGroupId = trim(replace(AccountGroup, " ", "", "ALL"))>	
																			   
						   	<cf_PLViewDataContent 
									Panel        = "#attributes.Panel#" 
									History      = "#attributes.History#"									
									ShowPeriod   = "#attributes.showPeriod#"
									PeriodList   = "#attributes.PeriodList#"
									FileNo       = "#attributes.FileNo#"
									BaseId       = "#attributes.panel#_#pAccountParentId#_#vAccountGroupId#"	
									Visible      = "#vDetailVisible#" 
									ContentStyle = "#stl#"									
									Color        = "ffffff"																
									GroupField   = "GLAccount"
									GroupValue   = "#GLAccount#"
									GroupName    = "#Description#"
									Filter1Field = "AccountParent"
									Filter1Value = "#AccountParent#"
									Filter2Field = "AccountGroup"
									Filter2Value = "#AccountGroup#">							   
						  							
								<!--- ---------------------------- --->
								<!--- show cost center information --->
								<!--- ---------------------------- --->
							
								<cfif attributes.Aggregation eq "GroupDetailCenter">
								
									<!--- check--->
									<cfquery name="checkUnit"
									datasource="AppsQuery" 
									username="#SESSION.login#" 
									password="#SESSION.dbpw#">
										SELECT  DISTINCT OrgUnit
										FROM    #SESSION.acc#PL#attributes.FileNo#
										WHERE   GLAccount  = '#GLAccount#'																			
										AND     Panel      = '#attributes.panel#'
									</cfquery>	
									
									<cfif checkUnit.OrgUnit eq "0" and checkUnit.recordcount lte "1">	
									
										<!--- we skip this section --->						
									
									<cfelse>
								
										<cfoutput group="OrgUnitHierarchy">
																														
											<cf_PLViewDataContent 
												Panel        = "#attributes.Panel#" 
												History      = "#attributes.History#"									
												ShowPeriod   = "#attributes.showPeriod#"
												PeriodList   = "#attributes.PeriodList#"
												FileNo       = "#attributes.FileNo#"
												Visible      = "display:xnone;" 
												BaseId       = "#attributes.panel#_#pAccountParentId#"	
												ContentStyle = "#stl#"												
												Color        = "DAF9FC"															
												GroupField   = "Center"
												GroupValue   = "#OrgUnit#"
												GroupName    = "#OrgUnitName#"
												Filter1Field = "AccountParent"
												Filter1Value = "#AccountParent#"									
												Filter2Field = "AccountGroup"
												Filter2Value = "#AccountGroup#"
												Filter3Field = "GLAccount"
												Filter3Value = "#GLAccount#">											
											
										</cfoutput>
										
									</cfif>	
									
								</cfif>	
													   
						   </cfoutput>
						   						
						<cfelseif attributes.Aggregation eq "GroupCenter" 
					          or attributes.Aggregation eq "GroupCenterDetail">	

					      <cfoutput group="OrgUnitHierarchy">		
						  
						  		<cf_PLViewDataContent 
									Panel        = "#attributes.Panel#" 
									History      = "#attributes.History#"									
									ShowPeriod   = "#attributes.showPeriod#"
									PeriodList   = "#attributes.PeriodList#"
									FileNo       = "#attributes.FileNo#"
									Visible      = "display:xnone;" 
									BaseId       = "#attributes.panel#_#pAccountParentId#"	
									ContentStyle = "#stl#"
									Show         = "1"		
									Color        = "DAF9FC"															
									GroupField   = "Center"
									GroupValue   = "#OrgUnit#"
									GroupName    = "#OrgUnitName#"
									Filter1Field = "AccountParent"
									Filter1Value = "#AccountParent#"									
									Filter2Field = "AccountGroup"
									Filter2Value = "#AccountGroup#">			
						  
						    <!--- <cfinclude template="PLViewDataCenter.cfm"> --->
							
						  	<cfif attributes.Aggregation eq "GroupCenterDetail">	
																																										
								<cfoutput group="GLAccount">  																		
								
									<cf_PLViewDataContent 
									Panel        = "#attributes.Panel#" 
									History      = "#attributes.History#"									
									ShowPeriod   = "#attributes.showPeriod#"
									PeriodList   = "#attributes.PeriodList#"
									FileNo       = "#attributes.FileNo#"
									Visible      = "display:xnone;" 
									BaseId       = "#attributes.panel#_#pAccountParentId#"	
									ContentStyle = "#stl#"
									Show         = "1"		
									Color        = "transparent"															
									GroupField   = "GLAccount"
									GroupValue   = "#GLAccount#"
									GroupName    = "#Description#"
									Filter1Field = "AccountParent"
									Filter1Value = "#AccountParent#"									
									Filter2Field = "AccountGroup"
									Filter2Value = "#AccountGroup#"
									Filter3Field = "OrgUnit"
									Filter3Value = "#OrgUnit#">								
									
								</cfoutput>
								
							</cfif>
																
						  </cfoutput>
						  
						</cfif>  
				
				    </cfoutput>	
					
				</cfoutput>					
						
		   <cfelseif Aggregation eq "Center">
		   
		   		<cfoutput group="OrgUnitHierarchy">	
				
					<!--- ------------ --->
					<!--- Center level --->
					<!--- ------------ --->		
					
						<cf_PLViewDataContent 
									Panel        = "#attributes.Panel#" 
									History      = "#attributes.History#"									
									ShowPeriod   = "#attributes.showPeriod#"
									PeriodList   = "#attributes.PeriodList#"
									FileNo       = "#attributes.FileNo#"
									Visible      = "#pDetailVisible#" 
									BaseId       = "#attributes.panel#_#pAccountParentId#"	
									ContentStyle = "#stl#"
									height       = "26"
									fontsize     = "16"
									Color        = "DAF9FC"	
									Show         = "1"																	
									GroupField   = "Center"
									GroupValue   = "#OrgUnit#"
									GroupName    = "#OrgUnitName#"
									Filter1Field = "AccountParent"
									Filter1Value = "#AccountParent#">								
									
					<cfoutput group="AccountGroupOrder">		
						<cfoutput group="AccountGroup">		
						
						         <cf_PLViewDataContent 
									Panel        = "#attributes.Panel#" 
									History      = "#attributes.History#"									
									ShowPeriod   = "#attributes.showPeriod#"
									PeriodList   = "#attributes.PeriodList#"
									FileNo       = "#attributes.FileNo#"
									Visible      = "" 
									BaseId       = "#attributes.panel#_#pAccountParentId#"	
									ContentStyle = "#stl#"									
									Show         = "1"		
									Color        = "e1e1e1"																	
									GroupField   = "AccountGroup"
									GroupValue   = "#AccountGroup#"
									GroupName    = "#AccountGroupDescription#"
									Filter1Field = "AccountParent"
									Filter1Value = "#AccountParent#"
									Filter2Field = "OrgUnit"
									Filter2Value = "#OrgUnit#">		
														       										
								<cfoutput group="GLAccount">   			
								
									<cf_PLViewDataContent 
									Panel        = "#attributes.Panel#" 
									History      = "#attributes.History#"									
									ShowPeriod   = "#attributes.showPeriod#"
									PeriodList   = "#attributes.PeriodList#"
									FileNo       = "#attributes.FileNo#"
									Visible      = "display:xnone;" 
									BaseId       = "#attributes.panel#_#pAccountParentId#"	
									ContentStyle = "#stl#"
									Show         = "1"		
									Color        = "ffffff"															
									GroupField   = "GLAccount"
									GroupValue   = "#GLAccount#"
									GroupName    = "#Description#"
									Filter1Field = "AccountParent"
									Filter1Value = "#AccountParent#"
									Filter2Field = "OrgUnit"
									Filter2Value = "#OrgUnit#"
									Filter3Field = "AccountGroup"
									Filter3Value = "#AccountGroup#">					
																		
								</cfoutput>
						</cfoutput>					
					</cfoutput>					
				
				</cfoutput>
				
			<cfelse>
						
				<cfoutput group="StatementOrder">	
		
					<!--- -------------- --->
					<!--- StatementOrder --->
					<!--- -------------- --->		
											
					<cf_PLViewDataContent 
									Panel        = "#attributes.Panel#" 
									History      = "#attributes.History#"									
									ShowPeriod   = "#attributes.showPeriod#"
									PeriodList   = "#attributes.PeriodList#"
									FileNo       = "#attributes.FileNo#"
									Visible      = "#pDetailVisible#" 
									BaseId       = "#attributes.panel#_#pAccountParentId#"	
									ContentStyle = "#stl#"
									Show         = "1"		
									Color        = "DEF8EF"
									Height       = "27"	
									fontsize     = "16"															
									GroupField   = "StatementCode"
									GroupValue   = "#StatementCode#"
									GroupName    = "#StatementName#"
									Filter1Field = "AccountParent"
									Filter1Value = "#AccountParent#">			
									
					<cfif aggregation eq "Custom">													
													
						<cfoutput group="AccountGroupOrder">							
							<cfoutput group="AccountGroup">			
							
									<cf_PLViewDataContent 
										Panel        = "#attributes.Panel#" 
										History      = "#attributes.History#"									
										ShowPeriod   = "#attributes.showPeriod#"
										PeriodList   = "#attributes.PeriodList#"
										FileNo       = "#attributes.FileNo#"
										Visible      = "" 
										BaseId       = "#attributes.panel#_#pAccountParentId#"	
										ContentStyle = "#stl#"
										Show         = "1"		
										Color        = "f1f1f1"	
										Height       = "20"																
										GroupField   = "AccountGroup"
										GroupValue   = "#AccountGroup#"
										GroupName    = "#AccountGroupDescription#"
										Filter1Field = "AccountParent"
										Filter1Value = "#AccountParent#"
										Filter2Field = "StatementCode"
										Filter2Value = "#StatementCode#">		
																								
										<cfoutput group="GLAccount">   		
										
											<cf_PLViewDataContent 
											Panel        = "#attributes.Panel#" 
											History      = "#attributes.History#"									
											ShowPeriod   = "#attributes.showPeriod#"
											PeriodList   = "#attributes.PeriodList#"
											FileNo       = "#attributes.FileNo#"
											Visible      = "display:none;" 
											BaseId       = "#attributes.panel#_#pAccountParentId#"	
											ContentStyle = "#stl#"
											Height       = "20"	
											Show         = "1"		
											Color        = "DAF9FC"															
											GroupField   = "GLAccount"
											GroupValue   = "#GLAccount#"
											GroupName    = "#Description#"
											Filter1Field = "AccountParent"
											Filter1Value = "#AccountParent#"
											Filter2Field = "StatementCode"
											Filter2Value = "#StatementCode#"
											Filter3Field = "AccountGroup"
											Filter3Value = "#AccountGroup#">																
																												
										</cfoutput>
										
							</cfoutput>					
						</cfoutput>			
						
					<cfelse>
					
						<cfoutput group="OrgUnitHierarchy">
							
									<cf_PLViewDataContent 
										Panel        = "#attributes.Panel#" 
										History      = "#attributes.History#"									
										ShowPeriod   = "#attributes.showPeriod#"
										PeriodList   = "#attributes.PeriodList#"
										FileNo       = "#attributes.FileNo#"
										Visible      = "" 
										BaseId       = "#attributes.panel#_#pAccountParentId#"	
										ContentStyle = "#stl#"
										Color        = "DAF9FC"
											
										Height       = "20"			
										GroupField   = "Center"
										GroupValue   = "#OrgUnit#"
										GroupName    = "#OrgUnitName#"																							
										Filter1Field = "AccountParent"
										Filter1Value = "#AccountParent#"
										Filter2Field = "StatementCode"
										Filter2Value = "#StatementCode#">	
										
										<cfoutput group="AccountGroupOrder">							
											<cfoutput group="AccountGroup">		
										
											<cf_PLViewDataContent 
												Panel        = "#attributes.Panel#" 
												History      = "#attributes.History#"									
												ShowPeriod   = "#attributes.showPeriod#"
												PeriodList   = "#attributes.PeriodList#"
												FileNo       = "#attributes.FileNo#"
												Visible      = "display:xnone;" 
												BaseId       = "#attributes.panel#_#pAccountParentId#"	
												ContentStyle = "#stl#"
												Height       = "16"															
												Color        = "eaeaea"		
												GroupField   = "AccountGroup"
												GroupValue   = "#AccountGroup#"
												GroupName    = "#AccountGroupDescription#"																									
												Filter1Field = "AccountParent"
												Filter1Value = "#AccountParent#"
												Filter2Field = "StatementCode"
												Filter2Value = "#StatementCode#"
												Filter3Field = "OrgUnit"
												Filter3Value = "#OrgUnit#">			
												
												<cfoutput group="GLAccount">   		
										
														<cf_PLViewDataContent 
														Panel        = "#attributes.Panel#" 
														History      = "#attributes.History#"									
														ShowPeriod   = "#attributes.showPeriod#"
														PeriodList   = "#attributes.PeriodList#"
														FileNo       = "#attributes.FileNo#"
														Visible      = "display:xnone;" 
														BaseId       = "#attributes.panel#_#pAccountParentId#"	
														ContentStyle = "#stl#"
														Height       = "20"															
														Color        = "ffffff"															
														GroupField   = "GLAccount"
														GroupValue   = "#GLAccount#"
														GroupName    = "#Description#"
														Filter1Field = "AccountParent"
														Filter1Value = "#AccountParent#"
														Filter2Field = "StatementCode"
														Filter2Value = "#StatementCode#"
														Filter3Field = "OrgUnit"
														Filter3Value = "#OrgUnit#"
														Filter4Field = "AccountGroup"
														Filter4Value = "#AccountGroup#">																
																															
													</cfoutput>													
																												
											</cfoutput>										
										</cfoutput>					
			
						</cfoutput>						
					
					</cfif>			
					
				</cfoutput>
			
				
		   </cfif>
	
</cfoutput>

<cfoutput>
		
	<!--- ------------------- --->  
	<!--- profit / loss lines --->

	<cfif attributes.panel eq "debit">
			
	  <!--- source data--->
	  <cfquery name="Data"
		datasource="AppsQuery" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT  sum(Credit-Debit) as Total
			FROM    #SESSION.acc#PL#attributes.FileNo#										
	  </cfquery>	   
	
		<cfif attributes.showperiod eq "1" or data.total gt "0">
		
			
			<cfset stl = "border:1px solid silver;padding-right:3px;border-radius:0px;background-color:##00800080;color:black">	
    
			<tr class="navigation_row line fixlengthlist labelmedium2">		  
				  <td colspan="2" class="labelmedium" style="padding-left:10px;padding-right:3px"> <cf_tl id="Profit"></td>
				 
				 <cfif attributes.showperiod eq "1">
				 
					   <cfloop index="per" list="#attributes.periodlist#" delimiters=",">
					   
					   	    <!--- source data--->
							<cfquery name="Data"
							datasource="AppsQuery" 
							username="#SESSION.login#" 
							password="#SESSION.dbpw#">
								SELECT  sum(Credit-Debit) as Total
								FROM    #SESSION.acc#PL#attributes.FileNo#
								<cfif attributes.history eq "TransactionPeriod">
								WHERE   TransactionPeriod = '#per#'	
								<cfelse>
								WHERE   AccountPeriod     = '#per#'	
								</cfif>					
							</cfquery>	
					   				   				
							<cfif data.total gt "0">	
							   				
							<td align="right" style="#stl#;border-bottom:1px solid silver">
								#NumberFormat(Data.Total,',____')#</font>
							</td>
							
							<cfelse>
							
								<td style="#stl#;border-bottom:1px solid silver;background-color:##ffffff80"></td>
								
							</cfif>
						
					   </cfloop>
				   
				  </cfif>		
				  
				  <!--- source data--->
				  <cfquery name="Data"
					datasource="AppsQuery" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
						SELECT  sum(Credit-Debit) as Total
						FROM    #SESSION.acc#PL#attributes.FileNo#										
				  </cfquery>	   
				  			 		  	
				  <cfif data.total gt "0">		 		  	
				 	 <td align="right" style="#stl#;border-bottom:1px solid silver;font-size:17px">
					  #NumberFormat(Data.Total,'_,____')# 
					  </font>
					 </td>
				  <cfelse>
				  	<td style="#stl#:border-bottom:1px solid silver;background-color:##ffffff80"></td> 	 
				  </cfif>	
					
			 </tr>		
		 
		 </cfif>
	 
	<cfelse>
	
		  <!--- source data--->
		  <cfquery name="Data"
			datasource="AppsQuery" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				SELECT  sum(Debit-Credit) as Total
				FROM    #SESSION.acc#PL#attributes.FileNo#												
		  </cfquery>   
	
		  <cfif attributes.showperiod eq "1" or data.total gt "0">
		  
		    <cfif attributes.showperiod eq "0"> 
			
				<tr><td height="15"></td></tr>
			
			</cfif>
						
			<cfset stl = "border:1px solid silver;padding-right:3px;background-color:##FF000080;color:black">
		
			<tr class="navigation_row line labelmedium2 fixlengthlist">		  
			  <td colspan="2" style="padding-left:10px;padding-right:3px"><cf_tl id="Loss"></td>
			 
			 <cfif attributes.showperiod eq "1">
			 
				   <cfloop index="per" list="#attributes.periodlist#" delimiters=",">
				   
				   		 <!--- source data--->
						<cfquery name="Data"
						datasource="AppsQuery" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">
							SELECT  sum(Debit-Credit) as Total
							FROM    #SESSION.acc#PL#attributes.FileNo#
							<cfif attributes.history eq "TransactionPeriod">
							WHERE   TransactionPeriod = '#per#'	
							<cfelse>
							WHERE   AccountPeriod     = '#per#'	
							</cfif>				
						</cfquery>
				   		
						<cfif data.total gte "0">	   				
						<td align="right" style="#stl#;border-bottom:1px solid silver">#NumberFormat(Data.Total,'_,____')#	 															</td>
						<cfelse>
						<td style="#stl#;border-bottom:1px solid silver;background-color:##ffffff50"></td>
						</cfif>
					
				   </cfloop>
			   
			  </cfif>		
			  
			   <!--- source data--->
			  <cfquery name="Data"
				datasource="AppsQuery" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
					SELECT  sum(Debit-Credit) as Total
					FROM    #SESSION.acc#PL#attributes.FileNo#												
			  </cfquery>   
	  		  
			  <cfif data.total gte "0">		 		  	
			 	 <td align="right" style="#stl#;border-bottom:1px solid silver;font-size:17px;font-weight:bold">				 
				  #NumberFormat(Data.Total,'_,____')#
				 </td>
			  <cfelse>
			  	<td style="#stl#;border-bottom:1px solid silver;background-color:##ffffff80"></td> 	 
			  </cfif>	
				
		   </tr>		
		
		</cfif> 
		
	</cfif>	
	
	<tr><td height="10"></td></tr>
	  
</cfoutput>	