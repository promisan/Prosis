 <cfquery name="Fields" 
   datasource="AppsSystem" 
   username="#SESSION.login#" 
   password="#SESSION.dbpw#">
        SELECT   *
        FROM     Ref_ReportControlCriteriaField 
        WHERE    ControlId    = '#ControlId#'
        AND      CriteriaName = '#CriteriaName#'
        AND      Operational  = '1' 
	 ORDER BY FieldOrder 
</cfquery>


<cfif Fields.recordcount lte "1" and Fields.recordcount gte "4">
			
    <b><cf_tl id="Alert">:</b> <cf_tl id="Multi selected related only" class="Message"> <cf_tl id="supported for 2 and 3 fields." class="Message">					
	
<cfelse>
			
		<cfloop query="Fields">
		
			<cfparam name="Name#CurrentRow#" default="#Fields.FieldName#">
						
			<cfif Fields.FieldSorting neq "">
				<cfparam name="Sort#CurrentRow#"        default="#Fields.FieldSorting#">
			<cfelse>
				<cfparam name="Sort#CurrentRow#"        default="#Fields.FieldName#">
			</cfif>
			
			<cfparam name="Display#CurrentRow#"         default="#Fields.FieldDisplay#">
			<cfparam name="CodeInDisplay#CurrentRow#"   default="#Fields.CodeInDisplay#">
			<cfparam name="Value#CurrentRow#"           default="">
			<cfparam name="LookupMultiple#CurrentRow#"  default="#Fields.LookupMultiple#">
			
			<!--- Sept 13, 2012 [kherrera]: This fix the error if there are more than one extended parameter in the same report --->
			<cfset "Name#CurrentRow#" = Fields.FieldName>
			<cfif Fields.FieldSorting neq "">
				<cfset "Sort#CurrentRow#" = Fields.FieldSorting>
			<cfelse>
				<cfset "Sort#CurrentRow#" = Fields.FieldName>
			</cfif>
			<cfset "Display#CurrentRow#" = Fields.FieldDisplay>
			<cfset "CodeInDisplay#CurrentRow#" = Fields.CodeInDisplay>
			<cfset "Value#CurrentRow#" = "">
			<cfset "LookupMultiple#CurrentRow#" = Fields.LookupMultiple>
				
		</cfloop>	
							
        <cfset Crit = replaceNoCase("#CriteriaValues#", "@userid", "#SESSION.acc#" , "ALL")>										
		<cfset Crit = replaceNoCase(Crit,"@manager", SESSION.isAdministrator,"ALL")>
		
		<cfset cond = replace(crit, ",", '$', 'ALL')>  					
		<cfset cond = replace(cond, "'", ';', 'ALL')>  
		<cfset cond = replace(cond, '=', '^', 'ALL')> 
												
		<cfoutput>
						
			<table class="#cl#" id="#fldid#_box" class="formspacing">
			<tr>
				<td valign="top">	
								
				<cfif lookupMultiple1 eq "1">
				   <cfset mul = "yes">
				   <cfset s = 4>
				   <cfset ht = "105">
				<cfelse>
				   <cfset mul = "no"> 
				   <cfset s = 1>
				   <cfset ht = "25">
				</cfif>														
				
				<cfquery name="preselect" 
				 datasource="AppsSystem" 
				 username="#SESSION.login#" 
				 password="#SESSION.dbpw#">
				 SELECT    CriteriaValue
				 FROM      UserReportCriteria 
				 WHERE     ReportId = '#URL.ReportId#' 
				 AND       CriteriaName = '#CriteriaName#_#Name1#'
				</cfquery>
				
				<cfset def = preselect.criteriaValue>
				
				<cfif def neq "">
				
					<cfset def = replace(def, ",", '$', 'ALL')>  					
					<cfset def = replace(def, "'", ';', 'ALL')>  
					<cfset def = replace(def, '=', '^', 'ALL')> 
				
				</cfif>				
								
				<cfif criteriaNameParent neq "">

					<cfselect name="#CriteriaName#_#Name1#"
						bindOnLoad="yes"										
						multiple="#mul#"	
						class="regularxl"
						style="height:#ht#;padding-right:10px;padding-right:10px"
						size="#s#" 						
						bind="cfc:service.Input.InputDropdown.DropdownSelect('#LookupDataSource#','#LookupTable#','#Name1#','#Sort1#','#Display1#','parent',{#CriteriaNameParent#},'','','','','#def#','#cond#','#Name1#','#codeInDisplay1#')"/>				
					
				<cfelse>					

					<cfselect name="#CriteriaName#_#Name1#"
						bindOnLoad="yes"										
						multiple="#mul#"	
						style="height:#ht#;padding-right:10px"
						class="regularxl"
						size="#s#" 						
						bind="cfc:service.Input.InputDropdown.DropdownSelect('#LookupDataSource#','#LookupTable#','#Name1#','#Sort1#','#Display1#','','','','','','','#def#','#cond#','#Name1#','#codeInDisplay1#')"/>				
									
				</cfif>
				
				</td>												
																																
			<cfif Fields.recordcount eq "2">				
						
				<cfquery name="preselect" 
				 datasource="AppsSystem" 
				 username="#SESSION.login#" 
				 password="#SESSION.dbpw#">
				 SELECT    CriteriaValue
				 FROM      UserReportCriteria 
				 WHERE     ReportId = '#URL.ReportId#' 
				 AND       CriteriaName = '#CriteriaName#'
				</cfquery>
				
				<cfset def = preselect.criteriaValue>
				
				<cfif def neq "">
				
					<cfset def = replace(def, ",", '$', 'ALL')>  					
					<cfset def = replace(def, "'", ';', 'ALL')>  
					<cfset def = replace(def, '=', '^', 'ALL')> 
				
				</cfif>				
				
				<cfif lookupMultiple2 eq "1">
				   <cfset mul = "yes">
				   <cfset s = 4>
				   <cfset ht = "105">
				<cfelse>
				   <cfset mul = "no"> 
				   <cfset s = 1>
				   <cfset ht = "25">
				</cfif>			
							
				<td style="padding-left:2px">	
				
				<cfif criteriaNameParent neq "">

				  	<cfselect name="#CriteriaName#"
						bindOnLoad="yes"	
						multiple="#mul#"	
						class="regularxl"
						style="height:#ht#;padding-right:10px"
						size="#s#" 						
						bind="cfc:service.Input.InputDropdown.DropdownSelect('#LookupDataSource#','#LookupTable#','#Name2#','#Sort2#','#Display2#','parent',{#CriteriaNameParent#},'#Name1#',{#CriteriaName#_#Name1#},'','','#def#','#cond#','#LookupFieldValue#','#codeInDisplay2#')"/>				
						
				<cfelse>

					<cfselect name="#CriteriaName#"
						bindOnLoad="yes"	
						multiple="#mul#"	
						style="height:#ht#;padding-right:10px"
						class="regularxl"
						size="#s#" 									
						bind="cfc:service.Input.InputDropdown.DropdownSelect('#LookupDataSource#','#LookupTable#','#Name2#','#Sort2#','#Display2#','','','#Name1#',{#CriteriaName#_#Name1#},'','','#def#','#cond#','#LookupFieldValue#','#codeInDisplay2#')"/>				
												
				</cfif>	
					
				</td>	
				
			 <cfelse>
			 
				<td valign="top" style="padding-left:2px">				
								
				 <cfquery name="Preselect" 
				 datasource="AppsSystem" 
				 username="#SESSION.login#" 
				 password="#SESSION.dbpw#">
				 SELECT    CriteriaValue
				 FROM      UserReportCriteria 
				 WHERE     ReportId = '#URL.ReportId#' 
				 AND       CriteriaName = '#CriteriaName#_#Name2#'
				</cfquery>
				
				<cfset def = preselect.criteriaValue>
				
				<cfif def neq "">
				
					<cfset def = replace(def, ",", '$', 'ALL')>  					
					<cfset def = replace(def, "'", ';', 'ALL')>  
					<cfset def = replace(def, '=', '^', 'ALL')> 
				
				</cfif>					
				
				<cfif lookupMultiple2 eq "1">
				 <cfset mul = "yes">
				  <cfset s = 4>
				  <cfset ht = "105">
				<cfelse>
				 <cfset mul = "no"> 
				 <cfset s = 1>
				 <cfset ht = "25">
				</cfif>			
								 
				 <cfif criteriaNameParent neq "">

					 <cfselect name="#CriteriaName#_#Name2#"
     				     bindonload="yes"
						 multiple="#mul#"
						 class="regularxl"
						 style="height:#ht#;padding-right:10px"
						 size="#s#" 
						 bind="cfc:service.Input.InputDropdown.DropdownSelect('#LookupDataSource#','#LookupTable#','#Name2#','#Sort2#','#Display2#','parent',{#CriteriaNameParent#},'#Name1#',{#CriteriaName#_#Name1#},'','','#def#','#cond#','#Name2#','#codeInDisplay2#')"/>				
						 
				 <cfelse>

					  <cfselect name="#CriteriaName#_#Name2#"
	       				 bindonload="yes"
						 multiple="#mul#"
						 class="regularxl"
						 style="height:#ht#;padding-right:10px"
						 size="#s#" 
						 bind="cfc:service.Input.InputDropdown.DropdownSelect('#LookupDataSource#','#LookupTable#','#Name2#','#Sort2#','#Display2#','','','#Name1#',{#CriteriaName#_#Name1#},'','','#def#','#cond#','#name2#','#codeInDisplay2#')"/>				
											 
				 </cfif>	 
				
				</td>	
										
				<td valign="top" style="padding-left:2px">
				
				 <cfquery name="Preselect" 
				 datasource="AppsSystem" 
				 username="#SESSION.login#" 
				 password="#SESSION.dbpw#">
				 SELECT    CriteriaValue
				 FROM      UserReportCriteria 
				 WHERE     ReportId = '#URL.ReportId#' 
				 AND       CriteriaName = '#CriteriaName#'
				</cfquery>
				
				<cfset def = preselect.criteriaValue>
				
				<cfif def neq "">
				
					<cfset def = replace(def, ",", '$', 'ALL')>  					
					<cfset def = replace(def, "'", ';', 'ALL')>  
					<cfset def = replace(def, '=', '^', 'ALL')> 
				
				</cfif>
				
				
				<cfif lookupMultiple3 eq "1">
				 <cfset mul = "yes">
				 <cfset s = 4>
				 <cfset ht = "105">
				<cfelse>
				 <cfset mul = "no"> 
				 <cfset s = 1>
				 <cfset ht = "25">
				</cfif>			
				
				 <cfif criteriaNameParent neq ""> 

				 <cfselect name="#CriteriaName#"
					 bindOnLoad="yes"
					 multiple="#mul#"
					 class="regularxl"
					 style="height:#ht#;padding-right:10px"
					 size="#s#" 
					 bind="cfc:service.Input.InputDropdown.DropdownSelect('#LookupDataSource#','#LookupTable#','#Name3#','#Sort3#','#Display3#','parent',{#CriteriaNameParent#},'#Name1#',{#CriteriaName#_#Name1#},'#Name2#',{#CriteriaName#_#Name2#},'#def#','#cond#','#LookupFieldValue#','#codeInDisplay3#')"/>														
					 
				 <cfelse>
		 																																												 
				 <cfselect name="#CriteriaName#"
					 bindOnLoad="yes"
					 multiple="#mul#"
					 class="regularxl"
					 style="height:#ht#;padding-right:10px"
					 size="#s#" 
					 bind="cfc:service.Input.InputDropdown.DropdownSelect('#LookupDataSource#','#LookupTable#','#Name3#','#Sort3#','#Display3#','','','#Name1#',{#CriteriaName#_#Name1#},'#Name2#',{#CriteriaName#_#Name2#},'#def#','#cond#','#LookupFieldValue#','#codeInDisplay3#')"/>														
											 
				 </cfif>	 
					
				</td>															
								 					 
			 </cfif>	
			
			 </tr>
			 </table>
		 </cfoutput>
				 
	</cfif>