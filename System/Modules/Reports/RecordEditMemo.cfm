
<cfquery name="Line" 
datasource="AppsSystem" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT L.*
    FROM Ref_ReportControl L
	WHERE ControlId = '#URL.ID#'
</cfquery>

<cf_textareascript>

<cf_screentop height="100%" jQuery="yes" scroll="no" 
    label="About this report" html="yes" line="no" layout="webapp" banner="blue">

<cfform action="RecordSubmit.cfm?ID=#URL.ID#" method="POST" name="entry" target="result">

<table width="100%" height="100%" align="center">
			
		<tr>
	        <td colspan="2" height="100%">
													
				<cf_textarea
				 	name = "FunctionAbout"                 
					 height="680"
					 color="ffffff"
					 resize="false"
					 init="Yes">
				 <cfoutput>#Line.FunctionAbout#</cfoutput></cf_textarea>
				
			</td>					
		</TR>
		
		<tr class="hide"><td><iframe name="result" id="result"></iframe></td></tr>
		
		<tr>
		<td height="35" 
		    colspan="2" 
			align="center"><input type="submit" class="button10g" style="width:160px;height:24px" name="About" id="About" value="Save">
		</td>
		</tr>

</table>	

</cfform>

<cfset ajaxonload("initTextarea")>
	
<cf_screenbottom layout="webapp">	