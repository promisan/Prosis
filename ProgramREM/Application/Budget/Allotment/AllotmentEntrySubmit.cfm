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
<cfset st = "0">
<link rel="stylesheet" type="text/css" href="<cfoutput>#SESSION.root#/#client.style#</cfoutput>">

<cfparam name="URL.Status" default="0">
<cfparam name="URL.Mode"   default="Embed">

<cf_tl id="You have entered one or more non numeric amounts" var="1" class="text">
<cfset vMore=lt_text>

<cf_tl id="Operation aborted" var="1" class="text">
<cfset vAbort=lt_text>
  
<cftransaction>

<!--- update visibility --->

<!--- this is done through ajax --->
	
	<cfquery name="Check" 
		datasource="AppsProgram" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		DELETE FROM ProgramObject
		WHERE      ProgramCode = '#program#'		
	</cfquery>
	
	<cfloop index="rec" from="1" to="#Form.No#" step="1">
	
		<cfparam name="FORM.Show_#Rec#" default="">
		<cfset object      = Evaluate("FORM.Show_" & Rec)>
		
		<cfif object neq "">	
		
			<!--- not needed as this is on the fly 	
						 
			<cfquery name="EditionFund" 
			datasource="AppsProgram" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				SELECT   DISTINCT ltrim(rtrim(F.Fund)) as Fund
				FROM     Ref_AllotmentEdition E,
				         Ref_AllotmentEditionFund F
				WHERE    E.EditionId IN (#Form.Edition#)	
				AND      E.BudgetEntryMode = 0 <!--- detailed entry disabled here --->
				AND      E.EditionId = F.EditionId	
			</cfquery>	
			
			
			<cfloop query="EditionFund">
		
				<cfquery name="Insert" 
					datasource="AppsProgram" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
					INSERT INTO ProgramObject
					       (ProgramCode, ObjectCode,Fund)
					VALUES ('#Program#','#Object#','#fund#')			
				</cfquery>
			
			</cfloop>
			
			--->
		
		</cfif>
	
	</cfloop>
	
<cfset program     = Evaluate("FORM.Program")>
<cfset period      = Evaluate("FORM.Period")>
<cfset filterfund  = Evaluate("FORM.Fund")>

<cfset dateValue = "">
<CF_DateConvert Value="#form.TransactionDate#">
<cfset DTE = dateValue>

<cfquery name="Mission" 
datasource="AppsProgram" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT   *
	FROM     Program
	WHERE    ProgramCode = '#program#'
</cfquery>

<cfquery name="Parameter" 
datasource="AppsProgram" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT   *
	FROM     Ref_ParameterMission
	WHERE    Mission = '#Mission.Mission#'
</cfquery>

<cfset cur = Parameter.BudgetCurrency>
  
<cfquery name="EditionFund" 
datasource="AppsProgram" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT   E.EditionId, ltrim(rtrim(F.Fund)) as Fund
	FROM     Ref_AllotmentEdition E,
	         Ref_AllotmentEditionFund F
	WHERE    E.EditionId IN (#Form.Edition#)	
	AND      E.BudgetEntryMode = 0 <!--- detailed entry disabled here --->
	AND      E.EditionId = F.EditionId
	<cfif filterfund neq "">
	AND      F.Fund = '#filterFund#'
	</cfif>
	ORDER BY E.EditionId,F.Fund
</cfquery>

<!--- update amounts by edition --->

<cfloop query="EditionFund">
   
  <!--- verify if header program allotment record exists for the edition --->
  
  <cfquery name="Check" 
	datasource="AppsProgram" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT     *
	FROM       ProgramAllotment
	WHERE      ProgramCode = '#program#'	
	AND        Period      = '#period#'   
	AND        EditionId   = '#EditionId#'
  </cfquery>
  
  <cfquery name="getPeriod" 
	     datasource="AppsProgram" 
	     username="#SESSION.login#" 
	     password="#SESSION.dbpw#">
	     SELECT     *
	     FROM       Ref_Period
		 WHERE      Period = '#period#'			    
	</cfquery>  
  
  <cfif Check.recordcount eq "0">
  
	  <cfquery name="Insert" 
		datasource="AppsProgram" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		INSERT INTO ProgramAllotment
		   (ProgramCode, 
		    Period, 
			EditionId,
			OfficerUserId, 
			OfficerLastName, 
			OfficerFirstName)
		Values ('#Program#', 
		        '#period#', 
				'#EditionId#', 
				'#SESSION.acc#', 
				'#SESSION.last#', 
				'#SESSION.first#')
	  </cfquery>

  </cfif>
      
  <cfquery name="Check" 
     datasource="AppsProgram" 
     username="#SESSION.login#" 
     password="#SESSION.dbpw#">
     SELECT     P.Status, 
	            E.BudgetEntryMode, 
			    E.EntryMethod, 
				E.EditionClass
     FROM       Ref_AllotmentEdition E, 
	            ProgramAllotment P
     WHERE      E.EditionId   = P.EditionId
	 AND        P.ProgramCode = '#Program#'
	 AND        P.Period      = '#period#' 
	 AND        P.EditionId   = '#EditionId#'	
  </cfquery>	
  
  <cfif Check.BudgetEntryMode eq "0"> 
	    
	  <cfif Check.EntryMethod eq "Snapshot" or Check.Status eq "0"> 
	    
	    <!--- remove all prior values in case of snapshot OR in case of
		transaction with the header record status = 0 see FR pg 15.--->
		
		<cfset st = "1">
		  
	    <cfquery name="RemovePrior" 
		datasource="AppsProgram" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
				
		DELETE FROM ProgramAllotmentDetail
		WHERE      ProgramCode = '#program#'	
		AND        Period      = '#period#'    
		AND        EditionId   = '#EditionId#'
		AND        Fund        = '#Fund#'
		</cfquery>	
			
	  </cfif>	
  
  	  <cfset all = 0>
	   
	  <cf_exchangeRate 
	    DataSource    = "AppsProgram"
		CurrencyFrom  = "#cur#" 
		CurrencyTo    = "#Application.BaseCurrency#"
		EffectiveDate = "#dateformat(getPeriod.DateEffective,CLIENT.DateFormatShow)#">
				
	  <cfif Exc eq "0" or Exc eq "">
		 <cfset exc = 1>
	  </cfif>			

  	  <!--- now loop through all the fields in the entry screen --->
  
	  <cfloop index="rec" from="1" to="#Form.No#" step="1">
		
		  <!--- evaluate the value --->		  
		
		  <cfset object      = Evaluate("i#EditionId#_#Fund#_Code_#Rec#")>		  		  
		  <cfset amount      = Evaluate("i#EditionId#_#Fund#_Amount_#Rec#")>
		  <cfset prior       = Evaluate("i#EditionId#_#Fund#_AmountPrior_#Rec#")>				 
		  
		  <cfset Amount = replace(Amount,',','',"ALL")>
		  <cfset Prior  = replace(Prior,',','',"ALL")>
		  
		  <cfset amountBase = round((amount*100)/exc)/100>
		    
		  <cfif not isNumeric(amount) AND amount neq "">
		    		      
			  <cf_waitEnd>		 
			  
			  <cf_message message = "#vMore# #amount#. #vAbort#."
			              return = "back">
			  <cfabort>
		  
		  </cfif>
		  
		  <cfset NewAmount = amount>
		  
		  <cfif amount eq "" AND prior neq "">
		     	<cfset amount = "0">
		  </cfif>			  		    
		        
		  <cfif (Check.EntryMethod eq "Snapshot" OR Check.Status eq "0") AND NewAmount neq ""> 
		  											
				  <cfif amount neq prior and all eq "0">	
				   	  	  
					   <cfquery name="ResetHeaderStatus" 
						datasource="AppsProgram" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">
						UPDATE     ProgramAllotment
						SET        Status      = '#st#'
						WHERE      ProgramCode = '#program#'	
						AND        Period      = '#period#'    
						AND        EditionId   = '#EditionId#' 
					   </cfquery>
					   
					   <!--- prevent query per edition --->				
					   <cfset all = 1>		
					   	   
				  </cfif>					   
				   
				  <cfif amount neq "0">
				  									
					  <cfquery name="InsertAmount" 
						datasource="AppsProgram" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">
						INSERT INTO ProgramAllotmentDetail
								(ProgramCode, 
								 Period,
								 EditionId,
								 TransactionDate, 
								 Currency,
								 Amount,
								 ExchangeRate,
								 AmountBase,
								 Fund,
								 ObjectCode,
								 Status,
								 OfficerUserId, 
								 OfficerLastName, 
								 OfficerFirstName, 
								 Created)
						Values ('#Program#', 
						        '#Period#', 
						        '#Editionid#', 
								#dte#, 
								'#cur#',
								<cfif Parameter.BudgetAmountMode eq "0">
					 				#amount#,
									'#exc#',
									#amountBase#,
								 <cfelse>
									#amount#*1000.0,
									'#exc#',
									#amountBase#*1000.0,	
								</cfif>							
								'#Fund#',
								'#Object#',
								'#URL.Status#',
								'#SESSION.acc#', 
								'#SESSION.last#', 
								'#SESSION.first#', 
								getDate()
				    			)
					  </cfquery>
				  
				  </cfif>  
					 	    
		  <cfelse> 
		  
		      <!--- transaction method and program allotment status = 1 (approved) ------------------- ---> 		  
		      <!--- define sum of value of prior transaction entries -for the object, edition, program ---> 
			  <!--- ---------------------------------------------------------------------------------- --->
			 	  
			  <cfquery name="Prior" 
					datasource="AppsProgram" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
			        SELECT 	<cfif Parameter.BudgetAmountMode eq "0">
			 				SUM(Amount) AS Amount
							<cfelse>
							SUM(Amount/1000) AS Amount
							</cfif>	
			        FROM    ProgramAllotmentDetail
					WHERE   ProgramCode = '#program#'
					AND     Period      = '#period#'	   
			    	AND     EditionId   = '#Editionid#'
					AND     Fund        = '#Fund#'
					AND     ObjectCode  = '#Object#'				
					AND     Status != '9'
			  </cfquery> 
			  
			  <cfif amount eq "">
				   <cfset amount = 0>
			  </cfif>
			  	 	  	       
		      <cfif Prior.Amount neq Amount>	  
			  
			      <cfif Prior.Amount eq "">		  
				     <cfset  diff = Amount>
				  <cfelse>	  
		    		  <cfset diff = Amount-Prior.Amount> 		  
				  </cfif>
				  				  
				  <cfset diffB =  round((diff*100)/exc)/100>
		    	  
				  <cfif diff neq "" and (diff gte 0.01 or diff lte -0.01)>	
				  	  
				      <cfset st = "1">		
					  
					  <cf_assignid>		
					  
					   <cfquery name="InsertLogging" 
							datasource="AppsProgram" 
							username="#SESSION.login#" 
							password="#SESSION.dbpw#">
							INSERT INTO ProgramAllotmentAction
									(ActionId,
									 ProgramCode, 
								     EditionId,
								     Period,
								     ActionClass, 									
									 ActionType, 
									 Status,
									 OfficerUserId, 
									 OfficerLastName, 
									 OfficerFirstName)
							VALUES ('#rowguid#',
							        '#Program#', 
						            '#EditionId#', 
								    '#Period#',
								    'Update Cell', 									
									<cfif URL.Status eq "0">
										'Entry',
									<cfelse>
										'Approved',
									</cfif>	
									'#URL.Status#',
									'#SESSION.acc#', 
									'#SESSION.last#', 
									'#SESSION.first#')
					  </cfquery>  
					  
					  <!--- 20/8/2010 added condition not to neter 0 amounts --->
					  
					  <cfif diff neq "0">  
					  							  			  			  			  			  			  		  
						  <cfquery name="InsertTransaction" 
								datasource="AppsProgram" 
								username="#SESSION.login#" 
								password="#SESSION.dbpw#">
								INSERT INTO ProgramAllotmentDetail
									(TransactionId,
									 ProgramCode, 
									 EditionId,
									 Period,
									 ActionId,
									 TransactionDate, 
									 Currency,
									 Amount,
									 ExchangeRate,
									 AmountBase,
									 Fund,
									 ObjectCode,
									 Status,
									 OfficerUserId, 
									 OfficerLastName, 
									 OfficerFirstName)
								VALUES 
									('#rowguid#',
									 '#Program#', 
							        '#EditionId#', 
									'#Period#',
									'#rowguid#',
									#dte#, 
									'#cur#',
									<cfif Parameter.BudgetAmountMode eq "0">
						 				#diff#,
										'#exc#',
										#diffB#,
									 <cfelse>
										#diff#*1000.0,
										'#exc#',
										#diffB#*1000.0,
									</cfif>		
									'#fund#',
									'#Object#',
									'#URL.Status#',
									'#SESSION.acc#', 
									'#SESSION.last#', 
									'#SESSION.first#')
							</cfquery>  
						
						</cfif>
												 			  			
				  </cfif>
				
			  </cfif> 
			  
			</cfif>  
			  		  
	</cfloop>  
		
</cfif>  
		
</cfloop>
	
</cftransaction>

<cfoutput>

<cfif URL.caller eq "External">

	<script language="JavaScript">
	
	    window.close();
		<cfif st eq "1">
		    opener.history.go()
		</cfif>
		
	</script>

<cfelse>

	<cfset oSecurity = CreateObject("component","Service.Process.System.UserController")/>
	<cfset mid = oSecurity.gethash()/> 	

	<script language="JavaScript">			   
		window.location = "AllotmentInquiry.cfm?mid=#mid#&context=#url.context#&mode=#url.mode#&Program=#Program#&Version=#form.version#&Fund=#filterFund#&period=#period#&caller=#URL.caller#&Width=#URL.Width#&method=#URL.Method#"					
	</script>

</cfif>

</cfoutput>
