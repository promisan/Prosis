
<cfoutput>

<input type="hidden" name="ProgramCode_#Rec#" value="#ProgramCode#">
<input type="hidden" name="ActivityPeriod_#Rec#" value="#ActivityPeriod#">
<input type="hidden" name="OutputId_#Rec#" value="#OutputId#">


<table width="98%" border="1" align="center" bgcolor="f9f9f9" bordercolor="silver">
		
		<tr>
		<td width="10%" height="20" class="top3n">
		  &nbsp;Output:
		</td>
		<td width="80%" height="20" class="top3n">
		  #ActivityOutput#
		</td>
		<td width="10%" align="right" valign="top" class="top3n">
		    <b>#DescriptionShort# 
			<!--- (#DateFormat(ActivityOutputDate, CLIENT.DateFormatShow)#) --->&nbsp;</b>
		</td>
		</tr>
			
		<tr><td colspan="3">
		
		<table width="100%" border="0" cellspacing="0" cellpadding="0" align="center">
			
		<cfif Progress.recordCount eq "1" and #Progress.ProgressStatus# neq "0">
		<tr>
		<td colspan="6" align="right" class="regular">Previously submitted by :<b>#Progress.OfficerFirstName# #Progress.OfficerLastName#</b> on : <b>#Dateformat(Progress.Created, CLIENT.DateFormatShow)#</b>&nbsp;</td>
		</tr>
		</cfif>
		
		<tr><td height="5"></td></tr>
		<tr>
		 
	       <td width="5%"></td>
		   <td class="labelit"><cf_tl id="Report date">:</td>
		   <td>&nbsp;
		   
		   <cfif CLIENT.DateFormatShow is "US">
		   		   <cfinput type="Text" name="ProgressStatusDate_#Rec#" value="#Dateformat(now(), CLIENT.DateFormatShow)#" message="Please enter a correct date" validate="date" required="Yes" size="10" maxlength="10" style="text-align: center" class="regularxl">
		   <cfelse>
		   		   <cfinput type="Text" style="text-align: center" name="ProgressStatusDate_#Rec#" value="#Dateformat(now(), CLIENT.DateFormatShow)#" message="Please enter a correct date" validate="eurodate" required="Yes" size="10" maxlength="10" class="regularxl">
		   </cfif>
		  
		    <!---											   
	   	   	<cf_intelliCalendarDateLim
			FieldName="ProgressStatusDate_#Rec#" 
			Default="#Dateformat(now(), CLIENT.DateFormatShow)#"
			AllowBlank="False">	
			--->
						
			
		</td>
		</tr>
		<tr class="regular"><td height="5"></td></tr>
		<tr>
		  <td></td>
		  <td class="labelit"><cf_tl id="Status">:</td>
		  <td class="regular">&nbsp;
		  
		  <cfloop query = "Status">
		  		  
		   <cfif Status.Status eq '0'>
			      <input type="radio" class="radiol" name="ProgressStatus_#Rec#" value="#Status.Status#" checked onClick="javascript: revise(this.value,'#Rec#')">&nbsp;#Description#
	   	   <cfelseif URL.Sub eq LastSubPeriod.SubPeriod AND Status.Status eq 2>
		   <cfelse>
				  <input type="radio" class="radiol" name="ProgressStatus_#Rec#" value="#Status.Status#" onClick="javascript: revise(this.value,'#Rec#')">&nbsp;#Description#
	   	   </cfif>
		
	      </cfloop>  
		  
		  
		  
		  </td>
		</tr>
		
		<tr class="regular"><td height="5"></td></tr>
		<tr id="Rev#Rec#" class="hide">
		 
	       <td width="5%"></td>
		   <td class="labelit">New target:</td>
		   <td>&nbsp;
		   
		    <cfif CLIENT.DateFormatShow is "US">
		   		   <cfinput type="Text" style="text-align: center" name="RevisedOutputDate_#Rec#" value="#Dateformat(Output.ActivityOutputDate, CLIENT.DateFormatShow)#" validate="date" required="No" size="10" maxlength="10" class="regularxl">
		   <cfelse>
		   		   <cfinput type="Text" style="text-align: center" name="RevisedOutputDate_#Rec#" value="#Dateformat(Output.ActivityOutputDate, CLIENT.DateFormatShow)#" validate="eurodate" required="No" size="10" maxlength="10" class="regularxl">
		   </cfif>
		  
		    <!---											   
	   	   		  
	   	   	<cf_intelliCalendarDate
			FieldName="RevisedOutputDate_#Rec#" 
			Default=""
			AllowBlank="True">	
			
			--->
		  
		</td>
		</tr>
		
		<tr><td height="2"></td></tr>
		<tr>
	   	  <td></td>
		  <td height="50" valign="top" class="regular">
		  <table width="100%">
		     <tr><td class="regular">Memo:</td></tr>
	    	 <tr><td height="50" align="right" valign="bottom">
			 <!--- disabled 
			 <button onClick="spell('document.report.ProgressMemo_#Rec#.value', 'document.report.ProgressMemo_#Rec#.value')"><img src="../../../../Images/spell.GIF" alt="" width="22" height="22" border="0"></button>
			 --->
		 	 </td></tr>
		  
		  </table>
		  </td>
		  
		  <td>
<!---	  &nbsp;&nbsp;<textarea cols="70" rows="5" name="ProgressMemo_#Rec#" class="regular"></textarea> &nbsp; --->
	  <cf_LanguageInput
			TableCode       = "ProgramActivityProgress" 
			Mode            = "Edit"
			Name            = "ProgressMemo"
			NameSuffix      = "_#Rec#"
			Value           = ""
			Key1Value       = "#Output.ProgramCode#"
			Key2Value       = "#Output.ActivityPeriod#"
			Key3Value       = "-99"
			Type            = "Text"
			Rows			= "2"
			Cols            = "100" 
			maxlength       = "300"
			Class           = "regular">   

		  </td>
		  
		</tr>
		
		<tr><td height="5"></td></tr>

	</table>
	
</cfoutput>	