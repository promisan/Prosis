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
<cf_tl id="REQ058" var="1">
<cfset vReq058=#lt_text#>

<cf_tl id="REQ059" var="1">
<cfset vReq059=#lt_text#>

<cf_tl id="Operation not allowed." var="1">
<cfset vONA=#lt_text#>

<cfparam name="Form.CaseReference" default="">

<cfset select = SESSION["reqlist_#url.mode#"]>

<cfif select eq "">
	<cf_alert message = "#vReq058# #vONA#"  return = "back">
	<cfabort>
</cfif>

<cfparam name="Form.SelectMe" default="">

<cfif Form.SelectMe eq "add">
	<cfif Form.CaseNo eq "">
		<cf_tl id="CaseNo" var="1">
	    <cf_alert message = "#vReq059# #lt_text#. #vONA#"  return = "back">
		<cfabort>
	</cfif>
</cfif>

<!--- add

      1. define job No 
	  2. add jobactor 
      3. create job header  
	  4. update jobno in reqline 
	  5. Create vendor lines
	
	  exist
	  1. update jobno in reqline 
	  2. add requisitionLinevendor based on JobVendor
		  
--->

<cfquery name="Parameter" 
	datasource="AppsPurchase" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
    SELECT *
    FROM Ref_ParameterMission
	WHERE Mission = '#URL.Mission#' 
</cfquery>

<cfset last = Parameter.QuotationSerialNo>
	
<cftransaction>

<cfif Form.selectjob neq "Exist">

		<!---  1. define reference No  --->
		<cflock timeout="20" throwontimeout="No" name="SerialNo" type="EXCLUSIVE">
		
				<cfset getno = 1>
		
				<cfloop condition="#getno# eq 1">
				
					<cfset No = last+1>
					<cfif No lt 1000>
					     <cfset No = 1000+No>
					</cfif>		
					
					<cfset JobNo = "#Parameter.MissionPrefix#-#Parameter.QuotationPrefix#-#No#">
								
					<cfquery name="Exist" 
					datasource="AppsPurchase" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
					    SELECT * FROM Job WHERE JobNo = '#JobNo#'					
					</cfquery>	
					
					<cfif Exist.recordcount eq "0">
						
						<cfset getno = 0>
						
					<cfelse>
					
						<cfset last = no>	
					
					</cfif>
				
				</cfloop>
									
				<cfquery name="Update" 
				datasource="AppsPurchase" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				    UPDATE Ref_ParameterMission
					SET    QuotationSerialNo = '#No#'				
					WHERE  Mission = '#URL.Mission#'
				</cfquery>
				
		</cflock>			
		
						
		<!--- 2. create job header  --->
		
		<cfquery name="Insert" 
		     datasource="AppsPurchase" 
		     username="#SESSION.login#" 
		     password="#SESSION.dbpw#">
		     INSERT INTO Job 
					 (JobNo, 
					  OrderClass, 
					  JobCategory, 
					  Mission, 
					  Period, 
					  Description, 
			 	      CaseName, 
					  CaseNo, 
					  CaseReference, 
					  ActionStatus, 
					  OfficerUserId, 
					  OfficerLastName, 
					  OfficerFirstName) 
		     VALUES ('#jobno#', 
			         '#Form.OrderClass#', 
					 '#Form.JobCategory#', 
					 '#URL.Mission#', 
					 '#URL.Period#',
					 '#Form.Description#',
			 	     '#Form.CaseName#', 
					 '#Form.CaseNo#', 
					 '#Form.CaseReference#', 
					 '0', 
					 '#SESSION.acc#', 
					 '#SESSION.last#', 
					 '#SESSION.first#')
		</cfquery>
		
		<!---  3. enter actor --->
		
		<cfquery name="InsertJobActor" 
		     datasource="AppsPurchase" 
		     username="#SESSION.login#" 
		     password="#SESSION.dbpw#">
		     	INSERT INTO JobActor 
					 (JobNo, Role, ActorUserId, ActorLastName, ActorFirstName, OfficerUserId, OfficerLastName, OfficerFirstName) 
				VALUES ('#jobno#',
				        'ProcBuyer', 
						'#SESSION.acc#', 
						'#SESSION.last#', 
						'#SESSION.first#',
						'#SESSION.acc#', 
						'#SESSION.last#', 
						'#SESSION.first#')
		</cfquery>			
		
								
<cfelse>

		<cfset JobNo = Form.JobNo>

</cfif>


<cfloop index="req" list="#select#">
	
	<!---  4. update requisition lines --->
	<cfquery name="Update" 
	     datasource="AppsPurchase" 
	     username="#SESSION.login#" 
	     password="#SESSION.dbpw#">
	     UPDATE RequisitionLine
		 SET    JobNo        = '#jobno#',   
		        ActionStatus = '2q'  <!--- 22/2/2011 : was '2k' --->
		 WHERE  RequisitionNo = #preservesinglequotes(req)# 
		 AND    (JobNo = '' or JobNo is NULL)
 	</cfquery>
		
	<!--- ------------------------- --->
	<!--- preload potential vendors	--->
	<!--- ------------------------- --->
	
	<cfif url.mode eq "SSA">
	
		<!---  4. update requisition lines --->
		<cfquery name="get" 
		     datasource="AppsPurchase" 
		     username="#SESSION.login#" 
		     password="#SESSION.dbpw#">
		     SELECT * FROM RequisitionLine
			 WHERE  RequisitionNo = #preservesinglequotes(req)# 		
 		</cfquery>
		
		<cfif get.personno neq "">
			
				<cfquery name="Insert" 
				datasource="AppsPurchase" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				INSERT INTO JobPerson 
					 (JobNo,PersonClass,PersonNo,OfficerUserId, OfficerLastName, OfficerFirstName)
				VALUES 
				     ('#JobNo#','employee','#get.PersonNo#','#SESSION.acc#','#SESSION.last#','#SESSION.first#')
				</cfquery>	
				
		</cfif>		
					
	<cfelse>
	
		<cfif Parameter.EnableVendorRoster eq "1">
		
			<!--- 4. add vendor lines --->
			
			<cfquery name="Vendor" 
				  datasource="AppsPurchase" 
				  username="#SESSION.login#" 
				  password="#SESSION.dbpw#">
				  
					SELECT  O.OrgUnit, 
					        O.OrgUnitCode, 
							O.OrgUnitName
					FROM    RequisitionLine R INNER JOIN
				            ItemMasterVendor I ON R.ItemMaster = I.Code INNER JOIN
				            Organization.dbo.Organization O ON I.OrgUnitVendor = O.OrgUnit
					WHERE   RequisitionNo = #preservesinglequotes(req)# 
					AND     O.OrgUnit NOT IN (SELECT OrgUnitVendor 
					                          FROM   JobVendor 
											  WHERE  JobNo = '#JobNo#')
					AND     I.Operational = 1						  
					
											  
			</cfquery>	
			
			<cfloop query="Vendor">
			
				<cfquery name="Insert" 
				datasource="AppsPurchase" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				INSERT INTO JobVendor 
					    (JobNo,OrgUnitVendor,OfficerUserId, OfficerLastName, OfficerFirstName)
				VALUES  ('#JobNo#','#OrgUnit#','#SESSION.acc#','#SESSION.last#','#SESSION.first#')
				</cfquery>		
							
				<cfquery name="Insert" 
				     datasource="AppsPurchase" 
				     username="#SESSION.login#" 
				     password="#SESSION.dbpw#">
					 INSERT INTO RequisitionLineQuote 
					 	(RequisitionNo, 
					   	   JobNo, 
						   OrgUnitVendor, 
						   VendorItemDescription, 
						   TaxIncluded,
						   TaxExemption,
						   QuoteTax, 
						   QuotationQuantity, 
						   QuotationUoM, 
						   Currency,
						   OfficerUserId,
						   OfficerLastName,
						   OfficerFirstName)
					 SELECT RequisitionNo, 
					        '#JobNo#', 
							'#OrgUnit#', 
							RequestDescription, 
							'#Parameter.DefaultTaxIncluded#',
							'#Parameter.TaxExemption#',
							'#Parameter.TaxDefault#', 
							RequestQuantity, 
							QuantityUoM, 
							'#APPLICATION.BaseCurrency#',
							'#SESSION.acc#',
							'#SESSION.last#',
							'#SESSION.first#'
					 FROM   RequisitionLine
					 WHERE  RequisitionNo = #preservesinglequotes(req)#
				</cfquery>
			
			</cfloop>
			
	  </cfif>		
	
	</cfif>

</cfloop>

<!---  5. create entries --->

<cfif Form.SelectMe eq "Exist">
		
<!--- 1. define entries in JobVendor --->

	<cfquery name="Vendor" 
	     datasource="AppsPurchase" 
	     username="#SESSION.login#" 
	     password="#SESSION.dbpw#">
	     SELECT *
		 FROM   JobVendor
		 WHERE  JobNo = '#JobNo#'
	</cfquery>
	
	<!--- 2. loop insert requisitionline in linequote for each vendor --->
	
	<cfloop query="Vendor">
	
		<cfquery name="Insert" 
		     datasource="AppsPurchase" 
		     username="#SESSION.login#" 
		     password="#SESSION.dbpw#">
			 INSERT INTO RequisitionLineQuote
			 (RequisitionNo, 
			  JobNo, 
			  OrgUnitVendor, 
			  VendorItemDescription, 
			  QuoteTax, 
			  QuotationQuantity, 
			  QuotationUoM, 
			  <!--- QuotationMultiplier, --->
			  Currency)
			 SELECT S.RequisitionNo, 
			        '#JobNo#', 
					'#OrgUnitVendor#', 
					S.RequestDescription, 
					'#Parameter.TaxDefault#', 
					S.RequestQuantity, 
					S.QuantityUoM, 
					<!--- WarehouseMultiplier, --->
					'#APPLICATION.BaseCurrency#'
			 FROM   RequisitionLINE S
			 WHERE  JobNo = '#JobNo#'
			 AND    RequisitionNo NOT IN (SELECT RequisitionNo 
			                              FROM   RequisitionLineQuote 
									      WHERE  OrgUnitVendor = '#OrgUnitVendor#'
										  AND    RequisitionNo = S.RequisitionNo)
		</cfquery>
		
	</cfloop>

</cfif>

</cftransaction>	

<cf_workflowenabled 
		     mission="#url.mission#" 
			 entitycode="ProcJob">			 

<cfif workflowenabled eq "1" and Form.JobCategory neq ""> 
		
  	   <cfset link = "Procurement/Application/Quote/QuotationView/JobViewGeneral.cfm?Period=#URL.Period#&ID=JOB&ID1=#JobNo#&Role=ProcBuyer">
			   			   				
	   <cf_ActionListing 
	    EntityCode       = "ProcJob"
		EntityClass      = "#Form.OrderClass#"
		EnforceWorkflow  = "No"  <!--- do not warn if the class does not have a published flow --->
		EntityGroup      = "#Form.JobCategory#"
		EntityStatus     = ""		
		Mission          = "#URL.Mission#"
		OrgUnit          = ""
		ObjectReference  = "#Form.Description#"
		ObjectReference2 = "#Form.CaseNo#"
		ObjectKey1       = "#jobno#"				
	  	ObjectURL        = "#link#"
		Show             = "No"
		ActionMail       = "Yes"
		DocumentStatus   = "0">
				
<cfelse>
	
	<!--- disabled auto 
			  		  
	<cfquery name="Update" 
	   datasource="AppsPurchase" 
	   username="#SESSION.login#" 
	   password="#SESSION.dbpw#">
	   UPDATE Job 
	   SET ActionStatus = '1'
	   WHERE JobNo = '#jobno#'
	</cfquery>
	
	--->
  
</cfif>		

<!--- verify if screen can be closed --->

<cfquery name="Parameter" 
  datasource="AppsPurchase" 
  username="#SESSION.login#" 
  password="#SESSION.dbpw#">
      SELECT *
      FROM   Ref_ParameterMission
	  WHERE  Mission = '#URL.Mission#'
</cfquery>
	
<cfquery name="Requisition" 
	datasource="AppsPurchase" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT    L.*, I.Description, Org.Mission, Org.MandateNo, Org.HierarchyCode, Org.OrgUnitName
	FROM      RequisitionLine L, ItemMaster I, Organization.dbo.Organization Org
	WHERE     L.ActionStatus = '2k' 
	AND       L.OrgUnit = Org.OrgUnit
	AND       (L.JobNo is NULL OR L.JobNo = '')
	
	<cfif getAdministrator(url.mission) eq "1">
	
		<!--- no filtering --->
	
	<cfelse>
	
		AND       (
					L.RequisitionNo IN (SELECT RequisitionNo
		                            	 FROM  RequisitionLineActor  
										WHERE ActorUserId = '#SESSION.acc#')
									
					 OR	 L.Mission IN (SELECT Mission 
					                     FROM Organization.dbo.OrganizationAuthorization					
									    WHERE Role = 'ProcApprover'
								          AND UserAccount = '#SESSION.acc#')
				  )					
								
	</cfif>		
	
	<!---
		
	<cfif url.mode eq "Position">
	
	    <!--- --------------------------------- --->
	    <!--- select only position requisitions --->
		<!--- --------------------------------- --->
		
		AND        L.ItemMaster IN (SELECT I.Code 
	                                FROM   ItemMaster I, Ref_EntryClass R
								    WHERE  I.EntryClass = R.Code
								    AND    (
								       
									        (R.CustomDialog = 'Contract' AND I.CustomForm = 1)
									   
									   OR									   
									      I.CustomDialogOverwrite = 'Contract'								  										  
									   )	
								   )	   			
		
		
	<cfelse>
	
	    <!--- select others --->
	
		AND       (L.PersonNo is NULL or L.PersonNo = '') 
		
		AND        L.ItemMaster NOT IN (SELECT I.Code 
	                                    FROM   ItemMaster I, Ref_EntryClass R
								        WHERE  I.EntryClass = R.Code
								        AND    (
								       
									        (R.CustomDialog = 'Contract' AND I.CustomForm = 1)									   
									        OR									   
									        I.CustomDialogOverwrite = 'Contract'								  										  
									        )	
								   )	   
		
		
	</cfif>
	
	--->
						
	AND       I.Code      = L.ItemMaster   	
	AND       L.Period    = '#URL.Period#'	
	AND       Org.Mission = '#URL.Mission#'					
	ORDER BY  Org.Mission, 
	          Org.MandateNo, 
			  Org.HierarchyCode, 
			  L.Created DESC							
	</cfquery>
		
	
	<cfif Requisition.recordcount eq "0">
	
		<cfoutput>
		<script language="JavaScript">
			
		  try {  		    
			  parent.opener.right.location = "#SESSION.root#/Procurement/Application/Quote/QuotationView/JobViewGeneral.cfm?header=no&Period=#url.period#&ID=JOB&ID1=#JobNo#&Role=ProcBuyer" 
			  } 
			  catch(e) {}		
		      parent.window.close()		
		   
		</script>
		</cfoutput>
	
	<cfelse>
	
		<cfoutput>
		
		<script>	
		
			  try {  			
			  parent.opener.right.location = "#SESSION.root#/Procurement/Application/Quote/QuotationView/JobViewGeneral.cfm?header=no&Period=#url.period#&ID=JOB&ID1=#JobNo#&Role=ProcBuyer" 
			  }
			  catch(e) {}				 
			  document.getElementById('menu1').click()			    			 			 
			  ColdFusion.navigate('SelectPending.cfm?mission=#url.mission#&period=#url.period#','contentbox1')	  
		</script>	
		
		</cfoutput>
	
	</cfif>


</body>
</html>

