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

<cf_screentop height="100%" 
			  label="Address Zone" 			 
			  scroll="Yes" 
			  layout="webapp" 
			  banner="blue" 
			  menuAccess="Yes" 
			  systemfunctionid="#url.idmenu#">

<CFFORM action="RecordSubmit.cfm" method="post" name="dialog">

<!--- Entry form --->

<table width="95%" align="center" class="formpadding formpadding">


   <tr><td style="height:15px"></td>
   <!--- Field: Id --->
    <TR>
    <TD class="labelmedium2">Code:</TD>
    <TD>
		<cfinput type="Text" name="Code" value="" message="Please enter a code" required="Yes" size="20" maxlength="20"
		class="regularxxl">
	</TD>
	</TR>
	
	   <!--- Field: Mission --->
    <TR>
    <TD class="labelmedium2">Mission:&nbsp;</TD>
    <TD>
  	  	<cfquery name="getLookup" 
			datasource="AppsEmployee" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			SELECT *
			FROM Ref_ParameterMission
		</cfquery>
		<select name="mission" class="regularxxl">
			<cfoutput query="getLookup">
			  <option value="#getLookup.mission#">#getLookup.mission#</option>
		  	</cfoutput>
		</select>	
    </TD>
	</TR>
	

	 <!--- Field: Description --->
    <TR>
    <TD class="labelmedium2">Description:&nbsp;</TD>
    <TD>
  	  	<cfinput type="Text" name="description" value="" message="Please enter a description" required="Yes" size="30" maxlength="50" class="regularxxl">
				
    </TD>
	</TR>	
		
	<tr><td height="3"></td></tr>
	
	<tr><td colspan="2" class="line"></td></tr>
	<tr>	
		<td align="center" colspan="2" height="30">
		<input class="button10g" type="button" name="Cancel" value=" Cancel " onClick="window.close()">
		<input class="button10g" type="submit" name="Insert" value=" Save ">
		</td>
	</tr>
	    
</TABLE>

</CFFORM>
