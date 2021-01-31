
 <cfoutput>

  <cfif FunctionIcon eq "Maintain">
         <img src="#SESSION.root#/Images/logos/system/settings.png" width="44" height="44" valign="absmiddle" alt="Global Preferences" border="0">
  <cfelseif FunctionIcon eq "Parameter">	
         <img src="#SESSION.root#/Images/logos/system/settings.png" align="absmiddle" alt="" width="44" height="44" border="0">
  <cfelseif TemplateSQL eq "Application">	
         <img src="#SESSION.root#/Images/logos/system/modules.png" width="44" height="44" align="absmiddle" alt="Open dataset"> 	 
  <cfelseif FunctionIcon eq "DataSet">	  
         <img src="#SESSION.root#/Images/logos/system/modules.png" height="44" align="absmiddle" alt="Open dataset"> 	 	 
  <cfelseif FunctionIcon eq "Flash">	
         <img src="#SESSION.root#/Images/logos/system/reports.png"  width="44" height="44" align="absmiddle" alt="Open report"> 	 
  <cfelseif FunctionIcon eq "PDF">	
         <img src="#SESSION.root#/Images/logos/system/reports.png" width="44" height="44" align="absmiddle" alt="Open report" alt="" border="0"> 
  <cfelseif FunctionIcon eq "Listing">	
         <img src="#SESSION.root#/Images/list.png" height="24" align="absmiddle" alt="Open report" alt="" border="0"> 		
  <cfelse>	
          <img src="#SESSION.root#/Images/logos/system/reports.png"  height="44" height="44" alt="" border="0">
  </cfif>
 
 </cfoutput>