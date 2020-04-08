
<!--- output entry dialog --->

<cfquery name="Activity" 
datasource="AppsProgram" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
    FROM   ProgramActivity A 
	WHERE  ActivityId = '#URL.ID#' 
</cfquery>

<cfquery name="Output" 
datasource="AppsProgram" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
    FROM   ProgramActivityOutput O 
	WHERE  ActivityId = '#URL.ID#'
	AND    RecordStatus != '9' 
	AND    OutputId = '#URL.Outputid#'	
</cfquery>

<cfquery name="qClass" 
datasource="AppsProgram" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT 	PC.*
	FROM   	Program P
			INNER JOIN Ref_ProgramClass PC
				ON P.ProgramClass = PC.Code
	WHERE  	P.ProgramCode = '#Activity.programcode#'
</cfquery>

<cfset vPeriodFieldsMode = "Text">
<cfif qClass.EntryMode eq "Regular">
	<cfset vPeriodFieldsMode = "Text">
</cfif>
<cfif qClass.EntryMode eq "Editor">
	<cfset vPeriodFieldsMode = "HTML">
</cfif>

<cf_tl id="Deliverable / Milestone" var="1">

<cf_screentop label="#lt_text#" height="100" bannerheight="55" layout="webapp" user="no" banner="gray">

<cfform method="POST" enablecab="Yes" name="outputform">

<cfoutput>

<table width="100%" height="100%" bgcolor="white" cellspacing="0" cellpadding="0">

    <tr><td height="5"></td></tr>
	
	<tr><td valign="top">
	
	<table width="93%" class="formpadding formspacing" cellspacing="0" cellpadding="0" align="center">
	
	<cfquery name="Category" 
		datasource="AppsProgram" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		    SELECT  R.Code, R.Description
		    FROM    ProgramCategory P, Ref_ProgramCategory R
			WHERE   P.ProgramCategory = R.Code 
			AND     P.ProgramCode = '#activity.programcode#'	
			AND     P.Status != '9'
		</cfquery>
		
	  <!--- check which classes are defined for this project --->
	  
	  <cfif Category.recordcount gte "0">
	  	  
		  <tr><td width="80" style="padding-top:4px" valign="top" class="labelmedium"><cf_tl id="Output">:</td>	
		  <td class="labelmedium" width="80%">	
		  <select name="ProgramCategory" id="programcategory"  class="enterastab regularxl">
		  	<option value="">n/a</option>
		  	<cfloop query="Category">
			<option <cfif code eq output.programcategory>selected</cfif> value="#Code#">#code# #Description#</option></cfloop>
		  </select>
		  </td>
		  </td></tr>	
	  
	  </cfif>
	
	<tr>
		
			<td class="labelmedium"><cf_tl id="Completion">:</td>		
			  
			<td width="230" class="labelit">
			   
			   	   <table cellspacing="0" cellpadding="0">
			       <tr>
				   
				   <td class="labelit">
				     <input type="radio" class="enterastab radiol" name="select" value="enddate" onClick="outputend(this.value)"
				     <cfif Output.ActivityOutputDate eq Activity.ActivityDate or Output.ActivityOutputDefault neq "0">checked</cfif>>
				   </td>
				   
				   <td style="padding-left:7px" class="labelmedium">
				    <cf_tl id="Activity End">
				   </td>
				 				   				   
				   <td style="padding-left:17px">				   
		           <input type="radio" class="enterastab radiol" name="select" <cfif dateformat(Output.ActivityOutputDate,client.dateformatshow) neq dateformat(Activity.ActivityDate,dateformatshow)>checked</cfif> value="entry" onClick="outputend(this.value)"> 
				   </td>
				   
				   <td style="padding-left:7px" class="labelmedium">
				   <cf_tl id="Date">					   
				   </td>
				   
				   <td id="outputdte" class="labelit" style="padding-left:10px">					   
				     
					 <cf_space spaces="40">
					 
				   	 <cf_intelliCalendarDate9
						FieldName="activityoutputdate" 
						Default="#Dateformat(Output.ActivityOutputDate, CLIENT.DateFormatShow)#"
						AllowBlank="True"
						class="regularxl enterastab">	
														  
				   </td></tr>
				   
				   </table>			  
					
			</td>
			
		</tr>	
		
		<tr>		
		<td class="labelmedium"><cf_tl id="Reference">:</td>  	  
		<td class="labelit">
		  		<input type="text" 
				   name="referenceoutput" 
				   id="referenceoutput" 				   
				   value="#Output.Reference#" 
				   size="10" 
				   maxlength="10" 
				   class="regularxl enterastab">
		</td>
		
	  </tr>					
		  
	  <tr>
		<td width="80" style="padding-top:4px" valign="top" class="labelmedium"><cf_tl id="Descriptive">:</td>	</tr>
	  </tr>
	  
	  <tr>			  								   						 						  
		<td colspan="2" class="labelmedium" width="80%">	
			
			<cfif vPeriodFieldsMode eq "HTML">
				<cf_textarea name="activityoutput" id="activityoutput"                                            
				   height         = "250"
				   toolbar        = "basic"
				   expand         = "no"
				   init           = "Yes"
				   resize         = "yes"
				   color          = "ffffff">#Output.ActivityOutput#</cf_textarea>
			<cfelse>
				<textarea class="regular" style="font-size:15px;padding:5px;width:100%;height:250px;" name="activityoutput" id="activityoutput">#Output.ActivityOutput#</textarea>
			</cfif>	
		   						
		</td>				   
	   </tr>	
	   	 			
			
	  <tr>	
							   			   
		   <input type="hidden" name="outputid" id="outputid" value="#URL.outputid#">			  			  
	   	   <cf_tl id="Save" var="1">
		   <td colspan="2" align="center" height="40">
			   <input type="button" onclick="updateTextArea();outputsave('save');" value=" <cfoutput>#lt_text#</cfoutput> " class="button10g" style="height:24px;width:140;font-size:13px">
		   </td>

		 </TR>			 
	
	</table>
		
	</td></tr>
	
</table>

</cfoutput>

</cfform>

<cf_screenbottom layout="webapp">

<cfset ajaxonload("doCalendar")>
<cfset ajaxOnLoad("initTextArea")>
	

