
<cfif URL.PublishNo eq "">

	<cfquery name="Get" 
	datasource="AppsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT *
	FROM Ref_EntityClassAction
	WHERE ActionCode  = '#URL.ActionCode#'
	AND   EntityClass = '#URL.EntityClass#'
	AND   EntityCode  = '#URL.EntityCode#' 
	</cfquery>

	<cfquery name="NEXT" 
		datasource="AppsOrganization" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT  A.ActionCode, A.ActionDescription, A.ActionType, A.ActionReference, Go.ConditionScript, Go.ProcessActionCode AS Enabled
		FROM    Ref_EntityClassAction A LEFT OUTER JOIN
                Ref_EntityClassActionProcess Go ON A.EntityCode = Go.EntityCode 
				AND A.EntityClass = Go.EntityClass 
				AND A.ActionCode = Go.ProcessActionCode 
				AND Go.ProcessClass = 'GoTo'  
				AND Go.Operational = '1'  
				AND Go.ActionCode = '#URL.ActionCode#'
		WHERE   A.EntityCode = '#URL.EntityCode#'
		 AND    A.EntityClass = '#URL.EntityClass#'
		 AND    A.ActionCode <> '#URL.ActionCode#'				
		 AND    A.ActionOrder is not NULL
		ORDER BY A.ActionCode						 						 
	</cfquery>
	
<cfelse>	

	<cfquery name="Get" 
	datasource="AppsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT *
	FROM Ref_EntityActionPublish A, Ref_EntityClassPublish P
	WHERE A.ActionCode    = '#URL.ActionCode#'
	AND A.ActionPublishNo = '#URL.PublishNo#'
	AND A.ActionPublishNo = P.ActionPublishNo
	</cfquery>

	<cfquery name="Next" 
		datasource="AppsOrganization" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT  A.ActionCode, A.ActionDescription, A.ActionType, A.ActionReference, Go.ConditionScript, Go.ProcessActionCode AS Enabled
		FROM    Ref_EntityActionPublish A LEFT OUTER JOIN
                Ref_EntityActionPublishProcess Go ON A.ActionPublishNo = Go.ActionPublishNo
				 AND A.ActionCode = Go.ProcessActionCode 
				 AND Go.ProcessClass = 'GoTo' 
				 AND Go.Operational = '1' 
				 AND Go.ActionCode = '#URL.ActionCode#'
		WHERE   A.ActionPublishNo = '#URL.PublishNo#'
		 AND    A.ActionCode <> '#URL.ActionCode#'				
		 AND    A.ActionOrder is not NULL
		ORDER BY A.ActionOrder,A.ActionCode						 						 
	</cfquery>

</cfif>

<cfoutput>
			
	<table width="97%" height="100%" align="center" cellspacing="0" cellpadding="0" border="0">
	
	<tr><td height="5"></td></tr>
	<tr><td height="5" colspan="2" class="labelit" width="690"><b>Note:</b> <font color="808080">In this section you may define if and how a user may move to a workflow step once this step <font color="0080FF">[#Get.ActionDescription#]</font> is due for action and for steps that are not defined as a default step in the workflow manager. The
	allowed steps to move to will be show to the user in the <b>[Go To]</b> dropdown of the action dialog. You may define a condition which is verified prior to the move to the selected step.</td></tr>	
	<tr><td height="3"></td></tr>
	<tr><td class="linedotted" colspan="2" height="1"></td></tr>		
		
	<tr><td colspan="2" height="20">
			
			<cfform name="flowform">
			
				<table width="100%" class="formpadding">
			 
			 	<TR>
				<TD width="25%" class="labelit" height="25" class="labelit">Define next action mode:</TD>
				<TD>		
				
					<select name="ActionGoTo" id="ActionGoTo" onchange="saveflow()" class="regularxl">
						<option value="0" <cfif Get.ActionGoTo eq "0">selected</cfif>>Disabled</option>
						<option value="1" <cfif Get.ActionGoTo eq "1">selected</cfif>>Enabled, for pending steps only</option>
						<option value="2" <cfif Get.ActionGoTo eq "2">selected</cfif>>Enabled, for already performed steps (send back)</option>
						<option value="3" <cfif Get.ActionGoTo eq "3">selected</cfif>>Enabled, for all steps</option>
					</select>
									
					</td>				
				</tr>
				
				<TR>
				<TD width="25%" class="labelit" height="25">Label:</TD>
				<TD>		
				
					<input type="text" 
					       onchange="saveflow()" 
					   	   name="ActionGoToLabel" 
						   id="ActionGoToLabel" 
						   value="#get.ActionGoToLabel#"
					       maxlength="20" 
						   class="regularxl">			
															
					</td>				
				</tr>
				
				</table>
			
			</cfform>
			
			</td>
			</tr>
								
			<cfif get.ActionGoTo gte "1">
			  <cfset sb = "regular">
			<cfelse>
			  <cfset sb = "hide">  					  
			</cfif>
			
			
			<tr class="line"><td STYLE="height:26px" colspan="2" class="labelit">Select actions that may be performed once this step has been reached (besides the predefined next action)</td></tr>
			<tr>
				
			<td style="height:400" colspan="2" class="#sb#" id="goto">		
			
				<CF_DIVSCROLL style="height:100%">			
																										
				<table width="97%" border="0" align="center" cellspacing="0" cellpadding="0">
				
					<cfloop query="Next">
					
						<tr class="<cfif next.enabled neq "">highlight2<cfelse>regular</cfif>">
							<td style="padding-left:3px" class="labelit">
							<!--- <a href="javascript:gotocondition('box#ActionCode#','#ActionCode#')"> --->
							#ActionCode#</td>
							<td class="labelit">#ActionDescription#</td>
							<td class="labelit">#ActionType#</td>
							<td class="labelit">#ActionReference#</td>
							<td>
							
								<input type="checkbox" 
								    onclick="gotoselect('#currentrow#',this,this.checked,this.value)" 
									name="GoToNext" 
									id="GoToNext" 
									value="#ActionCode#" <cfif next.enabled neq "">checked</cfif>>	
															
							</td>
						</tr>
												
						<tr><td colspan="5">
						
						  <cfif Enabled neq "">
						    <cfdiv id="box#currentrow#" bind= "url:ActionStepFlowCondition.cfm?entityCode=#URL.EntityCode#&entityClass=#URL.EntityClass#&ActionCode=#url.actionCode#&Publishno=#url.publishno#&stepto=#actioncode#"/> 	
						  <cfelse>
						  	<cfdiv id="box#currentrow#"/> 	
						  </cfif>	
						  					  				       				
						</td></tr>
						
					<tr><td colspan="5" height="1" class="linedotted"></td></tr>	
					</cfloop>
					
				</table>		
				
				</CF_DIVSCROLL>					
										
			</TD>
		</TR>
				
	</table>	
				
</cfoutput>		

	