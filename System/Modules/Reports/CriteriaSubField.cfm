<cf_compression>

<cfparam name="URL.ID2" default="">
<cfparam name="URL.Status" default="0">
<cfparam name="URL.Multiple" default="0">

<cfif url.table eq "" or url.keyfld eq "">

	<cfabort>

</cfif>

<cfquery name="Report" 
datasource="AppsSystem" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
    FROM  Ref_ReportControl
	WHERE ControlId    = '#URL.ID#'
</cfquery>

<cfquery name="Criteria" 
datasource="AppsSystem" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
    FROM  Ref_ReportControlCriteria
	WHERE ControlId    = '#URL.ID#'
	AND   CriteriaName = '#URL.ID1#'
</cfquery>

<cfquery name="Mission" 
datasource="AppsOrganization" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
  SELECT  *
  FROM    Ref_Mission
</cfquery>

<!--- correction --->

<cfquery name="Check" 
datasource="AppsSystem" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
    FROM  Ref_ReportControlCriteriaField
	WHERE ControlId    = '#URL.ID#'
	AND   CriteriaName = '#URL.ID1#'
	AND   FieldOrder   = '99'
</cfquery>

<cfif Check.FieldName neq url.keyfld>

		<cfquery name="Delete" 
			datasource="AppsSystem" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			    DELETE FROM  Ref_ReportControlCriteriaField
				WHERE ControlId  = '#URL.ID#'
				AND   CriteriaName = '#URL.ID1#'
				AND   FieldName    = '#Check.FieldName#'	
				AND   FieldOrder = '99'				
		</cfquery>		
		
		<cftry>
		
		<cfquery name="Insert" 
		     datasource="AppsSystem" 
		     username="#SESSION.login#" 
		     password="#SESSION.dbpw#">
		     INSERT INTO Ref_ReportControlCriteriaField 
		         (ControlId,
				 CriteriaName,
				 FieldName,
				 FieldSorting,				
				 <cfif URL.Multiple eq "0">
				 FieldDisplay,
				 <cfelse>
				 FieldDescription,
				 </cfif>
				 FieldOrder,
				 Operational)
		      VALUES ('#URL.ID#',
				  '#URL.ID1#', 
		      	  '#url.keyfld#',
				  '#url.keyfld#',
				  <cfif URL.Multiple eq "0">
					 '#url.keyfld#',
				  <cfelse>
					 '#url.keyfld#',
				  </cfif>
				  '99',
				  '1') 
		</cfquery>		
		
		<cfcatch></cfcatch>
		
		</cftry>
		
</cfif>			

<cfquery name="Detail" 
datasource="AppsSystem" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
    FROM  Ref_ReportControlCriteriaField
	WHERE ControlId = '#URL.ID#'
	AND CriteriaName = '#URL.ID1#'
	ORDER By FieldOrder
</cfquery>

<cftry>

<cfquery name="FieldNames" 
datasource="#url.ds#">
   SELECT   TOP 1  *
   FROM    #URL.table#
 </cfquery>	

	<cfcatch> 
	
		Alert : Problem with lookup table
		<cfabort>
	
	 </cfcatch>

</cftry>

<cfset submitlink = "CriteriaSubFieldSubmit.cfm?Status=#URL.Status#&ID=#URL.ID#&ID1=#URL.ID1#&ID2=#URL.ID2#&table=#URL.table#&multiple=#URL.Multiple#&ds=#url.ds#">

	<table width="97%" align="left">
	    
	  <tr>
	    <td width="100%">
		
	    <table width="100%" class="formpadding">
			
	    <TR>
		   <td width="20"></td>
		   <td width="30%" class="labelit">Value Field</td>
		   <td width="40%" class="labelit">Display Field</td>
		   <td width="10%" class="labelit">Select</td>
		   <td width="10%" class="labelit">Tree</td>		 
		   <td width="30" colspan="2" style="cursor:pointer" class="labelit">
		   
		     <cfif (URL.Status eq "0" or SESSION.isAdministrator eq "Yes") and (URL.Multiple eq "1" or URL.Multiple eq "0" and detail.recordcount lte "2")>
			 <cfoutput>
			 <div onClick="ptoken.navigate('CriteriaSubField.cfm?Status=#URL.Status#&ID=#URL.ID#&ID1=#URL.ID1#&ID2=new&table=#URL.table#&Multiple=#URL.Multiple#&ds=#url.ds#&keyfld=#url.keyfld#','isubfield')">			 
		     <A>Add</a>
			 </div>
			 </cfoutput>
			 </cfif>
				 
		   </td>
	    </TR>	
		<tr><td colspan="7" class="linedotted"></td></tr>
	
		<cfoutput>
		<cfloop query="Detail">
				
			<cfset nm = FieldName>
			<cfset de = FieldDescription>
			<cfset op = Operational>
													
			<cfif URL.ID2 eq nm>
					
			    <input type="hidden" name="fieldname" id="fieldname" value="<cfoutput>#Detail.FieldName#</cfoutput>">
				
				<cfif operational eq "0">
					<cfset cl = "fafafa">
				<cfelseif fieldorder eq "99">
					<cfset cl = "ffffcf">
				<cfelse>
				   	<cfset cl = "ffffff">
				</cfif>
																	
				<TR>
				     <td align="center">#FieldOrder#.</td>
					 <td align="center" colspan="6">
					 		
								<table width="99%"
							       border="1"
							       align="center"
							       bordercolor="C0C0C0"
							       bgcolor="F4FBFD"
								   class="formpadding">
												
								<TR>
								
								<cfif fieldorder neq "99">
								
									<td class="labelit">Position:</td>
									<td>
									     <cfoutput>
										    <input type="Text" 
											  name="fieldorder" 
											  id="fieldorder"
											  value="#FieldOrder#" 
											  style="width:16;text-align: center;" 
											  required="Yes" 
											  maxlength="1">
										  </cfoutput>
									</td>
								
								<cfelse>
									<td>
									&nbsp;<img src="#SESSION.root#/Images/key1.gif" height="12" width="12" alt="" border="0" align="absmiddle">
									</td>									
									<td></td>
									<input type="hidden" name="fieldorder" id="fieldorder" value="99">
								
								</cfif>
																
								<td style="cursor: pointer;" class="labelit"><cf_UIToolTip
								tooltip="Only if selected Lookup table = 'dbo.Organization' you may filter the selection fields with a mission acronym <br> to which the user has been granted role/group access for this report">
								<img src="#SESSION.root#/Images/help2.gif" align="absmiddle" alt="" border="0">Tree Authorization:
								</cf_UIToolTip>
								</td>
								
								<td>			
								
								<cfif Criteria.lookuptable neq "Organization">
								 <cfset dis = "disabled">
								<cfelse>
								 <cfset dis = ""> 
								</cfif>
								
								<select name="lookupunittreesel" id="lookupunittreesel" #dis#>
									<option value="None" selected>None</option>
									<cfloop query="Mission">			
										<option value="#Mission#" <cfif Detail.LookupUnitTree eq Mission>selected</cfif>>#Mission#</option>
									</cfloop>
								</select>
								
								</td>	
								
								</tr>
								
								<tr>
								
									<td class="labelit">Field content:</td>
									<td height="20" colspan="1"><b>#fieldname#
										<input type="hidden" name="fieldname" id="fieldname" value="#fieldname#">
									</td>
									
									<cfif fieldorder eq "99">
									
										<td class="labelit">Show as SELECT:</td>
										<td>
										<input type="checkbox" name="suboperational" id="suboperational" value="1" <cfif operational eq "1">checked</cfif>>
										</td>	
										
									<cfelse>
									<td class="labelit">Operational:</td><td>
									
									<input disabled type="checkbox" name="suboperational" id="suboperational" value="1" checked>	
									</td>
									
																		
									</cfif>						
																
								</tr>
								
								<tr>
								
								<td class="labelit">Field sorting:</td>
								
								<td colspan="3">
								  <select name="fieldsorting" id="fieldsorting" style="width:230px">
																		  
									  	  <option value="" selected>--Same as Content Field--</option> 
										  <cfloop index="col" list="#FieldNames.columnList#" delimiters=",">
										  			  
										  <cfquery name="Check" 
											datasource="AppsSystem" 
											username="#SESSION.login#" 
											password="#SESSION.dbpw#">
											SELECT *
										    FROM  Ref_ReportControlCriteriaField
											WHERE ControlId = '#URL.ID#'
											AND CriteriaName = '#URL.ID1#'
											AND FieldSorting = '#col#' 
										  </cfquery>
										 
										  	<cfif Check.recordcount eq "0">
										  		  <option value="#col#" <cfif col eq fieldsorting>selected</cfif>>#col#</option> 
											</cfif>  
											
										  </cfloop>
										  
									 	 </select>
								</td>
								
								</tr>
								
								<tr>
								
								<td class="labelit">Field display:</td>
								
								<td colspan="3">
								
								<table>
								<tr><td>
								
								<select name="fielddisplay" id="fielddisplay" style="width:230px">
								
										<option value="" selected>--Same as Content Field--</option> 
									 
										  <cfloop index="col" list="#FieldNames.columnList#" delimiters=",">
										  			  
											  <cfquery name="Check" 
												datasource="AppsSystem" 
												username="#SESSION.login#" 
												password="#SESSION.dbpw#">
												SELECT *
											    FROM   Ref_ReportControlCriteriaField
												WHERE  ControlId        = '#URL.ID#'
												AND    CriteriaName     = '#URL.ID1#'
												AND    FieldDescription = '#col#' 
											  </cfquery>
											 
											  <cfif Check.recordcount eq "0">
											  	  <option value="#col#"  <cfif col eq fielddisplay>selected</cfif>>#col#</option> 
											  </cfif>  
											
										  </cfloop>
									
								</select>
								
								</td>
								<td>&nbsp;</td>
								<td><cf_UIToolTip  tooltip="Show code code and display field in the lookup">Incl. Code:</cf_UIToolTip></td><td>
									
									<cfif codeindisplay eq "1">
									<input type="checkbox" name="codeindisplay" id="codeindisplay" value="1" checked>	
									<cfelse>
									<input type="checkbox" name="codeindisplay" id="codeindisplay" value="1">
									</cfif>
									</td>
								
								</tr>
								
								</table>
								
								</td>
								</tr>
																																
								<cfif URL.Multiple eq "0">
									<input type="hidden" name="fielddescription" id="fielddescription" value="#FieldDescription#">
								<cfelse>
									<tr>
									<td class="labelit">Label:</td>
									<td colspan="3">
								    <input type="Text" name="fielddescription" id="fielddescription" value="#FieldDescription#" required="Yes" size="40" maxlength="40">								   
									</td>
									</tr>
								</cfif>  	
								
								<tr>
								<td class="labelit"><cf_UIToolTip  tooltip="Selection mode">Select Multiple:</cf_UIToolTip></td>
								<td>
								
									<table cellspacing="0" cellpadding="0"><tr><td>				
									<input type="radio" name="lookupmultipleselect" id="lookupmultipleselect" value="1" onclick="document.getElementById('lookupmultiple').value=1" <cfif lookupmultiple eq "1">checked</cfif>>
									</td>
									<td class="labelit">Multiple</td>
									<td>&nbsp;</td>
									<td>
									<input type="radio" name="lookupmultipleselect" id="lookupmultipleselect" value="0" onclick="document.getElementById('lookupmultiple').value=0" <cfif lookupmultiple eq "0">checked</cfif>>
									</td>
									<td class="labelit">One (1)</td>
									
									</tr>		
									</table>	
									
									</td>
									 <input type="hidden" name="lookupmultiple" id="lookupmultiple" value="#lookupmultiple#">
								</tr>				
								
								<tr>
								<td>
					
								<cf_UIToolTip tooltip="So the developer may define a field as global which will limit the content of the select boxes.">
								<img src="#SESSION.root#/Images/help2.gif" align="absmiddle" alt="" border="0">&nbsp;Filter global:
								</cf_UIToolTip>
								
								</td>
								
								<td colspan="3">
													
									<select name="fieldglobal" id="fieldglobal" style="width:230px">
									  <cfoutput>
									  									  
									  	  <cfquery name="Global" 
											datasource="AppsSystem" 
											username="#SESSION.login#" 
											password="#SESSION.dbpw#">
												SELECT R.*
											    FROM   Ref_ReportControlCriteria R, Ref_ReportControl A
												WHERE  A.ControlId = R.ControlId
												AND    SystemModule = '#Report.SystemModule#'
												AND    FunctionClass = 'System'								
										  </cfquery>
										  
										  <option value="">---n/a---</option>
									  						  
										  <cfloop query="Global">
										  								
											  	  <option value="#CriteriaName#" <cfif detail.fieldGlobal eq CriteriaName>selected</cfif>>#CriteriaName#</option> 
																			
										  </cfloop>
									  </cfoutput>
									</select>
																
								</td>
								
								</tr>
								 								
								<tr><td height="1" colspan="4" class="linedotted"></td></tr>
								
								<tr>
																
								 <td colspan="4" align="center">			   
				   
								   <input type="button" 
								   value="Update" 
								   style="width:100px"
						   		   onclick="ColdFusion.navigate('#submitlink#&operational='+suboperational.checked+'&fieldname='+fieldname.value+'&fieldsorting='+fieldsorting.value+'&fielddisplay='+fielddisplay.value+'&codeindisplay='+codeindisplay.checked+'&fielddescription='+fielddescription.value+'&lookupunittree='+lookupunittreesel.value+'&fieldorder='+fieldorder.value+'&lookupmultiple='+document.getElementById('lookupmultiple').value+'&fieldglobal='+fieldglobal.value+'&keyfld=#url.keyfld#','isubfield')">
							   	
								</td>
																    
								</TR>	
								
								</table>
				
								 
					 </td>
					
				   
			    </TR>	
						
			<cfelse>
			
				<cfif operational eq "0">
					<cfset cl = "f4f4f4">
				<cfelseif fieldorder eq "99">
					<cfset cl = "ffffcf">
				<cfelse>
				   	<cfset cl = "ffffff">
				</cfif>
			
				<TR bgcolor="#cl#">
				   <td height="20" align="center" class="labelit">
				   <cfif fieldorder eq "99">
				   <img src="#SESSION.root#/Images/key1.gif" height="12" width="12" alt="" border="0">
				   <cfelse>#FieldOrder#.</cfif></td>
				   <td class="labelit">
				     <cfif URL.Status eq "0" or SESSION.acc eq "AdministratorX">
				     <A href="javascript:ColdFusion.navigate('CriteriaSubField.cfm?Status=#URL.Status#&ID=#URL.ID#&ID1=#URL.ID1#&ID2=#nm#&table=#URL.table#&Multiple=#URL.Multiple#&ds=#url.ds#&keyfld=#url.keyfld#','isubfield')">
					      #FieldName#
					 </a>
					 <cfelse>
					  #FieldName#
					</cfif>
					
				   </td>
				   
				   <td class="labelit">
				     <cfif fieldorder neq "99">
					     <cfif URL.Status eq "0" or SESSION.acc eq "AdministratorX">
					     <A href="javascript:ColdFusion.navigate('CriteriaSubField.cfm?Status=#URL.Status#&ID=#URL.ID#&ID1=#URL.ID1#&ID2=#nm#&table=#URL.table#&Multiple=#URL.Multiple#&ds=#url.ds#&keyfld=#url.keyfld#','isubfield')">
						      #FieldDisplay#
						 </a>
						 <cfelse>
						  #FieldDisplay#
						</cfif>
					</cfif>
					</td>
				   <td class="labelit"><cfif fieldorder neq "99">
				       	<cfif lookupmultiple eq "1">Multiple<cfelse>Single</cfif>
					   </cfif></td>	
				   <td class="labelit"> <cfif fieldorder eq "1"> #lookupunittree#</cfif></td>
				  
				   <td align="right" class="labelit">
				     <cfif fieldorder neq "99"> 
					     <cfif URL.Status eq "0" or SESSION.acc eq "AdministratorX">
					    
						      <img onclick="ColdFusion.navigate('CriteriaSubField.cfm?Status=#URL.Status#&ID=#URL.ID#&ID1=#URL.ID1#&ID2=#nm#&table=#URL.table#&Multiple=#URL.Multiple#&ds=#url.ds#&keyfld=#url.keyfld#','isubfield')" src="#SESSION.root#/Images/edit.gif" height="10" width="11" alt="Edit" border="0">
						
						 </cfif>
					 </cfif>
				   </td>
				   <td width="30" class="labelit">
				    <cfif (URL.Status eq "0" or SESSION.acc eq "AdministratorX") and fieldorder neq "99"> 
				        <img onclick="ColdFusion.navigate('CriteriaSubFieldPurge.cfm?Status=#URL.Status#&ID=#URL.ID#&ID1=#URL.ID1#&ID2=#nm#&table=#URL.table#&Multiple=#URL.Multiple#&ds=#url.ds#&keyfld=#url.keyfld#','isubfield')" src="#SESSION.root#/Images/delete5.gif" width="12" height="12" alt="Remove" border="0">
					
					</cfif>
				  </td>
				   
			    </TR>	
			
			</cfif>
		
							
		</cfloop>
		</cfoutput>
										
		<cfif URL.ID2 eq "new" and (URL.Status eq "0" or SESSION.acc eq "AdministratorX")>		
		
			<cfif (detail.recordcount lt "3" and url.multiple eq "0") or url.multiple eq "1">
											
				<tr><td colspan="7" bgcolor="white">
				
					<table width="100%" bgcolor="fafafa" bordercolor="silver" align="center" border="0" cellspacing="0" cellpadding="0" class="formpadding">
					<TR>
					
					<td class="labelit">Select Position:</td>
					
					<td>
					     <cfoutput>
					    <input type="Text" 
						  name="fieldorder" 
						  id="fieldorder"
						  value="#Detail.recordcount#" 
						  style="width:16;text-align: center;" 
						  required="Yes" 
						  maxlength="1">
						  </cfoutput>
					</td>
					
					<td class="labelit">Tree Authorization:</td>
					
					<td>	
					
					<cfif Criteria.lookuptable neq "Organization">
					 <cfset dis = "disabled">
					<cfelse>
					 <cfset dis = ""> 
					</cfif>		
					
					<select name="lookupunittreesel" id="lookupunittreesel" #dis#>
						<option value="None" selected>None</option>
						<cfoutput query="Mission">			
						<option value="#Mission#">#Mission#</option>
						</cfoutput>
					</select>
					
					</td>	
					
					</tr>
					
					<tr>
					
					<td class="labelit">Field name content:</td>
					
					<td colspan="3">
					  <select name="fieldname" id="fieldname" style="width:230px">
						  <cfoutput>
						  
							  <cfloop index="col" list="#FieldNames.columnList#" delimiters=",">
							  			  
							  <cfquery name="Check" 
								datasource="AppsSystem" 
								username="#SESSION.login#" 
								password="#SESSION.dbpw#">
								SELECT *
							    FROM  Ref_ReportControlCriteriaField
								WHERE ControlId = '#URL.ID#'
								AND CriteriaName = '#URL.ID1#'
								AND FieldName = '#col#' 
							  </cfquery>
							 
							  	<cfif Check.recordcount eq "0">
							  		  <option value="#col#">#col#</option> 
								</cfif>  
								
							  </cfloop>
							  
						  </cfoutput>
					  </select>
					</td>
					
					</tr>
					
					<tr>
					
					<td class="labelit">Field name sorting:</td>
					
					<td colspan="3">
					  <select name="fieldsorting" id="fieldsorting" style="width:230px">
						  <cfoutput>
						  
						  	  <option value="" selected>--Same as Content Field--</option> 
							  <cfloop index="col" list="#FieldNames.columnList#" delimiters=",">
							  			  
							  <cfquery name="Check" 
								datasource="AppsSystem" 
								username="#SESSION.login#" 
								password="#SESSION.dbpw#">
								SELECT *
							    FROM  Ref_ReportControlCriteriaField
								WHERE ControlId = '#URL.ID#'
								AND CriteriaName = '#URL.ID1#'
								AND FieldSorting = '#col#' 
							  </cfquery>
							 
							  	<cfif Check.recordcount eq "0">
							  		  <option value="#col#">#col#</option> 
								</cfif>  
								
							  </cfloop>
							  
						  </cfoutput>
					  </select>
					</td>
					
					</tr>
					
					<tr>
					
					<td class="labelit">Field name display:</td>
					
					<td colspan="3">
					
						<table cellspacing="0" cellpadding="0">
						<tr><td>
										
						<select name="fielddisplay" id="fielddisplay" style="width:230px">
						
							<option value="" selected>--Same as Content Field--</option> 
						  <cfoutput>
							  <cfloop index="col" list="#FieldNames.columnList#" delimiters=",">
							  			  
								  <cfquery name="Check" 
									datasource="AppsSystem" 
									username="#SESSION.login#" 
									password="#SESSION.dbpw#">
									SELECT *
								    FROM   Ref_ReportControlCriteriaField
									WHERE  ControlId        = '#URL.ID#'
									AND    CriteriaName     = '#URL.ID1#'
									AND    FieldDescription = '#col#' 
								  </cfquery>
								 
								  <cfif Check.recordcount eq "0">
								  	  <option value="#col#">#col#</option> 
								  </cfif>  
								
							  </cfloop>
						  </cfoutput>
						</select>
						
						<td>&nbsp;</td>
								<td><cf_UIToolTip  tooltip="Show code code and display field in the lookup">Incl. Code:</cf_UIToolTip></td><td>
									
									<cfif Check.codeindisplay eq "1">
									<input type="checkbox" name="codeindisplay" id="codeindisplay" value="1" checked>	
									<cfelse>
									<input type="checkbox" name="codeindisplay" id="codeindisplay" value="1">
									</cfif>
									</td>
						
						</td>
						
						</tr>
						</table>
					
					</tr>	
					
						<cfif URL.Multiple eq "0">
							<input type="hidden" name="fielddescription" id="fielddescription" value="">
						<cfelse>
						<tr>
							<td class="labelit">Field label:</td>
							<td colspan="3">
						    <input type="Text"   name="fielddescription" id="fielddescription" value="" required="Yes" size="40" maxlength="40">								   
							</td>
						</tr>	
						</cfif>  
					
					<tr>
						<td class="labelit"><cf_UIToolTip  tooltip="Selection mode">Select Multiple:</cf_UIToolTip></td>
						<td>
						  
						  <table cellspacing="0" cellpadding="0"><tr><td>				
							<input type="radio" name="lookupmultipleradio" id="lookupmultipleradio" value="1" onclick="document.getElementById('lookupmultiple').value=1">
							</td>
							<td class="labelit">Multiple</td>
							<td>&nbsp;</td>
							<td>
							<input type="radio" name="lookupmultipleradio" id="lookupmultipleradio" value="0" checked onclick="document.getElementById('lookupmultiple').value=0">
							</td>
							<td class="labelit">One (1)</td>
							</tr>		
						  </table>	
						  <input type="hidden" name="lookupmultiple" id="lookupmultiple" value="0">
						  
						</td>
					</tr>				
								
													
					<tr>
					
					<td class="labelit">Filter global:</td>
					
					<td colspan="3">
										
						<select name="fieldglobal" id="fieldglobal" style="width:230px">
						  <cfoutput>
						  
						  	  <cfquery name="Global" 
								datasource="AppsSystem" 
								username="#SESSION.login#" 
								password="#SESSION.dbpw#">
									SELECT R.CriteriaName
								    FROM   Ref_ReportControlCriteria R, Ref_ReportControl A
									WHERE  A.ControlId = R.ControlId
									AND    A.SystemModule = '#Report.SystemModule#'
									AND    A.FunctionClass = 'System'								
							  </cfquery>
			  							  
							  <option value="" selected>---n/a---</option>
						  						  
							  <cfloop query="Global">
							  								
								  	  <option value="#CriteriaName#">#CriteriaName#</option> 
																
							  </cfloop>
						  </cfoutput>
						</select>
										
					</td>
					
					</tr>
					
					<tr><td height="1" colspan="6" class="linedotted"></td></tr>
					
					<tr>
																   
					<td align="center" colspan="4">
					
					<cfoutput>
					<input type = "button" 
						value       = "Add Subquery Field" 				
						onclick     = "ColdFusion.navigate('#submitlink#&fieldname='+fieldname.value+'&fieldsorting='+fieldsorting.value+'&fielddisplay='+fielddisplay.value+'&codeindisplay='+codeindisplay.checked+'&fielddescription='+fielddescription.value+'&lookupunittree='+lookupunittreesel.value+'&fieldglobal='+fieldglobal.value+'&fieldorder='+fieldorder.value+'&lookupmultiple='+document.getElementById('lookupmultiple').value+'&keyfld=#url.keyfld#','isubfield')">
					</cfoutput>				
					</td>
													    
					</TR>	
					
					</table>
				
				</td></tr>
													
			</cfif>	
		
		</cfif>
			
		</table>
		
		</td>
		</tr>
				
		<tr><td height="2" colspan="5"></td></tr> 		
					
	</table>	
