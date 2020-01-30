

<cfquery name="Program" 
   datasource="AppsProgram" 
   username="#SESSION.login#" 
   password="#SESSION.dbpw#">
   SELECT *
   FROM   Program
   WHERE  ProgramCode = '#URL.ProgramCode#'
</cfquery>

<cfif Program.recordcount eq "1">

<cf_screenTop height="100%" 
	    label="Move #Program.ProgramClass# - #Program.ProgramName#" 
		bannerheight="60" 
		border="0" 	
		band="no"
		user="no"
		banner="gray"
		jquery="Yes"
		line="No"		
		scroll="yes" 
		layout="webapp">
		
<cfelse>

<cf_screenTop height="100%" 
	    label="Select" 
		bannerheight="60" 
		border="0" 	
		band="no"
		user="no"
		banner="gray"
		jquery="Yes"
		line="No"		
		scroll="yes" 
		layout="webapp">


</cfif>		
	
<cfoutput>
			
	<script>
				
	function programselected(pid,org) {
		    
    	<cfif url.applyscript neq "">			
		try {
			parent.#url.applyscript#(pid,'#url.scope#',org);	
		} catch(e) {}	
	    </cfif>		
		parent.ColdFusion.Window.destroy('programwindow',true);	
		
		}
		
	</script>
		
		
	<table cellspacing="0" height="99%" width="100%" cellpadding="0">
		<tr><td valign="top" style="min-width:290px;padding-left:4px;border-right: solid 1px silver">
			<cfinclude template="ProgramTree.cfm">
			</td>			
			<td width="80%" valign="top">
			<cf_divscroll id="right"></cf_divscroll>
			
			</td>
		</tr>
	</table>		
		
</cfoutput>

<cf_screenbottom layout="webapp">
