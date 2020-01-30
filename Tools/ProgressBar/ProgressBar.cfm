
<cfparam name="url.name"                   default="myname">
<cfparam name="url.Color"                  default="f4f4f4">
<cfparam name="url.ProgressColor"          default="FEDFA5">
<cfparam name="url.Width"                  default="400">
<cfparam name="url.Height"                 default="20">

<cfparam name="Attributes.Color"           default="#url.color#">
<cfparam name="Attributes.ProgressColor"   default="#url.ProgressColor#">
<cfparam name="Attributes.Width"           default="#url.Width#">
<cfparam name="Attributes.Height"          default="#url.Height#">

<cfparam name="session.Label_#url.name#"   default="Record">
<cfparam name="session.Count_#url.name#"   default="0">
<cfparam name="session.Base_#url.name#"    default="1">

<cfset label = evaluate("session.Label_#url.name#")>
<cfset base  = evaluate("session.Base_#url.name#")>
<cfset count = evaluate("session.Count_#url.name#")>
<cfif base eq "0">
	<cfset base = 1>
</cfif>

<cfoutput>
	
	<table width="#Attributes.width#" height="#attributes.height#" style="border:1px solid gray">	
		 
	<cfset progress = (count / base) * 100>
	
	<tr><td class="labelmedium" style="padding-left:6px;padding-top:5px">	  
	  	 #label# #count# of #base#	<cfif count eq base><b>Completed</b><cfelse> : #round(progress)#%</cfif>
	     </td>
	</tr>		
		
	<tr><td style="padding:5px">			
			<table width="100%" cellspacing="0" cellpadding="0" height="#attributes.height#" style="border:1px solid silver">			
			<tr>
				<td align="right" class="labelit" style="padding-right:4px" bgcolor="#Attributes.ProgressColor#" width="#round(progress)#%"></td>
				<td bgcolor="white" width="(100-#progress#)%"></td>
			</tr>			
			</table>		
		</td>
	</tr>		
	</table>

	<cfif count eq base>

		<script>
			try { clearInterval ( progressrefresh_#url.name# ) } catch(e) {}
		</script>	
		
	</cfif>

</cfoutput>
