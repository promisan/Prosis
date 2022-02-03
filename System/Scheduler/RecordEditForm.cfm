<cfif url.collectionid neq "">
	
	<cfquery name="Collection" 
	datasource="AppsSystem" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT *
	    FROM   Collection
		WHERE  CollectionId = '#URL.Collectionid#'	
	</cfquery>

</cfif>

<cfform action="RecordSubmit.cfm?ID=#URL.ID#&collectionid=#url.collectionid#" method="POST" jquary="Yes" name="entry" target="result">
						
		<table width="92%" align="center" class="formpadding">
		
		<tr>		
			<td height="20" class="labelmedium" width="25%">Module:</td>
			<TD class="labelmedium">
			
			<cfif URL.ID eq "">
			
				<cfif url.collectionid neq "">
				
					<cfoutput>
					#Collection.SystemModule#
					<input type="hidden" name="CollectionId" id="CollectionId" value="#collection.collectionid#">			
					<input type="hidden" name="SystemModule" id="SystemModule" value="#collection.systemmodule#">
					</cfoutput>		
														
				<cfelseif SESSION.isAdministrator eq "No">  
			 
					<cfquery name="Module" 
					datasource="AppsSystem" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
						SELECT DISTINCT S.SystemModule, S.Description
						FROM   Ref_SystemModule S, 
							   Organization.dbo.OrganizationAuthorization A
						WHERE  A.ClassParameter = S.RoleOwner
						AND    A.UserAccount = '#SESSION.acc#'
						AND    A.Role = 'AdminSystem'
						AND    S.Operational = '1'
					</cfquery>
					
					<select class="regularxl" name="SystemModule" id="SystemModule">
					<cfoutput query="Module">
					   <option value="#SystemModule#">#SystemModule#</option>
					</cfoutput>
					</select>				
			
				<cfelse>
			
					<cfquery name="Module" 
					datasource="AppsSystem" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
						SELECT  DISTINCT S.SystemModule, S.Description
						FROM    Ref_SystemModule S
						WHERE   S.Operational = '1'
					</cfquery>
					
					<select class="regularxl" name="SystemModule" id="SystemModule">
					<cfoutput query="Module">
					   <option value="#SystemModule#">#SystemModule#</option>
					</cfoutput>
					</select>				
				
				</cfif>
				
			<cfelse>		
				
					<cfoutput>#Line.SystemModule#</cfoutput>
					
			</cfif>	
			
			</TD>
			
		</TR>	
		
		<TR>
	    <TD class="labelmedium" height="20">Name</TD>
		<TD class="labelmedium">
		<cfif URL.ID eq "">
		     <cfif url.collectionid neq "">
	 			<cfinput type="Text" name="ScheduleName" message="Please enter a schedule name" value="#collection.collectionname#" required="Yes" visible="Yes" enabled="Yes" size="30" maxlength="30" class="regularxl">
			 <cfelse>
				<cfinput type="Text" name="ScheduleName" message="Please enter a schedule name" required="Yes" visible="Yes" enabled="Yes" size="30" maxlength="30" class="regularxl enterastab">
			</cfif>	
		<cfelse>
			<cfoutput>#Line.ScheduleName#</cfoutput>
		</cfif>
		</TD>
		</tr>
		
		<tr>
	    <TD class="labelmedium">Host:</TD>
		<TD class="labelmedium">
		
		<cfif url.collectionid neq "">
				
			<cfoutput>#Collection.ApplicationServer#				
			<input type="hidden" name="ApplicationServer" id="ApplicationServer" value="#collection.ApplicationServer#">
			</cfoutput>
				
		<cfelse>		
		
			<select name="ApplicationServer" id="ApplicationServer" onchange="check()" class="regularxl enterastab">
			<cfoutput query="AppServer">
			   <option value="#ApplicationServer#" <cfif Line.ApplicationServer eq ApplicationServer or (Line.applicationServer eq "" and ApplicationServer eq CGI.HTTP_HOST)>selected</cfif>>#ApplicationServer#</option>
			</cfoutput>
			</select>
			
		</cfif>
			
		</TD>
		</TR>	
						
		<tr>
	    <TD class="labelmedium">Template&nbsp;path/name:</TD>
		<TD>
		
		<cfif Line.scheduleClass eq "System">
		    <cfoutput>
			<input type="text" name="ScheduleTemplate" id="ScheduleTemplate" value="#Line.ScheduleTemplate#" readonly size="90" maxlength="100" class="regularxl">	
			</cfoutput>
		<cfelse>
		    <cfif url.collectionid neq "">
			    <cfif Collection.IndexDataTemplate neq "">
			     	<input readonly type="text" name="ScheduleTemplate" id="ScheduleTemplate" value="<cfoutput>#Collection.IndexDataTemplate#</cfoutput>" required="Yes" size="90" maxlength="100" class="regularxl">		
				<cfelse>
				   	<input readonly type="text" name="ScheduleTemplate" id="ScheduleTemplate" value="/system/Collection/CaseFile/CollectionIndex.cfm" required="Yes" size="90" maxlength="100" class="regularxl">						
				</cfif>	
			<cfelse>
				<cfinput type="text" name="ScheduleTemplate" onchange="check()" value="#Line.ScheduleTemplate#" message="you must register a template file name" required="Yes" size="90" maxlength="100" class="regularxl">
			</cfif>
		</cfif>	
		
		</TD>
		</TR>	
		
		<tr>
	    <TD class="labelmedium">Query String:</TD>
		<TD class="labelmedium">
		 <cfif url.collectionid neq "">
		   <input readonly type="text" name="SchedulePassThru" id="SchedulePassThru" value="<cfoutput>collectionid=#collectionid#</cfoutput>" required="No" size="70" maxlength="80" class="regularxl">
		 <cfelse>
		   <cfinput type="text" name="SchedulePassThru" value="#Line.SchedulePassThru#" required="No" size="70" maxlength="80" class="regularxl enterastab">
		 </cfif>
		
		</TD>
		</TR>	
		
		<tr><td></td><td class="labelmedium">Enter passthru query string example : ID1=AAA&ID2=BBB </td></tr>
		
		<tr><td></td><td id="ifilecheck"></td></tr>
		
		<cfif url.id eq "">
		  <cfset d = "#Dateformat(now(), CLIENT.DateFormatShow)#">
		<cfelse>
		  <cfset d = "#Dateformat(Line.ScheduleStartDate, CLIENT.DateFormatShow)#">
		</cfif>
		
		<tr>
	    <TD class="labelmedium">Chained task of :</TD>
		<TD class="labelmedium"> 

		<cfquery name="Parent" 
				 datasource="AppsSystem" 
				 username="#SESSION.login#" 
				 password="#SESSION.dbpw#">
					SELECT  *
					FROM    Schedule
					WHERE  1=1 
					<cfif url.id neq "">
					AND ScheduleId  != '#url.id#'
					</cfif>
					<cfif Line.recordcount eq 1>
					AND SystemModule = '#Line.SystemModule#'
					</cfif>
					ORDER BY SystemModule
		</cfquery>
		
		<cfselect name="ParentScheduleId"
	          group="SystemModule"
	          queryposition="below"
			  onchange="timetoggle(this.value)"
	          query="Parent"
	          value="ScheduleId"
	          display="ScheduleName"
	          selected="#Line.ParentScheduleId#"
	          visible="Yes"
	          enabled="Yes"
	          class="regularxl enterastab">
		    <option value="">--- n/a ---</option>			
		</cfselect>
				
		</TD>
		</TR>	
		
		<cfif Line.ParentScheduleId neq "">
			 <cfset cl = "hide">
		<cfelse>
			<cfset cl = "regular">	 
		</cfif>
			
		<tr name="timebox" class="<cfoutput>#cl#</cfoutput>"><td class="labelmedium">Date start:</td>
		<td>
		 <cf_calendarscript>
		 <cf_intelliCalendarDate9
			FieldName="ScheduleStartDate" 
			Default="#d#"
			class="regularxl enterastab"
			DateValidEnd="#dateformat(now()+10,'YYYYMMDD')#"
			AllowBlank="False">	
		</td>
		</td>		
				
		<tr name="timebox" class="<cfoutput>#cl#</cfoutput>">
	    <TD class="labelmedium"><cf_tl id="Interval">:</TD>
		<TD class="labelit">
		<select name="ScheduleInterval" id="ScheduleInterval" class="regularxl" onchange="ColdFusion.navigate('setTime.cfm?schedule='+this.value,'schedulebox')">
		<option value="600" <cfif "600" eq Line.ScheduleInterval>selected</cfif>>Every 10 mins</option>
		<option value="900" <cfif "900" eq Line.ScheduleInterval>selected</cfif>>Every 15 mins</option>
		<option value="3600" <cfif "3600" eq Line.ScheduleInterval>selected</cfif>>Hourly</option>
		<option value="7200" <cfif "7200" eq Line.ScheduleInterval>selected</cfif>>Every 2 hours</option>
		<option value="10800" <cfif "10800" eq Line.ScheduleInterval>selected</cfif>>Every 3 hours</option>
		<option value="21600" <cfif "21600" eq Line.ScheduleInterval>selected</cfif>>Every 6 hours</option>
		<option value="Once" <cfif "Once" eq Line.ScheduleInterval>selected</cfif>>Once</option>
		<option value="Daily" <cfif "Daily" eq Line.ScheduleInterval or URL.ID eq "">selected</cfif>>Daily</option>
		<option value="Weekly" <cfif "Weekly" eq Line.ScheduleInterval>selected</cfif>>Weekly</option>
		<option value="Monthly" <cfif "Monthly" eq Line.ScheduleInterval>selected</cfif>>Monthly</option>
		<option value="Manual" <cfif "Manual" eq Line.ScheduleInterval>selected</cfif>>Manual</option>
		<!---
		<input type="radio" class="radiol" name="ScheduleInterval" id="ScheduleInterval" value="900" <cfif "900" eq Line.ScheduleInterval>checked</cfif>>Every 15 minutes		
		<input type="radio" class="radiol" name="ScheduleInterval" id="ScheduleInterval" value="3600" <cfif "3600" eq Line.ScheduleInterval>checked</cfif>>Hourly
		<input type="radio" class="radiol" name="ScheduleInterval" id="ScheduleInterval" value="Once" <cfif "Once" eq Line.ScheduleInterval>checked</cfif>>Once	
		<input type="radio" class="radiol" name="ScheduleInterval" id="ScheduleInterval" value="Daily" <cfif "Daily" eq Line.ScheduleInterval or URL.ID eq "">checked</cfif>>Daily
		<input type="radio" class="radiol" name="ScheduleInterval" id="ScheduleInterval" value="Weekly" <cfif "Weekly" eq Line.ScheduleInterval>checked</cfif>>Weekly
		<input type="radio" class="radiol" name="ScheduleInterval" id="ScheduleInterval" value="Monthly" <cfif "Monthly" eq Line.ScheduleInterval>checked</cfif>>Monthly
		<input type="radio" class="radiol" name="ScheduleInterval" id="ScheduleInterval" value="Manual" <cfif "Manual" eq Line.ScheduleInterval>checked</cfif>>Manual
		--->
		</select>
		<td class="hide" id="schedulebox"></td>
						
		
		</TR>	
		
		<tr name="timebox" class="<cfoutput>#cl#</cfoutput>"><td class="labelmedium">Time:</td>
		<td>	
		<table><tr><td class="labelmedium">Start:</td>
		<td style="padding-left:10px">
		<cfset hr = left(Line.ScheduleStartTime,2)>
		<cfset mn = mid(Line.ScheduleStartTime,4,2)>
		
		<cfif hr eq ""> <cfset hr = "00"> </cfif>
		<cfif mn eq ""> <cfset mn = "00"> </cfif>
		
		      <cfinput type="Text"
		       name="hour"
		       value="#hr#"
		       maxlength="2"
		       message="Please enter a valid hour between 00 and 23"
		       validate="regular_expression"
		       pattern="[0-9]|[0-1][0-9]|[2][1-3]"
			   onKeyUp="return autoTab(this, 2, event);"
		       size="1"
			   required="yes"
		       style="text-align: center"
		       class="regularxl enterastab">
													
		   :	   
		 		
			<cfinput type="Text"
		       name="minute"
		       value="#mn#"
		       message="Please enter a valid minute between 00 and 59"
		       maxlength="2"
			   validate="regular_expression"
		       pattern="[0-9]|[0-5][0-9]"
		       required="yes"
		       size="1"
		       style="text-align: center"
		       class="regularxl enterastab">
		</td>
		
		<cfif Line.ScheduleInterval eq "600" or Line.ScheduleInterval eq "900" or Line.ScheduleInterval eq "3600">
			<cfset cl = "labelmedium">
		<cfelse>			
		    <cfset cl = "hide">
		</cfif>
		
		<cfoutput>
						
		<td name="endtimebox" style="padding-left:20px" class="#cl#">End:</td>
		<td name="endtimebox" style="padding-left:10px" class="#cl#">	
		
		<cfset hr = left(Line.ScheduleEndTime,2)>
		<cfset mn = mid(Line.ScheduleEndTime,4,2)>
		
		<cfif hr eq ""> <cfset hr = "00"> </cfif>
		<cfif mn eq ""> <cfset mn = "00"> </cfif>
		
		      <cfinput type="Text"
		       name="ehour"
		       value="#hr#"
		       maxlength="2"
		       message="Please enter a valid hour between 00 and 23"
		       validate="regular_expression"
		       pattern="[0-9]|[0-1][0-9]|[2][1-3]"
			   onKeyUp="return autoTab(this, 2, event);"
		       size="1"
			   required="yes"
		       style="text-align: center"
		       class="regularxl enterastab">
													
		   :	   
		 		
			<cfinput type="Text"
		       name="eminute"
		       value="#mn#"
		       message="Please enter a valid minute between 00 and 59"
		       maxlength="2"
			   validate="regular_expression"
		       pattern="[0-9]|[0-5][0-9]"
		       required="yes"
		       size="1"
		       style="text-align: center"
		       class="regularxl enterastab">
		</td>
		
		</cfoutput>
		
		</tr>
		</table>
		
		</td>
		</tr>

		
		<TR>
	    <TD class="labelmedium">On Misfire:</TD>
		<TD class="labelmedium">
			<cfselect id="misfire" name="misfire" class="regularxl">
				<option value="" <cfif Line.ScriptMisfire eq "">selected</cfif> >No action</option>
				<option value="fire_now" <cfif Line.ScriptMisfire eq "fire_now">selected</cfif> >Try to run the task immediately</option>
			</cfselect>
		</TD>
		</TR>	
		
		<cfif url.id eq "">
		  <cfset t = 1000>
		<cfelse>
		  <cfset t = "#Line.ScriptTimeOut#">
		</cfif>
		
		<tr>
	    <TD class="labelmedium">Timeout after:</TD>
		<TD class="labelmedium"><cfinput type="Text"
	       name="ScriptTimeOut"
	       value="#t#"
	       validate="integer"
	       required="No"
	       visible="Yes"
		   enabled="Yes"
	       size="3"
	       maxlength="5"
		   style="text-align:center"
	       class="regularxl enterastab"> sec.
		</TD>
		</TR>
		
		<cfif URL.id neq "">
		
			<cfquery name="Host" 
			datasource="AppsControl" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				SELECT *
				FROM  ParameterSite
				WHERE ApplicationServer = '#Line.ApplicationServer#'
			</cfquery>
						
			<TR>
		    <TD class="labelmedium">Enabled:</TD>
		    <TD class="labelmedium">
		    	<cfif CGI.HTTP_HOST neq "#Host.HostName#">
		    		<cfif Line.Operational eq 1> Yes <cfelse> No </cfif>
		    	<cfelse>
					<cfinput type="radio" class="radiol enterastab" name="operational" id="operational" value="1"  checked="#Line.Operational eq 1#"/>Yes
					<cfinput type="radio" class="radiol enterastab" name="operational" id="operational" value="0"  checked="#Line.Operational eq 0#"/>No
				</cfif>
			</td>
			</tr>
		
		</cfif>
		
		<cfif url.id eq "">
		  <cfset t = client.eMail>
		<cfelse>
		  <cfset t = "#Line.ScriptFailureMail#">
		</cfif>
		
		<tr>
						
			<TR>
		    <td style="padding-left:10px" width="90" class="labelmedium">Mail Failure:</td>			
		    <TD>
			<table><tr><td>
			<cfinput type="Text"
		       name="ScriptFailureMail"
		       message="Please enter a valid eMail address"	      
			   OnChange="ptoken.navigate('ScheduleMail.cfm?address='+this.value,'mailfailure')"
		       required="No"
			   tooltip="please enter a valid eMail address"
		       visible="Yes"
		       enabled="Yes"
			   value="#t#"
		       size="50"
		       maxlength="100"
		       class="regularxl enterastab"></td><td style="padding-left:4px" class="labelit" colspan="1" id="mailfailure"></td>
			   </tr></table>		   
			   </td>
			</TR>
						
			<cfif url.id eq "">
		  		<cfset t = client.eMail>
			<cfelse>
			  <cfset t = "#Line.ScriptSuccessMail#">
			</cfif>
			
			<TR>
		    <td style="padding-left:10px" class="labelmedium">Mail Success:</td>
		    <TD>
			<table><tr><td>
			<cfinput type="Text"
		       name="ScriptSuccessMail"
		       message="Please enter a valid eMail address"
			   OnChange="ptoken.navigate('ScheduleMail.cfm?address='+this.value,'mailsuccess')"
		       required="No"
			   tooltip="please enter a valid eMail address"
		       visible="Yes"
		       enabled="Yes"
			   value="#t#"
		       size="50"
		       maxlength="100"
		       class="regularxl enterastab"></td><td style="padding-left:4px" class="labelit" colspan="1" id="mailsuccess">
			   </tr></table>		   
			   </td>
			</TR>
								   
		<TR>
	    <td valign="top" style="padding-top:3px" class="labelmedium">Memo:</td>
	    <TD><cfoutput><textarea style="width:96%;height:40px;padding:3px;font-size:14px" name="ScheduleMemo" class="regular">#Line.ScheduleMemo#</textarea></cfoutput></td>
		</TR>
		
		<tr><td class="linedotted" colspan="2"></td></tr>
		
		<tr>
			<td colspan="2" align="center">

		    <table align="center" class="formspacing">

			   <tr>
			  
			     <td valign="top">
			   		<input type="button" class="button10g" onclick="parent.ProsisUI.closeWindow('schedulebox')"  name="cancel" id="cancel" value = "Cancel">
				 </td>
				 
				 <td valign="top">
				 
					 <cfif url.id eq "">
				    
					  	<input class="hide" type="submit" name="update" id="update" value="Save">			 
					 
					 <cfelse>		
					 
					 	<input type="submit" class="button10g" name="update" id="update" value ="Save">
						
					 </cfif>
				 
			     </td>			 
				 
			   </tr>
		   
	       </table>	
		   
		  </td>
		</tr>	
		
		</table>	
		
</CFFORM>
		
<script>
	check()
</script>		
