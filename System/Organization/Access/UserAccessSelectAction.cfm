
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
   
   <!---
   <td style="padding-left:0px" class="labelsmall"> 
   
   	   <cfif AccessLvl eq ""><b><font color="0080FF"></cfif>
	   <img src="#session.root#/images/posting_cancel.gif" alt="" border="0">
	   <!--- <cfif AccessList.Number gt "1">Deny<cfelse>Disabled</cfif> --->
	   
   </td>
   --->  
   
          
	   <cfif actiontype neq "Create">	   
	   
	    <td align="center" id="d#ms#_#CurrentRow#0" style="width:30px;padding:0px;border:1px solid gray;background-color:c0c0c0">
		
		 <table style="padding:0px"><tr><td style="background-color:c0c0c0;padding-bottom:2px" title="User may only access this step but is not allowed to forward it or move it otherwise">
	   	    
		 <input type  = "radio" 
		      name    = "#ms#_AccessLevel_#CurrentRow#"
			  id      = "#ms#_AccessLevel_#CurrentRow#" 			  
			  value   = "0" 			  	  		  
			  onClick = "ClearRow('d#ms#_#CurrentRow#','0')" <cfif AccessLvl eq "0">checked</cfif>>
		
		 
		 </td></tr></table>  
			  
     	</td>	
		
		<!---	
		<td style="padding-left:0px" class="labelsmall"> 			
		   <cfif AccessLvl eq "0"><font color="0080FF"></cfif>
		   <cf_uiTooltip tooltip="User may only access this step but is not allowed to forward it or move it otherwise">
		   <img src="#session.root#/images/posting_open.gif" border="0">
		   </cf_uiTooltip>
		   <!--- <cfif AccessList.Number gt "1">Assist<cfelse>Assist</cfif>	   --->
		   
	   </td>
	   --->
	   
	   <cfelse>
	   
	    <td style="width:43px;padding-left:9px;padding-right:2px;background-color:silver" id="d#ms#_#CurrentRow#0"></td>	  
		 
	   </cfif>   
	    
   <td align="center" style="border:1px solid gray;width:30px;background-color:80FF00" id="d#ms#_#CurrentRow#1">  
      
	    <table style="padding:0px"><tr><td style="background-color:80FF00;padding-bottom:2px;height:100%;" title="No access">
	      
   		<input type    = "radio" 
			   name    = "#ms#_AccessLevel_#CurrentRow#" 
			   id      = "g#url.mission##row#_#cnt#"
			   value   = "1" 			   			   
			   <cfif AccessLvl eq "1">checked</cfif>
			   onClick = "ClearRow('d#ms#_#CurrentRow#','1')">
			
		 </td></tr></table>  
			   			   
   </td> 
   
   <!---  
   <td style="padding-left:0px;padding-right:2px" class="labelsmall"><cfif AccessLvl eq "1"><font color="0080FF"></cfif>
   <cf_uiTooltip tooltip="User may both access this AND is allowed to forward it">
   <img src="#session.root#/images/posting_done.gif" alt="Process" border="0">
   </cf_uiTooltip>
   <!---Process---></td>   
   
   --->
   
        
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
   
   <!---
   
    <td style="padding-left:0px;padding-right:2px" class="labelsmall"><cfif AccessLvl eq "2"><font color="0080FF"></cfif>
   <cf_uiTooltip tooltip="Special access to be used in flow">
   <img src="#session.root#/images/posting_done.gif" alt="Process" border="0">
   </cf_uiTooltip>
   <!---Process---></td>   
   
   --->
   
   </tr>
</table>
   
</cfoutput>	   