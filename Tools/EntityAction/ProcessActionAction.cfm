

<cfinvoke component = "Service.Access"  
	method         =   "AccessEntity" 
	objectid       =   "#Object.ObjectId#"
	actioncode     =   "#Action.ActionCode#" 
	mission        =   "#Object.mission#"
	orgunit        =   "#Object.OrgUnit#" 
	entitygroup    =   "#Object.EntityGroup#" 
	returnvariable =   "entityaccess">		

<cf_tl id="Select This option to  keep the document at the CURRENT STEP for pending review" var="vLblTTPending">     		
<cf_tl id="Select this option to GO TO the step in the drop down list" var="vLblTTGoTo">  
<cf_tl id="Select this option to go to the NEXT STEP" var="vLblTTNext">     	
  	
 <cfoutput>
 
 <tr class="line">
 
    <!---
    <td style="height:35px;padding-left:10px" class="labelmedium">
		<!--- <cf_tl id="Click for help" var="vHelpMsg">
		<a 
			href="javascript:setProsisHelp('ProsisActionActionHelp.cfm', function(){ toggleProsisHelp(); });" 
			style="color:##507BE2;" 
			title="#vHelpMsg#"> --->
				<cf_tl id="Action status">:
		<!--- </a> --->
	</td>
	--->
    
	<td colspan="2" style="padding-left:10px;height:45px">   
	
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

	   <td style="cursor: pointer;" title="#vLblTTPending#">
	
	  		 <input style="cursor: pointer;" id="r0" class="radiol" type="radio" name="actionstatus" value="0"  <cfif Status eq "0">checked</cfif> onClick="_cf_loadingtexthtml='';updateTextArea();selectoption('d0','0');ptoken.navigate('ProcessActionButton.cfm?wfmode=#wfmode#&PublishNo=#ActionPublishNo#&ActionCode=#ActionCode#&Method=Pending','processnow');<cfif entityaccess eq 'EDIT'>ptoken.navigate('#SESSION.root#/tools/EntityAction/ActionListingFly.cfm?mode=regular&objectid=#object.Objectid#&ActionPublishNo=#ActionPublishNo#&ActionCode=#ActionCode#','stepflyaccess')</cfif>;">
	  
	   </td>
       <td class="labelmedium2" style="padding-left:3px;padding-right:3px" title="#vLblTTPending#">
                    <img src="#SESSION.root#/Images/Pending.png" width="24" height="24"
				   alt="Pending" border="0" 
				   align="absmiddle">       
       </td>
       <td id="d0" class="labelmedium2" onclick="document.getElementById('r0').click()" style="padding-right:10px" title="#vLblTTPending#"><cf_tl id="Save"></td>
    
      	  
   <cfif action.ActionGoTo gte "1">
     		
	   <cfquery name="Check" 
		 datasource="AppsOrganization"
		 username="#SESSION.login#" 
		 password="#SESSION.dbpw#">
		   SELECT ProcessActionCode
		   FROM   Ref_EntityActionPublishProcess
		   WHERE  ActionPublishNo   = '#Object.ActionPublishNo#'
		     AND  ActionCode        = '#ActionCode#' 
			 AND  ProcessActionCode != '#ActionCode#' 
			 AND  ProcessClass      = 'GoTo' 			
			 AND  Operational       = 1
	   </cfquery>	
	   		   
	   <cfquery name="Revert" 
		 datasource="AppsOrganization"
		 username="#SESSION.login#" 
		 password="#SESSION.dbpw#">
		 SELECT DISTINCT P.ActionCode, 
		        P.ActionDescription, 
				P.ActionCompleted, 
				P.ActionDenied,
				P.ActionReference,
				P.ActionProcess,
				P.ActionOrder
		 FROM   #CLIENT.LanPrefix#Ref_EntityActionPublish P	 		
		 WHERE  P.ActionPublishNo = '#Object.ActionPublishNo#' 
		 AND    P.ActionCode != '#ActionCode#' 
		 <cfif action.ActionGoTo eq "1">
		 AND    P.ActionCode NOT IN (SELECT ActionCode
			                         FROM   OrganizationObjectAction
	        	                     WHERE  ObjectId = '#Action.ObjectId#' 
									 AND    ActionStatus IN ('2', '2Y'))
		 </cfif>	
		 
		 <cfif action.ActionGoTo eq "2">
		 	AND   P.ActionCode IN (SELECT   ActionCode
			                       FROM     OrganizationObjectAction
	        		               WHERE    ObjectId = '#Action.ObjectId#' 
								   AND      ActionStatus IN ('2', '2Y','2N'))			 
		 </cfif>	
		 
		 <cfif Check.recordcount gt "0">
		     AND  P.ActionCode IN (SELECT   ProcessActionCode
								   FROM     Ref_EntityActionPublishProcess
								   WHERE    ActionPublishNo = '#Object.ActionPublishNo#'
								   AND      ActionCode = '#ActionCode#' 
								   AND      ProcessActionCode != '#ActionCode#' 
								   AND      ProcessClass = 'GoTo'
								   AND      Operational = 1) 
		 </cfif>
		 			
		 GROUP BY P.ActionCode, P.ActionDescription, P.ActionReference, P.ActionCompleted, P.ActionDenied, P.ActionProcess, P.ActionOrder
		 ORDER BY P.ActionOrder 		 
		 
	   </cfquery>
	  	   	      
	   <cfif entityaccess eq "ALL" or entityaccess eq "EDIT" or entityaccess eq "READ">	   
	   	           
		   <cfif Revert.recordcount gte "1" and TriggerActionType neq "Action">

		   		<td class="labelmedium2" style="height:34;padding-left:3px;" title="#vLblTTGoTo#">

				   <input id="r1" style="cursor: pointer;" 			 
				   type="radio" name="actionstatus" value="1" class="radiol"  <cfif Status eq "1">checked</cfif>
				   onClick="_cf_loadingtexthtml='';selectoption('d1','2N');updateTextArea();ptoken.navigate('ProcessActionButton.cfm?wfmode=#wfmode#&PublishNo=#ActionPublishNo#&ActionCode=#ActionCode#&Method=Forward','processnow');<cfif entityaccess eq 'EDIT'>ptoken.navigate('#SESSION.root#/tools/EntityAction/ActionListingFly.cfm?mode=revert&objectid=#object.Objectid#&ActionPublishNo=#ActionPublishNo#&ActionCode=#Revert.ActionCode#','stepflyaccess')</cfif>;">
			   			   
			   </td>
		  		  		    		
                <td class="labelmedium2" id="d1" style="cursor: pointer;" onclick="document.getElementById('r1').click()" title="#vLblTTGoTo#">
                    <table cellspacing="0" cellpadding="0">
                        <tr>
                            <td style="padding-left:3px;padding-right:3px">
                                <img src="#SESSION.root#/Images/workflow_previous.png" width="18" height="18" alt="Go back to previous step" border="0" align="absmiddle">
                            </td>
                            <td style="padding-left:5px;padding-right:3px" class="labelmedium2">
                                <cf_tl id="#ActionGoToLabel#">
                            </td>
                        </tr>
                    </table>
                </td>
			   
			   <cfif Status eq "1">
			  	 <cfset r = "regular">
			   <cfelse>
			     <cfset r = "hide">
			   </cfif>
		       
			   <td class="#r#" id="d1a" style="padding-left:8px;padding-right:4px" title="#vLblTTGoTo#"></td>
				      
			   <td class="#r#" id="d1b" title="#vLblTTGoTo#">  	
			   			   		      
				   <select style="width:240px;border:0px;background-color:f1f1f1" class="regularxxl"				   
				     name="ActionCodeOnHold" id="ActionCodeOnHold"
					 style="background: ffffff;" 
					 onchange="_cf_loadingtexthtml='';updateTextArea();ptoken.navigate('#SESSION.root#/tools/EntityAction/ActionListingFly.cfm?mode=revert&objectid=#object.Objectid#&ActionPublishNo=#ActionPublishNo#&ActionCode='+this.value,'stepflyaccess');">					 
					<cfloop query="Revert">
					   <option value="#ActionCode#">: #ActionDescription# | #ActionReference# [#ActionCode#]</option>
					</cfloop>
					</select>					
				</td>
								   	   
		   </cfif>	
	   
	   </cfif>
	  
  </cfif>
  	   
  <td class="hide" id="d1a"></td>
  <td class="hide" id="d1b"></td>
   
  <!--- provision for the holder to act --->
    
  <cfif entityaccess eq "EDIT" or entityAccess eq "ALL">
  
  		<cfquery name="MethodEnabled" 
			 datasource="AppsOrganization"
			 username="#SESSION.login#" 
			 password="#SESSION.dbpw#">
			 SELECT *
			 FROM   Ref_EntityActionPublishScript 
			 WHERE  ActionCode      = '#ActionCode#' 
			 AND    ActionPublishNo = '#ActionPublishNo#' 		 
			 AND    Method          = 'Submission' 		
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
			 AND    Method          = 'Submission' 		
			 AND    (MethodScript != '' or DocumentId is not NULL)	 
	  </cfquery>
	        		  	  		   
	  <cfif MethodEnabled.recordcount eq "1" or Methods.Recordcount eq "0">	  
	  	  		 	    	
		  <td style="cursor: pointer;" id="d2"  onclick="document.getElementById('r2').click()">
		  		  
		     <table cellspacing="0" cellpadding="0">
			
			   <tr> 
                   <td class="labelmedium2" style="padding-left:3px;padding-right:3px" title="#vLblTTNext#">
		 
				  
		   <input type="radio" id="r2" style="cursor: pointer;" class="radiol"
		   <cfif URL.Process neq "">disabled</cfif>
		   name="actionstatus" value="2"  <cfif Status eq "2" or status eq "0">checked</cfif>
		   onClick="_cf_loadingtexthtml='';selectoption('d2','2');updateTextArea();ptoken.navigate('ProcessActionButton.cfm?wfmode=#wfmode#&PublishNo=#ActionPublishNo#&ActionCode=#ActionCode#&Method=Submission','processnow'); ptoken.navigate('#SESSION.root#/tools/EntityAction/ActionListingFly.cfm?mode=regular&objectid=#object.Objectid#&ActionPublishNo=#ActionPublishNo#&ActionCode=#ActionCode#','stepflyaccess');">
		   
		  </td>
				  <td class="labelmedium2" style="padding-right:3px" title="#vLblTTNext#">

				   <img src="#SESSION.root#/Images/workflow_next.png" width="32" height="32"
				   alt="Forward to next step" border="0" 
				   align="absmiddle">
				   
				  </td>
				  <td style="padding-right:5px" class="labelmedium2" title="#vLblTTNext#">
				  
				   <cfif URL.Process neq ""><font color="C0C0C0"></cfif>
				   
				   <cfif ActionGoToYesLabel eq "">
					   <cf_tl id="Forward">		
				   <cfelse>
					   #ActionGoToYesLabel#
				   </cfif>
		   
		   	    </td>
                
			    </tr>
			</table>
		  	   
		  </td>   
		
	   </cfif>  
	  	   
	   <cfif Action.ActionDateInput eq "1">
	   
	   <td class="labelmedium2" style="padding-left:0px;padding-right:4px"><cf_tl id="on">:</td>
	   <td>
	   							
				<cfif Action.ActionDateInput eq "">
			
					<cf_intelliCalendarDate9
					FieldName="ActionDateInput" 
					class="regularxxl"
					Default="#Dateformat(Action.ActionDateInput, CLIENT.DateFormatShow)#"
					AllowBlank="false">	
				
				<cfelse>
				
					<cf_intelliCalendarDate9
					FieldName="ActionDateInput" 
					class="regularxxl"
					Default="#Dateformat(now(), CLIENT.DateFormatShow)#"
					AllowBlank="false">							
				
				</cfif>
				
	   </td>   
	   </cfif>	
   
    </cfif>
      
   <td class="labelmedium" colspan="1" style="padding-left:7px" align="right" id="processnow">
	 
	    <cf_tl id="Submit" var="1">		

	   	<input type="button" 
		    name="saveaction" 
			id="saveaction"
			value="#lt_text#" 
			style="width:120px;height:25;font-size:14px;border-radius:5px;border:none;background:##033F5D;color:##FFFFFF;font-family:-apple-system,BlinkMacSystemFont,'Segoe UI',Roboto,Oxygen-Sans,Ubuntu,Cantarell,'Helvetica Neue',sans-serif,'Raleway',sans-serif !important;"
			onclick="updateTextArea();Prosis.busy('yes');saveforms('#wfmode#')" 
			class="button10g">		
					
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
				  AND ActionStatus > '0'
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
		    <td class="labelmedium" style="padding-left:10px;"><cf_tl id="Action Reference">:</td>
			<td>
			<table cellspacing="0" cellpadding="0">
			<tr><td>
			<input type="text" name="ActionReferenceNo" id="ActionReferenceNo" class="regularxl" value="#aref#">
			<td class="labelmedium" style="padding-left:20px"><cf_tl id="Date">:</td>				 
			<td style="padding-left:10px">
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
		
		<cfif getAccess.recordcount eq "0">
		
		 <cfquery name="getaccess" 
			datasource="AppsOrganization" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">		
				SELECT   OA.AccessId, U.PersonNo, P.IndexNo, P.LastName, P.FirstName, P.Gender, P.Nationality
				FROM     OrganizationAuthorization AS OA INNER JOIN
		                 System.dbo.UserNames AS U ON OA.UserAccount = U.Account INNER JOIN
		                 Employee.dbo.Person AS P ON U.PersonNo = P.PersonNo
				WHERE    OA.ClassParameter = '#Action.ActionCode#' 							
				AND      OA.OrgUnit        is NULL
				AND      OA.Mission        = '#Object.Mission#'
				AND      OA.AccessLevel    = '2'
		</cfquery>	
		
		</cfif>
		
		 <!--- we check if also access level 2 exists ---> 
		
		<cfif getAccess.recordcount gte "1">
		
			<tr class="labelmedium2">
			<td></td>
			<td colspan="1" style="color:red;height:35px;background-color:ffffff;font-size:15px">
			<b>Attention</b> : By confirming, I certify that this action is taken on behalf of <cfif getAccess.Gender eq "M">Mr.<cfelse>Ms.</cfif> #getaccess.firstName# #getAccess.lastName#.								
			</td>
			</tr>
		
		</cfif>
				
	</cfif>  
  
 <tr>
 	<td colspan="2">
     <cfdiv id="actionprocessbox"/>  
    </td>
 </tr>
    		
</cfoutput>	

<cfset ajaxonload("doCalendar")>