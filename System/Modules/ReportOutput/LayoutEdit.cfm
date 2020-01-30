
<cfquery name="Detail" 
		datasource="AppsSystem" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
	    SELECT *
	    FROM   Ref_ReportControlLayout
		WHERE  ControlId = '#URL.ID#'
		AND LayoutId = '#URL.ID1#' 
</cfquery>
		
<!---- edit/add layout --->

<cf_screentop height="100%" user="no" line="no" label="Report Layout Settings" scroll="Yes" layout="webapp" banner="gray">

<cfform action="LayoutSubmit.cfm?Status=#URL.Status#&ID=#URL.ID#&ID1=#URL.ID1#" target="result" method="POST" name="layout">

<cfoutput>

<table width="92%" align="center" cellspacing="0" cellpadding="0" class="formpadding formspacing">

<tr class="hide"><td colspan="2"><iframe name="result"
                            id="result"
                            width="100%"
                            height="100"
                            scrolling="yes"></iframe></td></tr>

<tr><td height="10"></td></tr>
<TR>
	   <td width="150" class="labelmedium">Name:</td>
	
	   <td height="20" width="80%" class="labelmedium">
	   
	      <cfif Detail.TemplateReport eq "Excel">
		    Analysis/Export 
		    <input type="hidden" name="LayOutName" id="LayOutName" value="#Detail.LayoutName#" readonly> 					
		  <cfelse>
		     <cfinput type="Text" 
			         name="LayoutName" 
					 message="Please enter a report description" 
					 value="#Detail.LayoutName#" 
					 required="Yes" 
					 size="30" 
					 maxlength="30" 
					 class="regularxl">		
		  </cfif>
		  
		</td>
		
</tr>	

<tr>
		<td class="labelmedium">Layout Class:</td>
		
		<cfif detail.recordcount eq "1">
			<td class="labelmedium">#detail.layoutclass#
			  <input type="hidden" name="LayOutClass" id="LayOutClass" value="#detail.LayOutClass#">
			</td>
		<cfelse>
			<td>
			 <select name="layoutclass" id="layoutclass" class="regularxl">
				 <option value="Report" checked>Report (cfr)</option>
				  <option value="View" checked>View (cfm)</option>
				 </select>
			</td>
		</cfif>	 
				
</tr>

<tr>
		<td class="labelmedium">Layout Title:</td>		
		<td class="labelmedium"><input type="Text" name="LayoutTitle" id="LayoutTitle" value="#Detail.LayoutTitle#" style="width:400" maxlength="80" class="regularxl"></td>		
</tr>

<tr>
		<td class="labelmedium">Layout Sub-Title:</td>		
		<td class="labelmedium"><input type="Text" name="LayoutSubTitle" id="LayoutSubTitle" value="#Detail.LayoutSubTitle#" style="width:400" maxlength="100" class="regularxl"></td>		
</tr>

<tr>		
		<td height="24" class="labelmedium">Report Developer Code:</td>	
   		<td><cfif Detail.TemplateReport neq "Excel">
	 	     <input type="Text" name="LayoutCode" id="LayoutCode" value="#Detail.LayoutCode#" size="4" maxlength="10" class="regularxl">		
		   <cfelse>
		     N/A
		     <input type="hidden" name="LayOutCode" id="LayOutCode" value="">	 
		   </cfif>
		</td>
		
</tr>	

<tr>		
		<td height="24" class="labelmedium">Remove&nbsp;TEMP&nbsp;Tables&nbsp;after&nbsp;execution:</td>	
   		<td class="labelmedium">
				 
		 <input class="radiol" type="radio" name="CleanSQLTables" id="CleanSQLTables" value="1"  <cfif Detail.CleanSQLTables eq "1">checked</cfif>>Yes
		 <input class="radiol" type="radio" name="CleanSQLTables" id="CleanSQLTables" value="0"  <cfif Detail.CleanSQLTables neq "1">checked</cfif>>No (use if you allow for subreport)
		
		</td>
		
</tr>	

<tr>

		<td height="24" class="labelmedium">File Name</td>
	   
	    <td class="labelmedium">
	    <cfif Detail.TemplateReport neq "Excel">
		
			<cfinput type="Text" name="TemplateReport" value="#Detail.TemplateReport#" message="You must register the report template name" required="Yes" size="15" maxlength="30" class="regularxl">		
	    
		<cfelse>
		<cfoutput>Analysis/Export <!--- #Detail.TemplateReport# ---></cfoutput> 
	     <input type="hidden" name="TemplateReport" id="TemplateReport" value="#Detail.TemplateReport#">	 
		</cfif>			
		</td>
		
</tr>

<tr>		
		<td height="24" class="labelmedium">Interface Listing Order:</td>	   
		<td>
			<cfinput type="Text" name="ListingOrder" class="regularxl" value="#Detail.ListingOrder#" message="You must define an order" validate="integer" required="Yes" size="1" maxlength="2" style="text-align: center;">
		</td>
		
</tr>

<tr><td width="125px" class="labelmedium">Allow for Dashboard:</td>	
   <td colspan="1" height="24">
	<table>
		<tr>						
			<td align="left" class="labelmedium">
				<input type="checkbox" class="radiol" name="Dashboard" id="Dashboard" value="1" <cfif "1" eq Detail.Dashboard>checked</cfif>>
			</td>
			<td width="125px" align="right" class="labelmedium">
				User scoped:
			</td>
			<td align="left" class="labelmedium">
				<input type="checkbox" class="radiol" name="UserScoped" id="UserScoped" value="1" <cfif "1" eq Detail.UserScoped>checked</cfif>>
			</td>
		</tr>
	</table>
	</td>
</tr>	
<cfif Detail.TemplateReport neq "Excel">	

<tr>	<td class="labelmedium">Output Format:</td>
		<td>		    
			    <select name="LayoutFormat" id="LayoutFormat" class="regularxl">
				<option value="All" <cfif "All" eq Detail.LayoutFormat or Detail.LayoutFormat eq "">selected</cfif>>All formats</option>
				<option value="PDF" <cfif "PDF" eq Detail.LayoutFormat>selected</cfif>>PDF only</option>
				</select>			
		</td>
		</tr>
<cfelse>
	<input type="hidden" name="LayoutFormat" id="LayoutFormat" value="#Detail.LayoutFormat#">	
</cfif>		
	
<cfif Detail.TemplateReport neq "Excel">
	
<tr><td valign="top" style="padding-top:4px" class="labelmedium">for PDF only:</td>
<td>

	<table cellspacing="0" cellpadding="0" class="formpadding">
	
	<tr>
		<td class="labelmedium">Permissions:</td>
		<td class="labelmedium">
	
				<input type="text"
	               name="OutputPermission"
				   id="OutputPermission"
	               value="#Detail.OutputPermission#"
	               size="20"
			   	   class="regularxl"
	               maxlength="80">
								
		</td>
	</tr>	
	
	<tr>	
		<td class="labelmedium">Encryption:</td>
		<td class="labelmedium"><select name="OutputEncryption" id="OutputEncryption" class="regularxl">
				<option value="None" <cfif "None" eq Detail.OutputEncryption>selected</cfif>>None</option>
				<option value="128-bit" <cfif "128-bit" eq Detail.OutputEncryption>selected</cfif>>128-bit</option></select>
		</td>
	</tr>
	
	<tr><td class="labelmedium" style="padding-right:20px">Password Owner:</td>
		
		<td><input type="text"
	            name="PasswordOwner"
				id="PasswordOwner"
	            value="<cfoutput>#Detail.PasswordOwner#</cfoutput>"
	            size="20"
				class="regularxl"
	            maxlength="50">
		</td>  
		</tr>
		
	<tr><td class="labelmedium">Password User:</td>	
		
			<td><input type="text"
		                name="PasswordUser"
						id="PasswordUser"
		                value="<cfoutput>#Detail.PasswordUser#</cfoutput>"
		                size="20"
						class="regularxl"
		                maxlength="50">
			</td>   				 
	    </tr>
			
	</tr>
	
	</table>
	
</td>
</tr>

	
</cfif>
<tr><td colspan="2" height="1" class="linedotted"></td></tr>	
<tr>	<td class="labelmedium">Operational:</td>		
		<td class="labelmedium">
			<input type="checkbox" class="radiol" name="Operational" id="Operational" value="1" <cfif "1" eq Detail.Operational>checked</cfif>>
		</td>

    </TR>	
	
</cfoutput>
							
	<cfquery name="Cluster" 
	datasource="AppsSystem" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT    ControlId, CriteriaCluster, CriteriaName
		FROM      Ref_ReportControlCriteria
		WHERE     CriteriaCluster <> '' 
		AND       ControlId = '#URL.ID#'
	</cfquery>
	
	<cfif cluster.recordcount gte "1">
		
	<tr><td><cf_UIToolTip
	          tooltip="Allow you to hide a report option if a certain cluster value has been selected">Availability for cluster:</cf_UIToolTip>
		  </td>
	<td>	
			
			<table cellspacing="0" cellpadding="0" class="formpadding">
			<tr>
																	
			<cfoutput query="Cluster" group="CriteriaCluster">
			
			    
				<cfquery name="Check" 
				datasource="AppsSystem" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
					SELECT   *
					FROM     Ref_ReportControlLayoutCluster
					<cfif detail.recordcount gte "1">
					WHERE    LayoutId = '#Detail.LayoutId#'
					<cfelse>
					WHERE     1=0
					</cfif>
					AND      CriteriaCluster = '#criteriaCluster#'
				</cfquery>
								
				<td align="right" class="labelmedium"><b>[#CriteriaCluster#]:</td>
				<td class="labelmedium"> 
				<select name="cluster_#criteriaCluster#" id="cluster_#criteriaCluster#" class="regularxl">
				<option value="" selected>Show for any selection</option>
				<cfoutput>									
					<option value="#CriteriaName#" <cfif CriteriaName eq Check.CriteriaName>selected</cfif>>
					Show only for #criteriaName#
					</option>
				</cfoutput>
				</select>
				</td>
										
			</cfoutput>
			
			</tr>
			
			</table>
	</td>
	</tr>
	
</cfif>

<tr><td colspan="2" height="1" class="linedotted"></td></tr>	
		
<tr bgcolor="white">
		<td colspan="2" align="center" height="35">
		   <button class="button10g" name="Save" id="Save" type="button" onclick="parent.ColdFusion.Window.destroy('mydialog',true)">
		   Cancel
		   </button>
		   <button class="button10g" name="Save" id="Save" type="submit">
		   <cfif url.id1 eq "00000000-0000-0000-0000-000000000000">
		   Add report
		   <cfelse>
		   Save
		   </cfif>
		   </button>
	    </td>
</tr>		

</table>

</cfform>	

<cf_screenbottom layout="webapp">