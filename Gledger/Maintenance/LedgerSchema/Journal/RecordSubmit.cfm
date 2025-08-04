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

<cfset jrn = replace(form.journal," ", "","All")> 

<cfparam name="FORM.BankId"         default="">
<cfparam name="FORM.JournalBatchNo" default="">
<cfparam name="FORM.DebitCredit"     default="">

<cfif URL.mode eq "Insert"> 
	
	<cfquery name="Verify" 
	datasource="AppsLedger" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT *
	FROM   Journal
	WHERE  Journal  = '#jrn#' 
	</cfquery>

	<cfif Verify.recordCount is 1>
   
	   <script language="JavaScript">
	   
	     alert("A journal with this acronym has been registered already!")
	     
	   </script>  
  
    <cfelse>
	
	    <cftransaction>
		
		<cfif form.GLCategory is "Payment">
		
		    <cfset dc = "Credit">
		
		<cfelse>
		
			<cfset dc = Form.DebitCredit>
		
		</cfif>
		
		<cfquery name="Insert" 
		datasource="AppsLedger" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		INSERT INTO Journal
		         (Journal,
					 Description,
					 TransactionCategory,
					 Mission,
					 SystemJournal,
					 JournalType,
					 Currency,
					 GLCategory,
				     Speedtype,
					 EntityClass,
					 AccountType,		
					 EnableScheduler,	
					 BankId, 
					 JournalBatchNo,
					 OfficerUserId,
					 OfficerLastName,
					 OfficerFirstName)
		  VALUES ('#jrn#', 
		          '#Form.Description#',
				  '#Form.TransactionCategory#',
				  '#form.Mission#',
				  <cfif Form.SystemJournal neq "">
				  '#Form.SystemJournal#',
				  <cfelse>
				  NULL,
				  </cfif>
				  '#Form.JournalType#',
				  '#Form.Currency#',
				  '#Form.GLCategory#',
				  <cfif Form.Speedtype neq "">				  
				  '#Form.Speedtype#',
				  <cfelse>
				  NULL,
				  </cfif>
				  '#Form.EntityClass#',
				  '#dc#',
				  '#Form.EnableScheduler#',
				  <cfif form.bankid neq "">
				  '#Form.BankId#',
				  <cfelse>
				  NULL,
				  </cfif>
				  '#Form.JournalBatchNo#',
				  '#SESSION.acc#',
		    	  '#SESSION.last#',		  
			  	  '#SESSION.first#')
		</cfquery>
		
		<cfif Form.JournalBatchNo neq "0" and Form.JournalBatchNo neq "">
		
			<cfquery name="Insert" 
			datasource="AppsLedger" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			INSERT INTO JournalBatch
				(Journal,
				 JournalBatchNo,
				 BatchCategory,
				 Description,
				 TransactionDate,
				 OfficerUserId,
				 OfficerLastName,
				 OfficerFirstName)
			VALUES
				('#jrn#',
				 '#Form.JournalBatchNo#',
				 '#Form.BatchCategory#',
				 '#Form.BatchDescription#',
				 getDate(),
				 '#SESSION.acc#',
				 '#SESSION.last#',
				 '#SESSION.first#')	
			 </cfquery>
			
		</cfif>
			  
		<cfif FORM.GLAccount neq "">
		
		    <cfquery name="Update" 
		     datasource="AppsLedger" 
		     username="#SESSION.login#" 
		     password="#SESSION.dbpw#">
		     UPDATE Journal
		     SET    <!--- GLAccount      = '#FORM.GLAccount#', --->
		            JournalType    = '#FORM.JournalType#'    
		     WHERE  Journal        = '#jrn#'
		    </cfquery>
			
			<!--- populate the contra-account table --->
			
			 <cfquery name="InsertContraAccount" 
		     datasource="AppsLedger" 
		     username="#SESSION.login#" 
		     password="#SESSION.dbpw#">
		     INSERT INTO JournalAccount
				(Journal,
				 GLAccount,
				 ListDefault,
				 ListOrder,
				 Mode,
				 OfficerUserId,
				 OfficerLastName,
				 OfficerFirstName)
			 VALUES
			    ('#jrn#',
				 '#FORM.GLAccount#',
				 '1',
				 '1',
				 'Contra',
				 '#SESSION.acc#',
				 '#SESSION.last#',
				 '#SESSION.first#')			 	 
		     
		    </cfquery>
			
		</cfif>		
		
		</cftransaction>  	
		 
		 <script language="JavaScript">
	   		     
			 opener.applyfilter('5','','content')
			 window.close()
	        
		</script> 
   
	</cfif>
	
	
</cfif>

<cfif URL.mode eq "update"> 

	<cfif form.TransactionCategory is "Payment">
		
		<cfset dc = "Credit">
		
	<cfelse>
		
		<cfset dc = Form.DebitCredit>
		
	</cfif>
	
	<cfquery name="Update" 
	datasource="AppsLedger" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	UPDATE Journal
	SET    Description           = '#Form.Description#',
	       <cfif Form.SystemJournal neq "">
		     SystemJournal       = '#Form.SystemJournal#',
		   <cfelse>
			 SystemJournal       = NULL,
		   </cfif>
		   <cfif dc neq "">		  
		   AccountType           = '#dc#',
		   </cfif>
		   OrgUnitOwner          = '#Form.OrgUnitOwner#',
		   EntityClass           = '#Form.EntityClass#',
		   JournalType           = '#Form.JournalType#',    
		   TransactionCategory   = '#Form.TransactionCategory#', 
		   Currency              = '#Form.Currency#',
		   <cfif form.bankId neq "">
		   BankId                = '#Form.BankId#',
		   <cfelse>
		   BankId                = NULL,
		   </cfif>
		   EnableScheduler       = '#FORM.EnableScheduler#',	
		   JournalBatchNo        = '#Form.JournalBatchNo#',
		   JournalSerialNo       = '#Form.JournalSerialNo-1#',		
		   <cfif trim(Form.Speedtype) neq "">	
		   Speedtype             = '#Form.Speedtype#',
		   <cfelse>
		   Speedtype			 =	NULL,
		   </cfif>
		   Operational           = '#Form.Operational#'
		 
	WHERE  Journal               = '#jrn#'
	</cfquery>
	
	<!--- check if account exists : if not we add, otherwise we set it as default --->
	
	<cfquery name="check" 
		datasource="AppsLedger" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		     SELECT * 
			 FROM   JournalAccount
			 WHERE  Journal = '#jrn#'
			 AND    GLAccount = '#FORM.GLAccount#'		     
     </cfquery>
	 
	 <cfquery name="set" 
		datasource="AppsLedger" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		     UPDATE JournalAccount
			 SET    ListDefault = 0
			 WHERE  Journal = '#jrn#'			 	     
     </cfquery>
	
	 <cfif check.recordcount eq "0" and FORM.GLAccount neq "">	 
	 
			 <cfquery name="InsertContraAccount" 
		     datasource="AppsLedger" 
		     username="#SESSION.login#" 
		     password="#SESSION.dbpw#">
		     INSERT INTO JournalAccount
				(Journal,
				 GLAccount,
				 ListDefault,
				 ListOrder,
				 OfficerUserId,
				 OfficerLastName,
				 OfficerFirstName)
			 VALUES
			    ('#jrn#',
				 '#FORM.GLAccount#',
				 '1',
				 '1',
				 '#SESSION.acc#',
				 '#SESSION.last#',
				 '#SESSION.first#')				 
		     
		    </cfquery>
			
	<cfelse>		
	 
		 <cfquery name="set" 
			datasource="AppsLedger" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			     UPDATE JournalAccount
				 SET    ListDefault = 1
				 WHERE  Journal = '#jrn#'
				 AND    GLAccount = '#FORM.GLAccount#'		     
	     </cfquery>
	 	 
	 </cfif>
	 
	 <cfoutput>
	 
	 <script language="JavaScript">
	   	     
		 opener.applyfilter('1','','#jrn#')
		 window.close()
	        
	</script> 
	
	</cfoutput>
	
	 
</cfif>	

<cfif URL.mode eq "delete"> 
	
	<cfquery name="CountRec" 
      datasource="AppsLedger" 
      username="#SESSION.login#" 
      password="#SESSION.dbpw#">
	      SELECT *
	      FROM   TransactionHeader
	      WHERE  Journal  = '#jrn#' 
	</cfquery>

    <cfif CountRec.recordCount gt 0>
		 
	     <script language="JavaScript">
	    
		   alert("Journal is in use. Operation aborted.")
	     
	     </script>  
	 
    <cfelse>
	
		<cfquery name="Delete" 
			datasource="AppsLedger" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			DELETE FROM JournalBatch
			WHERE  Journal        = '#jrn#'
	    </cfquery>
				
		<cfquery name="Delete" 
			datasource="AppsLedger" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			DELETE FROM Journal
			WHERE  Journal        = '#jrn#'
	    </cfquery>
	
	</cfif>
	
	<cfoutput>
				
	<script language="JavaScript">
	   	     
		 opener.applyfilter('1','','#jrn#')
		 window.close()
	        
	</script> 
	
	</cfoutput>
	
</cfif>	
 

