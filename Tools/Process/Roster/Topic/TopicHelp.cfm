
<cfparam name="url.code" default="">
<cfparam name="url.listcode" default="">

<cfoutput>

<table width="100%"><tr><td width="100%" style="padding:0px">

<cfif url.listcode eq "">

	<cfquery name="Topic"
	   datasource="AppsSelection"
	   username="#SESSION.login#"
	   password="#SESSION.dbpw#">
         SELECT * 
         FROM   #CLIENT.LanPrefix#Ref_Topic
	  	 WHERE  Topic = '#URL.Code#' 
	</cfquery>	
		
	<cfif topic.tooltip neq "">
		
	<table bgcolor="D3E9F8">	
		<tr><td style="font-size:25px;padding-top:12px;padding:5px" class="labelmedium"><b><font color="0080FF">#Topic.Question#</td></tr>	
		<tr><td style="font-size:29px;padding:5px" class="labellarge">#Topic.TopicLabel#</td></tr>	
		<tr><td style="font-size:18px;padding:5px" class="labelmedium" style="padding:5px">#Topic.Tooltip#</td></tr>	
	</table>
	
	<cfelse>
	
	<table><tr><td class="labelmedium"><cf_tl id="No additional information"></td></tr></table>
	
	</cfif>
	
<cfelse>	

	<cfquery name="Topic"
	   datasource="AppsSelection"
	   username="#SESSION.login#"
	   password="#SESSION.dbpw#">
         SELECT * 
         FROM   #CLIENT.LanPrefix#Ref_Topic
	  	 WHERE  Topic = '#URL.Code#'
	</cfquery>	
	
	<table width="100%">	
	<tr>			
		<cfif topic.tooltip neq "">		
		<td  width="50%" valign="top" style="background-color:rgba(175,238,238,0.75)">								
			<table width="100%">				
				<tr><td style="font-size:25px;padding-top:4px;padding:12px" class="labelmedium"><b><font color="black">#Topic.Question# #Topic.TopicLabel#</td></tr>				
				<tr><td style="font-size:17px;padding:12px" class="labelmedium">#Topic.Tooltip#</td></tr>				
			</table>						
		</td>			
		</cfif>						
	</tr>		
	</table>	
	<td></td>

</cfif>

</td></tr></table>

</cfoutput>
