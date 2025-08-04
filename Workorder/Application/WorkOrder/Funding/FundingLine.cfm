<!--
    Copyright © 2025 Promisan

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

        http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
-->

<cfajaximport tags="cfWindow">
				
<cfparam name="URL.workorderid"     default="">	
<cfparam name="URL.billingdetailid" default="">	<!--- either billingid or billingdetailid --->
<cfparam name="URL.search"          default="">
<cfparam name="URL.row"             default="0">
<cfparam name="box"                 default="">

<cfquery name="WorkOrder" 
datasource="AppsWorkOrder" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
    FROM   WorkOrder
	WHERE  WorkorderId = '#URL.WorkOrderId#'	
</cfquery>

<cfquery name="Customer" 
datasource="AppsWorkOrder" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
    FROM  Customer
	WHERE CustomerId = '#workorder.customerid#'	
</cfquery>

<cfif customer.orgunit eq "">

	<cfset access = "ALL">

<cfelse>
	
	<cfquery name="Param" 
	datasource="AppsWorkOrder" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		 SELECT  *	
    	 FROM    Ref_ParameterMission
		 WHERE   Mission  = '#workorder.mission#'	
	</cfquery>

	<!--- define access --->	
	
	<cfinvoke component = "Service.Access"  
	   method           = "WorkorderFunder" 
	   mission          = "#Param.TreeCustomer#" 
	   serviceitem      = "#workorder.serviceitem#"
	   orgunit          = "#Customer.OrgUnit#"
	   returnvariable   = "access">		
	  	
</cfif>	   

<cfquery name="CurrencyList" 
	datasource="AppsLedger" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT *
	FROM   Currency	
</cfquery>

<cfquery name="UnitList" 
	datasource="AppsWorkOrder" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT *
	FROM   ServiceItemUnit
	WHERE  ServiceItem = '#workorder.serviceitem#'	
	AND    Unit IN (SELECT ServiceItemUnit 
	                FROM   WorkOrderLineBillingDetail 
				    WHERE  WorkOrderId = '#url.workorderid#')
</cfquery>

<cfsavecontent variable="myfunding">

	<cfoutput>
	
	   SELECT   WF.*, 
	            P.FundingType as FundingType,
				P.Reference as Reference,
	            P.Fund AS Fund, 
				<!---
				P.Period as Period,
				--->
				P.OrgUnitCode AS OrgUnitCode, 
				P.ProjectCode AS ProjectCode,
				P.ProgramCode AS ProgramCode,
				P.ObjectCode as ObjectCode,
				P.Reference as FundingReference,
				P.GLAccount
	   FROM     WorkOrderFunding WF INNER JOIN
	            Ref_Funding P ON WF.FundingId = P.FundingId
	   WHERE    WF.WorkOrderId = '#url.workorderid#'
	   
	   <cfif url.search neq "">
	   AND      WF.Reference LIKE '%#url.search#%' 
	         OR WF.FundingId IN (SELECT FundingId 
			                     FROM   Ref_Funding 
							     WHERE  Fund LIKE '%#url.search#%')
	   </cfif>
	   
	    AND      Operational = 1
	  
	</cfoutput>

</cfsavecontent>

<cfif url.billingdetailid neq "">
	
	<cfquery name="Billing" 
		  datasource="AppsWorkOrder" 
		  username="#SESSION.login#" 
		  password="#SESSION.dbpw#">
		  SELECT * 
		  FROM   WorkOrderLineBilling
		  WHERE  BillingId = '#url.billingdetailid#'
	</cfquery>	
	
	<cfif Billing.recordcount eq "1">
				
		<cfset mode = "billingline">
		
	<cfelse>
	
		<cfquery name="Billing" 
		  datasource="AppsWorkOrder" 
		  username="#SESSION.login#" 
		  password="#SESSION.dbpw#">
		  
		  SELECT   WOD.*, WB.BillingExpiration AS BillingExpiration
		  FROM     WorkOrderLineBillingDetail WOD INNER JOIN
                   WorkOrderLineBilling WB ON WOD.WorkOrderId = WB.WorkOrderId AND WOD.WorkOrderLine = WB.WorkOrderLine AND 
                   WOD.BillingEffective = WB.BillingEffective
		 		  
		  WHERE  BillingDetailId = '#url.billingdetailid#'
	   </cfquery>	
	
		<cfset mode = "billingunit">	
		
	</cfif>
	
<cfelse>

	<cfparam name="Billing.BillingEffective" default="">

	<cfset mode = "main">
	
</cfif>	

<!--- show records for the listing --->
	
<cfquery name="Detail" 
datasource="AppsWorkOrder" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">

   #preserveSingleQuotes(myfunding)#  
      
   <cfif url.billingdetailid neq "">  
   
   AND      (
   
            WF.BillingDetailId = '#url.billingdetailid#'    <!--- this is on the billing + unit level [not used] --->
   
            OR
			
				(  WF.WorkOrderLine IN (
				                         SELECT WorkorderLine 
				                         FROM   WorkOrderLineBilling
						   			     WHERE  WorkOrderId       = WF.WorkOrderId
									     AND    WorkorderLine     = WF.WorkorderLine	
										 AND    WorkOrderLine     = '#Billing.WorkOrderLine#'		
										 <!--- changed <= into >= based on diaz observation --->						
									     AND    (
										          BillingExpiration is NULL OR BillingExpiration >= WF.DateEffective
												)										

										<cfif mode eq "billingline">
											AND ( WF.DateExpiration IS NULL OR WF.DateExpiration >= BillingEffective )
											AND BillingId = '#url.billingdetailid#'
										</cfif>												
									    )
				)
			)
	
		<cfif Billing.BillingExpiration neq "">
		AND    WF.DateEffective <= '#Billing.BillingExpiration#'  		
		<cfelse>										 
		<!---
	 	AND    (WF.DateExpiration > '#Billing.BillingEffective#' or WF.DateExpiration is NULL)		
		--->
		</cfif>							 
						 
   <cfelse>
   
   AND      WF.BillingDetailId is NULL 
   AND      WF.WorkOrderLine   is NULL
   
   </cfif>     
   
   ORDER BY DateEffective DESC, Priority
   
</cfquery>


<cfif detail.recordcount eq "0" and url.billingdetailid neq "">
			 
	 <!--- get the line --->	
	
	 <cfquery name="get" 
	datasource="AppsWorkOrder" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	   SELECT  * 
	   FROM    WorkorderLineBillingDetail
	   WHERE   BillingdetailId = '#url.billingdetailid#'	  
	</cfquery> 
	
	<cfif get.workorderline neq "">
			
		<cfquery name="Detail" 
		datasource="AppsWorkOrder" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		   #preserveSingleQuotes(myfunding)#     	  
		   AND      WF.WorkOrderLine IN (SELECT WorkorderLine 
					                     FROM   WorkOrderLineBilling
										 WHERE  WorkOrderid      = '#url.workorderid#'
										 AND    WorkOrderLine    = '#get.workorderline#'
										 AND    BillingEffective = WF.BillingEffective) 	
			AND    (WF.DateExpiration > '#Billing.BillingEffective#' or WF.DateExpiration is NULL)								   
		  
		</cfquery>
		
	</cfif>
		
	<cfif detail.recordcount eq "0">
	 	 
		 <cfquery name="Detail" 
			datasource="AppsWorkOrder" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			 #preserveSingleQuotes(myfunding)#    	 
	   		 AND      WF.BillingDetailId is NULL	
			 AND      WF.Workorderline is NULL	     
			 AND     (WF.DateExpiration > '#Billing.BillingEffective#' or WF.DateExpiration is NULL)	
			 <cfif Billing.BillingExpiration neq "">
			 AND      WF.DateEffective <= '#Billing.BillingExpiration#'
			 </cfif>
			 ORDER BY DateEffective 			
	      </cfquery>  	
	 
	 </cfif> 
			 
</cfif>

<cfif Detail.recordcount eq "0" 
    and url.billingdetailid eq "" 
	and (access eq "EDIT" or access eq "ALL")>
   <cfset url.id2 = "new">      
<cfelse>
   <cfparam name="url.id2" default="">     
</cfif>

<cfform action="#SESSION.root#/workorder/application/workorder/Funding/FundingLineSubmit.cfm?mode=#mode#&tabno=#url.tabno#&row=#url.row#&Search=#url.search#&WorkOrderId=#URL.WorkOrderId#&billingdetailid=#url.billingdetailid#&ID2=#URL.ID2#" 
     method="POST" 
	 name="billinginsert_#url.tabno#_#url.row#">
		
<table width="100%" border="0" cellspacing="0" cellpadding="0" align="center">
	
	<!--- ----------------------------- --->
	<!--- only visible for default view --->
	<!--- ----------------------------- --->
		
	<cfif url.billingdetailid eq "">
	
		<tr><td height="40" class="labellarge"><cf_tl id="Funding Account"></td></tr>
	
		<!---		
		<tr><td height="7"></td></tr>
		<tr>
		 <td height="19" width="100">&nbsp;&nbsp;&nbsp;Locate: </td>
		 		 
		 <cfoutput>
		 
			  <td width="130" style="border: 1px solid Silver;">	
			
			 	<input type="text"
			       name="billingfind"
			       size="25"
				   value="#URL.search#"
				   onKeyUp="billingsearch()"
			       maxlength="25"
			       class="regular3">
				   
			</td>
			
			<td height="20" style="padding-left: 2px;">	   
				   
			    <img src="#SESSION.root#/Images/locate3.gif" 
					 alt    = "Search" 
					 name   = "locate" 
					 onMouseOver= "document.locate.src='#SESSION.root#/Images/contract.gif'" 
					 onMouseOut = "document.locate.src='#SESSION.root#/Images/locate3.gif'"
					 style  = "cursor: pointer;" 					 
					 border = "0" 
					 height="20" 
					 width="19"
					 align  = "absmiddle" 
					 onclick="billingsearching('#url.tabno#','#url.workorderid#',billingfind.value)">
				
			  </td> 
			  <td width="70%"></td>
		  
		  </cfoutput>	   
			      
		</tr>		
		<tr><td height="4"></td></tr>		
		--->
	
	</cfif>	
	
	<cfset cols = "13">
	      
	<tr>
	
	    <td style="width:100%;padding:0px" colspan="4" align="center">
	    <table width="100%" border="0" cellspacing="0" cellpadding="0" class="navigation_table">
		
		<cfif url.billingdetailid eq "" or url.id2 neq "">							
	    <TR class="labelit line">
		   
		   <td height="20"><cf_space spaces="4"></td>
		   <td><cf_space spaces="6"></td>		  
		   <td><cf_UIToolTip tooltip="Fund,Project.Program,Org,ObjectCode"><cf_tl id="Funding"></cf_UIToolTip></td>
		   <cfif url.billingdetailid eq "">
		   <td width="50"><cf_tl id="Unit"></td>		  
		   </cfif> 
		   <td><cf_space spaces="20"><cf_tl id="Effective"></td>
		   <td><cf_space spaces="20"><cf_tl id="Expiration"></td>
		   <td><cf_tl id="Note"></td>
		   <cfif url.billingdetailid eq "">
		   <td width="50"><cf_tl id="Curr"></td>
		   <td align="right"><cf_tl id="Amount"></td>
		   </cfif>
		
		   <td align="right" colspan="4" width="5%" style="cursor: pointer;">
		     <cfoutput>			 
			 
			 <cfif URL.ID2 neq "new">
			 
				  <cfif access eq "EDIT" or access eq "ALL">
					  <a href="#ajaxLink('#SESSION.root#/workorder/application/workorder/Funding/FundingLine.cfm?tabno=#url.tabno#&row=#url.row#&WorkOrderId=#URL.WorkOrderId#&billingdetailid=#url.billingdetailid#&search=#url.search#&ID2=new')#">
					  <font color="0080FF"><cf_tl id="add"></font></a>		
				  </cfif>		
			  
			 </cfif>			
			 
			 </cfoutput>
		   </td>		  
	    </TR>	
							
		</cfif>		
							
		<cfif URL.ID2 eq "new">	
						
			<cfoutput>
		  						
			<TR bgcolor="ffffaf">
			
			<td></td>
			<td></td>
			
			<td>
			
				<cf_space spaces="70">	
												
				<cfset link = "#SESSION.root#/workorder/application/workorder/Funding/FundingLineSelect.cfm?tabno=#url.tabno#&row=#url.row#&workorderid=#URL.workorderid#&billingdetailid=#url.billingdetailid#">	
			
				<table cellspacing="0" cellpadding="0" width="99%">
					<tr>
					<td width="20" height="24" style="padding-right:2px">
										
					   <cf_selectlookup
					    box        = "billing#url.tabno#_#url.row#"
						link       = "#link#"
						button     = "Yes"
						icon       = "contract.gif"
						close      = "Yes"
						class      = "funding"
						des1       = "FundingId">
						
					</td>	
					<td>&nbsp;</td>				
					<td width="99%"><cfdiv bind="url:#link#" id="billing#url.tabno#_#url.row#"/></td>
					</tr>
				</table>
			
			</td>
			
			 <cfif url.billingdetailid eq "">
						  
				<td>
					
					<select name="fundunit#url.tabno#_#url.row#" id="fundunit#url.tabno#_#url.row#" style="width:150">
					<option value="">Any</option>
					<cfloop query="UnitList">
						<option value="#Unit#">#unitdescription#</option>
					</cfloop>
					</select>
				</td>
				
			</cfif>	
			
			<td style="z-index:#200-url.row#; position:relative;padding:4px">
			
				<cfif url.billingdetailid neq "">
							
					<cfquery name="Billingdetail" 
					datasource="AppsWorkOrder" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
					    SELECT *
					    FROM   WorkorderLineBillingDetail
						WHERE  BillingDetailId = '#url.billingdetailid#'	
					</cfquery>
					
					<cfif BillingDetail.recordcount eq "1">
					
						<cfset date = BillingDetail.BillingEffective>	
						
					<cfelse>
					
						<cfquery name="Billingdetail" 
						datasource="AppsWorkOrder" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">
						    SELECT *
						    FROM   WorkorderLineBilling
							WHERE  BillingId = '#url.billingdetailid#'	
						</cfquery>
					
						<cfset date = BillingDetail.BillingEffective>	
					
					</cfif>	
				
				<cfelse>
				
					<cfquery name="GetPrior" 
						datasource="AppsWorkOrder" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">
						    SELECT TOP 1 *
						    FROM   WorkorderFunding
							WHERE  WorkOrderId = '#workorder.workorderid#'	
							AND    WorkOrderLine is NULL
							AND    Operational = 1
							ORDER BY DateEffective DESC
						</cfquery>
						
					<cfif getPrior.DateExpiration neq "">
					
					<cfset date = dateAdd("D","1",getPrior.DateExpiration)>
										
					<cfelse>
					
					<cfset date = WorkOrder.OrderDate>
					
					</cfif>					
							
				</cfif>		
			
				<cf_space spaces="42">					
					
				<cf_intelliCalendarDate9
					FieldName="funddateeffective#url.tabno#_#url.row#" 
					class="regularxl"						
					Default="#Dateformat(date, CLIENT.DateFormatShow)#"		
					AllowBlank="False">	
			
		    </td>
			 			
		    <td style="z-index:#200-url.row-1#; position:relative;padding:4px">
			
			     <cf_space spaces="42">	
			
				 <cf_intelliCalendarDate9
					FieldName="funddateexpiration#url.tabno#_#url.row#" 					
					class="regularxl"	
					Default=""		
					AllowBlank="True">	
			
			</td>	
			
			<td>
			
				 <cf_space spaces="25">	
			
				 <cfinput type="Text"
			       name="fundreference#url.tabno#_#url.row#"				      
			       required="No"
			       visible="Yes"
			       enabled="Yes"				     
			       size="1"
			       maxlength="30"
			       class="regularxl"
			       style="text-align:left;width:100">
			  		
			</td>
			
			<cfif url.billingdetailid eq "">		
			
			<td>
			
				<cf_space spaces="20">	
			
				<select name="fundcurrency#url.tabno#_#url.row#" id="fundcurrency#url.tabno#_#url.row#" class="regularxl">
				<cfloop query="CurrencyList">
					<option value="#Currency#" <cfif currency eq APPLICATION.BaseCurrency>selected</cfif>>#currency#</option>
				</cfloop>
				</select>
				
			</td>
			<td align="right">
			
				 <cf_space spaces="30">	
			
				 <cfinput type="Text"
			       name="fundamount#url.tabno#_#url.row#"
			       validate="float"
			       required="No"
			       visible="Yes"
			       enabled="Yes"
			       maxlength="15"
			       class="regularxl"
			       style="height:19;text-align: right;width:100">
				
			</td>
			
			</cfif>
											   
			<td colspan="4" align="right" width="50">
			
				 <cf_space spaces="10">	
			
				<input type="submit" style="height:25;width:40" value="Add" class="button10g">
				
			</td>
			    
			</TR>	
			
			</cfoutput>			

																
		</cfif>	
		
		<cfoutput>
						
		<cfloop query="Detail">		
		
			<cfif billingdetailid neq "" or workorderline neq "">
			
			    <cfset color = "ffffaf">
							
			<cfelse>
					
				<cfset color = "E3FBE8">
				
			</cfif>		
						
			<cfif currentrow neq "1" and prior lte Billing.BillingEffective>
			
				<!---#dateEffective# #Billing.BillingEffective#--->
			
				<!--- no need to show this record as its period is covered already --->
			
			<cfelse>
																				
				<cfif URL.ID2 eq fundingdetailid>			
											   												
					<tr>				  
					   
					   <td width="2"></td>
					   <td height="20" style="padding-left:5px">
						   <cf_space spaces="10"><font size="1">#currentrow#.</font>
					   </td>			
					   
					   <td>
					   
				     	<cf_space spaces="70">	
					  
					  	<cfset link = "#SESSION.root#/workorder/application/workorder/Funding/FundingLineSelect.cfm?tabno=#url.tabno#&row=#url.row#&workorderid=#URL.workorderid#&billingdetailid=#url.billingdetailid#">	
					
						<table cellspacing="0" cellpadding="0" width="96%">
						
							<tr>
							<td width="20" style="padding-right:2px">
							
							   <cf_selectlookup
							    box        = "billing#url.tabno#_#url.row#"
								link       = "#link#"
								button     = "Yes"
								icon       = "contract.gif"
								close      = "Yes"
								class      = "funding"
								des1       = "FundingId">
								
							</td>					
							<td width="99%" valign="top">
								<cfdiv id="billing#url.tabno#_#url.row#">
								    <cfset url.fundingId = fundingid>
									<cfinclude template="FundingLineSelect.cfm">
								</cfdiv>
							</td>
							</tr>
						</table>
						
				      </td>		
					  
					  <cfif url.billingdetailid eq "">
					
						<td style="padding-left:4px">
							<cf_space spaces="60">	
							<select name="fundunit#url.tabno#_#url.row#" id="fundunit#url.tabno#_#url.row#" style="width:150" class="regularxl">
							<option value="">Any</option>
							<cfloop query="UnitList">
								<option value="#Unit#" <cfif detail.serviceitemunit eq unit>selected</cfif>>#unitdescription#</option>
							</cfloop>
							</select>
						</td>
						
					  </cfif>	
					   
					  <td style="z-index:#200-url.row#; position:relative;padding:2px">
					   					
						  <cf_space spaces="42">					
						 
						  <cf_intelliCalendarDate9
							FieldName="funddateeffective#url.tabno#_#url.row#" 					
							Default="#Dateformat(dateEffective, CLIENT.DateFormatShow)#"	
							class="regularxl"	
							AllowBlank="False">	
					
					  </td>
					
					  <td style="z-index:#200-url.row-1#; position:relative;padding:2px">
					  
					    	 <cf_space spaces="42">	
					
							<cf_intelliCalendarDate9
							FieldName="funddateexpiration#url.tabno#_#url.row#" 					
							Default="#Dateformat(dateExpiration, CLIENT.DateFormatShow)#"	
							class="regularxl"		
							AllowBlank="True">	
					
					  </td>
					
					  <td>
					  
					  	 <cf_space spaces="30">	
					   
				  		 <input type="text" 
					         name="fundreference#url.tabno#_#url.row#" 
                             id="fundreference#url.tabno#_#url.row#"
							 size="1" 	
							 value="#Memo#"												
							 class="regularxl" 
							 style="text-align: center;width:100" 
							 MaxLength="30"
							 visible="Yes" 
							 enabled="Yes">
		
			           </td>
					   								
					<cfif url.billingdetailid eq "">						
					  
						<td style="padding-left:4px">
						 <cf_space spaces="20">	
							<select name="fundcurrency#url.tabno#_#url.row#" id="fundcurrency#url.tabno#_#url.row#" class="regularxl">
							<cfloop query="CurrencyList">
								<option value="#Currency#" <cfif detail.currency eq currency>selected</cfif>>#currency#</option>
							</cfloop>
							</select>
						</td>
						
						<td align="right">
						
							 <cf_space spaces="30">	
						
							 <cfinput type="Text"
						       name="fundamount#url.tabno#_#url.row#"
						       validate="float"
							   value="#Amount#"
						       required="No"
						       visible="Yes"
						       enabled="Yes"
						       maxlength="10"
						       class="regularxl"
						       style="text-align:right;width:100">
							   
						</td>
					
					</cfif>
					
								
					<td colspan="4" align="right">&nbsp;
					<input type="submit" style="height:25;width:50" value="Save" class="button10g"></td>
					
				    </TR>	
					
					<!---
								
					</cfform>
					
					--->
							
				<cfelse>
									
					<tr bgcolor="#color#" class="label navigation_row line">		
					 		
					   <cfif access eq "EDIT" or access eq "ALL">					
					     <cfset link = "#ajaxLink('#SESSION.root#/workorder/application/workorder/Funding/FundingLine.cfm?tabno=#url.tabno#&row=#url.row#&WorkOrderId=#URL.workorderid#&billingdetailid=#url.billingdetailid#&ID2=#fundingdetailid#&search=#url.search#')#">
					   <cfelse>
					      <cfset link = "">
					   </cfif>
					   
					   <td width="2" height="15"></td>
					   <td onclick="#link#" style="width:20px;padding-left:5px;padding-right:10px"><font size="1">#currentrow#.</font></td>						   
					   <td onclick="#link#" style="width:60%;border-right:0px solid silver">					     				   	
						   
						   #FundingType#:#FundingReference#
						
						   <!--- 	 
						   <cfif period eq "">....<cfelse>#Period#</cfif>
						   --->
						   #Fund#			
						   <cfif orgunitcode eq "">-[]<cfelse>-#OrgUnitCode#</cfif>
						   <cfif projectcode eq "">-[]<cfelse>-#ProjectCode#</cfif>
						   <cfif programcode eq "">-[]<cfelse>-#Programcode#</cfif>						   
						   <cfif objectcode  eq "">-[]<cfelse>-#ObjectCode#</cfif>			
					       &nbsp;&nbsp;[#GLAccount#]	
						   						   		   
					   </td>
					   
					   <cfif url.billingdetailid eq "">
					   
					   		<td style="padding-right:10px"><cfif serviceitemunit eq "">Any<cfelse>#serviceitemunit#</cfif></td>
							
					   </cfif>
					   
					   <td onclick="#link#" style="width:10%">#dateformat(DateEffective,CLIENT.DateFormatShow)#</td>
					   <td onclick="#link#" style="width:10%;padding-left:5px">#dateformat(DateExpiration,CLIENT.DateFormatShow)#</td>
					   <td onclick="#link#" style="width:10%;padding-left:5px">#memo#</td>
					 
					   <cfif url.billingdetailid eq "">
					   
					 	   <td onclick="#link#" style="padding-left:5px">#Currency# <cf_space spaces="4"></td>
						   <td align="right" onclick="#link#" style="padding-left:5px">#numberformat(amount,",.__")#<cf_space spaces="20"></td>
						   
					   </cfif>
					 
					   <td align="right" width="20" style="padding-left:5px">							   				   	 	
										 
						  <cfif url.billingdetailid neq "" and billingdetailid eq "">
						  
							  <!--- if on billing level but the record is for the header, then do not show edit/add --->
							  
						  <cfelse>
						  
						  	 <cfif access eq "EDIT" or access eq "ALL">
		
								 <img src="#SESSION.root#/images/edit.gif"
								    alt="edit" onclick="#link#"	height="11" width="11" style="cursor:pointer" border="0" align="absmiddle">				 
								
							 </cfif>	
								
						  </cfif>		
										 
					   </td>
					   
					   <td style="padding-left:5px;padding-right:5px" align="center" id="fundingdelete#url.tabno#_#currentrow#">
					   					   
					   	   <cfif url.billingdetailid neq "" 
						         and mode eq "billingline" and workorderline eq "">
						   
						   	 	<!--- inherited, do not show --->
								
						   <cfelseif url.billingdetailid neq "" 
						         and mode eq "billingunit" and billingdetailid eq "">	
								 
								 <!--- inherited, do not show --->
						   
						   <cfelse>
						   
							    <cfif access eq "ALL">
								
									<cfif url.billingdetailid eq "" or Billing.BillingEffective lte dateEffective>
																						
									<img src="#SESSION.root#/images/delete5.gif" 
									  name="img2_#currentrow#" height="11" width="11"
									  style="cursor:pointer"
									  onclick="_cf_loadingtexthtml='';#ajaxlink('#SESSION.root#/workorder/application/workorder/Funding/FundingLinePurge.cfm?tabno=#url.tabno#&row=#url.row#&WorkOrderId=#URL.workorderid#&billingdetailid=#url.billingdetailid#&ID2=#fundingdetailid#&search=#url.search#')#"
								      onMouseOver="document.img2_#currentrow#.src='#SESSION.root#/Images/delete4.gif'" 
				    			      onMouseOut="document.img2_#currentrow#.src='#SESSION.root#/Images/delete4.gif'"
								      alt="Remove" 
									  align="absmiddle" 
									  border="0">	
									  
									  <cfelse>
									  
									  --
									  
									  </cfif>
								  
								 </cfif> 					
							
							</cfif>  
								 
					  </td>
					  
					  <td align="center"></td>			   
					  <td align="center"></td>
					   
				    </TR>	
					
					
							
				</cfif>
				
			</cfif>	
			
			<cfset prior = DateEffective>	
								
		</cfloop>
		</cfoutput>									
									
		</table>
		
		</td>
		</tr>
					
	</table>	

</cfform>

<cfset ajaxonload("doHighlight")>	
<cfset ajaxonload("doCalendar")>