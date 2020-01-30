
<cf_screentop html="No" jquery="Yes">

<cfparam name="url.recordstatus" default="1">
  
<cfquery name="Parameter" 
datasource="AppsEPAS" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT * 
    FROM   Parameter
</cfquery>

<cfoutput>

<cfquery name="Contract" 
     datasource="AppsEPAS" 
     username="#SESSION.login#" 
     password="#SESSION.dbpw#">
     SELECT *
	 FROM   Contract
	 WHERE  ContractId = '#Form.ContractId#'
</cfquery>

<cfif Contract.recordcount eq "1">
	
	<cftransaction action="begin"> 
	
		<!--- header --->	
				 	
		<cfquery name="Check" 
	     datasource="AppsEPAS" 
	     username="#SESSION.login#" 
	     password="#SESSION.dbpw#">
	     SELECT  *
		 FROM    ContractActivity
		 WHERE   ContractId    = '#Form.ContractId#'
		 AND     RecordStatus  = '#url.recordstatus#'
		 AND     ActivityOrder = '0'
		</cfquery>
			 	
		<cfif Check.recordcount eq "0">
	   	 
			   <cfquery name="InsertActivity" 
			     datasource="AppsEPAS" 
			     username="#SESSION.login#" 
			     password="#SESSION.dbpw#">
			     INSERT INTO ContractActivity
				         ( ContractId,
						   ActivityDescription,
						   Reference,
						   RecordStatus,
						   OfficerUserId,
						   OfficerLastName,
						   OfficerFirstName)
			      VALUES ('#Form.ContractId#',
					      '#Form.Description#',
					      '#Form.Reference#',
						  '#url.recordstatus#',
					      '#SESSION.acc#',
			    	      '#SESSION.last#',		  
				  	      '#SESSION.first#')
				</cfquery>
			
				<cfquery name="LastNo" 
			     datasource="AppsEPAS" 
			     username="#SESSION.login#" 
			     password="#SESSION.dbpw#">
					 SELECT   TOP 1 ActivityId
					 FROM     ContractActivity
					 WHERE    ContractId = '#Form.ContractId#'
					 AND      RecordStatus  = '#url.recordstatus#'
					 ORDER BY Created DESC
				 </cfquery>
				 
				 <cfset NoAct = LastNo.ActivityId>
		
		<cfelse>
		
				<cfquery name="UpdateActivity" 
			     datasource="AppsEPAS" 
			     username="#SESSION.login#" 
			     password="#SESSION.dbpw#">
				 	UPDATE ContractActivity
					 SET    ActivityDescription = '#Form.Description#', 
					        Reference           = '#Form.Reference#'
					 WHERE  ContractId          = '#Form.ContractId#'
					 AND    RecordStatus        = '#url.recordstatus#'
					 AND    ActivityOrder       = '0'
				</cfquery>
						
				<cfquery name="Delete" 
				   datasource="AppsEPAS" 
				   username="#SESSION.login#" 
				   password="#SESSION.dbpw#">
					  DELETE FROM ContractActivityOutput  
				   	  WHERE  ContractId = '#Form.ContractId#'
					  AND    ActivityId IN (SELECT ActivityId 
					                        FROM   ContractActivity 
											WHERE  Contractid = '#Form.ContractId#' 
											AND    RecordStatus = '#url.recordstatus#')
					   
				</cfquery>	
	
				<cfset NoAct = Check.ActivityId>	
		
		</cfif>
		
	<cfquery name="Class" 
	datasource="AppsEPAS" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT * 
		FROM Ref_OutputClass
	</cfquery>
	
	<cfquery name="Parameter" 
	datasource="AppsEPAS" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT *
	    FROM Parameter
	</cfquery>	 
	
	<cfquery name="Delete" 
	datasource="appsePas" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		DELETE FROM   ContractTraining
		WHERE  ContractId   = '#Form.ContractId#' 
		  AND  ActivityId is not NULL 
	</cfquery>	
	
	<cfset count = Contract.enableTasks - 1>
	
	<!--- Tasks --->
	
	<cfloop index="Rec" from="1" to="#count#">
	  
	  <cfset Description  = Evaluate("FORM.Description_" & #Rec#)>
	  <cfset Reference    = Evaluate("FORM.Reference_" & #Rec#)>
	  <cfset PriorityCode = Evaluate("FORM.PriorityCode_" & #Rec#)>
	       
	  <cfif Description neq "">
	  
	      <cfif PriorityCode eq "">
	   
				<cf_interface cde="OutputError">
				
				<script>parent.Prosis.busy('no')</script>
				<cf_message message="<cfoutput>#name#</cfoutput>"  Return="back">				
				
				<cfabort>
			  
		  </cfif>		  
		 	 	  
		    <cfquery name="Check" 
		     datasource="AppsEPAS" 
		     username="#SESSION.login#" 
		     password="#SESSION.dbpw#">
			     SELECT *
				 FROM   ContractActivity
				 WHERE  ContractId    = '#Form.ContractId#'
				 AND    ActivityOrder = '#Rec#'
				 AND    RecordStatus  = '#url.recordstatus#'
			</cfquery>
				 	
			<cfif Check.recordcount eq "0">
		   	 
				   <cfquery name="InsertActivity" 
				     datasource="AppsEPAS" 
				     username="#SESSION.login#" 
				     password="#SESSION.dbpw#">
				     INSERT INTO ContractActivity
					         (ContractId,
							 ActivityOrder,
							 ActivityDescription,
							 ActivityIdParent,
							 Reference,
							 PriorityCode,
							 RecordStatus,
							 OfficerUserId,
							 OfficerLastName,
							 OfficerFirstName)
				      VALUES (
					          '#Form.ContractId#',
							  '#Rec#',
							  '#Description#',
							  '#Noact#',
							  '#Reference#',
							  '#PriorityCode#',
							  '#url.recordstatus#',
							  '#SESSION.acc#',
					    	  '#SESSION.last#',		  
						  	  '#SESSION.first#')
					</cfquery>
				
				   <cfquery name="Output" 
				     datasource="AppsEPAS" 
				     username="#SESSION.login#" 
				     password="#SESSION.dbpw#">
					 SELECT   TOP 1 ActivityId
					 FROM     ContractActivity
					 WHERE    ContractId       = '#Form.ContractId#'
					 AND      ActivityIdParent = '#NoAct#'
					 AND      RecordStatus  = '#url.recordstatus#'
					 ORDER BY Created DESC
				   </cfquery>
				   
				   <cfset outid = Output.ActivityId>
			
		   <cfelse>
			
				   <cfset outid = Check.ActivityId>	
				   
				   <cfquery name="UpdateActivity" 
				     datasource="AppsEPAS" 
				     username="#SESSION.login#" 
				     password="#SESSION.dbpw#">
						 UPDATE ContractActivity
						 SET    ActivityDescription = '#Description#', 
						        Reference           = '#Reference#',
							    PriorityCode        = '#PriorityCode#',
								Operational         = 1
						 WHERE  ContractId          = '#Form.ContractId#'
						 AND    ActivityOrder       = '#Rec#'
						 AND    RecordStatus        = '#url.recordstatus#'
				   </cfquery>
			
		   </cfif>
		   
		   <cfif Parameter.hideTraining eq "0">
		   
			    <cfparam name="FORM.Training_#Rec#" default="0">
			    <cfset Training    = Evaluate("FORM.Training_" & #Rec#)>
			 		     
			    <cfif Training eq "1">
				
					<cfparam name="FORM.TrainingReason_#Rec#" default="">
				    <cfparam name="FORM.TrainingDescription_#Rec#" default="">
				    <cfparam name="FORM.TrainingTarget_#Rec#" default="01/01/2000">
				    <cfparam name="FORM.TrainingReference_#Rec#" default="">
				
				   	<cfset Reason      = Evaluate("FORM.TrainingReason_" & #Rec#)>
			   		<cfset Descrip     = Evaluate("FORM.TrainingDescription_" & #Rec#)>
			    	<cfset Target      = Evaluate("FORM.TrainingTarget_" & #Rec#)>
			    	<cfset Reference   = Evaluate("FORM.TrainingReference_" & #Rec#)>
			    	<CF_DateConvert Value="#Target#">
					<cfset Target = #dateValue#>
				 	 
				    	<cfquery name="Insert" 
						  datasource="appsEPAS" 
						  username="#SESSION.login#" 
						  password="#SESSION.dbpw#">
						  INSERT INTO  ContractTraining
								      (ContractId, 
									   ActivityId,
									   TrainingReason, 
					  		           TrainingDescription,
							           TrainingTarget,
							           TrainingReference,
									   OfficerUserId,
									   OfficerLastName,
									   OfficerFirstName)
						  VALUES ('#Form.ContractId#',
						          '#outid#',
								  '#Reason#', 
						          '#Descrip#',
							       #Target#,
							      '#Reference#',
								  '#SESSION.acc#',
								  '#SESSION.last#',
								  '#SESSION.first#')
						</cfquery>							
							
				</cfif>
			
			</cfif> 
				
		   <cfset entry = "0">
		 	           
		   <cfloop query="Class">
		      
			   <cfset Output = Evaluate("FORM.Output_" & #Rec# & "_" & #code#)>
			   
			   <cfif Output neq "">
			   
			       <cfset entry = "1">
			   
				   <cftry>
				        	     
					   <cfquery name="Insert" 
					   datasource="AppsEPAS" 
					   username="#SESSION.login#" 
					   password="#SESSION.dbpw#">
					   INSERT INTO ContractActivityOutput  
					         (ContractId, 
							  ActivityId, 
							  OutputClass,
							  OutputDescription,
							  OfficerUserId, 
							  OfficerLastName,
							  OfficerFirstName)
						VALUES ('#Form.ContractId#', 
						       '#outid#',
							   '#Code#',
							   '#Output#', 
							   '#SESSION.acc#', 
							   '#SESSION.last#', 
							   '#SESSION.first#')
					  </cfquery>	
					  		  
					  <cfcatch></cfcatch>
				  
				  </cftry>
			  
			  </cfif>
			    
		  </cfloop>	
		  	  	  
		  <cfif entry eq "0" 
		     and Description neq "" 
			 and Parameter.EnforceOutput eq "1">		   		
					
			<cf_interface cde="OutputError">		
			<script>
				parent.Prosis.busy('no')
			</script>	
			<cf_message message="#Name#"  Return="back">
			
			<cfabort>	
						  
		  </cfif>
		  
	   </cfif>	  
	     
	</cfloop>
	
	</cftransaction> 
			
<cfelse>

	  <cf_message message="Problem, ePas could not be located. Please contact your administrator.">		 
	  <script>
		parent.Prosis.busy('no')
   	  </script>
	<cfabort>		

</cfif>


<cf_Navigation
	 Alias         = "AppsEPAS"
	 Object        = "Contract"
	 Group         = "Contract"
	 Section       = "#URL.Section#"
	 Id            = "#Form.ContractId#"
	 NextEnable    = "1"
	 NextMode      = "1"
	 OpenDirect    = "1">
	 		
</cfoutput>	   
