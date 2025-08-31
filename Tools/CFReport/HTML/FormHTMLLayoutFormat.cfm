<!--
    Copyright © 2025 Promisan B.V.

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
<cfif URL.LayoutId neq "">

<cfquery name="Layout" 
	 datasource="AppsSystem" 
	 username="#SESSION.login#" 
	 password="#SESSION.dbpw#">
	 SELECT *
	 FROM   Ref_ReportControlLayout R
	 WHERE  LayoutId = '#URL.Layoutid#' 
</cfquery>

<cfquery name="Report" 
	 datasource="AppsSystem" 
	 username="#SESSION.login#" 
	 password="#SESSION.dbpw#">
	 SELECT *
	 FROM   Ref_ReportControl
	 WHERE  ControlId = '#Layout.ControlId#' 
</cfquery>

<table width="160" style="height:25" class="formpadding">
	
<cfif Layout.LayoutFormat eq "PDF">

	<tr class="hide">
	<TD class="labelmedium" style="width:20px;padding-left:10px">
	 <input type="Radio" class="radiol" name="FileFormat" id="FileFormat" value="PDF" checked></TD>
	 <td class="labelmedium" style="padding:3px">PDF</td>
		 
<cfelseif Layout.LayoutClass eq "View">		

	<tr>
    <cftry>
    <cfif Report.ReportRoot eq "Application">
	  <cffile action="READ" 
	      file="#SESSION.rootpath#/#Report.ReportPath#/#Layout.TemplateReport#" variable="template">	
	<cfelse>	
	  <cffile action="READ" 
	      file="#SESSION.rootReportPath#/#Report.ReportPath#/#Layout.TemplateReport#" variable="template">		  			   			
    </cfif>	 
	
	<cfif not find("mypdfoutputfile","#template#")>
		
		<cfset URL.sel = "HTM">
						
		<td class="labelmedium" style="padding-left:4px">					 
		<input type="Radio" class="radiol" name="FileFormat" id="FileFormat" value="HTM" 
			<cfif url.sel eq "HTM">checked</cfif>></td><td class="labelmedium" style="padding:3px">HTML</td>		
		<td class="labelmedium" style="padding-left:4px">
		<input type="Radio" class="radiol" name="FileFormat" id="FileFormat" value="RTF"
			<cfif url.sel eq "RTF">checked</cfif>></td><td class="labelmedium" style="padding:3px">MS-Word</td>				
		<td class="labelmedium" style="padding-left:4px">
		<input type="Radio" class="radiol" name="FileFormat" id="FileFormat" value="PDF"
			<cfif url.sel eq "PDF">checked</cfif>></td><td class="labelmedium" style="padding:3px">PDF</td>
			
		<!---	
		<td class="labelmedium" style="padding-left:4px">					 
		<input type="Radio" class="radiol" name="FileFormat" id="FileFormat" value="Excel"
			<cfif url.sel eq "Excel">checked</cfif>></td><td class="labelmedium" style="padding:3px">MS-Excel</td>
			
			--->
		
		
	<cfelse>
	
	<tr>
		
		<TD style="padding-left:4px;width:20px">
	
		<cfset URL.sel = "PDF">
		
		<input type="Radio" class="radiol" name="FileFormat" id="FileFormat" value="PDF"
			<cfif url.sel eq "PDF">checked</cfif>>
						
			</TD>
			<td class="labelmedium" style="padding:3px">PDF</td>
		
	</cfif>	
	
	<cfif Report.EnableAttachment eq "1">
	
		<script>
		 try {
		  document.getElementById("attachmentmode").className = "regular"
		 } catch(e) {}
		 
		</script>	
	
	<cfelse>
		
		<script>
		 try {
		  document.getElementById("attachmentmode").className = "hide"
		 } catch(e) {}
		 
		</script>	
	
	</cfif>
	
	<cfcatch><font color="FF0000">Layout Template not found</cfcatch>
	
	</cftry>
		
<cfelseif Layout.TemplateReport eq "Excel">		 

	<!--- scan if dataset with _dim is being generated --->
	
	<cftry>
		
	    <!--- check the dateset tables defined for this out --->
				
		  		  
		<cfquery name="Output" 
			 datasource="AppsSystem" 
			 username="#SESSION.login#" 
			 password="#SESSION.dbpw#">
			 SELECT TOP 1 *
			 FROM  Ref_ReportControlOutput R
			 WHERE ControlId = '#Layout.ControlId#' 
		</cfquery>
		  
	      <cfif Output.OutputClass eq "variable">
		
			  <cfif Report.ReportRoot neq "Report">
		          <cfset rootpath  = "#SESSION.rootpath#">
		      <cfelse>
		          <cfset rootpath  = "#SESSION.rootReportPath#">
		      </cfif>
			  
			  <TD>
				
			 	 <cffile action = "read"
				 	  file = "#rootpath#\#Report.ReportPath#\#Report.TemplateSQL#"
					  variable = "sql">  
						  
					<cfif Find("_dim", "#sql#")>	
					
						<table><tr><td style="padding-left:6px">			 
						<input type="Radio" name="FileFormat" id="FileFormat" class="radiol" value="OLAP" 
						    <cfif url.sel neq "Excel">checked</cfif>></td><td style="padding-left:4px" class="labelmedium"><cf_tl id="Dimensional Analysis"></td>
							<td style="padding-left:4px">
						<input type="Radio" name="FileFormat" id="FileFormat" class="radiol" value="Excel" 
							<cfif url.sel eq "Excel">checked</cfif> ></td><td style="padding-left:4px" class="labelmedium">Excel</td>
							</tr>
						</table>
						
					<cfelse>
						<table><tr><td>						
						<input type="Radio" name="FileFormat" id="FileFormat" class="radiol" value="Excel" checked></td><td style="padding-left:4px" class="labelmedium">Excel</td>
						</tr>
						</table>
					
					</cfif>	
					
			</td>
				
			<cfelseif Output.OutputClass eq "table">		
								 
				<cfquery name="Fields" 
				datasource="#Output.DataSource#" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				SELECT c.name as FieldValue
				FROM      sysobjects S INNER JOIN
	                      syscolumns C ON S.id = C.id INNER JOIN
	                      systypes T ON C.xtype = T .xtype 
				WHERE     s.name = '#Output.VariableName#' 
				ORDER BY S.name, C.colid  
				</cfquery>		
				
				<TD colspan="7" class="labelmedium" style="padding-left:5px">			
			
			    <cfif fields.recordcount gte "1">	
				
					<table><tr><td style="padding-left:6px">			 
					<input type="Radio" name="FileFormat" id="FileFormat" class="radiol" value="OLAP" 
					    <cfif url.sel neq "Excel">checked</cfif>></td><td style="padding-left:4px" class="labelmedium"><cf_tl id="Dimensional Analysis"></td>
						<td style="padding-left:14px">
					<input type="Radio" name="FileFormat" id="FileFormat" class="radiol" value="Excel" 
						<cfif url.sel eq "Excel">checked</cfif> ></td><td style="padding-left:4px" class="labelmedium">Excel</td>
						</tr>
					</table>
			
						
				<cfelse>
										
					<table>
					<tr><td>						
						<input type="Radio" name="FileFormat" id="FileFormat" value="Excel" checked></td><td style="padding-left:4px" class="labelit">Excel</td>
						</tr>
					</table>
					
				</cfif>	
				
				</td>
			
			
			</cfif>
	
		<cfcatch>
		
			<TD colspan="7">
			
			<input type="Radio" name="FileFormat" id="FileFormat" value="OLAP" 
			    <cfif url.sel neq "Excel">checked</cfif>><cf_tl id="Dimensional Analysis">	 
			<input type="Radio" name="FileFormat" id="FileFormat" value="Excel" 
				<cfif url.sel eq "Excel">checked</cfif> >Excel
				
				</td>
		
		</cfcatch>
		
	</cftry>	
		
	<!--- subscription hide --->	
	<script>
	 try {
	  document.getElementById("attachmentmode").className = "hide"
	 } catch(e) {}
	 
	</script>	
						 
<cfelse>
	
    <td style="padding-left:3px" class="labelit">
				
	<input type="Radio" class="radiol" name="FileFormat" id="FileFormat" value="PDF"
		<cfif url.sel eq "PDF" or url.sel eq "Flashpaper" or url.sel eq "">checked</cfif>>
		</td>
		<td style="padding-left:4px" class="labelmedium">PDF</td>
	
		<td style="padding-left:6px">			 																	
	<input type="Radio" class="radiol" name="FileFormat" id="FileFormat" value="RTF"
		<cfif url.sel eq "RTF">checked</cfif>>
		</td><td style="padding-left:4px" class="labelmedium">MS Word</td>		
	
	<!--- DISABLED Dev
	
		<td style="padding-left:6px">				 
	<input type="Radio" class="radiol" name="FileFormat" id="FileFormat" value="Excel"
		<cfif url.sel eq "Excel">checked</cfif>>
		</td><td style="padding-left:4px" class="labelmedium">Excel</td>		
		
		<td style="padding-left:6px">
	<input type="Radio" class="radiol" name="FileFormat" id="FileFormat" value="HTML"
		<cfif url.sel eq "HTML">checked</cfif>>
		</td>
		<td style="padding-left:4px" class="labelmedium">HTML</td>	
			
		<td style="padding-left:6px">	
	<input type="Radio" class="radiol" name="FileFormat" id="FileFormat" value="XML"
		<cfif url.sel eq "HTML">checked</cfif>></td>
		<td class="labelmedium" style="padding-left:4px">XML</td>
		
	--->
		
	<!--- subscription hide --->	
	<script language="JavaScript">
		 try {
		  document.getElementById("attachmentmode").className = "regular"
		 } catch(e) {}
	</script>	
			 
</cfif>		
				
	</tr>
	
	<cfif Layout.layoutTitle neq "">
	
		<cfoutput>
				
		<tr class="fixlengthlist labelmedium2">
		<td colspan="2" style="padding-left:5px"><cf_tl id="Title">:</td>
		<td colspan="8" title="#Layout.LayoutTitle#">#Layout.LayoutTitle#</td>
		</tr>
		
		<cfif Layout.LayoutSubTitle neq "">
		<tr class="fixlengthlist labelmedium2">
		<td colspan="2" style="padding-left:5px"><cf_tl id="Subtitle">:</td>
		<td colspan="8" title="#Layout.LayoutSubtitle#">#Layout.LayoutSubTitle#</td>
		</tr>	
		</cfif>
		
		</cfoutput>
	
	</cfif>
		
</table>	

<cfelse>

<font color="FF0000"><b><cf_tl id="STOP">:</b> <cf_tl id="Output format has not been configured."> <br><cf_tl id="You must contact your administrator">, <br><cf_tl id="You can not use this report!"></font>

</cfif>	 
						 