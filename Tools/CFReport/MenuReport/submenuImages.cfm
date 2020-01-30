
 <cfoutput>

  <cfif FunctionIcon eq "Maintain">
         <img src="#SESSION.root#/Images/logos/Configuration.png" width="36" height="36" valign="absmiddle" alt="Global Preferences" border="0">
  <cfelseif FunctionIcon eq "Parameter">	
         <img src="#SESSION.root#/Images/detail.jpg" align="absmiddle" alt="" width="38" height="36" border="0">
  <cfelseif TemplateSQL eq "Application">	
         <img src="#SESSION.root#/Images/dataset2.png" width="36" height="36" align="absmiddle" alt="Open dataset"> 	 
  <cfelseif FunctionIcon eq "DataSet">	  
         <img src="#SESSION.root#/Images/dataset2.png" height="35" align="absmiddle" alt="Open dataset"> 	 	 
  <cfelseif FunctionIcon eq "Flash">	
         <img src="#SESSION.root#/Images/report_icon.png"  width="36" height="36" align="absmiddle" alt="Open report"> 	 
  <cfelseif FunctionIcon eq "PDF">	
         <img src="#SESSION.root#/Images/report_icon.png" width="36" height="36" align="absmiddle" alt="Open report" alt="" border="0"> 
  <cfelseif FunctionIcon eq "Listing">	
         <img src="#SESSION.root#/Images/list.png" height="24" align="absmiddle" alt="Open report" alt="" border="0"> 		
  <cfelse>	
          <img src="#SESSION.root#/Images/report_icon.png"  height="40" alt="" border="0">
  </cfif>
 
 </cfoutput>