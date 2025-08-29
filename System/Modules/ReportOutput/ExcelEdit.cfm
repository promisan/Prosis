<!--
    Copyright © 2025 Promisan B.V.

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

        http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
-->
<cf_textareascript>	

<cf_screentop height="100%" close="parent.ColdFusion.Window.destroy('myexcel',true)" jQuery="yes" html="no" bannerheight="4" title="Data set declaration form" layout="webapp" banner="gray">

<cfoutput>

<script>
function goto() {
          ptoken.open("RecordListing.cfm?ID=#URL.ID#", "_top");
}
</script>
</cfoutput>

<cfparam name="URL.ID1" default="00000000-0000-0000-0000-000000000000">
<cfif URL.ID1 eq "">
	<cfset URL.ID1 = "00000000-0000-0000-0000-000000000000">
</cfif>

<cfquery name="Get" 
datasource="AppsSystem" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
SELECT *
FROM Ref_ReportControlOutput
WHERE OutputId = '#URL.ID1#' 
</cfquery>
 
<cfset Header = "Register data set">
	
<cfoutput>

<CFFORM action="ExcelSubmit.cfm?ID=#URL.ID#&Mode=#URL.Mode#" method="post" target="result">
	
<table width="100%" align="center">

<tr class="hide"><td><iframe name="result"></iframe></td></tr>
<input type="hidden" name="OutputId" id="OutputId" value="#URL.ID1#">

  <tr><td colspan="2" height="5" style="padding-top:10px">

<!--- Entry form --->

<table width="95%"  align="center" class="formpadding formspacing">

   <!--- Field: Id --->
   		
	   <!--- Field: Description --->
    <TR class="labelmedium2">
    <TD><cf_tl id="Name">:</TD>
    <TD>
		<cfinput type="Text"
       name="OutputName"
       required="No"
	   value="#Get.OutputName#"
       visible="Yes"
       enabled="Yes"
       size="50"
       maxlength="50"
       class="regularxxl">
	</TD>
	</TR>
	
	<tr class="labelmedium2">
	 <TD><cf_tl id="Class">:</TD>
	 <td>
	 	<input type="radio" onclick="ptoken.navigate('ExcelName.cfm?id=Variable','name')" name="outputclass" id="outputclass" value="Variable" <cfif Get.OutputClass eq "" or #Get.OutputClass# eq "Variable">checked</cfif>>Variable (SQL.cfm)
		<input type="radio" onclick="ptoken.navigate('ExcelName.cfm?id=Table','name')" name="outputclass" id="outputclass" value="Table" <cfif Get.OutputClass eq "Table">checked</cfif>>Existing table/view
		
	</td>
	</tr>
	
    <TR class="labelmedium2">
    <TD><cf_tl id="Dataset Datasource">:</TD>
    <TD>
	
		<cfset ds = "#Get.DataSource#">
		<cfif ds eq "">
		 <cfset ds = "AppsQuery">
		</cfif>
			<!--- Get "factory" --->
		<CFOBJECT ACTION="CREATE"
		TYPE="JAVA"
		CLASS="coldfusion.server.ServiceFactory"
		NAME="factory">
		<!--- Get datasource service --->
		<CFSET dsService=factory.getDataSourceService()>

		<!--- Extract names into an array --->
		<CFSET dsNames=dsService.getNames()>
		<cfset ArraySort(dsnames, "textnocase")> 
		
	    <select name="DataSource" id="DataSource" class="regularxxl">
			<CFLOOP INDEX="i"
			FROM="1"
			TO="#ArrayLen(dsNames)#">
			<CFOUTPUT>
			<option value="#dsNames[i]#" <cfif #ds# eq "#dsNames[i]#">selected</cfif>>#dsNames[i]#</option>
			</cfoutput>
			</cfloop>
		</select>
		
		</TD>
	</TR>
				
	<TR class="labelmedium">
    <TD>
	<cfdiv id="name" bind="url:ExcelName.cfm?id=#Get.OutputClass#">
	</TD>
    <TD>
			<input type="Text" class="regularxl" name="VariableName"  id="VariableName"
			value="<cfif #Get.VariableName# neq "">#Get.VariableName#</cfif>"
			size="30" maxlength="30">
			<img src="#SESSION.root#/Images/help2.gif" align="absmiddle" onclick="helpme()" alt="" border="0">
			
			<script>
			function helpme() {
			se = document.getElementsByName("outputclass")
			
			if (se[0].checked) {
				alert(se[0].value+": Enter table1, table2, table3 etc. as generated through SQL.cfm")
			} else {
			 	alert(se[1].value+": Enter the name of a table or view on the server : dbo.NNNNNN")
			}
			}	
				
			</script>
			
		</td>
		<!---
		   <!--- Field: Description --->
	    <TD class="regular">&nbsp;Class:</TD>
	    <TD><input type="radio" name="OutputClass" value="Table" checked>Table
		    <input type="radio" name="OutputClass" value="Format">Format
		</TD>
		--->
	</tr>
	
		
    <TR class="labelmedium2">
    <TD><cf_tl id="Listing order">:</TD>
    <TD>
		<input type="text" name="ListingOrder" style="text-align:center" id="ListingOrder" 
		value="<cfif #Get.ListingOrder# neq "">#Get.ListingOrder#<cfelse>1</cfif>"
		 size="2" maxlength="2" class="regularxxl">
	</TD>
	</TR>
	
	<tr class="labelmedium2"><td height="40" style="font-weight:200;font-size:19px" colspan="2">Optional user selection settings</td></tr>
				
    <TR class="labelmedium2">
    <TD align="right" style="padding-right:5px">Excel : Grouping 1 Fieldname:</TD>
    <TD>
		<input type="Text" name="FieldGrouping1" id="FieldGrouping1"
		value="<cfif #Get.FieldGrouping1# neq "">#Get.FieldGrouping1#</cfif>" class="regularxxl" size="30" maxlength="50">
	</TD>
	</TR>
			
    <TR class="labelmedium2">
    <td align="right" style="padding-right:5px">Excel : Grouping 2 Fieldname:</td>
    <TD>
		<input type="Text" name="FieldGrouping2" id="FieldGrouping2"
		value="<cfif #Get.FieldGrouping2# neq "">#Get.FieldGrouping2#</cfif>" class="regularxxl" size="30" maxlength="50">
	</TD>
	</TR>
	
	 <TR class="labelmedium2">
    <TD  align="right" style="padding-right:5px">Detail fields(s):</TD>
    <TD><textarea style="font-size:14px;padding:3px" class="regular" name="FieldDetail" cols="50" rows="2">#Get.FieldDetail#</textarea>
		</TD>
	</TR>
	
	<TR class="labelmedium2">
    <TD  align="right" style="padding-right:5px">Summary Fieldname(s):</TD>
    <TD>
		<input type="Text" name="FieldSummary" id="FieldSummary"
		value="<cfif #Get.FieldSummary# neq "">#Get.FieldSummary#</cfif>" class="regularxxl" size="40" maxlength="50">
	</TD>
	</TR>
			
	<TR class="labelmedium2">
    <TD  align="right" style="padding-right:5px">ROLAP Detail template:</TD>
    <TD>
		<input type="Text" name="DetailTemplate" id="DetailTemplate"
		value="<cfif #Get.DetailTemplate# neq "">#Get.DetailTemplate#</cfif>" class="regularxxl" size="80" maxlength="80">
	</TD>
	</TR>
	
	<TR class="labelmedium2">
    <TD  align="right" style="padding-right:5px">ROLAP ID= passthru:</TD>
    <TD>
		<input type="Text" name="DetailKey" id="DetailKey"
		value="<cfif #Get.DetailKey# neq "">#Get.DetailKey#</cfif>" class="regularxxl" size="30" maxlength="30">
	</TD>
	</TR>
		
	<tr><td height="2"></td></tr>
			
	<tr class="line">
        <td colspan="2" align="center">			
		<cf_textarea name="OutputMemo" init="Yes" color="ffffff" toolbar="Mini" height="120">#Get.OutputMemo#</cf_textarea>		
		</td>
		
	</TR>		
	
	<tr><td colspan="2" align="center" height="35">
	
	    <table class="forspacing"><tr>
		<td>
		<input class="button10g" type="button" name="Cancel" id="Cancel" value="Cancel" onClick="parent.parent.ProsisUI.closeWindow('myexcel',true)">
		</td>
		<cfif URL.Mode eq "New">
			<td>
			<input type="submit" name="Insert" id="Insert" class="button10g" value="Save">
			</td>
		<cfelse>
		   <td><input type="submit" name="Delete" id="Delete" class="button10g" value="Delete"></td>
		   <td><input type="submit" name="Update" id="Update" class="button10g" value="Save"></td>		   
		</cfif>	
		</tr></table>
	
	</td></tr>
	

</TABLE>

</td>
</tr>

</TABLE>

</cfform>

</cfoutput> 

<cf_screenbottom layout="InnerBox">
