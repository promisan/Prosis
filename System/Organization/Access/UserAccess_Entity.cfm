
<cfquery name="Role" 
datasource="AppsOrganization" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT *
	FROM    Ref_AuthorizationRole
	WHERE   Role = '#URL.ID#' 
</cfquery>

<script language="JavaScript">

function more(bx) {
  	
	icM  = document.getElementById(bx+"Min")
    icE  = document.getElementById(bx+"Exp")
	ic   = document.getElementsByName(bx)
					 		 
	if (icM.className == "hide") {
	     cl = "" 
		 icM.className = "regular"
		 icE.className = "hide"
		 } else {
		 cl = "hide"
		 icE.className = "regular"
		 icM.className = "hide"
		 }
	
	cnt = 0
	while (ic[cnt]) {
		 ic[cnt].className = cl
		 cnt++
		 }		 		
   }
  
</script>  

<cfparam name="show"        default="1">
<cfparam name="tree"        default="1">
<cfparam name="url.mode"    default="direct">
<cfparam name="URL.access"  default="">
<cfparam name="URL.ms"      default="">
<cfparam name="URL.group"   default="">

<cfif show eq "1">
  
	 <cfif tree neq "1"> 
	 	 		
	   <!--- create access table --->
	   
	   <CF_DropTable dbName="AppsQuery"  tblName="#SESSION.acc#TreeAccess">
	  
	   <cfquery name="AccessList" 
			datasource="AppsOrganization" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#"> 
	       SELECT  ClassParameter, 
		           GroupParameter, 
				   Max(AccessLevel) as AccessLevel, 
				   max(A.RecordStatus) as RecordStatus,
				   count(*) as Number
		   INTO    userQuery.dbo.#SESSION.acc#TreeAccess
		   FROM    OrganizationAuthorization A 
		   WHERE   A.AccessLevel < '8'
			AND    ((A.OrgUnit     = '#URL.ID2#') 
			   OR (A.OrgUnit is NULL and A.Mission = '#URL.Mission#')
			   OR (A.OrgUnit is NULL and A.Mission is NULL))
			AND    A.UserAccount = '#URL.ACC#' 
			AND    A.Role = '#URL.ID#'
			GROUP BY ClassParameter, GroupParameter  
		</cfquery>
		
	 <cfelseif url.mode eq "query">
		 
	    <CF_DropTable dbName="AppsQuery"  tblName="#SESSION.acc#TreeAccess">
	  
	   <cfquery name="AccessList" 
			datasource="AppsOrganization" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#"> 
	       SELECT  ClassParameter, 
		           GroupParameter, 
				   MAX(AccessLevel) as AccessLevel, 
				   MAX(A.RecordStatus) as RecordStatus,
				   count(*) as Number
		   INTO    userQuery.dbo.#SESSION.acc#TreeAccess
		   FROM    OrganizationAuthorization A 
		   WHERE   A.AccessLevel < '8'
			AND    (A.OrgUnit is NULL AND A.Mission = '#URL.Mission#')
			AND    A.UserAccount = '#URL.ACC#' 
			AND    A.Role = '#URL.ID#'
			GROUP BY ClassParameter, GroupParameter  
		</cfquery>		
	    
	 </cfif> 	 
	 	 
	 <!--- create entity table --->
	 <CF_DropTable dbName="AppsQuery"  tblName="#SESSION.acc#Entity">
	 	 	  
	 <!--- check if the workflows are filtered by owner --->
	  
	 <cfquery name="Mission" 
			datasource="AppsOrganization" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#"> 
			SELECT * 
			FROM   Ref_Mission
			WHERE  Mission = '#url.mission#' 
	 </cfquery>	 
	 
	 <cfif url.mission neq "">
	 	 
		 <!--- get owner from the mission incl; admin unit --->
		 
		 <cfquery name="Owner" 
			datasource="AppsOrganization" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#"> 		 
			 SELECT   DISTINCT R.MissionOwner
			 FROM     Employee.dbo.Position AS P INNER JOIN
	                  Organization AS O ON P.OrgUnitAdministrative = O.OrgUnit INNER JOIN
	                  Ref_Mission AS R ON O.Mission = R.Mission
			 WHERE    P.Mission = '#url.mission#' 
		 </cfquery>
		 
		 <cfif owner.recordcount gte "1">
		     <cfset ownerlist = "#QuotedValueList(owner.MissionOwner)#">
		 <cfelse>
			 <cfset ownerlist = "'#mission.MissionOwner#'">
		 </cfif>	
		 
	 <cfelse>	  
	 
		 <cfset ownerlist = "">
		 	 
	 </cfif>
	 
	 <!--- obtain actions per workgroup splitted --->
			 
	 <cfquery name="Entity" 
		datasource="AppsOrganization" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#"> 
	        SELECT  E.EntityCode, 
			        E.EntityDescription, 
	     			EA.ActionCode, 
			    	EA.ActionType, 
				    EA.ActionDescription, 
					EA.ListingOrder,
	    			EG.EntityGroup,
					EG.EntityGroupName,
					EG.Owner
	        INTO    userQuery.dbo.#SESSION.acc#Entity 			   
	        FROM    Ref_Entity E INNER JOIN
	                Ref_EntityAction EA ON E.EntityCode = EA.EntityCode LEFT OUTER JOIN
	                Ref_EntityGroup EG ON E.EntityCode = EG.EntityCode 
						    AND EG.Operational = 1 
							<cfif ownerlist neq "">
							AND (EG.Owner IN (#preservesinglequotes(ownerlist)#) or EG.Owner is NULL)
							</cfif>
					
			WHERE   E.Role = '#URL.ID#'		
			
			<cfif url.mission neq "">
			
			AND     ( EA.ActionCode IN (SELECT ActionCode
			                          FROM   Ref_EntityClassAction
			                          WHERE  EntityCode = E.EntityCode
									  AND    EntityClass IN (SELECT EntityClass 
									                         FROM   Ref_EntityClass 
															 WHERE  EntityCode = E.EntityCode
															 AND    Operational = 1)
									  AND    (
									  
									         <!--- steps defined for this mission its owner --->
									         EntityClass IN (
											 	             SELECT EntityClass
									                         FROM   Ref_EntityClassOwner
															 WHERE  EntityCode = E.EntityCode
															 AND    EntityClassOwner = '#mission.missionowner#'
															)
															
											 OR
											 
											 <!--- the mission is enabled for this entity  --->
									         EntityClass IN (
											 	             SELECT EntityClass
									                         FROM   Ref_EntityClassMission
															 WHERE  EntityCode = E.EntityCode
															 AND    Mission = '#url.mission#'
															)				
															 
											 OR											 
																					 
											 <!--- no owners defined for this class so global access --->
											 EntityClass NOT IN (
											                     SELECT EntityClass
									                             FROM   Ref_EntityClassOwner
															     WHERE  EntityCode = E.EntityCode				 
																) 
																
																
														
											)
									)		
									
						OR EA.ActionType = 'Create'		
						)	
			</cfif>													
			AND     EA.Operational = 1 
								
	  </cfquery>		  
 	 	  	     	
	   <cfquery name="AccessList" 
		datasource="AppsQuery" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		   
		   SELECT    E.*, 
		             A.RecordStatus, 
					 A.AccessLevel, 
					 A.number
	       FROM      #SESSION.acc#Entity E LEFT OUTER JOIN
	                 #SESSION.acc#TreeAccess A ON E.ActionCode = A.ClassParameter AND E.EntityGroup = A.GroupParameter
	       WHERE     E.EntityGroup IS NOT NULL
		   
	       UNION 
		   
	       SELECT    E.*, A.RecordStatus, A.AccessLevel AS AccessLevel, A.number 
	       FROM      #SESSION.acc#Entity E LEFT OUTER JOIN
	                 #SESSION.acc#TreeAccess A ON E.ActionCode = A.ClassParameter
	       WHERE     EntityGroup IS NULL
		   
		   ORDER BY  E.EntityCode, 
		             E.EntityGroup, 
					 E.ListingOrder,
					 E.ActionCode					 
								
	     </cfquery>	
		 			
		  <!--- Hanno : 03/01/2012 set the iterations based on the user access for the owner, this code is not 100% if the
		  user has different access for each mission, showing more or less owners, maybe best to define
		  the iterations in a variable per mission --->
		  		 
		  <script language="JavaScript">
		     try {
		     document.getElementById('row').value = '<cfoutput>#accesslist.recordcount#</cfoutput>'
			 } catch(e) {}
		  </script>
		  		   
		   <CF_DropTable dbName="AppsQuery"  tblName="#SESSION.acc#Entity">
		  
			<table width="95%" cellspacing="0" cellpadding="0" align="center" class="navigation_table">
											
			<cfset row = 0>
			
			<cfif accessList.recordcount is "0">			
				<tr><td colspan="6" height="40" align="center" class="labelit"><font color="red">No workflow steps found. You can not grant any access <cfif url.mission neq ""> for <cfoutput>#URL.mission#</cfoutput></font></cfif></td></tr>			
			</cfif>

			<cfoutput query="AccessList" group="EntityCode">
			
			<tr>			
				<td colspan="4" height="26" style="padding-top:6px;padding-bottom:3px">
					<table cellspacing="0" cellpadding="0">
					<tr>					
						<td style="padding-left:1px" class="labelit"></td>
						<td style="padding-left:4px" class="labellarge">#EntityDescription# (#EntityCode#)</td>				
					</tr>
					</table>
				</td>				
			</tr>			

			<cfoutput group="EntityGroup">
						
			<cfset row = row+1>
			<cfset cnt = 0>			
						
			<cfset show = 1> 	
			
			<cfif entityGroup neq "">
							
				 <cfquery name="Check" 
					datasource="AppsOrganization" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
						   SELECT    *
					       FROM      Ref_AuthorizationRoleOwner
						   WHERE     Code = '#EntityGroup#'
			     </cfquery>	
				 
				 <cfif check.recordcount eq "1">
				 
				     <cfif SESSION.isAdministrator eq "No">
					 	
						 <cfquery name="Check" 
							datasource="AppsOrganization" 
							username="#SESSION.login#" 
							password="#SESSION.dbpw#">
								SELECT DISTINCT ClassParameter 
								FROM   OrganizationAuthorization
								WHERE  Role           = 'AdminUser'
								AND    UserAccount    = '#SESSION.acc#'
								AND    ClassParameter = '#EntityGroup#'
					     </cfquery>	
						 
						 <cfif check.recordcount eq "0">
						      <cfset show = "0">
						 </cfif>
					 
					 </cfif>
					 
				  </cfif>	 
			 
			</cfif>
			
			<!--- ---------------------------------------------------------- --->
			<!--- this option can be hidden upon opening and loaded via ajax --->
			<!--- ---------------------------------------------------------- --->
			
			<cfif show eq "1">			
									
				<cfif EntityGroup neq "">
								
																		
					<tr class="line">
					<td width="60%" colspan="4">
					
						<table cellspacing="0" cellpadding="0" width="100%">
						
						<tr><td width="20" style="height:20px;padding-left:14px;padding-right:5px">
															
						<cfparam name="url.mission" default="">
						
							<img src="#SESSION.root#/Images/arrowright.gif" alt="" 
								id="i#url.mission##row#Exp" border="0" class="show" 
								align="absmiddle" style="cursor: pointer;" 
								onClick="more('i#url.mission##row#')">
						
							<img src="#SESSION.root#/Images/arrowdown.gif" 
								id="i#url.mission##row#Min" alt="" border="0" 
								align="absmiddle" class="hide" style="cursor: pointer;" 
								onClick="more('i#url.mission##row#')">
						
						</td>
						<td class="labelit" style="height:20px">
						<a href="javascript:more('i#url.mission##row#')"><font size="1">wg:&nbsp;</font>#EntityGroup#:<font color="0080C0">#EntityGroupName#&nbsp;</font><cfif owner neq "">(#Owner#)<cfelse>(multiple)</cfif></a>
						</tr>
						
						</table>
					
					</td>
													
					<td colspan="2" align="right" id="s#url.mission##row#" class="labelmedium">														
																										
							<cfif Role.GrantAllTrees eq "0">
							
								<cfif URL.Access eq "">
								    <a href="javascript:showaccess('1','#url.mission##row#');more('i#url.mission##row#')"><font color="0080C0"><cf_tl id="Grant all steps"></font></a>
								<cfelse>
									<a href="javascript:showaccess('0','#url.mission##row#')"><font color="0080C0"><cf_tl id="Revoke all steps"></font></a>
								</cfif>
																
							</cfif>
						
					</td>
															
					</tr>
					
					<cfset cl = "hide">
					
				<cfelse>	
				
				<tr>
						
				<td colspan="2" id="s#url.mission##row#" style="padding-left:20px" class="labelmedium">
																
					<cfif Role.GrantAllTrees eq "0">
						
						<cfif URL.Access eq "">
						    <a href="javascript:showaccess('1','#url.mission##row#')">Grant all steps</a>
						<cfelse>
							<a href="javascript:showaccess('0','#url.mission##row#')">Revoke all steps</a>
						</cfif>
						
					</cfif>
				
				</td>
				</tr>
				
				<cfset cl = "regular">
				   
				</cfif>
			
				<cfoutput>		
																						
				<input type="hidden" name="#ms#_classparameter_#CurrentRow#" id="#ms#_classparameter_#CurrentRow#" value="#ActionCode#">
				<input type="hidden" name="#ms#_groupparameter_#CurrentRow#" id="#ms#_groupparameter_#CurrentRow#" value="#EntityGroup#">
				
				<cfset accesslvl = AccessLevel>
																				 				 
				 <cfif accesslvl neq "">
				 
				 <tr id="i#url.mission##row#" name="i#url.mission##row#" class="regular navigation_row">
				 
				 <cfelse>  
				 
				 <tr id="i#url.mission##row#" name="i#url.mission##row#" class="#cl# navigation_row">
				   
				 </cfif>
				 				 								
				  <td class="labelmedium linedotted" style="padding-left:10px"></td>
				  <td class="labelmedium linedotted" valign="top" style="padding-top:4px;padding-right:8px"><cfif actiontype neq "Action"><font color="green"></cfif>#ActionType#</font>: #ActionDescription# <font size="1">(#ActionCode#)</font></td>				 			  
				  <td class="labelmedium linedotted" style="padding:1px;padding-right:3px">
				  
					   <table width="100%" bgcolor="ffffff" cellspacing="0" cellpadding="0" style="border:1px solid gray">
											  
					   <cfquery name="Used" 
							datasource="AppsOrganization" 
							username="#SESSION.login#" 
							password="#SESSION.dbpw#">
								SELECT DISTINCT R.EntityClass, A.ActionOrder
								FROM   Ref_EntityClass R, Ref_EntityClassAction A
								WHERE  R.EntityCode   =  A.EntityCode
								AND    R.EntityClass  =  A.EntityClass
								AND    A.EntityCode   = '#entitycode#'
								AND    A.ActionCode   = '#actioncode#'	
								AND	   R.Operational = 1				
					     </cfquery>	
						 
						 <cfloop query="used">
							 <tr>
							 <td style="padding-left:4px" class="labelit">
							    <a href="##" title="Workflow and the position where this action is used."> #entityclass#
							 </td>						 
							 <td style="padding-right:4px" align="right"><font size="1"> [#actionorder#]</font></td>
							 </tr>
						 </cfloop>
						 </table>
				  
				  </td>
				  					  
				  <td width="20%" align="right" class="linedotted" style="padding-right:3px">				      						  				      
					  <cfinclude template="UserAccessSelectAction.cfm">				  						  
				  </td>	
				  
				  <cfset cnt=cnt+1>
					  			 
				</tr>		
																	
				</cfoutput>
				
			</cfif>
				
			</cfoutput>
			</cfoutput>
		    </table>
						
			<cfset class = AccessList.recordcount>
						
<cfelse>

	 <!--- get the maximum number of actions shown per mission --->
	 
	 <cfparam name="class" default="0">
	 
	 <cfif class eq "0">
	
		 <cfquery name="Entity" 
			datasource="AppsOrganization" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#"> 
		        SELECT  E.EntityCode, 
				        E.EntityDescription, 
		     			EA.ActionCode, 				
				    	EA.ActionType, 
					    EA.ActionDescription
						<!--- 
		    			EG.EntityGroup,
						EG.EntityGroupName
						--->
		        FROM    Ref_Entity E INNER JOIN
		                Ref_EntityAction EA ON E.EntityCode = EA.EntityCode 
						
						<!--- this is blowing up the number of actions and is not needed
						29/10/2011 as we already group by group as well 
						LEFT OUTER JOIN
		                Ref_EntityGroup EG ON E.EntityCode = EG.EntityCode AND EG.Operational = 1
						--->
												
				WHERE   E.Role = '#URL.ID#'		
				AND     EA.Operational = 1		
		  </cfquery>	
		  
		  <!---	3/1 not needed based on a observation of Nery 	 
		 		  
		  <cfquery name="getGroup" 
			datasource="AppsOrganization" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#"> 
		    SELECT *
			FROM   Ref_EntityGroup 
			WHERE  EntityCode IN (SELECT EntityCode FROM Ref_Entity WHERE Role = '#URL.ID#')
			AND    Operational = 1
		  </cfquery>
		   
		  <cfif getGroup.recordcount gte "1">	
		   
		      <cfset class = Entity.recordcount*getGroup.recordcount>	
		  
		  <cfelse>
		   
		   	  <cfset class = Entity.recordcount>	
		   
		  </cfif>
		   
		  --->
		   
		    <cfset class = Entity.recordcount>		   
				 	  
	  </cfif>		
				
</cfif>		
	

