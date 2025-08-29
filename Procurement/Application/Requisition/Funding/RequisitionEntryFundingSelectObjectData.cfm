<!--
    Copyright © 2025 Promisan B.V.

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
<cfif url.unithierarchy eq "undefined">
	<cfset url.unithierarchy = "">	
</cfif>

<cfoutput>

<cftry>
				
	<cfquery name="Funding" 
	datasource="AppsQuery" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT    SUM(total) AS Total
		FROM      dbo.#SESSION.acc#Requirement
		
		<cfif filtermode eq "resource">
		
		WHERE    ObjectCode IN (SELECT Code 
					            FROM   Program.dbo.Ref_Object 
								WHERE  Resource = '#Resource#')
				  				
		<cfelse>
		
		WHERE     (
				      ObjectCode = '#Code#' OR 
				      ObjectCode IN (SELECT Code 
					                FROM   Program.dbo.Ref_Object 
									WHERE  ParentCode = '#Code#')
				  )
				  
		</cfif>		
		  
		<cfif url.fund neq "">
		 AND      Fund       = '#URL.Fund#'
		</cfif>			
		
		<cfif ProgramHierarchy neq "">
		
		AND       ProgramHierarchy LIKE '#ProgramHierarchy#%'	
										
		<cfelseif ProgramCode neq "">
		
		AND       ProgramCode = '#ProgramCode#'
														
		</cfif>				
				
    </cfquery>	
							
	<cfcatch>
						
			<cfinvoke component = "Service.Process.Program.Execution"  
				   method           = "Budget" 
				   period           = "#url.period#" 
				   mission          = "#url.mission#"
				   editionid        = "#Edition#"
				   fund             = "#url.fund#"
				   currency         = "#application.basecurrency#"
				   unithierarchy    = "#url.unithierarchy#"
				   programcode      = "#url.programcode#"
				   programhierarchy = "#ProgramHierarchy#"
				   object           = "#code#"		
				   objectchildren   = "1"	  
				   status           = "0"      
				   mode             = "view"
				   returnvariable   = "Funding">				   				
					
			</cfcatch>	
		
		</cftry>
				
		<cfif Funding.Total neq "" or programhierarchy neq "">		
						
		  <td align="right" 		
			  style="#ostyle#;cursor:pointer;border-left:1px solid gray; <cfif filtermode eq 'resource'>font-weight:bold</cfif>"	
			  onclick="amore('all','#ProgramCode#_#Edition#_#url.Fund#_#CurrentRow#','#edition#','#URL.Fund#','#URL.ID#','#planningperiod#','#URL.ProgramCode#','#Code#','show','list','#url.mission#','#ProgramHierarchy#','#UnitHierarchy#','#filtermode#','')"
			  bgcolor="CEF1F4">		
			  			  			  						
		<cfelse>				
		
		  <td bgcolor="CEF1F4" 
		      align="right" 
			  style="#ostyle#; <cfif filtermode eq 'resource'>font-weight:bold</cfif>">			  
			  		
		</cfif>
		
		<cf_space spaces="#spc#">
		
		<cfif Funding.total eq "">
		  <cfset rsc = 0> - 
		<cfelse>
		  <cfset rsc =  Funding.total>
		  #numberformat(rsc/1000,"_,_._")#
		</cfif>
						
	    </td>
		
		<cfif url.scope eq "Embed">
		
			<cfset all = rsc>
		
		<cfelse>
				
			<cftry>
					
				<cfquery name="Funding" 
				datasource="AppsQuery" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				SELECT    SUM(total) AS Total
				FROM      dbo.#SESSION.acc#Release
				
				<cfif filtermode eq "resource">
					
					WHERE    ObjectCode IN (SELECT Code 
								            FROM   Program.dbo.Ref_Object 
											WHERE  Resource = '#Resource#')
							  				
				<cfelse>
					
				WHERE     (
						      ObjectCode = '#Code#' OR 
						      ObjectCode IN (SELECT Code 
							                FROM   Program.dbo.Ref_Object 
											WHERE  ParentCode = '#Code#')
						  )
						  
				</cfif>		  
				
				<cfif url.fund neq "">
				 AND      Fund       = '#URL.Fund#'
				</cfif>		
											
				<cfif ProgramHierarchy neq "">
					
					AND       ProgramHierarchy LIKE '#ProgramHierarchy#%'	
													
				<cfelseif ProgramCode neq "">
					
					AND       ProgramCode = '#ProgramCode#'
																	
				</cfif>			
				
			    </cfquery>		
											
				<cfcatch>
																		
				<cfinvoke component = "Service.Process.Program.Execution"  
					   method           = "Budget" 
					   period           = "#url.period#" 
					   mission          = "#url.mission#"
					   currency         = "#application.basecurrency#"
					   editionid        = "#Edition#"
					   fund             = "#url.fund#"
					   unithierarchy    = "#url.unithierarchy#"
					   programcode      = "#url.programcode#"
					   programhierarchy = "#ProgramHierarchy#"
					   object           = "#code#"		
					   objectchildren   = "1"
					   status           = "1"	        
					   mode             = "view"
					   returnvariable   = "Funding">					
						
				</cfcatch>	
			
			</cftry>
			
			<cfif Funding.Total neq "" and programhierarchy neq "">
			
			  <td align="right" 	
			      style="#ostyle#;cursor:pointer; <cfif filtermode eq 'resource'>font-weight:bold</cfif>"							  	
				  onclick="amore('all','#ProgramCode#_#Edition#_#url.Fund#_#CurrentRow#','#edition#','#URL.Fund#','#URL.ID#','#planningperiod#','#URL.ProgramCode#','#Code#','show','list','#url.mission#','#ProgramHierarchy#','#UnitHierarchy#','#filtermode#','1')" 			  
				  bgcolor="D9FFD9">		   
							
			<cfelse>
			
			<td bgcolor="D9FFD9" style="#ostyle#; <cfif filtermode eq 'resource'>font-weight:bold</cfif>" align="right">
			
			</cfif>
			
			
			<cf_space spaces="#spc#">		
			<cfif Funding.total eq "">
			
			  <cfset all = 0>
			  -
			<cfelse>
			  <cfset all =  Funding.total>
			  #numberformat(all/1000,",_._")#
			</cfif>								
									
		    </td>		
		
		</cfif>
		
		<cfif url.mode eq "List">
				
			<!--- define pipile --->
			
			<cftry>
			
				<!--- define reservations --->
				<cfquery name="Pipeline" 
				datasource="AppsQuery" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				SELECT   SUM(ReservationAmount) as ReservationAmount
				FROM     dbo.#SESSION.acc#Pipeline		
				
				<cfif ProgramHierarchy neq "">
					
					WHERE       ProgramHierarchy LIKE '#ProgramHierarchy#%'	
													
				<cfelseif ProgramCode neq "">
					
					WHERE       ProgramCode = '#ProgramCode#'
																	
				</cfif>							
				
				<cfif filtermode eq "resource">
					
					AND     ObjectCode IN (SELECT Code 
								            FROM   Program.dbo.Ref_Object 
											WHERE  Resource = '#Resource#')
							  				
				<cfelse>
	
					AND      (
						      ObjectCode = '#Code#' OR 
						      ObjectCode IN (SELECT Code 
							                FROM   Program.dbo.Ref_Object 
											WHERE  ParentCode = '#Code#')
						  )			
						  
				</cfif>		  
				
				<cfif url.fund neq "">
				AND      Fund       = '#URL.Fund#'				   			
				</cfif>
				</cfquery>
							
			<cfcatch>
						   
				<cfinvoke component = "Service.Process.Program.Execution"  
				   method           = "Requisition" 
				   mission          = "#url.mission#"
				   period           = "#persel#" 
				   currency         = "#application.basecurrency#"
				   fund             = "#url.fund#"
				   status           = "pipeline"
				   unithierarchy    = "#url.unithierarchy#"
				   programcode      = "#url.programcode#"
				   programhierarchy = "#ProgramHierarchy#"
				   object           = "#code#"
				   objectchildren   = "1"
				   mode             = "view"
				   returnvariable   = "Pipeline">		 
					
			</cfcatch>
			
			</cftry>	
			
			<cfif url.mission neq "STL">	
								
				<cfif Pipeline.ReservationAmount neq "" and programhierarchy neq "">
				    <td align="right" bgcolor="ffffaf"		
					 style="#ostyle#;cursor:pointer"	
					 onclick="bmore('add','#ProgramCode#_#Edition#_#url.Fund#_#CurrentRow#','#URL.Fund#','#URL.ID#','#URL.Period#','#URL.ProgramCode#','#Code#','show','list','#url.mission#','#ProgramHierarchy#','#UnitHierarchy#','#edition#','#filtermode#')">					
				<cfelse>			
				    <td align="right" style="#ostyle#" bgcolor="ffffef">									
				</cfif>
										
				<cfif Pipeline.ReservationAmount eq "">
					  <cfset pip = 0>
					  <cf_space align="right" label="-" spaces="#spc#">
				<cfelse>
					  <cfset pip =  Pipeline.ReservationAmount>
					  <cf_space align="right" label="#numberformat(pip/1000,",_._")#" spaces="#spc#">
				</cfif>
								
				</td>
			
			</cfif>
				
		</cfif>
					
		<cftry>
		
			<!--- define reservations --->
			<cfquery name="Planned" 
			datasource="AppsQuery" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			SELECT   SUM(ReservationAmount) as ReservationAmount
			FROM     dbo.#SESSION.acc#Planned		
			WHERE    1 = 1
			<cfif ProgramHierarchy neq "">
				
				AND       ProgramHierarchy LIKE '#ProgramHierarchy#%'	
												
			<cfelseif ProgramCode neq "">
				
				AND       ProgramCode = '#ProgramCode#'
																
			</cfif>							
			
			<cfif filtermode eq "resource">
				
				AND     ObjectCode IN (SELECT Code 
							            FROM   Program.dbo.Ref_Object 
										WHERE  Resource = '#Resource#')
						  				
			<cfelse>

				AND      (
					      ObjectCode = '#Code#' OR 
					      ObjectCode IN (SELECT Code 
						                FROM   Program.dbo.Ref_Object 
										WHERE  ParentCode = '#Code#')
					  )			
					  
			</cfif>		  
			
			<cfif url.fund neq "">
			AND      Fund       = '#URL.Fund#'				   			
			</cfif>
			</cfquery>
						
			<cfcatch>
						   
				<cfinvoke component = "Service.Process.Program.Execution"  
				   method           = "Requisition" 
				   mission          = "#url.mission#"
				   period           = "#persel#" 
				   currency         = "#application.basecurrency#"
				   fund             = "#url.fund#"
				   status           = "planned"
				   unithierarchy    = "#url.unithierarchy#"
				   programcode      = "#url.programcode#"
				   programhierarchy = "#ProgramHierarchy#"
				   object           = "#code#"
				   objectchildren   = "1"
				   mode             = "view"
				   returnvariable   = "Planned">		 
					
			</cfcatch>
		
		</cftry>	
							
		<cfif Planned.ReservationAmount neq "" and programhierarchy neq "">
		
		    <td align="right" bgcolor="ffffaf"		
			 style="#ostyle#;cursor:pointer; <cfif filtermode eq 'resource'>font-weight:bold</cfif>"	
			 onclick="bmore('add','#ProgramCode#_#Edition#_#url.Fund#_#CurrentRow#','#URL.Fund#','#URL.ID#','#URL.Period#','#URL.ProgramCode#','#Code#','show','list','#url.mission#','#ProgramHierarchy#','#UnitHierarchy#','#edition#','#filtermode#')">		
			 		 			
		<cfelse>
		
		    <td align="right" style="#ostyle#; <cfif filtermode eq 'resource'>font-weight:bold</cfif>" bgcolor="ffffef">		
						
		</cfif>
		
		<cf_space spaces="#spc#">
		<cfif Planned.ReservationAmount eq "">
			  <cfset pla = 0>
			  -
		<cfelse>
			  <cfset pla =  Planned.ReservationAmount>
			  #numberformat(pla/1000,"_,_._")#
		</cfif>
	
	    </td>
					
		<!--- define reservations --->
		
		<cftry>
		
			<!--- define reservations --->
			<cfquery name="Reservation" 
			datasource="AppsQuery" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			SELECT   SUM(ReservationAmount) as ReservationAmount
			FROM     dbo.#SESSION.acc#Requisition	
			WHERE    1 = 1		
			<cfif ProgramHierarchy neq "">
				
				AND       ProgramHierarchy LIKE '#ProgramHierarchy#%'	
												
			<cfelseif ProgramCode neq "">
				
				AND       ProgramCode = '#ProgramCode#'
																
			</cfif>			
			
			<cfif filtermode eq "resource">
				
				AND     ObjectCode IN (SELECT Code 
							            FROM   Program.dbo.Ref_Object 
										WHERE  Resource = '#Resource#')
						  				
			<cfelse>

				AND      (
					      ObjectCode = '#Code#' OR 
					      ObjectCode IN (SELECT Code 
						                FROM   Program.dbo.Ref_Object 
										WHERE  ParentCode = '#Code#')
					  )			
					  
			</cfif>		  
			
			<cfif url.fund neq "">
			AND      Fund       = '#URL.Fund#'				   			
			</cfif>
			
			</cfquery>		
			
			<cfcatch>
			
				<cfinvoke component = "Service.Process.Program.Execution"  
				   method           = "Requisition" 
				   mission          = "#url.mission#"
				   period           = "#persel#" 
				   currency         = "#application.basecurrency#"
				   fund             = "#url.fund#"			   
				   status           = "cleared"
				   unithierarchy    = "#url.unithierarchy#"
				   programcode      = "#url.programcode#"
				   programhierarchy = "#ProgramHierarchy#"
				   object           = "#code#"			  
				   objectchildren   = "1" 
				   mode             = "view"
				   returnvariable   = "Reservation">		
					
			</cfcatch>	
		
		</cftry>								
					
		<cfif Reservation.ReservationAmount neq "" and programhierarchy neq "">
		    <td align="right" bgcolor="ffffaf"		
			 style="#ostyle#;cursor:pointer; <cfif filtermode eq 'resource'>font-weight:bold</cfif>"	
			 onclick="bmore('add','#ProgramCode#_#Edition#_#url.Fund#_#CurrentRow#','#URL.Fund#','#URL.ID#','#URL.Period#','#URL.ProgramCode#','#Code#','show','list','#url.mission#','#ProgramHierarchy#','#UnitHierarchy#','#edition#','#filtermode#')">		
			 			 			
		<cfelse>
		    <td align="right" style="#ostyle#; <cfif filtermode eq 'resource'>font-weight:bold</cfif>" bgcolor="ffffef">		   
			
		</cfif>
		
		<cf_space spaces="#spc#">
		<cfif Reservation.ReservationAmount eq "">
		  <cfset res = 0>
		  -
		<cfelse>
		  <cfset res =  Reservation.ReservationAmount>
		  #numberformat(res/1000,"_,_._")#
		</cfif>
	
	 </td>
	
		<!--- define reservations --->
		
		<cfif url.mode neq "List">
		
		<cftry>
		
			<!--- define reservations --->
			<cfquery name="Obligation" 
			datasource="AppsQuery" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				SELECT   SUM(ObligationAmount) as ObligationAmount
				FROM     dbo.#SESSION.acc#Obligation
				WHERE    1 = 1
				<cfif ProgramHierarchy neq "">				
				AND       ProgramHierarchy LIKE '#ProgramHierarchy#%'													
				<cfelseif ProgramCode neq "">					
				AND       ProgramCode = '#ProgramCode#'																	
				</cfif>			
				
				<cfif filtermode eq "resource">
				
				AND     ObjectCode IN (SELECT Code 
							            FROM   Program.dbo.Ref_Object 
										WHERE  Resource = '#Resource#')
						  				
				<cfelse>
	
					AND      (
						      ObjectCode = '#Code#' OR 
						      ObjectCode IN (SELECT Code 
							                FROM   Program.dbo.Ref_Object 
											WHERE  ParentCode = '#Code#')
						  )			
						  
				</cfif>		  
				<cfif url.fund neq "">
				AND      Fund       = '#URL.Fund#'		
				</cfif>										   
			</cfquery>
						
			<cfcatch>
			
			  <cfinvoke component = "Service.Process.Program.Execution"  
			   method           = "Obligation" 
			   mission          = "#url.mission#"
			   period           = "#persel#" 
			   currency         = "#application.basecurrency#"
			   fund             = "#url.fund#"
			   unithierarchy    = "#url.unithierarchy#"
			   programcode      = "#url.programcode#"
			   programhierarchy = "#ProgramHierarchy#"
			   object           = "#code#"
			   objectchildren   = "1"
			   mode             = "view"
			   returnvariable   = "Obligation">		
						
			</cfcatch>
		
		</cftry>
			
		<cfif Obligation.ObligationAmount neq "" and programhierarchy neq "">
		
		   <td align="right" 
			 onclick="bmore('add','#ProgramCode#_#edition#_#url.Fund#_#CurrentRow#','#url.Fund#','#URL.ID#','#URL.Period#','#URL.ProgramCode#','#Code#','show','list','#url.mission#','#ProgramHierarchy#','#UnitHierarchy#','#edition#','#filtermode#')" 
			 bgcolor="F3F3DA" style="#ostyle#;cursor:pointer; <cfif filtermode eq 'resource'>font-weight:bold</cfif>">		 
					
		<cfelse>
		    <td align="right" style="#ostyle#; <cfif filtermode eq 'resource'>font-weight:bold</cfif>" bgcolor="F3F3DA">
		</cfif>
		
		<cf_space spaces="#spc#">
		<cfif Obligation.ObligationAmount eq "">		 
		  -
		  <cfset obl = 0>
		<cfelse>
		  <cfset obl =  Obligation.ObligationAmount>
		  #numberformat(obl/1000,"_,_._")#
		</cfif>			
	
	    </td>
		
		</cfif>
					
		<cfif url.mode eq "List">
				
			<cftry>
								
				<!--- define reservations --->
				<cfquery name="Unliquidated" 
				datasource="AppsQuery" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				SELECT   SUM(ObligationAmount) as ObligationAmount
				FROM     dbo.#SESSION.acc#Unliquidated
				WHERE    1=1
				<cfif ProgramHierarchy neq "">
				
					AND     ProgramHierarchy LIKE '#ProgramHierarchy#%'	
												
				<cfelseif ProgramCode neq "">
					
					AND      ProgramCode = '#ProgramCode#'
																	
				</cfif>			
				
				<cfif filtermode eq "resource">
				
					AND     ObjectCode IN (SELECT Code 
							            FROM   Program.dbo.Ref_Object 
										WHERE  Resource = '#Resource#')
						  				
				<cfelse>
	
					AND      (
						      ObjectCode = '#Code#' OR 
						      ObjectCode IN (SELECT Code 
							                FROM   Program.dbo.Ref_Object 
											WHERE  ParentCode = '#Code#')
						  )			
						  
				</cfif>		  
				
				<cfif url.fund neq "">
				AND      Fund       = '#URL.Fund#'		
				</cfif>																   
				</cfquery>
				
																	
				<cfcatch>								
								
					<cfquery name="Parameter" 
					datasource="AppsPurchase" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
						SELECT    *
						FROM      Ref_ParameterMission
						WHERE     Mission = '#URL.Mission#'	
					</cfquery>	
					
					<cfquery name="Mission" 
					datasource="AppsOrganization" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
						SELECT    *
						FROM      Ref_Mission
						WHERE     Mission = '#URL.Mission#'	
					</cfquery>											
									
					<cfif mission.ProcurementMode eq "1">  
											
						<!--- ---------------unliq obligations----------- --->		   
						
						<cfinvoke component = "Service.Process.Program.Execution"  
						   method           = "Obligation" 
						   mission          = "#url.mission#"
						   period           = "#persel#" 
						   currency         = "#application.basecurrency#"
						   fund             = "#url.fund#"
						   unithierarchy    = "#url.unithierarchy#"
						   programcode      = "#url.programcode#"
						   programhierarchy = "#ProgramHierarchy#"
						   object           = "#code#"
						   objectchildren   = "1"
						   scope            = "Unliquidated"
						   mode             = "view"
						   returnvariable   = "Unliquidated">		
							   
					<cfelse>
											   		   			   
						<!--- -------- posted obligations : Dev -------- --->
						
						<cfinvoke component = "Service.Process.Program.Execution"  
						   Method           = "Disbursement" 
						   Mission          = "#url.mission#"
						   Period           = "#persel#" 
						   AccountPeriod    = "#peraccsel#"
						   currency         = "#application.basecurrency#"
						   Fund             = "#url.fund#"
						   unithierarchy    = "#url.unithierarchy#"
						   programcode      = "#url.programcode#"
						   Programhierarchy = "#ProgramHierarchy#"
						   Scope            = "Budget"
						   TransactionSource  = "'Obligation'"
						   Object           = "#code#"
						   objectchildren   = "1"						   
						   Mode             = "view"
						   returnvariable   = "Unliquidated">		
										
					
					</cfif>		
											
				</cfcatch>
			
			</cftry>
			
			<cfif Unliquidated.ObligationAmount neq "" and programhierarchy neq "">
			
			   <td align="right" bgcolor="F3F3DA"
				 onclick="umore('add','#ProgramCode#_#edition#_#url.Fund#_#CurrentRow#','#url.Fund#','#URL.ID#','#URL.Period#','#URL.ProgramCode#','#Code#','show','list','#url.mission#','#ProgramHierarchy#','#UnitHierarchy#','#edition#','#filtermode#')" 				 
				 style="cursor:pointer; #ostyle#; <cfif filtermode eq 'resource'>font-weight:bold</cfif>">		 
				  					
			<cfelse>
		
			    <td align="right" style="#ostyle#; <cfif filtermode eq 'resource'>font-weight:bold</cfif>" bgcolor="F3F3DA">
		
			</cfif>
			
			<cf_space spaces="#spc#">
			<cfif Unliquidated.ObligationAmount eq "">
			  <cfset unl =  0>
			  -
			<cfelse>
			  <cfset unl =  Unliquidated.ObligationAmount>
			  #numberformat(unl/1000,",_._")#
			</cfif>
			
			
						
			</td>	
		
		<cfelse>
		
			<cfif Parameter.FundingCheckCleared eq "0">
			
				<td align="right" bgcolor="ffffef" style="#ostyle#; <cfif filtermode eq 'resource'>font-weight:bold</cfif>" bgcolor="E7F5FA">												
				<cf_space spaces="#spc#"> #numberformat((rsc-pla-obl-res)/1000,',_._')#								
				</td>
			
			<cfelse>
				
				<td align="right" bgcolor="ffffef" style="#ostyle#; <cfif filtermode eq 'resource'>font-weight:bold</cfif>" bgcolor="E7F5FA">												
				<cf_space spaces="#spc#"> #numberformat((all-pla-obl-res)/1000,',_._')#
				</td>
			
			</cfif>
				
		 </cfif>
				
		<cftry>
									
			<!--- define disbursement --->
			<cfquery name="Invoice" 
			datasource="AppsQuery" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				SELECT   SUM(InvoiceAmount) as InvoiceAmount
				FROM     dbo.#SESSION.acc#Invoice
				WHERE  1=1
				
				<cfif ProgramHierarchy neq "">
				
					AND     ProgramHierarchy LIKE '#ProgramHierarchy#%'	
												
				<cfelseif ProgramCode neq "">
					
					AND     ProgramCode = '#ProgramCode#'
																	
				</cfif>								
				
				<cfif filtermode eq "resource">
				
				AND     ObjectCode IN (SELECT Code 
							            FROM   Program.dbo.Ref_Object 
										WHERE  Resource = '#Resource#')
						  				
				<cfelse>
	
					AND      (
						      ObjectCode = '#Code#' OR 
						      ObjectCode IN (SELECT Code 
							                FROM   Program.dbo.Ref_Object 
											WHERE  ParentCode = '#Code#')
						  )			
						  
				</cfif>		  
				
				<cfif url.fund neq "">
				AND      Fund       = '#URL.Fund#'		
				</cfif>		
							   
			</cfquery>
												
			<cfcatch>
									
				<cfinvoke component = "Service.Process.Program.Execution"  
				   Method           = "Disbursement" 
				   Mission          = "#url.mission#"
				   Period           = "#persel#" 
				   AccountPeriod    = "#peraccsel#"
				   currency         = "#application.basecurrency#"
				   Fund             = "#url.fund#"
				   unithierarchy    = "#url.unithierarchy#"
				   programcode      = "#url.programcode#"
				   Programhierarchy = "#ProgramHierarchy#"
				   Scope            = "Budget"
				   Object           = "#code#"
				   ObjectChildren   = "1"
				   Mode             = "view"
				   returnvariable   = "Invoice">		
			   					
			</cfcatch>
		
		</cftry>
		
	<cfif Invoice.InvoiceAmount neq "">
	
			<td align="right"
			style="#ostyle# cursor:pointer; <cfif filtermode eq 'resource'>font-weight:bold</cfif>" bgcolor="F3F3DA"		
			onclick="imore('inv','#ProgramCode#_#edition#_#url.Fund#_#CurrentRow#','#url.Fund#','#URL.ID#','#URL.Period#','#URL.ProgramCode#','#Code#','show','list','#url.mission#','#ProgramHierarchy#','#UnitHierarchy#','#edition#','#filtermode#')">
		
	<cfelse>
	
			<td align="right" style="#ostyle#; <cfif filtermode eq 'resource'>font-weight:bold</cfif>" bgcolor="F3F3DA">
		
	</cfif>	
	
	<cf_space spaces="#spc#">
	<cfif Invoice.InvoiceAmount eq "">
		  	<cfset dis = 0>
			-
	<cfelse>
		  	<cfset dis =  Invoice.InvoiceAmount>
			#numberformat(dis/1000,",_._")#
	</cfif>
						
	</td>
	
		<cfif url.mode eq "List">
			
		<td align="right" bgcolor="B7DBFF" style="#ostyle#; <cfif filtermode eq 'resource'>font-weight:bold</cfif>">	
		
			    <cfif url.mission eq "O">
				
				  <cftry>
				  
					  <cfquery name="IMIS" 
						datasource="AppsQuery" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">
							SELECT   SUM(ExpenditureAmount) as ExpenditureAmount
							FROM     #SESSION.acc#IMIS		
							<cfif ProgramHierarchy eq "">
							WHERE    1=1
							<cfelse>
							WHERE    ProgramHierarchy LIKE '#ProgramHierarchy#%' 
							</cfif>
							<cfif url.fund neq "">						  
							AND       Fund = '#url.fund#'					
							</cfif>		
								
							<cfif filtermode eq "resource">
					
								AND     ObjectCode IN (SELECT Code 
										            FROM   Program.dbo.Ref_Object 
													WHERE  Resource = '#Resource#')
									  				
							<cfelse>
				
								AND      (
									      ObjectCode = '#Code#' OR 
									      ObjectCode IN (SELECT Code 
										                FROM   Program.dbo.Ref_Object 
														WHERE  ParentCode = '#Code#')
									  )			
									  
							</cfif>								
							
						</cfquery>	
												
						<cfif IMIS.ExpenditureAmount eq "">
						  <cfset ims = 0>
						<cfelse>
						  <cfset ims =  IMIS.ExpenditureAmount>
						</cfif>	
						
						<cf_space align="right" label="#numberformat(ims/1000,",_._")#" spaces="#spc#">
					
					<cfcatch></cfcatch>
					</cftry>
															
				<cfelse>			
					<cfif unl+dis eq "0">
					    <cf_space spaces="#spc#"> -
					<cfelse>
						<cf_space spaces="#spc#"> #numberformat((unl+dis)/1000,",_._")#
					</cfif>
				</cfif>		
																
		</td>
		
		</cfif>
		
		<cfif url.mode eq "List">
		
			<cfif Parameter.FundingCheckCleared eq "0">		
					
				<cfset diff = rsc-pla-res-unl-dis>
			
				<cfif diff lt 0>
				    <cfset cl = "red">
				<cfelse>
				    <cfset cl = "black"> 
				</cfif>							
			    
			<cfelse>
			
				<cfset diff = all-pla-res-unl-dis>
			
				<cfif diff lt 0>
				    <cfset cl = "red">
				<cfelse>
				    <cfset cl = "black"> 
				</cfif>				
			   
			</cfif>   
	
			<td align="right" bgcolor="E7F5FA" style="#ostyle#; color:#cl#; <cfif filtermode eq 'resource'>font-weight:bold</cfif>">																	
				<cf_space spaces="#spc#"> #numberformat((diff)/1000,',_._')#		
			</td>
		
		</cfif>
			
		<cfif url.mode eq "List">
					
			<cfset tot = pla+res+unl+dis>
			
			<cfif Parameter.FundingCheckCleared eq "0">
			
				<cfif rsc neq "0">
					<cfset exe = "#numberformat(tot*100/rsc,'._')#%">
					<cfif tot gt rsc>
						<cfset cl = "red">
					<cfelse>
						<cfset cl = "B0FFB0">
					</cfif>
				<cfelse>
					<cfset exe = "-">
					<cfset cl = "d4d4d4">
				</cfif>						
			
			<cfelse>
			
				<cfif all neq "0">
					<cfset exe = "#numberformat(tot*100/all,'._')#%">
					<cfif tot gt all>
						<cfset cl = "red">
					<cfelse>
						<cfset cl = "B0FFB0">
					</cfif>
				<cfelse>
					<cfset exe = "-">
					<cfset cl = "d4d4d4">
				</cfif>			
			
			</cfif>
			
			<td align="right" bgcolor="#cl#" style="#ostyle#; <cfif filtermode eq 'resource'>font-weight:bold;</cfif>">
				<cf_space spaces="#spc#"> #exe#
			</td>	
			
			
			
		</cfif>	
	
</cfoutput>	