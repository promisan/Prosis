<cfinvoke component = "Service.Access"  
	method         =   "AccessEntity" 
	objectid       =   "#Object.ObjectId#"
	actioncode     =   "#Action.ActionCode#" 
	mission        =   "#Object.mission#"
	orgunit        =   "#Object.OrgUnit#" 
	entitygroup    =   "#Object.EntityGroup#" 
	returnvariable =   "entityaccess">		
	
<cfoutput>	


<cfif entityaccess eq "READ" or entityaccess eq "EDIT" or entityaccess eq "ALL">
 
 <tr><td height="4"></td></tr>
 <tr bgcolor="ffffff" style="height:45px" class="line">
 
    <!---
    <td height="29" width="90" style="padding-left:10px;padding-right:10px" class="fixlength labelmedium2">#Action.ActionDescription#:</td>
	--->
 
    <td colspan="2">	   
	    <table id="processblock">
		<tr>
			
		<input type="hidden" name="StatusOld" id="StatusOld" value="#ActionStatus#">  
			
			<!--- put the pk of the entity in a variuable --->
					
			<cfquery name="StatusShow" 
			 datasource="AppsOrganization"
			 username="#SESSION.login#" 
			 password="#SESSION.dbpw#">
				 SELECT MIN(ActionStatus) as ActionStatus
				 FROM   OrganizationObjectAction 		
				 WHERE  ObjectId         = '#Action.ObjectId#' 
				 AND    ActionFlowOrder  <= '#ActionFlowOrder#'
				 AND    ActionCode       != '#ActionCode#' 
		   </cfquery>	
		   
		   <cfif StatusShow.ActionStatus eq "2">
		      <cfset Status = "0">
		   <cfelse>
		      <cfset Status = ActionStatus> 	
		   </cfif>
	    
	   <td>
	   
	   <input type="radio" style="cursor: pointer;" id="r0" class="radiol" name="actionstatus" value="0"  <cfif Status eq "0">checked</cfif>
	       onClick="javascript:selectoption('d0','0');updateTextArea();ptoken.navigate('ProcessActionButton.cfm?wfmode=#wfmode#&PublishNo=#ActionPublishNo#&ActionCode=#ActionCode#&Method=Pending','processnow')">
		   
	   </td>
	    	
	   <td id="d0"  class="labelmedium2 fixlength" style="cursor: pointer;padding:0 10px 0 0;" onclick="document.getElementById('r0').click()">
	       <img src="#SESSION.root#/Images/Pending.png" width="24" height="24"
						   alt="Go back to previous step" border="0" 
						   align="absmiddle">
	       <span style="position: relative; top:2px;"><cf_tl id="Pending decision"></span></td>
	   	  
	   
	   <cfif entityaccess eq "EDIT" or entityaccess eq "ALL">
	     
		      <cfif action.ActionGoTo gte "1">
		     		   
					<cfquery name="Check" 
					 datasource="AppsOrganization"
					 username="#SESSION.login#" 
					 password="#SESSION.dbpw#">
					   SELECT  ProcessActionCode
					   FROM    Ref_EntityActionPublishProcess
					    WHERE  ActionPublishNo   = '#Object.ActionPublishNo#'
					     AND   ActionCode        = '#ActionCode#' 
						 AND   ProcessActionCode != '#ActionCode#' 
						 AND   ProcessClass      = 'GoTo'
						 AND   Operational       = 1
						
					</cfquery>				
			   		   
				    <cfquery name="Revert" 
					 datasource="AppsOrganization"
					 username="#SESSION.login#" 
					 password="#SESSION.dbpw#">
						 SELECT DISTINCT P.ActionCode, P.ActionDescription, p.ActionReference, P.ActionCompleted, P.ActionDenied, P.ActionProcess, P.ActionOrder
						 FROM   #CLIENT.LanPrefix#Ref_EntityActionPublish P	 		
						 WHERE  P.ActionPublishNo = '#Object.ActionPublishNo#'
						 AND    P.ActionCode != '#ActionCode#' 
						 <!--- in case of decision do not show the decision nodes in the goto --->
						 AND    P.ActionCode != '#ActionGoToYes#'  
						 <!---
						 AND    P.ActionCode != '#ActionGoToNo#'  
						 --->
						 <cfif action.ActionGoTo eq "1">
						 	<!--- only actions that have NOT beern processed yet --->
							AND    P.ActionCode NOT IN (SELECT  ActionCode
							                            FROM   OrganizationObjectAction
					        		                    WHERE  ObjectId = '#Action.ObjectId#' 
														AND    ActionStatus IN ('2', '2Y'))
						 </cfif>	
						 
						 <cfif action.ActionGoTo eq "2">
						    <!--- only actions that have been processed already --->
						 	AND    P.ActionCode IN (SELECT  ActionCode
							                            FROM   OrganizationObjectAction
					        		                    WHERE  ObjectId = '#Action.ObjectId#' 
														AND    ActionStatus IN ('2', '2Y','2N'))			 
						 </cfif>	
						 
						 <cfif Check.recordcount gt "0">
						     AND  P.ActionCode IN (SELECT ProcessActionCode
												   FROM   Ref_EntityActionPublishProcess
												   WHERE  ActionPublishNo = '#Object.ActionPublishNo#'
												   AND    ActionCode = '#ActionCode#' 
												   AND    ProcessActionCode != '#ActionCode#' 
												   AND    Operational = 1
												   AND    ProcessClass = 'GoTo')
						 </cfif>
						 						
						 GROUP BY P.ActionCode, P.ActionDescription, P.ActionCompleted, P.ActionReference,P.ActionDenied, P.ActionProcess, P.ActionOrder
						 ORDER BY P.ActionOrder 
					 
				   </cfquery>
				 		           
				   <cfif Revert.recordcount gte "1" and TriggerActionType neq "Action">
				   			  	        
					   <td style="padding-left:8px">
					  
					   <input type="radio" style="cursor: pointer;" class="radiol" id="r1" name="actionstatus" value="1"  <cfif Status eq "1">checked</cfif>
						   onClick="selectoption('d1','2N');updateTextArea();ptoken.navigate('ProcessActionButton.cfm?wfmode=#wfmode#&PublishNo=#ActionPublishNo#&ActionCode=#ActionCode#&Method=Revert','processnow')">
					   
					   </td>
					    	
					   <td class="labelmedium2" style="cursor: pointer;padding-right:5px" id="d1" onclick="document.getElementById('r1').click()">
					      
						  <table>
						  <tr class="labelmedium2">
						  <td><img src="#SESSION.root#/Images/Send.png" width="32" height="32" alt="Go back to previous step" border="0" align="absmiddle"></td>
						  <td class="fixlength" style="padding-bottom:1px"><cf_tl id="#ActionGoToLabel#"></td>
						   
					      <cfif Status eq "1">
					  	    <cfset r = "regular">
					      <cfelse>
					        <cfset r = "hide">
					      </cfif>
						  
					      <td class="#r#" id="d1a"></td>
						      
						<td class="#r#" id="d1b" style="padding-left:1px;padding-right:8px">	  
								  
						   <select style="max-width:280px;border:0px;background-color:f1f1f1" name="ActionCodeOnHold" id="ActionCodeOnHold" class="regularxxl">
							<cfloop query="Revert">
							  <option value="#Revert.ActionCode#">: #ActionDescription# | #ActionReference# [#ActionCode#]</option>
							</cfloop>
						   </select>
						   
						 </td></tr>
						 </table>	
						 
						</td> 
								   
				   </cfif>	
					  				   
		   
		       </cfif>
			   
			   <cfquery name="MethodEnabled" 
				 datasource="AppsOrganization"
				 username="#SESSION.login#" 
				 password="#SESSION.dbpw#">
				     SELECT *
					 FROM   Ref_EntityActionPublishScript 
					 WHERE  ActionCode      = '#ActionCode#' 
					 AND    ActionPublishNo = '#ActionPublishNo#' 		 
					 AND    Method          = 'Deny' 		
					 AND    MethodEnabled   = 1	 
					 AND    (MethodScript != '' or DocumentId is not NULL)
			  </cfquery>	  
			   
			  <cfquery name="Methods" 
				 datasource="AppsOrganization"
				 username="#SESSION.login#" 
				 password="#SESSION.dbpw#">
				 SELECT *
				 FROM   Ref_EntityActionPublishScript 
				 WHERE  ActionCode      = '#ActionCode#' 
				 AND    ActionPublishNo = '#ActionPublishNo#' 		 
				 AND    Method          = 'Deny' 			 
		  	   </cfquery>
			          	  		   
		 		<cfif MethodEnabled.recordcount eq "1" or len(Methods.MethodScript) lte "5">	   
		   	      		      
				<td style="padding-left:5px">
	
				   <input id="r2n" 
				        name="actionstatus" 
						style="cursor: pointer;" 
						type="radio" 
						class="radiol"
						value="2N" 
						<cfif URL.Process neq "">disabled</cfif> <cfif Status eq "2N">checked</cfif>
				        onClick="selectoption('d2n','2N');updateTextArea();ptoken.navigate('ProcessActionButton.cfm?wfmode=#wfmode#&PublishNo=#ActionPublishNo#&ActionCode=#ActionCode#&Method=Deny','processnow')">
				</td>
				        	
				<td id="d2n" class="labelmedium2 fixlength" style="padding:0 10px 0 0;cursor: pointer;" onclick="document.getElementById('r2n').click()">
				   
				    <img src="#SESSION.root#/Images/Deny.png" width="24" height="24" alt="No, denied" border="0" align="absmiddle">
					
					   <cfif URL.Process neq ""><font color="C0C0C0"></cfif>
				      			   
				   <cfif Action.ActionGoToNoLabel gte "a">
				     <span style="position: relative; top:2px;">#Action.ActionGoToNoLabel#</span>  
				   <cfelse>
	                   <span style="position: relative; top:2px;"><cf_tl id="No, denied"></span>
				   </cfif>
				   
			   </td>
			   
			    </cfif>
				   		      
			   <td style="padding-left:5px">
	
			   <input type="radio"
			       id="r2y" name="actionstatus" value="2y" class="radiol" style="cursor: pointer;" <cfif URL.Process neq "">disabled</cfif>  
				   <cfif Status eq "2Y">checked</cfif>
			       onClick="selectoption('d2y','2Y');updateTextArea();ptoken.navigate('ProcessActionButton.cfm?wfmode=#wfmode#&PublishNo=#ActionPublishNo#&ActionCode=#ActionCode#&Method=Submission','processnow')">
				   
			   </td>
			        	
			   <td id="d2y" class="labelmedium2 fixlength" style="padding:0 4px 0 0;cursor: pointer;" onclick="document.getElementById('r2y').click()">
				   
				   <img src="#SESSION.root#/Images/Approve.png" width="24" height="24" alt="Yes, agreed" border="0" align="absmiddle">
				   
					   <cfif URL.Process neq ""><font color="C0C0C0"></cfif>
				   
				   <cfif Action.ActionGoToYesLabel eq "">
				       <span style="position: relative; top:2px;"><cf_tl id="Yes, Agreed"></span>
				   <cfelse>
				      <span style="position: relative; top:2px;">#Action.ActionGoToYesLabel#</span>
				   </cfif>
				   
			  </td>	
				      
			   <cfif Action.ActionDateInput eq "1">
			   
				   <td class="labelmedium2" style="padding-left:1px;padding-bottom:1px;padding-right:4px"><cf_tl id="on">:</td>
				   <td style="min-width:130px;">
													
							<cfif Action.ActionDateInput eq "">
						
								<cf_intelliCalendarDate9
								FieldName="ActionDateInput" 
								class="regularxl"
								Default="#Dateformat(Action.ActionDateInput, CLIENT.DateFormatShow)#"
								AllowBlank="false">	
							
							<cfelse>
							
								<cf_intelliCalendarDate9
								FieldName="ActionDateInput" 
								class="regularxl"
								Default="#Dateformat(now(), CLIENT.DateFormatShow)#"
								AllowBlank="false">							
							
							</cfif>
				   
				   </td>   
				   
			   </cfif>	
	   
	    </cfif>
			
	      
	   <td align="right" id="processnow" style="padding-left:10px">
	     
		  <cf_tl id="Submit" var="1">
		  		   
		  <!--- ------------------------------------------------------------- --->
		  <!--- process step and process custom fields and/or dialogs as well --->
		  <!--- ------------------------------------------------------------- --->
				 		 
		  <input type = "button" 
		      name    = "saveaction" 
			  id      = "saveaction"
		      onclick = "updateTextArea();Prosis.busy('yes');saveforms('#wfmode#')" 
			  value   = "#lt_text#" 
			  style   = "width:120px;height:25;font-size:14px;border-radius:5px;border:none;background:##033F5D;color:##FFFFFF;font-family:-apple-system,BlinkMacSystemFont,'Segoe UI',Roboto,Oxygen-Sans,Ubuntu,Cantarell,'Helvetica Neue',sans-serif,'Raleway',sans-serif !important;"
			  class   = "button10g">	   		   
			   
	   </td>
	        
	   </tr>
	   </table>
  </td>
  </tr>
    	   
  <cfif ActionReferenceEntry eq "1">
    	 
		 <cfif Action.ActionReferenceDate eq "">
		 				 
		    <cfquery name="PriorActionCode" 
				 datasource="AppsOrganization"
				 username="#SESSION.login#" 
				 password="#SESSION.dbpw#">
		 
		  		  SELECT   *
				  FROM     OrganizationObjectAction
				  WHERE    ObjectId = '#Action.ObjectId#' and ActionCode = '#Action.ActionCode#'
				  AND      ActionStatus > '0'
				  ORDER BY Created DESC
			</cfquery>	
			
			<cfset adte = PriorActionCode.ActionReferenceDate>
			<cfset aref = PriorActionCode.ActionReferenceNo>	 
		 
		 <cfelse>
		 
		 	<cfset adte = Action.ActionReferenceDate>
			<cfset aref = Action.ActionReferenceNo>		 
		 
		 </cfif>
	 	   		 
		 <tr><td height="3"></td></tr>
		 <tr>
		    <td class="labelmedium" style="padding-left:10px"><cf_tl id="Reference">:</td>
			<td>
			<table cellspacing="0" cellpadding="0">
			<tr>
                <td>
                    <input type="text" name="ActionReferenceNo" id="ActionReferenceNo" class="regularxl" value="#aref#">
                <td  class="labelmedium" style="padding-left:20px"><span style="position: relative; top:2px;"><cf_tl id="Date">:</span></td>
                <td>
				<cf_intelliCalendarDate9
				FieldName="ActionReferenceDate" 
				Default="#Dateformat(adte, CLIENT.DateFormatShow)#"
				Class="regularxl"
				AllowBlank="false">	
			     </td>
			     </td>
			</tr>
			</table>
			</td>
		 </tr>				
		 <tr><td height="3"></td></tr>
				 
   </cfif>
   
   </cfif>
      
   <cfif entityaccess eq "EDIT">
   
	   <cfquery name="getaccess" 
			datasource="AppsOrganization" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">		
				SELECT   OA.AccessId, U.PersonNo, P.IndexNo, P.LastName, P.FirstName, P.Gender, P.Nationality
				FROM     OrganizationAuthorization AS OA INNER JOIN
		                 System.dbo.UserNames AS U ON OA.UserAccount = U.Account INNER JOIN
		                 Employee.dbo.Person AS P ON U.PersonNo = P.PersonNo
				WHERE    OA.ClassParameter = '#Action.ActionCode#' 							
				AND      OA.OrgUnit        = '#Object.OrgUnit#'
				AND      OA.AccessLevel    = '2'
		</cfquery>	
				
		 <!--- we check if also access level 2 exists ---> 
		
		<cfif getAccess.recordcount gte "1">
		
			<tr class="labelmedium2">
			
			<td colspan="2" style="color:red;background-color:ffffff;font-size:15px">
			<b>Attention</b> : By confirming, I certify that this action is taken on behalf of <cfif getAccess.Gender eq "M">Mr.<cfelse>Ms.</cfif> #getaccess.firstName# #getAccess.lastName#.								
			</td>
			</tr>
		
		</cfif>
				
	</cfif>
   	
	<tr><td colspan="2">
     <cfdiv id="actionprocessbox"/>  
  </td></tr>  
  	   
</cfoutput>	

