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
<cf_screentop height="100%" html="No" jquery="Yes">
 
<cfoutput>

<script>

ie = document.all?1:0
ns4 = document.layers?1:0

function hl(itm,fld,vis){

     if (ie){
          while (itm.tagName!="TR")
          {itm=itm.parentElement;}
     }else{
          while (itm.tagName!="TR")
          {itm=itm.parentNode;}
     }	 
	 vis2 = document.getElementsByName(vis)	 	 		 	
	 if (fld != false){		
    	 itm.className = "highlight line";	
	     vis2[0].className = "regularxl";		 
	 }else{		
         itm.className = "regular line";		
	     vis2[0].className = "hide";
	 }
  }
    
</script>	

</cfoutput>

<!--- record my clearances --->

<cfquery name="get" 
datasource="AppsSystem" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT    M.*, U.Status, U.Account, U.OrderListing
	FROM      Ref_ModuleControl M LEFT OUTER JOIN UserModule U ON  M.SystemFunctionId = U.SystemFunctionId
	    AND   U.Account = '#SESSION.acc#'
	WHERE     M.SystemModule = 'Portal' 
	 AND      M.Operational IN  ('1')
	 AND      M.MenuClass IN ('Topic','Widget') 
	 AND      FunctionClass != 'Portal'
	 AND      LastModified > '01/01/2010'
	ORDER BY  M.MenuClass, M.FunctionClass, M.MenuOrder
</cfquery>

<form action="PortalTopicsAddSubmit.cfm" method="post" name="result" style="height:100%">
 
	<table height="100%" width="95%" align="center" class="formpadding">
	
	<tr><td height="16"></td></tr>
	<tr>
	<td align="left" class="labellarge" style="font-size:28px;width:60px">
	<img src="<cfoutput>#SESSION.root#</cfoutput>/Images/blue_home.png" title="home" border="0" align="left" style="height:75px;float:left;padding-20px;">
	</td>
	<td class="Main-Title"><cf_tl id="Customize your home page"></td>
	<td class="Main-Sub-Title" style="padding-left:42px;top:67px;">
	   You may select and define the content once added that you need displayed on your Home Page. 
	</td>
	</tr>
	
	<tr>
	
	<td colspan="2" style="height:100%">
	
		<table width="100%" height="100%" align="center" class="navigation_table">
		
		<tr><td align="center" style="height:100%">
				
		<cf_divscroll>
				
			<table width="100%" align="center" style="padding-top:0px">
			   
			  <tr class="labelmedium2 fixrow">       
				   <td></td>
				   <td></td>
				   <td><cf_tl id="Description"></td>
				   <td><cf_tl id="Order"></td>
				   <td><cf_tl id="Published"></td>	  	  
			  </tr>
			  
			  <tr><td colspan="5" class="linedotted"></td></tr>
			   
			   <cfoutput group="MenuClass" query="get">
			   
			   <!---
			   <tr><td style="height:40px;padding-top:5px;padding-left:20px;padding-bottom:5px;font-size:30px" colspan="5" class="labellarge"><cfif MenuClass eq "Topic"><cf_tl id="Resource Summaries"><cfelse>Widget</cfif></td></tr>
			   --->
			   
			   <cfoutput group="FunctionClass">
			   
			   <tr><td style="height:40px;padding-top:5px;padding-left:20px;padding-bottom:5px;font-size:20px" colspan="5">
			   
			   <cfswitch expression="#FunctionClass#">
			      <cfcase value="HR"><cf_tl id="Human Resources"></cfcase>
				  <cfcase value="Program"><cf_tl id="Program Management"></cfcase>
				  <cfcase value="WorkOrder"><cf_tl id="Operations"></cfcase>
				  <cfcase value="User"><cf_tl id="Personal Productivity"></cfcase>
				  <cfdefaultcase>#FunctionClass#</cfdefaultcase>
			   </cfswitch>
			   </td></tr>
			  
			          
			   <cfoutput>
			      
			     <tr class="navigation_row labelmedium <cfif account neq "" and Status neq "">line</cfif>">
				 
			    	 <TD style="height:18px;padding-left:46px;padding:3px"></TD>	
					 <TD style="padding-left:20px">
					    <input type="hidden" name="controlno_#get.currentrow#" value="#SystemFunctionId#" size="2" maxlength="2" class="<cfif #Account# eq "">hide<cfelse>regular</cfif>" style="text-align: center;">
					    
						<input type="checkbox" 
						      style="height:17;width:17" 
							  name="select_#get.currentrow#" 
							  value="1" 
							  onClick="hl(this,this.checked,'listingorder_#get.currentrow#')"
				     	 <cfif account neq "" and Status neq "">checked</cfif>>
						 
			          </TD>
			         <TD style="padding-top:2px">
					 <table>
					    <tr class="labelmedium"><td style="color: black; font-size: 14px;">#FunctionName#:&nbsp;<font size="2" color="45617d">#FunctionMemo#</font></b></td></tr>				 
					 </table>	
					  <TD style="padding:0px">
					    <input type="text" name="listingorder_#get.currentrow#" value="#OrderListing#" size="2" maxlength="2" 
						 class="<cfif Account neq "" and Status neq "">regularxl<cfelse>hide</cfif>" 
						 style="text-align: center;border:0px;border-left:1px solid silver;border-right:1px solid silver">
					 </TD>	
					 <TD style="padding:0px">#dateformat(LastModified,client.dateformatshow)#</TD>
					
			        
			     </TR>
				 <input type="hidden" name="class_#get.currentrow#" value="#get.MenuClass#">
			
			   </cfoutput>	 
			   </cfoutput>	 	 
			   </cfoutput>
						
				<cfoutput>
				<input type="hidden" name="number" value="#get.recordcount#">
				</cfoutput>
			
			</TABLE>
		
		</cf_divscroll>
		
		</td></tr>
		
	</table>	
	
	</td>
	</tr>
		
	<tr>
	  <td colspan="5" height="37" align="center">
	   <input type="button" style="height:27;width:170;font-size:13px" name="Back" value="Back" class="button10g btn-ico-back" onClick="javascript:history.back()">
	   <input type="submit" style="height:27;width:170;font-size:13px" name="Add" value="Update" class="button10g">   
	  </td>
	</tr>
		
	</table>

</form>
