<!--- deployment section --->

<cfoutput>
	
<tr><td colspan="2" style="padding-left:10px">
	<table width="100%" cellspacing="0" cellpadding="0" align="center">
		 	 
	 <cfquery name="Parent" 
		datasource="AppsSystem" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT *
		FROM  Ref_ReportControl S 
		WHERE ControlIdParent = '#URL.ID#' 
	 </cfquery>
	 
	 <cfquery name="Flow" 
		datasource="AppsOrganization" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT *
		FROM  OrganizationObject O, 
		      OrganizationObjectAction OA
		WHERE O.ObjectId = OA.ObjectId
		AND   ObjectKeyValue4  = '#URL.ID#' 
		AND   O.Operational  = 1 
	</cfquery>				
	 		 
	 <cfif Parent.Recordcount gte "1">
	 	 
	    <tr><td height="23" class="labelit">&nbsp;&nbsp;&nbsp;<img src="#SESSION.root#/Images/warning.gif" alt="" border="0" align="absmiddle">
		<a href="RecordEdit.cfm?id=#Parent.ControlId#" title="Load instance">
		&nbsp;An instance of this report definition is currently under development.
		</a>
		</td></tr>
	 
	 <cfelse>
	 	    
	    <cfif Line.SystemModule neq "">
	 	<tr><td height="1" class="line"></td></tr>
		<tr>
		   <td height="30" bgcolor="white">
		<cfelse>
		<tr>
		   <td height="1" bgcolor="white">   
		   
		</cfif>
	 
		    <table cellspacing="0" cellpadding="0" class="formpadding"><tr>
			
			<script>
					function showaction() {
						if  (document.getElementById("operational").checked == true) {
						document.getElementById("status").className = "Button10s"
						
						} else	{
						document.getElementById("status").className = "hide"
						
						}
					}
					</script>				
					
			<cfif Line.SystemModule eq "">
				<td>
			  
				<input type="hidden" name="Operational" id="Operational" value="0">
				</td>
				
			<cfelse>
						
				<cfif master eq "1">
										
				    <cfif Line.Operational eq "0">
					
						<cfquery name="FlowCurrent" 
							datasource="AppsOrganization" 
							username="#SESSION.login#" 
							password="#SESSION.dbpw#">
							SELECT *
							FROM  OrganizationObject O, 
							      OrganizationObjectAction OA
							WHERE O.ObjectId       = OA.ObjectId
							AND   ObjectKeyValue4  = '#URL.ID#' 
							AND   O.Operational    = 1
							AND   OA.ActionStatus  = '0'
						 </cfquery>
																			
						<cfif FlowCurrent.Recordcount eq "0" and (master eq "1" or SESSION.isAdministrator eq "Yes")>
							<td class="labelmedium">
							<img src="#SESSION.root#/Images/select4.gif"
						     alt=""
						     border="0"
						     align="absmiddle">
							 <cfif flow.recordcount eq "0">
							 Submit for deployment
							<cfelse>
							 Resubmit for deployment
							</cfif>
							</td>
							<td>&nbsp;&nbsp;<input type="checkbox" class="radiol" name="operational" id="operational" value="1" onclick="showaction()"></td>
							<td>&nbsp;&nbsp;<input style="width:200px" class="hide" type="submit" name="status" id="status" value ="Submit"></td>
						</cfif>	
						
					<cfelseif Line.Operational eq "1">
					
						<!--- sync can only be done on a master server and only if there is a completed workflow or no workflow at all --->
						<cfif wfstatus eq "No">	
							<td id="sync" style="padding-left:20px">
							<cf_UIToolTip tooltip="Distribute this published report again to all local production sites">
							<input style="width:200px" type="button" onclick="syncreport('#line.controlid#')" name="sync" id="sync" class="button10g" value="Synchronize Again">
							</cf_UIToolTip>
							&nbsp;							
							</td>
							
						</cfif>	
						<td class="labelmedium">Set to status : <font color="FF0000"><b>Under Development</b></td>
						<td>&nbsp;&nbsp;<input type="checkbox" class="radiol" name="operational" id="operational" value="0" onclick="showaction()"></td>
						<td>&nbsp;&nbsp;<input style="width:120px" class="hide" type="submit" name="status" id="status" value ="Submit"></td>
						

						
						
					</cfif>	
					
				<cfelse>	
					
					<!--- production version --->
									
					<td>
					<table cellspacing="0" cellpadding="0"><tr>
					<td class="labelit"><font color="808000">Production Instance:</td>
					<td>&nbsp;</td>
					<td><input 
					 type="radio" 
					 name="operational" 
					 id="operational"
					 onclick="ColdFusion.navigate('RecordUpdate.cfm?controlid=#Line.ControlId#&operational=1','set')"
					 value="1" <cfif line.operational eq "1">checked</cfif>></td>
					<td class="labelit">Activated</td>
					<td>&nbsp;</td>
					<td><input 
					    type="radio" 
						name="operational" id="operational"
						 onclick="ColdFusion.navigate('RecordUpdate.cfm?controlid=#Line.ControlId#&operational=0','set')"
						value="0" <cfif line.operational eq "0">checked</cfif>></td>
					<td class="labelit">Disabled</td>
					<td id="set" class="hide"></td>
					</tr>
					</table>
									
				</cfif>
				
				<td>
				
			</cfif>	
			</td>
			</tr></table>
			</td>
			
		 </tr>	
		 
	 </cfif>
		 
	</table>
	</td></tr>
	
</cfoutput>	