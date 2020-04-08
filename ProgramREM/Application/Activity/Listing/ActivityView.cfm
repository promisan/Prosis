
<cfajaximport tags="cfdiv,cfchart,cfwindow">

<cf_dialogREMProgram>

<cfinclude template="../../Budget/Request/RequestScript.cfm">

<cf_tl id="ProjectActivityChart" var="1">

<cfset Heading = " #Lt_text#">
<cfparam name="url.html" default="No">

<cf_screenTop height="100%" 
    label="#heading#" 	
	layout="webapp"
	scroll="Yes"
	horisontal="Yes"
	banner="red"
	jQuery="yes"
	bannerheight="70"
	html="#url.html#" 
	blockevent = "rightclick">	

<cfparam name="URL.Refresh" default="0">
<cfset url.output = "0">

<cfset ProgramFilter = "ProgramCode = '#URL.ProgramCode#'">		

<cfparam name="URL.ProgramCode" default="">
<cfparam name="URL.Period"      default="">

<cfset row = 0>

<!--- Query returning program parameters --->
	<cfquery name="Parameter" 
	datasource="AppsProgram" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
    SELECT *
    FROM Parameter
</cfquery>

<table width="99%" height="100%" align="center" border="0" cellspacing="0" cellpadding="0">

<tr><td colspan="2" valign="top" style="border:0px solid silver" height="30">
	<cfset url.attach = "0">
	<cfinclude template="../../Program/Header/ViewHeader.cfm">
</td></tr>
  
<cfif Program.Status eq "0" and CheckMission.workflowEnabled eq "1" and Program.ProgramClass neq "Program">

	<tr><td style="padding-top:10px;border:0px solid silver;height:100%" colspan="2" class="labellarge" width="100%" valign="top" align="center">
	 <font color="FF0000"><cf_tl id="Your new project record has not been cleared. Please contact your administrator"></td></tr>

<cfelse>
	
	<tr>
	
	<cfinclude template="ActivityViewScript.cfm">

	
	<td colspan="2" valign="top" height="100%" width="100%" align="right">
			
		<cfquery name="Clear" 
		    datasource="AppsProgram" 
		     username="#SESSION.login#" 
		     password="#SESSION.dbpw#">
			 DELETE FROM  ProgramActivityParent
			 WHERE     (ActivityId = ActivityParent)	
		</cfquery>
			 
		<cfquery name="Period" 
		     datasource="AppsProgram" 
		     username="#SESSION.login#" 
		     password="#SESSION.dbpw#">
		     SELECT *
		     FROM   Ref_Period
			 WHERE  Period = '#URL.Period#'
		</cfquery>
		
		<cfset perS = Period.DateEffective>
		<cfset perE = Period.DateExpiration>
		
		<cfquery name="PeriodListing" 
		    datasource="AppsProgram" 
		    username="#SESSION.login#" 
		    password="#SESSION.dbpw#">
		     SELECT *
		     FROM   Ref_Period
			 WHERE  IncludeListing = '1'
			 AND    Period <= (SELECT MAX(Period) FROM ProgramPeriod WHERE ProgramCode = '#URL.ProgramCode#')
			 AND    Period IN (SELECT Period FROM Organization.dbo.Ref_MissionPeriod WHERE Mission = '#url.Mission#') 			
				 
		</cfquery>
			
		<cfoutput>	
		
		<script>
		
			function resetft(val) {							
			try { document.getElementById("ftpln").style.fontWeight  = "normal"; } catch(e) {}
			try { document.getElementById("ftrev").style.fontWeight  = "normal"; } catch(e) {}
			try { document.getElementById("ftana").style.fontWeight  = "normal"; } catch(e) {}
			try { document.getElementById(val).style.fontWeight  = "bold"; } catch(e) {}
			}
			
		</script>	
		
		<table width="99%" height="100%" cellspacing="0" cellpadding="0" align="center">	
		
		    <tr>
			<td colspan="2" style="padding-left:6px;height:30px;">
						
				<table><tr><td class="labelmedium">		
				<cf_tl id="Valid for period">:
				</td>
				
				<td style="padding-left:10px">
				
				<select id="period" class="regularxl" name="period" onChange="menuoption('list','1','0')">
				    <option value=""><cf_tl id="ANY"></option>
					<cfloop query="PeriodListing">
					<option value="#PeriodListing.Period#" <cfif PeriodListing.Period eq URL.Period>selected</cfif>>#Period#</option>
					</cfloop>
				</select>
				
				</td></tr></table>	
				
				</td>
			</tr>
						
			<tr><td width="100%" align="center" height="100%" colspan="2" valign="top">
			
				<table width="99%" height="100%" style="border: 0px solid d4d4d4;">
					<tr><td valign="top" width="100%" height="100%" bgcolor="ffffff" id="detail">	  				
				  		  <cfinclude template="ActivityListing.cfm">								 
					</td></tr>
				</table>
					
				</td>
			</tr>	
			
			</table>
					
		</cfoutput>	
		
	</td>
	</tr>
	
</cfif>	

</table>

<cf_screenbottom html="#url.html#" layout="webapp">