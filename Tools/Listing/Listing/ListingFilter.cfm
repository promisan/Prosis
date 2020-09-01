
<cf_tl id="contains" var="1">
<cfset vcontains=#lt_text#>
<cf_tl id="begins with" var="1">
<cfset vbegins=#lt_text#>
<cf_tl id="ends with" var="1">
<cfset vends=#lt_text#>
<cf_tl id="is" var="1">
<cfset vis=#lt_text#>
<cf_tl id="is not" var="1">
<cfset visnot=#lt_text#>
<cf_tl id="before" var="1">
<cfset vbefore=#lt_text#>
<cf_tl id="after" var="1">
<cfset vafter=#lt_text#>

<cfoutput>

	<cfset show  = 0>
	<cfset group = "No">
	
	<cfset appliedfilter = "1">
	
	<cfloop array="#attributes.listlayout#" index="current">
	
		<cfparam name="current.search" default="">
				
		<cfif current.search neq "">			
			<cfset show = 1>
		</cfif>		
	
	</cfloop>

	<!--- -------------- --->
	<!--- - filter box - --->
	<!--- -------------- --->			
	
	<cfif show eq "1">
		
	<!--- adjust the query to remove the SELECT and remove characters --->
	
	<cfset count = LEN(attributes.listquery)>
	<cfset start = Find("FROM", attributes.listquery)>
	
	<cfset qry = attributes.listquery>
	
	<cfset qry = replace(qry,"{","","ALL")>
	<cfset qry = replace(qry,"}","","ALL")>
	<cfset qry = replace(qry,"'","|","ALL")>
	<cfset qry = replace(qry,",",";","ALL")>
	<cfset qry = replace(qry,"=","&","ALL")>
			
	<cfform name="listfilter" method="POST" onsubmit="return false"> 	
			
	<table width="98%" align="center">
	
	      <tr><td height="3"></td></tr>			
								
			<cfset cnt  = 0>
			<cfset show = "0">
			<cfset row  = 0>
			
			<!--- for the listing to show complete data we need to run the query again
			but then without the filtering applied so we have all possible dropdown 
			values to select --->
			
			<cfif condition eq "">
			
				<!--- prevent running the query --->
				
				<cfset filterselect = searchresult>
			
			<cfelse>								
			
				<cfset scfull = replaceNoCase(sc,condition,"")>			
			
				<cfquery name="filterselect" 
				datasource="#attributes.datasource#" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#"> 			
					#preserveSingleQuotes(scfull)# 
				</cfquery>
				
				<!---							
				<cfoutput>#cfquery.executiontime#</cfoutput>
				--->
											
			</cfif>	
			
			<cfset reset = "">			
																	
			<cfloop array="#attributes.listlayout#" index="current">	
						
				<cfset row=row+1>
					  								
				<cfparam name="current.label"              default="">	
				<cfparam name="current.labelfilter"        default="#current.label#">	
				<cfparam name="current.search"             default="">	
				<cfparam name="current.displayfilter"      default="#current.display#">	
				<cfparam name="current.alias"              default="">	
				<cfparam name="current.searchtypeahead"    default="0">									
				<cfparam name="form.filter#current.field#" default="">		
				<cfparam name="form.filter#current.field#_operator" default="xxx">		
				<cfparam name="current.lookupscript"       default="">		
				<cfparam name="current.lookupgroup"        default="0">		
				<cfparam name="current.selectfield"        default="">						
																																							
				<cfif current.search neq ""  and current.displayfilter eq "yes">	
				
					<cfset show = "1">		
					<cfset showfield = "0">						
					
					<!--- we only show dropdownas if this indeed has some relevant values --->
															
					<cfif current.filtermode eq "2" or current.filtermode eq "3">	
										    						
						<cfset fld  = current.field>	
						<cfset srh  = current.searchfield>	
							
						<cfif srh eq "">
						   <cfset srh = fld>
						</cfif>		
						
						<cfset sel  = current.selectfield>
						
						<cfif sel eq "">
						   <cfset sel = fld>
						</cfif>		
						
						<cfif sel neq "">
							<cfset displ = sel>
						<cfelse>
							<cfset displ = fld>
						</cfif>		
						
						<cfset srt  = current.fieldsort>
						
						<cfif srt eq "">
						   <cfset srt = fld>
						</cfif>										
					
						<cfif current.lookupscript neq "">
						
							<!--- replace @field with #fld# anf then do the same --->
							
							<cfset lookup = replaceNoCase(current.lookupscript,"@fld","#fld# as DISPLAY")> 
							<cfset lookup = replaceNoCase(lookup,"@code","#srh# as CODE")>
							
							<cfquery name="lookupdata" datasource="#attributes.datasource#" 
							  username="#SESSION.login#" password="#SESSION.dbpw#">
								#preservesingleQuotes(lookup)#
							</cfquery>	
						
						<cfelse>		
												
							<cftry>		
																				
								<cfif current.lookupgroup eq "">			
																																				
								 	<cfquery name="lookupdata" dbtype="query">
									    SELECT   DISTINCT #srh# AS CODE, #displ# AS DISPLAY   
							   			FROM     filterselect				
										WHERE    #fld# is not NULL 	and #fld# != ''
										ORDER BY #srt# 								 
								    </cfquery>																
																				
								<cfelse>
								
									<cfquery name="lookupdata" dbtype="query">
									
									    SELECT   DISTINCT #srh# AS CODE, #displ# AS DISPLAY, #current.lookupgroup#   
							   			FROM     filterselect				
										WHERE    #fld# is not NULL and #fld# != '' 	
										ORDER BY #current.lookupgroup#,#srt#							 
								    </cfquery>		
								
								</cfif>		
																							
															
							<cfcatch>
							
								<cfset fld  = current.field>	
								<cfset srh  = current.field>		
																					
								<cfif current.lookupgroup eq "">		
																																			
								 	<cfquery name="lookupdata" dbtype="query">
									    SELECT   DISTINCT #srh# AS CODE,#displ# AS DISPLAY   
							   			FROM     filterselect													
										ORDER BY #fld# 								 
								    </cfquery>		
								
								<cfelse>
							
									<cfquery name="lookupdata" dbtype="query">
									    SELECT   DISTINCT #srh# AS CODE, #displ# AS DISPLAY #current.lookupgroup#   
							   			FROM     filterselect													
										ORDER BY #current.lookupgroup#,#srt#							 
								    </cfquery>		
							
								</cfif>				
								
							</cfcatch>
														
							</cftry>
						
						</cfif>
						
						<cfif lookupdata.recordcount gte "2">						
							<cfset showfield = "1">		
						</cfif>									
																	
					<cfelse>		

						 <cfset showfield = "1">						
				
					</cfif>
							
				
					<cfif showfield eq "1">					
						
						<cfset cnt=cnt+1>
					
						<cfif cnt eq "1"><tr></cfif>
						
						<td height="12" style="width:160<cfif cnt neq '1'>;padding-left:10px</cfif>" class="labelmedium">#Current.LabelFilter#: <cfif current.filtermode eq "4"></cfif>
						<cfif current.filterforce eq "1"><font color="FF0000">*)</font></cfif><cf_space spaces="40">
						</td>
						
						<cfif client.browser eq "explorer">
							<cfset p = 1>
						<cfelse>
							<cfset p = 2>	
						</cfif>
								
						<td style="width:40%;padding:#p#px;z-index:#40-row#; position:relative;">	
																									
						<cfset val = evaluate("form.filter#current.field#")>
						
						<cfset fld = current.field>		
						
						<cfif current.filterforce eq "1">
						    <cfset oblig = "Yes">	
							<cfset blank = "False">							
						<cfelse>
							<cfset oblig = "No">
							<cfset blank = "True">	
						</cfif>		
																																			
						<cfswitch expression="#Current.search#">
						
							<cfcase value="default">																
							
							   <cfinput type  = "text" 
							      name        = "filter#current.field#" 
								  value       = "#val#" 
								  class       = "regularxxl" 
								  message     = "Please select a #Current.LabelFilter#"
								  required    = "#oblig#"
								  size        = "20" 
								  maxlength   = "20">
								  
							   <cfset reset =  "#reset#;document.getElementById('filter#current.field#').value=''">	
								  
							</cfcase>		
											
							<cfcase value="text">								
														
								<cfif current.filtermode eq "0">									
																
								   <cfinput type="text" 
								      name      = "filter#current.field#" 
									  value     = "#val#" 
									  onkeyup   = "gofilter(event)"									 
									  class     = "regularxxl" 
									  message   = "Please select a #Current.LabelFilter#"
									  required  = "#oblig#"
									  size      = "20" 								 
									  maxlength = "20">	
									  
								  <cfset reset =  "#reset#;document.getElementById('filter#current.field#').value=''">						
							
								<cfelseif current.filtermode eq "1">	
																								
									<cfquery name="getInit" 
										 datasource="AppsSystem">
									 	 SELECT * 
										 FROM   Parameter			 
									</cfquery>			
									
									   <cfif getInit.VirtualDirectory eq "">					
																		
										   <cfinput type="text" 
										      name="filter#current.field#" 
											  value="#val#" 
											  class="regularxxl" 
											  size="20" 
											  message="Please select a #Current.LabelFilter#"
											  required="#oblig#"
											  typeahead="#current.searchtypeahead#"
											  showautosuggestloadingicon="No"
											  autosuggestminlength="2" 
											  autosuggest = "cfc:component.reporting.presentation.getlistingsuggest('#attributes.datasource#','#qry#','#fld#','#url.systemfunctionid#','#url.functionserialno#',{cfautosuggestvalue},'10','combo','listing')"				      
											  maxlength="20">
										  
									  <cfelse>
									  
										     <cfinput type="text" 
										      name="filter#current.field#" 
											  value="#val#" 
											  class="regularxxl" 
											  size="20"
											  message="Please select a #Current.LabelFilter#"
											  required="#oblig#" 
											  typeahead="#current.searchtypeahead#"
											  showautosuggestloadingicon="No"
											  autosuggestminlength="2" 
											  autosuggest = "cfc:#getInit.VirtualDirectory#.component.reporting.presentation.getlistingsuggest('#attributes.datasource#','#qry#','#fld#','#url.systemfunctionid#','#url.functionserialno#',{cfautosuggestvalue},'10','combo','listing')"				      
											  maxlength="20">
									  								  
									  </cfif>	 
									  
									   <cfset reset =  "#reset#;document.getElementById('filter#current.field#').value=''">	 
									  
								<cfelseif current.filtermode eq "2">	
																											
										<cfif lookupdata.recordcount lte "200">
																						
											<cfif current.LookupGroup eq "">

												<cfif LookupData.recordcount gt 10>
													<cfset vFilter = "contains">
												<cfelse>
													<cfset vFilter ="">
												</cfif>
												
												<cfquery name="checkDropdown" 
												  dbtype="query">
													 SELECT * 
													 FROM   lookupdata
													 WHERE Code = '#val#'
												 </cfquery>		

												<cf_UIselect name   = "filter#current.field#"
												    class           = "regularxxl" 
													queryposition   = "below"
													query           = "#lookupdata#"
													value           = "CODE"
													required        = "#oblig#"
													onchange        = "applyfilter('','1','content')"	
													message         = "Please select a #Current.LabelFilter#"
													display         = "DISPLAY"
													filter          = "#vFilter#"
													selected        = "#val#"																								
													style           = "width:90%;">
													<cfif current.filterforce eq "0">
												      <option value="" style="background: White;font:10px"><cf_tl id="Any"></option>
													<cfelse>
													  <option value="" style="background: White;font:10px">--<cf_tl id="Select">--</option>
													</cfif>
													<cfif checkdropdown.recordcount eq "0">
													  <option value="#val#" selected>#val#</option>
													</cfif>
													
												</cf_UIselect>
											
											<cfelse>
											
												<cfquery name="checkDropdown" 
												  dbtype="query">
													 SELECT * 
													 FROM   lookupdata
													 WHERE Code = '#val#'
												 </cfquery>		

												<cf_UISelect name   = "filter#current.field#"
												    class           = "regularxxl" 
													queryposition   = "below"
													query           = "#lookupdata#"
													group           = "#current.LookupGroup#"
													value           = "CODE"
													onchange        = "applyfilter('','1','content')"
													message         = "Please select a #Current.LabelFilter#"
													required        = "#oblig#"
													display         = "DISPLAY"
													selected        = "#val#"
													filter          = "contains"
													style           = "width:90%">
													<cfif current.filterforce eq "0">
												    <option value="" style="background: White;font:10px"><cf_tl id="Any"></option>		
													<cfelse>
													 <option value="" style="background: White;font:10px">--<cf_tl id="Select">--</option>		
													</cfif>		
													<cfif checkdropdown.recordcount eq "0">
													  <option value="#val#" selected>#val#</option>
													</cfif>																						
												</cf_UIselect>
											
											</cfif>
																						
											<cfset reset =  "#reset#;document.getElementById('filter#current.field#').selectedIndex='None'">		
										
										<cfelse>									
										
										   <cfinput type   = "text" 
										       name        = "filter#current.field#" 
											   value       = "#val#" 
											   class       = "regularxxl" 
											   message     = "Please select a #Current.LabelFilter#"
											   required    = "#oblig#" 
											   style       = "width:180;"						 
											   maxlength   = "20">											
										   
										   <cfset reset =  "#reset#;document.getElementById('filter#current.field#').value=''">	 
									  									
										</cfif>
																				
										<cfset group = "Yes">
										
								<cfelseif current.filtermode eq "3">
								
								        <!--- adjust val so we can ensure we find a value not as a subvalue --->
										
										<cfset val = "#val#,">
																																				
									 	<cfquery name="lookupdata" dbtype="query">
										    SELECT   DISTINCT #fld# AS PK, #displ# as DISPLAY   
								   			FROM     filterselect				
											WHERE    #fld# is not NULL   
										    ORDER BY #current.fieldsort#
									    </cfquery>	
																														
										<cfif lookupdata.recordcount lte "4">
										
											<table cellspacing="0" cellpadding="0">
											<tr>
																				
											<cfloop query="lookupdata">
											   <cfif pk neq "">
											  	 <td><input class="radiol" type="checkbox" id="filter#current.field#_#currentrow#" name="filter#current.field#" value="#PK#" <cfif find("#pk#,",val)>checked</cfif>></td>
												 <td style="padding-top:2px;padding-left:3px;padding-right:10px" class="labelmedium">#DISPLAY#</td>
											   </cfif>
											    <cfset reset =  "#reset#;document.getElementById('filter#current.field#_#currentrow#').checked=false">	 								  
											</cfloop>
																					
											</tr></table>
										
										<cfelse>
										
											<cf_UISelect name  = "filter#current.field#"
											     class         = "regularxxl"
											     queryposition = "below"
											     query         = "#lookupdata#"
											     value         = "PK"
											     onchange      = "applyfilter('','1','content')"
											     message       = "Please select a value #Current.LabelFilter#"
											     required      = "#oblig#"
											     display       = "DISPLAY"
											     selected      = "#val#"
											     multiple      = "yes">
											</cf_UIselect>

										   <cfset reset =  "#reset#;document.getElementById('filter#current.field#').value=''">	 
									  									
										</cfif>
										
										<cfset group = "Yes">	
										
							  <cfelseif current.filtermode eq "4">		
							  
							  		<!--- exact match --->
									
								   <cfset ope = evaluate("form.filter#current.field#_operator")>	
								   								  									
								   <table><tr><td>
								   
								   <select name="filter#current.field#_operator" class="regularxl" style="height:28px">
		
										<OPTION value="CONTAINS" <cfif ope eq "CONTAINS">selected</cfif>><cfoutput>#vcontains#</cfoutput>
										<OPTION value="BEGINS_WITH" <cfif ope eq "BEGINS_WITH">selected</cfif>><cfoutput>#vbegins#</cfoutput>
										<OPTION value="ENDS_WITH" <cfif ope eq "ENDS_WITH">selected</cfif>><cfoutput>#vends#</cfoutput>
										<OPTION value="EQUAL" <cfif ope eq "EQUAL">selected</cfif>><cfoutput>#vis#</cfoutput>
										<OPTION value="NOT_EQUAL" <cfif ope eq "NOT_EQUAL">selected</cfif>><cfoutput>#visnot#</cfoutput>
										<!---
										<OPTION value="SMALLER_THAN"><cfoutput>#vbefore#</cfoutput>
										<OPTION value="GREATER_THAN"><cfoutput>#vafter#</cfoutput>
										--->
									
									</SELECT>
								   
								   </td>
								   
								     <td style="padding-left:5px">
									 										
								     <cfinput type="text" 
								      name="filter#current.field#" 
									  value="#val#" 
									  onkeyup="gofilter(event)"
									  message="Please select a #Current.LabelFilter#"
									  required="#oblig#" 
									  class="regularxxl" 
									  size="40" 								 
									  maxlength="100">	
									  
									  <td>
									  
									  </tr></table>	
									  
								  <cfset reset =  "#reset#;document.getElementById('filter#current.field#').value=''">				
																												
								</cfif>	  
								  
							</cfcase>		
							
							<cfcase value="number">		
							
							    <table cellspacing="0" cellpadding="0">
							  <tr><td>										
							
							   <cfinput type="text" 
								      name="filter#current.field#" 
									  value="#val#" 
									  validate="float"									  
									  style="text-align:right"
									  required="#oblig#" 
									  message="Incorrect numeric value #Current.LabelFilter#"
									  class="regularxxl enterastab" 
									  size="8" 
									  maxlength="20">
									  
							   <cfset reset =  "#reset#;document.getElementById('filter#current.field#').value=''">	 
							   
							    </td>
							   
							   <td style="padding-left:4px;padding-right:4px">-</td>
							   <td>
							   
							     <cfparam name="form.filter#current.field#_to" default="">	
								  <cfset val = evaluate("form.filter#current.field#_to")>	
							   
							     <cfinput type="text" 
								      name="filter#current.field#_to" 
									  value="#val#" 
									  validate="float"
									  style="text-align:right"
									  required="#oblig#" 
									  class="regularxxl enterastab" 
									  message="Incorrect numeric value #Current.LabelFilter#"
									  size="8" 
									  maxlength="20">
									  
							   <cfset reset =  "#reset#;document.getElementById('filter#current.field#_to').value=''">	 
							   							   							
								</td></tr>
								</table>											
															  
							</cfcase>
							
							<cfcase value="amount">		
							
							    <table cellspacing="0" cellpadding="0">
							  <tr><td>										
							
							   <cfinput type="text" 
								      name="filter#current.field#" 
									  value="#val#" 
									  validate="float"									  
									  style="text-align:right"
									  required="#oblig#" 
									  message="Incorrect numeric value #Current.LabelFilter#"
									  class="regularxxl enterastab" 
									  size="8" 
									  maxlength="20">
									  
							   <cfset reset =  "#reset#;document.getElementById('filter#current.field#').value=''">	 
							   
							    </td>
							   
							   <td style="padding-left:4px;padding-right:4px">-</td>
							   <td>
							   
							     <cfparam name="form.filter#current.field#_to" default="">	
								  <cfset val = evaluate("form.filter#current.field#_to")>	
							   
							     <cfinput type="text" 
								      name="filter#current.field#_to" 
									  value="#val#" 
									  validate="float"
									  style="text-align:right"
									  required="#oblig#" 
									  class="regularxxl enterastab" 
									  message="Incorrect numeric value #Current.LabelFilter#"
									  size="8" 
									  maxlength="20">
									  
							   <cfset reset =  "#reset#;document.getElementById('filter#current.field#_to').value=''">	 
							   							   							
								</td></tr>
								</table>											
															  
							</cfcase>
						
							<cfcase value="mail">
							
							   <input type="text" 
							          name="filter#current.field#" 
									  id="filter#current.field#"
									  class="regularxxl" 
									  value="#val#" 
									  size="20" 
									  maxlength="20">
									  
							   <cfset reset =  "#reset#;document.getElementById('filter#current.field#').value=''">	 
									  								  
							</cfcase>						
													
							<cfcase value="date">
							
							  <table cellspacing="0" cellpadding="0">
							  <tr><td style="min-width:140px">
							  						 
							  <cfparam name="form.filter#current.field#_from" default="">	
							  <cfset val = evaluate("form.filter#current.field#_from")>
							 							  
							     <cf_intelliCalendarDate9
									FieldName="filter#current.field#_from" 
									Default="#val#"
									class="regularxxl"
									AllowBlank="#blank#">	
																		
							   <cfset reset =  "#reset#;document.getElementById('filter#current.field#_from').value=''">	 
																						
							   </td>
							   
							   <td style="padding-left:4px;padding-right:4px">-</td>
							   <td style="min-width:140px">					   				   
							   															
								  <cfparam name="form.filter#current.field#_to" default="">	
								  <cfset val = evaluate("form.filter#current.field#_to")>	
									
								   <cf_intelliCalendarDate9 
								     FieldName="filter#current.field#_to" 
									 Default="#val#"
									 class="regularxxl"
									 AllowBlank="#blank#">		
									 
								   <cfset reset =  "#reset#;document.getElementById('filter#current.field#_to').value=''">	 									  	 								 							
														
								</td></tr>
								</table>
							
							</cfcase>						
						
						</cfswitch>
											
						</td>	
						
						<cfif cnt eq "2"></tr><cfset cnt = 0></cfif>		
						
					</cfif>				
					
				</cfif>
					
			</cfloop>	
															 			
			<cfif annotation neq "">
						  
				<tr><td class="labelmedium"><cf_tl id="Flagged">:</td>
				<td colspan="3" style="padding-left:0px"><cf_annotationfilter></td></tr>
			
			</cfif>
			
			<cfif url.systemfunctionid neq "" and group eq "Yes">
							
			 	<tr><td class="labelmedium" style="height:35px"><cf_tl id="Group output by">:<cf_space spaces="30"></td>
				<td colspan="5">
					<table cellspacing="0" cellpadding="0">
					<tr>
					
					<td><input type="radio" class="radiol" name="groupfield" 
									 value="none" <cfif url.listgroup eq "">checked></cfif></td>
					<td style="padding-left:3px;padding-right:7px" class="labelit"><cf_tl id="None"></td>
					
					<cfset hasGroup = "0">
									 
					<cfloop array="#attributes.listlayout#" index="current">	
						<cfif (current.filtermode eq "2" or current.filtermode eq "3" ) and current.search neq "">	 
								<cfset hasGroup = "1">					
								<td><input type="radio" class="radiol" name="groupfield" 
									 value="#current.field#" <cfif url.listgroupfield eq current.field>checked</cfif>></td>
								<td style="padding-left:4px;padding-right:7px" class="labelit">#current.labelfilter#</td>
									
						</cfif>
					</cfloop>
					
					<cfif hasGroup eq "1">
					
					<td style="padding-left:8px"><input type="checkbox" class="radiol" name="groupdir" 
									 value="DESC" <cfif url.listgroupdir eq "DESC">checked></cfif></td><td style="padding-left:4px;padding-right:7px"><cf_tl id="DESC"></td>
									 
					</cfif>				 
					
					</tr>
					</table>		
				
				</td></tr>
				<tr><td height="2"></td></tr>	
						
			</cfif>
			
			<cfif show eq "1">
						
			<tr>
			<td colspan="6" height="32">
			
				<table class="formspacing" cellspacing="0" cellpadding="0">
				<tr>
				<td>		
					 <cf_tl id="Reset" var="1">
				     <input type="button" name="reset" id="reset" value="#lt_text#" class="button10g" style="border-radius:7px;font-size:12px;height:25px;width:120px" onClick= "#reset#">    	
					 
				</td>
				
				
				<td style="padding-left:2px">
					 <cf_tl id="Apply" var="1">
					 <input type="button" name="apply" id="apply" value="#lt_text#" class="button10g" style="font-size:12px;height:25px;border-radius:7px;width:120px" onClick= "applyfilter('',1,'content')">  
														
				</td>
				
				<cfif url.systemfunctionid neq "">
				
					<td style="padding-left:8px"><input type="checkbox" class="radiol" checked name="savefilter" id="savefilter" value="1"></td>					
					<td class="labelmedium" style="padding-top:3px;padding-bottom:2px;padding-left:2px"><cf_tl id="Remember"></td>
				
				</cfif>
				
				</tr>
				
				</table>
				
			</td>
			</tr>				
			
			</cfif>		
							
	</table>
	
	</cfform>					
		
	</cfif>
	
</cfoutput>	
	