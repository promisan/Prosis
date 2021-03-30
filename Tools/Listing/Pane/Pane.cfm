<cfparam name="attributes.id"				default="1">
<cfparam name="attributes.label"			default="">
<cfparam name="attributes.labelClass"		default="labellarge">
<cfparam name="attributes.labelStyle"		default="font-size:20px; color:##808080;">
<cfparam name="attributes.labelSeparator"	default="Yes">
<cfparam name="attributes.height"			default="auto">
<cfparam name="attributes.search"			default="Yes">
<cfparam name="attributes.delayFilter"		default="500">
<cfparam name="attributes.paneItemMinSize"	default="">
<cfparam name="attributes.paneItemOffset"	default="35">
<cfif thisTag.ExecutionMode is "start">

	<cfoutput>
		    
		<div class="pane_clsSummaryPanelContainer" style="width:100%;height:#attributes.height#;">
			
			<div style="width:100%;height:auto;">
			
				<table width="100%" height="auto">
								
					<cfif trim(attributes.label) neq "">
						<tr>
							<td class="#attributes.labelClass#" style="#attributes.labelStyle#">#attributes.label# </td>
						</tr>
					</cfif>
					
					<cfif attributes.search eq "Yes">
					<tr>
						<td style="padding-left:10px; padding-top:3px;">
							<cfinvoke component = "Service.Presentation.TableFilter"  
							   method           = "tablefilterfield" 
							   filtermode       = "direct"
							   name             = "filtersearch_#attributes.id#"
							   style            = "font-size:15px; width:250px; padding:5px;"
							   rowclass         = "pane_clsSummaryPanelItem_#attributes.id#"
							   rowfields        = "pane_clsPaneFilterContent_#attributes.id#">
						</td>
					</tr>
					</cfif>
					
					<cfif attributes.labelSeparator eq "yes" and (attributes.search eq "Yes" or trim(attributes.label) neq "")>
						<tr><td height="2"></td></tr>
						<tr><td class="linedotted"></td></tr>
						<tr><td height="2"></td></tr>
					</cfif>
				</table>
				   
			</div>			
			
	</cfoutput>
	
<cfelse>

	</div>
	
	<cfif attributes.paneItemMinSize neq "">
		<cfset AjaxOnLoad("function() { _pane_resizeMenuItems('#attributes.paneItemMinSize#', #attributes.paneItemOffset#); $(window).on('orientationchange resize', function() { _pane_resizeMenuItems('#attributes.paneItemMinSize#', #attributes.paneItemOffset#); }); }")>
	</cfif>

</cfif>