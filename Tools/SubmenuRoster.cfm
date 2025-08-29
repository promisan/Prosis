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
<style>

	table.highLight {
		BACKGROUND-COLOR: #ffffcf;
		border-top : 0px solid silver;
		border-right : 0px solid silver;
		border-left : 0px solid silver;
		border-bottom : 0px solid silver;
	}
	table.regular {
		BACKGROUND-COLOR: #ffffff;
		border-top : 0px solid white;
		border-right : 0px solid white;
		border-left : 0px solid white;
		border-bottom : 0px solid white;
	}
	
</style>

<cfoutput>

<input type="hidden" name="action" id="action" value="0">

<cfset rand = round(Rand()*100)>

<script language="JavaScript">
	
	ie = document.all?1:0
	ns4 = document.layers?1:0
	
	w = 0
	h = 0
	if (screen) {
		w = #CLIENT.width# - 60
		h = #CLIENT.height# - 140
	}
	
	function modulelog(id,mis) {
		 ptoken.navigate('#SESSION.root#/Tools/SubmenuLog.cfm?systemfunctionid='+id+'&mission='+mis,'modulelog')
	}	
	
	function hl(itm,fld,name){
			 
	     if (ie){
	          while (itm.tagName!="TABLE")
	          {itm=itm.parentElement;}
	     }else{
	          while (itm.tagName!="TABLE")
	          {itm=itm.parentNode;}
	     }		 
		 	 		 	
		 if (fld != false){
			 itm.className = "highLight";
		 }else{
			 itm.className = "";					
		 }
	  }
	    
	function loadform(name,cond,target) { 
	
	   act = document.getElementById("action")
	   act.value = act.value-0+1
	   if (cond == ""){
	      ptoken.open(name+"?time=#now()#&action="+act.value, target)
	   } else {
	      ptoken.open(name+"?"+cond+"&time=#now()#&action="+act.value, target); 
	   }		  
	 } 
	
</script>  

</cfoutput>
 
<cfparam name="class" default="'Main'">

<cfoutput>

<cfif MenuClass eq "Special">
	 
     <cfif row eq "1"><TR class="line"></cfif>

     <td width="50%" colspan="3" align="center" style="padding-left:20px">
	 	 	 
	 <cfset condition = FunctionCondition>
	 	 
	 <cfif FunctionPath neq "">
		   
     <table width="100%" 
	      onClick="modulelog('#function.systemfunctionid#','#submissionedition#');loadform('#FunctionPath#','#condition#','#FunctionTarget#')" 
	      onMouseOver="hl(this,true,'#FunctionName#')" onMouseOut="hl(this,false,'')">
	  
	  <cfelse>
	  
	   <table width="100%"
	      onClick="modulelog('#function.systemfunctionid#','#submissionedition#');#ScriptName#('#mode#')" 
	      onMouseOver="hl(this,true,'#FunctionName#')" onMouseOut="hl(this,false,'')">
	  	  
	  </cfif>
	 	 	 	 
	    <tr style="cursor:pointer" class="fixlengthlist">
	        <td style="min-width:50px" align="center">       
			  <cfinclude template="submenuImages.cfm">		
			</td>
			<td width="100%" style="padding-left:7px;font-size:16px" class="labelmedium">#FunctionName#</td>   
			<td style="font-size:12px;min-width:20%;padding-right:5px;padding-top:7px" align="right" valign="top">#FunctionMemo#</td>
			
        </tr>
				       
				     
     </table>
	 	   
     </td>
		
     <cfif row eq "1"><cfelse></TR></cfif> 	

<cfelse>
 
     <tr><td height="4" colspan="6"></td></tr>
     <tr><td colspan="6" height="1">
	   
     <cfset condition = FunctionCondition>
	 	 
	 <cfif FunctionPath neq "">
		  
     <table width="95%" border="0" bordercolor="FFFFFF" style="padding:4px"
      onClick="modulelog('#systemfunctionid#','#submissionedition#');loadform('#FunctionPath#','#condition#','#FunctionTarget#')" 
      onMouseOver="hl(this,true,'#FunctionName#')" onMouseOut="hl(this,false,'')">
	  
	  <cfelse>
	  	  
	  <table width="95%" border="0" bordercolor="FFFFFF" style="padding:4px"       
	  onClick="modulelog('#systemfunctionid#','');#ScriptName#('#mode#')" 
      onMouseOver="hl(this,true,'#FunctionName#')" onMouseOut="hl(this,false,'')">
	  	  	  
	  </cfif>
	  
	   <tr style="cursor:pointer" class="fixlengthlist">
     	 	   
     <td style="width:20px;" align="center">	      
    	 <cfinclude template="submenuImages.cfm">    
     </td>
  
     <td width="47%" style="padding-left:2px;height:23px;font-size:16px" class="labelmedium">#FunctionName#</td>
	 <td align="right" style="padding-right:10px">#FunctionMemo#</td>
    	    
     </tr> 
      	 	    
     </table>
    
     </td></tr> 
	 
	 <tr><td height="3" colspan="3"></td></tr>
	 
	
</cfif>
  
</cfoutput>

