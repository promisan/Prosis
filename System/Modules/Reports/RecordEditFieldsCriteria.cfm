<cfoutput>


	<table width="96%" border="0" cellspacing="0" align="center" class="formpadding">
	
		<tr><td height="3"></td></tr>		
		<tr class="line"><td colspan="8" style="height:45px;font-size:23px;font-weight:200" class="labelmedium">Report Data Preparation Settings</font></td></tr>
		
		<tr><td height="3"></td></tr>			
		
		<tr><td colspan="8"><table width="100%">								
		<TR>
		
		<TD class="labelit">Data Preparation:</TD>
		
		<td class="labelit">
		
	  	  <cfoutput>
		  
		  <script language="JavaScript">
			
			function trigger(val) {
			se1 = document.getElementById("trigger1")
			se2 = document.getElementById("trigger2")
			
			if (val == "SQL.cfm") { 
			  se1.className = "regular";
			  se2.className = "regular";
			} else {
		   	  se1.className = "hide";
			  se2.className = "hide";
			}
			}  
			
		  </script>
		  
		  <cfif Line.ReportRoot eq "Application">
		 	<cfset rt = SESSION.rootPath>
		  <cfelse>
		    <cfset rt = SESSION.rootReportPath>
		  </cfif>
		  
		  <cfif FileExists("#rt#\#Line.ReportPath#\SQL.cfm")>
		
			  <cfif Line.Operational eq "1">
			  
			  #Line.TemplateSQL#
			  
			  <cfelse>
			  	
			  <select name="templatesql" id="templatesql" class="regularxl" onChange="javascript:showsql(this.value); trigger(this.value)">
			    <option value="SQL.cfm" <cfif Line.TemplateSQL eq "SQL.cfm">selected</cfif>>SQL script</option>
				<option value="Application" <cfif Line.TemplateSQL eq "Application">selected</cfif>>Application (Tag Generated)</option>
			    <option value="External" <cfif Line.TemplateSQL eq "External">selected</cfif>>External (NOVA only)</option>
				<option value="" <cfif Line.TemplateSQL eq "">selected</cfif>>N/A (use for existing datasets)</option>
			  </select>  
			  
			  </cfif>
			  
			  <cfif Line.TemplateSQL eq "SQL.cfm">
			     <cfset cl = "regular">
			  <cfelse>
			      <cfset cl = "hide">
			  </cfif>
			 							  	  
			 <img src="#SESSION.root#/Images/locate3.gif"
			     alt="View SQL script"
			     name="sql0"
			     id="sql0"
			     width="14"
			     height="14"
			     border="0"
			     align="absmiddle"
			     class="#cl#"
			     style="cursor: pointer; border: 0pt solid silver;"
			     onClick="sql('#Line.ControlId#')"
			     onMouseOver="document.sql0.src='#SESSION.root#/Images/button.jpg'"
			     onMouseOut="document.sql0.src='#SESSION.root#/Images/locate3.gif'">
				 								 
		  <cfelse>
		  
		   <cfif Line.Operational eq "1">
			  
			  <cfif Line.TemplateSQL eq ""><b>N/A (use for existing datasets)</b><cfelse>#Line.TemplateSQL#</cfif>
			  
			<cfelse>  
		     	  
		    <select name="templatesql" id="templatesql" class="regularxl" onchange="javascript:trigger(this.value)">
			    <option value="SQL.cfm" <cfif Line.TemplateSQL eq "SQL.cfm">selected</cfif>>SQL script</option>
			    <option value="External" <cfif Line.TemplateSQL eq "External">selected</cfif>>External (NOVA only)</option>
				<option value="Application" <cfif Line.TemplateSQL eq "Application">selected</cfif>>Application (Tag generated)</option>
			    <option value="" <cfif Line.TemplateSQL eq "">selected</cfif>>N/A (existing datasets)</option>
			  </select>  
			  
			 </cfif> 
		  	    	 
		  </cfif>
		  </cfoutput>
		  
		  </td>
		  
		  <cftransaction></cftransaction>
		  
		  <TD class="labelit">SQL: READ_UNCOMMITTED:</TD>
		
		  <td class="labelit">
		  
		      <cfif Line.Operational eq "1">
				  
				  	<b><cfif Line.TemplateSQLIsolation eq "1">READ_UNCOMMITTED<cfelse>Standard</cfif>
				  
			  <cfelse>
			  
				  <input type="checkbox" class="radiol" name="TemplateSQLIsolation" id="TemplateSQLIsolation" value="1" <cfif Line.TemplateSQLIsolation eq "1">checked</cfif>>
				 				  
			  </cfif>
		  		  
		  </td>		   
		   		  
		  <cftry>
		  
			  <cfquery name="Source" 
				datasource="AppsSystem" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
			  	  	SELECT DISTINCT DataSource
			    	FROM stUpload
			  </cfquery>
			  
			  <cfif Source.recordcount neq "0">
			  	  
				  <td class="labelit">Source:</td>
				    
				  <td align="center">
				  
				  <cfif Line.Operational eq "1">
				  
				  	<b><cfif Line.DataSource neq "">#Line.DataSource#<cfelse>N/A</cfif>
				  
				  <cfelse>
				 			 
				      <select name="DataSource" id="DataSource"  class="regularxl">
					    <option value="">
						<cfloop query="Source">
						  <option value="#DataSource#" <cfif Line.DataSource eq "#DataSource#">selected</cfif>>#DataSource#
						</cfloop>
					  </select>
				  
				  </cfif>
				  	  
				  </td>
				  
			  <cfelse>	  
			  
			 	 <td width="1"></td>
				 <td width="1"></td>
			  
			  </cfif>
		  
		  <cfcatch></cfcatch>
		  
		  </cftry>
		  
		  <cfif Line.TemplateSQL eq "SQL.cfm">
			  <cfset tr = "regular">
		  <cfelse>
			  <cfset tr = "hide">
		  </cfif>
		  
		  <TD class="labelit" style="cursor:pointer"><cf_UIToolTip tooltip="Define the datasource in which the SQL.cfm store the temp tables. The depends on the datasource used in the SQL.cfm">Query Datasource:</cf_UIToolTip></TD>
			
		  <td class="labelit">	
		  					
		    <cfif Line.Operational eq "1">
		   			
					<b>#Line.TemplateUserQuery#</b>
					
			<cfelse>		

						<!--- Get "factory" --->
						<CFOBJECT ACTION="CREATE"
						TYPE="JAVA"
						CLASS="coldfusion.server.ServiceFactory"
						NAME="factory">
						<!--- Get datasource service --->
						<CFSET dsService = factory.getDataSourceService()>												
						<cfset dsNames   = dsService.getNames()>
						<cfset ArraySort(dsnames, "textnocase")> 						
						
						<cfselect name="TemplateUserQuery" class="regularxl"
						tooltip="Define the datasource in which the SQL.cfm store the temp tables (answerNN, tableNN.<br> This is determined based on the datasource used in the SQL.cfm. <br> Defining the data source will shield your report from Datawarehouse server outage. <p><b>Define only if you are absolutely certain otherwise select Multiple Stores.">
							
							<option value="" selected >Multiple stores</option>
							
							<CFLOOP INDEX="i"
								FROM="1"
								TO="#ArrayLen(dsNames)#">
								
								<cfif findNoCase("appsQuery","#dsNames[i]#")>
							
									<CFOUTPUT>
									<option value="#dsNames[i]#" <cfif Line.TemplateUserQuery eq "#dsNames[i]#">selected</cfif>>#dsNames[i]#</option>
									</cfoutput>
								
								</cfif>
							
							</cfloop>
							
						</cfselect>
					
						
						<input type="hidden" name="TemplateType" id="TemplateType" value="#Line.TemplateType#" readonly>
			</cfif>
						
		  </td>	 	  
		 		  
		  <TD class="labelit #tr#" id="trigger1" style="cursor:pointer"><cf_UIToolTip tooltip="Enable option to define Parameters as a condition Parameter. <br>Refer to the Reporting Framework  manual for usage.">Condition:</cf_UIToolTip></TD>
		  
		  <td class="labelit #tr#" id="trigger2">
		  
			  <cfif Line.Operational eq "1">
				  
				  	<b><cfif Line.TemplateCondition eq "1">Enabled<cfelse>Disabled</cfif>
				  
			  <cfelse>
			  
				  <input type="checkbox" class="radiol" name="TemplateCondition" id="TemplateCondition" value="1" <cfif #Line.TemplateCondition# eq "1">checked</cfif>>
				  <cfif Line.TemplateCondition eq "1">
				   <cfif not #FileExists("#SESSION.rootPath#\#Line.ReportPath#\Event.cfm")#>
					   <b><font color="FF0000"> Event.cfm not found!</b>
			   	   </cfif>
				  </cfif>
				  
			  </cfif>
		  	  
		  </td>
		  
		  </tr>
		  
		  </table></td></tr>		
		  
		  <cfif Line.TemplateSQL eq "SQL.cfm">
		  		  	  
			  <cfif Line.ReportRoot eq "Application" or Line.ReportRoot eq "">
				<cfset rootpath  = "#SESSION.rootpath#">
			  <cfelse>
				<cfset rootpath  = "#SESSION.rootReportPath#">
			  </cfif>
		  
			  <cf_fileVerifyN
			    Root      = "#RootPath#"
			    Directory = "#Line.ReportPath#"
				File      = "#Line.templateSQL#"
				Timestamp = "#Line.TemplateSQLDate#">
			  
			  <cfif FileStatus eq "Changed">
			 		 	  
			     <tr><td height="3" colspan="8"></td></tr>
			     <tr><td colspan="8" bgcolor="e4e4e4"></td></tr>
				 <tr><td height="3" colspan="8"></td></tr>
			     <tr>
			  	     <td colspan="8" class="labelit">
					  <cf_distributer>
					  <font color="FF0000"><img src="#SESSION.root#/Images/warning.gif" alt="" border="0" align="absmiddle"> Template modified on: <b>#FileStamp#</b>. 
					   <cfif master eq "1">
						   <cfif WorkFlow.Recordcount gte "1">
						  	 A new instance was created.
						   <cfelse>
						   	 Status was reset!
						   </cfif>
					   </cfif>
					   </b>
					 </td>	  
				 </tr>		
				 		
			  </cfif>
		  
		  </cfif>
		  
		<tr><td height="8"></td></tr>		
		<tr class="line"><td colspan="8" class="labelit"><font color="b0b0b0">Report Criteria Selection Settings and Fields</font></td></tr>
		
		<tr><td height="4"></td></tr>	
		
		<TR class="line">
		    <TD height="23" class="labelit"><font color="800040">Criteria Selection Mode:</TD>
			<TD colspan="7"><table width="100%" cellspacing="0"  cellpadding="0">
			<tr><td class="labelmedium">
			
			<cfif line.operational eq "0">
			
				<input type="radio" class="radiol" name="TemplateMode" id="TemplateMode" value="none" onClick="toggleP('none')" 
				<cfif Line.TemplateMode eq "none" or Line.TemplateMode eq "">checked</cfif>>&nbsp;No parameters
				&nbsp;&nbsp;<input type="radio" class="radiol" name="TemplateMode" id="TemplateMode" value="table" onClick="toggleP('criteria')" 
				<cfif Line.TemplateMode eq "table">checked</cfif>>&nbsp;Selection parameters			
			
			<cfelse>
			
				<cfif Line.TemplateMode eq "table">Structured parameters</cfif>
			
			</cfif>
			
			</td>
			<td align="right"><!--- empty --->
			
			
			</td></tr></table>
			</TD>
		</TR>			  
						
				
		<TR class="line">
				
				<td class="labelit">
					<cfoutput>
				
				<button name="aboutreport1"
			        id="aboutreport1"
			        type="button"
			        class="button10g"
					style="width:200px;height:30px"			       
			        onClick="schedule('#Line.controlId#','HTML')">
					<img src="#SESSION.root#/Images/status_overview.gif" align="absmiddle" alt="" border="0">
					Test Interface
				</button>
					
				</cfoutput>
				</td>
				
				<td style="cursor:pointer" class="labelit"><cf_UIToolTip  tooltip="Render the user interface with a maximum number of colums in the selection grid">Criteria Grid Columns:</cf_UIToolTip></td>
				<td class="labelit">
				<cfif Line.Operational eq "1">
				#Line.TemplateBoxes#
				<cfelse>
				<input type="Text" class="regularxl" style="text-align: center;" name="TemplateBoxes" id="TemplateBoxes" value="<cfoutput>#Line.TemplateBoxes#</cfoutput>" range="1,4" message="Please define the number of boxes accross" validate="integer" required="Yes" size="1" maxlength="1">														
				</cfif>		
				</td>
				
				<td colspan="5" align="right">
				
				<table border="0" height="25" rules="none" cellspacing="0" class="formpadding">
				<tr><td class="labelit">Settings:&nbsp;</td>
				
			    <TD class="labelit" style="padding-right:4px;cursor:pointer"><cf_UIToolTip tooltip="Allow users to subscribe to VIEWs prepared for this report under modality of ATTACHMENT. <br>Refer to the Reporting Framework manual for usage.">Attachment Subscription:</cf_UIToolTip></TD>
			    <td class="labelit">
				  	  <cfif Line.Operational eq "xxx">
						  	<b><cfif Line.EnableAttachment eq "1">Yes<cfelse>No</cfif>
					  <cfelse>
						  <input type="checkbox" class="radiol" name="EnableAttachment" id="EnableAttachment" value="1" <cfif Line.EnableAttachment eq "1">checked</cfif>>
					  </cfif>				  	  
			    </td>	
				<td style="width:30px"></td>			   										
					
				<td class="labelit" style="padding-right:4px"><cf_UIToolTip tooltip="Show/Hide the backbutton for this report in the interface">Enable <b>BACK</b> Button:</cf_UIToolTip></td>
				<td align="right" class="labelit">
		  
					  <cfif Line.Operational eq "xxx">
						  
						  	<b><cfif Line.EnableButtonBack eq "1">Yes<cfelse>No</cfif>
						  
					  <cfelse>
					  
						  <input type="checkbox" class="radiol" name="EnableButtonBack" id="EnableButtonBack" value="1" <cfif Line.EnableButtonBack eq "1">checked</cfif>>
						 			  
					  </cfif>
					  	  
				</td>
				
				</tr>
				</table>
				
				</td>
									
			</tr>	
										
			<cfoutput>		
		
		
		<tr id="criteria" class="<cfif #Line.TemplateMode# eq 'table'>regular<cfelse>hide</cfif>">
		
			 <td colspan="8">		
			 			 		 
			   <iframe id="icrit" name="icrit" width="100%" 
			     height="100" marginwidth="0" marginheight="0" hspace="0" vspace="0" align="left" frameborder="0" scrolling="no"></iframe>
				 
			   <cf_loadpanel 
				   id="icrit"
				   template="Criteria.cfm?id=#URL.ID#&status=#op#">
		
			</td>
		</TR>
				
		<tr><td height="4"></td></tr>	
		<tr><td align="center" colspan="8">
	 			  
	    <cfif Line.Operational eq "0">
				   
		    <input class="button10g" type="submit" name="update" id="update" value ="Save report">
	        <input class="button10g" type="submit" name="update2" id="update2" value ="Save & close">
				
		<cfelse>	
				
			<cfquery name="Owner" 
			datasource="AppsSystem" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			    SELECT *
			    FROM Ref_SystemModule
				WHERE SystemModule = '#Line.SystemModule#'
			</cfquery>
	
			  <cfinvoke component="Service.Access"
				Method="system"
				Owner="#Owner.RoleOwner#"
				ReturnVariable="Access">					
								
				<cfif Access eq "ALL">
				    <input type="submit" name="delete" id="delete" value="Purge" class="button10s" style="width:100;height:23" onClick="javascript:return purge()">
				</cfif>
				
				<input class="button10s" style="width:100;height:23" type="submit" name="update3" id="update3" value ="Update">
							  
		</cfif>	
			
		</td></tr>
		<tr><td height="4"></td></tr>
		<tr><td height="1" colspan="8" class="line"></td></tr>	
		
		</cfoutput>
				
	</table>
		
</cfoutput>		