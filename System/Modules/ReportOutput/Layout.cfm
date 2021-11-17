
<cfparam name="URL.ID1" default="{00000000-0000-0000-0000-000000000000}">
<cfparam name="URL.Status" default="0">

<cf_distributer>
<cfif master eq "0">
	<cfset url.status = 1>
</cfif>	
<cfif SESSION.acc eq "AdministratorX">
	<cfset url.status = 0>
</cfif>

<cfquery name="Detail" 
datasource="AppsSystem" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT S.*, R.ReportRoot, R.ReportPath, R.TemplateSQL, R.TemplateSQLDate
    FROM   Ref_ReportControlLayout S, Ref_ReportControl R
	WHERE  S.ControlId = '#URL.ID#'
	AND    S.ControlId = R.ControlId
	ORDER BY S.ListingOrder
</cfquery>

<cfif Detail.ReportRoot eq "Application">
   <cfset rootpath  = "#SESSION.rootpath#">
<cfelse>
   <cfset rootpath  = "#SESSION.rootReportPath#">
</cfif>

<cfif Detail.TemplateSQL eq "External">

	<cfquery name="remove" 
	datasource="AppsSystem" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    DELETE Ref_ReportControlLayout 
		WHERE  ControlId = '#URL.ID#' 
		AND    TemplateReport = 'Excel'
	</cfquery>

</cfif>
			
		<table width="95%" align="center">
		<tr><td>
	    <table width="100%" bgcolor="white">
			
	    <TR class="labelmedium2 line">
		   <td height="18">Name</td>
		   <td width="50">Class</td>
		   <td>Code</td>
		   <td>Template name</td>
		   <td align="center">Order</td>
		   <td align="center">Dashb.</td>
		   <td align="center">Format</td>
		   <td align="center">Active</td>		  
	    </TR>	
				
		<cfif url.status eq "0">
		<tr class="line"><td colspan="8" align="center" class="labelmedium" style="height:25px"><a href="javascript:outputedit('00000000-0000-0000-0000-000000000000')">[Add a new layout]</a></td></tr>		
		</cfif>
				
		<cfquery name="Check" 
		datasource="AppsSystem" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		    SELECT *
		    FROM   Ref_ReportControlLayout
			WHERE  ControlId = '#URL.ID#'
			AND Operational = 1
		</cfquery>
		
		<cfif Check.recordcount eq "0">
			<tr class="labelmedium2"><td height="1" colspan="10" align="center" bgcolor="f4f4f4">
			<cfset cnt = cnt+15>
			<font face="Verdana" color="FF0000">Attention: You have not registered or enabled a report/view output definition.</font>
			</td></tr>
		</cfif>
		
		<cfloop query="Detail">
						
			<cfset id = LayoutId>
			<cfset rl = LayoutName>
			<cfset cd = LayoutCode>
			<cfset fl = TemplateReport>
			<cfset op = Operational>
			<cfset db = Dashboard>	
													
			<cfif URL.ID1 eq id>
							
			<cfelse>
						
				<cfoutput>	
		
				 <TR class="line labelmedium2" bgcolor="<cfif op eq "0">FCCFC9<cfelse>ffffff</cfif>">
				
				   <td>
					    <table cellspacing="0" cellpadding="0">
						<tr class="labelmedium2">
						
						<td style="padding-left:5px">
					    <A href="javascript:outputedit('#LayOutId#')">							
					    	<cfif TemplateReport eq "Excel">Dataset/Excel<cfelse>#rl#</cfif>
						</a>
						</td></tr></table>
				   </td>
				   
				   <td class="cellcontent">#layoutclass#</td>
				   
				   <td class="cellcontent">#cd#</td>
				   
				   <td class="cellcontent">
				   
						   <cfif TemplateReport eq "Excel">
						   
						   	   <cfif op eq "0">
						   				#fl#
							   <cfelse>
							   		   <a href="javascript:extractadd()">below</a>
							   </cfif>		   
							   
						   <cfelseif TemplateSQL eq "External">
						   
						   	#fl#_*.*
						   
						   <cfelse>		   
						   
							   <cftry>
							   			
								<cfif FileExists("#RootPath#\#ReportPath#\#fl#")>
									#fl#  
								<cfelse>
								  <font color="FF0000">&nbsp;#fl#</font>
								</cfif>
	
								<cfcatch></cfcatch>
						
								</cftry>
							
						  </cfif>
						  
				   </td>
				   
				   <td class="cellcontent" align="center">#ListingOrder#</td>
				   <td class="cellcontent" align="center"><cfif db eq "1">*</cfif></td>
				   <td class="cellcontent" align="center">#LayoutFormat#</td>
				   
				   <cfif URL.status eq "0">
					    
				       <td align="center">
					   <table cellspacing="0" cellpadding="0">
						   <tr>
						   <td width="20"  style="padding-top:3px">					   
						   	<cf_img icon="edit" onClick="outputedit('#LayOutId#')">				         						  
						   </td>
					 	   <td align="center" height="24" style="padding-top:2px">					   
						    <cfif TemplateReport neq "Excel">						
								<cf_img icon="delete" onClick="outputpurge('#rl#')">							
							<cfelse>					   									
								<cf_img icon="add" onClick="extractadd()">														
							</cfif>
						   </td>
						   </tr>
					   </table>
					   </td>
					   
				     </cfif>
				   
			    </TR>	
				
				<cfif LayoutTitle neq "">				
					<tr class="labelmedium2 line">
					<td></td>
					<td>Title:</td>
					<td colspan="6">#LayoutTitle#</td>
					</tr>			
				</cfif>
				
				<cfif LayoutSubTitle neq "">				
					<tr class="labelmedium2 line">
					<td></td>
					<td>Subtitle:</td>
					<td colspan="6">#LayoutSubtitle#</td>
					</tr>			
				</cfif>
				
				<cfif TemplateReport neq "Excel">
				
					<tr>
					<td></td>
					<td colspan="7">
						<table style="width:400px" border="0" cellspacing="0" cellpadding="0">
						<tr class="labelmedium2 line">
							<td width="80" bgcolor="f4f4f4">Permissions:</td>
							<td width="160"><cfif OutputPermission eq "">none<cfelse>#OutputPermission#</cfif></td>
							<td width="100" bgcolor="f4f4f4">Encryption:</td>
							<td width="80">#OutputEncryption#</td>
						</tr>
						</table>
					</td>
					</tr>
				
				</cfif>
				
				<cf_distributer>
				
				<cfif master eq "1" and url.status eq "1">
				
					<cf_fileVerifyN
					    Root      = "#RootPath#"
					    Directory = "#ReportPath#"
						File      = "#templateReport#"
						Timestamp = "#TemplateSQLDate#">
					
					<cfif FileStatus eq "Changed" and TemplateReport neq "Excel">
				  			
						  <tr>
					  	     <td colspan="8" align="center" bgcolor="ffffcf">
							  <font color="FF0000">
							  <img align="absmiddle" src="<cfoutput>#SESSION.root#</cfoutput>/Images/childnode.gif" border="0">
							  &nbsp;<b>Alert</b>:</font> #TemplateReport# was modified on: <b>#FileStamp#</b>. Report status reset to:  <font color="FF0000"><b>Under Development</b></font>
							 </td>	  
						 </tr>	
											 
				    </cfif>
				
				</cfif>		
				
				<cfif TemplateReport eq "Excel">
				<tr>
				<td></td>
				<td colspan="6">			
				   <cfinclude template="ExcelListing.cfm">
				</td>
				</tr>							
				</cfif>
				
				</cfoutput>	
						
			</cfif>
					
		</cfloop>		
				
		</table>
		
		</tr>		
						
	</table>	
