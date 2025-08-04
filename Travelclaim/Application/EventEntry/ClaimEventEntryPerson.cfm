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

<script language="JavaScript">

ie = document.all?1:0
ns4 = document.layers?1:0

function hle(itm,fld){

     if (ie){
          while (itm.tagName!="TR")
          {itm=itm.parentElement;}
     }else{
          while (itm.tagName!="TR")
          {itm=itm.parentNode;}
     }
	 
	 	 		 	
	 if (fld != false){
		
	 itm.className = "highLight2";
	 }else{
		
     itm.className = "regular";		
	 }
  }
  
  
</script>


<table width="100%" border="0" cellspacing="0" cellpadding="1" class="<cfoutput>#cl#</cfoutput>">

    <tr bgcolor="f0f0f0"><td height="19" colspan="7"><b><font face="Verdana">Traveller</b></td></tr>
     <tr><td colspan="7" bgcolor="EAEAEA"></td></tr>
	<tr bgcolor="f4f4f4">
		<td width="20"></td>
		<td>IndexNo</td>
		<td>Name</td>
		<td>Nationality</td>
		<td>Birth date</td>
		<td>Type</td>
		<td></td>
	</tr>
	<tr><td colspan="7" bgcolor="E5E5E5"></td></tr>
	
	<cfoutput query="EventPerson">
	
	<cfquery name="Check" 
		 datasource="appsTravelClaim" 
		 username="#SESSION.login#" 
		 password="#SESSION.dbpw#">
		 SELECT *
		 FROM ClaimEventPerson 
		  WHERE ClaimEventId = '#URL.ID1#'
			AND PersonNo     = '#PersonNo#' 
		</cfquery>
		
		 <cfif #Check.recordcount# eq "1">
		   <cfset cl = "highlight2">
		   <cfset hl = "1">
		
		 <cfelse>
		
		   <cfset hl = "0"> 
		   <cfset cl = "regular">
		 </cfif>
		
	<tr id="#IndexNo#" class="#cl#">
	    <td align="center">#currentRow#</td>
		<td>#IndexNo#</td>
		<td><cfif #Gender# eq "M">Mr.<cfelse>Mrs.</cfif> #FirstName# #LastName#</td>
		<td>#Nationality#</td>
		<td>#DateFormat(Birthdate,CLIENT.DateFormatShow)#</td>
		<td>
				
		 <cfif #check.claimantType# neq "">
		  <cfset clm = "#check.claimantType#">
		<cfelse>
		  <cfset clm = "#EventPerson.claimantType#">  
		</cfif>
		
		<cfquery name="Claimant" 
		 datasource="appsTravelClaim" 
		 username="#SESSION.login#" 
		 password="#SESSION.dbpw#">
		 SELECT * 
		 FROM Ref_Claimant 
		 WHERE Code = '#clm#' 
		</cfquery>
		
		<input type="hidden" name="ClaimantType_#CurrentRow#" value="#Claimant.Code#">
		
		#Claimant.Description#						
				
		</td>				
		<td>
		
		<cfif #Check.recordcount# eq "1">
		
			 <input type="hidden" 
		        name="PersonNo_#CurrentRow#" 
				value="#PersonNo#">
		
		<cfelse>
			   	
			<cfif #hl# eq "0">
							
			   <input type="checkbox" 
			   name="PersonNo_#CurrentRow#" 
			   value="#PersonNo#" 
			   onClick="hle(this,this.checked)">
			  		
			<cfelse>
			
			   <input type="checkbox" 
			   name="PersonNo_#CurrentRow#" 
			   value="#PersonNo#" 
			   onClick="hle(this,this.checked)"
			   <cfif #Check.recordcount# eq "1">checked</cfif>
					   
			</cfif>   
		
		</cfif>
		
		</td>
	</tr>
	
	<cfif #currentRow# neq "#EventPerson.recordcount#">
	<tr><td colspan="7" bgcolor="EAEAEA"></td></tr>
	
	</cfif>
	
	</cfoutput>	
			
</table>

	
			