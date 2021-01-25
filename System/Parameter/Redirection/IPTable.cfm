
<cf_screentop height="100%" scroll="yes" html="No" jquery="Yes">

<table width="94%" height="100%" align="center">

<tr style="height:10px"><td>
	<cfset add          = "1">
	<cfset page         = "0">
	<cfset Header       = "IP direction">
	<cfinclude template="../HeaderParameter.cfm">  
</td>
</tr>

<tr class="noprint">   
    
	<cfoutput>
    <td height="50" style="padding-left:10px;padding-top:10px" class="labellarge">
	<b>&nbsp;
	<img src="#SESSION.root#/Images/ipmonitor.gif" alt="" border="0" align="absmiddle">
	&nbsp;IP redirection</b></font>
	</td>	
	</cfoutput>
	
</tr>
	
<cfset cnt = "0">

<cfparam name="URL.ID1" default="{00000000-0000-0000-0000-000000000000}">

<cfoutput>
	
	<script language="JavaScript">
	
	function purge(ip) {
		if (confirm("Do you want to remove this IP range ?")) {
		     window.location = "IPTablePurge.cfm?ID="+ip			
		}		    
	}
	
	function toggle(val) {
	
	  if (val != "URL") {
	  	document.getElementById("ServerURL").className = "hide"
	  } else {
		document.getElementById("ServerURL").className = "regularxl"
	  }	  
	}
	
	</script>

</cfoutput>

<cfquery name="IPTable" 
datasource="AppsSystem" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT    *
    FROM      stRedirection
	ORDER BY  IPRangeStartNum
</cfquery>

<cfquery name="IPTableLast" 
datasource="AppsSystem" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT    TOP 1 *
    FROM      stRedirection
	ORDER BY  Created DESC
</cfquery>

<cfquery name="getMission" 
datasource="AppsSystem" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT    *
    FROM      Organization.dbo.Ref_Mission	
	WHERE     Operational = 1
</cfquery>

<cfquery name="getLink" 
datasource="AppsInit" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT    DISTINCT ApplicationRoot
	FROM      Parameter
</cfquery>	

<tr><td valign="top" style="padding-top:10px">

	<cfform action="IPTableSubmit.cfm?ID1=#URL.ID1#&idmenu=#url.idmenu#" method="POST"  name="fund">
	
		<table width="100%">
		    
		  <tr>
		    <td width="95%" style="padding-left:20px;padding-right:20px">
					
		    <table width="100%" class="formpadding navigation_table">
				
		    <TR class="labelmedium2 line">
			   <td height="20" width="30"></td>
			   <td>IP range start</td>
			   <td>IP range end</td>
			   <td>Entity</td>
			   <td>URL (http://servername/virtual_dir)</td>
			   <td></td>
			   <td>Created</td>
			   <td width="7%"></td>
			   <td width="7%"></td>
		    </TR>	
				
			<cfoutput>
			
			<cfloop query="IPTable">
																	
			<cfif URL.ID1 eq IPRangeId>
					
			<tr bgcolor="ffffff" class="navigation_row line">
			
			   <td style="height:28px" class="labelit">#currentRow#</td>
			
			   <td height="23">		
			     <cfinput type="text" 
				 name="IPRangeStart" 
				 value="#IPRangeStart#" 
				 size="15" 
				 maxlength="15" 
				 style="text-align: center;" 
				 required="Yes"
				 message="Please enter a valid IP range start" 
				 validate="regular_expression" 
				 pattern="^[1-9]\d?\d?\.[1-9]\d?\d?.[0-9]\d?\d?.[0-9]\d?\d?$" 
				 visible="Yes" 
				 enabled="Yes"
				 class="regularxl">
			   </td>
			   
			   <td>
			   
			     <cfinput type="text" 
				 name="IPRangeEnd"  
				 value="#IPRangeEnd#" 
				 size="15" 
				 maxlength="15" 
				 style="text-align: center;" 
				 message="Please enter a valid IP range end" 
				 validate="regular_expression" 
				 pattern="^[1-9]\d?\d?\.[1-9]\d?\d?.[0-9]\d?\d?.[0-9]\d?\d?$" 
				 visible="Yes" 
				 enabled="Yes"
				 class="regularxl">
				 
			   </td>
			   
			   <td>
			    <cfset mis = mission>
				
			    <select name="Mission" id="Mission" class="regularxl">
					<option value="">n/a</option>
					<cfloop query="getMission">
					<option value="#mission#" <cfif mission eq mis>selected</cfif>>#Mission#</option>
					</cfloop>
				</select>		
			   
			   </td>		   
			   
			   <td width="375">
			   
			   	 <table cellspacing="0" cellpadding="0">
				 <tr><td>
			   
			    <select name="Redirect" id="Redirect" class="regularxl">
				 <option value="URL" <cfif serverurl neq "Disabled">selected</cfif>>URL</option>
				 <option value="Disabled" <cfif serverurl eq "Disabled">selected</cfif>>Disabled</option>
				</select>		
				
				 </td>
				 
				 <cfif serverurl eq "Disabled">
				 <cfset cl = "hide">
				 <cfelse>
				 <cfset cl = "regularxl">
				 </cfif>
				 
				 <td style="padding-left:3px">					 
							
			    <select name="ServerURL" class="#cl#">				
					<cfloop query="getLink">
					<option value="#ApplicationRoot#" <cfif IPTable.serverurl eq ApplicationRoot>selected</cfif>>#ApplicationRoot#</option>
					</cfloop>
				 </select>		
				 
				 <td>
				 
				 </tr>
				 </table>
				 
			   </td>
			   <td colspan="4" align="right">
			   <input type="submit" name="submit" id="submit" style="height:25px" value="Update" class="button10g">
			   
			   </tr>
			   						
			<cfelse>
										
				  <TR style="height:25px" class="labelmedium2 navigation_row line" bgcolor="#IIf(CurrentRow Mod 2, DE('FFFFFF'), DE('f6f6f6'))#"> 
				   <td style="padding-left:5px">#CurrentRow#.</td>
				   <td>#IPRangeStart#</td>
				   <td>#IPRangeEnd#</td>
				   <td>#Mission#</td>
				   <td bgcolor="<cfif serverURL eq 'disabled'>yellow</cfif>">#ServerURL#</td>
				   <td><!--- #OfficerLastName# ---></td>
				   <td>#DateFormat(Created, CLIENT.DateFormatShow)#</td>
				   <td align="center">
				     <A href="IPTable.cfm?ID1=#IPRangeID#&idmenu=#url.idmenu#">[edit]</a>
				   </td>
				   <td align="center" style="padding-top:3px">
				      <cf_img icon="delete" onclick="purge('#IPRangeID#')">			
				  </td>			   
			    </TR>
															
			</cfif>
					
			</cfloop>
									
			</cfoutput>
									
			<cfif URL.ID1 eq "{00000000-0000-0000-0000-000000000000}">
	
			 <tr>
			   <td></td> 
			   <td height="25">		
			     <cfinput type="Text"
			       name="IPRangeStart"
			       message="Please enter a valid IP range start"
			       validate="regular_expression"
			       pattern="^[1-9]\d?\d?\.[1-9]\d?\d?.[0-9]\d?\d?.[0-9]\d?\d?$"
			       required="Yes"
			       visible="Yes"
			       enabled="Yes"
				   class="regularxl"
			       size="15"
			       maxlength="15" style="text-align: center;">
			   </td>
			   
			   <td>
			     <cfinput type="text" 
				 name="IPRangeEnd" 
				 size="15" 
				 maxlength="15" 
				 class="regularxl"		 
				 required="No"
				 style="text-align: center;" 
				 message="Please enter a valid IP range end" 
				 validate="regular_expression" 
				 pattern="^[1-9]\d?\d?\.[1-9]\d?\d?.[0-9]\d?\d?.[0-9]\d?\d?$" visible="Yes" enabled="Yes">
			   </td>	
			   
			   <td>
			   
			    <select name="Mission" id="Mission" class="regularxl">
				    <option value="">n/a</option>
					<cfoutput query="getMission">
					<option value="#mission#">#Mission#</option>
					</cfoutput>
				</select>		
				
			   </td>	   
			   
			   <td width="375">
			     <table cellspacing="0" cellpadding="0">
				 <tr><td>
				 
			     	<select name="Redirect" id="Redirect" onchange="toggle(this.value)" class="regularxl">
						 <option value="URL" selected>URL</option>
						 <option value="Disabled">Disabled</option>
					</select>
					
				 </td>
				 <td style="padding-left:3px">
							 	
			    <select name="ServerURL" id="ServerURL" class="regularxl">				
					<cfoutput query="getLink">
					<option value="#ApplicationRoot#" selected>#ApplicationRoot#</option>
					</cfoutput>
				 </select>		
				 
				 <!---
				 
			     <cfinput type="Text"
			       name="ServerURL"
			       value="#IPTableLast.ServerURL#"
			       message="Please enter a valid #SESSION.welcome# URL"
			       validate="URL"
			       required="No"
			       visible="Yes"
			       enabled="Yes"
				   typeahead="No"
				   class="regularxl"
				   style="width:280"		     
			       maxlength="80">
				   --->
				   
				   </td></tr></table>
			   </td>
			   <td colspan="4" align="left">
			   <input type="submit" name="submit" id="submit" style="height:25px" value="Save" class="button10g">
									
			</cfif>	
			
			</table>
			
			</tr>
			
			</table>
				
	</cfform>

</td></tr>
	
</table>