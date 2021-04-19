
<!--- Contents 

1. show contents of current file
2. show contents of master master
3. comparison report used for update

--->

<cfquery name="Master" 
	datasource="appsControl">
	SELECT *
	FROM   ParameterSite
	WHERE  ServerRole = 'QA'
</cfquery>	

<cfoutput>

<cf_screentop jquery="Yes" height="100%" band="false" scroll="Yes" layout="webapp" title="Template Content #url.file#">

<table height="98%" width="99%" align="center" class="formpadding">

<tr><td valign="top" height="95%">	

<cf_TemplateCompare 
		 left   = "#url.path##url.file#"
		 right  = "#Master.sourcePath#\#url.file#"
		 output = "#SESSION.rootPath#\cfrstage\user\#SESSION.acc#\compare.html"
		 delete = "no">

<cflayout type="Tab" align="Center" name="Template" tabheight="750">

          <!---
				 
		 <cflayoutarea  name="icomps" title="Comparison">
		 	 
			 <table width="100%" height="100%" border="0" cellspacing="0" cellpadding="0" bordercolor="D1D1D1" class="formpadding">
			
			 <tr><td height="100%">
						
			 <iframe src="../../Template/TemplateDetailCompare.cfm"
		        width="100%"
	    	    height="100%"
		       	scrolling="yes"
	    	    frameborder="0"></iframe>
									 
			 </td></tr>
			 </table>
		 
		</cflayoutarea>	
		
		--->
				
		
		<cflayoutarea  name="icontent" title="Content">
	
			<cffile action="READ" file="#url.path##url.file#" variable="mycontent">
			
			<!---
			<cfif find("textarea","#mycontent#")>
				  <cfset content = "#replace(mycontent,'textarea','_textarea','ALL')#">
			<cfelse>
			      <cfset content = "#mycontent#">
			</cfif>
			--->
			
			<form name="template" id="template">
			
			<input type="hidden" name="path" value="#url.path##url.file#">
					
			<textarea class="regular" name="content"
				   style="font-family:verdana; font-size: 9pt; width:100%; height:97%; color: blue; background: white;">#mycontent#</textarea>
				   
			</form>	   
			
			<!---
				
			<cfif len(mycontent) gt 100000>
			
				<cfif find("textarea","#mycontent#")>
					   <cfset content = "#replace(mycontent,'textarea','_textarea','ALL')#">
			    <cfelse>
					   <cfset content = "#mycontent#">
				</cfif>
					
				<textarea class="regular" 
				   style="font-family:verdana; font-size: 8pt; width:100%; height:#client.height-290#; color: blue; background: white;">
						#content#
				</textarea>
				
			<cfelse>
			
			      <cfinvoke component="Service.Presentation.ColorCode"  
				   method="colorstring" 
				   datastring="#mycontent#" 
				   returnvariable="result">		
				   	
			       <cfset result = replace(result, "�", "", "all")/>
				  
				   <table width="100%"><tr><td>#result#</td></tr></table>
				  
				
			</cfif>
			
			--->
		
		</cflayoutarea>

</cflayout>

</td>
</tr>

<tr><td>
	<table>
		<tr>
		<td><input type="button" name="Apply" value="Apply" class="button10g" onclick="ptoken.navigate('TemplateSubmit.cfm','process','','','POST','template')"></td>
		<td id="process"></td>
		</tr>
	</table>
</td></tr>

<script>

function compare() {
	 w = #CLIENT.width# - 60;
     h = #CLIENT.height# - 120;
	 ptoken.open("#SESSION.root#/cfrstage/user/#SESSION.acc#/compare.html","_blank","left=20, top=20, width=" + w + ", height= " + h + ", status=yes, toolbar=yes, scrollbars=yes, resizable=yes")
}

</script>

</table>

</cfoutput>

