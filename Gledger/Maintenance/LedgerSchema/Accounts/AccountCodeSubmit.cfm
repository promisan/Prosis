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

<link rel="stylesheet" type="text/css" href="<cfoutput>#SESSION.root#/#client.style#</cfoutput>"> 

<cf_verifyOperational 
         datasource= "AppsLedger"
         module    = "Program" 
		 Warning   = "No">
		 
<cfparam name="Form.RevaluationMode" default="0">		 
		 		 
<cfif ParameterExists(Form.Insert)> 
		
		<cfquery name="Verify" 
		datasource="AppsLedger" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT *
		FROM   Ref_Account
		WHERE  (GLAccount  = '#Form.GLAccount#' or Description = '#Form.Description#')
		</cfquery>
		
		   <cfif Verify.recordCount gte 1>
		   
			   <script language="JavaScript">
			   
			     alert("An account with this code or description was registered already. Operation not allowed.")
			     
			   </script>  
		   
		  <cfelse>  
     
	   		<cftransaction>
			
			<cfquery name="Insert" 
			datasource="AppsLedger" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			INSERT INTO Ref_Account
			         (GLAccount,
					 AccountLabel, 
					 Description,
					 AccountGroup,
					 AccountType,
					 AccountClass,
					 AccountCategory,
					 TaxCode,		
					 MonetaryAccount,
					 <cfif Form.ForceCurrency neq "">
					 ForceCurrency,
					 </cfif>					
					 RevaluationMode,					
					 FundAccount,
					 PresentationClass,
					 BankReconciliation,
					 <cfif moduleenabled eq "1">		
					 ForceProgram,
					 </cfif>
					 TaxAccount,
					 <cfif moduleenabled eq "1">		
					 ObjectCode,
					 </cfif>
					 <cfif Form.BankId neq "">
					 BankId,
					 </cfif>
					 OfficerUserId,
					 OfficerLastName,
					 OfficerFirstName)
			  VALUES ('#Form.GLAccount#', 
			          '#Form.GLAccount#',
			          '#Form.Description#',
					  '#Form.AccountGroup#',
					  '#Form.AccountType#',
					  '#FORM.AccountClass#',
					  '#FORM.AccountCategory#',
					  '#Form.TaxCode#',		
					  '#Form.MonetaryAccount#',
					  <cfif Form.ForceCurrency neq "">					  
					  '#Form.ForceCurrency#',
					  </cfif>
					  '#Form.RevaluationMode#',					  
					  '#Form.FundAccount#',
					  '#Form.PresentationClass#',
					  '#Form.BankReconciliation#',
					   <cfif moduleenabled eq "1">	
					  '#Form.ForceProgram#',
					  </cfif>
					  '#Form.TaxAccount#',
					   <cfif moduleenabled eq "1">	
					  '#Form.ObjectCode#',
					  </cfif>
					  <cfif Form.BankId neq "">
					  '#Form.BankId#',
					  </cfif>
					  '#SESSION.acc#',
			    	  '#SESSION.last#',		  
				  	  '#SESSION.first#')  
			  </cfquery>
						  		
				<cfif Form.SystemAccount neq "">
				
					<cfquery name="Insert"
					datasource="AppsLedger" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
						INSERT INTO Ref_AccountMission 
						(Mission,GLAccount,OfficerUserId,OfficerLastName,OfficerFirstName)
						VALUES
						('#URL.mission#','#Form.GLAccount#','#SESSION.acc#','#SESSION.last#','#SESSION.first#')
					</cfquery>
						
					<cfquery name="Update" 
					datasource="AppsLedger" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
						UPDATE Ref_AccountMission
						SET    SystemAccount      = '#Form.SystemAccount#'			
						WHERE  GLAccount        = '#Form.GLAccount#'
						AND    Mission          = '#URL.Mission#'
					</cfquery>		
					
				<cfelse>	
				
					<!--- enable the account code for the selected mission immediately --->
				
					<cfquery name="Insert"
					datasource="AppsLedger" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
						INSERT INTO Ref_AccountMission 
						(Mission,GLAccount,OfficerUserId,OfficerLastName,OfficerFirstName)
						VALUES
						('#URL.mission#','#Form.GLAccount#','#SESSION.acc#','#SESSION.last#','#SESSION.first#')
					</cfquery>		
				
				</cfif>
				
			</cftransaction>	
			
			
		</cfif>	
		           
</cfif>

<cfif ParameterExists(Form.Update)>
		
	<cfquery name="Update" 
	datasource="AppsLedger" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">	  
		UPDATE  Ref_Account 
		SET 	Description        = '#Form.Description#',
				AccountGroup       = '#Form.AccountGroup#',
				AccountLabel       = '#Form.AccountLabel#',
				AccountType        = '#Form.AccountType#',
				AccountClass       = '#FORM.AccountClass#',
				AccountCategory    = '#FORM.AccountCategory#',
				TaxCode            = '#Form.TaxCode#',		
				Memo               = '#Form.Memo#',	
				<cfif moduleenabled eq "1">	
				  ForceProgram     = '#Form.ForceProgram#',
				  ObjectCode       = '#Form.ObjectCode#', 
				</cfif>			
				<cfif Form.BankId neq "">
				 BankId            = '#Form.BankId#',
				</cfif>
				<cfif form.accountclass eq "Balance">
					StockAccount       = '#Form.StockAccount#',
					FundAccount        = '#Form.FundAccount#',
					MonetaryAccount    = '#Form.MonetaryAccount#',
					RevaluationMode    = '#Form.RevaluationMode#',
						<cfif Form.ForceCurrency neq "">
						ForceCurrency      = '#Form.ForceCurrency#',			
						<cfelse>
						ForceCurrency      = NULL,
						</cfif>
					BankReconciliation = '#Form.BankReconciliation#',
				<cfelse>
					StockAccount       = '0',
					FundAccount        = '0',
					MonetaryAccount    = '0',
					BankReconciliation = '0',
				</cfif> 			
				PresentationClass  = '#Form.PresentationClass#',
				TaxAccount         = '#Form.TaxAccount#'		
		WHERE   GLAccount        = '#Form.GLAccount#'	
	</cfquery>
	
	 <cf_LanguageInput
		TableCode       = "AccountGL" 
		Mode            = "Save"
		Key1Value       = "#Form.GLAccount#"
		Name1           = "Description">
	
	<!--- save custom fields --->
			
	<cfquery name="GetTopics" 
	  datasource="AppsLedger" 
	  username="#SESSION.login#" 
	  password="#SESSION.dbpw#">
		  SELECT *
		  FROM   Ref_Topic
		  WHERE  Operational = 1
		  AND    TopicClass = 'Account'
		  AND    (Mission is NULL or Mission = '#url.mission#')
	</cfquery>
						
	<!--- ----saving the topic values------- --->
	<!--- 11/1/2011 can be made more generic --->
	<!--- ---------------------------------- --->
		
		<cfset alias   = "AppsLedger">
		<cfset table   = "Ref_AccountTopic">
		<cfset tField1 = "GLAccount">

	<cfloop query="getTopics">
							
		 <cfif ValueClass eq "List">
	
			 <cfset value  = Evaluate("FORM.Topic_#Code#")>
			
			 <cfquery name="GetList" 
				datasource="#alias#" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				  SELECT *
				  FROM   Ref_TopicList
				  WHERE  Code     = '#Code#'
				  AND    ListCode = '#value#'				  
			</cfquery>		
			
			<cfquery name="CleanCurrent" 
					  datasource="#alias#" 
					  username="#SESSION.login#" 
					  password="#SESSION.dbpw#">							 
					  DELETE  FROM  #table#
					  WHERE    #tfield1#   = '#FORM.GLAccount#'		  					     
					  AND     Topic        = '#Code#'				  
		    </cfquery>
						
			<cfif value neq "">
														
				<cfquery name="InsertTopics" 
				  datasource="#alias#" 
				  username="#SESSION.login#" 
				  password="#SESSION.dbpw#">
				  INSERT INTO  #table#
				 		 (#tfield1#,						 
						  Topic,						
						  ListCode,
						  TopicValue,
						  OfficerUserId,
						  OfficerLastName,
						  OfficerFirstName)
				  VALUES ('#Form.GLAccount#',				         
				          '#Code#',						 
						  '#value#',
						  '#getList.ListValue#',
						  '#SESSION.acc#',
						  '#SESSION.last#',
						  '#SESSION.first#') 
				</cfquery>
					
			</cfif>	
							
		<cfelse>
						
			<cfif ValueClass eq "Boolean">	
									
				<cfparam name="FORM.Topic_#Code#" default="0">						
				
			</cfif>
			
			<cfif ValueClass eq "Lookup">	
			
				<cfif isDefined("Form.Topic_#Code#")>  
				    
				 <cfset lcode  = Evaluate("FORM.Topic_#Code#")>
				  <cfquery name="GetLookup" 
				  datasource="#ListDataSource#" 
				  username="#SESSION.login#" 
				  password="#SESSION.dbpw#">
				      SELECT   DISTINCT 
				             #ListPK# as PK, 
				             #ListDisplay# as Display
				     FROM     #ListTable#
				     WHERE    #ListPK# = '#lcode#'  
				     <cfif ListCondition neq "">
				     AND      #preservesinglequotes(ListCondition)#
				     </cfif>                
				  </cfquery>
				      
				 <cfset value  = getLookup.Display>  
				<cfelse>
				 <cfset value="">
				</cfif>
							
			<cfelseif ValueClass eq "Date">			
			
			    <cfset dateValue = "">
			    <CF_DateConvert Value="#evaluate('FORM.Topic_#Code#')#">
			    <cfset DTE = dateValue>
						
			    <cfset lcode  = "">
				<cfset value  = "#dateformat(dte,client.dateSQL)#">
			
				
			<cfelseif ValueClass eq "DateTime">		
			
				<cfset dateValue = "">
			    <CF_DateConvert Value="#evaluate('FORM.Topic_#Code#')#">
			    <cfset DTE = dateValue>
			
			    <cfset lcode  = "">
				<cfset value  = "#dateformat(dte,client.dateSQL)# #evaluate('FORM.Topic_#Code#_hour')#:#evaluate('FORM.Topic_#Code#_minute')#:00">
			
			<cfelseif ValueClass eq "Time">		
			
			    <cfset lcode  = "">
				<cfset value  = "#evaluate('FORM.Topic_#Code#_hour')#:#evaluate('FORM.Topic_#Code#_minute')#">
			
			<cfelse>
			
			    <cfset lcode  = "">
				<cfset value  = Evaluate("FORM.Topic_#Code#")>
	
			</cfif>		
			
			<cfquery name="CleanSameDateValues" 
				datasource="#alias#" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				  DELETE FROM #table#
				  WHERE    #tfield1#     = '#Form.GLAccount#'		  					      
				  AND      Topic         = '#Code#'				    
		    </cfquery>	
			
			<cfif value neq "">
				
				<cfquery name="InsertTopics" 
				  datasource="#alias#" 
				  username="#SESSION.login#" 
				  password="#SESSION.dbpw#">
				  INSERT INTO #table#
				 			 (#tField1#,									
							  Topic, 
							  <cfif lcode neq "">
							  ListCode,
							  </cfif>							 
							  TopicValue,
							  OfficerUserId,
							  OfficerLastName,
							  OfficerFirstName)
				  VALUES 	 ('#Form.GLAccount#',						            
							  '#Code#',
							  <cfif lcode neq "">
							  '#lcode#',
							  </cfif>							 
							  '#value#',
							  '#SESSION.acc#',
							  '#SESSION.last#',
							  '#SESSION.first#')
				</cfquery>	
											
			</cfif>
			
		</cfif>	
	
	</cfloop>	
	
	<cfif Form.SystemAccount neq "">
	
		<cfquery name="Clear" 
		datasource="AppsLedger" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			UPDATE Ref_AccountMission
			SET    SystemAccount   = NULL			
			WHERE  Mission         = '#url.Mission#'
			AND    SystemAccount   = '#Form.SystemAccount#'
		</cfquery>
		
		<cfquery name="Update" 
		datasource="AppsLedger" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			UPDATE Ref_AccountMission
			SET    SystemAccount    = '#Form.SystemAccount#'			
			WHERE  GLAccount        = '#Form.GLAccount#'
			AND    Mission          = '#url.Mission#'  
		</cfquery>
	
	<cfelse>
	
		<cfquery name="Clear" 
		datasource="AppsLedger" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			UPDATE Ref_AccountMission
			SET    SystemAccount   = NULL			
			WHERE  Mission         = '#url.Mission#'
			AND    SystemAccount   = '#Form.SystemAccount#'
		</cfquery>
	
	</cfif>

</cfif>	

<cfif ParameterExists(Form.Delete)> 

    <cfquery name="CountRec" 
      datasource="AppsLedger" 
      username="#SESSION.login#" 
      password="#SESSION.dbpw#">
	      SELECT GLAccount
	      FROM   TransactionLine
	      WHERE  GLAccount  = '#Form.GLAccount#' 
    </cfquery>

    <cfif CountRec.recordCount gt 0>
		 
	     <script language="JavaScript">    
		   alert("Account is in use. Operation aborted.")     
	     </script>  
	 	 
    <cfelse>
	
		<cfquery name="CountRec" 
	      datasource="AppsLedger" 
	      username="#SESSION.login#" 
	      password="#SESSION.dbpw#">
		      SELECT GLAccount
		      FROM   Ref_AccountReceipt
		      WHERE  GLAccount  = '#Form.GLAccount#' 
	    </cfquery>
		
		<cfif CountRec.recordCount gt 0>
		 
		     <script language="JavaScript">    
			   alert("Account code is used as mapping. Operation aborted.")     
		     </script>  	
		
		<cfelse>
		
			<cfquery name="Delete" 
				datasource="AppsLedger" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
			    DELETE FROM Ref_Account
				WHERE  GLAccount   = '#Form.GLAccount#'
		    </cfquery>
		
		</cfif>
	
    </cfif>	
	
</cfif>	

<script language="JavaScript">   
     window.close()
	 opener.history.go()        
</script>  
