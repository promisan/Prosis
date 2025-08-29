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

<cfajaxImport>
<cf_dialogREMProgram>

<cf_screenTop height="100%" html="No" scroll="yes" flush="Yes">

<table width="100%" border="0" cellspacing="0" cellpadding="0">

<tr><td style="padding:10px">
    <cfset url.attach = "0">
	<cfinclude template="../Header/ViewHeader.cfm">
</td></tr>

<tr>

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
	 ColdFusion.Ajax.submitForm('entry','GroupEntrySubmit.cfm')
	 
	 }else{
		
     itm.className = "regular";		
	 ColdFusion.Ajax.submitForm('entry','GroupEntrySubmit.cfm')
	 }
  }
  
</script>

 	<td style="height:40px;padding-left:24px;font-size:25px;font-weight:200" class="labelmedium"><cf_tl id="Program grouping"></td>				

</tr>

<tr><td>

<cfform action="GroupEntrySubmit.cfm"  method="POST" name="entry">
    
	<table width="100%" align="center" cellspacing="0" cellpadding="0">
	
	<tr><td height="2"></td></tr>
	
	<cfquery name="get" 
		datasource="AppsProgram" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT  *
			FROM    Program	
			WHERE   ProgramCode = '#url.ProgramCode#'				
	</cfquery>
	
	<cfquery name="GroupAll" 
		datasource="AppsProgram" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT  F.*, 
			        S.ProgramCode as Selected
			FROM    ProgramGroup S RIGHT OUTER JOIN
	                Ref_ProgramGroup F ON S.ProgramGroup = F.Code AND S.ProgramCode = '#URL.ProgramCode#'		
			WHERE  (F.Mission = '#get.Mission#' OR F.Mission is NULL)
			AND    (F.Period  = '#URL.Period#'  OR F.Period  is NULL)
			
	</cfquery>
			
	<tr><td>
						
	       <table width="95%" cellspacing="0" cellpadding="0" align="center">
			
			<cfoutput query="GroupAll">
											
			<cfif CurrentRow MOD 2><TR></cfif>
					<td width="50%">
					<table width="100%" cellspacing="0" cellpadding="0">
					<cfif Selected eq "">
						          <TR class="regular">
					<cfelse>  <TR class="highlight2">
					</cfif>
				   	<TD width="10%" style="padding:3px" class="labelmedium line">#Code#</TD>
				    <TD width="80%" style="padding:3px" class="labelmedium line">#Description#</TD>
					<TD width="10%" class="line">
					<cfif Selected eq "">
						<input type="checkbox" class="radiol" name="programgroup" value="#Code#" onClick="hl(this,this.checked)"></TD>
					<cfelse>
						<input type="checkbox" class="radiol" name="programgroup" value="#Code#" checked onClick="hl(this,this.checked)"></td>
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

</td></tr>
 
</table>

<cf_screenbottom html="No">
