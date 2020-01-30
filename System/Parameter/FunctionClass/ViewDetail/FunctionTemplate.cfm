
<cfparam name="URL.ID" default="">
<cfparam name="URL.TemplateFunctionId" default="">
<cfparam name="Form.Update" default="No">

<cfparam name="Form.ClassID" default="">
<cfparam name="Form.FileName" default="">
<cfparam name="Form.FileNameOld" default="">
<cfparam name="Form.PathNameOld" default="">
<cfparam name="Form.TemplateFunction" default="">

<cfif Form.ClassID eq "">
	<cfset Form.ClassID = '#URL.Id#'>
</cfif>

<cfoutput>

<cfquery name="Master" 
datasource="AppsControl" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
    FROM ParameterSite
	WHERE ServerRole = 'QA'	
</cfquery>

<cfquery name="FileList" 
datasource="AppsControl" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
    FROM ClassFunctionTemplate
	WHERE ClassFunctionId = '#Form.ClassId#'
	order by created
</cfquery>


<table width="99%" cellspacing="0" cellpadding="0" class="formpadding">
<tr><td height="2"></td></tr>
<tr>
<td width="17%"><b>Path Name</td>
<td width="18%"><b>File Name</td>
<td width="50%"><b>Function</td>
<td width="7%"></td>
</tr>

<tr><td colspan="4" height="1" bgcolor="silver"></td></tr>

<cfset lines=0>
<cfloop query="FileList">

<cfset vPathName=replace(PathName,"\","\\","all")>
	<tr>
		<td>#PathName#\#FileName#</td>
		<td>
		<cfquery name="Check" 
		datasource="AppsControl" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		    SELECT TOP 1 *
		    FROM   Ref_TemplateContent
			WHERE  PathName='#PathName#' 
			AND    FileName='#FileName#'	
			AND    ApplicationServer = '#Master.ApplicationServer#'
			ORDER BY Created DESC	
		</cfquery>
		
		<cfif Check.recordcount eq "1">
			<button onClick="javascript:detail('#Check.TemplateId#','')" 
			      class="button10g">#FileName#</button>
		</cfif>
		
		</td>
		
		<td>#TemplateFunction#</td>
		<td align="center" width="40">
		  
		   <A href="javascript:ColdFusion.navigate('FunctionTemplate.cfm?id=#url.id#&TemplateFunctionId=#TemplateFunctionId#','Template')">
		   <img src="#SESSION.root#/Images/edit.gif" alt="" border="0">
		   </a>
		   
		   <A href="javascript:ColdFusion.navigate('FilePurge.cfm?id=#url.id#&TemplateFunctionId=#TemplateFunctionId#','Template')">
		   <img src="#SESSION.root#/Images/delete4.gif" alt="" border="0">
		   </a>
	   
		   <cfset lines=#len(TemplateFunction)#+#lines#>
		</td>
	
	</tr>
	
	<tr><td colspan="5" bgcolor="silver"></td></tr>
	
</cfloop>

<cfform action="FileSubmit.cfm?id=#url.id#" name="AddFile" method="post">

<cfif URL.templateFunctionId neq "">

	<cfquery name="FileSelect" 
	datasource="AppsControl" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT *
	    FROM ClassFunctionTemplate
		WHERE TemplateFunctionId = '#URL.TemplateFunctionId#'				
	</cfquery>

	<cfset lines=#len(FileSelect.TemplateFunction)#+#lines#>
	<input type="hidden" id="update" name="update" value="Yes">
	<input type="hidden" id="PathNameOld" name="PathNameOld" value="#FileSelect.PathName#">
	<input type="hidden" id="FileNameOld" name="FileNameOld" value="#FileSelect.FileName#">

</cfif>

	<tr><td height="3"></td></tr>
	<tr><td colspan="4"><font size="2" color="808080"><b>Add a Template Association</td></tr>	
	<tr><td colspan="4" bgcolor="silver"></td></tr>	

	<tr>
	<td colspan="4"> Select File:
	
	 <cfif URL.TemplateFunctionId neq "">
	
		<input type="text" name="File" id="File" value="#FileSelect.PathName#/#FileSelect.FileName#" size="80">
		
		<button name="btnFunction" id="btnFunction" class="button1" style="height:20" onClick="javascript:Browse()"> 
				  <img src="<cfoutput>#SESSION.root#/Images/locate.gif</cfoutput>" alt="" name="img1" 
					  style="cursor: pointer;" alt="" border="0" align="top">
		</button>
		
		<input type="hidden" id="ClassId" name="ClassId"  value="#URL.ID#" >
		<input type="hidden" name="TemplateFunctionId" id="TemplateFunctionId" value="#FileSelect.TemplateFunctionId#" readonly="yes">
		<input type="hidden" name="PathName" id="PathName" value="#FileSelect.PathName#" readonly="yes">
		<input type="hidden" name="FileName" id="PathName" value="#FileSelect.FileName#" readonly="yes" >
		
	<cfelse>
	
		<input type="text" name="File" id="File" value="" size="80">
		
		<button name="btnFunction" id="btnFunction" class="button1" style="height:20" onClick="javascript:Browse()"> 
				  <img src="<cfoutput>#SESSION.root#/Images/locate.gif</cfoutput>" alt="" name="img1" 
					  style="cursor: pointer;" alt="" border="0" align="top">
		</button>
		
		<input type="hidden" id="ClassId" name="ClassId"  value="#URL.ID#" >
		<input type="hidden" name="PathName" id="PathName" value="" readonly="yes">
		<input type="hidden" name="FileName" id="FileName" value="" readonly="yes" >
	
	</cfif>
		
	</td>
	
	</tr>
	
	<tr><td colspan="4" style="border: 1px solid Gray;">
	
	 <cf_Textarea 
  		 name="TemplateFunction" 
		 height="200" 				 
		 toolBar="Basic" 	
		 tooltip="Function of the template"			 
		 richtext="true" 
		 skin="silver">
		 
		 <cfif URL.TemplateFunctionId neq "">				 
		 #trim(FileSelect.TemplateFunction)#
		 </cfif>
				 						
		  </cf_textarea>		
	
	</td></tr>
		
	<tr><td colspan="4" bgcolor="silver"></td></tr>	
	<tr>
	<td colspan="4" align="center">
	<input type="submit" value="Save" class="button10g">
	</td>
	</tr>
	</table>

	
</cfform>



</cfoutput>
