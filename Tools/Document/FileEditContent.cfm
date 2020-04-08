<cf_param name="url.openas" default="" type="string">
<cf_param name="url.mode"   default="" type="string">
<cf_param name="url.id"     default="" type="string">

<cfquery name="Att" 
	 datasource="AppsSystem"
	 username="#SESSION.login#" 
	 password="#SESSION.dbpw#">
	     SELECT    TOP 1 *
		 FROM      Attachment
		 WHERE     AttachmentId = '#url.id#'		
</cfquery>

<!--- edit screen for SQL.cfm --->

<cf_screentop height="100%" scroll="No" html="no">

<cfset docHost = att.server> 
<cfset docPath = att.serverpath> 
<cfset docpath = replace(docpath,"|","\","ALL")>

<cfif ParameterExists(Form.Save)> 

	<cfif att.server eq "report">
   
	   	<cffile action="WRITE"
	        file="#docpath#"
	        output="#Form.SQL#"
	        addnewline="Yes"
	        fixnewline="No"> 
		
	<cfelseif att.server eq "Document">
			
			<cffile action="WRITE"
	        file="#SESSION.rootDocumentPath#\#docpath#\#att.filename#"
	        output="#Form.SQL#"
	        addnewline="Yes"
	        fixnewline="No"> 
		
	<cfelse>
		
			<cffile action="WRITE"
	        file="#att.server#\#docpath#\#att.filename#"
	        output="#Form.SQL#"
	        addnewline="Yes"
	        fixnewline="No"> 		
		
	</cfif>
	
</cfif>	

<cfform action="FileEditContent.cfm?openas=#url.openas#&mode=#url.mode#&id=#url.id#" method="post">
   
<table height="100%" width="100%" cellspacing="0" cellpadding="0" class="formpadding">

<tr><td align="center" height="25">

	<input type="button" name="Cancel" id="Cancel" style="width:100" value="Cancel" class="button10g" onclick="parent.window.close()">
		
	<cfif url.openas eq "Edit" or url.mode eq "report"> 
		<input type="submit" name="Save" id="Save" style="width:100" value="Save" class="button10g">
	</cfif>
	
	<cfif find(".cfm",  att.filename)>
	<cfif ParameterExists(Form.Format)>
	<input type="submit" name="Edit" id="Edit" style="width:100" value="Edit" class="button10s">	
	<cfelse>
	<input type="submit" name="Format" id="Format" style="width:100" value="Formatted" class="button10s">	
	</cfif>
	</cfif> 

	</td>
</tr>

<tr><td height="1" class="linedotted"></td></tr>

<tr><td height="100%" valign="top">

<cfif ParameterExists(Form.Edit) or ParameterExists(Form.Format)>

    <!--- take content from form --->
	<cfset content = form.SQL>
	
	<cfif ParameterExists(Form.Edit)>
	
		<table width="100%" height="100%" cellspacing="0" cellpadding="0" class="formpadding">
		<tr><td style="padding:10px">
		
		<cfoutput>
		<textarea name="SQL"
	          class="regular0"
	          style="font-size:13px;width: 100%; height: 100%; word-break: break-all;">#content#</textarea>
		</cfoutput>
		
		</td></tr>
		</table>	
		
	<cfelse>
		
		<div class="relative">
	
		<table width="100%" height="100%" cellspacing="0" cellpadding="0">
		<tr>
		<td class="hide" style="padding:10px">
		
		<cfoutput>
		<textarea name="SQL"	         
	          style="font-size:13px; width: 100%; height: 100%; word-break: break-all;">#content#</textarea>
		</cfoutput>
		
		</td>
		</tr>
		
		<tr>
		<td valign="top">		
			
		<cfinvoke component="Service.Presentation.ColorCode"  
			      method="colorstring" 
			      datastring="#content#" 
			      returnvariable="result">			
	              <cfset result = replace(result, "�", "", "all") />
				  <cfoutput>#result#</cfoutput>			  
		  
				  
		</td>		  
				  
		</tr></table>	
		
		</div>	  
	
	</cfif>	

<cfelse> 

	<cfif att.filename eq "">
			
		    <cffile action="READ" 
			   file="#docpath#" 
			   variable="content">
			
	<cfelse>
	
		<cfif url.mode eq "Report">
				
			<cffile action="READ" 
			   file="#docpath#\#att.filename#" 
			   variable="content">
				   
		<cfelse>
		
				<cfif att.server eq "Document">
		
			    <cffile action="READ" 
				   file="#SESSION.rootDocumentPath#\#docpath#\#att.filename#" 
				   variable="content">
				   
				<cfelse>
				
				 <cffile action="READ" 
				   file="#att.server#\#docpath#\#att.filename#" 
				   variable="content">
				
				</cfif>   
				   
		</cfif>
	
	</cfif>
	
	<table width="100%" height="100%" cellspacing="0" cellpadding="0" class="formpadding">
		<tr><td style="padding:10px">
		
		<cfoutput>
		
			<textarea name="SQL" class="regular0" style="font-size:13px;width: 100%; height: 100%; word-break: break-all;">#content#</textarea>
			
		</cfoutput>
		
		</td></tr>
	</table>
	
</cfif>	

</td></tr>

</table>

</cfform>
