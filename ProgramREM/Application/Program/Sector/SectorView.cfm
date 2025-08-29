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
<cfsilent>
	<proUsr>dev</proUsr>
	<proOwn>dev dev</proOwn>
	<proDes>Displays the groups allowed for the period</proDes>
	<proCom>SAT CHANGE</proCom>
</cfsilent>

<cfajaximport tags="cfdiv">

<cf_screenTop height="100%" html="No" scroll="yes" flush="Yes">

<cf_dialogREMProgram>

<table width="99%" border="0" align="center" cellspacing="0" cellpadding="0" class="formpadding">
<tr><td style="padding:10px">
	<cfinclude template="../Header/ViewHeader.cfm">
	</td>
</tr>

<tr><td style="padding:10px">

<script language="JavaScript">

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
	  ColdFusion.Ajax.submitForm('entry','SectorEntrySubmit.cfm')
	 }else{
		
     itm.className = "regular";		
	  ColdFusion.Ajax.submitForm('entry','SectorEntrySubmit.cfm')
	 }
  }

</script>

<cfquery name="SectorAll" 
datasource="AppsProgram" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT F.*, 
	       S.ProgramCode as Selected
	FROM   ProgramSector S RIGHT OUTER JOIN
           Ref_ProgramSector F ON S.ProgramSector = F.Code and S.ProgramCode = '#URL.ProgramCode#'	
	WHERE  F.Code IN (SELECT Code FROM Ref_ProgramSectorMission WHERE Mission = '#Program.Mission#')	   
</cfquery>

<cfform action="SectorEntrySubmit.cfm"  method="POST" name="entry">
  
<table width="96%" border="0" cellspacing="0" cellpadding="0" align="center">

<cfoutput query="SectorAll">

	<cfif CurrentRow MOD 2><TR></cfif>
				<td width="50%" class="regular" >
				<table width="100%" border="0" cellspacing="0" cellpadding="0">

		<cfif Selected eq "">
		          <TR class="regular">
		<cfelse>  <TR class="highlight2">
		</cfif>		   
	
			<TD style="padding-left:10px" width="15%" class="labelmedium">#Code#</TD>
		    <TD width="70%" style="padding-left:4px" class="labelmedium">#Description#</TD>
			<TD width="10%" align="right" style="padding-right:6px">
			<cfif Selected eq "">
			<input type="checkbox" class="radiol" name="programsector" value="#Code#" onClick="hl(this,this.checked)">
			<cfelse>
			<input type="checkbox" class="radiol" name="programsector" value="#Code#" checked onClick="hl(this,this.checked)">
		    </cfif>
			</td>
			</table>
			</TD>
			<cfif SectorAll.recordCount eq "1">
  				<td width="50%" class="regular"></td>
			</cfif>
	
		<cfif CurrentRow MOD 2><cfelse></TR></cfif> 

</cfoutput>

<tr><td height="4" colspan="5"></td></tr>
<tr><td height="1" colspan="5" class="labelit"></td></tr>

</table>
  
<cfoutput>
	<input type="hidden" name="ProgramCode" value="#URL.ProgramCode#">
	<input type="hidden" name="Period" value="#URL.Period#">	
</cfoutput>	

</td>
</tr>

</TABLE>

</cfform>

<cf_screenbottom html="No">
