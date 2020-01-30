

<cfquery name="Param" 
	    datasource="AppsProgram" 
	    username="#SESSION.login#" 
	    password="#SESSION.dbpw#">
	    SELECT *
	    FROM  Parameter
</cfquery>

<cf_tl id="This activity is dependent on the completion of" var="1" class="message">
<cfset msg1="#lt_text#">

<cfquery name="Output" 
datasource="AppsProgram" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT    O.*, T.TargetDueDate, T.TargetReference, T.TargetDescription, T.TargetIndicator,
	          (SELECT Description FROM Ref_ProgramCategory WHERE Code = O.ProgramCategory) as CategoryName
	FROM      #CLIENT.LanPrefix#ProgramActivityOutput O LEFT OUTER JOIN #CLIENT.LanPrefix#ProgramTarget T ON O.TargetId = T.TargetId
	WHERE     O.ActivityId = '#url.ActivityId#' 
	AND       O.RecordStatus != '9'
	ORDER BY  ActivityOutputDate 
</cfquery>

<cfparam name="URL.ProgramCode"  default="#Output.ProgramCode#">
<cfparam name="URL.Period"       default="#Output.ActivityPeriod#">
<cfparam name="url.periodfilter" default="#url.period#">
<cfparam name="url.mode" default="read">

<cfoutput>

<table width="100%" cellspacing="0" cellpadding="0">

<cf_filelibraryCheck
		DocumentPath="#Param.DocumentLibrary#"
		SubDirectory="#URL.ProgramCode#" 
		Filter="act#url.activityid#">	
		
<cfif files gte "1">		
	
	<tr><td style="padding-right:15px" >
		
		<cf_filelibraryN
			DocumentPath="#Param.DocumentLibrary#"
			SubDirectory="#URL.ProgramCode#" 
			Filter="act#url.activityid#"
			Insert="no"
			Box="att#url.activityid#"
			loadscript="no"
			Remove="no"
			Highlight="no"
			Rowheader="no"
			Width="100%"
			Listing="yes">	
							
	</td></tr>			

</cfif>

<tr><td id="box#activityid#">
			 
	<table width="100%" border="0" cellspacing="0" cellpadding="0">
			
	<cfset line = 0>	
	<cfset period = "">
	<cfset out = 0>
			 
	<cfif Output.recordcount eq "0">
	
		<tr><td align="center" class="labelit"><font color="red"><cf_tl id="No outputs defined"></td></tr>
	
	<cfelse>		 
			 
		<cfloop query="Output">
		
		    <cfset out = out + 1>
			<cfset outdte = ActivityOutputDate>
								
			<tr class="line" bgcolor="fafafa">
		   		<td valign="top"  height="20" width="4%" style="padding-top:2px;padding-left:7px"><font color="gray">
				
				<cfif targetid neq "">
					<img src="#SESSION.root#/Images/logos/program/target.png" height="15" alt="Milestone/Output" border="0" align="absmiddle">
				<cfelse>
					<img src="#SESSION.root#/Images/milestone.png" height="15" alt="Milestone/Output" border="0" align="absmiddle">
				</cfif>
				
				</td>	    	
				<td valign="top" width="10%" style="padding-top:1px;padding-left:7px;padding-right:7px" class="labelit">
				<font color="gray">
				<cfif targetid neq "">
				#DateFormat(TargetDueDate, CLIENT.DateFormatShow)#
				<cfelse>
				#DateFormat(ActivityOutputDate, CLIENT.DateFormatShow)#
				</cfif>
				</font>
				</td>	
		    	<td valign="top" width="74%" class="labelit" style="padding-right:5px"><font color="gray">
				<cfif targetid neq "">
				<table>
					<tr><td class="labelit"><b>#TargetReference#</b> - #TargetDescription#</td></tr>
					<tr><td class="labelit">#TargetIndicator#</td></tr>
				</table>
				<cfelse>
				#ActivityOutput#
				</cfif>
				</td>
				<td valign="top" width="14%" class="labelit" style="padding-top:1px;padding-right:5px"><font color="gray">#CategoryName#</td>					
		
			</tr>
			
	   </cfloop>
					
	</cfif> 
	     
    </table>	
					  
	</td>
</tr>	
	
</table>
	
</cfoutput>


