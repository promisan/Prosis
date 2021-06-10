
<cf_textareascript>

<cfparam name="url.caller" default="">

<cf_screentop label="Position Assigment Review"  
     jquery="Yes" height="100%" scroll="No" layout="webapp" banner="gray">
	 
<cfajaximport tags="cfform,cfdiv">
<cf_menuscript>
<cf_actionlistingscript>
<cf_dialogPosition>

<cfoutput>

<script>

 function revert(pos) {
 	ptoken.navigate('resetAssignmentReview.cfm?box=#url.box#&positionno='+pos,pos)
 }
 
 function docheck() {
    ptoken.navigate('doWorkflowCheck.cfm?positionno=#url.id1#','process')
 }
 
</script>
</cfoutput>

<cfquery name="get"
datasource="AppsEmployee" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
	FROM   Position
	WHERE  Positionno = '#url.id1#'
</cfquery>

<cfquery name="language"
datasource="AppsSystem" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
	FROM   Ref_SystemLanguage
	WHERE  LanguageCode != ''
	AND    Operational > 0
	ORDER BY LanguageCode	
</cfquery>

<table width="100%" height="100%" align="center">

	<tr class="hide"><td id="process"></td></tr>

	<tr><td height="40" style="padding-left:2px">
						
		<table width="97%" height="100%" border="0" align="center" class="formpadding">		  		
						
			<cfset ht = "64">
			<cfset wd = "64">
					
			<tr>							
						
					<cf_menutab item       = "1" 					            
					            iconsrc    = "Logos/Staffing/Extension-Request.png" 
								iconwidth  = "#wd#" 
								iconheight = "#ht#" 
								class      = "highlight1"
								name       = "Position"
								source     = "PositionDetails.cfm?id1=#url.id1#&caller=#url.caller#&box=#url.box#">	
					
					<cfset itm = 1>
								
					<cfoutput query="language">		
					
					<cfset itm = itm+1>	
								
				    <cf_menutab item       = "#itm#" 
					            iconsrc    = "Flag/#code#.png" 
								iconwidth  = "#wd#" 								
								iconheight = "#ht#" 							
								name       = "Job Description"
								source     = "PositionProfile.cfm?accessmode=view&id=#get.PositionParentId#&id1=#url.id1#&code=#code#&languagecode=#languagecode#">
								
					</cfoutput>					
					
					<td width="10%"></td>				
																						
																	 		
				</tr>
		</table>
		
		</td>
	</tr>
	
	<tr><td class="linedotted"></td></tr>		
		
	<tr><td style="height:100%">
	
			<cf_divscroll>
			
			<table width="96%" 
			      border="0"
				  height="100%"
				  cellspacing="0" 
				  cellpadding="0" 
				  align="center" 
			      bordercolor="d4d4d4">	  	 		
								
					<cf_menucontainer item="1" class="regular">						
						<cfinclude template="PositionDetails.cfm">	
					<cf_menucontainer>		
										
					
					<cfset itm = 1>
					
					<cfoutput query="language">		
						<cfset itm = itm+1>
						<cf_menucontainer item="#itm#" class="hide"/>	
					</cfoutput>			
					
			</table>
			
			</cf_divscroll>
			
			</td>
	</tr>				
	
</table>	

<cf_screenbottom layout="innerbox">
