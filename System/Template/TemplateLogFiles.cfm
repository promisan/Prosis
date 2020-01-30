
<cfif Listing.recordcount eq "0" and URL.site neq "">
	
	<table width="99%" align="center" border="0" cellspacing="0" cellpadding="0" class="formpadding">
	<tr>
	<td height="140" class="labelmedium" align="center"><font size="2" color="green">Good !, no more differences were detected <cfif url.group neq "">in <cfoutput><b>/#url.group#/</cfoutput></cfif></td>
	</tr>
	</table>
		
<cfelse>
		
	<table width="99%" align="center"  border="0" cellspacing="0" cellpadding="0" class="navigation_table">
						
	<cfset row = 0>
	<cfset srv = 0>	

	<cfoutput query="Listing" group="ApplicationServer">
	
		<cfset srv = srv+1>
	   		
		<cfparam name="URL.Version" default="">
		
		<cfquery name="Check" 
				datasource="AppsControl">
			    SELECT * 
				FROM   ParameterSiteVersion R
				WHERE  ApplicationServer = '#url.site#'				
		</cfquery>
		
		<cfif url.version eq "" and url.filter eq "0">
				
		<tr><td colspan="7" class="linedotted"></td></tr>
		
		<cfquery name="Master" datasource="AppsControl">
		      SELECT   * 
			  FROM     ParameterSite
			  WHERE    ServerRole = 'QA'
			  ORDER BY ServerRole
	  </cfquery>
		
		<tr>
		   <td height="25" colspan="7">
		   
		   <table width="100%" class="formpadding formspacing" cellspacing="0" cellpadding="0">
		   <tr><td class="labelit">
		     Comparison with MASTER &nbsp;<img src="#url.root#/Images/cf.png" alt="" align="absmiddle" border="0"> <b>#Master.ApplicationServer#</b> [#Master.ReplicaPath#]
		   </td>
			
			<!--- --------------------------------------------------------------- --->	  		
			<!--- generate distribution package, only for remote production sites --->
			<!--- --------------------------------------------------------------- --->	  	
						
		    <cfif ApplicationServer eq master.applicationServer 
					 and (Site.ServerRole eq "Production" and Site.ServerLocation neq "Local")
					 and (Site.VersionDate neq master.VersionDate or Check.recordcount eq "0")>
					 
					 <td>
					 	<input type="radio" name="distribution" id="distribution" value="0" <cfif url.distribution eq "0">checked</cfif> onClick="javascript:reload('0')">Report and Application files
						<input type="radio" name="distribution" id="distribution" value="1" <cfif url.distribution eq "1">checked</cfif> onClick="javascript:reload('1')">Only Application files&nbsp;
					 </td>
					 
					 <td align="right" style="padding-right:10px">
						  
						 <table cellspacing="0" cellpadding="0">
						 <tr><td id="prepare">   
					   
					        <input type  = "button" 
						        class   = "button10g" 
								name    = "Update" 
								id      = "Update"
								onclick = "distribute()"
								value   = "Prepare Distribution Package">
							
							</td>
						</tr>	
						</table>
							
					</td>		
							
			</cfif>		
			
			<!--- ----------------------------------------------------------------- --->	  		
			<!--- direct exchange only for local production sites and design server --->
			<!--- ----------------------------------------------------------------- --->	  	
										
		    <cfif ApplicationServer eq master.applicationServer 
					 and (Site.ServerRole eq "Design" or Site.ServerLocation eq "Local")
					 and SESSION.isAdministrator eq "Yes">
					 
					 <td align="right">					 
					    <input type="checkbox" name="confirm" id="confirm" value="yes" checked>&nbsp;Confirm each file&nbsp;
					 </td>
					 
					 <td align="right" style="padding-right:4px">	
					 
						 <cfif site.enableBatchUpdate eq "1">					 
							 <input type="button" 
						        class="button10g" 
								name="Update" 
								id="Update"
								style="width:230px"
								onclick="deploybatch('#url.group#')"
								value="Batch Deployment to #URL.site#">
						 </cfif>	
					 							
					</td>		
		    </cfif>
		   		   
		   </tr>
		   </table>
		   </td>
		   
		</tr>		
				
		</cfif>
						
		<cfoutput group="TemplateGroup">
					
		<tr>
		<td height="20" colspan="7">

			<table width="100%" cellspacing="0" cellpadding="0">
			<tr class="line"><td width="4"></td>
			
			<cfif url.group neq "">
			
				<td></td>
				
			<cfelse>
			
				<td width="10" valign="middle" style="padding-top:3px" onClick="javascript:show('#srv#_#TemplateGroup#')">
					
					<img src="#SESSION.root#/Images/icon_expand.gif"
				     alt="Expand"
				     id="#srv#_#TemplateGroup#_col"
				     border="0"
				     class="hide"
				     style="cursor: pointer;">
					 
					<img src="#SESSION.root#/Images/icon_collapse.gif"
				     alt="Collapse"
				     id="#srv#_#TemplateGroup#_exp"
				     border="0"
				     class="regular">
					 
				</td>
			
			</cfif>
			<td width="90%"
			 style="cursor: pointer;font-size:23px;" class="labellarge"
			 onClick="javascript:show('#srv#_#TemplateGroup#')">#TemplateGroup#</b></td>
			<td width="30" align="right" style="padding-right:4px">
			
			<cfif site.enableBatchUpdate eq "1"
			    and url.site neq master.applicationServer 
				and url.site neq "">	
			
					<input type="checkbox" 
						name="hdr#TemplateGroup#"
						id="hdr#TemplateGroup#"
						checked 
						onclick="selall(this.checked,'#TemplateGroup#')">								
			</cfif>
			
			</td>
			</table>
			
		</tr>	
					
		<tr><td colspan="7">
		
		<table width="100%" id="#srv#_#templategroup#" border="0" cellspacing="0" cellpadding="0">			
						
			<cfoutput group="PathName">
			
				<cfset space = "1">
				
				<cfif pathname neq "[root]">
					<tr bgcolor="f4f4f4" class="line">
					<td colspan="7" style="height:34px;color:gray;font-size:17px;padding-left:10px">
					<img src="#url.root#/Images/folder3.gif" 
					align="absmiddle" alt="" border="0">  
					#PathName#</td>
					</tr>
					
				</cfif>
				
				<cfoutput group="FileName">
				
					<cfset row = row+1>
					
					<cfif Comparison eq "Update: Master">
					
					    <cfset color = "E8E8D0">
						
					<cfelseif Operational eq "0">
					
						<cfset color = "ffffaf">
						
				    <cfelse>
								
						<cfquery name="Check" 
						datasource="AppsControl" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">
						    SELECT *
							FROM  SiteVersionReview
							WHERE ApplicationServer = '#Master.ApplicationServer#'
							AND VersionDate = '#dateformat(VersionDate,client.dateSQL)#'
							AND PathName = '#PathName#'
							AND FileName = '#FileName#'
						</cfquery>
						
						<cfif check.actionstatus eq "3">
							<cfset color = "C9F5D2">
						<cfelseif check.actionstatus eq "2">	
						    <cfset color = "yellow">
						<cfelseif check.actionstatus eq "1">		
						    <cfset color = "yellow">
						<cfelse>
						    <cfset color = "white">
						</cfif>
										
					</cfif>					
															
					<tr bgcolor="#color#" class="navigation_row labelit line" style="height:15px" id="line#templateid#">
					
					<td style="width:3%" style="padding-left:7px" align="right">#row#</td>
					
					<td align="right" style="width:3%;padding-top:5px;padding-left:7px">
					
					    <!--- ------------------------------------------- --->
					    <!--- show modification history in case of master --->
						<!--- ------------------------------------------- --->
						
						<cfif URL.site eq "">
						
						  <cf_img icon="expand" toggle="Yes" onclick="history('#TemplateId#','#currentRow#')">
						  
						 </cfif>
						 
					</td>
					
					<td width="80%" style="padding-left:7px">
					
					<cfif PathName neq "[root]">
					 <cfset path = pathName>
					<cfelse>
					 <cfset path = "">
					</cfif>
															
					<cfif binary(filename) eq "image">
					   <a href="#URL.root#/#path#/#FileName#" target="_blank">#fileName#</a>
					<cfelseif binary(filename) eq "yes">
						#filename#
					<cfelse>					
					  <a href="javascript:detail('#TemplateId#','#TemplateCompareId#')" title="view template content">#FileName#</a>
					</cfif>
					</td>
					<td width="120"><cfif TemplateModifiedBy eq "">Undefined<cfelse>#TemplateModifiedBy#</cfif><cfif space eq "1"><cf_space spaces="40"></cfif></td>
											
					<td width="120">#dateFormat(TemplateModified,CLIENT.DateFormatShow)# #timeFormat(TemplateModified,"HH:MM")#<cfif space eq "1"><cf_space spaces="40"></cfif></td>
					<td width="100" align="center">#numberformat(TemplateSize/1024,"_._")# Kb<cfif space eq "1"><cf_space spaces="25"></cfif></td>
						
					<cfif ApplicationServer eq master.applicationServer 
						 and (Site.serverrole eq "Design" or Site.ServerLocation eq "Local")
						
						 and operational eq "1"
						 and comparison neq "Update: Master">						 
						 
						 <!--- and SESSION.isAdministrator eq "Yes"  --->
						 
						 <td align="right" height="20" className="highlight">
						 
						 	<cfif space eq "1"><cf_space spaces="40"></cfif>
							
							<!--- ---------------------------------------------------------- --->
							<!--- allow for removal on master only the site is a design site --->
							<!--- ---------------------------------------------------------- --->
							
							<table width="100%"><tr>
							
							<td id="d#templateid#" width="30">
							 
							<cfif templatecompareid eq "" and Site.serverrole eq "Design">
							    
								 <img onclick="deletetemplate('#templateid#','1')" 
							        src="#SESSION.root#/Images/delete5.gif" height="14" width="14"
									alt="Remove This Template from master" 
									border="0" 
									align="absmiddle" 
									style="cursor: pointer;">
								
							</cfif>		
							
							</td> 
							
							<!--- ---------------------------------------------------------- --->
							<!--- -------select files for batch/single update--------------- --->
							<!--- ---------------------------------------------------------- ---> 
							
							<td id="u#templateid#">	
																												
								 <cfif url.site neq master.applicationServer and url.site neq "">
															
									 <cfif site.enableBatchUpdate eq "1">			
									      
											<input type="checkbox" 
												id="#TemplateGroup#" 
												name="templates" 
												checked
												onclick="hl(this,this.checked)" 
												value="#templateId#">								
									
									 <cfelse>
										 											 
										<cfif check.actionstatus eq "3">
									
											<!--- show deployment only once file has been reviewed --->
										   							   
										    <img onclick="deployclient('#templateId#','#TemplateCompareId#','#site.applicationserver#','#check.reviewid#')" 
										         src="#SESSION.root#/Images/refresh4.gif" 
												 alt="Deploy template on #site.applicationserver# with master copy." 
												 border="0" 
												 align="absmiddle" 
												 style="cursor: pointer;">&nbsp;								 
											<a href="javascript:deployclient('#templateId#','#TemplateCompareId#','#site.applicationserver#','#check.reviewid#')" 
											title="Deploy template on #site.applicationserver# with master copy.">Deploy</a>
											
										</cfif>
																									
								 	</cfif>	
								
								</cfif>	
							
							 </td>
													 	
							 <td>&nbsp;</td>
							 </tr>
							 </table>
							
						<cfelse>

						 <!--- added 8/5/2008 --->
						 <cfif comparison neq "remove">
						 	<td height="20" width="150" id="d#templateid#"> 	
						 <cfelse>
						 	<td height="20" width="150" id="d#templatecompareid#">
						 </cfif>
						 
					    </cfif>
						
					<cfif comparison eq "Not found in master">
						
						<cfif TemplateModified lt (now()-30)>
						  							
						   Not on Master [30+]
						   
						   	  <img onclick="inserttemplate('#templateid#','0')" 
						        src="#SESSION.root#/Images/portal_max.jpg" 
								alt="Add Template to master server" 
								border="0" 
								align="absmiddle" 
								style="cursor: pointer;">
							   
							 <img onclick="deletetemplate('#templateid#','0')" 
						        src="#SESSION.root#/Images/portal_min.jpg" 
								alt="Remove template from design" 
								border="0" 
								align="absmiddle" 
								style="cursor: pointer;">	   
											
						<cfelse>
						
						  Not on Master	
						
						 <img onclick="inserttemplate('#templateid#','0')" 
						        src="#SESSION.root#/Images/portal_max.jpg" 
								alt="Add template to master server" 
								border="0" 
								align="absmiddle" 
								style="cursor: pointer;">
								
						  <img onclick="deletetemplate('#templateid#','0')" 
						        src="#SESSION.root#/Images/portal_min.jpg" 
								alt="Remove template from design server" 
								border="0" 
								align="absmiddle" 
								style="cursor: pointer;">
															
						</cfif>
						
					<cfelseif comparison eq "remove">
					
						 <img onclick="deletetemplate('#templatecompareid#')" 
						        src="#SESSION.root#/Images/delete5.gif" 
								alt="File not present on master, press to remove (and log) template from #url.site#" 
								border="0" height="13" width="13"
								align="absmiddle" 
								style="cursor: pointer;">	
					
					</cfif>
					
					</td>		
					
					</tr>
					
					<cfif comparison eq "Update: Master">
					
						<cfquery name="Dev" 
						datasource="AppsControl">
						    SELECT   *
							FROM     Ref_TemplateContent RC 
							WHERE    ApplicationServer = '#URL.Site#'
							AND      PathName = '#PathName#'
							AND      FileName = '#FileName#'
					   </cfquery>
				   
					   <cfif dev.recordcount eq "1">
											
							<tr bgcolor="ffffdf">
							
							 <td align="center" colspan="2">#URL.Site#</td>													
							 <td><cfif dev.TemplateModifiedBy eq "">Undefined<cfelse>#dev.TemplateModifiedBy#</cfif></td>
							 <td>#dateFormat(dev.TemplateModified,CLIENT.DateFormatShow)# #timeFormat(dev.TemplateModified,"HH:MM")#</td>
							 <td align="center">#numberformat(dev.TemplateSize/1024,"_._")# Kb</td>
							 <td colspan="2" align="center" id="u#templateid#">
							 
							 <cfif binary(filename) eq "no">
							 
							 	 <img src="#SESSION.root#/Images/comparison2.gif"
							     alt="Print a detailed comparison report"
							     height="14"
								 onclick="javascript:comparison('#dev.templateId#','#templateid#')"
							     border="0"
								 style="cursor: pointer;"
							     align="absmiddle"
							     order="0">
								 
							 </cfif>	 
							 
							 <img onclick="updatemaster('#dev.templateId#','#templateid#')" 
						         src="#SESSION.root#/Images/refresh4.gif" 
								 alt="Update template on master copy with development copy" 
								 border="0" 
								 align="absmiddle" 
								 style="cursor: pointer;">&nbsp;
								<a href="javascript:updatemaster('#dev.templateId#','#templateid#')" title="Add template">#Comparison#</a>
								
							  </td>
								
							</tr>
						
						</cfif>
					
					</cfif>
										
					<cfif TemplateComments neq "">
					    <tr><td></td><td colspan="6" bgcolor="f5f5f5">#TemplateComments#</td></tr>
					</cfif>
					
					<cfif Operational eq "0" and URL.Site eq "">
						<tr><td colspan="7" align="center" bgcolor="red" style="color:ffffff">This template was removed</td></tr>
				   	</cfif>
					 
					 <tr class="hide" id="d#currentrow#">
						<td></td>
						<td></td>
						<td colspan="5" id="i#currentRow#"></td>
					 </tr>
									 
				</cfoutput>		
			</cfoutput>
			
			<cfset space = "0">

		</table>
		</td></tr>
		</cfoutput>
				
		
	</cfoutput>
	
	</table>
	
	</cfif>
		
	<cfif listing.recordcount eq "0" and url.filter eq "0">
	<script language="JavaScript">
		 try { document.getElementById("list").className = "hide" } catch(e) {}
	</script>	
	</cfif>
		
<!--- prepare a temp zip file for quick reference --->

<cfif site.serverrole neq "QA" and 
      site.serverrole neq "Design" 
	  and listing.recordcount gte "1">
	
	<!--- create file list --->
	
	<cfset strFileToZip="">
	
	<cfloop query="Listing">
	
		<cfif pathname eq "[root]">
		  <cfset path = "">
		<cfelse>
		  <cfset path = pathname>
		</cfif>
	
		<cfif operational eq "1" and 
		      FileExists("#master.replicaPath#\#path#\#filename#")>
			  
			  <cfset strFileToZip=listappend(strFileToZip,SESSION.rootPath & path & "\" & filename)>
			  
		</cfif>
		
	
	</cfloop>
	
	<cftry>
				
		<cf_zip filelist="#strFileToZip#" 
			recursedirectory  = "No" 
			savepath          = "Yes"
			output            = "#SESSION.rootPath#\_distribution\#URL.site#_patch.zip">	
			<cfcatch></cfcatch>
			
		</cftry>	
					
</cfif>		

<cfset ajaxonload("doHighlight")>

	