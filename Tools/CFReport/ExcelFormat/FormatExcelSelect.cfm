
<table width="95%" height="100%" align="center" border="0" cellspacing="0" cellpadding="0" bordercolor="e4e4e4" >

<tr><td colspan="2" height="30">

   <table width="100%" border="0" class="formpadding navigation_table" cellspacing="0" cellpadding="0">
		
		<tr class="line labelmedium">
		<td height="23" width="50"></td>
		<td><cf_tl id="Name"></td>
		<td><cf_tl id="Table"></td>
		<td align="right"><cf_tl id="Fields"></td>
		<td align="right" style="padding-right:3px"><cf_tl id="Records"></td>		
		</tr>
			
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
						   						   
						   <tr id="r#currentRow#" style="cursor:pointer;" class="labelmedium navigation_row line"
						    onclick="reload('#CurrentRow#','#OutputId#','#tbl#')"
						    bgcolor="<cfif #CurrentRow# eq "1">ffffff</cfif>">
							
						    <td width="50" style="padding-left:3px">
							
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
						    <td width="30%" style="padding-left:10px">#OutputName#</td>
							<td width="30%">#datasource#:#tbl#</td>
							<td align="right">#numberFormat(FieldNo.total, ",")#</td>
							<td align="right" style="padding-right:4px">#numberFormat(NoRecords.total, ",")#</td>
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

<cf_menucontainer item="1" class="regular">
<cf_menucontainer item="2" class="hide" iframe="excelframe">

<cfif tblinit neq "">

 	<script>
	   ColdFusion.navigate('#SESSION.root#/Tools/Cfreport/ExcelFormat/FormatExcelDetail.cfm?mode=#url.mode#&reportid=#url.reportid#&ID=#idinit#&Table=#tblinit#','contentbox1')
 	</script>
	
<cfelse>
	
	<tr><td height="300">
		 <cf_message message="Problem, excel source data could not be located" return="no">
	</td></tr> 
	
</cfif>

</cfoutput>

</table>


