  <cfif LookupMultiple eq "0">
							
		<cfif Default.DefaultValue eq "">
		
				<cfquery name="query#CriteriaName#" 
					     datasource="appsSystem" 
						 username="#SESSION.login#" 
						 password="#SESSION.dbpw#">
					     SELECT   DISTINCT *
						 FROM     Ref_ReportControlCriteriaList
						 WHERE    ControlId = '#ControlId#'
						 AND      CriteriaName = '#CriteriaName#' 
						 ORDER BY ListOrder, ListDisplay
						
				</cfquery> 	 
		
		<cfelse>
			
				 <cfset tmp = "">
		         <cfloop index="itm" list="#Default.DefaultValue#,#CriteriaDefault#" delimiters=",">
        	     <cfif tmp eq "">
		    	    <cfset tmp = "'#itm#'">
			     <cfelse>
			        <cfset tmp = "#tmp#,'#itm#'">
			     </cfif>
		         </cfloop>
				 
				<cfquery name="query#CriteriaName#" 
			     datasource="appsSystem" 
				 username="#SESSION.login#" 
				 password="#SESSION.dbpw#">
			     SELECT   DISTINCT *
				 FROM     Ref_ReportControlCriteriaList
				 WHERE    ControlId = '#ControlId#'
				 AND      CriteriaName = '#CriteriaName#'
				 AND      ListValue IN (#preserveSingleQuotes(tmp)#) 
				 ORDER BY ListOrder, ListDisplay
				</cfquery> 	  
			 						
		</cfif>
		
		<cfif CriteriaInterface neq "Checkbox">
		
			<cfif format eq "Flash">	 
				
				<!--- disabled --->
			
			<cfelse>
			
			<cfoutput>
				<table border="0" cellspacing="0" cellpadding="0" class="#cl#" id="#fldid#_box" class="formpadding">
			</cfoutput>
			
			<tr><td>			
																						
			<cfselect name="#CriteriaName#" 
						selected   = "#CriteriaDefault#"
				    	size       = "1" 
						multiple   = "No"
					    message    = "#Error#" 
					   	required   = "#ob#"
						class      = "#cl#"
						id         = "#fldid#"
						width      = "#sizeU#"						
						label      = "#CriteriaDescription#:"
						style      = "width: #SizeU*8#;font-size:15px;height:25;border:1px solid silver;font-family:calibri;"	
						query      = "query#CriteriaName#"
						queryPosition="below"
						value      = "ListValue"
						display    = "ListDisplay"
						onChange   = "SelectChange('#CriteriaName#');"
						onKeyDown  = "KeyPress('#CriteriaName#');" 
						onMouseDown= "KeyPressEnabled = false;">
						<cfif LookupEnableAll eq "1">
						  <option value="all">--- <cf_tl id="All"> ---</option>
						</cfif>  
						
			</cfselect>	
			
			</td></tr>
			
			</table>
																		
			</cfif>
											
		<cfelse>
		    				
			 <cfset def = "#CriteriaDefault#">	
			 <cfset des = "#CriteriaDescription#">			
			
			<table cellspacing="0" cellpadding="0"><tr>	
			 <cfloop query="query#CriteriaName#">
			 
			 		<td style="<cfif currentrow neq 1>padding-left:10px</cfif>">
				  				  
				        <cfif find(listvalue,#def#)>
						
						  <cfinput type="Radio" 
				           name="#CriteriaName#" 						   				   
						   value="#ListValue#"
		                   size="10" 
						   class="#cls# radiol"
						   id="#fldid#"
		                   maxlength="10" 
				           label="#ListDisplay#"
						   tooltip="#des#"
						   checked/>
						   
						<cfelse>												
						 
						 <cfinput type="Radio" 
				           name="#CriteriaName#" 						   
						   value="#ListValue#"
		                   size="10" 
						   class="#cls# radiol"
						   id="#fldid#"
		                   maxlength="10" 
				           label="#ListDisplay#"
						   tooltip="#des#"/>
						   
						</cfif>
						
						</td>
													
						<cfif format eq "HTML">
						    <td class="labelmedium" style="padding-left:4px;padding-right:5px">
								<cfoutput>
									<cf_tl id="#ListDisplay#">
									<cfif recordcount gte "6"><br></cfif>
								</cfoutput>
							</td>
						</cfif>					
						      										 
				  </cfloop>		
				  
				  </tr>
				</table>
				  
		</cfif>	  		 
				
	<cfelse>
	
			<cfif Default.DefaultValue eq "">
		
				<cfquery name="query#CriteriaName#" 
					     datasource="appsSystem" 
						 username="#SESSION.login#" 
						 password="#SESSION.dbpw#">
					     SELECT DISTINCT *
						 FROM   Ref_ReportControlCriteriaList
						 WHERE  ControlId = '#ControlId#'
						 AND    CriteriaName = '#CriteriaName#' 
						 ORDER BY ListOrder, ListDisplay
						
				</cfquery> 	 
		
			<cfelse>
			
				 <cfset tmp = "">
		         <cfloop index="itm" list="#Default.DefaultValue#,#CriteriaDefault#" delimiters=",">
        	     <cfif tmp eq "">
		    	    <cfset tmp = "'#itm#'">
			     <cfelse>
			        <cfset tmp = "#tmp#,'#itm#'">
			     </cfif>
		         </cfloop>
				 						 
				<cfquery name="query#CriteriaName#" 
			     datasource="appsSystem" 
				 username="#SESSION.login#" 
				 password="#SESSION.dbpw#">
				     SELECT DISTINCT *
					 FROM   Ref_ReportControlCriteriaList
					 WHERE  ControlId = '#ControlId#'
					 AND    CriteriaName = '#CriteriaName#'
					 AND ListValue IN (#preserveSingleQuotes(tmp)#) 
					 ORDER BY ListOrder, ListDisplay
				</cfquery> 	  
			 						
			</cfif>	
			
				<cfif CriteriaInterface neq "Checkbox">
				
				<cfif s gt evaluate("query#CriteriaName#.recordcount")>
					<cfset s = evaluate("query#CriteriaName#.recordcount")>
					<cfif s lte 1>
						<cfset s = 2>
					</cfif>
				</cfif>
				<cfset ht = s*18+3>				
							
				<cfselect name     = "#CriteriaName#" 
						selected   = "#CriteriaDefault#"
				    	size       = "#s#" 
						multiple   = "Yes"
					    message    = "#Error#" 
					   	required   = "#ob#"
						class      = "#class# radiol"
						id         = "#fldid#"
						width      = "#sizeU#"
						style      = "width: #SizeU*8#;font-size:14px;height:#ht#;border:1px solid silver;font-family:calibri;"							
						tooltip    = "#CriteriaMemo#"
						label      = "#CriteriaDescription#:"
						query      = "query#CriteriaName#"
						queryPosition="below"
						value      = "ListValue"
						display    = "ListDisplay">
						
				</cfselect>	
			
			<cfelse>
			
			<cfoutput>
			<table border="0" cellspacing="0" cellpadding="0" class="#cl#" id="#fldid#_box" class="formpadding">
			
				 <tr><td class="labelmedium">
			
			      <cfset fld = "#Parameter.CriteriaName#">
				  <cfset des = "#Parameter.CriteriaDescription#">
			
			      <cfloop query="query#CriteriaName#">
				  
				         <!---  class="#class#"  --->
				  
				        <cfif find(listvalue,Parameter.CriteriaDefault)>
						
						  <cfinput type   = "CheckBox" 
				           name           = "#fld#_#currentrow#" 
						   value          = "#ListValue#"
		                   size           = "10"
						   id             = "#fldid#"
						   class          = "radiol"
						   maxlength      = "10" 
				           label          = "#ListDisplay#"
						   tooltip        = "#des#"
						   checked/>
						   
						<cfelse>
						
						 <cfinput type    = "CheckBox" 
				           name           = "#fld#_#currentrow#" 
						   value          = "#ListValue#"
		                   size           = "10" 
						   maxlength      = "10" 
						   class          = "radiol"
				           label          = "#ListDisplay#"
						   tooltip        = "#des#"/>
						   
						</cfif>
																						
						<cfif format eq "HTML"><cfoutput><cf_tl id="#ListDisplay#">&nbsp;</cfoutput></cfif>
						
						<cfif evaluate("query#CriteriaName#.recordcount") gt "3">
						  </td></tr><tr><td>
						</cfif>
						      										 
				  </cfloop>	
				  
				 </td></tr>
			</table>	
			</cfoutput> 
				  			 
			
			</cfif>
				
	</cfif>