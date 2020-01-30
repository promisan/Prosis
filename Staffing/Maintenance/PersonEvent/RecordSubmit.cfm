
<link rel="stylesheet" type="text/css" href="<cfoutput>#SESSION.root#/#client.style#</cfoutput>"> 

<cfparam name="Form.ActionPosition" default="0">
<cfparam name="Form.ActionPeriod"   default="0">
<cfparam name="Form.EnablePortal"   default="0">
<cfparam name="Form.Missions"       default="">

<cfif ParameterExists(Form.Insert)> 

			<cfquery name="Verify" 
			datasource="AppsEmployee" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				SELECT *
				FROM   Ref_PersonEvent
				WHERE  Code  = '#Form.Code#' 
			</cfquery>
			
			   <cfif Verify.recordCount is 1>
			   
					   <script language="JavaScript">			   
					     alert("a record with this code has been registered already!")			     
					   </script>  
			  
			   <cfelse>
			   
						<CF_RegisterAction 
							SystemFunctionId="0999" 
							ActionClass="Person Event" 
							ActionType="Enter" 
							ActionReference="#Form.Code#" 
							ActionScript="">   
						
						<cfquery name="Insert" 
						datasource="AppsEmployee" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">
						INSERT INTO Ref_PersonEvent
						         (Code,
								 Description,
								 ActionPosition,
								 ActionPeriod,		
								 EnablePortal,						
								 EntityClass,
								 OfficerUserId,
								 OfficerLastName,
								 OfficerFirstName)
						  VALUES ('#Form.Code#',
						          '#Form.Description#',
						          '#Form.ActionPosition#', 
						          '#Form.ActionPeriod#',	
								  '#Form.EnablePortal#',					         
								  '#Form.entityClass#',
								  '#SESSION.acc#',
						    	  '#SESSION.last#',		  
							  	  '#SESSION.first#')
						  </cfquery>
								  
						  <cfquery name="MissionCheck" 
							datasource="appsEmployee" 
							username="#SESSION.login#" 
							password="#SESSION.dbpw#">
							    DELETE  Ref_PersonEventMission
								WHERE   PersonEvent = '#Form.Code#'
						  </cfquery>	
								
						  <cfloop list="#Form.Missions#"  index="Element">
								
								<cfquery name="qInsert" datasource = "AppsEmployee">
									INSERT INTO Ref_PersonEventMission
										(PersonEvent, Mission, OfficerLastName, OfficerFirstName, OfficerUserId)
									VALUES ('#Form.Code#','#Element#','#SESSION.last#','#SESSION.first#','#SESSION.acc#')
								</cfquery>							
							
						  </cfloop>									  								  
					  
			    </cfif>		  
           
</cfif>

<cfif ParameterExists(Form.Update)>

<CF_RegisterAction 
SystemFunctionId="0999" 
ActionClass="Person Event" 
ActionType="Update" 
ActionReference="#Form.CodeOld#" 
ActionScript="">   

<cfquery name="Update" 
datasource="AppsEmployee" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	UPDATE Ref_PersonEvent
	SET   Code            = '#Form.Code#',
	      Description     = '#Form.Description#',
	      EntityClass	  = '#Form.entityClass#',
	      EnablePortal    = '#Form.EnablePortal#',
	      ActionPosition  = '#Form.ActionPosition#',
	      ActionPeriod    = '#Form.ActionPeriod#'
	WHERE Code  = '#Form.CodeOld#'
</cfquery>	

	<cfquery name="MissionCheck" 
	datasource="appsEmployee" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    DELETE  Ref_PersonEventMission
		WHERE PersonEvent = '#Form.CodeOld#'
	</cfquery>	
		
	<cfloop list="#Form.Missions#"  index="Element">
		
		<cfquery name="qInsert" datasource = "AppsEmployee">
			INSERT INTO Ref_PersonEventMission
			(PersonEvent, Mission, OfficerLastName, OfficerFirstName, OfficerUserId)
			VALUES ('#Form.CodeOld#','#Element#','#SESSION.last#','#SESSION.first#','#SESSION.acc#')
		</cfquery>	
	
	</cfloop>	
	
</cfif>	

<cfif ParameterExists(Form.Delete)> 

<cfquery name="CountRec" 
      datasource="AppsEmployee" 
      username="#SESSION.login#" 
      password="#SESSION.dbpw#">
      SELECT *
      FROM  PersonEvent
      WHERE PersonEvent = '#Form.CodeOld#' 
    </cfquery>

    <cfif CountRec.recordCount gt 0>
		 
     <script language="JavaScript">
    
	   alert("Event Code is in use. Operation aborted.")
     
     </script>  
	 
    <cfelse>
	
	<CF_RegisterAction 
		SystemFunctionId="0999" 
		ActionClass="Person Event" 
		ActionType="Remove" 
		ActionReference="#Form.CodeOld#" 
		ActionScript="">   

	<cfquery name="MissionCheck" 
	datasource="appsEmployee" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    DELETE Ref_PersonEventMission
		WHERE  PersonEvent = '#Form.CodeOld#'
	</cfquery>	
		
	<cfquery name="Delete" 
	datasource="AppsEmployee" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		DELETE FROM Ref_PersonEvent
		WHERE Code = '#FORM.CodeOld#'
    </cfquery>
	
	</cfif>
		
</cfif>	

<script language="JavaScript">
   
     window.close()
	 opener.location.reload()
        
</script>  
