
<!--- this is general wrapper for the EDI processes --->

<cfcomponent>

    <cfproperty name="name" type="string">
    <cfset this.name = "EDI routing cfc">
	
	<!--- custom validation, 
	      sale issue, 
		  sale void --->
		
	<cffunction name="CustomerValidate"
             access="remote"
             returntype="any"
             returnformat="plain"
             displayname="ValidateCustomer">			 
			 
			 <cfargument name="Mission"        type="string"  required="true"   default="">
			 <cfargument name="CustomerName"   type="string"  required="false"  default="1">			 
			 <cfargument name="Reference"      type="string"  required="true"   default="">
			 <cfargument name="Datasource"     type="string"  required="true"   default="appsOrganization">	
							
			 <cfquery name="qmission" 
			  datasource="#ARGUMENTS.Datasource#" 
			  username="#SESSION.login#" 
			  password="#SESSION.dbpw#">
				    SELECT  *
					FROM   Organization.dbo.Ref_Mission
					WHERE  Mission = '#ARGUMENTS.Mission#'	    							   
			</cfquery>			
			
			<cfif qmission.EDIMethod neq "">			
				
				<cfinvoke component = "Service.Process.EDI.#qmission.EDIMethod#"  
			      method           = "CustomerValidate" 
				  datasource       = "#ARGUMENTS.Datasource#"
   				  mission          = "#ARGUMENTS.Mission#" 
			      customername     = "#ARGUMENTS.CustomerName#" 
			      reference        = "#ARGUMENTS.Reference#"
			      returnvariable   = "EDIResult">	 
			
			<cfelse>
			
				<cfset EDIResult.Status = "OK">
			
			</cfif>	
			
			<cfreturn EDIResult>
			 
	</cffunction>	
	
	<cffunction name="SaleIssue"
        access="public"
        returntype="any"
        returnformat="plain"
        displayname="SubmitSale">
			 
			 <cfargument name="Datasource"       type="string"  required="true"   default="appsOrganization">
			 <cfargument name="Mission"          type="string"  required="true"   default="">
			 <cfargument name="Terminal"         type="string"  required="true"   default="1">	
			 <cfargument name="Journal"          type="string"  required="true"   default="">
			 <cfargument name="JournalSerialNo"  type="string"  required="true"   default="">	
			 <cfargument name="eMailAddress"     type="string"  required="true"   default="">	 
			 <cfargument name="BatchId"          type="string"  required="true"   default="">
			 <cfargument name="ActionId"         type="string"  required="true"   default="">
			 <cfargument name="RetryNo"          type="string"  required="false"  default="0">
			 <cfargument name="Mode" 	         type="string"  required="false"  default="2">
			 
			 <cfif BatchId neq "">
			 
			 	<!--- passed the sale instead --->
			 
				 <cfquery name="GetTransaction"
					datasource="#ARGUMENTS.Datasource#"
					username="#SESSION.login#"
					password="#SESSION.dbpw#">
					SELECT *
					FROM   Accounting.dbo.TransactionHeader
					WHERE  TransactionSourceId = '#batchId#'
					AND    TransactionCategory = 'Receivables'					
				</cfquery>
				
				<cfset Journal         = getTransaction.Journal>
				<cfset JournalSerialNo = getTransaction.JournalSerialNo>			 
			 
			 </cfif>
			 
			 <cfquery name="qmission" 
			  datasource="#ARGUMENTS.Datasource#" 
			  username="#SESSION.login#" 
			  password="#SESSION.dbpw#">
				    SELECT *
					FROM   Organization.dbo.Ref_Mission
					WHERE  Mission = '#Mission#'												   
			</cfquery>
			
			<!--- there is an EDI --->

			<cfif qmission.EDIMethod neq "">			

				<cfif Mode eq "2">
				
				    <!--- 2020 mode current for POS only TO BE DEPRECATED --->
				
					<cfinvoke component = "Service.Process.EDI.#qmission.EDIMethod#"
				      	method              = "SaleIssueV2"
					  	datasource          = "#ARGUMENTS.Datasource#"
	   				  	mission             = "#Mission#"
				      	Terminal            = "#Terminal#"
						Batchid             = "#BatchId#"								      	
					  	RetryNo		        = "#RetryNo#"
				      	returnvariable      = "EDIResult">
					
				<cfelseif Mode eq "3">
				
					<!--- 2021 mode revised for all sales and POS AR --->
									
					<cfinvoke component      = "Service.Process.EDI.#qmission.EDIMethod#"
							method           = "SaleIssueV3"
							datasource       = "#ARGUMENTS.Datasource#"
							mission          = "#Mission#"
							Terminal         = "#Terminal#"
							Journal          = "#journal#"
							journalSerialNo  = "#journalserialNo#"		
							actionid         = "#actionid#"					
							RetryNo		     = "#RetryNo#"
							returnvariable   = "EDIResult">
														
				</cfif>
				
				<cfif EDIResult.Log eq "1">		
							
					<!--- create the log also with the NIT and document --->
					
					<cfquery name="checkAction"
		               datasource="AppsLedger"
		               username="#SESSION.login#"
		               password="#SESSION.dbpw#">
					   SELECT  *
					   FROM    TransactionHeaderAction
					   WHERE   Journal          = '#Journal#'
					   AND     JournalSerialNo  = '#JournalSerialNo#'
					   AND     ActionMode       = '2'
					   AND     ActionStatus     = '1'
					   AND     ActionReference1 = '#EDIResult.Cae#'
					   
					</cfquery>   
					
					<!--- this reference does not exist yet as approved --->
					<cfif checkaction.recordcount eq "0">
						<cfset status = "#EDIResult.Status#"> 
					<cfelse>
						<cfset status = "4">	
					</cfif>				
																	
					<cf_assignId>			

					<cfquery name="AddAction"
		               datasource="AppsLedger"
		               username="#SESSION.login#"
		               password="#SESSION.dbpw#">
		                  INSERT INTO TransactionHeaderAction
						  						  
		                         (ActionId,
							      Journal,
		                          JournalSerialNo,
		                          ActionCode,     
							      ActionMode,  
								  
								  ActionSource1,
								  ActionSource2,
								  
								  <!---
							      <cfif Invoice.Mode eq "2" and Invoice.Status eq "1">
								  --->
								  
								   <!--- more information --->	
								  ActionReference1,
								  ActionReference2,
								  ActionReference3,						                       								
							      ActionReference4,
								  ActionReference5,
								   
								  <!--- 
								  <cfelseif getWarehouseJournal.TransactionMode eq "2">  <!--- Mode was 2 but no connection to the GFACE --->
								   ActionReference4,
								  </cfif>
								  --->
								  
								  ActionMemo,
								  ActionContent,
		                          ActionDate,
				  			      ActionStatus,  
								  eMailAddress,                              
		                          OfficerUserId,
		                          OfficerLastName,
		                          OfficerFirstName)
								  
		                  VALUES ('#rowguid#',
								  '#Journal#',
		            		      '#JournalSerialNo#',
		                          'Invoice',		
								  '2',		<!--- electronic --->	
								  '#EDIResult.Source1#',
								  '#EDIResult.Source2#',								  
								  	
								  <!---			
								  <cfif Invoice.Mode eq "2" and Invoice.Status eq "1">												                     
								  --->
										'#EDIResult.Cae#',
										'#EDIResult.DocumentNo#',
										'#EDIResult.Dte#',
										<cfif StructKeyExists(EDIResult,"SeriesNo")>
										'#EDIResult.SeriesNo#',
										<cfelse>
											'FEL',   <!--- hardcoded hanno --->
										</cfif>										
										<cfif StructKeyExists(EDIResult,"Series")>
										'#EDIResult.Series#',
										<cfelse>
										NULL,
										</cfif>
										
								  <!--- 		
								  <cfelseif getWarehouseJournal.TransactionMode eq "2">
								  		<cfif Invoice.Status eq "1">
									  		'#GetManualSeries.SeriesNo#',
										<cfelse>
											'ERROR',
										</cfif>
								  </cfif> 	
								  --->							  
								  
								  '#left(EDIResult.ErrorDescription,100)#',
								  '#EDIResult.ErrorDetail#',
								  #EDIResult.ActionDate#,
				                  								                                  
		        		          '#Status#',     <!--- process completed 1 or 9 --->
								  '#eMailAddress#',
		                	      '#SESSION.acc#',
		                          '#SESSION.last#',								  
				                  '#SESSION.first#')  
								                 
		            </cfquery>  				
	
				</cfif>		
				
				<cfif EDIResult.Status eq "9">
			         <cfset EDIResult.Status   = "FALSE">	
				<cfelse>
				     <cfset EDIResult.Status   = "OK">																
				</cfif>
				
				<cfset EDIResult.ActionId = rowguid>				

			<cfelse>
			
				<cfset EDIResult.Status   = "OK">
				<cfset EDIResult.ActionId = "">
			
			</cfif>
			
			<cfreturn EDIResult>
		 
	</cffunction>			  		
	
	<cffunction name="SaleVoid"
             access="public"
             returntype="any"
             returnformat="plain"
             displayname="VoidSale">
			 
			 <cfargument name="Datasource"       type="string"  required="true"   default="appsOrganization">
			 <cfargument name="Mission"          type="string"  required="true"   default="">
			 <cfargument name="Terminal"         type="string"  required="true"   default="1">	
			 <cfargument name="Journal"          type="string"  required="true"   default="">
			 <cfargument name="JournalSerialNo"  type="string"  required="true"   default="">		 		 
			 <cfargument name="BatchId"          type="string"  required="true"   default="">
			 
			  <cfif BatchId neq "">
			 
			 	<!--- passed the sale no instead --->
			 
				 <cfquery name="GetTransaction"
					datasource="#ARGUMENTS.Datasource#"
					username="#SESSION.login#"
					password="#SESSION.dbpw#">
					SELECT *
					FROM   Accounting.dbo.TransactionHeader
					WHERE  TransactionSourceId = '#batchId#'
					AND    TransactionCategory = 'Receivables'					
				</cfquery>
				
				<cfset Journal         = getTransaction.Journal>
				<cfset JournalSerialNo = getTransaction.JournalSerialNo>			 
			 
			 </cfif>
			 
			  <cfquery name="qmission" 
			  datasource="#ARGUMENTS.Datasource#" 
			  username="#SESSION.login#" 
			  password="#SESSION.dbpw#">
				    SELECT  *
					FROM   Organization.dbo.Ref_Mission
					WHERE  Mission = '#Mission#'					   
			</cfquery>
			
			
			<cfif qmission.EDIMethod neq "">	
						
				<cfinvoke component   = "Service.Process.EDI.#qmission.EDIMethod#"  
			      method              = "SaleVoid" 
				  datasource          = "#ARGUMENTS.Datasource#"
   				  mission             = "#Mission#" 
			      Terminal            = "#Terminal#" 
				  Journal             = "#journal#"
				  journalSerialNo     = "#journalserialNo#"						  
			      returnvariable      = "EDIResult">
				  
				  <cfparam name="EDIResult.log" default="1">
					 
				  				  
				  <cfif EDIResult.Log eq "1">
				  				  				  		  
					  <!--- record action --->
					  
					    <cf_assignId>	
						
						<cfquery name="AddAction"
								datasource="#datasource#"
								username="#SESSION.login#"
								password="#SESSION.dbpw#">
																								
								INSERT INTO Accounting.dbo.TransactionHeaderAction
				
										(ActionId,
										Journal,
										JournalSerialNo,
										ActionCode,
										ActionSource1,
										ActionSource2,
										ActionMode,
										
										<!--- more information --->
										ActionReference1,
										ActionReference2,
										ActionReference3,
										ActionReference4,
										ActionMemo,
										ActionStatus,
										ActionDate,										
										OfficerUserId,
										OfficerLastName,
										OfficerFirstName)
				
								VALUES ('#rowguid#',
										'#Journal#',
										'#JournalSerialNo#',
										'CreditNote', 
										'#EDIResult.Source1#',
										'#EDIResult.Source2#',
										'2', <!--- auto fel --->
										<!--- more information --->
										'#EDIResult.Cae#',
										'#EDIResult.DocumentNo#',
										'#EDIResult.Dte#',
										'FEL',
										<!---  '#GetWarehouseSeries.SeriesNo#', --->
										'#left(EDIResult.ErrorDescription,100)#',										
										'5',     <!--- 5 void process completed --->
										#EDIResult.ActionDate#,
										'#SESSION.acc#',
										'#SESSION.last#',
										'#SESSION.first#')
										
						</cfquery>
				  
				  </cfif>
				  
				 
			<cfelse>
			
				<cfset EDIResult.Status = "No">
			
			</cfif>
			
			<cfreturn EDIResult>
			 
	</cffunction>		    
	
</cfcomponent>	