
<style>

	table.highLight {
		BACKGROUND-COLOR: #ffffcf;
		border-top : 1px solid silver;
		border-right : 1px solid silver;
		border-left : 1px solid silver;
		border-bottom : 1px solid silver;
	}
	table.regular {
		BACKGROUND-COLOR: #ffffff;
		border-top : 1px solid white;
		border-right : 1px solid white;
		border-left : 1px solid white;
		border-bottom : 1px solid white;
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
			 itm.style.cursor = "pointer";
			 self.status = name;
		 }else{
			 itm.className = "";		
			 itm.style.cursor = "";
			 self.status = name;
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

     <td width="50%" colspan="3" align="center">
	 	 	 
	 <cfset condition = FunctionCondition>
	 	 
	 <cfif FunctionPath neq "">
		   
     <table width="90%" align="center" 
	      bordercolor="FFFFFF" 
	      onClick="modulelog('#function.systemfunctionid#','#submissionedition#');loadform('#FunctionPath#','#condition#','#FunctionTarget#')" 
	      onMouseOver="hl(this,true,'#FunctionName#')" onMouseOut="hl(this,false,'')">
	  
	  <cfelse>
	  
	   <table width="90%" align="center" 
	      bordercolor="FFFFFF" 
	      onClick="modulelog('#function.systemfunctionid#','#submissionedition#');#ScriptName#('#mode#')" 
	      onMouseOver="hl(this,true,'#FunctionName#')" onMouseOut="hl(this,false,'')">
	  	  
	  </cfif>
	 	 	 	 
	    <tr>
	        <td width="40" rowspan="2" align="center">       
			  <cfinclude template="submenuImages.cfm">		
			</td>
			<td width="80%" style="padding-left:2px;height:23px;font-size:22px" class="labelmedium">#FunctionName#</td>   
        </tr>
				       
		<tr> 
	       <td width="80%" style="padding-left:20px;height:20px" class="labelit">#FunctionMemo#</td>
        </tr>	
		     
     </table>
	 	   
     </td>
		
     <cfif row eq "1"><cfelse></TR>
		
	 </cfif> 	

<cfelse>
 
     <tr><td height="4" colspan="6"></td></tr>
     <tr><td align="center" colspan="6" height="1">
	   
     <cfset condition = FunctionCondition>
	 	 
	 <cfif FunctionPath neq "">
		  
     <table width="95%" border="0" cellspacing="0" cellpadding="0" align="center" bordercolor="FFFFFF" style="padding:4px"
      onClick="modulelog('#systemfunctionid#','#submissionedition#');loadform('#FunctionPath#','#condition#','#FunctionTarget#')" 
      onMouseOver="hl(this,true,'#FunctionName#')" onMouseOut="hl(this,false,'')">
	  
	  <cfelse>
	  	  
	  <table width="95%" border="0" cellspacing="0" cellpadding="0" align="center" bordercolor="FFFFFF" style="padding:4px"       
	  onClick="modulelog('#systemfunctionid#','');#ScriptName#('#mode#')" 
      onMouseOver="hl(this,true,'#FunctionName#')" onMouseOut="hl(this,false,'')">
	  	  	  
	  </cfif>
     	 	   
     <td width="40" height="43" align="center" rowspan="2">	      
    	 <cfinclude template="submenuImages.cfm">    
     </td>
  
     <td width="47%"  style="padding-left:2px" class="labelmedium"><b>#FunctionName#</b></td>
     <td width="40%" align="right"></td>
	    
     </tr> 
  
     <tr> 
       <td colspan="6" style="padding-left:20px">#FunctionMemo#</td>
     </tr>
	 	    
     </table>
    
     </td></tr> 
	 <tr><td height="3" colspan="6"></td></tr>
	
</cfif>
  
</cfoutput>

