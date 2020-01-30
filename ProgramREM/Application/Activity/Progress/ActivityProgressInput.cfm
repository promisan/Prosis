
<cfoutput>

<input type="hidden" name="ProgramCode_#line#" id="ProgramCode_#line#" value="#ProgramCode#">
<input type="hidden" name="ActivityPeriod_#line#" id="ActivityPeriod_#line#" value="#ActivityPeriod#">
<input type="hidden" name="OutputId_#line#" id="OutputId_#line#" value="#OutputId#">

<table width="94%" border="0" bordercolor="e4e4e4" align="center">
						
	<tr>
	  <td colspan="3">
	  
    	<table width="100%" border="0" cellspacing="0" cellpadding="0" align="center" class="formpadding">
		
		<cfif ListPriorProgress.recordCount eq "1" and ListPriorProgress.ProgressStatus neq "0">
    		<tr><td colspan="6" align="right" class="labelit"><cf_tl id="PreviouslySubmittedBy">:&nbsp;<b>#ListPriorProgress.OfficerFirstName# #ListPriorProgress.OfficerLastName#</b> on : <b>#Dateformat(ListPriorProgress.Created, CLIENT.DateFormatShow)#</b>&nbsp;</td></tr>
		</cfif>
		
		<tr><td height="3"></td></tr>
		
		<tr>
		 	     
		   <td class="labelmedium"><cf_tl id="Report date">:</td>
		   <td>
		   
		      <cf_intelliCalendarDate9
			FieldName="ProgressStatusDate_#line#" 
			Default="#Dateformat(now(), CLIENT.DateFormatShow)#"
			AllowBlank="False"
			class="regularxl">	
		  
									
		</td>
		</tr>
		
		<tr><td height="3"></td></tr>
		
		<tr>
		 
		  <td class="labelmedium" width="100"><cf_tl id="Status">:</td>
		  <td class="labelmedium" style="padding-top:2px">
		  
		  <table><tr class="labelmedium">
		  
		  <cfquery name="RefStatus" 
			datasource="AppsProgram"
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			    SELECT * 
			    FROM  Ref_Status
				WHERE ClassStatus = 'Progress'
			</cfquery>
			
			<cfset fst = "0">
		  
		  <cfloop query = "RefStatus">
		 		 	  
			  <cfif PointerDate eq "0">
			  
			  	<td>
			       <input type="radio" class="radiol" name="ProgressStatus_#line#" id="ProgressStatus_#line#" value="#Status#" <cfif fst eq "0">checked</cfif> onClick="javascript: revise(this.value,'#line#-#Out#')"></td>
				   <td style="padding-left:4px;padding-right:7px">#Description#</td>
			   	   <cfset fst = "1">	
				   	  
			  <cfelseif PointerDate eq "1" and now() lt outdte>
				<td>	  
			   	   <input type="radio" class="radiol" name="ProgressStatus_#line#" id="ProgressStatus_#line#" value="#Status#" <cfif fst eq "0">checked</cfif> onClick="javascript: revise(this.value,'#line#-#Out#')"></td>
				   <td style="padding-left:4px;padding-right:7px">#Description#</td>
				   <cfset fst = "1">		
				      
			  </cfif> 
		
	      </cfloop>  
		  
		  </tr></table>
		  
		  </td>
		</tr>
				
		<tr id="Rev#Line#-#Out#" class="hide">		 
	      
		   <td width="100" class="labelmedium" height="25"><cf_tl id="NewTarget">:</td>
		   <td>
		   
		   <table cellspacing="0" cellpadding="0">
		   <tr><td>
		   
		        <cf_intelliCalendarDate9
			FieldName="RevisedOutputDate_#line#" 
			Default="#Dateformat(Output.ActivityOutputDate, CLIENT.DateFormatShow)#"
			class="regularxl"
			AllowBlank="False">	
			
			</td>
			<td width="100" align="right" class="labelmedium"><cf_tl id="Percentage">:</td>
			<td> <input type="text" class="regularxl" name="Percentage_#line#" id="Percentage_#line#" value="0" size="2" style="text-align:center;width:30px" maxlength="2"> % </td>
			</tr>
			
			</table>
		   
			</td>
						
		</tr>
		
		<tr><td height="3"></td></tr>
		
		<tr>
	   	
		  <td height="50" valign="top" style="padding-top:4px" class="labelmedium">
		   <cf_tl id="Memo">:
		  </td>
		  
		  <td>
		  <textarea name="ProgressMemo_#line#"
		            class="regular"
		            style="height:40;width:98%;font-size:14px;padding:3px"></textarea> 
		  	  
		  </td>
		  
		</tr>
		
		<tr><td height="2"></td></tr>
				
		<TR>
			 	 
		 <cf_assignid>	
			
		 <cfset att = Right(rowguid, 12)>
		
		 <td colspan="2">	
		 
		 <table width="100%" cellspacing="0" cellpadding="0">
		 <tr><td>
										 
		 	<cf_filelibraryN
					DocumentPath="#Param.DocumentLibrary#"
					SubDirectory="#ProgramCode#" 
					Filter="#att#"
					box="att#att#"
					Insert="yes"
					Remove="yes"
					LoadScript="No"
					Highlight="no"
					Rowheader="no"
					Width="100%"
					Listing="yes">		

		</td></tr>			
		</table>	 									 
							
		 </TD>
		 
		 <input type="hidden" name="Attach_#line#" id="Attach_#line#" value="#att#">	
		 
		</TR>
						
		<tr><td height="8"></td></tr>
		
	</table>
	
	</table>
	
	
</cfoutput>	

<cfset ajaxonload("doCalendar")>