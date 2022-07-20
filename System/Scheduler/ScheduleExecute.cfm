
<!--- Query returning search results --->
<cfquery name="Schedule"
	datasource="AppsSystem" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT *
	FROM   Schedule S
	WHERE  ScheduleId = '#URL.ID#'
</cfquery>

<cf_assignId>

<cfoutput>

<!---
<cf_screentop height="100%" bannerheight="40" label="Execute Process" scroll="no" bannerforce="gray" layout="webapp" user="No">
--->

<cf_divscroll>

	<table width="100%" height="100%" bgcolor="white">
	
	<tr><td bgcolor="white" valign="top">
	
		<table width="94%" align="center" class="formpadding">
		
		<tr><td width="130" class="labelit">#Schedule.SystemModule#:</td><td style="height:20px" class="labelmedium" width="80%">#Schedule.ScheduleName#</td></tr>
		
		<tr class="line"><td class="labelit">Requester:</td><td style="height:20px" class="labelmedium">#SESSION.first# #SESSION.last# on #timeformat(now(),"HH:MM:SS")#</td></tr>
						
		<tr class="hide"><td colspan="2" id="run#url.id#"></td></tr>
			
		<tr><td colspan="2" height="450" valign="top">
		
		<cfdiv id="progress#url.id#" style="position:relative;overflow: auto; width:100%; height:420; scrollbar-face-color: F4f4f4;">
			
			<table width="100%">
			<tr><td colspan="2" align="center" height="390">
			
				<button onclick="recordexecute('#url.id#','#rowguid#'); prg = setInterval('showprogress(\'#url.id#\',\'#rowguid#\')', 5000)"			
					style="width:120px;height:40px;background: ##c83702;color:##ffffff;border-radius: 5px;border: none;font-weight: 600;font-size: 16px;padding-top: 2px;"
					name="execute" id="execute"
					type="button"
					value="Close">
					 <cf_tl id="Start"> &nbsp;<img src="#client.virtualdir#/Images/Execute-W.png" alt="" border="0" width="28" height="28" align="absmiddle" style="position: relative;top: -2px;">
				</button>
				
				</td>
			</tr>	
			</table>
			
		</cfdiv>
		
		</td></tr>
		
		<tr><td colspan="2" height="1" class="line"></td></tr>
		
		<tr><td align="center" colspan="2" height="35">
		
		<input type="button" 
		  onclick="showlastaction('#url.id#');ProsisUI.closeWindow('executetask');" 
		  style="width:120px;height:30px;background: ##033f5d;color:##ffffff;border-radius: 5px;border: none;font-weight: 600;font-size: 14px;text-transform: uppercase;" 
		  name="Close" id="Close" value="Close"><br>
		</td></tr>
		
		</table>
	
	</td></tr>
	
	</table>

</cf_divscroll>

</cfoutput>

