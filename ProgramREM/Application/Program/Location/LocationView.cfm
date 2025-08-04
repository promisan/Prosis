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

<cf_dialogREMProgram>
<cfajaxImport>

<cfparam name="URL.Layout" default="Program">

<cf_screenTop height="100%" html="No" scroll="yes" jquery="Yes">

<script>

ie = document.all?1:0
ns4 = document.layers?1:0

function hl(itm,fld){

     if (ie){
          while (itm.tagName!="TR")
          {itm=itm.parentElement;}
     }else{
          while (itm.tagName!="TR")
          {itm=itm.parentNode;}
     }
	 
	 	 		 	
	 if (fld != false){
		
	 	 itm.className = "highLight2";
		 ColdFusion.Ajax.submitForm('groupentry','LocationEntrySubmit.cfm')
	 
	 }else{
		
    	 itm.className = "regular";		
		 ColdFusion.Ajax.submitForm('groupentry','LocationEntrySubmit.cfm')
	
	 }
  }
  
</script>

<table width="100%" border="0">

<tr><td style="padding:10px">

<cfinclude template="../Header/ViewHeader.cfm">

</td></tr>

<tr><td style="padding:10px">

<cfform method="POST" name="groupentry">

<table width="97%" align="center" border="0" cellspacing="0" cellpadding="0" class="navigation_table">
  <tr>
  	<td height="23" valign="middle" class="labellarge" style="font-size:26px;height:50px">
		<cfoutput>#Program.ProgramClass#</cfoutput> Associated Locations</b>
	</td>		
	<td align="right"></td>	
       
	<cfquery name="GroupAll" 
		datasource="AppsProgram" 
		username="#SESSION.login#" 
	    password="#SESSION.dbpw#">
			SELECT 	F.*, S.ProgramCode as Selected
			FROM    ProgramLocation S RIGHT OUTER JOIN
                    Employee.dbo.Location F ON S.LocationCode = F.LocationCode
			AND 	S.ProgramCode = '#URL.ProgramCode#'
			WHERE   F.Mission     = '#Program.Mission#'
			ORDER BY ListingOrder
    </cfquery>
		
	<tr><td>
					
       <table width="99%" border="0" cellspacing="0" cellpadding="0" align="center" style="border:0px dotted silver">
		
		<cfoutput query="GroupAll">
										
		<cfif CurrentRow MOD 2><TR></cfif>
				<td width="50%">
				<table width="100%" cellspacing="0" cellpadding="0">
				<cfif selected eq "">
					          <TR class="regular navigation_row">
				<cfelse>  <TR class="highlight2">
				</cfif>
			   	<TD width="15%" style="padding-left:16px" class="labelmedium">#LocationCode#</font></TD>
			    <TD width="60%" style="padding-left:6px" class="labelmedium">#LocationName#</font></TD>
				<TD width="10%" align="right" style="padding-right:4px">
				<cfif selected eq "">
					<input type="checkbox" class="radiol" name="Location" value="#LocationCode#" onClick="hl(this,this.checked)"></TD>
				<cfelse>
					<input type="checkbox" class="radiol" name="Location" value="#LocationCode#" checked onClick="hl(this,this.checked)"></td>
			    </cfif>
				</table>
				</td>
				<cfif GroupAll.recordCount eq "1">
  						<td width="50%" class="regular"></td>
				</cfif>
    			<cfif CurrentRow MOD 2><cfelse></TR></cfif> 	
					
		</CFOUTPUT>
												
	   </table>
		   
	<cfoutput>
		<input type="hidden" name="ProgramCode" id="ProgramCode" value="#URL.ProgramCode#">
		<input type="hidden" name="Period" id="Period" value="#URL.Period#">
		<input type="hidden" name="Layout" id="Layout" value="#URL.Layout#">	
	</cfoutput>	

	</cfform>
				
	</td></tr>
	
	 <tr><td class="linedotted"></td></tr>
				
</table>

</td>
</tr>

</table>

