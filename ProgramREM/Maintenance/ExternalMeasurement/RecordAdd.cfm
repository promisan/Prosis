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
		   label="Add Source"
		   menuAccess="Yes" 
		   systemfunctionid="#url.idmenu#">	
		   
<cf_droptable dbname="AppsProgram" tblname="tmp#SESSION.acc#Category"> 

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

<cfif #Source.Recordcount# eq "0">

<cfquery name="Source" 
datasource="AppsProgram" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
INSERT INTO Ref_MeasureSource
(Code,Description)
VALUES ('External','External')
</cfquery>

<cfquery name="Source" 
datasource="AppsProgram" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
SELECT *
FROM Ref_MeasureSource
WHERE Code != 'Manual' 
</cfquery>

</cfif>

<cfform action="RecordSubmit.cfm" method="POST" enablecab="Yes" name="dialog">

<!--- Entry form --->

<table width="95%" cellspacing="0" cellpadding="0" align="center" class="formpadding">

    <TR>
    <td width="150">Table name:</td>
    <TD>
  	   <cfinput type="text" name="FileName" value="" message="Please enter a filename" required="Yes" size="44" maxlength="50">
    </TD>
	</TR>
	
		
    <TR>
    <TD>Datasource:</TD>
    <TD>
	
		<cfset ds = "AppsQuery">
		
			<!--- Get "factory" --->
		<CFOBJECT 
			ACTION="CREATE"
			TYPE="JAVA"
			CLASS="coldfusion.server.ServiceFactory"
			NAME="factory">
			<!--- Get datasource service --->
			<CFSET dsService=factory.getDataSourceService()>
		
			<cfset dsNames = dsService.getNames()>
			<cfset ArraySort(dsnames, "textnocase")> 
		
		    <select name="DataSource">
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
		
	<TR>
    <TD>Tree/Mission:</TD>
    <TD>
	   <select name="Mission">
	   <cfoutput query="Mission">
	   <option value="#Mission#">#Mission#</option>
	   </cfoutput>
    </TD>
	</TR>
		
	<TR>
    <TD>Period:</TD>
    <TD>
	   <select name="Period">
	   <cfoutput query="Period">
	   <option value="#Period#">#Period#</option>
	   </cfoutput>
    </TD>
	</TR>
			
	<TR>
    <TD>Location upload:</TD>
    <TD>
	    <INPUT type="checkbox" name="LocationEnabled" value="1"> 
	</TD>
	</TR>
			
	<TR>
    <TD><cf_UIToolTip  tooltip="This option removes previosly uploaded values and also not approved manual entries">Overwrite prior:</cf_UIToolTip></TD>
    <TD>
	    <INPUT type="checkbox" name="Overwrite" value="1" checked> 
	</TD>
	</TR>
			
	<TR>
    <TD>Source:</TD>
    <TD>
	    <select name="source" class="#cl#">
	   
		   <cfoutput query="Source">
			   <option value="#Code#"> #Description#</option>
		   </cfoutput>
		   
		 </select>  
	</TD>
	</TR>
		
	<TR>
    <TD>Operational:</TD>
    <TD>
	    <INPUT type="radio" name="Operational" value="1" checked> Yes
		<INPUT type="radio" name="Operational" value="0" > No
	</TD>
	</TR>
	
	<tr><td class="line" colspan="2"></td></tr>
	
	<tr>	
		
	<td colspan="2" align="center" height="30">	
		
	<input class="button10g" type="button" name="Cancel" value="Cancel" onClick="window.close()">
    <input class="button10g" type="submit" name="Insert" value="Submit">
	
	</td>	
	</tr>
	
</TABLE>

</CFFORM>

<cf_screenbottom layout="innerbox">
