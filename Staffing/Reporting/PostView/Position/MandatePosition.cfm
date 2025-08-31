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
	<proDes>Translated</proDes>
	<proCom></proCom>
</cfsilent>
<!--- End Prosis template framework --->

<cfinvoke component="Service.Presentation.Presentation" 
     method="highlight" 
	 returnvariable="stylescroll">
	 	 
 <cf_LanguageInput
	TableCode       = "Ref_ModuleControl" 
	Mode            = "get"
	Name            = "FunctionName"
	Key1Value       = "#url.idmenu#"
	Key2Value       = "#url.mission#"				
	Label           = "Yes">	
		 
<cf_screentop label="#url.mission# : #lt_content#" html="Yes" jquery="Yes" layout="Webapp" banner="gray" bannerForce="Yes">	 

<cf_ListingScript>
<cf_DialogStaffing>
<cf_Calendarscript>

<cfparam name="url.mandate" default="P001">
   
<!--- obtain a list of functions to be shown here --->

<cfinvoke component = "Service.Authorization.Function"  
  			 method           = "AuthorisedFunctions" 
			 mode             = "View"			 
			 mission          = "#url.mission#" 
			 orgunit          = ""
   			 Role             = ""
			 SystemModule     = "'Staffing'"
			 FunctionClass    = "'Inquiry'"
			 MenuClass        = "'Position'"
			 Except           = "''"
   			 Anonymous        = ""
			 returnvariable   = "listaccess">		 
				     

<cfif listaccess.recordcount eq "">

	<table width="98%" align="center">

		<tr>
		   <td align="center" class="labelmedium" style="font-size:16px;padding-top:40px"><font color="FF0000">You have no access to this function.<br>Please contact your administrator</td>
		</tr>
	
	</table>	

<cfelse>
      
	<cfoutput>
	
		<script language="JavaScript">
		
		function submenu(category,menusel,len) {
			
			 menucnt=1 	
			 len++ 	 	
			
		     while (menucnt != (len)) {
					
				  if (menucnt == menusel) {
				    document.getElementById(category+menucnt).className = "highlight"
				  } else {
				    document.getElementById(category+menucnt).className = "regular"
				  }		  
				  menucnt++	  	 
			 }
				
		 }
		
		 function position(sid) {
		      Prosis.busy('yes')
		      _cf_loadingtexthtml='';
			  ptoken.navigate('#SESSION.root#/Staffing/Reporting/PostView/Position/ViewMandate.cfm?systemfunctionid='+sid+'&mission=#url.mission#&mandate='+document.getElementById('mandateselect').value,'actionbox')		 
		 }	
		 
		 function postmanagement(sid) {		     
		      _cf_loadingtexthtml='';
			  ptoken.navigate('#SESSION.root#/Staffing/Reporting/PostView/Position/ViewManagement.cfm?systemfunctionid='+sid+'&mission=#url.mission#&mandate='+document.getElementById('mandateselect').value,'actionbox')		 
		 }			
		
		</script>
			
	<table width="100%" height="100%">
		 
	 <tr class="line">
	 	    
	      <td class="labellarge" style="background-color:f1f1f1;border-right:1px solid silver;padding-left:6px; width:5%; font-size:16px; height:35px; padding-top:1px; padding-right:5px">
		  <cf_tl id="Period">
		  </td>
	   
	        <cfquery name="MandateList" 
			datasource="AppsOrganization" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			    SELECT   *
			    FROM     Ref_Mandate
				WHERE    Mission = '#URL.Mission#' 
				AND      Operational = 1
				ORDER BY DateEffective
			</cfquery>
								
			<td style="width:10%;">
			
				<select name="mandateselect" id="mandateselect" style="border:0px;font-size:16px;height:26px;width:200px;" class="regularxl" onChange="reloadview(totals.value,snapshot.value,'operational',this.value)">
					<cfloop query="MandateList">
						<option value="#MandateNo#" <cfif MandateNo eq URL.Mandate>selected</cfif>>
							#MandateNo# [#DateFormat(DateExpiration, CLIENT.DateFormatShow)#]
						</option>						
					</cfloop>
				</select>
																		
			</td>
		  
	       <td style="padding-left:10px; width:90%;">
		   
			   <table cellspacing="0" cellpadding="0">
			   <tr>
			  		     
				   <cfloop query="listaccess"> 
					
						 <td name="actionlog#currentrow#" id="actionlog#currentrow#" style="padding-top3px" #stylescroll# 			  
							  onclick="submenu('actionlog','#currentrow#','#recordcount#');#scriptname#('#systemfunctionid#')">
							
							<table border="0" style="cursor:pointer">
					  		<tr>
							<td align="center" style="padding-left:8px;height:45px">
								<img src="#SESSION.root#/Images/Menu_brown.png" height="32" width="32">
							</td>						
							<td align="center" style="padding-left:8px;padding-right:10px;font-size:16px;border-right:1px solid ##cccccc;" class="labelmedium"><cf_uitooltip tooltip="#FunctionMemo#"><font color="000000">#FunctionName#</cf_uitooltip><td>
							</tr>				
				  		    </table>  
													
						 </td>	
					 
					</cfloop> 
					 		   
			   </tr>	   
			   </table>
	   
	      </td>		 	 
		  
	 </tr>
	 
	 </cfoutput>
	 	 
	 <tr>
	    <td height="100%" valign="top" colspan="3">
		<cfdiv style="width:100%;height:99%;padding-bottom:2px" id="actionbox"></td>
	 </tr>
					  
	</table>  
	
</cfif>	 
