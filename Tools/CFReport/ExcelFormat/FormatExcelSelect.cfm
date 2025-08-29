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
<table width="100%" height="100%" align="center">

<tr><td colspan="2" valign="top">

   <table width="100%" border="0" class="formpadding navigation_table">
		
		<!---
		<tr class="line labelmedium">
		<td height="23" width="50"></td>
		<td><cf_tl id="Name"></td>
		<td><cf_tl id="Table"></td>
		<td align="right"><cf_tl id="Fields"></td>
		<td align="right" style="padding-right:3px"><cf_tl id="Records"></td>		
		</tr>
		--->
			
	   <cfset tblinit = "">
	   	     	   
	   <cfoutput query="tableOutput">		  	   	  	   
		 		   
		   <cfif OutputClass eq "Variable">	
		   
		   	    <cfset tbl = "#evaluate(VariableName)#">	
				<cfparam name="CLIENT.#variablename#" default="">				
				<cfif tbl eq "">
                    <cfset tbl = evaluate("CLIENT.#variablename#")>
                </cfif>   
				
				
				    		   
		   <cfelse>		 
		     
		   		<cfset tbl = VariableName>		   
				
		   </cfif>		
		   	 			  
		  		     		   
		   <cfif tbl neq "">
		   				   
			   <!--- check if this is an excel table --->
			  			  			   
			    <cfquery name="CheckField" 
				datasource="#TableOutput.DataSource#"
				username="#SESSION.login#" 
	            password="#SESSION.dbpw#">
					SELECT    C.name
					FROM      sysobjects S INNER JOIN
		                      syscolumns C ON S.id = C.id
					WHERE     S.name = '#tbl#' 
					AND       C.name LIKE '%_dim' 
				</cfquery>
				
				<!---
							
			    <cfif CheckField.recordcount eq "0">
				
				--->
				
					   <cftry>
				  				   	   	   	   
						   <cfquery name="NoRecords" 
							datasource="#TableOutput.DataSource#" 
							username="#SESSION.login#" 
				            password="#SESSION.dbpw#">
								SELECT   count(*) as Total
							    FROM     #tbl#
						   </cfquery>					   
						   
							<cfquery name="FieldNo" 
							datasource="#TableOutput.DataSource#"
							username="#SESSION.login#" 
				            password="#SESSION.dbpw#">
							SELECT   count(*) as Total
						    FROM     SysObjects S, SysColumns C 
							WHERE    S.id = C.id
							AND      S.name = '#tbl#'	
							</cfquery>
						   						   
						   <tr id="r#currentRow#" style="cursor:pointer;" class="labelmedium2 navigation_row line fixlengthlist"
						    onclick="reload('#CurrentRow#','#OutputId#','#tbl#')"
						    bgcolor="<cfif #CurrentRow# eq "1">ffffff</cfif>">
							
						    <td style="padding-left:13px">
							
							<cf_tl id="Open" var="1">
							
							 <button 
							    id="select#currentrow#"
							    name="select" 
								value="#lt_text#" 		
								type="button"		  
								class="button10g"
								style="height:30px;width:60px;cursor: pointer;">			
								   	<img height="25" src="#SESSION.root#/images/excel.gif" alt="" border="0">
							</button>	
							
							   
							</td>
						    <td>#OutputName#</td>
							<td>#datasource#:#tbl#</td>
							<td align="right">#numberFormat(FieldNo.total, ",")#</td>
							<td align="right">#numberFormat(NoRecords.total, ",")#</td>
						   </tr>		
						  
						   <cfif tblinit eq "">
						       <cfset tblinit = tbl>
			    			   <cfset idinit  = outputid>
						   </cfif>  
						   
						   <cfcatch></cfcatch>
					   
					   </cftry>
					    
								 
			</cfif>	    			
	
		         
	   </cfoutput>  
	 	
	
   </table>
   
   </td>
</tr>   

<cf_menuscript>

<cfoutput>

<!---

<tr><td id="mainmenu" class="hide" height="20">
	
	<table width="100%"  class="formpadding" cellspacing="0" cellpadding="0">
	
	<tr>
	
			<cfset ht = "28">
			<cfset wd = "30">
	
				<cf_menutab item       = "1" 
			            iconsrc    = "Logos/System/Registration.png" 
						iconwidth  = "#wd#" 
						class      = "highlight1"
						iconheight = "#ht#" 
						name       = "Selection Criteria">			
				
					
				<cf_menutab item       = "2" 
			            iconsrc    = "Logos//WorkSheet.png" 
						iconwidth  = "#wd#" 
						iconheight = "#ht#" 
						name       = "Open">
	
	
		<td id="excelmenu" align="right" valign="bottom" width="10%"></td>

	</tr>
	
	</table>

</td></tr>

--->

<tr><td colspan="2" style="height:100%">
<table style="height:100%;width:100%">

<cf_menucontainer item="1" class="regular">
<cf_menucontainer item="2" class="hide" iframe="excelframe">
</table>
</td></tr>

<cfif tblinit neq "">

 	<script>
	   ptoken.navigate('#SESSION.root#/Tools/cfreport/ExcelFormat/FormatExcelDetail.cfm?mode=#url.mode#&reportid=#url.reportid#&ID=#idinit#&Table=#tblinit#','contentbox1')
 	</script>
	
<cfelse>
	
	<tr><td height="300">
		 <cf_message message="Problem, excel source data could not be located" return="no">
	</td></tr> 
	
</cfif>

</cfoutput>

</table>


