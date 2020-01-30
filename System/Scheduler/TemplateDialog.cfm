
<cfquery name="Line" 
datasource="AppsSystem" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT L.*
    FROM Schedule L
	WHERE ScheduleId = '#URL.ID#'	
</cfquery>

<cfoutput>
	
	  <cfparam name="url.file" default="">
	 
	  <table width="100%" height="100%" border="0" cellspacing="0" cellpadding="0">
			
			<td width="55%" height="25" class="labelit">
			
				<cfif SESSION.isAdministrator eq "Yes">
				<img src="#client.virtualdir#/Images/finger.gif" alt="" border="0" align="absmiddle">
				&nbsp;
				<a alt="Execute this script" href="#SESSION.root#/tools/scheduler/RunScheduler.cfm?id=#Line.scheduleName#&#Line.SchedulePassThru#&mode=trial" target="_blank">
				<font size="2" color="0080FF">Press here to Manually Execute script</font></a>
				</cfif>
			</td>
			
			<td width="45%" align="right" style="padding-right:5px" class="labelit">#Line.ScheduleTemplate#</td>
			
			</tr>
			
			<tr><td colspan="2" class="linedotted" height="1"></td></tr>
			
			<tr><td colspan="2" valign="top" width="100%" height="100%" style="font-family : arial; font-size : 8pt;">
			
			<cf_divscroll>			
			<cfinvoke component="Service.Presentation.ColorCode"  
				   method="colorfile" 
				   filename="#SESSION.rootpath#\#line.ScheduleTemplate#" 
				   returnvariable="result">			
				   
	    	   <cfset result = replace(result, "�", "", "all") />		
			   
				#result#	
				
			</cf_divscroll>	
				
				</td>
				
			</tr>	
							   	
			   		
	 </table>
	 
					
</cfoutput>
