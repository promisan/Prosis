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
<cfparam name="url.idmenu" default="">

<cf_screentop 
           height="100%" 
		   layout="webapp" 
		   label="Reference Edit Form"
		   menuAccess="Yes" 
		   systemfunctionid="#url.idmenu#">	
		
<cfquery name="Mission" 
datasource="AppsOrganization" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT *
	FROM Ref_Mission
	WHERE Mission IN (SELECT Mission FROM Ref_MissionModule WHERE SystemModule = 'Program')
</cfquery>

<cfquery name="Period" 
datasource="AppsProgram" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT *
	FROM Ref_Period
</cfquery>

<cfquery name="Source" 
datasource="AppsProgram" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT *
	FROM Ref_MeasureSource
	WHERE Code != 'Manual'
</cfquery>
  
<cfquery name="Get" 
datasource="AppsProgram" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT *
	FROM stProgramMeasure
	WHERE fileName = '#URL.ID1#' 
</cfquery>

<script language="JavaScript">

function ask() {
	if (confirm("Do you want to remove this source?")) {
		return true 
	}
	return false	
}	

</script>

<cfform action="RecordSubmit.cfm?fileNo=#get.fileNo#" method="POST" enablecab="Yes" name="dialog">

<!--- Entry form --->

<table width="97%" cellspacing="0" cellpadding="0" align="center" class="formpadding">

    <TR>
    <td width="150">Table name:</td>
    <TD>
  	   <cfinput type="text" name="FileName" value="#get.FileName#" message="Please enter a filename" required="Yes" size="50" maxlength="50" class="regular">
	  
    </TD>
	</TR>
		
    <TR>
    <TD>Datasource:</TD>
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
				
		<cfset dsnames = dsService.getNames()>
		<cfset ArraySort(dsnames, "textnocase")> 
				
	    <select name="DataSource">
			<CFLOOP INDEX="i"
			FROM="1"
			TO="#ArrayLen(dsnames)#">
			<CFOUTPUT>
			<option value="#dsnames[i]#" <cfif #ds# eq "#dsnames[i]#">selected</cfif>>#dsnames[i]#</option>
			</cfoutput>
			</cfloop>
		</select>
		
		</TD>
	</TR>
			
	<TR>
    <TD>Tree:</TD>
    <TD>	
	   <select name="Mission">
	   <cfoutput query="Mission">
	   <option value="#Mission#" <cfif #Mission# eq "#Get.Mission#">selected</cfif>>#Mission#</option>
	   </cfoutput>
	   </select>
    </TD>
	</TR>
		
	<TR>
    <TD>Period:</TD>
    <TD>
	   <select name="Period">
	   <cfoutput query="Period">
	   <option value="#Period#" <cfif #Period# eq "#Get.Period#">selected</cfif>>#Period#</option>
	   </cfoutput>
	   </select>
    </TD>
	</TR>
				
	<TR>
    <TD>Location enabled:</TD>
    <TD>
	    <INPUT type="checkbox" name="LocationEnabled" <cfif #get.LocationEnabled# eq "1">checked</cfif> value="1"> 
	</TD>
	</TR>
			
	<TR>
    <TD>Overwrite prior:</TD>
    <TD>
	    <INPUT type="checkbox" name="Overwrite" value="1" <cfif #get.Overwrite# eq "1">checked</cfif>> 
	</TD>
	</TR>
			
	<TR>
    <TD>Source:</TD>
    <TD>
	    <select name="source" class="#cl#">
	   
		   <cfoutput query="Source">
			   <option value="#Code#" <cfif #get.Source# eq #Code#>selected</cfif>> #Description#</option>
		   </cfoutput>
		   
		 </select>  
	</TD>
	</TR>
		
	<TR>
    <TD>Operational:</TD>
    <TD>
	    <INPUT type="radio" name="Operational" value="1" <cfif #get.Operational# eq "1">checked</cfif>> Yes
		<INPUT type="radio" name="Operational" value="0" <cfif #get.Operational# eq "0">checked</cfif> > No
	</TD>
	</TR>
	
	<tr><td height="1" colspan="2" bgcolor="d0d0d0"></td></tr>
	<tr>	
		<td colspan="2" align="center" height="30">
		<input class="button10g" type="button" name="Cancel" value="Cancel" onClick="window.close()">
	    <input class="button10g" type="submit" name="Delete" value="Delete" onclick="return ask()">
    	<input class="button10g" type="submit" name="Update" value="Update">
		</td>	
	</tr>
	
</TABLE>
	
</CFFORM>

<cf_screenbottom layout="innerbox">
