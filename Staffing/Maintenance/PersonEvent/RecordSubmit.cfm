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

<cfparam name="Form.ActionPosition" default="0">
<cfparam name="Form.ActionPeriod"   default="0">
<cfparam name="Form.EnablePortal"   default="0">
<cfparam name="Form.Missions"       default="">
<cfparam name="Form.CodeOld"        default="">
<cfparam name="ActionInstruction"   default="">

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
								 ActionInstruction,
								 ActionPosition,
								 ActionPeriod,		
								 EnablePortal,						
								 EntityClass,
								 OfficerUserId,
								 OfficerLastName,
								 OfficerFirstName)
						  VALUES ('#Form.Code#',
						          '#Form.Description#',
								  '#Form.ActionInstruction#',
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
		SET   Code              = '#Form.Code#',
		      Description       = '#Form.Description#',
			  ActionInstruction = '#Form.ActionInstruction#',
		      EntityClass	    = '#Form.entityClass#',
		      EnablePortal      = '#Form.EnablePortal#',
		      ActionPosition    = '#Form.ActionPosition#',
		      ActionPeriod      = '#Form.ActionPeriod#'
		WHERE Code  = '#Form.CodeOld#'
	</cfquery>	
	
	<!--- we remove any records no longer selected --->
	
	<cfset mis = "">
	
	<cfloop list="#Form.Missions#" index="itm">
	    <cfif mis eq "">
			<cfset mis = "'#itm#'">
		<cfelse>
			<cfset mis = "#mis#,'#itm#'">
		</cfif>	
	</cfloop>

	<cfquery name="MissionCheck" 
	datasource="appsEmployee" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    DELETE  Ref_PersonEventMission
		WHERE   PersonEvent = '#Form.CodeOld#'
		<cfif mis neq "">
		AND     Mission NOT IN (#preserveSingleQuotes(mis)#)
		</cfif>
	</cfquery>	
		
	<cfloop list="#Form.Missions#" index="itm">
	
		<cfquery name="get" 
		datasource="appsEmployee" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		    SELECT   *
			FROM     Ref_PersonEventMission
			WHERE    PersonEvent = '#Form.CodeOld#'
			AND      Mission = '#itm#'			
		</cfquery>		
		
		<cfif get.recordcount eq "0">
				
			<cfquery name="qInsert" datasource = "AppsEmployee">
				INSERT INTO Ref_PersonEventMission
				       ( PersonEvent, 
					     Mission, 
						 OfficerLastName, 
						 OfficerFirstName, 
						 OfficerUserId )
				VALUES ( '#Form.CodeOld#',
				         '#itm#',
						 '#SESSION.last#',
						 '#SESSION.first#',
						 '#SESSION.acc#' )
			</cfquery>	
		
		</cfif>
	
	</cfloop>	
	
</cfif>	

<cfif ParameterExists(Form.Delete)> 

<cfquery name="CountRec" 
      datasource="AppsEmployee" 
      username="#SESSION.login#" 
      password="#SESSION.dbpw#">
      SELECT *
      FROM  PersonEvent
      WHERE EventCode = '#Form.CodeOld#' 
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

<cfoutput>

<cfif Form.CodeOld neq "" and not ParameterExists(Form.Delete)>
	
	<script language="JavaScript">
	   
	    window.close()	 
		opener.applyfilter('1','','#Form.CodeOld#')
		         
	</script>  

<cfelse>

	<script language="JavaScript">

	   window.close()	 
   	   opener.applyfilter('1','','content')
	
	</script>

</cfif>
</cfoutput>
