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
<cfparam name="cnt"        default="1">
<cfparam name="row"        default="1">
<cfparam name="AccessLvl"  default="">
<cfparam name="ActionType" default="">

<cfoutput>

<table style="padding:0px">

  <tr style="height:25px">  	   
	    <input type   = "hidden" 
	          name    = "#ms#_AccessLevel_old_#CurrentRow#" 
			  id      = "#ms#_AccessLevel_old_#CurrentRow#"
			  value   = "#AccessLevel#">  	
		  	  
   <td align="center" style="border:1px solid gray;width:30px;background-color:ffffff" id="d#ms#_#CurrentRow#I"> 
   
	   <table style="padding:0px">
	   <tr>
		   <td style="background-color:ffffff;padding:0px;padding-bottom:0px" title="No access">
		   		   
		 	    <input type   = "radio" 
			          name    = "#ms#_AccessLevel_#CurrentRow#" 
					  id      = "n#url.mission##row#_#cnt#"
					  value   = ""  					 	  
					   <cfif AccessLvl eq "">checked</cfif> 
					  onClick = "ClearRow('d#ms#_#CurrentRow#','I')">   
							 
			</td>
		</tr>
		</table>  	       
		  
   </td>   
    
          
	   <cfif actiontype neq "Create">	   
	   
	    <td align="center" id="d#ms#_#CurrentRow#0" style="width:30px;padding:0px;border:1px solid gray;background-color:c0c0c0">
		
		 <table style="padding:0px">
		 <tr><td style="background-color:c0c0c0;padding-bottom:2px" title="User may only access this step but is not allowed to forward it or move it otherwise">
	   	    
		 <input type  = "radio" 
		      name    = "#ms#_AccessLevel_#CurrentRow#"
			  id      = "#ms#_AccessLevel_#CurrentRow#" 			  
			  value   = "0" 			  	  		  
			  onClick = "ClearRow('d#ms#_#CurrentRow#','0')" <cfif AccessLvl eq "0">checked</cfif>>
		
		 
		 </td></tr>
		 </table>  
			  
     	</td>	
			   
	   <cfelse>
	   
	    <td style="width:43px;padding-left:9px;padding-right:2px;background-color:silver" id="d#ms#_#CurrentRow#0"></td>	  
		 
	   </cfif>   
	    
   <td align="center" style="border:1px solid gray;width:30px;background-color:80FF00" id="d#ms#_#CurrentRow#1">  
      
	    <table style="padding:0px">
		<tr><td style="background-color:80FF00;padding-bottom:2px;height:100%;" title="Common access to process and forward the step">
	      
   		<input type    = "radio" 
			   name    = "#ms#_AccessLevel_#CurrentRow#" 
			   id      = "g#url.mission##row#_#cnt#"
			   value   = "1" 			   			   
			   <cfif AccessLvl eq "1">checked</cfif>
			   onClick = "ClearRow('d#ms#_#CurrentRow#','1')">
			
		</td></tr>
		</table>  
			   			   
   </td>      
        
   <td align="center" style="height:100%;padding:0px;border:1px solid gray;width:30px;background-color:0080FF" id="d#ms#_#CurrentRow#2">  
    
	    <table><tr><td style="background-color:0080FF;padding-bottom:2px;" title="Special Access to be used in context">
	      
    		<input type    = "radio" 
			   name    = "#ms#_AccessLevel_#CurrentRow#" 
			   id      = "g#url.mission##row#_#cnt#"
			   value   = "2" 			    
			   <cfif AccessLvl eq "2">checked</cfif>
			   onClick = "ClearRow('d#ms#_#CurrentRow#','2')">
				
		 </td></tr></table>  	
	  
   </td>  
    
   
     
   </tr>
</table>
   
</cfoutput>	   