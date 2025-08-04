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

<cfoutput>

	<cfparam name="own" default="">
	
	<cfif own eq "">
	  
		  <cfquery name="Account" 
		  datasource="AppsSystem" 
	      username="#SESSION.login#" 
	      password="#SESSION.dbpw#">
		  SELECT   *
		  FROM     UserNames
		  WHERE    Account = '#SESSION.acc#'
		 </cfquery>
		 
		 <cfset own = Account.AccountOwner>
		 
 	</cfif>
				
 <cfif own neq "">
 
 		<cfinvoke component = "Service.Process.Applicant.Vacancy"  
		   method           = "Candidacy" 
		   Owner            = "#own#"							   
		   PersonNo         = "#PersonNo#"	
		   Status           = ""   
		   returnvariable   = "Selection">	 
 	
	   		 
		 <cfparam name="col" default="11">
		
		 <cfif Selection.RecordCount gte "1">
		 		  	 
		    <tr>
			
			<cfif Selection.Status eq "Short-listed">
	           <cfset clr = "ffffff">
	        <cfelse>
			   <cfset clr = "ffffaf">   
			</cfif>
			<cfif Selection.Status eq "Return">
			   <!--- ???????????????????? --->
	           <cfset clr = "99fCCC">
			</cfif>
			  
			  <td></td>    
			  
			  <td height="18" colspan="#col-2#" align="left" style="padding:0px">
			 
			  <table width="100%" bgcolor="#clr#" style="border: 0px solid gray" class="formspacing">
			  
			  <tr class="labelmedium">
				  <td width="6%" align="center" style="padding-top:2px">
				  <cf_img icon="open" tooltip="Open Recruitment request" onClick="javascript:showdocumentcandidate('#Selection.DocumentNo#','#Selection.PersonNo#','#Selection.Status#')">
				  </td>
				  <td width="94%">
				  <cfif Selection.Status neq "Short-listed"></cfif>
				  <cfif Selection.Status eq "Selected">
				 	 <a href="javascript:showdocumentcandidate('#Selection.DocumentNo#','#Selection.PersonNo#','#Selection.Status#')"><font color="6688aa">
					   Candidate #Ucase(Selection.Status)# for #Selection.Mission# : #Selection.FunctionalTitle# <cfif Selection.ActionDate neq ""> on:  <font color="0080FF">#DateFormat(Selection.ActionDate,CLIENT.DateFormatShow)#</cfif>
					 </a>
				  <cfelseif Selection.Status eq "short-listed">
					 <a href="javascript:showdocumentcandidate('#Selection.DocumentNo#','#Selection.PersonNo#','#Selection.Status#')"><font color="6688aa">					 
				 	  Candidate #Ucase(Selection.Status)# for #Selection.Mission# : #Selection.FunctionalTitle# <cfif Selection.ActionDate neq ""> on:  <font color="0080FF">#DateFormat(Selection.ActionDate,CLIENT.DateFormatShow)#</cfif>
					  </a>
				  <cfelseif Selection.Status eq "Return">
				     <a href="javascript:showdocumentcandidate('#Selection.DocumentNo#','#Selection.PersonNo#','#Selection.Status#')"><font color="6688aa">					 
				 	  <cf_tl id="Candidate"> #Ucase(Selection.Status)#ed <cf_tl id="from Assignment"> <cfif Selection.ActionDate neq ""><cf_tl id="on">  <font color="0080FF">#DateFormat(Selection.ActionDate,CLIENT.DateFormatShow)#</cfif>
				     </a>
				  </cfif>
				  </td>
			  </tr>
			  </table>				 
			 
			</td></tr>			
			
		  </cfif> 
		 
		 <cfquery name="Offer" 
		  datasource="AppsVacancy" 
	      username="#SESSION.login#" 
	      password="#SESSION.dbpw#">
		  SELECT   *
		  FROM     stOffer
		  WHERE    PersonNo     = '#PersonNo#'
		  AND     OfferRejected = 1
		  ORDER BY EntryDate DESC
		 </cfquery>
		
		 <cfif Offer.RecordCount gte "1">
		 
		 	<tr><td height="2"></td></tr>
		    <tr class="labelmedium line">
			  <td></td>		      
			  <td height="18" colspan="#col-2#" align="left" bgcolor="FFcFcF" style="padding-left:5px;border: 1px solid d1d1d1;">
			
			   <img src="#SESSION.root#/Images/alert_stop.gif" alt="Open Recruitment request" name="img2_#personno#" 
			  onMouseOver="document.img2_#personno#.src='#SESSION.root#/Images/button.jpg'" 
			  onMouseOut="document.img2_#personno#.src='#SESSION.root#/Images/alert_stop.gif'"
			  style="cursor: pointer;" alt="" border="0" align="absmiddle" 
			  onClick="showdocumentcandidate('#Selection.DocumentNo#','#Selection.PersonNo#')">
			    &nbsp;&nbsp;
			  <a href="javascript:showdocumentcandidate('#Selection.DocumentNo#','#Selection.PersonNo#')">
			  <cf_tl id="Candidate has"> <b><cf_tl id="declined"></b> <cf_tl id="one or more offers">			  
			  </a>
			  </b>
			</td>
			</tr>
						
		 </cfif>
	 
	 </cfif>
		 
</cfoutput>			 