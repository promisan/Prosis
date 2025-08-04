<!--
    Copyright © 2025 Promisan

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

<cf_screentop bannerheight="50" height="100%" html="Yes" layout="webapp"
  label="Compare Workflow Settings" scroll="yes">

<cfoutput>
<script language="JavaScript">

function setReturn() {

var collection;
var x;
collection = document.getElementById("EClass");

for (i=0;i<collection.length;i++) {
   if (collection[i].selected)
   		x = collection[i].value;
	}	

	window.returnValue = x
	window.close()

}


function expand(table)
{
    se   = document.getElementById(table)

	if (se.className == "regular") {
	 se.className = "hide";
	} else {
	 se.className = "regular";
	}
	
}

</script>


<cfquery name="Origin" datasource="AppsControl">
	SELECT DatabaseServer
	FROM ParameterSite
	WHERE ApplicationServer='#CGI.HTTP_HOST#'
</cfquery>

<cfquery name="ListOfServer" datasource="AppsControl">
	SELECT Distinct DatabaseServer
	FROM ParameterSite
	WHERE DatabaseServer!='#Origin.DatabaseServer#'
</cfquery>


<cfset link = "">


<!--- edit form --->
<cfform>
<table width="98%" cellspacing="0" cellpadding="0" align="center" class="formpadding">

	<tr><td height="10"></td></tr>
	
	<TR class="labelmedium linedotted">
    <TD></TD>	
    <TD class="labellarge">Origin Server</b></TD>
	<TD>&nbsp;&nbsp;</TD>
	<TD class="labellarge">Destination Server</b></TD>
	</TR>


	<TR>
    <TD class="labelmedium">&nbsp;&nbsp;-&nbsp;&nbsp;Server:</TD>
    <TD class="labelmedium">
		#Origin.DatabaseServer#
	</TD>
	<TD>&nbsp;&nbsp;</TD>
	<TD class="labelmedium">
            <cfselect name="sServer" id="sServer" onChange="ColdFusion.navigate('#SESSION.root#/System/EntityAction/EntityFlow/ClassAction/WorkflowPublishListing.cfm?DataSource='+this.value+'&EntityCode=#URL.EntityCode#&EntityClass=#URL.EntityClass#','divPublish');" class="regularxl">
           	<option value=""></option>			
            <cfloop query="ListOfServer">
			

					<cfif FindNoCase(";",DatabaseServer) neq 0>
						<!--- Multiple instances --->
						<cfloop Index= "ele" List="#DatabaseServer#" delimiters=";">
				            	<option value="#Replace(ele,"\","|")#">#ele#</option>				
						</cfloop>
						
					<cfelse>
		            	<option value="#DatabaseServer#">#DatabaseServer#</option>				
					</cfif>
            </cfloop>
			</cfselect>	
	</TD>
	
	</TR>
	
	<TR>
    <TD class="labelmedium">&nbsp;&nbsp;-&nbsp;&nbsp;Entity:</TD>
    <TD class="labelmedium">
		#URL.EntityCode#
	</TD>
	<TD>&nbsp;&nbsp;</TD>
	<TD class="labelmedium">#URL.EntityCode#</TD>
	
	</TR>	
	
	<TR>
    <TD class="labelmedium">&nbsp;&nbsp;-&nbsp;&nbsp;Class:</TD>
    <TD class="labelmedium">
		#URL.EntityClass#
	</TD>
	<TD>&nbsp;&nbsp;</TD>
	<TD class="labelmedium">#URL.EntityClass#</TD>
	
	</TR>		
	
	<TR>
    <TD class="labelmedium">&nbsp;&nbsp;-&nbsp;&nbsp;No:</TD>
    <TD class="labelmedium">
		#URL.PublishNo#
	</TD>
	<TD>&nbsp;&nbsp;</TD>
	<TD>
		 <cfdiv id="divPublish"/>
	</TD>
	</TR>		

	<TR>
		<td colspan="4">
			 <cfdiv id="divComparison"/>
		</td>
	</TR>	

	

	
	<tr><td height="40"></td></tr>
	
	<tr><td colspan="4" class="linedotted"></td></tr>
	
	<tr>
		
	<tr><td colspan="4" height="5"></td></tr>

	<td colspan="4" align="center" colspan="2">
	<input class="button10g" type="button" name="Cancel" id="Cancel" value=" Cancel " onClick="window.returnValue = '';window.close()">
	</td>	
	
</TABLE>
</cfform>

</cfoutput>

<cf_screenbottom layout="webapp">
