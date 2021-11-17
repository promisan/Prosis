
<cfoutput>

<cfparam name="Attributes.MenuStart" default="1">
<!--- JM added this on 02/02/2010 in order to allow closing for a particular Id --->
<cfparam name="Attributes.AjaxId"    default="">

<div style="position:absolute; width:280px; background-color: F6F6F6; z-index:99999; border: 1px ridge silver; ">

	<table width="100%" class="navigation_table">
		
	<tr><td>
	
	<cfif Attributes.ajaxid neq "">
		
		<table width="100%" border="0" cellspacing="0" cellpadding="0" align="center" 				
		    onClick="cmclear('#attributes.ajaxid#');" 
			onMouseOver="hl(this,true,'')" 
			onMouseOut="hl(this,false,'')">
			
			<tr class="line" bgcolor="e1e1e1"> 
			  <td width="165" style="padding-left:4px;padding-right:3px" height="18" class="labelmedium"><cf_tl id="Submenu"></td>
			  <td align="right" style="padding-left:4px;padding-right:2px">
			  <cf_img icon="delete">
			</td>
			</tr>
			
			<tr><td colspan="2" height="1" class="linedotted"></td></tr>
			
		</table>	
		
	</cfif>
	
	</td></tr>
		
	<cfloop index="No" from="#Attributes.MenuStart#" to="#Attributes.MenuRows#" step="1">
	
		<cfparam name="Attributes.MenuShow#No#" default="Show">
		<cfset Status   = Evaluate("Attributes.MenuStatus" & #No#)>
		<cfset Name     = Evaluate("Attributes.MenuName" & #No#)>
		<cfset Action   = Evaluate("Attributes.MenuAction" & #No#)>
		<cfset Icon     = Evaluate("Attributes.MenuIcon" & #No#)>
		<cfset Show     = Evaluate("Attributes.MenuShow" & #No#)>
		
		<cfparam name="Attributes.MenuLine#No#" default="No">
		<cfset Line     = Evaluate("Attributes.MenuLine" & #No#)>		  	  
		
		<cfif Show eq "Show">
		
			<tr class="line navigation_row">
			<td>
	
			<table width="100%" 				
				align="center" 
			    onClick="#Action#" 
				onMouseOver="hl(this,true,'#Status#')" 
				onMouseOut="hl(this,false,'')"
				class="formpadding">
				
				<tr style="height:37px"> 
				  <td align="center" style="padding-left:4px;width:40px" height="23">				  
				  <img src="#Icon#" style="height:22px;width:22px" border="0" align="middle">
				  </td>
				  <td class="labelmedium2" style="padding-left:4px">#Name#</td>
				</tr>
			</table>
			
			</td></tr>
			
		</cfif>
		
	</cfloop> 
		
	</table>

</div>

<cfset ajaxonload("doHighlight")>

</cfoutput>	 
