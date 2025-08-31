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
<!--- 
	1. insert/edit record
	2. refresh_listing
	3. update amounts in ProgramAllotmentDetail and record modification
	4. Refresh amount boxes
--->

<cfquery name="Period" 
datasource="AppsProgram" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT    *
	FROM      Ref_Period
	WHERE     Period = '#Form.Period#'
</cfquery>

<cfquery name="ProgramPeriod" 
datasource="AppsProgram" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT    *
	FROM      Program P, ProgramPeriod Pe
	WHERE     P.ProgramCode  = Pe.ProgramCode
	AND       P.ProgramCode  = '#Form.programcode#' 
	AND       Pe.Period       = '#Form.period#' 	
</cfquery>

<cfquery name="Object" 
datasource="AppsProgram" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT    *
	FROM      Ref_Object
	WHERE     Code = '#Form.objectcode#'
</cfquery>

<cfparam name="form.ActivityId"         default="">
<cfparam name="form.BudgetCategory"     default="">
<cfparam name="form.ItemMaster"         default="">

<!--- define the items to save --->

<cfif Object.RequirementMode eq "3">	

	<cfset PositionMode = queryNew("BudgetEntryPosition", "CF_SQL_VARCHAR")>	
			 
	<!--- retrieve the full list of items in order 
	     to save the matrix listing --->
		 
		<cfquery name="getScreenList" 
		datasource="AppsPurchase" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT    Code, 
			          BudgetTopic, 
					  O.BudgetEntryLines,
					  O.ListingOrder
			FROM      ItemMaster IM	         
				      INNER JOIN ItemMasterObject O ON IM.Code = O.ItemMaster	
			WHERE     ObjectCode = '#Form.objectcode#'
			
			<!--- valid or used in the existing data for editing --->
			
			<cfif url.RequirementIdParent neq "">
			AND       (Operational = 1 or Code IN (SELECT ItemMaster 
			                                       FROM   Program.dbo.ProgramAllotmentRequest 
												   WHERE  RequirementIdParent = '#url.RequirementIdParent#'))
		    <cfelse>
			AND       Operational = 1
			</cfif>												   
			ORDER BY O.ListingOrder
		</cfquery>		
		
		<cfset List = queryNew("Code,BudgetTopic,ListingOrder", "CF_SQL_VARCHAR, CF_SQL_VARCHAR,CF_SQL_VARCHAR")>
			
		<cfset row = 0>
			
		<!--- add rows --->
		<cfloop query="getScreenList">
						
		   	<cfset queryaddrow(List, BudgetEntryLines)>			
				
			<cfloop index="line" from="1" to="#BudgetEntryLines#" step="1">
				
				<cfset row = row+1>			
										
				<!--- set values in cells --->
				<cfset querysetcell(List, "Code", "#Code#", row)>
				<cfset querysetcell(List, "BudgetTopic", "#BudgetTopic#", row)>
				<cfset querysetcell(List, "ListingOrder", "#ListingOrder#", row)>
				
			</cfloop>
			
		</cfloop>						
	  
<cfelseif Object.RequirementMode eq "2">		
	
	<cfquery name="PositionMode" 
		datasource="AppsPurchase" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT    *
			FROM      ItemMasterObject
			WHERE     ItemMaster  = '#Form.itemmaster#'
			AND       ObjectCode  = '#Form.objectcode#'
	</cfquery>
	 
	<!--- retrieve the full list of items in order to save the staffing matrix listing --->
	
	<cfif PositionMode.BudgetEntryPosition eq "0">	
	  
		 <cfquery name="List" 
			datasource="AppsProgram" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				SELECT   ItemMaster as Code, '0' as PositionNo, *
				FROM     Purchase.dbo.ItemMasterList
				WHERE    ItemMaster  = '#form.itemmaster#'					
				AND      Operational = 1
				ORDER BY ListOrder 
		 </cfquery>
	 
	 <cfelse> 	
	 	    		
		<cfquery name="List" 
			datasource="AppsEmployee" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">	
			SELECT   P.PositionNo, 
					 ItemMaster as Code,
					 L.*					  
		    FROM     Position P 
		    		 INNER JOIN Ref_PostGrade G ON P.PostGrade = G.PostGrade 
		    		 INNER JOIN Purchase.dbo.ItemMasterList L ON G.PostGradeBudget = L.TopicValueCode
		    		 INNER JOIN PositionParent PP ON P.PositionParentId = PP.PositionParentId
			WHERE    P.PositionNo IN (#preserveSingleQuotes(PositionList)#)  <!--- hierarchy check if no programs under it --->			
			<!--- positions valid on the start of the budget preparation year --->
			<!--- kherrera(2018-06-19): Effective period changed to the PositionParent --->
			AND      PP.DateEffective  <= '#period.dateEffective#'   <!--- 01/01/2015 --->
			AND      PP.DateExpiration >= '#period.dateEffective#'   <!--- 01/01/2015 : valid on this moment --->
			AND      L.ItemMaster      = '#Form.ItemMaster#'
			AND      L.Operational    = 1 	
			ORDER BY PostOrderBudget, PositionNo	
								  
		</cfquery>
	 
	 </cfif>
	 
<cfelse>

	<cfset PositionMode = queryNew("BudgetEntryPosition", "CF_SQL_VARCHAR")>	
	 
	<cfquery name="List" 
		datasource="AppsPurchase" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT    *, '0' as PositionNo
			FROM      ItemMaster
			WHERE     Code = '#Form.ItemMaster#'
	</cfquery>	 
	
</cfif>

<!--- -------------- --->
<!--- pre validation --->
<!--- -------------- --->

<!--- labels --->


<cf_tl id="Incorrect Standard Cost Entered" var="1">
<cfset stdCst = lt_text>
<cfparam name="form.ItemMaster" default="">

<cfloop query="List">
	
	<cfset ItemMaster = Code>
			
	<cfif ItemMaster eq "">
		
		<cfoutput>	
			<script>
				alert("Please select a Request category.")
				Prosis.busy('no')
			</script>
		</cfoutput>
		<cfabort>
		
	</cfif>
		
	<cfquery name="getItemMaster" 
	datasource="AppsPurchase" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT    *
		FROM      ItemMaster
		WHERE     Code = '#ItemMaster#'
	</cfquery>	
	
	<cfparam name="form.RequestDescription_#currentrow#"   default="">
	<cfparam name="form.topicvaluecode_#currentrow#"       default="">
	<cfparam name="form.requestPrice_#currentrow#"         default="0">

	<!--- we have the option to work per period here ---> 
	<cfparam name="form.requestquantity_sum"               default="">	
	<cfparam name="form.requestquantity_#currentrow#"      default="">
	<!--- ------------------------------------------ --->
		
	<cfset requestDescription = evaluate("form.requestDescription_#currentrow#")>
	<cfset TopicValueCode     = evaluate("form.topicvalueCode_#currentrow#")>
	
	<cfif form.requestQuantity_sum neq "">
		<cfset requestQuantity    = form.requestQuantity_sum>
	<cfelse>
		<cfset requestQuantity    = evaluate("form.requestQuantity_#currentrow#")>
	</cfif>
		
	<cfset requestPrice       = evaluate("form.requestPrice_#currentrow#")>	
	
	<cfif Object.RequirementMode eq "2">		
	
		 <!--- no validation --->
		 
	<cfelse>
		
	    <cfif RequestQuantity neq "">
	
		    <cfset qty = replace(RequestQuantity,',','',"ALL")>
			<cfset qty = replace(qty,' ','',"ALL")>
		
			<cfif isNumeric(qty)>
			
				<cfif RequestQuantity eq "0" and Object.RequirementMode neq "3">
			
					<cfoutput>	
						<script>
						alert("Please enter a Quantity (#RequestQuantity#).")
						Prosis.busy('no')
						</script>
					</cfoutput>
					<cfabort>
			
				</cfif>
			
			<cfelse>
			
				<cfoutput>	
					<script>
					alert("Please enter a valid Quantity (#RequestQuantity#).")
					Prosis.busy('no')
					</script>
				</cfoutput>
				<cfabort>
			
			</cfif>	
					
			<cfset price = replace(RequestPrice,',','',"ALL")>
			
			<cfif isNumeric(price)>	
							
				<cfif price eq "0" and Object.RequirementMode neq "3">
				
					<cfoutput>
					<cf_tl id="Incorrect Standard Cost entered (#numberformat(price,'__.__')#)" var="1">
					<script>
					alert("#lt_text#")
					Prosis.busy('no')
					</script>
					</cfoutput>
					<cfabort>
				
				</cfif>
				
			<cfelse>
			
				<cfoutput>	
					<script>
					alert("Please enter a valid Standard cost.")
					Prosis.busy('no')
					</script>
				</cfoutput>
				<cfabort>	
			
			</cfif>						
						
			<!--- maybe best to enforce this on the level of dbo.ItemMasterObject						
						
			<cfif requestDescription eq "" and getItemMaster.BudgetTopic neq "DSA">	
			   
			    <cfoutput>
				<cf_tl id="Please enter a description" var="1">
								
				<script>
					alert("#lt_text#")		
					Prosis.busy('no')			
				</script>
				</cfoutput>
				<cfabort>
				
			</cfif>	
			
			--->
						
		</cfif>	
		
		
	</cfif>	
	
</cfloop>	

<cf_tl id="Ceiling would be exceeded. Operation aborted" var="exceed">
<cf_tl id="Exceeded by" var="exceedin">
<cf_tl id="One or more positions have been budgetted already. Operation aborted" var="postext">

<cfset st = "1">

 <cfquery name="Program" 
	datasource="AppsProgram" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT     *
	FROM       Program
	WHERE      ProgramCode = '#Form.programCode#'			
</cfquery>

 <cfquery name="Param" 
	datasource="AppsProgram" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT     *
	FROM       Ref_ParameterMission
	WHERE      Mission = '#Program.Mission#'			
</cfquery>

<cfparam name="Form.RequestDue" default="">

<cfif form.requestDue neq "">
	<cfset dateValue = "">
	<CF_DateConvert Value="#Form.RequestDue#">
	<cfset dte = dateValue>
</cfif>

<cftransaction>

<!--- double check if the line exists --->

<cfquery name="Check" 
datasource="AppsProgram" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT  *
	FROM    ProgramAllotmentRequest
	WHERE   RequirementId = '#url.requirementId#' 
</cfquery>


<!--- ------------------------------------------- --->
<!--- ----------------- SAVING ------------------ --->
<!--- ------------------------------------------- --->


<cfif check.recordcount eq "0"        	
	   or Object.RequirementMode eq "3" 	
	   
	   or Object.RequirementMode eq "2" 	      
	    
	   or url.mode eq "add">
	   
	   <cfset processmode = "Add">
		 
	  <!--- attention : Object.RequirementMode added by Dev to allow for adding --->
		 
	  <!--- add new entries as we do not have any entries or we are 
	  						 in the travel mode or we have selected ADD --->
		
	  <!--- ---------------------- safeguard -------------------------- --->
	  <!--- create an allotment master record in case it does not exist --->
	  <!--- ----------------------------------------------------------- --->
	  	
	  <cfquery name="Check" 
		datasource="AppsProgram" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT     *
			FROM       ProgramAllotment
			WHERE      ProgramCode = '#Form.programCode#'	
			AND        Period      = '#Form.period#'   
			AND        EditionId   = '#Form.EditionId#'	
	  </cfquery>
	  
	  <cfif Check.recordcount eq "0">
	  
		  <cfquery name="Insert" 
			datasource="AppsProgram" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			INSERT INTO ProgramAllotment
					( ProgramCode, 
					  Period, 
					  EditionId,
					  SupportPercentage,
					  SupportObjectCode,
					  OfficerUserId, 
					  OfficerLastName, 
					  OfficerFirstName)
					  
			VALUES ( '#Form.ProgramCode#', 
			         '#Form.period#', 
					 '#Form.EditionId#', 
					 '#param.SupportPercentage#',
					 <cfif param.SupportObjectCode neq "">
					 '#param.SupportObjectCode#',
					 <cfelse>
					 NULL,
					 </cfif>
					 '#SESSION.acc#', 
					 '#SESSION.last#', 
					 '#SESSION.first#' )
		  </cfquery>
	
	  </cfif>
	  
	  <!--- if we are in the copy mode we do not want to remove the OLD lines of course --->
	  	  
	  <cfif url.mode eq "edit">
	  
		   <cfquery name="clearPriorrecording" 
			datasource="AppsProgram" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			
				DELETE    ProgramAllotmentDetailRequest
				WHERE     Requirementid IN ( SELECT RequirementId
				                             FROM   ProgramAllotmentRequest 
							 			     WHERE  RequirementIdParent = '#url.requirementidParent#'
											 AND    Period               = '#Form.Period#'
											 AND    RequestType        != 'Ripple' )		
				
				
				DELETE    ProgramAllotmentRequest
				WHERE     Requirementid IN ( SELECT RequirementId
				                             FROM   ProgramAllotmentRequest 
							 			     WHERE  RequirementIdParent = '#url.requirementidParent#'
											 AND    Period               = '#Form.Period#'
											 AND    RequestType        != 'Ripple' )	
				
				<!--- see code below for ripple handling as ripple OE can have this partially allotted --->
			
		  </cfquery>
		  
	  <cfelseif url.mode eq "Add">
	  	  
	  		<!--- to ensure that the new lines for quantity are updated --->
	  	    <cf_assignid>
			<cfset url.RequirementId = rowguid>
			<cfset url.RequirementIdParent = url.requirementid>
			
	  </cfif>
	  	    	  
	  <!--- create requirement records for the listed items to be posted --->
	  
	  <cfset priorMaster = "">	
	  
	 
	  <cfloop query="List">
	  	 	 	  	  	  	  	  	
		<cfset ItemMaster = Code>
		
		<!--- only if indeed the line is visible for the user --->
		
		<cfparam name="form.itm_#ItemMaster#_#currentrow#"  default="1">
												 
		<cfif evaluate("form.itm_#ItemMaster#_#currentrow#") eq "1">
		
			<cfif priorMaster neq Itemmaster>
			    <cfset row = 0>
				<cfset priorMaster = ItemMaster>
			</cfif>
			  
		    <cfparam name="form.RequestDescription_#currentrow#"  default="">
			<cfparam name="form.topicvaluecode_#currentrow#"      default="">
			
			<!--- we have the option to work per period here ---> 
			<cfparam name="form.requestquantity_sum"               default="">	
			<cfparam name="form.requestquantity_#currentrow#"      default="">
			<!--- ------------------------------------------ --->
		
			<cfparam name="form.resourcequantity_#currentrow#"    default="">
			<cfparam name="form.resourcedays_#currentrow#"        default="">
			
			<cfset requestDescription = evaluate("form.RequestDescription_#currentrow#")>
			<cfset TopicValueCode     = evaluate("form.topicvaluecode_#currentrow#")>
					
			<cfif form.requestQuantity_sum neq "">
				<cfset requestQuantity    = form.requestQuantity_sum>
			<cfelse>
				<cfset requestQuantity    = evaluate("form.requestQuantity_#currentrow#")>
			</cfif>
		
			<cfset resourceQuantity   = evaluate("form.resourceQuantity_#currentrow#")>
			<cfset resourceDays       = evaluate("form.resourceDays_#currentrow#")>
			<cfset requestPrice       = evaluate("form.requestPrice_#currentrow#")>		
				 
			<cfif Object.RequirementMode neq "2">		
			 
			 	<cfif List.BudgetTopic eq "Standard">
				
					<!--- selection list instead --->
			  	  
					<cfquery name="get" 
						datasource="AppsProgram" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">
							SELECT   *
							FROM     Purchase.dbo.ItemMasterList
							WHERE    ItemMaster     = '#itemmaster#'
							AND      TopicValueCode = '#topicvaluecode#'
					</cfquery>			
				
				<cfelseif List.BudgetTopic eq "DSA">
							
					<cfquery name="get" 
						datasource="AppsProgram" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">
							SELECT   LocationCode as TopicValueCode,
							         LocationCountry+' '+Description as TopicValue
							FROM     TravelClaim.dbo.Ref_PayrollLocation 					
							WHERE    LocationCode = '#topicvaluecode#' 							
					</cfquery>	
				
				</cfif>
			
			</cfif>		 	  
		    		  
			<!--- in case of periods for (sub)item we take the line total --->
			  
			<cfset rqty = replace(RequestQuantity,',','',"ALL")>
			<cfset rprc = replace(RequestPrice,',','',"ALL")>
			
			<cfset row = row+1>
			
			<cfif rqty neq "" and rqty neq "0">
			 		 	 	  
			      <!--- --------------------------------------------- --->
			  	  <!--- AAAAAAAA defined the price for each list item --->
				  <!--- --------------------------------------------- --->
			  
			  	  <cf_assignid>		
				  
				  <cfif PositionMode.BudgetEntryPosition eq "1">	
				  
				  		<!-- 8/11/2017 Stop the process if the position is already used for another orgunit 
						right now we can support different orgunits but the query is not ready for this
						here we need to include the auditid --->	
				  
					   <cfquery name="CheckPosition" 
						datasource="AppsProgram" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">
							SELECT *
							FROM   ProgramPeriod Pe 
							       INNER JOIN   ProgramAllotmentRequest R ON Pe.ProgramCode = R.ProgramCode AND Pe.Period = R.Period
							       INNER JOIN   Employee.dbo.Position P ON R.PositionNo = P.PositionNo
							WHERE  R.Period     = '#Form.Period#'
							AND    R.EditionId  = '#Form.EditionId#'
							AND    Pe.OrgUnit !=  '#ProgramPeriod.OrgUnit#'							
							AND    R.PositionNo = '#positionno#'
							AND    R.ActionStatus != '9'
						</cfquery>
						
						<cfif CheckPosition.recordcount gte "1">
								
							<cfif CheckPosition.SourcePostNumber neq "">	
								<cfset vSourcePostNumber = CheckPosition.SourcePostNumber>
							<cfelse>
								<cfset vSourcePostNumber = CheckPosition.PositionNo>
							</cfif>
							
							<cfquery name="qProgramReference" 
							datasource="AppsProgram" 
							username="#SESSION.login#" 
							password="#SESSION.dbpw#">
								SELECT *
								FROM   ProgramPeriod
								WHERE  ProgramCode = '#CheckPosition.ProgramCode#'
								AND    Period      = '#Form.Period#'
							</cfquery> 
	
							<cfif qProgramReference.recordcount neq "">
								<cfset vRef = qProgramReference.Reference>
							<cfelse>
								<cfset vRef = qProgramReference.ProgramCode> 
							</cfif>					
							
						    <cfoutput>										
								<script>
									alert("#postext#. Please check the position #vSourcePostNumber# in program #vRef#.");
									Prosis.busy('no');
								</script>
							</cfoutput>
							
							<cfabort>
						
						</cfif>
				  
				  </cfif>  		
				    
				  				 
				  <cfquery name="Insert" 
					datasource="AppsProgram" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
																											
						INSERT INTO ProgramAllotmentRequest 
						    (ProgramCode,			 
							 Period,
							 EditionId,
							 RequirementId,
							 ObjectCode,
							 Fund,
							 ItemMaster,	
							 BudgetCategory,	
							 ActivityId,		 									 
							 ResourceUnit,	
							 RequestLocationCode,								 
							 RequestDescription,
							 TopicValueCode,		
							 <cfif Object.RequirementMode eq "2" and PositionMode.BudgetEntryPosition eq "1">														
							 PositionNo,
							 </cfif>
							 RequestDue,										 
							 <cfif Object.RequirementPeriod eq "0">					 
								 <cfif Object.RequirementMode eq "1" or Object.RequirementMode eq "3">
									 ResourceQuantity,
									 ResourceDays,
								 </cfif>					 
								 RequestQuantity,					 
							 </cfif>					 
							 RequestPrice,
							 RequestRemarks,
							 RequirementIdParent,
							 RequirementSerialNo,
							 ActionStatus,
							 OfficerUserId,
							 OfficerLastName,
							 OfficerFirstName)
							 
					  VALUES (
					          '#Form.ProgramCode#',	  
					  	      '#Form.Period#',    
							  '#Form.EditionId#',
							  '#rowguid#',
							  '#Form.ObjectCode#',
							  '#Form.Fund#',
							  '#ItemMaster#',	
							  <cfif Form.BudgetCategory eq "">
							    NULL,
							  <cfelse>
							    '#Form.BudgetCategory#',
							  </cfif>		
							  <cfif Form.ActivityId eq "">
							  	NULL,
							  <cfelse>
							    '#Form.ActivityId#',
							  </cfif>		
							  					  					  				  
							  <cfif Object.RequirementUnit eq "1">					 
							    '#Form.OrgUnit#',	
							  <cfelse>
							    NULL,					 
							  </cfif>	
							  '#Form.RequestLocationCode#',							  
							  <cfif Object.RequirementMode eq "2">								  				  	  
								  '#topicvalue#',
								  '#topicvaluecode#',		
								  <cfif PositionMode.BudgetEntryPosition eq "1">			 							  
								  '#positionno#',
								  </cfif>
							  <cfelseif topicvaluecode eq "" and Object.RequirementMode neq "2">
								  '#RequestDescription#',
								  NULL,
							  <cfelse>
								  '#get.topicvalue#',
								  '#get.topicvaluecode#', 
							  </cfif>
							  
							  <cfif form.requestDue neq "">
							     #dte#,
							  <cfelseif Object.RequirementPeriod eq "0">
							     '#Period.DateEffective#',
							  <cfelse>
							     <!--- the ProgramAllotmentRequestQuantity table takes over --->
							     NULL,							    	 
							  </cfif>
							  
							  <cfif Object.RequirementPeriod eq "0">
							  
								  <cfif Object.RequirementMode eq "1" or Object.RequirementMode eq "3">
									  '#ResourceQuantity#',
									  '#ResourceDays#',
								  </cfif>
								  '#rqty#',
							  
							  </cfif>
							  
							  '#rprc#',
							  '#Form.RequestRemarks#',   
							  '#url.requirementId#',
							  '#row#',
							  '#st#',				
							  '#SESSION.acc#',
					    	  '#SESSION.last#',		  
						  	  '#SESSION.first#'
							  )
					</cfquery>		
										
				</cfif>		
				
			</cfif>	
							
		</cfloop>
		
	
<cfelse>

	<cfset processmode = "Edit">
				
	<!--- --------------------------------- --->	
	<!--- ------------- EDIT -------------- --->
	<!--- --------------------------------- --->
	
	<!--- we are getting the parent and determine all the records with the same parent --->
			
	<cfquery name="Parent" 
	datasource="AppsProgram" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT  * 
		FROM    ProgramAllotmentRequest
		WHERE   RequirementIdParent = '#url.requirementIdParent#' 
		AND     Period              = '#Form.Period#'
		AND     RequestType         = 'Standard'  <!--- 13/9 we exclude the ripple records here as these are handled below after wards ---> 
	</cfquery>	
	
	<cfset reqlist = "">
	
	<cfloop query="Parent">
	
		<cfif reqlist eq "">
			<cfset reqlist = "#requirementId#">
		<cfelse>	
		    <cfset reqlist = "#reqlist#,#requirementId#">
		</cfif>
	
	</cfloop>  
	
			
	<!--- we loop through the existing record requirement children --->
			
	<cfloop index="requirementid" list="#reqlist#">
	
		<cfquery name="Check" 
		datasource="AppsProgram" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT  * 
		FROM    ProgramAllotmentRequest		
		WHERE   RequirementId   = '#requirementId#'		
        </cfquery>
	
		<cfif Check.objectcode neq Form.ObjectCode or check.fund neq Form.Fund>		
		 	<cfset change = "1">			
		<cfelse>
			<cfset change = "0">
		</cfif>
		
		<!--- now we go through the list of item as we want to record them --->
	
		<cfloop query="List">	
		
			<cfset ItemMaster = Code>
		
			<cfparam name="form.RequestDescription_#currentrow#"  default="">
			<cfparam name="form.topicvaluecode_#currentrow#"      default="">
			
			<!--- we have the option to work per period here ---> 
			<cfparam name="form.requestquantity_sum"               default="">	
			<cfparam name="form.requestquantity_#currentrow#"      default="">
			<!--- ------------------------------------------ --->
	
			<cfparam name="form.resourcequantity_#currentrow#"    default="">
			<cfparam name="form.resourcedays_#currentrow#"        default="">
			
			<cfset requestDescription = evaluate("form.RequestDescription_#currentrow#")>
			<cfset TopicValueCode     = evaluate("form.topicvaluecode_#currentrow#")>
									
			<cfif form.requestQuantity_sum neq "">
				<cfset requestQuantity    = form.requestQuantity_sum>
			<cfelse>
				<cfset requestQuantity    = evaluate("form.requestQuantity_#currentrow#")>
			</cfif>
			
			<cfset requestQuantity       = replace(requestQuantity,',','',"ALL")>
	
			<cfset resourceQuantity   = evaluate("form.resourceQuantity_#currentrow#")>
			<cfset resourceDays       = evaluate("form.resourceDays_#currentrow#")>
			<cfset requestPrice       = evaluate("form.requestPrice_#currentrow#")>
			<cfset requestPrice       = replace(RequestPrice,',','',"ALL")>
			<cfset requestPrice       = replace(RequestPrice,' ','',"ALL")>				
			
			<cfif Object.RequirementMode neq "2">		
			 
			 	<cfif List.BudgetTopic eq "Standard">
				
					<!-- selection list instead --->
			  	  
					<cfquery name="get" 
						datasource="AppsProgram" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">
							SELECT    *
							FROM      Purchase.dbo.ItemMasterList
							WHERE     ItemMaster     = '#itemmaster#'
							AND       TopicValueCode = '#topicvaluecode#'
					</cfquery>
				
				<cfelseif List.BudgetTopic eq "DSA">
							
					<cfquery name="get" 
							datasource="AppsProgram" 
							username="#SESSION.login#" 
							password="#SESSION.dbpw#">
							SELECT   LocationCode as TopicValueCode,
							         Description as TopicValue
							FROM     TravelClaim.dbo.Ref_PayrollLocation 					
							WHERE    LocationCode = '#topicvaluecode#' 	
							
					</cfquery>	
				
				</cfif>
			
			</cfif>		 	  
											
			<!--- Dev problem if you would add an lines, which did not exisit before it will not be picked up --->
			
						
			
			<cfif   (PositionMode.BudgetEntryPosition neq "1" and Check.TopicValueCode eq topicvaluecode) 
			     or (PositionMode.BudgetEntryPosition eq "1" and Check.PositionNo eq PositionNo) >
				 								
				 <!--- logging of allotment release amount --->
				 <cfinvoke component = "Service.Process.Program.ProgramAllotment"  
				   method           = "LogRequirement" 
				   RequirementId    = "#RequirementId#">	
				   				
					<cfquery name="Update" 
						datasource="AppsProgram" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">						
						UPDATE ProgramAllotmentRequest
						SET    ObjectCode         = '#Form.ObjectCode#',
							   Fund               = '#Form.Fund#',
							   ItemMaster         = '#ItemMaster#',
							   
							   <cfif Object.RequirementUnit eq "1">						 
								 ResourceUnit = '#Form.OrgUnit#',						 
							   </cfif>
							   
							   RequestLocationCode = '#Form.RequestLocationCode#',
							   					   
							   <cfif Form.BudgetCategory eq "">
									BudgetCategory = NULL,	
							   <cfelse>
									BudgetCategory = '#Form.BudgetCategory#',
							   </cfif>
							   					     					   
							   <cfif Form.ActivityId eq "">
									ActivityId = NULL,	
							   <cfelse>
									ActivityId = '#Form.ActivityId#',
							   </cfif>					   
								
							   <cfif Object.RequirementMode neq "2">
							  
								   <cfif topicvaluecode eq "">
									   RequestDescription = '#RequestDescription#',
									   TopicValueCode     = NULL,
								   <cfelse>
									   RequestDescription = '#get.topicvalue#',
									   TopicValueCode     = '#get.topicvaluecode#',
								   </cfif>			   
							   
							   </cfif>
							  
							   <cfif Object.RequirementPeriod eq "0">
							   
								   <cfif form.requestDue neq "">
								   RequestDue         = #dte#,
								   </cfif>
								   RequestQuantity    = '#requestQuantity#',
								  <cfif Object.RequirementMode eq "1" or Object.RequirementMode eq "3">
								         <cfset rqty = replace(ResourceQuantity,',','',"ALL")>
										 ResourceQuantity  =  '#rqty#',
										 <cfset rday = replace(ResourceDays,',','',"ALL")>
										 ResourceDays      =  '#rday#',
								   </cfif>
								  			   
							   </cfif>
							   			   
							   RequestPrice       = '#RequestPrice#',			   
							   RequestRemarks     = '#Form.RequestRemarks#'
						WHERE  RequirementId      = '#requirementId#'		
				     </cfquery>
					 
					 <!--- now we check oif we change the amount to be released for allotment should change --->
					
					<cfquery name="get" 
					datasource="AppsProgram" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
					    SELECT * 
						FROM   ProgramAllotmentRequest
						WHERE  RequirementId = '#RequirementId#'	
					</cfquery>
					
					<cfif get.AmountBaseAllotment neq get.RequestAmountBase>
					
						<cfquery name="get" 
						datasource="AppsProgram" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">
						    UPDATE ProgramAllotmentRequest
							SET    AmountBaseAllotment = '#get.RequestAmountBase#'
							WHERE  RequirementId = '#RequirementId#'	
						</cfquery>
					
					</cfif>				
					 				 
			 </cfif>					
			 			 			 
		</cfloop>	
						
		<!--- if we detect a change in the requirement we always reset the line in ProgramAllotmentDetail
		so it can be resubmitted, 
		
		However we do not allow a requirement line to be amended though, so this is overkill  
		
		--->
	
		<!--- attention ----------------------------------------------------------------- --->
		<!--- if the fund/object was changed it -always- means we need to reset allotment --->
		<!--- --------------------------------------------------------------------------- --->
 
	    <cfif change eq "1">
					 
		 	<cfquery name="Update" 
			datasource="AppsProgram" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			 UPDATE ProgramAllotmentDetail			 
			 SET    Status = '0', 
			        ActionId = NULL
			 WHERE  TransactionId IN (SELECT TransactionId 
			                          FROM   ProgramAllotmentDetailRequest
		                              WHERE  Requirementid = '#requirementId#')
			</cfquery>		
			
			<!--- clean the detailed transaction entries --->
			
			<cfquery name="Update" 
			datasource="AppsProgram" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			   DELETE  FROM ProgramAllotmentDetailRequest
			   WHERE   Requirementid = '#requirementId#'		
			</cfquery>	
						
			<!--- attention this we need to extend for the rippled records as well --->	
		
	    </cfif>
						 
	</cfloop> 	 
			
</cfif>

<!--- ------------------------------------------------ --->
<!--- define all lines involved for details and custom --->
<!--- ------------------------------------------------ --->

<cfif url.requirementidparent eq "">

	<cfset reqlist = rowguid>

<cfelseif processmode eq "Add">

	<cfquery name="Parent" 
		datasource="AppsProgram" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT  *
			FROM    ProgramAllotmentRequest
			WHERE   RequirementIdParent = '#url.requirementId#' 
			AND     Period              = '#Form.Period#'
	</cfquery>
		
	<cfset reqlist = "">
		
	<cfloop query="Parent">
		
		<cfif reqlist eq "">
			<cfset reqlist = "#requirementId#">
		<cfelse>	
		    <cfset reqlist = "#reqlist#,#requirementId#">
		</cfif>
		
	</cfloop>   	

<cfelse>
		
	<cfquery name="Parent" 
		datasource="AppsProgram" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT  *
			FROM    ProgramAllotmentRequest
			WHERE   RequirementIdParent = '#url.requirementIdParent#' 
			AND     Period              = '#Form.Period#'
	</cfquery>
		
	<cfset reqlist = "">
		
	<cfloop query="Parent">
		
		<cfif reqlist eq "">
			<cfset reqlist = "#requirementId#">
		<cfelse>	
		    <cfset reqlist = "#reqlist#,#requirementId#">
		</cfif>
		
	</cfloop>   	

</cfif>

<!--- Finishing

- A. Capture subquantities by period
- B. Customer fields
- C. Ripple effect
- D. Ceiling and Recalculation

--->

<!--- --------------------------------------------------- --->
<!--- A. re-populate the quantity detailes from scratch-- --->
<!--- --------------------------------------------------- --->

<!--- Attention : 13/9/2014 if there is rippler record defined which als has period enabled, then through this
    action the ripple is correct on a deeper level and then the action under 4 to create a new
	ripple record will not occur, the allotments will not be affected here --->
	
<cfquery name="Fund" 
	datasource="AppsProgram" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT   *
	FROM     Ref_Fund
	WHERE    Code = '#form.fund#'	
</cfquery>

<cfparam name="form.contributionLineId" default="">

<cfif Fund.fundingMode eq "Donor">

	<cfloop index="requirementid" list="#reqlist#">

		<cfquery name="Clean" 
		datasource="AppsProgram" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			DELETE  FROM ProgramAllotmentRequestContribution
			WHERE   RequirementId = '#requirementId#' 
		</cfquery>
		
		<cfloop index="contrib" list="#form.contributionlineid#">
		
			 <cfquery name="Insert" 
				  datasource="AppsProgram" 
				  username="#SESSION.login#" 
				  password="#SESSION.dbpw#">
				  
				  INSERT INTO ProgramAllotmentRequestContribution
				 		 (RequirementId, ContributionLineId,OfficerUserId,OfficerLastName,OfficerFirstName)
				  VALUES ('#requirementid#','#contrib#','#session.acc#','#session.last#','#session.first#')
			 </cfquery>	 
		
		</cfloop>
		
	</cfloop>	
		
</cfif>

<cfif Object.RequirementPeriod eq "1">

	<cfquery name="Init" 
		datasource="AppsProgram" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		DELETE    ProgramAllotmentRequestQuantity
		WHERE     Requirementid IN ( SELECT RequirementId
				                     FROM   ProgramAllotmentRequest 
							 		 WHERE  RequirementIdParent = '#url.requirementidParent#'
									 AND    Period               = '#Form.Period#'
									 AND    RequestType        != 'Ripple' )	
	</cfquery>								 

	<cfloop index="requirementid" list="#reqlist#">
				
		<!--- check the number of the field in the list --->
				
		<cfquery name="Get" 
		datasource="AppsProgram" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT  *
			FROM    ProgramAllotmentRequest
			WHERE   RequirementId = '#requirementId#' 
		</cfquery>
		
		<!---
		<cfquery name="Clean" 
		datasource="AppsProgram" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			DELETE  FROM ProgramAllotmentRequestQuantity
			WHERE   RequirementId = '#requirementId#' 
		</cfquery>
		--->
		
		<!--- set the period of the dates to be saved --->
							   
		<cfquery name="getEdition" 
			datasource="AppsProgram" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				SELECT    *
				FROM      Ref_AllotmentEdition
				WHERE     EditionId      = '#form.Editionid#'				
		</cfquery>	
	
		<cfif getEdition.period eq "">
			<cfset perdates = get.period>
		<cfelse>
			<cfset perdates = getEdition.period>
		</cfif>					
					
		<cfset row = 1>
		
		<cfloop query="List">

			<cfif PositionMode.BudgetEntryPosition eq "0">	
				<cfif Get.TopicValueCode eq TopicValueCode>
					 <cfset row = currentrow>				
				</cfif>
			<cfelse>
			  	<cfif Get.PositionNo eq PositionNo>
					 <cfset row = currentrow>				
				</cfif>
			</cfif>	
					
		</cfloop>		
							
		<cfquery name="Edition" 
		datasource="AppsProgram" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT   *
			FROM     Ref_AllotmentEdition
			WHERE    EditionId      = '#Form.Editionid#'	
		</cfquery>
									
		<cfquery name="Dates" 
			datasource="AppsProgram" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				SELECT   *
				FROM     Ref_Audit				
				WHERE    Period = '#perdates#'				
				<cfif getItemMaster.BudgetAuditClass neq "" and Object.RequirementMode neq "2">
				AND      (
					         AuditId NOT IN (SELECT AuditId FROM Ref_AuditClass) OR
							 Auditid IN (SELECT AuditId 
							               FROM Ref_AuditClass 
										   WHERE AuditClass = '#getItemMaster.BudgetAuditClass#')
						 )		
				</cfif>
				<!--- filter on the visible ids only --->				
				AND    AuditId IN (#preserveSingleQuotes(Form.AuditIds)#)
				ORDER BY AuditDate
		</cfquery>							
				
		<cfloop query="dates">
		
			<cfif Object.RequirementMode neq "2">	
						
				<cfparam name = "Form.requestquantity_#currentrow#"  default="">
				<cfparam name = "Form.resourcequantity_#currentrow#" default="">
				<cfparam name = "Form.resourcedays_#currentrow#"     default="">
				<cfparam name = "Form.remarks_#currentrow#"          default="">
						
				<cfset qty  = Evaluate("FORM.requestquantity_#currentrow#")>
				<cfset res  = Evaluate("FORM.resourcequantity_#currentrow#")>
				<cfset day  = Evaluate("FORM.resourcedays_#currentrow#")>
				<cfset rem  = Evaluate("FORM.remarks_#currentrow#")>
			
			<cfelse>
			
				<cfset qty  = Evaluate("FORM.c#row#_#currentrow#")>
				<cfset res  = "">
				<cfset day  = "">
				<cfset rem  = "">
							
			</cfif>
			
			<cfif qty eq "">
				<cfset qty = "0">
			</cfif>
						
			<cfset qty = replace(qty,',','',"ALL")>
			<cfset res = replace(res,',','',"ALL")>
			<cfset day = replace(day,',','',"ALL")>
						
		    <cfif res neq "" and LSIsNumeric(res) and LSIsNumeric(day) and qty neq "0">	
		
		         <!--- ---------- --->
				 <!--- days entry --->
				 <!--- ---------- --->
				
				 <cfset qty = res*day>		
				 
				 <cfquery name="Insert" 
					  datasource="AppsProgram" 
					  username="#SESSION.login#" 
					  password="#SESSION.dbpw#">
					  INSERT INTO ProgramAllotmentRequestQuantity
					 		 (RequirementId, AuditId, RequestQuantity,ResourceQuantity,ResourceDays,Remarks,OfficerUserId,OfficerLastName,OfficerFirstName)
					  VALUES ('#requirementid#','#auditid#','#qty#','#res#','#day#','#rem#','#session.acc#','#session.last#','#session.first#')
				 </cfquery>	 
				 
			<cfelseif LSIsNumeric(qty) and qty neq "0">
			
				<cfquery name="Insert" 
				  datasource="AppsProgram" 
				  username="#SESSION.login#" 
				  password="#SESSION.dbpw#">
				  INSERT INTO ProgramAllotmentRequestQuantity
				 		 (RequirementId, AuditId, RequestQuantity,Remarks,OfficerUserId,OfficerLastName,OfficerFirstName)
				  VALUES ('#requirementid#','#auditid#','#qty#','#rem#','#session.acc#','#session.last#','#session.first#') 				  
				</cfquery>
										 
			</cfif>		
												
		</cfloop>		
			
		<!--- ---------------------------------- --->
		<!--- update parent line of the quantity --->
		<!--- ---------------------------------- --->
		
		<cfquery name="getDetails" 
			  datasource="AppsProgram" 
			  username="#SESSION.login#" 
			  password="#SESSION.dbpw#">
				SELECT    ISNULL(SUM(RequestQuantity),0) as Quantity
			    FROM      ProgramAllotmentRequestQuantity
			    WHERE     RequirementId = '#requirementId#'
		</cfquery>  					
		
		<cfif getDetails.Quantity eq "0">
												
			<cfquery name="get" 
			  datasource="AppsProgram" 
			  username="#SESSION.login#" 
			  password="#SESSION.dbpw#">
			  SELECT *
			  FROM   ProgramAllotmentRequest
			  WHERE  RequirementId = '#requirementId#'
			</cfquery>  
				
			<!--- Dev removed we can NOT really remove ripples here as they might be alloted refer to
			code under rippkied 9/13/2014 --->
			
			<!--- removed  !!!!!!!					
			<cfquery name="clearRipples" 
			  datasource="AppsProgram" 
			  username="#SESSION.login#" 
			  password="#SESSION.dbpw#">
			  DELETE FROM ProgramAllotmentRequest
		      WHERE  1=1
			  AND    (RequirementIdParent = '#get.requirementIdParent#' AND RequestType = 'Ripple' AND TopicValueCode = '#get.TopicValueCode#')
			  OR     RequirementId = '#requirementId#'			  
			</cfquery>  
			
			--->
			
		<cfelse>					
							
			<cfquery name="Header" 
				  datasource="AppsProgram" 
				  username="#SESSION.login#" 
				  password="#SESSION.dbpw#">
					UPDATE    ProgramAllotmentRequest
					SET       ResourceQuantity =
			                          (SELECT     SUM(ResourceQuantity)
			                            FROM      ProgramAllotmentRequestQuantity
			                            WHERE     RequirementId = '#requirementId#'),
							  ResourceDays =
			                          (SELECT     SUM(ResourceDays)
			                            FROM      ProgramAllotmentRequestQuantity
			                            WHERE     RequirementId = '#requirementId#'),
							  RequestQuantity =
			                          (SELECT     ISNULL(SUM(RequestQuantity),0)
			                            FROM      ProgramAllotmentRequestQuantity
			                            WHERE     RequirementId = '#requirementId#'),		
							  RequestDue = 	
								  	 (SELECT      MIN(AuditDate)
									    FROM      ProgramAllotmentRequestQuantity Q, Ref_Audit R
										WHERE     Q.AuditId = R.AuditId
			                            AND       RequirementId = '#requirementId#')							  		
														
					WHERE     RequirementId = '#requirementId#'
			</cfquery>		
			
			<!--- correcion 30/10/2014 if resource quantity = NULL, we a pply a ceiling / 12 --->
					
			<cfquery name="Header" 
				  datasource="AppsProgram" 
				  username="#SESSION.login#" 
				  password="#SESSION.dbpw#">
					UPDATE    ProgramAllotmentRequest
					SET       ResourceQuantity = CEILING(RequestQuantity/12)													
					WHERE     RequirementId = '#requirementId#'
					AND       ResourceQuantity is NULL
			</cfquery>											
			
			<!--- now we check oif we change the amount to be released for allotment should change --->
					
			<cfquery name="get" 
				datasource="AppsProgram" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				    SELECT * 
					FROM   ProgramAllotmentRequest
					WHERE  RequirementId = '#RequirementId#'	
			</cfquery>													
						   
			<cfif get.AmountBaseAllotment neq get.RequestAmountBase>				
					
				<cfquery name="set" 
				datasource="AppsProgram" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				    UPDATE ProgramAllotmentRequest
					SET    AmountBaseAllotment = '#get.RequestAmountBase#'
					WHERE  RequirementId = '#RequirementId#'	
				</cfquery>
					
			</cfif>					

			<cfif ISDEFINED("FORM.CostElement_#ROW#")>			
				<cfset url.rid = requirementId>
				<cfset url.row = row>			
				<cfset url.operation = "Write">
				<cfset url.itemmaster = form.itemmaster>
				<cfinclude template = "RateCalculation.cfm">
			</cfif>				
			
		</cfif>	
												
	</cfloop>	
	
	<cfquery name="Init" 
		datasource="AppsProgram" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		
		DELETE    ProgramAllotmentDetailRequest
		FROM      ProgramAllotmentDetailRequest T
		WHERE     Requirementid IN ( SELECT RequirementId
				                     FROM   ProgramAllotmentRequest 
							 		 WHERE  RequirementIdParent = '#url.requirementidParent#'
									 AND    Period               = '#Form.Period#'
									 AND    RequestType        != 'Ripple' )	
		AND       NOT EXISTS (SELECT 'X'
		                      FROM ProgramAllotmentRequestQuantity WHERE RequirementId = T.RequirementId) 	
		
		DELETE    ProgramAllotmentRequest
		FROM      ProgramAllotmentRequest T
		WHERE     Requirementid IN ( SELECT RequirementId
				                     FROM   ProgramAllotmentRequest 
							 		 WHERE  RequirementIdParent = '#url.requirementidParent#'
									 AND    Period               = '#Form.Period#'
									 AND    RequestType        != 'Ripple' )	
		AND       NOT EXISTS (SELECT 'X'
		                      FROM ProgramAllotmentRequestQuantity WHERE RequirementId = T.RequirementId) 							 
	</cfquery>			
	
	<!--- remove requirements without any quantity --->
	
	
	
</cfif>


<!--- --------------------------------------------------- --->
<!--- ---------------------  END ------------------------ --->
<!--- --------------------------------------------------- --->

<!--- --------------------------------------------------- --->
<!--- B. re-populate the custom fields ------------------ --->
<!--- --------------------------------------------------- --->

<cfloop index="requirementid" list="#reqlist#">
			
	<cfquery name="CleanTopics" 
	  datasource="AppsProgram" 
	  username="#SESSION.login#" 
	  password="#SESSION.dbpw#">
	  DELETE FROM ProgramAllotmentRequestTopic
	  WHERE       RequirementId = '#requirementId#'
	</cfquery>
	
	<cfquery name="GetTopics" 
			  datasource="AppsProgram" 
			  username="#SESSION.login#" 
			  password="#SESSION.dbpw#">
			  SELECT *
			  FROM   Ref_Topic
			  WHERE  Code IN (SELECT Code 
			                  FROM   Ref_TopicObject 
							  WHERE  ObjectCode = '#Form.ObjectCode#')
			  AND Operational = 1				  
	</cfquery>
				
	<cfloop query="getTopics">
	
	    <cfif ValueClass eq "List">
			
			<cfset value  = Evaluate("FORM.Topic_#Code#")>
			
			 <cfquery name="GetList" 
					  datasource="AppsProgram" 
					  username="#SESSION.login#" 
					  password="#SESSION.dbpw#">
					  SELECT *
					  FROM Ref_TopicList T
					  WHERE T.Code = '#Code#'
					  AND   T.ListCode = '#value#'				  
			</cfquery>
						
			<cfif value neq "">
						
			<cfquery name="InsertTopics" 
			  datasource="AppsProgram" 
			  username="#SESSION.login#" 
			  password="#SESSION.dbpw#">
			  INSERT INTO ProgramAllotmentRequestTopic
			 		 (RequirementId,Topic,ListCode,TopicValue)
			  VALUES ('#requirementId#','#Code#','#value#','#getList.ListValue#')
			</cfquery>
			
			</cfif>
			
		<cfelse>
		
			<cfif ValueClass eq "Boolean">
			
				<cfparam name="FORM.Topic_#Code#" default="0">
				
			</cfif>
			
			<cfset value  = Evaluate("FORM.Topic_#Code#")>
			
			<cfif value neq "">
			
				<cfquery name="InsertTopics" 
				  datasource="AppsProgram" 
				  username="#SESSION.login#" 
				  password="#SESSION.dbpw#">
				  INSERT INTO ProgramAllotmentRequestTopic
				 		 (RequirementId, Topic, TopicValue)
				  VALUES ('#requirementId#','#Code#','#value#')
				</cfquery>	
			
			</cfif>
		
		</cfif>	
				
	</cfloop>
	
	<cftry>
												
	<!--- logging of allotment release amount --->
	 <cfinvoke component = "Service.Process.Program.ProgramAllotment"  
	   method           = "LogRequirement" 
	   RequirementId    = "#RequirementId#">		
	   
	   <cfcatch></cfcatch>
	  
	 </cftry>  
	
</cfloop>	

	
<!--- --------------------------------------------------- --->
<!--- ---------------------  END ------------------------ --->
<!--- --------------------------------------------------- --->


<!--- -------------------------------------------------- --->
<!--- -------C.  Now we apply the ripple effects ------- --->
<!--- -------------------------------------------------- --->



<cfset row = 0>

<cfloop index="requirementid" list="#reqlist#">

	<cfinclude template="RequestSubmitRipple.cfm">

</cfloop>

<!--- --------------------------------------------------- --->
<!--- ---------------------  END ------------------------ --->
<!--- --------------------------------------------------- --->



<!--- --------------------------------------------------- --->
<!--- ---D. now we test if the ceiling is not exceeded--- --->
<!--- --------------------------------------------------- --->

<cfquery name="Check" 
datasource="AppsProgram" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT  *
	FROM    Ref_ParameterMissionResource
	WHERE   Mission = '#Program.Mission#'	
	AND     Resource = '#Object.Resource#'				
</cfquery>

<cfif Check.Ceiling eq "1">

	<cfquery name="Ceiling" 
	datasource="AppsProgram" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		  SELECT sum(Amount) as Amount
		  FROM   ProgramAllotmentCeiling
		  WHERE  ProgramCode  = '#Form.ProgramCode#'
		  AND    Period       = '#Form.Period#'
		  AND    EditionId    = '#Form.EditionId#'
		  AND    Resource     IN (SELECT Resource
								  FROM   Ref_ParameterMissionResource
								  WHERE  Mission = '#Program.Mission#'				
								  AND    Ceiling = 1)  
	</cfquery> 
	
	<!--- check requested for ceiling sources --->
	
	<cfquery name="Requested" 
	datasource="AppsProgram" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		  SELECT sum(RequestAmountBase) as Amount
		  FROM   ProgramAllotmentRequest
		  WHERE  ProgramCode  = '#Form.ProgramCode#'
		  AND    Period       = '#Form.Period#'
		  AND    EditionId    = '#Form.EditionId#'						  
		  AND    ObjectCode IN (SELECT  Code  
		                        FROM    Ref_Object
							    WHERE   Resource IN (SELECT  Resource
								  					  FROM   Ref_ParameterMissionResource
												      WHERE  Mission = '#Program.Mission#'				
													   AND   Ceiling = 1
													 )
							   )  
	</cfquery> 
	
	<cfif Ceiling.amount lt Requested.amount and Ceiling.amount gt "0">
		
		<cfoutput>
				
		<script>
			alert("#exceed# #exceedin# #numberformat(Requested.amount-Ceiling.amount,"__,__.__")#")
			Prosis.busy('no')
		</script>
		
		</cfoutput>
		
		<cfabort>
		
	</cfif>
	
</cfif>	

</cftransaction>

<!--- checkes the allotment entry and calculates the defined program support cost --->	  

	<cfinvoke component = "Service.Process.Program.Program"  
	   method           = "SyncProgramBudget" 
	   ProgramCode      = "#Form.ProgramCode#" 
	   Period           = "#Form.Period#"
	   EditionId        = "#Form.EditionId#">	 		
	
<!--- --------------------------------------------------- --->
<!--- ---------------------  END ------------------------ --->
<!--- --------------------------------------------------- --->

<cfoutput>
	
	<script language="JavaScript">
	   
	   		Prosis.busy('no')
			ptoken.navigate('#SESSION.root#/programrem/Application/Budget/Request/RequestDialogForm.cfm?mode=add&requirementid=&programcode=#form.programCode#&period=#form.period#&editionid=#form.EditionId#&objectcode=#form.ObjectCode#&activityid=#url.activityid#&cell=#url.cell#&itemmaster=#Form.ItemMaster#','entrydialog')		
			md = document.getElementById('summaryselectmode').value
			ptoken.navigate('#SESSION.root#/programrem/application/budget/request/RequestSummary.cfm?summarymode='+md+'&programcode=#form.programcode#&period=#form.period#&activityid=#url.activityid#&editionid=#form.editionid#','summary')
			 
			// this refresh was no longer needed ptoken.navigate('#SESSION.root#/programrem/application/budget/request/RequestList.cfm?scope=dialog&programcode=#form.programcode#&period=#form.period#&activityid=#url.activityid#&editionid=#form.editionid#&objectcode=#form.objectcode#&itemmaster=#Form.ItemMaster#&requirementid=#url.requirementid#','details')													
			
			<!--- now we try to process the underlying screen for the values --->
			try {			 	 
			   parent.opener.refreshview('#form.programcode#','#form.period#','#form.editionid#','#form.objectcode#') 				 
			 } catch(e) { }
			 
			try {			 	 			  
			   parent.opener.menuoption('gantt','1','0')			  
			 } catch(e) { } 
									
	</script>

</cfoutput>
