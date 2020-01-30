				 
		 <cfoutput>
	 
	     <table bordercolor="97A8BB" id="#fldid#_box" cellspacing="0" class="#cl#" border="0" class="formpadding">
		 <tr><td>
					 			 
		 <cfif CriteriaValidation eq "ZIPCode">
		     <cfset tpe = "ZIP">
		 <cfelse>
		     <cfset tpe = "Text">
		 </cfif> 	
		 
				 			 
		 <cfif LookupTable eq "">
			
			 <cf_textInput
				   form      = "selection"
				   type      = "#tpe#"
				   mode      = "regular"
				   name      = "#CriteriaName#"
				   id        = "#fldid#"
			       value     = "#DefaultValue#"
				   label     = "#CriteriaDescription#:"
				   mask      = "#criteriaMask#"  
			       required  = "#ob#"
				   validate  = "#CriteriaValidation#"
				   pattern   = "#criteriapattern#"
			       visible   = "Yes"
			       enabled   = "Yes"
			       size      = "#CriteriaWidth#"
			       maxlength = "800"
				   class     = "regular3"
				   style     = "padding-left:4px;padding-top:2px;font-size:15px;height:25;font-family:calibri;border:1px solid silver;"		
				   tooltip   = "#CriteriaMemo#"
				   message   = "#Error#" >			 
		 
		 <cfelse>
		
			 <cf_textInput
				   form            = "selection"
				   type            = "#tpe#"
				   mode            = "regular"
				   name            = "#CriteriaName#"
				   id              = "#fldid#"
			       value           = "#DefaultValue#"
				   label           = "#CriteriaDescription#:"
			       required        = "#ob#"
				   validate        = "#CriteriaValidation#"
				   pattern         = "#criteriapattern#"
			       visible         = "Yes"
			       enabled         = "Yes"
			       size            = "#CriteriaWidth#"
			       maxlength       = "800"
				   class           = "regular3"
				   style           = "padding-left:4px;padding-top:2px;font-size:15px;height:25;font-family:calibri;border:1px solid silver;"		
				   autosuggest     = "cfc:service.reporting.presentation.getlookup('#ControlId#','#CriteriaName#',{cfautosuggestvalue})"
			       tooltip         = "#CriteriaMemo#"
				   message         = "#Error#">
			   
		 </cfif>	   
					 
		 </td>
		 
		 <cfif CriteriaDatePeriod eq "1">
			
				   <cfset default = "#DefaultValueEnd#">
								   			
					<td width="8" align="center">-</td>
					<td>
					
					<cfif LookupTable eq "">
			
						 <cf_textInput
							   form      = "selection"
							   type      = "#tpe#"
							   mode      = "regular"
							   name      = "#CriteriaName#_end"
							   id        = "#fldid#"
						       value     = "#Default#"
							   label     = "#CriteriaDescription#:"
							   mask      = "#criteriaMask#"  
						       required  = "#ob#"
							   validate  = "#CriteriaValidation#"
							   pattern   = "#criteriapattern#"
						       visible   = "Yes"
						       enabled   = "Yes"
						       size      = "#CriteriaWidth#"
						       maxlength = "800"
							   style="font-size:15px;height:25;border:1px solid silver;font-family:calibri;"		
							   class     = "regular3"
							   tooltip   = "#CriteriaMemo#"
							   message   = "#Error#" >			 
					 
					 <cfelse>
					
						 <cf_textInput
							   form            = "selection"
							   type            = "#tpe#"
							   mode            = "regular"
							   name            = "#CriteriaName#_end"
							   id              = "#fldid#"
						       value           = "#Default#"
							   label           = "#CriteriaDescription#:"
						       required        = "#ob#"
							   validate        = "#CriteriaValidation#"
							   pattern         = "#criteriapattern#"
						       visible         = "Yes"
						       enabled         = "Yes"
						       size            = "#CriteriaWidth#"
						       maxlength       = "800"
							   style           = "font-size:15px;height:25;border:1px solid silver;font-family:calibri;"		
							   class           = "regular3"
							   autosuggest     = "cfc:service.reporting.presentation.getlookup('#ControlId#','#CriteriaName#',{cfautosuggestvalue})"
						       tooltip         = "#CriteriaMemo#"
							   message         = "#Error#">
						   
					 </cfif>	   
				
				
				    </td>
			</cfif>
		 	 
		 </tr>
		 </table>
		 
		 </cfoutput>
			   		 
		