
<cfparam name="cnt"        default="1">
<cfparam name="row"        default="1">
<cfparam name="AccessLvl"  default="">
<cfparam name="ActionType" default="">

<cfoutput>

<table cellspacing="0" cellpadding="0" class="formspacing">

  <tr>  	   
	    <input type   = "hidden" 
	          name    = "#ms#_AccessLevel_old_#CurrentRow#" 
			  id      = "#ms#_AccessLevel_old_#CurrentRow#"
			  value   = "#AccessLevel#">  	
		  	  
   <td style="padding-left:6px;padding-right:2px" id="d#ms#_#CurrentRow#I"> 
   
 	    <input type   = "radio" 
	          name    = "#ms#_AccessLevel_#CurrentRow#" 
			  id      = "n#url.mission##row#_#cnt#"
			  value   = ""  
			  style   = "height:14px;width:14px"		
			   <cfif AccessLvl eq "">checked</cfif> 
			  onClick = "ClearRow('d#ms#_#CurrentRow#','I')">        
		  
   </td>   
   <td style="padding-left:0px" class="labelsmall"> 
   
   	   <cfif AccessLvl eq ""><b><font color="0080FF"></cfif>
	   <img src="#session.root#/images/posting_cancel.gif" alt="" border="0">
	   <!--- <cfif AccessList.Number gt "1">Deny<cfelse>Disabled</cfif> --->
	   
   </td>  
              
  
	   
	   <cfif actiontype neq "Create">	   
	   
	    <td style="padding-left:9px;padding-right:2px" id="d#ms#_#CurrentRow#0">
	   
		 <input type  = "radio" 
		      name    = "#ms#_AccessLevel_#CurrentRow#"
			  id      = "#ms#_AccessLevel_#CurrentRow#" 
			  value   = "0" 
			  style   = "height:14px;width:14px"			  
			  onClick = "ClearRow('d#ms#_#CurrentRow#','0')" <cfif AccessLvl eq "0">checked</cfif>>
			  
     	</td>		
		<td style="padding-left:0px" class="labelsmall"> 			
		   <cfif AccessLvl eq "0"><font color="0080FF"></cfif>
		   <img src="#session.root#/images/posting_open.gif" alt="Assist" border="0">
		   <!--- <cfif AccessList.Number gt "1">Assist<cfelse>Assist</cfif>	   --->
		   
	   </td>
	   
	   <cfelse>
	   
	    <td style="width:43px;padding-left:9px;padding-right:2px" id="d#ms#_#CurrentRow#0">
		</td>	  
		 
	   </cfif>   
	    
   <td style="padding-left:9px;padding-right:2px" id="d#ms#_#CurrentRow#1">   
   
   		<input type    = "radio" 
			   name    = "#ms#_AccessLevel_#CurrentRow#" 
			   id      = "g#url.mission##row#_#cnt#"
			   value   = "1" 
			   style   = "height:14px;width:14px"		
			   <cfif AccessLvl eq "1">checked</cfif>
			   onClick = "ClearRow('d#ms#_#CurrentRow#','1')">
			   			   
   </td>   
   <td style="padding-left:0px;padding-right:2px" class="labelsmall"><cfif AccessLvl eq "1"><font color="0080FF"></cfif>
   <img src="#session.root#/images/posting_done.gif" alt="Process" border="0">
   <!---Process---></td>   
   <td width="1" id="d#ms#_#CurrentRow#2">   
	
	   <input type    = "hidden" 
	          name    = "#ms#_AccessLevel_#CurrentRow#" 
			  id      = "#ms#_AccessLevel_#CurrentRow#"
			  value   = "" 
			  onClick = "ClearRow('d#ms#_#CurrentRow#','2')">			  
   </td>  	
   </tr>
</table>
   
</cfoutput>	   