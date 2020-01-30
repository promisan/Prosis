
<!--- submit : add or edit and then check for wf and action --->

<cfparam name="Form.ActionCode" default="">
<cfparam name="url.action"      default="edit">
<cfparam name="url.wf"          default="0">

<cfquery name="get" 
datasource="AppsEmployee" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
    FROM   PersonAction
	WHERE  PersonNo       = '#form.PersonNo#'
	AND    PersonActionId = '#form.PersonActionId#' 
</cfquery>

<cfif url.action eq "delete"> 
		
	<cfquery name="clear" 
	datasource="AppsEmployee" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">		
	    DELETE FROM PersonAction
		WHERE  PersonNo       = '#form.PersonNo#'
		AND    PersonActionId = '#form.PersonActionId#'
	</cfquery>
	
	<!--- this also removes the workflow --->
	
	<!--- remove the action --->
		
	<cfquery name="ActionSource" 
	   datasource="AppsOrganization" 
	   username="#SESSION.login#" 
	   password="#SESSION.dbpw#">
    	  SELECT * 		  
		  FROM   Employee.dbo.EmployeeActionSource
		  WHERE  ActionDocumentNo IN (SELECT ActionDocumentNo 
		                          FROM   Employee.dbo.EmployeeAction 
								  WHERE  ActionSourceId = '#Form.PersonActionId#')		
	</cfquery>	
	
	<cfset PANo = ActionSource.ActionDocumentNo>
	
	<cfquery name="Delete" 
    datasource="AppsOrganization" 
    username="#SESSION.login#" 
    password="#SESSION.dbpw#">
    	 DELETE Employee.dbo.EmployeeAction 				
		 WHERE  ActionDocumentNo = '#PANo#'				 
	</cfquery>	
				
<cfelseif get.recordcount eq "0">

    <cftransaction>

	<!--- add record --->
	
	<cfset dateValue = "">
	<CF_DateConvert Value="#Form.DateEffective#">
	<cfset STR = dateValue>
	
	<cfset dateValue = "">
	<cfif Form.DateExpiration neq ''>
	    <CF_DateConvert Value="#Form.DateExpiration#">
	    <cfset END = dateValue>
	<cfelse>
	    <cfset END = 'NULL'>
	</cfif>	
	
	<!--- record the new transaction contract entry --->												 
	<cfquery name="InsertContract" 
     datasource="AppsEmployee" 
     username="#SESSION.login#" 
     password="#SESSION.dbpw#">
	     INSERT INTO PersonAction 
			         (PersonActionId,
					 ActionCode,
					 Mission,
					 PersonNo,							 
					 DateEffective,
					 DateExpiration,
					 EntityClass,							
					 Remarks,
					 ActionStatus,
					 OfficerUserId,
					 OfficerLastName,
					 OfficerFirstName)
		  VALUES    ('#Form.PersonActionId#',
				     '#Form.ActionCode#', 
				     '#Form.Mission#',
				     '#Form.PersonNo#',							
			         #STR#,
					 #END#,		
					 '#Form.EntityClass#',					 
					 '#Remarks#',
					 '0',
					 '#SESSION.acc#',
			    	 '#SESSION.last#',		  
				  	 '#SESSION.first#')
					 
	  </cfquery>

		
	 <!--- ---------------------------------------------- --->
	 <!--- action record -------------------------------- --->
	 <!--- ---------------------------------------------- --->
									 			   												
	 <cfinvoke component   = "Service.Process.Employee.PersonnelAction"  
			   method             = "ActionDocument" 
			   PersonNo           = "#Form.PersonNo#"
			   Mission            = "#Form.Mission#"
			   ActionCode         = "#form.actionCode#"			   
			   ActionLink         = "Staffing/Application/Employee/HRAction/ActionEdit.cfm?id=#form.personNo#&id1="
			   ActionSourceId     = "#Form.PersonActionId#"						   	 		 
			   ActionStatus       = "1">				
	
	<!--- --------------- --->
	<!--- create workflow --->
	<!--- --------------- --->
	
	<cf_assignid>
						
	<cfquery name="CheckMission" 
		 datasource="AppsEmployee"
		 username="#SESSION.login#" 
		 password="#SESSION.dbpw#">
			 SELECT   *
			 FROM     Organization.dbo.Ref_EntityMission 
			 WHERE    EntityCode     = 'HRAction'  
			 AND      Mission        = '#Form.Mission#' 
	</cfquery>
			
	<cfquery name="EntityClass" 
	   datasource="AppsEmployee" 
	   username="#SESSION.login#" 
	   password="#SESSION.dbpw#">
	     SELECT EntityClass
		 FROM   Organization.dbo.Ref_EntityClassPublish
		 WHERE  EntityCode   = 'HRAction'
		 AND    EntityClass  = '#Form.EntityClass#'		  						 
	</cfquery>
	
	</cftransaction>
							  
	<cfif CheckMission.WorkflowEnabled eq "0" 
	      or CheckMission.recordcount eq "0" 
		  or EntityClass.recordcount eq "0">
	        
			<!--- no workflow or no workflowendable,
			    clear the transaction immediately to status = 1 --->
									
			<cfif url.wf eq "0">
										
				<cfquery name="Update" 
				   datasource="AppsEmployee" 
				   username="#SESSION.login#" 
				   password="#SESSION.dbpw#">
				   	  UPDATE PersonAction
					  SET    ActionStatus    = '1'
					  WHERE  PersonNo        = '#FORM.PersonNo#' 
				      AND    PersonActionId  = '#Form.PersonActionId#' 	 
				</cfquery>
				
									
			</cfif>
			
  	  <cfelse>
	  
	      <cfset url.ajaxid = Form.PersonActionId>
		  <cfset url.show = "No">
		  <cfinclude template="HRActionWorkflow.cfm">
	     			
	  </cfif>			


<cfelse>

	<cfset dateValue = "">
	<CF_DateConvert Value="#Form.DateEffective#">
	<cfset STR = dateValue>
	
	<cfset dateValue = "">
	<cfif Form.DateExpiration neq ''>
	    <CF_DateConvert Value="#Form.DateExpiration#">
	    <cfset END = dateValue>
	<cfelse>
	    <cfset END = 'NULL'>
	</cfif>	
	
	<cfquery name="UpdateAction" 
	   datasource="AppsEmployee" 
	   username="#SESSION.login#" 
	   password="#SESSION.dbpw#">				   
	   UPDATE PersonAction 
	   SET    DateEffective          = #STR#,
			  DateExpiration         = #END#,						
			  ActionCode             = '#Form.ActionCode#',
			  EntityClass            = '#Form.EntityClass#',
			  Mission                = '#Form.Mission#', 			 
			  Remarks                = '#Remarks#'
	   WHERE  PersonNo        = '#Form.PersonNo#' 
	   AND    PersonActionId  = '#Form.PersonActionId#' 
	</cfquery>

</cfif>		

<cfoutput>
<cfset url.id = form.Personno>
<cfinclude template="HRAction.cfm">
</cfoutput>

