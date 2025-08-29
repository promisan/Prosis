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
<link rel="stylesheet" type="text/css" href="<cfoutput>#SESSION.root#/#client.style#</cfoutput>"> 

<cfif ParameterExists(Form.ControlView)> 
	<cfset ControlView = 1>
<cfelse>
	<cfset ControlView = 0>
</cfif>

<cfif ParameterExists(Form.ControlEdit)> 
	<cfset ControlEdit = 1>
<cfelse>
	<cfset ControlEdit = 0>
</cfif>

<cfif ParameterExists(Form.ControlExecution)> 
	<cfset ControlExecution = 1>
<cfelse>
	<cfset ControlExecution = 0>
</cfif>

<cfif form.BudgetEntryMode eq "1">
    <cfset meth = "Transaction">
<cfelse>
    <cfset meth = Form.EntryMethod>
</cfif>

<cfparam name="Form.Fund" default="">
<cfparam name="Form.BudgetEntryMode" default="0">
<cfparam name="Form.Version" default="">

<cfif ParameterExists(Form.Insert)> 
	
	<cfif Form.Fund eq "" and Form.CarryOver eq "">
		  <cf_alert message="You must associated a least one fund.">
		   <cfabort>
	</cfif>
	
	<cfif Form.Version eq "">
		  <cf_alert message="You must select a version.">
		   <cfabort>
	</cfif>

    <cfif Form.Period neq "">

		<cfquery name="Verify" 
		datasource="AppsProgram" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT *
		FROM Ref_AllotmentEdition
		WHERE Mission      = '#Form.Mission#'		 
		  AND Period       = '#Form.Period#'
		  AND Version      = '#Form.Version#'
		  AND EditionClass = '#Form.EditionClass#'
		</cfquery>
	
	<cfelse>
	
		<cfquery name="Verify" 
		datasource="AppsProgram" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT *
		FROM   Ref_AllotmentEdition
		WHERE  Mission      = '#Form.Mission#'		 
		  AND  Period is NULL
		  AND  Version      = '#Form.Version#'
		  AND  EditionClass = '#Form.EditionClass#'
		</cfquery>
		
	</cfif>

    <cfif Verify.recordCount gte 1>

	   <cf_alert message="An edition with for this entity for this period, version and class has been recorded already. This is not allowed" return="back">
	   <cfabort>
      
    <cfelse>
   
	   <cftransaction>	        
	   
	   		<cfquery name="Carry" 
				datasource="AppsProgram" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				   SELECT * 
				   FROM   Ref_AllotmentEdition
				   WHERE  EditionId = '#Form.CarryOver#'					  
		    </cfquery>
	   
			<cfquery name="Insert" 
			datasource="AppsProgram" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			INSERT INTO Ref_AllotmentEdition
			         (Mission,			 
					 <cfif Form.Period neq "">
					 Period,
					 </cfif>
					 <cfif form.editionclass eq "Budget">
					 Version,
					 </cfif>
					 EditionClass,
					 ListingOrder,
					 Description,
					 ControlView,
					 ControlEdit,
					 ControlExecution,
					 EntryMethod,
					 BudgetEntryMode,
					 AllocationEntryMode,
					 OfficerUserId,
					 OfficerLastName,
					 OfficerFirstName)
			  VALUES ('#Form.Mission#',	          
					  <cfif Form.Period neq "">
					    '#Form.Period#',
					  </cfif>
					  <cfif form.editionclass eq "Budget">
					   '#Form.Version#',
					   </cfif>
					  '#Form.EditionClass#',
					  '#Form.ListingOrder#',
			          '#Form.Description#', 
					  '#ControlView#',
					  '#ControlEdit#',
					  '#ControlExecution#',
					  <cfif form.CarryOver eq "">	
					  '#meth#',
					  '#Form.BudgetEntryMode#',
					  <cfelse>
					  '#Carry.EntryMethod#',
					  '#Carry.BudgetEntryMode#',
					  </cfif>
					  '#Form.AllocationEntryMode#',
					  '#SESSION.acc#',
			    	  '#SESSION.last#',		  
				  	  '#SESSION.first#')
			  </cfquery>
			  
			  <!--- get the last edition no --->
			  
			  <cfquery name="New" 
				datasource="AppsProgram" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				   SELECT   * 
				   FROM     Ref_AllotmentEdition
				   WHERE    Mission = '#Form.Mission#'
				   ORDER BY EditionId DESC 
			  </cfquery>
			  
			  <cfif form.CarryOver eq "">	
			  
				  <cfloop index="fd" list="#Form.Fund#" delimiters=","> 
			
						<cfquery name="InsertLine" 
							datasource="AppsProgram" 
							username="#SESSION.login#" 
							password="#SESSION.dbpw#">
						    INSERT INTO Ref_AllotmentEditionFund
									( EditionId, 
									  Fund,								   
									  OfficerUserId,
									  OfficerLastName,
						              OfficerFirstName)
							VALUES  ('#New.EditionId#',
							         '#fd#', 
								     '#SESSION.acc#',
						    	     '#SESSION.last#',		  
							  	     '#SESSION.first#')	  				
						</cfquery> 	
			
				  </cfloop>
				  
			  <cfelse>
			  
			  		<cfquery name="InsertLine" 
							datasource="AppsProgram" 
							username="#SESSION.login#" 
							password="#SESSION.dbpw#">
						    INSERT INTO Ref_AllotmentEditionFund
									( EditionId, 
									  Fund, 
									  OfficerUserId,
									  OfficerLastName,
						              OfficerFirstName)
							SELECT '#New.EditionId#',
							       Fund, 
								   '#SESSION.acc#',
						    	   '#SESSION.last#',		  
							  	   '#SESSION.first#'								   
							FROM Ref_AllotmentEditionFund
							WHERE EditionId = '#form.CarryOver#'	  				
					</cfquery> 	
			  		  
			  </cfif>				 					 		
			 			  
			  <cfif form.CarryOver neq "">	
			    		 
				   <!--- -------------------------------------------- --->	  		  	  		  		  		
				   <!--- define last planning period for this mission --->
				   <!--- -------------------------------------------- --->				   
				   
				   <cfquery name="LastPeriod"
					datasource="AppsProgram" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">					
					    SELECT TOP 1 R.Period 
					    FROM   ProgramAllotment PA , Ref_Period  R
						WHERE  PA.Period = R.Period
						AND    PA.EditionId = '#form.CarryOver#'
						ORDER  BY DateEffective DESC 			
			       </cfquery>				   			   
								  
				  <!--- check if there are any programs/project in this period --->
				  
				   <cfquery name="CheckHeader" 
					datasource="AppsProgram" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
					  SELECT   *
					  FROM     ProgramPeriod
					  WHERE    Period    = '#LastPeriod.Period#'
					  AND      ProgramCode IN (SELECT ProgramCode FROM Program WHERE Mission = '#Form.Mission#')
				   </cfquery>  
				  
				  <cfif checkHeader.recordcount eq "0">
				  
					  <script>
					     alert("There are no programs or projects defined under period #LastPeriod.Period#. Please carry over first!")
					 </script>
				  
				  	 <cfabort>
				  
				  </cfif>
				  			  
					<cfquery name="Fund" 
						datasource="AppsProgram" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">
						   SELECT * 
						   FROM   Ref_AllotmentEditionFund
						   WHERE  EditionId = '#Form.CarryOver#'					  
					</cfquery>		
					
					<cfset selfund = "">
					
					<cfloop query="Fund"> 
					
						<cfif selfund eq "">
							<cfset selfund = "'#fund#'">
						<cfelse>
							<cfset selfund = "#selfund#,'#fund#'">
						</cfif>	
						
					</cfloop>							
					
					<cfquery name="qSource" 
						datasource="AppsProgram" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">
							SELECT     ProgramCode
							FROM       ProgramAllotment
							WHERE      EditionId = '#form.CarryOver#' 
							AND        Period    = '#LastPeriod.Period#'
					</cfquery>		
									
					<cfloop query="qSource">
						
						<cfinvoke component	= "Service.Process.Program.CarryOver"
					    	Method		    = "ProgramEditionCarryOver"
						  	ProgramCode	    = "#qSource.ProgramCode#"
						  	FromPeriod	    = "#LastPeriod.Period#"
						  	FromEdition	    = "#form.CarryOver#"
						  	ToPeriod		= "#LastPeriod.Period#"
						  	ToEdition		= "#New.EditionId#"
						  	BudetEntryMode  = "#carry.budgetEntryMode#"
						  	Funds           = "#selfund#">
							  
					</cfloop>		  

					
			</cfif>		
					
			</cftransaction>			
												  
		</cfif>				  			    
		  
</cfif>		  

<cfif ParameterExists(Form.Update)>

	<cfparam name="Form.EntryMethod" default="1">

		<cftransaction>
	
		<cfquery name="Update" 
		datasource="AppsProgram" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		UPDATE Ref_AllotmentEdition
		SET Mission             = '#Form.Mission#',	  
			<cfif Form.Period eq "">
			Period              = NULL,
			<cfelse>
			Period              = '#Form.Period#',
			</cfif>
			<cfif form.editionclass eq "Budget">
			Version             = '#Form.Version#',
			</cfif>
			Status              = '#Form.Status#',
			ListingOrder        = '#Form.ListingOrder#',
			Description         = '#Form.Description#',
			ControlView         = '#ControlView#',
			BudgetEntryMode     = '#Form.BudgetEntryMode#',
			AllocationEntryMode = '#Form.AllocationEntryMode#',
			ControlEdit         = '#ControlEdit#',
			ControlExecution    =  '#ControlExecution#',
		    EntryMethod         = '#meth#'
		WHERE EditionId         = '#Form.EditionId#'
		</cfquery>
		
		<cfquery name="Clean" 
		datasource="AppsProgram" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			DELETE Ref_AllotmentEditionFund
			WHERE  EditionId    = '#Form.EditionId#'	 
			AND    Fund NOT IN (SELECT Fund 
			                    FROM   ProgramAllotmentDetail 
								WHERE  EditionId = '#Form.EditionId#')	
		</cfquery>
		
		<cfquery name="FundSel"
			datasource="AppsProgram" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			    SELECT *
				FROM Ref_Fund
				ORDER BY ListingOrder
	     </cfquery>  
			  
		 <cfloop query="FundSel"> 
			  
		 	    <cfparam name="Form.Fund_#code#" default="">
				<cfparam name="Form.Perc_#code#" default="">
				<cfparam name="Form.FundDefault" default="">
				
				<cfset fund = evaluate("Form.Fund_#code#")>
				<cfset perc = evaluate("Form.Perc_#code#")>
									
				<cfif fund neq "">
				
					<cfif fund eq form.funddefault>
					    <cfset def = "1">
					<cfelse>
						<cfset def = "0">  
					</cfif>
				
					<cfquery name="Check" 
						datasource="AppsProgram" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">
							SELECT * FROM Ref_AllotmentEditionFund									
							WHERE EditionId    = '#Form.EditionId#'
							AND   Fund         = '#fund#'
					</cfquery>
				
					<cfif check.recordcount eq "0">
						
						<cfquery name="InsertLine" 
							datasource="AppsProgram" 
							username="#SESSION.login#" 
							password="#SESSION.dbpw#">
							    INSERT INTO Ref_AllotmentEditionFund
									( EditionId, 
									  Fund,
									  PercentageRelease,FundDefault)
								VALUES ('#Form.EditionId#','#fund#','#perc#','#def#')	 			
						</cfquery> 
									
					<cfelse>	
						
						<cfquery name="Update" 
							datasource="AppsProgram" 
							username="#SESSION.login#" 
							password="#SESSION.dbpw#">
								UPDATE Ref_AllotmentEditionFund
								SET    PercentageRelease  = '#perc#', 
								       FundDefault        = '#def#'
								WHERE  EditionId          = '#Form.EditionId#'
								AND    Fund               = '#fund#'
								
						</cfquery>
										
					</cfif>
					
				</cfif>
		
		 </cfloop>
			
		</cftransaction>	

</cfif>	

<cfif ParameterExists(Form.Delete)> 

	<cfquery name="CountRec" 
      datasource="AppsOrganization" 
      username="#SESSION.login#" 
      password="#SESSION.dbpw#">
	  SELECT   *
	  FROM     Ref_MissionPeriod
      WHERE    EditionId  = '#Form.EditionId#' 	 
	</cfquery>
		
    <cfif CountRec.recordCount gt 0>
		 
     <script language="JavaScript">    
	   alert("Edition is used as a requisition funding reference. Operation aborted.")	        
     </script>  
	 
    <cfelse>
	
		<cfquery name="Delete" 
		datasource="AppsProgram" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			DELETE FROM ProgramAllotment
			WHERE EditionId = '#FORM.EditionId#'
	    </cfquery>
			
		<cfquery name="Delete" 
		datasource="AppsProgram" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		DELETE FROM Ref_AllotmentEdition
		WHERE EditionId = '#FORM.EditionId#'
	    </cfquery>
	
	</cfif>	
	
</cfif>	

<script language="JavaScript">
   
     parent.window.close()
	 parent.opener.history.go()
        
</script>  
