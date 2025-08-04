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

<cfajaximport tags="cfdiv">
<cf_dialogREMProgram>

<cfparam name="URL.Layout" default="Program">

<cf_screenTop height="100%" html="No" scroll="yes" flush="Yes">

<table width="100%" border="0" cellspacing="0" cellpadding="0">

<tr><td style="padding:10px">
	<cfinclude template="../Header/ViewHeader.cfm">
	</td></tr>

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
	 ColdFusion.Ajax.submitForm('groupentry','BeneficiaryEntrySubmit.cfm')
	 
	 }else{
		
     itm.className = "regular";		
	 ColdFusion.Ajax.submitForm('groupentry','BeneficiaryEntrySubmit.cfm')
	 }
  }
  
</script>

<tr>
		
		<td style="padding-left:16px;font-size:25px" height="34" class="labellarge">
		<cfoutput>#Program.ProgramClass#</cfoutput> beneficiaries
		</td>
</tr>

<tr><td style="padding-left:15px">

<cfform action="BeneficiaryEntrySubmit.cfm" method="POST" name="groupentry">
  
<table width="100%" align="center" border="0" cellspacing="0" cellpadding="0">

	<cfquery name="GroupAll" 
	datasource="AppsProgram" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT    F.*, S.ProgramCode as Selected
		FROM      ProgramBeneficiary S RIGHT OUTER JOIN
                  Ref_Beneficiary F ON S.Beneficiary = F.Code AND S.ProgramCode = '#URL.ProgramCode#'		
	</cfquery>	
		
<tr><td style="padding:10px">
					
       <table width="99%" border="0" cellspacing="0" cellpadding="0" align="center">
		
		<cfoutput query="GroupAll">
										
		<cfif CurrentRow MOD 2><TR></cfif>
				<td width="50%">
				<table width="100%" cellspacing="0" cellpadding="0">
				<cfif Selected eq "">
					          <TR>
				<cfelse>  <TR class="highlight2">
				</cfif>
			   	<TD width="20%" style="padding-left:8px" class="linedotted labelmedium">#Code#</font></TD>
			    <TD width="70%" class="linedotted labelmedium">#Description#</font></TD>
				<TD align="right" width="10%" class="linedotted" style="padding-right:5px">
				<cfif Selected eq "">
					<input type="checkbox" name="programgroup" class="radiol" value="#Code#" onClick="hl(this,this.checked)"></TD>
				<cfelse>
					<input type="checkbox" name="programgroup" class="radiol" value="#Code#" checked onClick="hl(this,this.checked)"></td>
			    </cfif>
				</table>
				</td>
				<cfif GroupAll.recordCount eq "1">
  						<td width="50%"></td>
				</cfif>
    			<cfif CurrentRow MOD 2><cfelse></TR></cfif> 	
					
		</CFOUTPUT>
												
	   </table>
				
	</td></tr>
				
</table>

<cfoutput>
   	<input type="hidden" name="ProgramCode" id="ProgramCode" value="#URL.ProgramCode#">
	<input type="hidden" name="Period" id="Period" value="#URL.Period#">
	<input type="hidden" name="Layout" id="Layout" value="#URL.Layout#">	
</cfoutput>	

</cfform>

</td>
</tr>

</table> 

<cf_screenbottom html="No">
