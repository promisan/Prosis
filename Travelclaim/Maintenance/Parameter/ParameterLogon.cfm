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


<table width="97%" cellspacing="2" cellpadding="2" align="center" height="100%">
	
	<tr><td height="7"></td></tr>

	<cftry>	
	<cfquery name="Check" 
	datasource="#get.LogonDataSource#"
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT TOP 1 #get.Identification1#, #get.Identification2#, #get.Identification3#
	FROM #get.LogonTableName#
	</cfquery>	
	
	<cfcatch>
	
	<cfoutput>
	SELECT TOP 1 #get.Identification1#, #get.Identification2#, #get.Identification3#
	FROM #get.LogonTableName#
	</cfoutput>
	<tr><td colspan="2"><font color="FF0000"><b>&nbsp;&nbsp;&nbsp;Logon Validation is not correct</font></td>
	</cfcatch>
	
	</cftry>
	
	<tr><td class="labelit">&nbsp;&nbsp;&nbsp;Validation datasource</td>
	<td>
	
	<cfset ds = "#Get.LogonDataSource#">
		<cfif ds eq "">
		 <cfset ds = "AppsEmployee">
		</cfif>
		<!--- Get "factory" --->
		<CFOBJECT ACTION="CREATE"
		TYPE="JAVA"
		CLASS="coldfusion.server.ServiceFactory"
		NAME="factory">
		<!--- Get datasource service --->
		<CFSET dsService=factory.getDataSourceService()>
		<!--- Get datasources --->
		
		
		<!--- Extract names into an array 
		<CFSET dsNames=StructKeyArray(dsFull)>
		--->
		<cfset dsNames = dsService.getNames()>
		<cfset ArraySort(dsnames, "textnocase")> 
		
	    <select name="logondatasource">
			<CFLOOP INDEX="i"
			FROM="1"
			TO="#ArrayLen(dsNames)#">
			<CFOUTPUT>
			<option value="#dsNames[i]#" <cfif #ds# eq "#dsNames[i]#">selected</cfif>>#dsNames[i]#</option>
			</cfoutput>
			</cfloop>
		</select>
	</td>
		
	</tr>
	
	<tr>
	<td class="labelit">&nbsp;&nbsp;&nbsp;Validation Table</td>
	<td>
	<cfinput type="Text"
       name="LogonTableName"
       value="#get.LogonTableName#"
       message="Please submit a table name"
       required="Yes"
       visible="Yes"
       enabled="Yes">	
	   
	</td>
	
	</tr>
			
	<tr><td></td><td class="labelit">Performs account creation against this database table</td></tr>
	
	<TR>
    <td class="labelit">&nbsp;&nbsp;&nbsp;Identification 1:</td>
    <TD>
  	    <cfoutput query="get">
		
			<cf_Portal_Identification
			name="Identification1"
			value="#Get.Identification1#">
		
		</cfoutput>
    </TD>
	</TR>
	
	<TR>
    <td class="labelit">&nbsp;&nbsp;&nbsp;Identification 2:</td>
    <TD>
  	    <cfoutput query="get">
		
			<cf_Portal_Identification
			name="Identification2"
			value="#Get.Identification2#">
		
		</cfoutput>
    </TD>
	</TR>
	
	<TR>
    <td class="labelit">&nbsp;&nbsp;&nbsp;Identification 3:</td>
    <TD>
  	    <cfoutput query="get">
		
			<cf_Portal_Identification
			name="Identification3"
			value="#Get.Identification3#">
		
		</cfoutput>
    </TD>
	</TR>
	
	<TR>
    <td width="160" class="labelit">&nbsp;&nbsp;&nbsp;<a href="##" title="Define how authentication will be enforced after Account has been created">Logon</a>:</td>
    <TD>
	  <input type="radio" name="LogonEnforce" value="1" <cfif Get.LogonEnforce eq "1">checked</cfif>>Enforce Account Logon
	  <input type="radio" name="LogonEnforce" value="0" <cfif Get.LogonEnforce eq "0">checked</cfif>>Allow Identification Logon</TD>
	</TR>
	
	<TR>
    <td width="160" class="labelit">&nbsp;&nbsp;&nbsp;<a href="##" title="Allows tester to access Claimant information through URL change">Mode</a>:</td>
    <TD>
	  <input type="radio" name="ModeDebug" value="1" <cfif #Get.ModeDebug# eq "1">checked</cfif>>Testing
	  <input type="radio" name="ModeDebug" value="0" <cfif #Get.ModeDebug# eq "0">checked</cfif>>Operational
    </TD>
	</TR>
		
	<TR>
    <td width="160" class="labelit">&nbsp;&nbsp;&nbsp;<a href="##" title="Allows administrator to limit unsuccessfull logons from a certain IP">Logon mode</a>:</td>
    <TD>
	  <input type="radio" name="LimitLogon" value="1" <cfif #Get.LimitLogon# eq "1">checked</cfif>>Limit to 3 logons
	  <input type="radio" name="LimitLogon" value="0" <cfif #Get.LimitLogon# eq "0">checked</cfif>>Unlimited
    </TD>
	</TR>
	
	
	</table>
	
