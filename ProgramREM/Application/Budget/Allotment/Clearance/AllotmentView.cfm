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
    
 <cfquery name="Period" 
  datasource="AppsProgram" 
  username="#SESSION.login#" 
  password="#SESSION.dbpw#">
	  SELECT     *
	  FROM       Ref_Period
	  WHERE      Period = '#URL.Period#'	   
 </cfquery>
 
<cfquery name="Edit" 
  datasource="AppsProgram" 
  username="#SESSION.login#" 
  password="#SESSION.dbpw#">
	  SELECT     *
	  FROM       Ref_AllotmentEdition
	  WHERE      EditionId = '#URL.Edition#'	   
</cfquery>

<cfquery name="Param" 
  datasource="AppsProgram" 
  username="#SESSION.login#" 
  password="#SESSION.dbpw#">
	  SELECT     *
	  FROM       Ref_ParameterMission
	  WHERE      Mission = '#Edit.Mission#'	   
</cfquery>
   
<!--- we first re-evaluate the allotment details + support costs --->
      
<cfoutput>

<cfajaximport tags="cfdiv">
<cf_dialogorganization>

<script language="JavaScript1.2">		
							
		function donordrill(traid) {			
						
			try { ColdFusion.Window.destroy('mydialog',true) } catch(e) {}
			ColdFusion.Window.create('mydialog', 'Donor allocation', '',{x:100,y:100,height:document.body.clientHeight-30,width:document.body.clientWidth-30,modal:true,resizable:false,center:true})    							
			ColdFusion.navigate('#SESSION.root#/ProgramREM/Application/Budget/Allotment/Clearance/DonorAllocation.cfm?transactionid=' + traid,'mydialog') 				
			
		}  	
		
		function donordrillrefresh(ret,traid) {
		
			if (ret == 1) {		
			   // refresh 				 
			   document.getElementById('Decision_'+traid+'_0').click()			   			  		   	   
			   ColdFusion.navigate('DonorAllocationViewLines.cfm?datamode=limited&transactionid='+traid,'donor_'+traid)		
			} else {   			  	
			   ColdFusion.navigate('AllotmentViewContent.cfm?mode=contribution&program=#url.Program#&period=#url.Period#&edition=#url.Edition#','content')
			}   
		
		}				
		
		function donordetail(box) {
		
		    se = document.getElementById(box) 
		   
		    if (se.className == "regular") {
			   se.className = "hide" 
			} else { 
			  se.className = "regular"
			}		 		 
		}				
		
		function setthisorgunit(id,val,box) {
		   Prosis.busy('yes')
		   _cf_loadingtexthtml='';			  
		   ColdFusion.navigate('setOrgUnit.cfm?transactionid='+id+'&orgunit='+val,box)		
		}
	
	
	</script>
	
</cfoutput>

<cf_DialogREMProgram>
<cf_ActionListingScript>
<cf_FileLibraryScript>

<cfset No = 0>

<cf_screentop height="100%" layout="webapp" line="no" 
	systemmodule="Budget" 
    functionclass="Window" 
	functionName="Allotment Submission" 
    banner="gray" label="#Edit.Period# #Edit.Description#" jQuery="Yes" scroll="yes" html="Yes">
	
	
<cfajaximport tags="cfwindow">	

<table width="100%" height="100%" cellspacing="0" cellpadding="0">

<tr>
	<td id="main" width="100%" height="100%" valign="top" style="padding:10px;padding-top:16px">
							
		<cfform method="post" name="clear" style="height:100%">
		
			<table width="100%" style="height:100%">
					
				<tr><td style="height:100%;padding-left:15px;padding-right:15px">				   
				  
				    <cf_divscroll id="content">
					<cfinclude template="AllotmentViewContent.cfm">					
					</cf_divscroll>
					
				</td></tr>
										
				<tr>
			
				<td align="center" height="40" style="padding-left:10px;padding-right:10px;padding-top:4px" id="submitbox" class="hide">
				
			     <cfinclude template="AllotmentSubmission.cfm">    
				 
				</td>
				
				</tr>
			
				<tr class="hide"><td id="processbox"></td></tr>					
			
			</table>
			
			<cfoutput>
			   <input type="hidden" name="Mission" id="Mission" value="#Edit.Mission#">
			   <input type="hidden" name="Program" id="Program" value="#URL.Program#">
			   <input type="hidden" name="Period" id="Period"   value="#URL.Period#">
			   <input type="Hidden" name="Edition" id="Edition" value="#URL.Edition#"> 
			</cfoutput>   
		
		</cfform>
			
	</td>
</tr>
</table>
			


